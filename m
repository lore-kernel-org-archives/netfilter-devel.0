From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 1/2] src: chain: delete useless castings
Date: Fri, 24 May 2013 13:28:41 +0200
Message-ID: <20130524112841.13209.37017.stgit@nfdev.cica.es>
References: <20130524112756.13209.37625.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:58200 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751596Ab3EXL2q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 May 2013 07:28:46 -0400
In-Reply-To: <20130524112756.13209.37625.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These casting were useless.


Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/chain.c        |    6 +++---
 src/expr/counter.c |    4 ++--
 src/rule.c         |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index b160cff..4146e6a 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -490,7 +490,7 @@ static int nft_chain_xml_parse(struct nft_chain *c, char *xml)
 		return -1;
 	}
 
-	c->handle = (uint64_t)utmp;
+	c->handle = utmp;
 	c->flags |= (1 << NFT_CHAIN_ATTR_HANDLE);
 
 	/* Get and set <chain bytes="x" ... >*/
@@ -503,7 +503,7 @@ static int nft_chain_xml_parse(struct nft_chain *c, char *xml)
 		mxmlDelete(tree);
 		return -1;
 	}
-	c->bytes = (uint64_t)utmp;
+	c->bytes = utmp;
 	c->flags |= (1 << NFT_CHAIN_ATTR_BYTES);
 
 	/* Get and set <chain packets="x" ... > */
@@ -516,7 +516,7 @@ static int nft_chain_xml_parse(struct nft_chain *c, char *xml)
 		mxmlDelete(tree);
 		return -1;
 	}
-	c->packets = (uint64_t)utmp;
+	c->packets = utmp;
 	c->flags |= (1 << NFT_CHAIN_ATTR_PACKETS);
 
 	/* Ignore <properties> node */
diff --git a/src/expr/counter.c b/src/expr/counter.c
index 633db3e..129f32e 100644
--- a/src/expr/counter.c
+++ b/src/expr/counter.c
@@ -160,7 +160,7 @@ nft_rule_expr_counter_xml_parse(struct nft_rule_expr *e, char *xml)
 			return -1;
 		}
 
-		ctr->pkts = (uint64_t)tmp;
+		ctr->pkts = tmp;
 		e->flags |= (1 << NFT_EXPR_CTR_PACKETS);
 	}
 
@@ -174,7 +174,7 @@ nft_rule_expr_counter_xml_parse(struct nft_rule_expr *e, char *xml)
 			return -1;
 		}
 
-		ctr->bytes = (uint64_t)tmp;
+		ctr->bytes = tmp;
 		e->flags |= (1 << NFT_EXPR_CTR_BYTES);
 	}
 
diff --git a/src/rule.c b/src/rule.c
index f000a77..318ae07 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -503,7 +503,7 @@ static int nft_rule_xml_parse(struct nft_rule *r, char *xml)
 		return -1;
 	}
 
-	r->handle = (uint64_t)tmp;
+	r->handle = tmp;
 	r->flags |= (1 << NFT_RULE_ATTR_HANDLE);
 
 	/* get and set <rule_flags> */

