#!/bin/sh

echo
echo ">> 1. GO TO MICROSERVICE ROOT"
echo

source ~/Scripts/func/msroot
msroot

echo "[OK]"

echo
echo ">> 2. FETCH CHANGES FROM GIT"
echo

git ppt

if [ $? -ne 0 ]
then
    echo "[ERROR]"
    exit 1
fi

echo "[OK]"

echo
echo ">> 3. DELETE service/.metadata-lock.json FILE"
echo

if test -f "service/.metadata-lock.json"; then
    rm service/.metadata-lock.json
else
    echo "Not found, skipped"
fi

echo "[OK]"

echo
echo ">> 4. DELETE node FOLDER"
echo

rm -rf service/src/main/resources/public/node/

echo "[OK]"

echo
echo ">> 5. DELETE package-lock.json FILES"
echo

dpl -f

echo "[OK]"

echo
echo ">> 6. DELETE node_modules FOLDERS"
echo

rm -rf service/src/main/resources/public/*/node_modules/

echo "[OK]"

echo
echo ">> 7. INSTALL MICROSERVICE"
echo

mvn-install;

if [ $? -ne 0 ]
then
    echo "[ERROR]"
    exit 1
fi

echo
echo ">> 8. RUN MICROSERVICE"
echo

cd service && mvn-run