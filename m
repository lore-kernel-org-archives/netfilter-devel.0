From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/05]: Small netfilter update
Date: Mon,  2 Oct 2006 17:46:03 +0200 (MEST)
Message-ID: <20061002154716.13121.53265.sendpatchset@localhost.localdomain>
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

following is a small netfilter update for 2.6.19. The first three patches
are fixes (Kconfig dependency fix and Horms' LVS routing fix), one patch
to remove the duplicated route_me_harder code from ipt_REJECT and Bart's
ebt_mark patch. I know I'm a little late, but I hope its they're still
fine since they're quite small.

Please apply, thanks.


 include/linux/netfilter_bridge/ebt_mark_t.h |   12 +++
 include/linux/netfilter_ipv4.h              |    2 
 net/bridge/netfilter/ebt_mark.c             |   21 ++++--
 net/ipv4/ipvs/ip_vs_core.c                  |   10 ++
 net/ipv4/netfilter.c                        |    9 +-
 net/ipv4/netfilter/ip_nat_standalone.c      |    3 
 net/ipv4/netfilter/ipt_REJECT.c             |   97 +++++-----------------------
 net/ipv4/netfilter/iptable_mangle.c         |    3 
 net/netfilter/Kconfig                       |    2 
 9 files changed, 70 insertions(+), 89 deletions(-)

Bart De Schuymer:
      [NETFILTER]: ebt_mark: add or/and/xor action support to mark target

Patrick McHardy:
      [NETFILTER]: Kconfig: fix xt_physdev dependencies
      [NETFILTER]: ipt_REJECT: remove largely duplicate route_reverse function

Simon Horman:
      [NETFILTER]: add type parameter to ip_route_me_harder
      [NETFILTER]: Honour source routing for LVS-NAT
