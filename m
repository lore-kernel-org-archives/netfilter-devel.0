From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 10/10]: ip6_route_me_harder should take into account mark
Date: Sun,  4 Mar 2007 21:20:11 +0100 (MET)
Message-ID: <20070304201919.28582.66193.sendpatchset@localhost.localdomain>
References: <20070304201906.28582.51903.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070304201906.28582.51903.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ip6_route_me_harder should take into account mark

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 906b5340def3527974c307c89460bc82c34535f7
tree 9142f0e4f515cccab225e8ab89e4a530f4dafecb
parent 346efa9c7dd81bff762a436d0259424e7c74fa69
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 02 Mar 2007 13:24:43 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 02 Mar 2007 13:24:43 +0100

 net/ipv6/netfilter.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 0b2d265..1c405dd 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -15,6 +15,7 @@ int ip6_route_me_harder(struct sk_buff *
 	struct dst_entry *dst;
 	struct flowi fl = {
 		.oif = skb->sk ? skb->sk->sk_bound_dev_if : 0,
+		.mark = skb->mark,
 		.nl_u =
 		{ .ip6_u =
 		  { .daddr = iph->daddr,
