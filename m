From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 05/21] expr: xml: validate registers < NFT_REG_MAX
Date: Wed, 26 Jun 2013 13:37:02 +0200
Message-ID: <20130626113702.23511.73961.stgit@nfdev.cica.es>
References: <20130626113509.23511.14359.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:54663 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751992Ab3FZLhK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:37:10 -0400
In-Reply-To: <20130626113509.23511.14359.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patchs add validations for all exprs that uses nft_registers to use a value < NFT_REG_MAX..

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/bitwise.c   |   10 ++++++++++
 src/expr/byteorder.c |    6 ++++++
 src/expr/cmp.c       |    5 +++++
 src/expr/ct.c        |    3 +++
 src/expr/exthdr.c    |    5 +++++
 src/expr/immediate.c |    5 +++++
 src/expr/lookup.c    |   10 ++++++++++
 src/expr/meta.c      |    5 +++++
 src/expr/payload.c   |    5 +++++
 9 files changed, 54 insertions(+)

diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index 6932086..35167db 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -237,6 +237,11 @@ nft_rule_expr_bitwise_xml_parse(struct nft_rule_expr *e, char *xml)
 		return -1;
 	}
 
+	if (tmp > NFT_REG_MAX) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
 	bitwise->sreg = (uint32_t)tmp;
 	e->flags |= (1 << NFT_EXPR_BITWISE_SREG);
 
@@ -252,6 +257,11 @@ nft_rule_expr_bitwise_xml_parse(struct nft_rule_expr *e, char *xml)
 		return -1;
 	}
 
+	if (tmp > NFT_REG_MAX) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
 	bitwise->dreg = (uint32_t)tmp;
 	e->flags |= (1 << NFT_EXPR_BITWISE_DREG);
 
diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index 201a943..c2f38a8 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -225,6 +225,9 @@ nft_rule_expr_byteorder_xml_parse(struct nft_rule_expr *e, char *xml)
 	if (tmp > UINT32_MAX || tmp < 0 || *endptr)
 		goto err;
 
+	if (tmp > NFT_REG_MAX)
+		goto err;
+
 	byteorder->sreg = tmp;
 	e->flags |= (1 << NFT_EXPR_BYTEORDER_SREG);
 
@@ -236,6 +239,9 @@ nft_rule_expr_byteorder_xml_parse(struct nft_rule_expr *e, char *xml)
 	if (tmp > UINT32_MAX || tmp < 0 || *endptr)
 		goto err;
 
+	if (tmp > NFT_REG_MAX)
+		goto err;
+
 	byteorder->dreg = tmp;
 	e->flags |= (1 << NFT_EXPR_BYTEORDER_DREG);
 
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index dac1f54..9507a0e 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -203,6 +203,11 @@ static int nft_rule_expr_cmp_xml_parse(struct nft_rule_expr *e, char *xml)
 			return -1;
 		}
 
+		if (tmp > NFT_REG_MAX) {
+			mxmlDelete(tree);
+			return -1;
+		}
+
 		cmp->sreg = (uint8_t)tmp;
 		e->flags |= (1 << NFT_EXPR_CMP_SREG);
 	}
diff --git a/src/expr/ct.c b/src/expr/ct.c
index 7a239fa..61a8fef 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -177,6 +177,9 @@ static int nft_rule_expr_ct_xml_parse(struct nft_rule_expr *e, char *xml)
 	if (tmp > UINT8_MAX || tmp < 0 || *endptr)
 		goto err;
 
+	if (tmp > NFT_REG_MAX)
+		goto err;
+
 	ct->dreg = tmp;
 	e->flags |= (1 << NFT_EXPR_CT_DREG);
 
diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index 8af6a63..7e16878 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -205,6 +205,11 @@ nft_rule_expr_exthdr_xml_parse(struct nft_rule_expr *e, char *xml)
 			return -1;
 		}
 
+		if (tmp > NFT_REG_MAX) {
+			mxmlDelete(tree);
+			return -1;
+		}
+
 		exthdr->dreg = tmp;
 		e->flags |= (1 << NFT_EXPR_EXTHDR_DREG);
 	}
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index b5a6a41..8bc810c 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -236,6 +236,11 @@ nft_rule_expr_immediate_xml_parse(struct nft_rule_expr *e, char *xml)
 		return -1;
 	}
 
+	if (tmp > NFT_REG_MAX) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
 	imm->dreg = (uint32_t)tmp;
 	e->flags |= (1 << NFT_EXPR_IMM_DREG);
 
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index 0ae93ce..ecc07cb 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -204,6 +204,11 @@ nft_rule_expr_lookup_xml_parse(struct nft_rule_expr *e, char *xml)
 		return -1;
 	}
 
+	if (tmp > NFT_REG_MAX) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
 	lookup->sreg = (uint32_t)tmp;
 	e->flags |= (1 << NFT_EXPR_LOOKUP_SREG);
 
@@ -217,6 +222,11 @@ nft_rule_expr_lookup_xml_parse(struct nft_rule_expr *e, char *xml)
 			return -1;
 		}
 
+		if (tmp > NFT_REG_MAX) {
+			mxmlDelete(tree);
+			return -1;
+		}
+
 		lookup->dreg = (uint32_t)tmp;
 		e->flags |= (1 << NFT_EXPR_LOOKUP_DREG);
 	}
diff --git a/src/expr/meta.c b/src/expr/meta.c
index 535b456..41fcff1 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -163,6 +163,11 @@ static int nft_rule_expr_meta_xml_parse(struct nft_rule_expr *e, char *xml)
 		return -1;
 	}
 
+	if (tmp > NFT_REG_MAX) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
 	meta->dreg = (uint8_t)tmp;
 	e->flags |= (1 << NFT_EXPR_META_DREG);
 
diff --git a/src/expr/payload.c b/src/expr/payload.c
index 28c52ca..dc42918 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -200,6 +200,11 @@ nft_rule_expr_payload_xml_parse(struct nft_rule_expr *e, char *xml)
 			return -1;
 		}
 
+		if (tmp > NFT_REG_MAX) {
+			mxmlDelete(tree);
+			return -1;
+		}
+
 		payload->dreg = (uint32_t)tmp;
 		e->flags |= (1 << NFT_EXPR_PAYLOAD_DREG);
 	}

