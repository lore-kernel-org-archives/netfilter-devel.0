From: Samuel Jean <sj-netfilter@cookinglinux.org>
Subject: [testsuite] ipt_length
Date: Sun, 19 Dec 2004 21:32:26 -0500
Message-ID: <41C639BA.4000708@cookinglinux.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060801070007080503080104"
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
--------------060801070007080503080104
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi rusty,

I broke my head to do a complete test against TCP, UDP and ICMP.
Once I finished, I looked at ipt_length.c to obviously open my eyes
on the fact we test against the IP header.

Should be not so bad..

Damnit :)

--peejix

--------------060801070007080503080104
Content-Type: text/plain;
 name="39ipt_length.sim"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="39ipt_length.sim"

# Send 5 packets with different length where datalen 0 & 4 are out of range.
# As it tests against the ip header, whatever layer4 proto we use is OK.
# TCP with no data ends up with a packet of 40 bytes.

iptables -I INPUT -m length --length 41:43 -j DROP
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_ACCEPT *
gen_ip IF=eth0 192.168.0.2 192.168.0.1 0 6 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP *
gen_ip IF=eth0 192.168.0.2 192.168.0.1 1 6 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP *
gen_ip IF=eth0 192.168.0.2 192.168.0.1 2 6 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP *
gen_ip IF=eth0 192.168.0.2 192.168.0.1 3 6 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_ACCEPT *
gen_ip IF=eth0 192.168.0.2 192.168.0.1 4 6 1 2 SYN
iptables -D INPUT -m length --length 41:43 -j DROP

# Invert the whole thing
iptables -I INPUT -m length ! --length 41:43 -j DROP
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP *
gen_ip IF=eth0 192.168.0.2 192.168.0.1 0 6 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_ACCEPT *
gen_ip IF=eth0 192.168.0.2 192.168.0.1 1 6 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_ACCEPT *
gen_ip IF=eth0 192.168.0.2 192.168.0.1 2 6 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_ACCEPT *
gen_ip IF=eth0 192.168.0.2 192.168.0.1 3 6 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP *
gen_ip IF=eth0 192.168.0.2 192.168.0.1 4 6 1 2 SYN
iptables -D INPUT -m length ! --length 41:43 -j DROP

--------------060801070007080503080104
Content-Type: text/plain;
 name="38ipt_length-bad-args.sim"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="38ipt_length-bad-args.sim"

# Test a normal straight rule (expecting: success)
iptables -I INPUT -m length --length 100
iptables -D INPUT -m length --length 100
iptables -I INPUT -m length --length 100:200
iptables -D INPUT -m length --length 100:200
iptables -I INPUT -m length --length :100
iptables -D INPUT -m length --length :100
iptables -I INPUT -m length --length 100:
iptables -D INPUT -m length --length 100:
iptables -I INPUT -m length --length :
iptables -D INPUT -m length --length :


# Test both invert argument (expecting: success)
iptables -I INPUT -m length ! --length 100
iptables -I INPUT -m length --length ! 100

# Twin options are not allowed (expecting: failure)
expect iptables iptables: command failed
iptables -I INPUT -m length --length 100 --length 50

# Bad arguments (expecting: failure)
expect iptables iptables: command failed
iptables -I INPUT -m length --length -1
expect iptables iptables: command failed
iptables -I INPUT -m length --length 50:100:150

--------------060801070007080503080104--
