From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 1/3]: nf_conntrack: Increment error count on parsing IPv4
 header
Date: Thu, 12 Jul 2007 00:06:54 +0900 (JST)
Message-ID: <200707111506.l6BF6taS007132@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: jengelh@computergmbh.de
To: kaber@trash.net, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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


Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
---
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    2 --
 net/netfilter/nf_conntrack_core.c              |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 89e20ab..b5c4bb5 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -131,8 +131,6 @@ ipv6_prepare(struct sk_buff **pskb, unsigned int hooknum, unsigned int *dataoff,
 	 */
 	if ((protoff < 0) || (protoff > (*pskb)->len)) {
 		pr_debug("ip6_conntrack_core: can't find proto in pkt\n");
-		NF_CT_STAT_INC_ATOMIC(error);
-		NF_CT_STAT_INC_ATOMIC(invalid);
 		return -NF_ACCEPT;
 	}
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 3d14110..b730413 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -625,6 +625,8 @@ nf_conntrack_in(int pf, unsigned int hooknum, struct sk_buff **pskb)
 
 	if ((ret = l3proto->prepare(pskb, hooknum, &dataoff, &protonum)) <= 0) {
 		pr_debug("not prepared to track yet or error occured\n");
+		NF_CT_STAT_INC_ATOMIC(error);
+		NF_CT_STAT_INC_ATOMIC(invalid);
 		return -ret;
 	}
 
-- 
1.5.2.2
