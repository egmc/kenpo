#!/bin/bash
current=$(cd $(dirname $0);pwd)

for key in `cat $current/list`; do
  page_id=`echo $key|cut -f1 -d '_'`
  target_date=`echo $key|cut -f2 -d '_'`
  result_path=$current/result/$key

  curl -s https://as.its-kenpo.or.jp/apply/empty_new?s=$page_id |grep -qs "$target_date"
  result=$?

  if [ -f "$result_path" ];then
    before=`cat $result_path`
    #echo "before $before"
    #echo "result $result"
    if [ $result -ne $before ] && [ $result -eq 0 ]; then
      #echo "$target_date is empty now"
      message="$target_date is empty now! https://as.its-kenpo.or.jp/apply/empty_new?s=$page_id"
      curl -s -H "Accept: application/json" -H "Content-type: application/json" -X POST -d "{\"to\": \"u6f27bae0d2ca7dec1ebca39b4f03eac3\", \"text\":\"say $message\"}" https://tkgiqnzhs2.execute-api.ap-northeast-1.amazonaws.com/production > /dev/null
    fi
  fi
  echo -n $result  > $result_path
done
