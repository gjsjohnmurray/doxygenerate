Class tests.gjsjohnmurray.doxygenerate.unittests.TestUtils Extends %UnitTest.TestCase
{

Method TestTODO()
{
	Set tExpected="Test string"
	set status=$$$OK
	do $$$AssertStatusOK(status,"TODO: $$$OK")
	set tResults=tExpected
    Do $$$AssertEquals(tResults,tExpected,"TODO: "_tExpected_" = "_tResults)
}

}
