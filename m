From: zhaojingmin@vivecode.com (Jing Min Zhao)
Subject: [PATCH] H.323: Call set_h225_addr instead of set_h225_addr_hook
Date: Fri, 18 May 2007 13:24:27 -0400 (EDT)
Message-ID: <20070518172427.C45313DA1F7@jzhao.vivecode.com>
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
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

They're the same.

Signed-off-by: Jing Min Zhao <zhaojingmin@vivecode.com>
---
 net/ipv4/netfilter/nf_nat_h323.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
index fcebc96..c5d2a2d 100644
--- a/net/ipv4/netfilter/nf_nat_h323.c
+++ b/net/ipv4/netfilter/nf_nat_h323.c
@@ -455,9 +455,9 @@ static int nat_q931(struct sk_buff **pskb, struct nf_conn *ct,
 		if (idx > 0 &&
 		    get_h225_addr(ct, *data, &taddr[0], &addr, &port) &&
 		    (ntohl(addr.ip) & 0xff000000) == 0x7f000000) {
-			set_h225_addr_hook(pskb, data, 0, &taddr[0],
-					   &ct->tuplehash[!dir].tuple.dst.u3,
-					   info->sig_port[!dir]);
+			set_h225_addr(pskb, data, 0, &taddr[0],
+				      &ct->tuplehash[!dir].tuple.dst.u3,
+				      info->sig_port[!dir]);
 		}
 	} else {
 		nf_conntrack_unexpect_related(exp);
-- 
1.4.4.3
