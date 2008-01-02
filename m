From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 19/27] xt_policy: use the new unoin nf_inet_addr
Date: Wed, 2 Jan 2008 21:30:44 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801022130340.14900@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56943 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105AbYABUaq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:30:46 -0500
In-Reply-To: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 3ee575c6ed06528d7bde3c59b8f8898de1eafd4e
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Wed Jan 2 18:25:38 2008 +0100

    [NETFILTER]: xt_policy: use the new unoin nf_inet_addr
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

 include/linux/netfilter/xt_policy.h |   23 +++++++++++++++++++----
 net/netfilter/xt_policy.c           |   15 ++++++++-------
 2 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/include/linux/netfilter/xt_policy.h b/include/linux/netfilter/xt_policy.h
index 45654d3..053d8cc 100644
--- a/include/linux/netfilter/xt_policy.h
+++ b/include/linux/netfilter/xt_policy.h
@@ -27,18 +27,33 @@ struct xt_policy_spec
 			reqid:1;
 };
 
+#ifndef __KERNEL__
 union xt_policy_addr
 {
 	struct in_addr	a4;
 	struct in6_addr	a6;
 };
+#endif
 
 struct xt_policy_elem
 {
-	union xt_policy_addr	saddr;
-	union xt_policy_addr	smask;
-	union xt_policy_addr	daddr;
-	union xt_policy_addr	dmask;
+	union {
+#ifdef __KERNEL__
+		struct {
+			union nf_inet_addr saddr;
+			union nf_inet_addr smask;
+			union nf_inet_addr daddr;
+			union nf_inet_addr dmask;
+		};
+#else
+		struct {
+			union xt_policy_addr saddr;
+			union xt_policy_addr smask;
+			union xt_policy_addr daddr;
+			union xt_policy_addr dmask;
+		};
+#endif
+	};
 	__be32			spi;
 	u_int32_t		reqid;
 	u_int8_t		proto;
diff --git a/net/netfilter/xt_policy.c b/net/netfilter/xt_policy.c
index 46ee7e8..ae5caa1 100644
--- a/net/netfilter/xt_policy.c
+++ b/net/netfilter/xt_policy.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <net/xfrm.h>
 
+#include <linux/netfilter.h>
 #include <linux/netfilter/xt_policy.h>
 #include <linux/netfilter/x_tables.h>
 
@@ -21,14 +22,14 @@ MODULE_DESCRIPTION("Xtables IPsec policy matching module");
 MODULE_LICENSE("GPL");
 
 static inline bool
-xt_addr_cmp(const union xt_policy_addr *a1, const union xt_policy_addr *m,
-	    const union xt_policy_addr *a2, unsigned short family)
+xt_addr_cmp(const union nf_inet_addr *a1, const union nf_inet_addr *m,
+	    const union nf_inet_addr *a2, unsigned short family)
 {
 	switch (family) {
 	case AF_INET:
-		return !((a1->a4.s_addr ^ a2->a4.s_addr) & m->a4.s_addr);
+		return ((a1->ip ^ a2->ip) & m->ip) == 0;
 	case AF_INET6:
-		return !ipv6_masked_addr_cmp(&a1->a6, &m->a6, &a2->a6);
+		return ipv6_masked_addr_cmp(&a1->in6, &m->in6, &a2->in6) == 0;
 	}
 	return false;
 }
@@ -38,12 +39,12 @@ match_xfrm_state(const struct xfrm_state *x, const struct xt_policy_elem *e,
 		 unsigned short family)
 {
 #define MATCH_ADDR(x,y,z)	(!e->match.x ||			       \
-				 (xt_addr_cmp(&e->x, &e->y, (z), family) \
+				 (xt_addr_cmp(&e->x, &e->y, (const union nf_inet_addr *)(z), family) \
 				  ^ e->invert.x))
 #define MATCH(x,y)		(!e->match.x || ((e->x == (y)) ^ e->invert.x))
 
-	return MATCH_ADDR(saddr, smask, (union xt_policy_addr *)&x->props.saddr) &&
-	       MATCH_ADDR(daddr, dmask, (union xt_policy_addr *)&x->id.daddr) &&
+	return MATCH_ADDR(saddr, smask, &x->props.saddr) &&
+	       MATCH_ADDR(daddr, dmask, &x->id.daddr) &&
 	       MATCH(proto, x->id.proto) &&
 	       MATCH(mode, x->props.mode) &&
 	       MATCH(spi, x->id.spi) &&
