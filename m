From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/9] netfilter: nft_dynset: do not reject set updates with NFT_SET_EVAL
Date: Wed, 13 Jun 2018 12:56:54 +0200
Message-ID: <20180613105700.12894-4-pablo@netfilter.org>
References: <20180613105700.12894-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180613105700.12894-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

NFT_SET_EVAL is signalling the kernel that this sets can be updated from
the evaluation path, even if there are no expressions attached to the
element. Otherwise, set updates with no expressions fail. Update
description to describe the right semantics.

Fixes: 22fe54d5fefc ("netfilter: nf_tables: add support for dynamic set updates")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h | 2 +-
 net/netfilter/nft_dynset.c               | 4 +---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index c9bf74b94f37..89438e68dc03 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -266,7 +266,7 @@ enum nft_rule_compat_attributes {
  * @NFT_SET_INTERVAL: set contains intervals
  * @NFT_SET_MAP: set is used as a dictionary
  * @NFT_SET_TIMEOUT: set uses timeouts
- * @NFT_SET_EVAL: set contains expressions for evaluation
+ * @NFT_SET_EVAL: set can be updated from the evaluation path
  * @NFT_SET_OBJECT: set contains stateful objects
  */
 enum nft_set_flags {
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 4d49529cff61..27d7e4598ab6 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -203,9 +203,7 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 				goto err1;
 			set->ops->gc_init(set);
 		}
-
-	} else if (set->flags & NFT_SET_EVAL)
-		return -EINVAL;
+	}
 
 	nft_set_ext_prepare(&priv->tmpl);
 	nft_set_ext_add_length(&priv->tmpl, NFT_SET_EXT_KEY, set->klen);
-- 
2.11.0
