From: Ed Suominen <ed@eepatents.com>
Subject: IPT2SH: Auto-Generate IPTABLES Configuration Script
Date: Wed, 26 Mar 2003 12:02:53 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E82076D.9070707@eepatents.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter@lists.netfilter.org, netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Below is a Bash script that looks at your current IPTABLES configuration 
and attempts to generate a Bash script that will reproduce it. The 
generated script can be edited to do advanced configuration of what an 
existing firewall program gives you and can be used as an rc.d script 
for startup configuration instead of the firewall program. Thus it is 
more flexible than iptables-save and iptables-restore.

It seems to work pretty well, but I believe there are still some loose 
ends. So I wouldn't (yet) recommend it for production systems.

I've had a lot of fun with the project, and there seems to be a real 
need for it, but just can't take any more time out to work on it. If 
anyone is interested using in maintaining the script (under the GPL), 
please feel free to do so. I'd certainly appreciate an email indicating 
your interest. Ideally, I'd like to see it distributed with 
iptables-save/restore.

Don't let all the SED/AWK code scare you -- It's pretty straightforward 
text parsing stuff.

Have fun!

-Ed

-------------
#!/bin/sh
# [IP] [T]ables [to] [SH]ell Script IPtables parsing utility
# Copyright (c) 2003 by Edwin A. Suominen, http://www.eepatents.com
# Registered Patent Agent & Technology Consultant
# Electrical Engineering * DSP * mySQL * Programming * Networking
#
# This script is licensed under the GNU Public License as last
# published prior to the copright year by the Free Software
# Foundation, which license is incorporated herein by reference.
#

### Functions
usage() {
     echo \
"Usage: `basename $0` ?-f <FILTER dump>? \
?-m <MANGLE dump>? ?-n <NAT dump>?"
}

makestr() {
     eval local X=\"$`echo $1`\"
     if [ -z $X ]; then
         # ...from shell
         $IPT -L -n -v -t `echo $1 |tr [:upper:] [:lower:]` |tr '\n' '~'
     else
         # ...from file
         cat $1 |tr '\n' '\\n'
     fi
}

### Setup
## Write temporary awk scripts
TMP=/tmp/.ipt2sh
echo '{
if($1=="Chain") {
   # Beginning of Chain Section
   printf "%da\n%db # %s\n",NR,NR,$0 > LEFT
   CHAIN=$2
   if($3~/\policy/) {
     # Built-in Chain
     printf "-P %s %s\n",CHAIN,$4 > TOP
   } else {
     # User-defined Chain
     printf "-N %s\n",CHAIN > TOP
   }
   printf "%da~%db~",NR,NR > RIGHT

} else {
   # Rule Definition
   if($3!="target" && NF > 0) {
     printf "%d -A %s",NR,CHAIN > LEFT;
     if($6!="*") { printf " -i %s",$6 > LEFT }
     if($7!="*") { printf " -o %s",$7 > LEFT }
     if($2~/tcp|udp|icmp/) { printf " -p %s",$4 > LEFT }
     printf " -s %s -d %s -j %s\n",$8,$9,$3 > LEFT
     printf "%d",NR > RIGHT
     for(i=10; i <= NF; i++)
       printf " %s",$i > RIGHT
     printf "~" > RIGHT
   } else { if($1~/^#/) {
       printf "%d %s\n",NR,$0 > LEFT
       printf "%d~",NR > RIGHT
   }}
}} END { printf "99999\n\n" > LEFT }' > $TMP-awk-1

echo '
function parsebits(x,  d,y) {
   d=16*substr(x,3,1)+substr(x,4,1); y=""
   if(and(d,32)) { printf "%sURG",y; y="," }
   if(and(d,16)) { printf "%sACK",y; y="," }
   if(and(d,8)) { printf "%sPSH",y; y="," }
   if(and(d,4)) { printf "%sRST",y; y="," }
   if(and(d,2)) { printf "%sSYN",y; y="," }
   if(and(d,1)) { printf "%sFIN",y; y="," }
   if(y=="") { printf "NONE" }
} {

printf "%s",$1; i=1; flag=""; protocol=" --protocol tcp"
while(i<=NF) {
   i++
   if($i~/tcp|udp/) continue
   if($i~/^dpt/) {
     printf "%s --dport %s",protocol,substr($i,index($i,":")+1); i++
     protocol=""
   }
   if($i~/^spt/) {
     printf "%s --sport %s",protocol,substr($i,index($i,":")+1); i++
     protocol=""
   }
   if($i=="state") { printf " -m state --state %s",$(++i) }
   if($i=="TOS") {
     if($(++i)=="set") {
       printf " --set-tos %s",$(++i)
     } else {
       printf " -m tos --tos %s",$(++i)
     }
   }
   if($i=="reject-with") { printf " --reject-with %s",$(++i) }
   if($i~/^limit/) {
     if (flag!="limit") { printf " -m limit"; flag="limit" }
     if($(++i)~/avg/) { printf " --limit %s",$(++i) }
     if($(++i)~/burst/) { printf " --limit-burst %d",$(++i) }
   }
   if($i~/LOG/ || flag=="log") {
     flag="log"
     if($(i+1)=="level") {
       printf " --log-level %d",$(++i)
     } else { if($(i+1)=="prefix") {
       printf " --log-prefix "; i++
       while(++i<=NF) { printf " %s",$i }
     } else {
       i++
     }}
   }
   if($i~/^to:/) {
     x=substr($i,index($i,":")+1); i++
     if($1=="SNAT") {
       printf " --to-source %s",x
     } else {
       printf " --to-destination %s",x
     }
   }
   if($i~/^flags:/) {
     printf "%s --tcp-flags ",protocol
     x=substr($i,index($i,":")+1)
     if(substr(x,1,1)=="!") { printf "! "; x=substr(x,2) }
     split(x,hex,"/")
     parsebits(hex[1])
     printf " "
     parsebits(hex[2])
   }
} printf "\n"
} END { printf "99999\n\n" }' > $TMP-awk-2

## Read specified iptables dump files or generate dumps
while getopts :n:m:f:o: OPTION
do
     case $OPTION in
     n)
         NAT=$OPTARG
     ;;
     m)
         MANGLE=$OPTARG
     ;;
     f)
         FILTER=$OPTARG
     ;;
     *)
         usage
     ;;
     esac
done

## Misc definitions
# Define iptables command
IPT=`whereis iptables |awk '{print $2}'`
# Read IPtables dumps
FILTER=`makestr FILTER`
MANGLE=`makestr MANGLE`
NAT=`makestr NAT`

## BEGIN output header
echo "
#!/bin/sh
# Generated `date +%x` by ipt2sh
# [IP] [T]ables [to] [SH]ell Script IPtables parsing utility
# by Edwin A. Suominen, http://www.eepatents.com
# Registered Patent Agent & Technology Consultant
# Electrical Engineering * DSP * mySQL * Programming * Networking

### Initialize iptables
IPT=$IPT
for i in filter mangle nat
do
     \$IPT -t \$i -F
     \$IPT -t \$i -X
     \$IPT -t \$i -Z
done

### Initialize chains" > $TMP-top
## END output header


### Parse dump for each table
for i in FILTER MANGLE NAT
do
     ### Pass 1: Parse the tabulated parts of dump text
     eval IN=\"\$`echo $i`\"
     echo "$IN" |tr '~' '\n' | \
       awk -f $TMP-awk-1 LEFT=$TMP-left RIGHT=$TMP-right-1 TOP=$TMP-top-1

     ### Pass 2: Parse the extra stuff in dump text
     cat $TMP-right-1 |awk -f $TMP-awk-2 RS=~ | \
       tr "[\`\']" "\"" > $TMP-right

     join $TMP-left $TMP-right | \
       cut --delim=' ' -f2- | \
       sed s/^[0-9].*$// |sed "s/^\-/-t `echo $i | \
         tr [:upper:] [:lower:]` -/" | \
         awk '{ if($1~/^\-/) {\
           printf "$IPT %s\n",$0 } else { print $0 } }' | \
           sed 's/0\.0\.0\.0\/0/0\/0/g' | \
           sed 1i"### Table: $i" > $TMP-$i

     ### Fix chain definition lines added for this table
     cat $TMP-top-1 |sed "s/^\-/\$IPT -t `echo $i | \
       tr [:upper:] [:lower:]` -/" >> $TMP-top
done

### Massage output before directing to stdout
echo -e "\n" >> $TMP-top
cat $TMP-top $TMP-FILTER $TMP-MANGLE $TMP-NAT
echo -e "###EOF"

### Delete temp files
rm $TMP*

### EOF
