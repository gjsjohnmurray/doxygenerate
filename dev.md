# Recipes
## Build and publish test package
```
PS C:\Users\JohnM\Documents\GitHub\gjsjohnmurray\doxygenerate> docker-compose down   
[+] Running 2/2
 ✔ Container doxygenerate-iris-1  Removed                                                                                                                                                                    16.4s 
 ✔ Network doxygenerate_default   Removed                                                                                                                                                                     0.3s 
PS C:\Users\JohnM\Documents\GitHub\gjsjohnmurray\doxygenerate> docker-compose build --progress=plain
--progress is a global compose flag, better use `docker compose --progress xx build ...
#0 building with "desktop-linux" instance using docker driver
...
#8 340.8 %SYS>
#8 DONE 350.0s

#9 [iris] exporting to image
#9 exporting layers
#9 exporting layers 29.8s done
#9 writing image sha256:ea981302bb8372094030c5c21703606ffb14c3116b542095cfe66157ed31add0 done
#9 naming to docker.io/library/doxygenerate-iris 0.0s done
#9 DONE 29.9s

#10 [iris] resolving provenance for metadata file
#10 DONE 0.1s
PS C:\Users\JohnM\Documents\GitHub\gjsjohnmurray\doxygenerate> docker-compose up -d
[+] Running 2/2
 ✔ Network doxygenerate_default   Created                                                                                                                                                                     0.2s 
 ✔ Container doxygenerate-iris-1  Started                                                                                                                                                                     1.6s 
PS C:\Users\JohnM\Documents\GitHub\gjsjohnmurray\doxygenerate> docker-compose exec iris iris session iris -U USER   

Node: 2d74b6857401, Instance: IRIS

USER>zpm

=============================================================================
|| Welcome to the Package Manager Shell (ZPM).                             ||
|| Enter q/quit to exit the shell. Enter ?/help to view available commands ||
=============================================================================
zpm:USER>load /home/irisowner/dev

[USER|doxygenerate]     Reload START (/home/irisowner/dev/)
[USER|doxygenerate]     Reload SUCCESS
[doxygenerate]  Module object refreshed.
[USER|doxygenerate]     Validate START
[USER|doxygenerate]     Validate SUCCESS
[USER|doxygenerate]     Compile START
[USER|doxygenerate]     Compile SUCCESS
[USER|doxygenerate]     Activate START
[USER|doxygenerate]     Configure START
[USER|doxygenerate]     Configure SUCCESS
Starting setup...
Building metadata for IRISLIB...
 done
Generating files for database IRISLIB...
 done
Building doc for database IRISLIB...
 done
Building metadata for IRISLIB...
 done
Generating files for database ENSLIB...
 done
Building doc for database ENSLIB...
 done
Building metadata for %SYS...
Building metadata for IRISSYS...
 done
Generating files for %SYS...
 done
Building doc for %SYS...
 done
Building metadata for USER...
Building metadata for USER...
 done
Generating files for USER...
 done
Building doc for USER...
 done

[USER|doxygenerate]     Activate SUCCESS
zpm:USER>

zpm:USER>doxygenerate package    

[USER|doxygenerate]     Reload START (/home/irisowner/dev/)
[USER|doxygenerate]     Reload SUCCESS
[doxygenerate]  Module object refreshed.
[USER|doxygenerate]     Validate START
[USER|doxygenerate]     Validate SUCCESS
[USER|doxygenerate]     Compile START
[USER|doxygenerate]     Compile SUCCESS
[USER|doxygenerate]     Activate START
[USER|doxygenerate]     Configure START
[USER|doxygenerate]     Configure SUCCESS
Starting setup...
Building metadata for IRISLIB...
 done
Generating files for database IRISLIB...
 done
Building doc for database IRISLIB...
 done
Building metadata for IRISLIB...
 done
Generating files for database ENSLIB...
 done
Building doc for database ENSLIB...
 done
Building metadata for %SYS...
Building metadata for IRISSYS...
 done
Generating files for %SYS...
 done
Building doc for %SYS...
 done
Building metadata for USER...
Building metadata for USER...
 done
Generating files for USER...
 done
Building doc for USER...
 done

[USER|doxygenerate]     Activate SUCCESS
[USER|doxygenerate]     Package START
[USER|doxygenerate]     Package SUCCESS
zpm:USER>

zpm:USER>repo -n registry -r -url https://test.pm.community.intersystems.com/registry/ -user test -pass PassWord42

registry
        Source:                 https://test.pm.community.intersystems.com/registry/
        Enabled?                Yes
        Available?              Yes
        Use for Snapshots?      Yes
        Use for Prereleases?    Yes
        Is Read-Only?           No
        Deployment Enabled?     No
        Username:               test
        Password:               <set>
zpm:USER>

zpm:USER>doxygenerate publish

[USER|doxygenerate]     Reload START (/home/irisowner/dev/)
[USER|doxygenerate]     Reload SUCCESS
[doxygenerate]  Module object refreshed.
[USER|doxygenerate]     Validate START
[USER|doxygenerate]     Validate SUCCESS
[USER|doxygenerate]     Compile START
[USER|doxygenerate]     Compile SUCCESS
[USER|doxygenerate]     Activate START
[USER|doxygenerate]     Configure START
[USER|doxygenerate]     Configure SUCCESS
Starting setup...
Building metadata for IRISLIB...
 done
Generating files for database IRISLIB...
 done
Building doc for database IRISLIB...
 done
Building metadata for IRISLIB...
 done
Generating files for database ENSLIB...
 done
Building doc for database ENSLIB...
 done
Building metadata for %SYS...
Building metadata for IRISSYS...
 done
Generating files for %SYS...
 done
Building doc for %SYS...
 done
Building metadata for USER...
Building metadata for USER...
 done
Generating files for USER...
 done
Building doc for USER...
 done

[USER|doxygenerate]     Activate SUCCESS
[USER|doxygenerate]     Package START
[USER|doxygenerate]     Package SUCCESS
[USER|doxygenerate]     Register START
[USER|doxygenerate]     Register SUCCESS
[USER|doxygenerate]     Publish START
[USER|doxygenerate]     Publish SUCCESS
zpm:USER>
zpm:USER>doxygenerate publish

[USER|doxygenerate]     Reload START (/home/irisowner/dev/)
[USER|doxygenerate]     Reload SUCCESS
[doxygenerate]  Module object refreshed.
[USER|doxygenerate]     Validate START
[USER|doxygenerate]     Validate SUCCESS
[USER|doxygenerate]     Compile START
[USER|doxygenerate]     Compile SUCCESS
[USER|doxygenerate]     Activate START
[USER|doxygenerate]     Configure START
[USER|doxygenerate]     Configure SUCCESS
Starting setup...
Building metadata for IRISLIB...
 done
Generating files for database IRISLIB...
 done
Building doc for database IRISLIB...
 done
Building metadata for IRISLIB...
 done
Generating files for database ENSLIB...
 done
Building doc for database ENSLIB...
 done
Building metadata for %SYS...
Building metadata for IRISSYS...
 done
Generating files for %SYS...
 done
Building doc for %SYS...
 done
Building metadata for USER...
Building metadata for USER...
 done
Generating files for USER...
 done
Building doc for USER...
 done

[USER|doxygenerate]     Activate SUCCESS
[USER|doxygenerate]     Package START
[USER|doxygenerate]     Package SUCCESS
[USER|doxygenerate]     Register START
[USER|doxygenerate]     Register SUCCESS
[USER|doxygenerate]     Publish START
[USER|doxygenerate]     Publish SUCCESS
zpm:USER>

zpm:USER>search
registry https://test.pm.community.intersystems.com/registry/:
doxygenerate 0.1.1
zpm:USER>
```

## Load test package into another IRIS instance
```
USER>zpm

=============================================================================
|| Welcome to the Package Manager Shell (ZPM). version 0.7.4               ||
|| Enter q/quit to exit the shell. Enter ?/help to view available commands ||
|| Current registry https://pm.community.intersystems.com                  ||
=============================================================================
zpm:USER>repo -n registry -r -url https://test.pm.community.intersystems.com/registry/ -user test -pass PassWord42

registry
        Source:                 https://test.pm.community.intersystems.com/registry/
        Enabled?                Yes
        Available?              Yes
        Use for Snapshots?      Yes
        Use for Prereleases?    Yes
        Is Read-Only?           No
        Deployment Enabled?     No
        Username:               test
        Password:               <set>
zpm:USER>

zpm:USER>search
registry https://test.pm.community.intersystems.com/registry/:
doxygenerate 0.1.1
zpm:USER>install doxygenerate
...
zpm:USER>repo -reset-defaults

registry
        Source:                 https://pm.community.intersystems.com
        Enabled?                Yes
        Available?              Yes
        Use for Snapshots?      Yes
        Use for Prereleases?    Yes
        Is Read-Only?           No
        Deployment Enabled?     No
zpm:USER>
```


# useful commands
## clean up docker
use it when docker says "There is no space left on device". It will remove built but not used images and other temporary files.
```
docker system prune -f
```

```
docker rm -f $(docker ps -qa)
```

## build container with no cache
```
docker-compose build --no-cache --progress=plain
```
## start iris container
```
docker-compose up -d
```

## open iris terminal in docker
```
docker exec iris iris session iris -U IRISAPP
```


## import objectscript code

do $System.OBJ.LoadDir("/home/irisowner/dev/src","ck",,1)
## map iris key from Mac home directory to IRIS in container
- ~/iris.key:/usr/irissys/mgr/iris.key

## install git in the docker image
## add git in dockerfile
USER root
RUN apt update && apt-get -y install git

USER ${ISC_PACKAGE_MGRUSER}


## install docker-compose
```
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

```

## load and test module
```

zpm "load /home/irisowner/dev"

zpm "test dc-sample"
```

## select zpm test registry
```
repo -n registry -r -url https://test.pm.community.intersystems.com/registry/ -user test -pass PassWord42
```

## get back to public zpm registry
```
repo -r -n registry -url https://pm.community.intersystems.com/ -user "" -pass ""
```

## export a global in runtime into the repo
```
d $System.OBJ.Export("GlobalD.GBL","/irisrun/repo/src/gbl/GlobalD.xml")
```

## create a web app in dockerfile
```
zn "%SYS" \
  write "Create web application ...",! \
  set webName = "/csp/irisweb" \
  set webProperties("NameSpace") = "IRISAPP" \
  set webProperties("Enabled") = 1 \
  set webProperties("CSPZENEnabled") = 1 \
  set webProperties("AutheEnabled") = 32 \
  set webProperties("iKnowEnabled") = 1 \
  set webProperties("DeepSeeEnabled") = 1 \
  set sc = ##class(Security.Applications).Create(webName, .webProperties) \
  write "Web application "_webName_" has been created!",!
```



```
do $SYSTEM.OBJ.ImportDir("/opt/irisbuild/src",, "ck")
```


### run tests described in the module

IRISAPP>zpm
IRISAPP:zpm>load /irisrun/repo
IRISAPP:zpm>test package-name

### install ZPM with one line
    // Install ZPM
    set $namespace="%SYS", name="DefaultSSL" do:'##class(Security.SSLConfigs).Exists(name) ##class(Security.SSLConfigs).Create(name) set url="https://pm.community.intersystems.com/packages/zpm/latest/installer" Do ##class(%Net.URLParser).Parse(url,.comp) set ht = ##class(%Net.HttpRequest).%New(), ht.Server = comp("host"), ht.Port = 443, ht.Https=1, ht.SSLConfiguration=name, st=ht.Get(comp("path")) quit:'st $System.Status.GetErrorText(st) set xml=##class(%File).TempFilename("xml"), tFile = ##class(%Stream.FileBinary).%New(), tFile.Filename = xml do tFile.CopyFromAndSave(ht.HttpResponse.Data) do ht.%Close(), $system.OBJ.Load(xml,"ck") do ##class(%File).Delete(xml)




docker run --rm --name iris-sql -d -p 9091:1972 -p 9092:52773  -e IRIS_PASSWORD=demo -e IRIS_USERNAME=demo intersystemsdc/iris-community


docker run --rm --name iris-ce -d -p 9091:1972 -p 9092:52773 -e IRIS_PASSWORD=demo -e IRIS_USERNAME=demo intersystemsdc/iris-community -a "echo 'zpm \"install webterminal\"' | iriscli"



docker run --rm --name iris-sql -d -p 9092:52773 containers.intersystems.com/intersystems/iris-community:2023.1.0.229.0


docker run --rm --name iris-ce -d -p 9092:52773 containers.intersystems.com/intersystems/iris-community:2023.1.0.229.0