From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/02]: Netfilter fixes
Date: Sat, 12 Aug 2006 02:25:35 +0200 (MEST)
Message-ID: <20060812002535.30253.73682.sendpatchset@localhost.localdomain>
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

following are two more fixes for 2.6.18. The ulog patch fixes an old
crash in ulog that has hit quite a few people so far. I'm going to push
it to -stable as well.

Please apply, thanks.


 net/bridge/netfilter/ebt_ulog.c |    6 +++
 net/ipv4/netfilter/arp_tables.c |   54 +++++++++++++++++++++++--------
 net/ipv4/netfilter/ip_tables.c  |   66 +++++++++++++++++++++++++++++---------
 net/ipv4/netfilter/ipt_ULOG.c   |   10 +++++
 net/ipv6/netfilter/ip6_tables.c |   68 +++++++++++++++++++++++++++++-----------
 net/netfilter/nfnetlink_log.c   |    6 +++
 6 files changed, 162 insertions(+), 48 deletions(-)

Mark Huang:
      [NETFILTER]: ulog: fix panic on SMP kernels

Patrick McHardy:
      [NETFILTER]: {arp,ip,ip6}_tables: proper error recovery in init path
