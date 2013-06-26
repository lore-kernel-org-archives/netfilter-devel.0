From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 19/21] nat: snprintf: fix buffer offset
Date: Wed, 26 Jun 2013 13:37:19 +0200
Message-ID: <20130626113719.23511.1621.stgit@nfdev.cica.es>
References: <20130626113509.23511.14359.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:54710 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752138Ab3FZLh1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:37:27 -0400
In-Reply-To: <20130626113509.23511.14359.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fix the buffer offset necesary to print correctly the nat expr in a default output mode.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/nat.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/expr/nat.c b/src/expr/nat.c
index 7d83154..378d053 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -383,18 +383,18 @@ nft_rule_expr_nat_snprintf_default(char *buf, size_t size,
 		break;
 	}
 
-	ret = snprintf(buf, len, "family=%s ", nft_family2str(nat->family));
+	ret = snprintf(buf+offset, len, "family=%s ", nft_family2str(nat->family));
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	if (e->flags & (1 << NFT_EXPR_NAT_REG_ADDR_MIN)) {
-		ret = snprintf(buf, len,
+		ret = snprintf(buf+offset, len,
 			       "sreg_addr_min_v4=%u sreg_addr_max_v4=%u ",
 			       nat->sreg_addr_min, nat->sreg_addr_max);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
 	if (e->flags & (1 << NFT_EXPR_NAT_REG_PROTO_MIN)) {
-		ret = snprintf(buf, len,
+		ret = snprintf(buf+offset, len,
 			       "sreg_proto_min=%u sreg_proto_max=%u ",
 			       nat->sreg_proto_min, nat->sreg_proto_max);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);

