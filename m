From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] src: get and set NFT_*_ATTR_FAMILY
Date: Sun, 31 Mar 2013 03:15:19 +0200
Message-ID: <20130331011519.15604.62461.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:42444 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755284Ab3CaBPb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Mar 2013 21:15:31 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds support to get and set the attribute NFT_{TABLE|CHAIN|RULE}_ATTR_FAMILY easily.

I found this very useful when parsing a XML table|chain|rule (future patch).
---
 src/chain.c |    9 +++++++++
 src/rule.c  |    3 +++
 src/table.c |    8 ++++++++
 3 files changed, 20 insertions(+)

diff --git a/src/chain.c b/src/chain.c
index 1b1c3fe..9d77179 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -90,6 +90,9 @@ void nft_chain_attr_set(struct nft_chain *c, uint16_t attr, void *data)
 	case NFT_CHAIN_ATTR_HANDLE:
 		c->handle = *((uint64_t *)data);
 		break;
+	case NFT_CHAIN_ATTR_FAMILY:
+		c->family = *((uint8_t *)data);
+		break;
 	case NFT_CHAIN_ATTR_TYPE:
 		if (c->type)
 			free(c->type);
@@ -177,6 +180,12 @@ void *nft_chain_attr_get(struct nft_chain *c, uint16_t attr)
 		else
 			return NULL;
 		break;
+	case NFT_CHAIN_ATTR_FAMILY:
+		if (c->flags & (1 << NFT_CHAIN_ATTR_FAMILY))
+			return &c->family;
+		else
+			return NULL;
+		break;
 	case NFT_CHAIN_ATTR_TYPE:
 		if (c->flags & (1 << NFT_CHAIN_ATTR_TYPE))
 			return c->type;
diff --git a/src/rule.c b/src/rule.c
index 501b4f6..57b849d 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -96,6 +96,9 @@ void nft_rule_attr_set(struct nft_rule *r, uint16_t attr, void *data)
 	case NFT_RULE_ATTR_COMPAT_FLAGS:
 		r->compat.flags = *((uint32_t *)data);
 		break;
+	case NFT_RULE_ATTR_FAMILY:
+		r->family = *((uint8_t *)data);
+		break;
 	default:
 		return;
 	}
diff --git a/src/table.c b/src/table.c
index d2e07db..f109cdd 100644
--- a/src/table.c
+++ b/src/table.c
@@ -61,6 +61,10 @@ void nft_table_attr_set(struct nft_table *t, uint16_t attr, void *data)
 		t->table_flags = *((uint32_t *)data);
 		t->flags |= (1 << NFT_TABLE_ATTR_FLAGS);
 		break;
+	case NFT_TABLE_ATTR_FAMILY:
+		t->family = *((uint8_t *)data);
+		t->flags |= (1 << NFT_TABLE_ATTR_FAMILY);
+		break;
 	}
 }
 EXPORT_SYMBOL(nft_table_attr_set);
@@ -84,6 +88,10 @@ const void *nft_table_attr_get(struct nft_table *t, uint16_t attr)
 		if (t->flags & (1 << NFT_TABLE_ATTR_FLAGS))
 			ret = &t->table_flags;
 		break;
+	case NFT_TABLE_ATTR_FAMILY:
+		if (t->flags & (1 << NFT_TABLE_ATTR_FAMILY))
+			ret = &t->family;
+		break;
 	}
 	return ret;
 }

