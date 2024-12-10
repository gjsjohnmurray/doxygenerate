Class gjsjohnmurray.doxygenerate.Utils Extends %RegisteredObject
{

/// Build the metadata files for this database
ClassMethod BuildMetadata(namespace As %String = {$namespace}) As %Status
{
    Return ##class(%Atelier.v1.Utils.MetaData).Build(..DatabaseName(namespace))
}

/// Generate the .py simulacrum files under the src folder of the metadata path
ClassMethod GenerateFiles(namespace As %String = {$namespace}) As %Status
{
    Set sc = $$$OK
    Set pyIndent="    "
    Set inDir=..MetadataPath(namespace)
    Set outDir=##class(%File).SubDirectoryName(inDir,"src")
    If ##Class(%File).DirectoryExists(outDir) {
        If '##class(%File).RemoveDirectoryTree(outDir) {
            Quit $$$ERROR($$$GeneralError,"Failed To remove existing directory tree: "_outDir)
        }
    }
    If '##class(%File).CreateDirectoryChain(outDir) {
        Quit $$$ERROR($$$GeneralError,"Failed To create directory: "_outDir)
    }
    Set doxyDir=##class(%File).SubDirectoryName(inDir,"doxygen")
    If '##class(%File).CreateDirectoryChain(doxyDir) {
        Quit $$$ERROR($$$GeneralError,"Failed To create directory: "_doxyDir)
    }
    set doxyFile=doxyDir_"/Doxyfile"
    if '##class(%File).Exists(doxyFile) {
        set oFile=##class(%File).%New(doxyFile)
        if oFile="" {
            quit $$$ERROR($$$GeneralError,"Failed To create file: "_doxyFile)
        }
        set sc=oFile.Open("WNS")
        if $$$ISERR(sc) {
            quit $$$ERROR($$$GeneralError,"Failed To open file: "_doxyFile)
        }
        for {
            set sc=oFile.WriteLine("PROJECT_NAME           = "_$system_":"_..DatabaseName(namespace)) quit:sc'=$$$OK
            set sc=oFile.WriteLine("OPTIMIZE_OUTPUT_JAVA   = YES") quit:sc'=$$$OK
            set sc=oFile.WriteLine("EXTRACT_PRIVATE        = YES") quit:sc'=$$$OK
            set sc=oFile.WriteLine("EXTRACT_STATIC         = YES") quit:sc'=$$$OK
            set sc=oFile.WriteLine("HIDE_UNDOC_MEMBERS     = YES") quit:sc'=$$$OK
            set sc=oFile.WriteLine("HIDE_SCOPE_NAMES       = YES") quit:sc'=$$$OK
            set sc=oFile.WriteLine("SORT_MEMBER_DOCS       = NO") quit:sc'=$$$OK
            set sc=oFile.WriteLine("SHOW_USED_FILES        = NO") quit:sc'=$$$OK
            set sc=oFile.WriteLine("SHOW_FILES             = NO") quit:sc'=$$$OK
            set sc=oFile.WriteLine("WARN_IF_UNDOCUMENTED   = NO") quit:sc'=$$$OK
            set sc=oFile.WriteLine("INPUT                  = ../src") quit:sc'=$$$OK
            set sc=oFile.WriteLine("RECURSIVE              = YES") quit:sc'=$$$OK
            set sc=oFile.WriteLine("DISABLE_INDEX          = YES") quit:sc'=$$$OK
            set sc=oFile.WriteLine("GENERATE_TREEVIEW      = YES") quit:sc'=$$$OK
            set sc=oFile.WriteLine("GENERATE_LATEX         = NO") quit:sc'=$$$OK
            quit
        }
        d oFile.Close()
        if $$$ISERR(sc) {
            quit $$$ERROR($$$GeneralError,"Failed To write to file: "_doxyFile)
        }
    }

    // Iterate through the .cls files in the metadata path
    set rs=##class(%ResultSet).%New("%Library.File:FileSet")
    Set sc=rs.Execute(inDir,"*.cls")
    If $$$ISERR(sc) Return sc
    Set (currentPackage,oFile)=""
    Set isFirst=1
    While (rs.%Next()) {
        // From inFileName=p1.p2.c.cls derive outFileDir=outDir/p1/p2 and outFile=outFileDir/c.py
        Set inFile=rs.%Get("Name")
        Set inFileName=rs.%Get("ItemName")
        Set unqualifiedClassname=$p(inFileName,".",*-1)

        // Read and parse JSON from inFile
        Set obj=##class(%DynamicObject).%FromJSONFile(inFile)
        If obj="" {
            Set sc=$system.Status.AppendStatus(sc, $system.Status.Error(5001,"Failed to parse JSON from "_inFile))
            Continue
        }
        // Verify that name property matches inFile
        if obj.name'=inFileName {
            w "Mismatch between name property and file name: ",inFileName,!
            Set sc=$system.Status.AppendStatus(sc, $system.Status.Error(5001,"Mismatch between name property and file name: "_inFileName))
            Continue
        }
        // Get the content object
        set oContent=obj.content
        if oContent="" {
            Set sc=$system.Status.AppendStatus(sc, $system.Status.Error(5001,"No content property in "_inFile))
            Continue
        }
        if oContent.hidden,(","_$Roles_",")'[",ISC_Internal," {
            Continue
        }

        // Write Python simulacrum into outFile

        Set thisPackage=..P2U($p(inFileName,".",1,*-2))

        // Class is in a different package
        if (thisPackage'=currentPackage) {
            if oFile'="" {
                d oFile.Close()
            }
            Set currentPackage=thisPackage
            Set outFileDir=outDir_"/"_$tr($p(thisPackage,".",1,*-1),".","/")
            Set outFile=outFileDir_"/"_$p(thisPackage,".",*)_".py"
            set sc2=##class(%File).CreateDirectoryChain(outFileDir)
            if $$$ISERR(sc2) {
                Set sc=$system.Status.AppendStatus(sc, $system.Status.Error(5001,"Failed to create directory: "_outFileDir))
                Continue
            }

            if $l(thisPackage,".")>1 {
                // Create all required intermediate stub __init__.py files that are not already present
                set initpyDir=outFileDir
                set todo=$l(thisPackage,".")-1
                while todo > 0 {
                    set filename=initpyDir_"/__init__.py"
                    if '##class(%File).Exists(filename) {
                        set oFile=##class(%File).%New(filename)
                        if oFile="" {
                            Set sc=$system.Status.AppendStatus(sc, $system.Status.Error(5001,"Failed to create __init__.py file for "_outFile))
                            Continue
                        }
                        set sc2=oFile.Open("WNS")
                        if $$$ISERR(sc2) {
                            Set sc=$system.Status.AppendStatus(sc, $system.Status.Error(5001,"Failed to open "_filename))
                            Continue
                        }
                        set sc2=oFile.WriteLine("")
                        d oFile.Close()
                        if $$$ISERR(sc2) {
                            Set sc=$system.Status.AppendStatus(sc, $system.Status.Error(5001,"Failed to write to file "_filename))
                            Continue
                        }
                    }
                    set todo=todo-1
                    set initpyDir=$p(initpyDir,"/",1,*-1)
                }
            }

            // Open module file
            set oFile=##class(%File).%New(outFile)
            if oFile="" {
                Set sc=$system.Status.AppendStatus(sc, $system.Status.Error(5001,"Failed to create %File object for "_outFile))
                Continue
            }
            set isNewModule='##class(%File).Exists(outFile)
            set sc2=oFile.Open("WS"_$s(isNewModule:"N",1:"A"))
            if $$$ISERR(sc2) {
                Set sc=$system.Status.AppendStatus(sc, $system.Status.Error(5001,"Failed to open "_outFile))
                Continue
            }

            // Module description if new file
            if isNewModule {
                set sc2=oFile.WriteLine("'''! Documentation for the "_thisPackage_" package'''")
                if $$$ISERR(sc2) {
                    Set sc=$system.Status.AppendStatus(sc, $system.Status.Error(5001,"Failed to write header to "_outFile))
                    Continue
                }
            }
        }

        // Add the mainpage doc to the first file
        if isFirst {
            kill lines
            set lines=0
            set lines($i(lines))="##"
            set lines($i(lines))="# @mainpage Docs for "_..DatabaseName(namespace)_" database"
            set lines($i(lines))="#"
            set lines($i(lines))="# @section description_main Description"
            set lines($i(lines))="# Generated by Doxygen.Utils.GenerateFiles("_$s(namespace'=$namespace:""""_namespace_"""", 1:"")_") in namespace "_$namespace_" on server "_$system
            set lines($i(lines))="# ("_$zv_")."
            set lines($i(lines))="#"
            set sc=$$$OK
            for i=1:1:lines {
                set sc2=oFile.WriteLine(lines(i))
                if $$$ISERR(sc2) {
                    Set sc=$system.Status.AppendStatus(sc, $system.Status.Error(5001,"Failed to write mainpage lines to file "_outFile))
                    set i=lines
                }
            }
            if (sc2'=$$$OK) {
                Continue
            }
            s isFirst=0
        }
        
        set strSuperclasses=""
        set iter=oContent.super.%GetIterator()
        while iter.%GetNext(.key,.value) {
            set strSuperclasses=strSuperclasses_","_..P2U(value)
        }
        set $e(strSuperclasses,1)=""

        set sc2=oFile.WriteLine("class "_unqualifiedClassname_"("_strSuperclasses_"):")
        if $$$ISERR(sc2) {
            Set sc=$system.Status.AppendStatus(sc, $system.Status.Error(5001,"Failed to write class header to file "_outFile))
            Continue
        }

        set sc2=oFile.Write(pyIndent_"'''! ")
        if $$$ISERR(sc2) {
            Set sc=$system.Status.AppendStatus(sc, $system.Status.Error(5001,"Failed to write docstring start to file "_outFile))
            Continue
        }

        set descIndent=""
        set iter=oContent.desc.%GetIterator()
        set sc2=$$$OK
        while iter.%GetNext(.key,.value) && (sc2=$$$OK) {
            set sc2=oFile.WriteLine(descIndent_value)
            if $$$ISERR(sc2) {
                Set sc=$system.Status.AppendStatus(sc, $system.Status.Error(5001,"Failed to write desc to file "_outFile))
                Continue
            }
            set descIndent=pyIndent
        }
        if (sc2'=$$$OK) {
            Continue
        }

        if descIndent="" {
            set sc2=oFile.WriteLine("")
            if $$$ISERR(sc2) {
                Set sc=$system.Status.AppendStatus(sc, $system.Status.Error(5001,"Failed to write EOL to file "_outFile))
                Continue
            }
        }
        set sc2=oFile.WriteLine(pyIndent_"'''")
        if $$$ISERR(sc2) {
            Set sc=$system.Status.AppendStatus(sc, $system.Status.Error(5001,"Failed to write docstring end to file "_outFile))
            Continue
        }

        // Parameters
        set iter=oContent.parameters.%GetIterator()
        set sc2=$$$OK
        kill lines
        set lines=0
        while iter.%GetNext(.key,.oParameter) && (sc2=$$$OK) {
            if oParameter.internal,(","_$Roles_",")'[",ISC_Internal," {
                Continue
            }
            set name=..P2U(oParameter.name)
            set lines($i(lines))="## @var "_name
            if oParameter.depr {
                set lines($i(lines))="## @deprecated"
                set lines($i(lines))="##" // TODO - check history and show when it became deprecated
            }
            if oParameter.internal {
                set lines($i(lines))="## @qualifier internal"
            }
            set iter2=oParameter.desc.%GetIterator()
            if iter2.%GetNext(.key2,.value) {
                set lines($i(lines))="## @brief "_value
                set lines($i(lines))="##"
                while iter2.%GetNext(.key2,.value) {
                    set lines($i(lines))="## "_value
                }
            }
            set lines($i(lines))=name_" = None"
        }
        if lines>0 {
            for i=1:1:lines {
                set sc2=oFile.WriteLine(pyIndent_lines(i))
                if $$$ISERR(sc2) {
                    Set sc=$system.Status.AppendStatus(sc, $system.Status.Error(5001,"Failed to write parameter lines to file "_outFile))
                    set i=lines
                }
            }
            if (sc2'=$$$OK) {
                Continue
            }
        }

        // Methods
        set iter=oContent.methods.%GetIterator()
        set sc2=$$$OK
        while iter.%GetNext(.key,.oMethod) && (sc2=$$$OK) {
            if oMethod.internal,(","_$Roles_",")'[",ISC_Internal," {
                Continue
            }
            set name=..P2U(oMethod.name)
            if (oMethod.private) {
                set name="__"_name
            }
            set value=""
            if oMethod.scope="class" {
                set sc2=oFile.WriteLine(pyIndent_"@staticmethod")
                if $$$ISERR(sc2) {
                    Set sc=$system.Status.AppendStatus(sc, $system.Status.Error(5001,"Failed to write class method decorator to file "_outFile))
                    Continue
                }
            }
            set iter2=oMethod.args.%GetIterator()
            while iter2.%GetNext(.key,.oArg) {
                set argName = ..P2U(oArg.name)
                set argType = ..P2U(oArg.type)
                set value=value_", "_argName_": "_argType
            }
            set $e(value,1)=""

            set returntype=..P2U(oMethod.returntype)
            set value="def "_name_"("_value_") -> "_returntype_" :"
            set sc2=oFile.WriteLine(pyIndent_value)
            if $$$ISERR(sc2) {
                Set sc=$system.Status.AppendStatus(sc, $system.Status.Error(5001,"Failed to write method to file "_outFile))
                Continue
            }

            set sc2=oFile.Write(pyIndent_pyIndent_"'''! ")
            if $$$ISERR(sc2) {
                Set sc=$system.Status.AppendStatus(sc, $system.Status.Error(5001,"Failed to write method docstring start to file "_outFile))
                Continue
            }

            set descIndent=""
            set iter2=oMethod.desc.%GetIterator()
            set sc2=$$$OK
            while iter2.%GetNext(.key,.value) && (sc2=$$$OK) {
                set sc2=oFile.WriteLine(descIndent_value)
                if $$$ISERR(sc2) {
                    Set sc=$system.Status.AppendStatus(sc, $system.Status.Error(5001,"Failed to write method desc to file "_outFile))
                    Continue
                }
                if descIndent="" {
                    // Separate brief from details
                    set sc2=oFile.WriteLine("")
                }
                set descIndent=pyIndent_pyIndent
            }
            if (sc2'=$$$OK) {
                Continue
            }

            if descIndent="" {
                set sc2=oFile.WriteLine("")
                if $$$ISERR(sc2) {
                    Set sc=$system.Status.AppendStatus(sc, $system.Status.Error(5001,"Failed to write method EOL to file "_outFile))
                    Continue
                }
            }
            set sc2=oFile.WriteLine(pyIndent_pyIndent_"&nbsp;")
            if $$$ISERR(sc2) {
                Set sc=$system.Status.AppendStatus(sc, $system.Status.Error(5001,"Failed to write method docstring trailing nbsp to file "_outFile))
                Continue
            }
            set sc2=oFile.WriteLine(pyIndent_pyIndent_"'''")
            if $$$ISERR(sc2) {
                Set sc=$system.Status.AppendStatus(sc, $system.Status.Error(5001,"Failed to write method docstring end to file "_outFile))
                Continue
            }
        }
        if (sc2'=$$$OK) {
            Continue
        }

        // Properties
        set iter=oContent.properties.%GetIterator()
        set sc2=$$$OK
        kill lines
        set lines=0
        while iter.%GetNext(.key,.oProperty) && (sc2=$$$OK) {
            if oProperty.internal,(","_$Roles_",")'[",ISC_Internal," {
                Continue
            }
            set name=..P2U(oProperty.name)
            if (oProperty.private) {
                // Unfortunately the presence/absence of a "__" prefix overrides any @private decoration, so we have to add the prefix
                set name="__"_name
            }
            set lines($i(lines))="## @var "_name
            if oProperty.depr {
                set lines($i(lines))="## @deprecated"
                set lines($i(lines))="##" // TODO - check history and show when it became deprecated
            }
            if oProperty.final {
                set lines($i(lines))="## @qualifier final"
            }
            if oProperty.internal {
                set lines($i(lines))="## @qualifier internal"
            }

            set linesBeforeDesc=lines
            set iter2=oProperty.desc.%GetIterator()
            if iter2.%GetNext(.key2,.value) {
                set lines($i(lines))="## @brief "_value
                set lines($i(lines))="##"
                while iter2.%GetNext(.key2,.value) {
                    set lines($i(lines))="## "_value
                }
                // Ensure we get a details section even if only one description line
                set lines($i(lines))="## &nbsp;"
            }
            if lines=linesBeforeDesc {
                // Ensure it shows up despite having no documentation.
                // We use EXTRACT_ALL=NO in conjunction with HIDE_UNDOC_MEMBERS=YES in order to suppess our __init__ stub
                set lines($i(lines))="## @brief &nbsp;"
                set lines($i(lines))="##"
                set lines($i(lines))="## &nbsp;"
            }
            set lines($i(lines))="self."_name_" = "_..P2U(oProperty.type)_"()"
        }
        if lines>0 {
            set sc2=oFile.WriteLine(pyIndent_"def __init__(self):")
            if $$$ISERR(sc2) {
                Set sc=$system.Status.AppendStatus(sc, $system.Status.Error(5001,"Failed to write __init__ header to file "_outFile))
                Continue
            }
            for i=1:1:lines {
                set sc2=oFile.WriteLine(pyIndent_pyIndent_lines(i))
                if $$$ISERR(sc2) {
                    Set sc=$system.Status.AppendStatus(sc, $system.Status.Error(5001,"Failed to write __init__ lines to file "_outFile))
                    set i=lines
                }
            }
            if (sc2'=$$$OK) {
                Continue
            }
        }
    }
    if oFile'="" {
        d oFile.Close()
    }
    Return sc
}

/// Doxygen can't handle subfolder names containing %, so use _ instead for %-packages
ClassMethod P2U(in As %String) As %String
{
    //if $e(in)="%" Return "_"_$e(in,2,*)
    if $e(in)="%" Return "_."_$e(in,2,*)
    Return in
}

/// Return the database name for this class
ClassMethod DatabaseName(namespace As %String = {$namespace}) As %String
{
    if $e(namespace)="^" return $e(namespace,2,*)

    Set gblref=$name(^|namespace|oddDEF)
    Set db=$$GetGlobalSourceDatabase^%SYS.SECURITY(gblref)
    #; Get the first name which maps to that directory
    If $$DatabasesByDirectory^%SYS.CONFIG($Piece(db,"^",2),$Piece(db,"^",3),.dblist)
    {
        Set dbname=$list(dblist,1)
    } else {
        Set dbname=""
    }
    Return dbname
}

/// Return the path where the metadata files are stored
ClassMethod MetadataPath(namespace As %String = {$namespace}) As %String
{
    Set tDir=$SYSTEM.Util.DataDirectory()
    Set tDir=##class(%File).SubDirectoryName(tDir,"dev")
    Set tDir=##class(%File).SubDirectoryName(tDir,"atelier")
    Set tDir=##class(%File).SubDirectoryName(tDir,..DatabaseName(namespace))
    Return tDir
}

}
