From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/02]: Netfilter fixes
Date: Mon, 15 Jan 2007 10:22:51 +0100 (MET)
Message-ID: <20070115092251.22775.89608.sendpatchset@localhost.localdomain>
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

following are two netfilter fixes for 2.6.20, fixing a memory leak in
ctnetlink and a compile failure of the state match on PPC.

Please apply, thanks.


 include/net/netfilter/nf_conntrack_compat.h |    1 +
 net/ipv4/netfilter/ip_conntrack_netlink.c   |    2 +-
 net/netfilter/nf_conntrack_netlink.c        |    2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

Mikael Pettersson:
      [NETFILTER]: fix xt_state compile failure

Patrick McHardy:
      [NETFILTER]: ctnetlink: fix leak in ctnetlink_create_conntrack error path
