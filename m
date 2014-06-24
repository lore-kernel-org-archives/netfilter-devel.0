From: Florian Westphal <fw@strlen.de>
Subject: [PATCH lnf-ct] conntrack: compare: relax MARK/ZONE attribute comparision
Date: Tue, 24 Jun 2014 12:02:09 +0200
Message-ID: <1403604129-8396-1-git-send-email-fw@strlen.de>
References: <CAGCkEt2p3rwpVGd1r-Uf92EiY7keWYCRKEPhW-hEQAXb+-DPNw@mail.gmail.com>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52297 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752014AbaFXKIW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Jun 2014 06:08:22 -0400
In-Reply-To: <CAGCkEt2p3rwpVGd1r-Uf92EiY7keWYCRKEPhW-hEQAXb+-DPNw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Relax checking for MARK and ZONE to treat 'attribute not
set' like 'attribute is set to 0'.

This matches kernel behaviour, conntracks are always in zone 0,
except if specified differently.  Same for connmark.

The kernel will also not include the zone/mark attributes in dumps
unless they have non-zero values.

This makes qa/test_api pass again with the updated test cases.

Reported-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 This is what I hacked up, your updated test cases pass with this patch
 applied.

 I'll push it soon if there are no further objections.

 src/conntrack/compare.c | 87 +++++++++++++++++++++++++------------------------
 1 file changed, 45 insertions(+), 42 deletions(-)

diff --git a/src/conntrack/compare.c b/src/conntrack/compare.c
index f4a194a..e15ba93 100644
--- a/src/conntrack/compare.c
+++ b/src/conntrack/compare.c
@@ -8,6 +8,7 @@
  */
 
 #include "internal/internal.h"
+#include <stdbool.h>
 
 static int __cmp(int attr,
 		 const struct nf_conntrack *ct1, 
@@ -15,7 +16,7 @@ static int __cmp(int attr,
 		 unsigned int flags,
 		 int (*cmp)(const struct nf_conntrack *ct1,
 		 	    const struct nf_conntrack *ct2,
-			    unsigned int flags))
+			    unsigned int flags), bool strict)
 {
 	int a = test_bit(attr, ct1->head.set);
 	int b = test_bit(attr, ct2->head.set);
@@ -25,9 +26,9 @@ static int __cmp(int attr,
 		return 1;
 	} else if (flags & NFCT_CMP_MASK &&
 		   test_bit(attr, ct1->head.set)) {
-		return 0;
+		return strict ? 0 : cmp(ct1, ct2, flags);
 	} else if (flags & NFCT_CMP_STRICT) {
-		return 0;
+		return strict ? 0 : cmp(ct1, ct2, flags);
 	}
 	return 1;
 }
@@ -93,11 +94,11 @@ cmp_orig_l4proto(const struct nf_conntrack *ct1,
 	switch(ct1->head.orig.protonum) {
 	case IPPROTO_ICMP:
 	case IPPROTO_ICMPV6:
-		if (!__cmp(ATTR_ICMP_ID, ct1, ct2, flags, cmp_icmp_id))
+		if (!__cmp(ATTR_ICMP_ID, ct1, ct2, flags, cmp_icmp_id, true))
 			return 0;
-		if (!__cmp(ATTR_ICMP_CODE, ct1, ct2, flags, cmp_icmp_code))
+		if (!__cmp(ATTR_ICMP_CODE, ct1, ct2, flags, cmp_icmp_code, true))
 			return 0;
-		if (!__cmp(ATTR_ICMP_TYPE, ct1, ct2, flags, cmp_icmp_type))
+		if (!__cmp(ATTR_ICMP_TYPE, ct1, ct2, flags, cmp_icmp_type, true))
 			return 0;
 		break;
 	case IPPROTO_TCP:
@@ -105,11 +106,11 @@ cmp_orig_l4proto(const struct nf_conntrack *ct1,
 	case IPPROTO_UDPLITE:
 	case IPPROTO_DCCP:
 	case IPPROTO_SCTP:
-		if (!__cmp(ATTR_ORIG_PORT_SRC, ct1, ct2, 
-			       flags, cmp_orig_port_src))
+		if (!__cmp(ATTR_ORIG_PORT_SRC, ct1, ct2,
+			       flags, cmp_orig_port_src, true))
 			return 0;
 		if (!__cmp(ATTR_ORIG_PORT_DST, ct1, ct2,
-			       flags, cmp_orig_port_dst))
+			       flags, cmp_orig_port_dst, true))
 			return 0;
 		break;
 	}
@@ -152,17 +153,17 @@ int __cmp_orig(const struct nf_conntrack *ct1,
 	       const struct nf_conntrack *ct2,
 	       unsigned int flags)
 {
-	if (!__cmp(ATTR_ORIG_L3PROTO, ct1, ct2, flags, cmp_orig_l3proto))
+	if (!__cmp(ATTR_ORIG_L3PROTO, ct1, ct2, flags, cmp_orig_l3proto, true))
 		return 0;
-	if (!__cmp(ATTR_ORIG_L4PROTO, ct1, ct2, flags, cmp_orig_l4proto))
+	if (!__cmp(ATTR_ORIG_L4PROTO, ct1, ct2, flags, cmp_orig_l4proto, true))
 		return 0;
-	if (!__cmp(ATTR_ORIG_IPV4_SRC, ct1, ct2, flags, cmp_orig_ipv4_src))
+	if (!__cmp(ATTR_ORIG_IPV4_SRC, ct1, ct2, flags, cmp_orig_ipv4_src, true))
 		return 0;
-	if (!__cmp(ATTR_ORIG_IPV4_DST, ct1, ct2, flags, cmp_orig_ipv4_dst))
+	if (!__cmp(ATTR_ORIG_IPV4_DST, ct1, ct2, flags, cmp_orig_ipv4_dst, true))
 		return 0;
-	if (!__cmp(ATTR_ORIG_IPV6_SRC, ct1, ct2, flags, cmp_orig_ipv6_src))
+	if (!__cmp(ATTR_ORIG_IPV6_SRC, ct1, ct2, flags, cmp_orig_ipv6_src, true))
 		return 0;
-	if (!__cmp(ATTR_ORIG_IPV6_DST, ct1, ct2, flags, cmp_orig_ipv6_dst))
+	if (!__cmp(ATTR_ORIG_IPV6_DST, ct1, ct2, flags, cmp_orig_ipv6_dst, true))
 		return 0;
 
 	return 1;
@@ -203,11 +204,11 @@ cmp_repl_l4proto(const struct nf_conntrack *ct1,
 	switch(ct1->repl.protonum) {
 	case IPPROTO_ICMP:
 	case IPPROTO_ICMPV6:
-		if (!__cmp(ATTR_ICMP_ID, ct1, ct2, flags, cmp_icmp_id))
+		if (!__cmp(ATTR_ICMP_ID, ct1, ct2, flags, cmp_icmp_id, true))
 			return 0;
-		if (!__cmp(ATTR_ICMP_CODE, ct1, ct2, flags, cmp_icmp_code))
+		if (!__cmp(ATTR_ICMP_CODE, ct1, ct2, flags, cmp_icmp_code, true))
 			return 0;
-		if (!__cmp(ATTR_ICMP_TYPE, ct1, ct2, flags, cmp_icmp_type))
+		if (!__cmp(ATTR_ICMP_TYPE, ct1, ct2, flags, cmp_icmp_type, true))
 			return 0;
 		break;
 	case IPPROTO_TCP:
@@ -215,11 +216,11 @@ cmp_repl_l4proto(const struct nf_conntrack *ct1,
 	case IPPROTO_UDPLITE:
 	case IPPROTO_DCCP:
 	case IPPROTO_SCTP:
-		if (!__cmp(ATTR_REPL_PORT_SRC, ct1, ct2, 
-			       flags, cmp_repl_port_src))
+		if (!__cmp(ATTR_REPL_PORT_SRC, ct1, ct2,
+			       flags, cmp_repl_port_src, true))
 			return 0;
 		if (!__cmp(ATTR_REPL_PORT_DST, ct1, ct2,
-			       flags, cmp_repl_port_dst))
+			       flags, cmp_repl_port_dst, true))
 			return 0;
 		break;
 	}
@@ -262,17 +263,17 @@ static int cmp_repl(const struct nf_conntrack *ct1,
 		    const struct nf_conntrack *ct2,
 		    unsigned int flags)
 {
-	if (!__cmp(ATTR_REPL_L3PROTO, ct1, ct2, flags, cmp_repl_l3proto))
+	if (!__cmp(ATTR_REPL_L3PROTO, ct1, ct2, flags, cmp_repl_l3proto, true))
 		return 0;
-	if (!__cmp(ATTR_REPL_L4PROTO, ct1, ct2, flags, cmp_repl_l4proto))
+	if (!__cmp(ATTR_REPL_L4PROTO, ct1, ct2, flags, cmp_repl_l4proto, true))
 		return 0;
-	if (!__cmp(ATTR_REPL_IPV4_SRC, ct1, ct2, flags, cmp_repl_ipv4_src))
+	if (!__cmp(ATTR_REPL_IPV4_SRC, ct1, ct2, flags, cmp_repl_ipv4_src, true))
 		return 0;
-	if (!__cmp(ATTR_REPL_IPV4_DST, ct1, ct2, flags, cmp_repl_ipv4_dst))
+	if (!__cmp(ATTR_REPL_IPV4_DST, ct1, ct2, flags, cmp_repl_ipv4_dst, true))
 		return 0;
-	if (!__cmp(ATTR_REPL_IPV6_SRC, ct1, ct2, flags, cmp_repl_ipv6_src))
+	if (!__cmp(ATTR_REPL_IPV6_SRC, ct1, ct2, flags, cmp_repl_ipv6_src, true))
 		return 0;
-	if (!__cmp(ATTR_REPL_IPV6_DST, ct1, ct2, flags, cmp_repl_ipv6_dst))
+	if (!__cmp(ATTR_REPL_IPV6_DST, ct1, ct2, flags, cmp_repl_ipv6_dst, true))
 		return 0;
 
 	return 1;
@@ -286,12 +287,13 @@ cmp_id(const struct nf_conntrack *ct1,
 	return (ct1->id == ct2->id);
 }
 
-static int 
+static int
 cmp_mark(const struct nf_conntrack *ct1,
 	 const struct nf_conntrack *ct2,
 	 unsigned int flags)
 {
-	return (ct1->mark == ct2->mark);
+	return nfct_get_attr_u32(ct1, ATTR_MARK) ==
+	       nfct_get_attr_u32(ct2, ATTR_MARK);
 }
 
 static int 
@@ -352,12 +354,13 @@ cmp_dccp_state(const struct nf_conntrack *ct1,
 	return (ct1->protoinfo.dccp.state == ct2->protoinfo.dccp.state);
 }
 
-static int 
+static int
 cmp_zone(const struct nf_conntrack *ct1,
 	 const struct nf_conntrack *ct2,
 	 unsigned int flags)
 {
-	return (ct1->zone == ct2->zone);
+	return nfct_get_attr_u16(ct1, ATTR_ZONE) ==
+	       nfct_get_attr_u16(ct2, ATTR_ZONE);
 }
 
 static int
@@ -419,27 +422,27 @@ static int cmp_meta(const struct nf_conntrack *ct1,
 		    const struct nf_conntrack *ct2,
 		    unsigned int flags)
 {
-	if (!__cmp(ATTR_ID, ct1, ct2, flags, cmp_id))
+	if (!__cmp(ATTR_ID, ct1, ct2, flags, cmp_id, true))
 		return 0;
-	if (!__cmp(ATTR_MARK, ct1, ct2, flags, cmp_mark))
+	if (!__cmp(ATTR_MARK, ct1, ct2, flags, cmp_mark, false))
 		return 0;
-	if (!__cmp(ATTR_TIMEOUT, ct1, ct2, flags, cmp_timeout))
+	if (!__cmp(ATTR_TIMEOUT, ct1, ct2, flags, cmp_timeout, true))
 		return 0;
-	if (!__cmp(ATTR_STATUS, ct1, ct2, flags, cmp_status))
+	if (!__cmp(ATTR_STATUS, ct1, ct2, flags, cmp_status, true))
 		return 0;
-	if (!__cmp(ATTR_TCP_STATE, ct1, ct2, flags, cmp_tcp_state))
+	if (!__cmp(ATTR_TCP_STATE, ct1, ct2, flags, cmp_tcp_state, true))
 		return 0;
-	if (!__cmp(ATTR_SCTP_STATE, ct1, ct2, flags, cmp_sctp_state))
+	if (!__cmp(ATTR_SCTP_STATE, ct1, ct2, flags, cmp_sctp_state, true))
 		return 0;
-	if (!__cmp(ATTR_DCCP_STATE, ct1, ct2, flags, cmp_dccp_state))
+	if (!__cmp(ATTR_DCCP_STATE, ct1, ct2, flags, cmp_dccp_state, true))
 		return 0;
-	if (!__cmp(ATTR_ZONE, ct1, ct2, flags, cmp_zone))
+	if (!__cmp(ATTR_ZONE, ct1, ct2, flags, cmp_zone, false))
 		return 0;
-	if (!__cmp(ATTR_SECCTX, ct1, ct2, flags, cmp_secctx))
+	if (!__cmp(ATTR_SECCTX, ct1, ct2, flags, cmp_secctx, true))
 		return 0;
-	if (!__cmp(ATTR_CONNLABELS, ct1, ct2, flags, cmp_clabel))
+	if (!__cmp(ATTR_CONNLABELS, ct1, ct2, flags, cmp_clabel, true))
 		return 0;
-	if (!__cmp(ATTR_CONNLABELS_MASK, ct1, ct2, flags, cmp_clabel_mask))
+	if (!__cmp(ATTR_CONNLABELS_MASK, ct1, ct2, flags, cmp_clabel_mask, true))
 		return 0;
 
 	return 1;
-- 
1.8.1.5

