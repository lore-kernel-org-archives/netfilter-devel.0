From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/04]: Netfilter fixes
Date: Tue,  9 Jan 2007 17:29:52 +0100 (MET)
Message-ID: <20070109162952.6229.79602.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
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

following are a few more netfilter fixes for 2.6.20, fixing a
nf_conntrack_ipv6 crash when dealing with fragments, hanging
connections when loading the nf_nat module, an incorrect value
for a TCP connection tracking flag and compilation of arp_tables
userspace. I'll also pass on the relevant ones to -stable.

Please apply, thanks.


 include/linux/netfilter/nf_conntrack_tcp.h |    2 +-
 include/linux/netfilter_arp/arp_tables.h   |    1 +
 net/ipv4/netfilter/nf_nat_standalone.c     |    2 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c    |    2 ++
 4 files changed, 5 insertions(+), 2 deletions(-)

Bart De Schuymer:
      [NETFILTER]: arp_tables: fix userspace compilation

Patrick McHardy:
      [NETFILTER]: nf_conntrack_ipv6: fix crash when handling fragments
      [NETFILTER]: nf_nat: fix hanging connections when loading the NAT module
      [NETFILTER]: tcp conntrack: fix IP_CT_TCP_FLAG_CLOSE_INIT value
