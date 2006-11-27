From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/04]: Netfilter fixes
Date: Mon, 27 Nov 2006 19:20:53 +0100 (MET)
Message-ID: <20061127182053.17688.57354.sendpatchset@localhost.localdomain>
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

following are a few small netfilter fixes for 2.6.19, fixing multiple
refcount leaks and a nf_conntrack helper assignment race which can
lead to use-after-free.

Please apply, thanks.


 net/ipv4/netfilter/ip_conntrack_core.c    |    6 +++---
 net/ipv4/netfilter/ip_conntrack_netlink.c |    1 +
 net/netfilter/nf_conntrack_core.c         |   19 +++++++++----------
 net/netfilter/nf_conntrack_netlink.c      |    9 +++++++++
 4 files changed, 22 insertions(+), 13 deletions(-)

Patrick McHardy:
      [NETFILTER]: ctnetlink: fix reference count leak

Yasuyuki Kozakai:
      [NETFILTER]: nfctnetlink: assign helper to newly created conntrack
      [NETFILTER]: nf_conntrack: fix the race on assign helper to new conntrack
      [NETFILTER]: conntrack: fix refcount leak when finding expectation
