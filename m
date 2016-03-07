From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH libnftnl] trace: fix multiple copy and paste errors
Date: Mon,  7 Mar 2016 12:01:17 +0100
Message-ID: <1457348477-13318-1-git-send-email-kaber@trash.net>
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49083 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbcCGLBZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Mar 2016 06:01:25 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix duplicated and incorrect assignments.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/trace.c | 51 +++++++++++++--------------------------------------
 1 file changed, 13 insertions(+), 38 deletions(-)

diff --git a/src/trace.c b/src/trace.c
index b04abb5..9655f0a 100644
--- a/src/trace.c
+++ b/src/trace.c
@@ -333,11 +333,6 @@ int nftnl_trace_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_trace *t)
 	if (!tb[NFTA_TRACE_TYPE])
 		abi_breakage();
 
-	if (tb[NFTA_TRACE_TABLE])
-		t->table = strdup(mnl_attr_get_str(tb[NFTA_TRACE_TABLE]));
-	if (tb[NFTA_TRACE_CHAIN])
-		t->chain = strdup(mnl_attr_get_str(tb[NFTA_TRACE_CHAIN]));
-
 	t->family = nfg->nfgen_family;
 	t->flags |= (1 << NFTNL_TRACE_FAMILY);
 
@@ -347,6 +342,16 @@ int nftnl_trace_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_trace *t)
 	t->id = ntohl(mnl_attr_get_u32(tb[NFTA_TRACE_ID]));
 	t->flags |= (1 << NFTNL_TRACE_ID);
 
+	if (tb[NFTA_TRACE_TABLE]) {
+		t->table = strdup(mnl_attr_get_str(tb[NFTA_TRACE_TABLE]));
+		t->flags |= (1 << NFTNL_TRACE_TABLE);
+	}
+
+	if (tb[NFTA_TRACE_CHAIN]) {
+		t->chain = strdup(mnl_attr_get_str(tb[NFTA_TRACE_CHAIN]));
+		t->flags |= (1 << NFTNL_TRACE_CHAIN);
+	}
+
 	if (tb[NFTA_TRACE_IIFTYPE]) {
 		t->iiftype = ntohs(mnl_attr_get_u16(tb[NFTA_TRACE_IIFTYPE]));
 		t->flags |= (1 << NFTNL_TRACE_IIFTYPE);
@@ -358,7 +363,7 @@ int nftnl_trace_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_trace *t)
 	}
 
 	if (tb[NFTA_TRACE_OIFTYPE]) {
-		t->iiftype = ntohs(mnl_attr_get_u16(tb[NFTA_TRACE_OIFTYPE]));
+		t->oiftype = ntohs(mnl_attr_get_u16(tb[NFTA_TRACE_OIFTYPE]));
 		t->flags |= (1 << NFTNL_TRACE_OIFTYPE);
 	}
 
@@ -390,49 +395,19 @@ int nftnl_trace_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_trace *t)
 		t->flags |= (1 << NFTNL_TRACE_TRANSPORT_HEADER);
 
 	if (tb[NFTA_TRACE_NFPROTO]) {
-		t->iiftype = ntohs(mnl_attr_get_u16(tb[NFTA_TRACE_NFPROTO]));
+		t->nfproto = ntohs(mnl_attr_get_u16(tb[NFTA_TRACE_NFPROTO]));
 		t->flags |= (1 << NFTNL_TRACE_NFPROTO);
 	}
 
 	if (tb[NFTA_TRACE_POLICY]) {
-		t->iiftype = ntohs(mnl_attr_get_u16(tb[NFTA_TRACE_POLICY]));
+		t->policy = ntohs(mnl_attr_get_u16(tb[NFTA_TRACE_POLICY]));
 		t->flags |= (1 << NFTNL_TRACE_POLICY);
 	}
 
-	if (tb[NFTA_TRACE_OIF]) {
-		t->oif = ntohl(mnl_attr_get_u32(tb[NFTA_TRACE_OIF]));
-		t->flags |= (1 << NFTNL_TRACE_OIF);
-	}
-
 	if (tb[NFTA_TRACE_MARK]) {
 		t->mark = ntohl(mnl_attr_get_u32(tb[NFTA_TRACE_MARK]));
 		t->flags |= (1 << NFTNL_TRACE_MARK);
 	}
 
-	if (tb[NFTA_TRACE_RULE_HANDLE]) {
-		t->rule_handle = be64toh(mnl_attr_get_u64(tb[NFTA_TRACE_RULE_HANDLE]));
-		t->flags |= (1 << NFTNL_TRACE_RULE_HANDLE);
-	}
-
-	if (tb[NFTA_TRACE_VERDICT])
-		nftnl_trace_parse_verdict(tb[NFTA_TRACE_VERDICT], t);
-
-	if (nftnl_trace_nlmsg_parse_hdrdata(tb[NFTA_TRACE_LL_HEADER], &t->ll))
-		t->flags |= (1 << NFTNL_TRACE_LL_HEADER);
-
-	if (nftnl_trace_nlmsg_parse_hdrdata(tb[NFTA_TRACE_NETWORK_HEADER], &t->nh))
-		t->flags |= (1 << NFTNL_TRACE_NETWORK_HEADER);
-
-	if (nftnl_trace_nlmsg_parse_hdrdata(tb[NFTA_TRACE_TRANSPORT_HEADER], &t->th))
-		t->flags |= (1 << NFTNL_TRACE_TRANSPORT_HEADER);
-
-	if (t->chain)
-		t->flags |= (1 << NFTNL_TRACE_CHAIN);
-
-	if (t->chain)
-		t->flags |= (1 << NFTNL_TRACE_CHAIN);
-	if (t->table)
-		t->flags |= (1 << NFTNL_TRACE_TABLE);
-
 	return 0;
 }
-- 
2.5.0

