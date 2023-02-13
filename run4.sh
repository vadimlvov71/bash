#!/bin/bash
declare  LIST_HEADERS
declare  CURL_HEADERS
declare  CURL_HEADERS1
RED='\033[0;31m'
NC='\033[0m' # No Color
GREEN='\033[0;32m'
#list of headers from file "cfg/headersList.cfg"
echo ${CONFIG[baseURL]}
check=$(curl -s -vv -I https://dod.local 2>/dev/null | grep  "HTTP/2 404")
check1=$(curl -s -vv -I https://www.deonlinedrogist.nl 2>/dev/null )


#echo $check
if [[ -z $check ]] ; then
      echo "Cnxn failed"
    else
      echo "Cnxn successful"
fi
echo "+++++++++++++++++++++++++++++"
curl -s -vv -I https://github.com/ardmy 2>/dev/null | grep -q "HTTP/2 200"
if [[ $? == 0 ]]; then
echo "Cnxn successful $?"
else
echo "Cnxn failed $?"
fi
value1=`echo "x-content-type-options: nosniff" | md5sum | cut -f1 -d" "`
while IFS=':' read -r value; do
  value="${value//\"}"

  #value=${value##*( )}
  #value=${value%%*( )}
  #to lower case
  #value=`echo ${value} | md5sum | cut -f1 -d" "`
  value=${value,,}
  LIST_HEADERS+=("$value")
done < ${CONFIG[cfg]}/headersList.cfg

#LIST_HEADERS+=("$value1")
echo -e "${GREEN}data from list: ${NC}"
for elem in "${!LIST_HEADERS[@]}"
do
  echo "${LIST_HEADERS[elem]}"
done

#list of headers from the site
while IFS=':' read -r value; do
  value=${value##+([[:space:]])}; value=${value%%+([[:space:]])}
  #check3=${(value  | grep  "HTTP/2 404")}
  #value="${value//\"}"
   #value=${value##*( )}
   #value=${value%%*( )}
   #value="${value##+([[:space:]])}"
   #value=`echo ${value} | md5sum | cut -f1 -d" "`
   #to lower case
    #value=${value,,}
    #check3=$(echo ${CURL_HEADERS[0]} | grep -o 'HTTP/2 404')
    CURL_HEADERS+=("$value")
#done < <(curl  -sIk -G ${CONFIG[baseURL]})
#done < <(curl  -sIk -G https://github.com/ardmy)
done < <(curl  -sIk -G https://www.deonlinedrogist.nl)
check3=$(echo ${CURL_HEADERS[6]} | grep -o 'x-content-type-options: nosniff')
if [[ -z $check3 ]] ; then
      echo "Cnxn failed"
    else
      echo "Cnxn successful"
fi
echo ${CURL_HEADERS[6]}
echo -e "${RED}++++++++++++++++:${NC}"
#printf "%s\n" "${CURL_HEADERS[@]}" > ${CONFIG[cfg]}/headersList1.cfg
#done < <(curl -sIk --request GET 'https://google.com')
CURL_HEADERS+=("$value1")
echo -e "${GREEN}data from curl:${NC}"
for elem in "${!CURL_HEADERS[@]}"
do
  #echo "${CURL_HEADERS[elem]}"
done

echo "_ -----------"
for elem in "${!CURL_HEADERS[@]}"
do
  CURL_HEADERS1+=(${CURL_HEADERS[elem]})
  echo "${elem}" "${CURL_HEADERS[elem]}"
done
echo "&&&&&&&&&&&&&&&&&&&&&&&&&&&&"

echo "+++++++++++++++++++++++++++++"
ArrayResult=()
for i in "${LIST_HEADERS[@]}"; do

    skip=
    for j in "${CURL_HEADERS[@]}"; do

        [[  $i == $j ]] && { skip=1; break; }
    done
    [[ -n $skip ]] || ArrayResult+=("$i")
done

if [[ -n ArrayResult[@] ]]; then
  echo -e "${RED}Array is not empty:${NC}"
  echo  "count: "${#ArrayResult[@]}
  for i in ${!ArrayResult[*]}; do
    echo "${ArrayResult[i]}"
  done
else
  echo -e "${GREEN}Array is not empty:${NC}"
  echo "Array empty"
fi
