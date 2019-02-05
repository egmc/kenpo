#!/bin/bash
current=$(cd $(dirname $0);pwd)

for key in `cat $current/list`; do
  if [ `echo $key | egrep '^#'` ];then
    #echo 'skip'
	continue
  fi
  page_id=`echo $key|cut -f1 -d '_'`
  target_date=`echo $key|cut -f2 -d '_'`
  result_path=$current/result/$key

  sleep $(($RANDOM % 1000))

  curl -H 'User-Agent: Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1)' -s https://as.its-kenpo.or.jp/apply/empty_new?s=$page_id |grep -qs "$target_date"
  result=$?

  if [ -f "$result_path" ];then
    before=`cat $result_path`
    #echo "before $before"
    #echo "result $result"
    if [ $result -ne $before ] && [ $result -eq 0 ]; then
      #echo "$target_date is empty now"
      MESSAGE="$target_date is empty now! https://as.its-kenpo.or.jp/apply/empty_new?s=$page_id"
      . $current/hook.sh
    fi
  fi
  echo -n $result  > $result_path
done
