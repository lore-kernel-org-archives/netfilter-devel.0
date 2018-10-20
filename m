From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 05/10] netfilter: xt_osf: simplify xt_osf_match_packet()
Date: Sat, 20 Oct 2018 11:43:12 +0200
Message-ID: <20181020094317.16011-6-pablo@netfilter.org>
References: <20181020094317.16011-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181020094317.16011-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

info area in match is always available, and remove unneeded variables.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_osf.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/net/netfilter/xt_osf.c b/net/netfilter/xt_osf.c
index bf7bba80e24c..7a103553d10d 100644
--- a/net/netfilter/xt_osf.c
+++ b/net/netfilter/xt_osf.c
@@ -40,14 +40,8 @@
 static bool
 xt_osf_match_packet(const struct sk_buff *skb, struct xt_action_param *p)
 {
-	const struct xt_osf_info *info = p->matchinfo;
-	struct net *net = xt_net(p);
-
-	if (!info)
-		return false;
-
 	return nf_osf_match(skb, xt_family(p), xt_hooknum(p), xt_in(p),
-			    xt_out(p), info, net, nf_osf_fingers);
+			    xt_out(p), p->matchinfo, xt_net(p), nf_osf_fingers);
 }
 
 static struct xt_match xt_osf_match = {
-- 
2.11.0
