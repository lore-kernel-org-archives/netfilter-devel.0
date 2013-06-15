From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 1/3] nat: xml: fix xml_snprintf buffer offset
Date: Sat, 15 Jun 2013 03:16:03 +0200
Message-ID: <20130615011603.3778.67261.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:54363 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752857Ab3FOBQH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Jun 2013 21:16:07 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fix the buffer offset of the nat snprintf function,
so elements are properly printed.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/nat.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/src/expr/nat.c b/src/expr/nat.c
index a76f5b5..448d2e3 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -336,19 +336,21 @@ nft_rule_expr_nat_snprintf_xml(char *buf, size_t size,
 		break;
 	}
 
-	ret = snprintf(buf, len, "<family>%s</family>",
+	ret = snprintf(buf+offset, len, "<family>%s</family>",
 		       nat->family == AF_INET ? "AF_INET" : "AF_INET6");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	if (e->flags & (1 << NFT_EXPR_NAT_REG_ADDR_MIN)) {
-		ret = snprintf(buf, len, "<sreg_addr_min_v4>%u</sreg_addr_min_v4>"
-				" <sreg_addr_max_v4>%u</sreg_addr_max_v4> ",
+		ret = snprintf(buf+offset, len,
+				"<sreg_addr_min_v4>%u</sreg_addr_min_v4>"
+				"<sreg_addr_max_v4>%u</sreg_addr_max_v4>",
 			       nat->sreg_addr_min, nat->sreg_addr_max);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
 	if (e->flags & (1 << NFT_EXPR_NAT_REG_PROTO_MIN)) {
-		ret = snprintf(buf, len, "<sreg_proto_min>%u</sreg_proto_min>"
+		ret = snprintf(buf+offset, len,
+				"<sreg_proto_min>%u</sreg_proto_min>"
 				"<sreg_proto_max>%u</sreg_proto_max>",
 		       nat->sreg_proto_min, nat->sreg_proto_max);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);

