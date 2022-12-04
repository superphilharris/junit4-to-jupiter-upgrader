#!/bin/bash

# TODO: if running on Windows-Subsystem or Linux, then replace the gsed with sed

find . -name "*.java" | while read filename; do
        if grep -q 'import org.junit.Test' $filename; then
                if grep -q 'Test.*timeout' $filename; then
                        echo "Skipping due to timeout $filename";

                elif grep -q 'class.*extends' $filename; then
                        echo "Skipping due to extends $filename";

                elif grep -q 'RunWith.*Silent' $filename; then
                        echo "Skipping due to silent runner $filename"

                else
                        echo "Upgrading $filename";

                        gsed -i 's/Assert/Assertions/g' $filename
                        gsed -i 's/org.junit./org.junit.jupiter.api./g' $filename
                        gsed -i 's/@Before/@BeforeEach/g' $filename
                        gsed -i 's/\.Before;/.BeforeEach;/g' $filename
                        gsed -i 's/@After/@AfterEach/g' $filename
                        gsed -i 's/\.After;/.AfterEach;/g' $filename
                        gsed -i 's/public class /class /g' $filename
                        gsed -i 's/public void /void /g' $filename

                        gsed -i 's/MatcherAssertions/MatcherAssert/g' $filename
                        gsed -i 's/api.Ignore/api.Disabled/g' $filename
                        gsed -i 's/@Ignore/@Disabled/g' $filename
                        gsed -i 's/@RunWith/@ExtendWith/g' $filename
                        gsed -i 's/.runner.RunWith/.extension.ExtendWith/g' $filename
                        gsed -i 's/import org.mockito.junit.MockitoJUnitRunner/import org.mockito.junit.jupiter.MockitoExtension/g' $filename
                        gsed -i 's/MockitoJUnitRunner/MockitoExtension/g' $filename
                        gsed -i 's/SpringJUnit4ClassRunner/SpringExtension/g' $filename
                        gsed -i 's/org.springframework.test.context.junit4/org.springframework.test.context.junit.jupiter/g' $filename

                        # TODO: expected = Exception
                        # TODO: assertEquals("message is first param"
                fi
        fi
done
