From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [testsuite] ipt_iprange
Date: Fri, 17 Dec 2004 12:17:37 +1100
Message-ID: <1103246257.29545.39.camel@localhost.localdomain>
References: <41C213FB.2000101@cookinglinux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>,
	nib@cookinglinux.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Samuel Jean <sj-netfilter@cookinglinux.org>
In-Reply-To: <41C213FB.2000101@cookinglinux.org>
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

On Thu, 2004-12-16 at 18:02 -0500, Samuel Jean wrote:
> Hi rusty,
> 
> Here's a (probably complete) nfsim testsuite against ipt_iprange match.

This is great.  As an exercise, I reworked 28ipt_range.sim as if I had
written it, to see what you think.  You might prefer your version, but I
thought it interesting to see how I would do it.

1) I like all the tests to only test one thing, and be as orthogonal and
simple as possible.  So I always try to use the same rule over and over,
with very simply changes.

2) The default setup is eth0: 192.168.0.*, and eth1: 192.168.1.*, so
unless there's a good reason you should probably stick with those
address ranges.

3) I ended up with one rule of form:
	iptables -I INPUT -m iprange --src-range 192.168.0.1-192.168.0.3 -j
DROP
   This makes it easy to test the edges: .0 and .4 should not
match, .1, .2 and .3 should.

4) The opposite case is always the exact opposite, making it simple to
write the test and ensure it's correct.

Here's the result:

# Source address belong to this range ?
iptables -I INPUT -m iprange --src-range 192.168.0.1-192.168.0.3 -j DROP
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_ACCEPT {IPv4 192.168.0.0 192.168.1.100 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.0 192.168.1.100 0 tcp 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP {IPv4 192.168.0.1 192.168.1.100 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.1 192.168.1.100 0 tcp 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP {IPv4 192.168.0.2 192.168.1.100 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.2 192.168.1.100 0 tcp 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP {IPv4 192.168.0.3 192.168.1.100 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.3 192.168.1.100 0 tcp 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_ACCEPT {IPv4 192.168.0.4 192.168.1.100 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.4 192.168.1.100 0 tcp 1 2 SYN
iptables -D INPUT -m iprange --src-range 192.168.0.1-192.168.0.3 -j DROP

# Source address doesn't belong to this range ?
iptables -I INPUT -m iprange ! --src-range 192.168.0.1-192.168.0.3 -j DROP
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP {IPv4 192.168.0.0 192.168.1.100 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.0 192.168.1.100 0 tcp 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_ACCEPT {IPv4 192.168.0.1 192.168.1.100 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.1 192.168.1.100 0 tcp 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_ACCEPT {IPv4 192.168.0.2 192.168.1.100 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.2 192.168.1.100 0 tcp 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_ACCEPT {IPv4 192.168.0.3 192.168.1.100 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.3 192.168.1.100 0 tcp 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP {IPv4 192.168.0.4 192.168.1.100 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.4 192.168.1.100 0 tcp 1 2 SYN
iptables -D INPUT -m iprange ! --src-range 192.168.0.1-192.168.0.3 -j DROP

# Destination address belong to this range ?
iptables -I INPUT -m iprange --dst-range 192.168.1.1-192.168.1.3 -j DROP
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_ACCEPT {IPv4 192.168.0.100 192.168.1.0 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.100 192.168.1.0 0 tcp 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP {IPv4 192.168.0.100 192.168.1.1 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.100 192.168.1.1 0 tcp 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP {IPv4 192.168.0.100 192.168.1.2 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.100 192.168.1.2 0 tcp 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP {IPv4 192.168.0.100 192.168.1.3 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.100 192.168.1.3 0 tcp 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_ACCEPT {IPv4 192.168.0.100 192.168.1.4 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.100 192.168.1.4 0 tcp 1 2 SYN
iptables -D INPUT -m iprange --dst-range 192.168.1.1-192.168.1.3 -j DROP

# Destination address doesn't belong to this range ?
iptables -I INPUT -m iprange ! --dst-range 192.168.1.1-192.168.1.3 -j DROP
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP {IPv4 192.168.0.100 192.168.1.0 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.100 192.168.1.0 0 tcp 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_ACCEPT {IPv4 192.168.0.100 192.168.1.1 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.100 192.168.1.1 0 tcp 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_ACCEPT {IPv4 192.168.0.100 192.168.1.2 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.100 192.168.1.2 0 tcp 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_ACCEPT {IPv4 192.168.0.100 192.168.1.3 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.100 192.168.1.3 0 tcp 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP {IPv4 192.168.0.100 192.168.1.4 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.100 192.168.1.4 0 tcp 1 2 SYN
iptables -D INPUT -m iprange --dst-range 192.168.1.1-192.168.1.3 -j DROP

# Source and Destination belong..
iptables -I INPUT -m iprange --src-range 192.168.0.1-192.168.0.3 --dst-range 192.168.0.1-192.168.0.3 -j DROP

	# Just destination not sufficient.
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_ACCEPT {IPv4 192.168.0.100 192.168.1.0 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.100 192.168.1.0 0 tcp 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_ACCEPT {IPv4 192.168.0.100 192.168.1.1 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.100 192.168.1.1 0 tcp 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_ACCEPT {IPv4 192.168.0.100 192.168.1.2 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.100 192.168.1.2 0 tcp 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_ACCEPT {IPv4 192.168.0.100 192.168.1.3 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.100 192.168.1.3 0 tcp 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_ACCEPT {IPv4 192.168.0.100 192.168.1.4 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.100 192.168.1.4 0 tcp 1 2 SYN

	# Just source not sufficient.
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_ACCEPT {IPv4 192.168.0.0 192.168.1.100 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.0 192.168.1.100 0 tcp 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_ACCEPT {IPv4 192.168.0.1 192.168.1.100 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.1 192.168.1.100 0 tcp 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_ACCEPT {IPv4 192.168.0.2 192.168.1.100 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.2 192.168.1.100 0 tcp 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_ACCEPT {IPv4 192.168.0.3 192.168.1.100 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.3 192.168.1.100 0 tcp 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_ACCEPT {IPv4 192.168.0.4 192.168.1.100 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.4 192.168.1.100 0 tcp 1 2 SYN

	# Need both.
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_ACCEPT {IPv4 192.168.0.0 192.168.1.0 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.0 192.168.1.0 0 tcp 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP {IPv4 192.168.0.1 192.168.1.1 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.1 192.168.1.1 0 tcp 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP {IPv4 192.168.0.2 192.168.1.2 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.2 192.168.1.2 0 tcp 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP {IPv4 192.168.0.3 192.168.1.3 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.3 192.168.1.3 0 tcp 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_ACCEPT {IPv4 192.168.0.4 192.168.1.4 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.4 192.168.1.4 0 tcp 1 2 SYN

iptables -D INPUT -m iprange --src-range 192.168.0.1-192.168.0.3 --dst-range 192.168.0.1-192.168.0.3 -j DROP

# Source and Destination doesn't belong..
iptables -I INPUT -m iprange ! --src-range 192.168.0.1-192.168.0.3 ! --dst-range 192.168.0.1-192.168.0.3 -j DROP

	# Just destination not sufficient.
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP {IPv4 192.168.0.100 192.168.1.0 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.100 192.168.1.0 0 tcp 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP {IPv4 192.168.0.100 192.168.1.1 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.100 192.168.1.1 0 tcp 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP {IPv4 192.168.0.100 192.168.1.2 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.100 192.168.1.2 0 tcp 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP {IPv4 192.168.0.100 192.168.1.3 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.100 192.168.1.3 0 tcp 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP {IPv4 192.168.0.100 192.168.1.4 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.100 192.168.1.4 0 tcp 1 2 SYN

	# Just source not sufficient.
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP {IPv4 192.168.0.0 192.168.1.100 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.0 192.168.1.100 0 tcp 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP {IPv4 192.168.0.1 192.168.1.100 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.1 192.168.1.100 0 tcp 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP {IPv4 192.168.0.2 192.168.1.100 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.2 192.168.1.100 0 tcp 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP {IPv4 192.168.0.3 192.168.1.100 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.3 192.168.1.100 0 tcp 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP {IPv4 192.168.0.4 192.168.1.100 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.4 192.168.1.100 0 tcp 1 2 SYN

	# Need both.
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP {IPv4 192.168.0.0 192.168.1.0 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.0 192.168.1.0 0 tcp 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_ACCEPT {IPv4 192.168.0.1 192.168.1.1 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.1 192.168.1.1 0 tcp 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_ACCEPT {IPv4 192.168.0.2 192.168.1.2 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.2 192.168.1.2 0 tcp 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_ACCEPT {IPv4 192.168.0.3 192.168.1.3 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.3 192.168.1.3 0 tcp 1 2 SYN
expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_DROP {IPv4 192.168.0.4 192.168.1.4 0 6 1 2 SYN}
gen_ip IF=eth0 192.168.0.4 192.168.1.4 0 tcp 1 2 SYN

iptables -D INPUT -m iprange ! --src-range 192.168.0.1-192.168.0.3 ! --dst-range 192.168.0.1-192.168.0.3 -j DROP

-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
