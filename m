From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.4 0/18]: Netfilter resync with 2.6
Date: Mon, 20 Dec 2004 08:14:03 +0100
Message-ID: <41C67BBB.6010100@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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

Hi Dave,

the following 18 patches resync netfilter in 2.4 with 2.6.
They contains the ICMP+NAT fixes, Yasuyuki's IPv6 fixes
and two misc. fixes.

You can pull all changes from bk://212.42.230.204/nf-2.4

Regards
Patrick


Patrick McHardy:
   o Merge coreworks.de:/home/kaber/src/nf/nf-2.4-misc into 
coreworks.de:/home/kaber/src/nf/nf-2.4
   o Merge coreworks.de:/home/kaber/src/nf/nf-2.4-nat into 
coreworks.de:/home/kaber/src/nf/nf-2.4
   o Merge coreworks.de:/home/kaber/src/nf/nf-2.4-ip6tables into 
coreworks.de:/home/kaber/src/nf/nf-2.4
   o [NETFILTER]: Fix stack leakage in iptables/ip6_tables
   o [NETFILTER]: Release dst_entry in PRE_ROUTING after NAT
   o [NETFILTER]: Verify NAT manips have been applied before reversing 
them in icmp_reply_translation
   o [NETFILTER]: Apply PRE_ROUTING manips in LOCAL_OUT for locally 
generated icmp errors
   o [NETFILTER]: Save a level of indentation in icmp_reply_translation
   o [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
   o [NETFILTER]: Associate locally generated ICMP errors with conntrack 
of original packet
 

Phil Oester:
   o [NETFILTER]: revert MASQUERADE optimization for mostly static IPs
 

Yasuyuki Kozakai:
   o [NETFILTER]: Backport fixes for ip6tables
   o [NETFILTER]: Backport fixes for ip6t_rt
   o [NETFILTER]: Backport fixes for ip6t_multiport
   o [NETFILTER]: Backport fixes for ip6t_ipv6header
   o [NETFILTER]: Backport fixes for ip6t_hbh
   o [NETFILTER]: Backport fixes for ip6t_frag
   o [NETFILTER]: Backport fixes for ip6t_eui64
   o [NETFILTER]: Fix check for ESP header size in ip6t_esp
   o [NETFILTER]: Backport fixes for ip6t_dst
   o [NETFILTER]: Backport fixes for ip6t_LOG
 
