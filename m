From: Samuel Jean <sj-netfilter@cookinglinux.org>
Subject: [testsuite] ipt_ttl
Date: Wed, 15 Dec 2004 21:52:04 -0500
Message-ID: <41C0F854.6000502@cookinglinux.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010501020905040506050008"
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
--------------010501020905040506050008
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi rusty,

Here's a little nfsim testsuite against ipt_ttl match.

Cheers,

Samuel

--------------010501020905040506050008
Content-Type: text/plain;
 name="25ipt_ttl.sim"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="25ipt_ttl.sim"

# This should fail but it doesn't because patch was lost
# somewhere in the outter limit.
# https://lists.netfilter.org/pipermail/netfilter-cvslog/2004-July/003454.html
expect iptables iptables: command failed
iptables -A INPUT -m ttl --ttl-eq -1
iptables -A INPUT -m ttl --ttl-gt 300
iptables -A INPUT -m ttl --ttl-lt -2000

# Test for match function.
# These should get NF_DROP verdict.
expect gen_ip hook:NF_IP_PRE_ROUTING iptable_nat NF_DROP *

iptables -t nat -I PREROUTING -m ttl --ttl-eq 50 -j DROP
gen_ip IF=eth0 TTL=50 192.168.0.2 192.168.0.1 0 tcp 1 2 SYN

iptables -t nat -I PREROUTING -m ttl --ttl-gt 51 -j DROP
gen_ip IF=eth0 TTL=55 192.168.0.2 192.168.0.1 0 tcp 1 2 SYN

iptables -t nat -I PREROUTING -m ttl --ttl-lt 50 -j DROP
gen_ip IF=eth0 TTL=49 192.168.0.2 192.168.0.1 0 tcp 1 2 SYN

# This packet with TTL=51 should be NF_ACCEPT'ed
expect gen_ip hook:NF_IP_PRE_ROUTING iptable_nat NF_ACCEPT *
gen_ip IF=eth0 TTL=51 192.168.0.2 192.168.0.1 0 tcp 1 2 SYN


--------------010501020905040506050008--
