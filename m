From: Samuel Jean <sj-netfilter@cookinglinux.org>
Subject: [testsuite] ipt_multiport testcase
Date: Sat, 18 Dec 2004 00:27:19 -0500
Message-ID: <41C3BFB7.3030901@cookinglinux.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030507070500030206010200"
Cc: netfilter-devel@lists.netfilter.org,
	Nicolas Bouliane <nib@cookinglinux.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------030507070500030206010200
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Rusty,

Like the subject suggests, here's the ipt_multiport testcase.
This is your fourth christmas gift. This one was very expensive
so I hope you will like it.

Cheers,

--peejix


--------------030507070500030206010200
Content-Type: text/plain;
 name="36ipt_multiport-bad-args.sim"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="36ipt_multiport-bad-args.sim"

# the three options should work (expecting: success)
# Default maximum ports number supported by the library is 15
iptables -I INPUT -p tcp -m multiport --source-ports 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
iptables -D INPUT -p tcp -m multiport --source-ports 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
iptables -I INPUT -p tcp -m multiport --destination-ports 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
iptables -D INPUT -p tcp -m multiport --destination-ports 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
iptables -I INPUT -p tcp -m multiport --ports 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
iptables -D INPUT -p tcp -m multiport --ports 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15

# Ensure UDP works too.. (expecting: success)
# One test should be sufficient
iptables -I INPUT -p udp -m multiport --source-ports 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
iptables -D INPUT -p udp -m multiport --source-ports 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15

# Multiport doesn't support invert nor complains about it. (expecting: answer from rusty)
# Do we still test it Rusty ?
iptables -I INPUT -p tcp -m multiport ! --source-ports 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
iptables -D INPUT -p tcp -m multiport ! --source-ports 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
iptables -I INPUT -p tcp -m multiport ! --destination-ports 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
iptables -D INPUT -p tcp -m multiport ! --destination-ports 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
iptables -I INPUT -p tcp -m multiport ! --ports 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
iptables -D INPUT -p tcp -m multiport ! --ports 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15

# Multiport doesn't support multiple options. (expecting: failure)
expect iptables iptables: command failed
iptables -I INPUT -p tcp -m multiport --sports 1 --dports 2 --ports 3
expect iptables iptables: command failed
iptables -I INPUT -p tcp -m multiport --sports 1 --dports 2

# Can we override ourself ? (expecting: failure)
expect iptables iptables: command failed
iptables -I INPUT -p tcp -m multiport --sports 1 --sports 1
expect iptables iptables: command failed
iptables -I INPUT -p tcp -m multiport --dports 2 --dports 2
expect iptables iptables: command failed
iptables -I INPUT -p tcp -m multiport --ports 3 --ports 3

# Reject ICMP and ALL (expecting: failure)
expect iptables iptables: command failed
iptables -I INPUT -p icmp -m multiport --ports 3
expect iptables iptables: command failed
iptables -I INPUT -m multiport --ports 3

--------------030507070500030206010200
Content-Type: text/plain;
 name="37ipt_multiport.sh"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="37ipt_multiport.sh"

#! /bin/sh

# For both TCP and UDP, test five ports against the three options
# where port 1 and port 5 are always the excluded twin (NF_ACCEPT'ed).
FLAG=" SYN"
for proto in 6 17; do
	if [[ $proto == 17 ]]; then
			 unset FLAG
	fi
	for arg in sports dports ports
	do
		echo iptables -I INPUT -p $proto -m multiport --${arg} 2,3,4 -j DROP
		for port in 1 2 3 4 5
		do
			case $port in
				[1,5]) 	VERDICT=NF_ACCEPT ;;
				*) 		VERDICT=NF_DROP	;;
			esac

			case $arg in
				sports)	PORTS="${port} 1" ;;
				dports)	PORTS="1 ${port}"	;;
				ports)	PORTS="${port} ${port}"	;;
			esac
				
				echo expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter $VERDICT \
				{IPv4 192.168.0.2 192.168.0.1 0 $proto ${PORTS}$FLAG}
				echo gen_ip IF=eth0 192.168.0.2 192.168.0.1 0 $proto $PORTS $FLAG
		done
		echo iptables -D INPUT -p $proto -m multiport --${arg} 2,3,4 -j DROP
	done
done > $TMPFILE

$NFSIM $NFSIM_ARGS < $TMPFILE

--------------030507070500030206010200--
