#!/bin/bash
#author cfreer
#referral klvchen

URL="https://domain or ip"
#USER="*****"   如果需要认证取消注释即可
#PASSWORD="*****"


get_vul()
{
    #curl -X GET -H 'Accept: text/plain' -u ${USER}:${PASSWORD} "${URL}/api/repositories/${rp}/tags/${t}/vulnerability/details" > result
    #输出到result 后续做漏洞数据分析
    curl -X GET -H 'Accept: text/plain' "${URL}/api/repositories/${rp}/tags/${t}/vulnerability/details" >> result

}


# 获取 project id
PID=$(curl -s -X GET --header 'Accept: application/json' "${URL}/api/projects"|grep "project_id"|awk -F '[:, ]' '{print $7}')
#echo ${PID}

for id in ${PID}
do
    # 拿获取到的 projects_id 获取 name
    REPOS=$(curl -s -X GET --header 'Accept: application/json' "${URL}/api/repositories?project_id=${id}"|grep "name"|awk -F '"' '{print $4}'|sed 's/\//%2f/g')
    for rp in ${REPOS}
    do
        echo ${rp}
        #获取tags 结合自身情况选择吧 cry
        #TAGS=$(curl -s -X GET --header 'Accept: application/json' "${URL}/api/repositories/${rp}/tags"|grep \"name\"|awk -F '"' '{print $4}'|sort -r |awk 'NR =1 {print $1}')
        TAGS=$(curl -s -X GET --header 'Accept: application/json' "${URL}/api/repositories/${rp}/tags"|grep \"name\"|awk -F '"' '{print $4}'|sort -ur |awk 'NR < 3 {print $1}')

        for t in ${TAGS}
        do
            echo ${t}
            get_vul
        done

        echo "======"

    done


done



