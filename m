From: Samuel Jean <sj-netfilter@cookinglinux.org>
Subject: [testsuite] ipt_iprange
Date: Thu, 16 Dec 2004 18:02:19 -0500
Message-ID: <41C213FB.2000101@cookinglinux.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080508050208010207090004"
Cc: rusty@rustcorp.com.au, nib@cookinglinux.org
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
--------------080508050208010207090004
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi rusty,

Here's a (probably complete) nfsim testsuite against ipt_iprange match.
By now, 27ipt_iprange-bad-addr.sim is failing.. safe to add into 
expected-failures.

Cheers,

Samuel


--------------080508050208010207090004
Content-Type: text/plain;
 name="27ipt_iprange-bad-addr.sim"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="27ipt_iprange-bad-addr.sim"

# Input some junk ip range.
# Obiously, this test must fail.
expect iptables iptables: command failed
iptables -A INPUT -m iprange --src-range 0.0.0.0-500.400.300.200
iptables -A INPUT -m iprange --dst-range 0.0.0.0-500.400.300.200

# Check if inputing the same option twice override previous one.
# This should ring the bell.
# Side note: Fixed in SVN since Mon Jul 12 07:16:54 2004 UTC, Revision 1407

iptables -A INPUT -m iprange --src-range 0.0.0.0-1.1.1.1 --src-range 1.1.1.1-2.2.2.2
iptables -A INPUT -m iprange --dst-range 0.0.0.0-1.1.1.1 --dst-range 1.1.1.1-2.2.2.2

# Giving a source and destination range should succeed.
expect ! iptables iptables: command failed
iptables -A INPUT -m iprange --src-range 0.0.0.0-1.1.1.1 --dst-range 1.1.1.1-2.2.2.2

# Invert
iptables -A INPUT -m iprange ! --src-range 0.0.0.0-1.1.1.1 ! --dst-range 1.1.1.1-2.2.2.2

# Remove me!
iptables -D INPUT -m iprange --src-range 0.0.0.0-1.1.1.1 --dst-range 1.1.1.1-2.2.2.2
iptables -D INPUT -m iprange ! --src-range 0.0.0.0-1.1.1.1 ! --dst-range 1.1.1.1-2.2.2.2


--------------080508050208010207090004
Content-Type: text/plain;
 name="28ipt_iprange.sim"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="28ipt_iprange.sim"

# Initial scenario: give a route for FORWARD'ed packets
route add 0.0.0.0/0 eth1

# Source address belong to this range ?
iptables -I INPUT -m iprange --src-range 10.0.0.0-10.0.0.5 -j DROP
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP {IPv4 10.0.0.2 192.168.0.1 0 6 1 2 SYN}
gen_ip IF=eth0 10.0.0.2 192.168.0.1 0 tcp 1 2 SYN

# Source address doesn't belong to this range ?
iptables -I INPUT -m iprange ! --src-range 10.0.0.0-10.0.0.5 -j ACCEPT
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_ACCEPT {IPv4 192.168.0.2 192.168.0.1 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.2 192.168.0.1 0 tcp 1 2 SYN

# Destination address belong to this range ?
iptables -I INPUT -m iprange --dst-range 192.168.0.0-192.168.0.255 -j DROP
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP {IPv4 10.0.0.2 192.168.0.1 0 6 1 2 SYN}
gen_ip IF=eth0 10.0.0.2 192.168.0.1 0 tcp 1 2 SYN

# Destination address doesn't belong to this range ?
iptables -I FORWARD -m iprange ! --dst-range 192.168.0.0-192.168.0.255 -j DROP
expect gen_ip hook:NF_IP_FORWARD iptable_filter NF_DROP {IPv4 10.0.0.2 10.0.0.1 0 6 1 2 SYN}
gen_ip IF=eth0 10.0.0.2 10.0.0.1 0 tcp 1 2 SYN

# Source and Destination belong..
iptables -I INPUT -m iprange --src-range 10.0.0.0-10.0.0.5 --dst-range 192.168.0.0-192.168.0.255 -j DROP
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP {IPv4 10.0.0.2 192.168.0.1 0 6 1 2 SYN}
gen_ip IF=eth0 10.0.0.2 192.168.0.1 0 tcp 1 2 SYN

# Source and Destination doesn't belong..
iptables -I FORWARD -m iprange ! --src-range 10.0.0.0-10.0.0.5 ! --dst-range 192.168.0.0-192.168.0.255 -j DROP
expect gen_ip hook:NF_IP_FORWARD iptable_filter NF_DROP {IPv4 192.168.0.1 10.0.0.2 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.1 10.0.0.2 0 tcp 1 2 SYN


--------------080508050208010207090004--
