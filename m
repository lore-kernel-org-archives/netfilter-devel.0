From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 2/4] expr: payload: get a nft_rule_expr type in nft_rule_expr_payload_snprintf_* functions.
Date: Sun, 22 Jun 2014 20:32:19 +0200
Message-ID: <1403461941-21605-3-git-send-email-anarey@gmail.com>
References: <1403461941-21605-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:55074 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbaFVScf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 22 Jun 2014 14:32:35 -0400
Received: by mail-wg0-f46.google.com with SMTP id y10so5672154wgg.17
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Jun 2014 11:32:34 -0700 (PDT)
In-Reply-To: <1403461941-21605-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Code refactoring in nft_rule_expr_payload_snprintf_* functions to get a
nft_rule_expr type instead of nft_expr_payload type. The nft_rule_expr is
needed to check information into flags variables.

Moreover, It remanes a variable from 'p' to 'payload' for code
readability reasons.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/payload.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/src/expr/payload.c b/src/expr/payload.c
index 90322c1..6c08e48 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -165,15 +165,17 @@ static const char *base2str(enum nft_payload_bases base)
 
 static int
 nft_rule_expr_payload_snprintf_json(char *buf, size_t len, uint32_t flags,
-				   struct nft_expr_payload *p)
+				   struct nft_rule_expr *e)
 {
+	struct nft_expr_payload *payload = nft_expr_data(e);
 	int size = len, offset = 0, ret;
 
 	ret = snprintf(buf, len, "\"dreg\":%u,"
 				 "\"offset\":%u,"
 				 "\"len\":%u,"
 				 "\"base\":\"%s\"",
-		       p->dreg, p->offset, p->len, base2str(p->base));
+		       payload->dreg, payload->offset, payload->len,
+		       base2str(payload->base));
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	return offset;
@@ -281,15 +283,17 @@ nft_rule_expr_payload_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 
 static int
 nft_rule_expr_payload_snprintf_xml(char *buf, size_t len, uint32_t flags,
-				   struct nft_expr_payload *p)
+				   struct nft_rule_expr *e)
 {
+	struct nft_expr_payload *payload = nft_expr_data(e);
 	int size = len, offset = 0, ret;
 
 	ret = snprintf(buf, len, "<dreg>%u</dreg>"
 				 "<offset>%u</offset>"
 				 "<len>%u</len>"
 				 "<base>%s</base>",
-		       p->dreg, p->offset, p->len, base2str(p->base));
+		       payload->dreg, payload->offset, payload->len,
+		       base2str(payload->base));
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	return offset;
@@ -307,11 +311,9 @@ nft_rule_expr_payload_snprintf(char *buf, size_t len, uint32_t type,
 				payload->len, base2str(payload->base),
 				payload->offset, payload->dreg);
 	case NFT_OUTPUT_XML:
-		return nft_rule_expr_payload_snprintf_xml(buf, len, flags,
-							  payload);
+		return nft_rule_expr_payload_snprintf_xml(buf, len, flags, e);
 	case NFT_OUTPUT_JSON:
-		return nft_rule_expr_payload_snprintf_json(buf, len, flags,
-							  payload);
+		return nft_rule_expr_payload_snprintf_json(buf, len, flags, e);
 	default:
 		break;
 	}
-- 
2.0.0

