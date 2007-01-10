From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/04]: Netfilter -stable fixes
Date: Wed, 10 Jan 2007 08:04:45 +0100 (MET)
Message-ID: <20070110070444.13495.95670.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
	davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: stable@kernel.org
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

Following are a few important netfilter patches for -stable, fixing

- a crash in nf_conntrack_ipv6 when handling fragments
- an incorrect numerical value for the TCP connection tracking
  IP_CT_TCP_FLAG_CLOSE_INIT flag, causing various kinds of misbehaviour
- a regression in 2.6.19 when routing REJECT packets in the OUTPUT chain
- userspace compilation of arp_tables

All patches are either already in Linus' tree or queued in Dave's net-2.6 tree.
Please apply, thanks.


 include/linux/netfilter/nf_conntrack_tcp.h |    2 +-
 include/linux/netfilter_arp/arp_tables.h   |    1 +
 net/ipv4/netfilter.c                       |    7 +++++--
 net/ipv6/netfilter/nf_conntrack_reasm.c    |    2 ++
 4 files changed, 9 insertions(+), 3 deletions(-)

Bart De Schuymer:
      [NETFILTER]: arp_tables: fix userspace compilation

Patrick McHardy:
      [NETFILTER]: Fix routing of REJECT target generated packets in output chain
      [NETFILTER]: nf_conntrack_ipv6: fix crash when handling fragments
      [NETFILTER]: tcp conntrack: fix IP_CT_TCP_FLAG_CLOSE_INIT value
