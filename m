From: Ed Suominen <ed@eepatents.com>
Subject: IPTables to shell script parsing utility
Date: Thu, 06 Feb 2003 15:13:41 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E42EC25.2050700@eepatents.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000002020801010500030409"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------000002020801010500030409
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Is anyone here interested in helping me finish this little GPL project?
It's a shell script alternative to iptables-save/restore, but perhaps
better in a way. The output can go right into an executable shell
script. So, you can use it to take an existing config and tweak it, or
even edit an "iptables -L" dump file to generate a firewall script.

Of course, the header text of the script's output is negotiable. :-)

Best regards, Ed

P.S. - Yeah, yeah, I know. A patent professional writing free software 
is sort of like a butcher being a vegetarian. But that's a very 
involved, very OT discussion, I'm afraid...

/--- Ed Suominen ------------------------------\
|> Registered Patent Agent
|> Independent Inventor of EE Technology
|> Author, PRIVARIA Secure Networking Suite
||  Freely available at http://www.privaria.org
|> Nothing above to be construed as legal advice
||  or the opinion of my firm or any client.
\--- http://www.eepatents.com -----------------/


--------------000002020801010500030409
Content-Type: text/plain;
 name="ipt2sh"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipt2sh"

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
    echo "Usage: `basename $0` ?-f <FILTER dump>? ?-m <MANGLE dump>? ?-n <NAT dump>?"
}

makestr() {
    eval local X=\"$`echo $1`\"
    if [ -z $X ]; then
        # ...from shell
        $IPT -L -n -t `echo $1 |tr [:upper:] [:lower:]` |tr '\n' '~'
    else
        # ...from file
        cat $1 |tr '\n' '\\n'
    fi
}

### Setup
# Read specified iptables dump files or generate dumps
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
# Define iptables command
IPT=`whereis iptables |awk '{print $2}'`
# Output temp file
OF=/tmp/.ipt2sh-out
# Read IPtables dumps
FILTER=`makestr FILTER`
MANGLE=`makestr MANGLE`
NAT=`makestr NAT`
# BEGIN output header
echo "
#!/bin/sh
# Generated `date +%x` by ipt2sh
# [IP] [T]ables [to] [SH]ell Script IPtables parsing utility
# by Edwin A. Suominen, http://www.eepatents.com
# Registered Patent Agent & Technology Consultant
# Electrical Engineering * DSP * mySQL * Programming * Networking

IPT=$IPT
-F

" > $OF
# END output header

### Parse dump for each table
for i in FILTER MANGLE NAT
do
    # Define temp file spec
    TMPFILE=/tmp/.ipt2sh-$i
    
    ### Pass 1: Parse the tabulated parts of dump text with just awk
    eval IN=\"\$`echo $i`\"
    echo "$IN" |tr '~' '\n' |awk '{
    if($1=="Chain") {
      printf "%da\n%db # %s\n",NR,NR,$0 > LEFT
      CHAIN=$2;
      if( $3 ~/\policy/ ) {
        printf "%dc -P %s %s\n",NR,CHAIN,substr($4,0,length($4)-1) > LEFT;
      } else {
        printf "%dc -N %s\n",NR,CHAIN > LEFT;
      }
      printf "%da~%db~%dc~",NR,NR,NR > RIGHT

    } else {
      if($1!="target" && NF > 0) {
        printf "%d -A %s",NR,CHAIN > LEFT;
        if($2~/tcp|udp/) { printf " -p %s",$2 > LEFT }
        printf " -s %s -d %s -j %s\n",$4,$5,$1 > LEFT;
        printf "%d",NR > RIGHT
        for(i=6; i <= NF; i++)
          printf " %s",$i > RIGHT;
        printf "~" > RIGHT
      }
    }}' LEFT=$TMPFILE-left RIGHT=$TMPFILE-right-1

    ### Pass 2: Parse the extra stuff in dump text
    cat $TMPFILE-right-1 |awk '{ 
    printf "%s",$1; i=1; limit=0;
    while(i <= NF) {
      i=i+1
      if($i~/tcp|udp/) continue;
      if($i~/^dpt/) { printf " --dport %s",substr($i,index($i,":")+1); i++ }
      if($i~/^spt/) { printf " --sport %s",substr($i,index($i,":")+1); i++ }
      if($i~/^limit/) {
        if (limit==0) { printf " -m limit"; limit=1 }
        if($(i+1)~/avg/) { printf " --limit %s",$(i+2); i+=2 }
        if($(i+1)~/burst/) { printf " --limit-burst %d",$(i+2); i+=2 }
      }
      printf "\n"
    }}' RS=~ > $TMPFILE-right

    echo -e "### Table: $i" >> $OF
    join $TMPFILE-left $TMPFILE-right |cut --delim=' ' -f2- |sed s/^[0-9].*$// >> $OF
    echo -e "\n" >> $OF
done

### Massage output before directing to stdout
cat $OF |awk '{ if($1~/^\-/) { printf "$IPT %s\n",$0 } else { print $0 } }'

### EOF



--------------000002020801010500030409--
