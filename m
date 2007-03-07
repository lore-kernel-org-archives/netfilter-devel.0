From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 10/13]: ip6_route_me_harder should take into account mark
Date: Wed,  7 Mar 2007 22:34:40 +0100 (MET)
Message-ID: <20070307213401.22306.7090.sendpatchset@localhost.localdomain>
References: <20070307213347.22306.9248.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
	davem@davemloft.net
To: stable@kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070307213347.22306.9248.sendpatchset@localhost.localdomain>
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
commit af72e6f0118b0361f8d4c933add715ca9c28cba3
tree 89f7dafae6150ddf03b74c7044899464b249adc2
parent a272604aa255307e92fcfd330cb466aa8108795a
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Tue, 06 Mar 2007 08:31:57 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 06 Mar 2007 08:31:57 +0100

 net/ipv6/netfilter.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index f6294e5..ca50b58 100644
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
