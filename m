From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 5/6] netfilter: nf_tables: add set extensions
Date: Wed, 25 Mar 2015 13:07:49 +0000
Message-ID: <1427288870-26336-6-git-send-email-kaber@trash.net>
References: <1427288870-26336-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48264 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbbCYNH5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2015 09:07:57 -0400
In-Reply-To: <1427288870-26336-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add simple set extension infrastructure for maintaining variable sized
and optional per element data.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/net/netfilter/nf_tables.h | 105 ++++++++++++++++++++++++++++++++++++++
 net/netfilter/nf_tables_api.c     |  16 ++++++
 2 files changed, 121 insertions(+)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index ace67a5..038f8a6 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -311,6 +311,111 @@ int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
 void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
 			  struct nft_set_binding *binding);
 
+/**
+ *	enum nft_set_extensions - set extension type IDs
+ *
+ *	@NFT_SET_EXT_KEY: element key
+ *	@NFT_SET_EXT_DATA: mapping data
+ *	@NFT_SET_EXT_FLAGS: element flags
+ *	@NFT_SET_EXT_NUM: number of extension types
+ */
+enum nft_set_extensions {
+	NFT_SET_EXT_KEY,
+	NFT_SET_EXT_DATA,
+	NFT_SET_EXT_FLAGS,
+	NFT_SET_EXT_NUM
+};
+
+/**
+ *	struct nft_set_ext_type - set extension type
+ *
+ * 	@len: fixed part length of the extension
+ * 	@align: alignment requirements of the extension
+ */
+struct nft_set_ext_type {
+	u8	len;
+	u8	align;
+};
+
+extern const struct nft_set_ext_type nft_set_ext_types[];
+
+/**
+ *	struct nft_set_ext_tmpl - set extension template
+ *
+ *	@len: length of extension area
+ *	@offset: offsets of individual extension types
+ */
+struct nft_set_ext_tmpl {
+	u16	len;
+	u8	offset[NFT_SET_EXT_NUM];
+};
+
+/**
+ *	struct nft_set_ext - set extensions
+ *
+ *	@offset: offsets of individual extension types
+ *	@data: beginning of extension data
+ */
+struct nft_set_ext {
+	u8	offset[NFT_SET_EXT_NUM];
+	char	data[0];
+};
+
+static inline void nft_set_ext_prepare(struct nft_set_ext_tmpl *tmpl)
+{
+	memset(tmpl, 0, sizeof(*tmpl));
+	tmpl->len = sizeof(struct nft_set_ext);
+}
+
+static inline void nft_set_ext_add_length(struct nft_set_ext_tmpl *tmpl, u8 id,
+					  unsigned int len)
+{
+	tmpl->len	 = ALIGN(tmpl->len, nft_set_ext_types[id].align);
+	BUG_ON(tmpl->len > U8_MAX);
+	tmpl->offset[id] = tmpl->len;
+	tmpl->len	+= nft_set_ext_types[id].len + len;
+}
+
+static inline void nft_set_ext_add(struct nft_set_ext_tmpl *tmpl, u8 id)
+{
+	nft_set_ext_add_length(tmpl, id, 0);
+}
+
+static inline void nft_set_ext_init(struct nft_set_ext *ext,
+				    const struct nft_set_ext_tmpl *tmpl)
+{
+	memcpy(ext->offset, tmpl->offset, sizeof(ext->offset));
+}
+
+static inline bool __nft_set_ext_exists(const struct nft_set_ext *ext, u8 id)
+{
+	return !!ext->offset[id];
+}
+
+static inline bool nft_set_ext_exists(const struct nft_set_ext *ext, u8 id)
+{
+	return ext && __nft_set_ext_exists(ext, id);
+}
+
+static inline void *nft_set_ext(const struct nft_set_ext *ext, u8 id)
+{
+	return (void *)ext + ext->offset[id];
+}
+
+static inline struct nft_data *nft_set_ext_key(const struct nft_set_ext *ext)
+{
+	return nft_set_ext(ext, NFT_SET_EXT_KEY);
+}
+
+static inline struct nft_data *nft_set_ext_data(const struct nft_set_ext *ext)
+{
+	return nft_set_ext(ext, NFT_SET_EXT_DATA);
+}
+
+static inline u8 *nft_set_ext_flags(const struct nft_set_ext *ext)
+{
+	return nft_set_ext(ext, NFT_SET_EXT_FLAGS);
+}
 
 /**
  *	struct nft_expr_type - nf_tables expression type
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0b969b6..972c47f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2827,6 +2827,22 @@ void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
 		nf_tables_set_destroy(ctx, set);
 }
 
+const struct nft_set_ext_type nft_set_ext_types[] = {
+	[NFT_SET_EXT_KEY]		= {
+		.len	= sizeof(struct nft_data),
+		.align	= __alignof__(struct nft_data),
+	},
+	[NFT_SET_EXT_DATA]		= {
+		.len	= sizeof(struct nft_data),
+		.align	= __alignof__(struct nft_data),
+	},
+	[NFT_SET_EXT_FLAGS]		= {
+		.len	= sizeof(u8),
+		.align	= __alignof__(u8),
+	},
+};
+EXPORT_SYMBOL_GPL(nft_set_ext_types);
+
 /*
  * Set elements
  */
-- 
2.1.0

