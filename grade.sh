CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
git clone $1 student-submission
echo 'Finished cloning'


if [ -f student-submission/ListExamples.java ]
then 
    echo 'ListExamples found'
else 
    echo 'need file ListExamples.java'
    exit 1
fi

cp student-submission/ListExamples.java ./


javac -cp .:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar *.java
if [["$?" -ne "0"]]
then
    echo 'Compiler error'
    exit 1
fi

java -cp .:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar org.junit.runner.JUnitCore TestListExamples > test-results.txt

rec="$( grep -ic "OK" test-results.txt)"
echo $rec
if [[ "$rec" -ne 0 ]]
then
    echo '100%, all tests passed'
else
    string=$(grep Failures test-results.txt)
    echo $string
    TOTAL=${string:11:1}
    FAILED=${string:25:1}
    echo $TOTAL '/' $FAILED ' tests failed'
fi
