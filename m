From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 03/10] src: treat ip6 nexthdr as a protocol
Date: Tue,  9 May 2017 17:51:15 +0200
Message-ID: <20170509155122.26356-4-fw@strlen.de>
References: <20170509155122.26356-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:44552 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755743AbdEIPvU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 May 2017 11:51:20 -0400
In-Reply-To: <20170509155122.26356-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ip6 nexthdr tcp tcp dport 22
will now inject a (useless) meta l4 dependency as ip6 nexthdr is no
longer flagged as EXPR_F_PROTOCOL.

Avoid this if user really specified a test for ip6hdr->nexthdr.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/payload.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/src/payload.c b/src/payload.c
index 55128fee1498..3a3fe8de97cf 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -117,6 +117,23 @@ static const struct expr_ops payload_expr_ops = {
 	.pctx_update	= payload_expr_pctx_update,
 };
 
+/*
+ * ipv6 is special case, we normally use 'meta l4proto' to fetch the last
+ * l4 header of the ipv6 extension header chain so we will also match
+ * tcp after a fragmentation header, for instance.
+ *
+ * If user specifically asks for nexthdr x, treat is as a full
+ * dependency rather than injecting another (useless) meta l4 one.
+ */
+static bool proto_key_is_protocol(const struct proto_desc *desc, unsigned int type)
+{
+	if (type == desc->protocol_key ||
+	    (desc == &proto_ip6 && type == IP6HDR_NEXTHDR))
+		return true;
+
+	return false;
+}
+
 struct expr *payload_expr_alloc(const struct location *loc,
 				const struct proto_desc *desc,
 				unsigned int type)
@@ -129,7 +146,7 @@ struct expr *payload_expr_alloc(const struct location *loc,
 	if (desc != NULL) {
 		tmpl = &desc->templates[type];
 		base = desc->base;
-		if (type == desc->protocol_key)
+		if (proto_key_is_protocol(desc, type))
 			flags = EXPR_F_PROTOCOL;
 	} else {
 		tmpl = &proto_unknown_template;
-- 
2.10.2

