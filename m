From: Samuel <sj-netfilter@cookinglinux.org>
Subject: [testsuite] ipt_recent
Date: Thu, 30 Dec 2004 01:16:26 -0500
Message-ID: <41D39D3A.8050308@cookinglinux.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060108030909010507020704"
Cc: Rusty Russell <rusty@rustcorp.com.au>,
	Nicolas Bouliane <nib@cookinglinux.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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
--------------060108030909010507020704
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi rusty,

Here's the testcase for the ipt_recent module.

Note that it really doesn't behave like I think it should.

Cheers,

--peejix

--------------060108030909010507020704
Content-Type: text/plain;
 name="40ipt_recent.sh"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="40ipt_recent.sh"

#! /bin/sh
{

##
# Test #1: Incoming packets with differents source addresses
# For each source ip .2, .3 & .4; throw 10 packets.
# Increase kernel time after all nth packets are sent.
# Do NOT increase time for fifth packet so we burst the balloon
# So get NF_DROP'ed on 5th packet in a 1hit/1sec ratio.
# 
# Also test invert behaviour.

for p in '' '! '; do # Test normal and then negated rule
	echo iptables -I INPUT -m recent --name testcase --rsource \
		--hitcount 1 --seconds 1 ${p}--update -j DROP
	echo iptables -A INPUT -m recent --name testcase --set --rsource -j ACCEPT

	for pkt in 1 2 3 4 5 6 7 8 9 10; do # The 10 packets we send
		for h in 2 3 4; do # From each of 192.168.0.2, .3 & .4
			if [ ! "$pkt" -eq "5" ]; then

			[ -z $p ] && verdict=NF_ACCEPT || verdict=NF_DROP

			# Fifth packet triggers the 1:1 ratio.
			else
			# Negation doesn't behave as it should..
			#[ -z $p ] && verdict=NF_DROP || verdict=NF_ACCEPT
			# FIXME: This doesn't make much sense...
			# It always match so expect NF_DROP.
			verdict=NF_DROP
			fi

			echo expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter $verdict '*'
			echo gen_ip IF=eth0 192.168.0.$h 192.168.0.1 0 17 1 2
		done

		# Increasing by one triggers the 1:1 ratio, use 2.
		[ ! "$pkt" -eq "4" ] && echo time +2
	done
	
	echo iptables -D INPUT -m recent --name testcase --rsource \
		--hitcount 1 --seconds 1 ${p}--update -j DROP
	echo iptables -D INPUT -m recent --name testcase --set --rsource -j ACCEPT
done

##
# Test #2: Forwarded packets with differents destination addresses
# For each destination ip .2, .3 & .4; throw 10 packets.
# Increase kernel time after all nth packets are sent.
# Do NOT increase time for fifth packet so we burst the balloon
# So get NF_DROP'ed on 5th packet in a 1hit/1sec ratio.
#
# This doesn't increase coverage but at least make sure
# that feature works :)
# 
# Also test invert behaviour. (Isn't it cool?)

for p in '' '! '; do # Test normal and then negated rule
	echo iptables -I FORWARD -m recent --name testcase --rdest \
		--hitcount 1 --seconds 1 ${p}--update -j DROP
	echo iptables -A FORWARD -m recent --name testcase --set --rdest -j ACCEPT

	for pkt in 1 2 3 4 5 6 7 8 9 10; do # The 10 packets we send
		for h in 2 3 4; do # To each of 192.168.1.2, .3 & .4
			if [ ! "$pkt" -eq "5" ]; then

			[ -z $p ] && verdict=NF_ACCEPT || verdict=NF_DROP

			# Fifth packet triggers the 1:1 ratio.
			else
			# Negation doesn't behave as it should..
			#[ -z $p ] && verdict=NF_DROP || verdict=NF_ACCEPT
			# FIXME: This doesn't make much sense...
			# It always match so expect NF_DROP.
			verdict=NF_DROP
			fi

			echo expect gen_ip hook:NF_IP_FORWARD iptable_filter $verdict '*'
			echo gen_ip IF=eth0 192.168.0.1 192.168.1.$h 0 17 1 2
		done

		# Increasing by one triggers the 1:1 ratio, use 2.
		[ ! "$pkt" -eq "4" ] && echo time +2
	done
	
	echo iptables -D FORWARD -m recent --name testcase --rdest \
		--hitcount 1 --seconds 1 ${p}--update -j DROP
	echo iptables -D FORWARD -m recent --name testcase --set --rdest -j ACCEPT
done

##
# Test #3: Using the TTL lookup feature.
# Throw 5 packets where the 1st and 5th are twins (same TTL)
# So get NF_DROP'ed on 5th packet
#
# Let's see how it behaves when we first stamp the TTL after routing
# and do the checkup before routing. (insane scenario, I know)
#
# I must admit I wasn't sure of the result, nice to see it works. --peejix

echo iptables -t mangle -I PREROUTING -m recent --name testcase --rsource \
	--rttl --rcheck -j DROP
echo iptables -I INPUT -m recent --name testcase --set --rttl --rsource -j ACCEPT

for ttl in 50 51 52 53; do # The 4 packets we send
	echo expect gen_ip hook:NF_IP_PRE_ROUTING iptable_mangle NF_ACCEPT '*'
	echo gen_ip IF=eth0 TTL=$ttl 192.168.0.2 192.168.0.1 0 17 1 2
done

# The 5th packet that matches the TTL stamped
echo expect gen_ip hook:NF_IP_PRE_ROUTING iptable_mangle NF_DROP '*'
echo gen_ip IF=eth0 TTL=50 192.168.0.2 192.168.0.1 0 17 1 2

echo iptables -t mangle -D PREROUTING -m recent --name testcase --rsource \
	--rttl --rcheck -j DROP
echo iptables -D INPUT -m recent --name testcase --set --rttl --rsource -j ACCEPT

##
# Test #4: Using --hitcount in solo limiting 5 packets & more.
# We expect to NF_DROP 5th and 6th packet. IMO
#
# FIXME: Actually it only drops 6th packet. Shouldn't this
#			acts the same on 5th packet ?
echo iptables -I INPUT -m recent --name testcase --rsource \
	--hitcount 5 --rcheck -j DROP
echo iptables -A INPUT -m recent --name testcase --set --rsource -j ACCEPT

for pkt in 1 2 3 4 5; do # The 4 packets we send + an unexpected 5th
	echo expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_ACCEPT '*'
	echo gen_ip IF=eth0 192.168.0.2 192.168.0.1 0 17 1 2
done

# The 5th and 6th packet _should_ get NF_DROP verdict
# However, only sixth packet will do. (Bug?)
echo expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP '*'
echo gen_ip IF=eth0 192.168.0.2 192.168.0.1 0 17 1 2

echo iptables -D INPUT -m recent --name testcase --rsource \
	--hitcount 5 --rcheck -j DROP
echo iptables -D INPUT -m recent --name testcase --set --rsource -j ACCEPT

##
# Test #5: Using --seconds in solo with a 1 seconds lap.
#

echo iptables -I INPUT -m recent --name testcase --rsource \
		--seconds 1 --update -j DROP
echo iptables -A INPUT -m recent --name testcase --set --rsource -j ACCEPT

for pkt in 1 2 3 4 5; do # The 5 packets we send
	# We do not increase time for 3rd packet. hence we expect NF_DROP
	[ ! "$pkt" -eq "3" ] && { verdict=NF_ACCEPT; echo time +2; } || verdict=NF_DROP
	echo expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter $verdict '*'
	echo gen_ip IF=eth0 192.168.0.2 192.168.0.1 0 17 1 2
done

echo iptables -D INPUT -m recent --name testcase --rsource \
		--seconds 1 --update -j DROP
echo iptables -D INPUT -m recent --name testcase --set --rsource -j ACCEPT

##
# Test #6: Simplest scenario to introduce --remove thingie.
# (1) A new address is tagged (NF_ACCEPT)
# (2) The address match, so we remove from the list. (NF_DROP)
# (3) Back to step 1.
# 

echo iptables -I INPUT -m recent --name testcase --rsource --remove -j DROP
echo iptables -A INPUT -m recent --name testcase --set --rsource -j ACCEPT

for loop in 1 2 3; do # Try this 3 time
	for pkt in 1 2; do # Send 2 packets
		[ "$pkt" -eq "2" ] && verdict=NF_DROP || verdict=NF_ACCEPT
	
		echo expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter $verdict '*'
		echo gen_ip IF=eth0 192.168.0.2 192.168.0.1 0 17 1 2
	done
done

echo iptables -D INPUT -m recent --name testcase --rsource --remove -j DROP
echo iptables -D INPUT -m recent --name testcase --set --rsource -j ACCEPT

##
# Test #7: Look for arguments that don't fit together
# --update, --set, --rcheck and --update are action parms.
for parm1 in '--update' '--set' '--rcheck' '--update'; do
	for parm2 in '--update' '--set' '--rcheck' '--update'; do
		echo expect iptables iptables: command failed
		echo iptables -I INPUT -m recent --name testcase $parm1 $parm2
	done
done

} > $TMPFILE
$NFSIM $NFSIM_ARGS < $TMPFILE

--------------060108030909010507020704--
