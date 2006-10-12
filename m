From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/06]: Netfilter fixes
Date: Thu, 12 Oct 2006 11:54:18 +0200 (MEST)
Message-ID: <20061012095547.11462.58507.sendpatchset@localhost.localdomain>
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

following are a few netfilter fixes for 2.6.19. Please apply, thanks.


 MAINTAINERS                               |    8 ++-
 net/ipv4/netfilter/arp_tables.c           |    2 
 net/ipv4/netfilter/ip_conntrack_netlink.c |   72 +-----------------------------
 net/ipv4/netfilter/ipt_ECN.c              |    6 +-
 net/ipv4/netfilter/ipt_TOS.c              |    6 +-
 net/netfilter/Kconfig                     |    4 +
 net/netfilter/nf_conntrack_netlink.c      |   72 +-----------------------------
 net/netfilter/xt_NFQUEUE.c                |    2 
 net/netfilter/xt_connmark.c               |    2 
 9 files changed, 24 insertions(+), 150 deletions(-)

Pablo Neira Ayuso:
      [NETFILTER]: ctnetlink: Remove debugging messages

Patrick McHardy:
      [NETFILTER]: fix cut-and-paste error in exit functions
      [NETFILTER]: arp_tables: missing unregistration on module unload
      [NETFILTER]: ipt_ECN/ipt_TOS: fix incorrect checksum update
      [NETFILTER]: xt_CONNSECMARK: fix Kconfig dependencies
      [NETFILTER]: Update MAINTAINERS entry
