Received: from localhost.localdomain (203.red-83-63-38.staticip.rima-tde.net [83.63.38.203])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5480630C605
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Aug 2025 12:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.63.38.203
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756385326; cv=none; b=MxTrF96mPmpsTjuk6WdZfOKy6xYE+KbotUPYNzaDB0VILq03GqJM6b7Kl7JUYQc9Tr0VwawtrBOudginQ+vby+U489ZjLlcZ1m55QdEv2fUFD3TjD9FLrGN74hRaszq3zlHtQIT6z9ZitX8HHSdgNoNTV18jiJA2v8F1hvyZDRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756385326; c=relaxed/simple;
	bh=o0lEhNTJ+I9o6PL0lyBLBu253wRIrWTsyr2+1wwSiRc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RQpSPgYeuoCoHGqInkapprlVwyWyF0iGl9GmMwl6d1t4B2CANNWUAjyRpC6N9JGjNnF1WKl1hKzmR/PMtvs39HYNQ4nfTB7C8YmcomPJMkVN0YG7a8kDE9XqZLs9mmP+RyAbCNZIPCJRaF18MmZ5Wr8Q3RhrkVm4LhdsFSwJ70g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de; spf=none smtp.mailfrom=localhost.localdomain; arc=none smtp.client-ip=83.63.38.203
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=localhost.localdomain
Received: by localhost.localdomain (Postfix, from userid 1000)
	id 5F64C2436032; Thu, 28 Aug 2025 14:48:37 +0200 (CEST)
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nf-next] netfilter: nft_payload: extend offset to 65535 bytes
Date: Thu, 28 Aug 2025 14:48:31 +0200
Message-ID: <20250828124831.4093-1-fmancera@suse.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In some situations 255 bytes offset is not enough to match or manipulate
the desired packet field. Increase the offset limit to 65535 or U16_MAX.

In addition, the nla policy maximum value is not set anymore as it is
limited to s16. Instead, the maximum value is checked during the payload
expression initialization function.

Tested with the nft command line tool.

table ip filter {
	chain output {
		@nh,2040,8 set 0xff
		@nh,524280,8 set 0xff
		@nh,524280,8 0xff
		@nh,2040,8 0xff
	}
}

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 include/net/netfilter/nf_tables_core.h |  2 +-
 net/netfilter/nft_payload.c            | 18 +++++++++++-------
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index 6c2f483d9828..7644cfe9267d 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -73,7 +73,7 @@ struct nft_ct {
 
 struct nft_payload {
 	enum nft_payload_bases	base:8;
-	u8			offset;
+	u16			offset;
 	u8			len;
 	u8			dreg;
 };
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 7dfc5343dae4..728a4c78775c 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -40,7 +40,7 @@ static bool nft_payload_rebuild_vlan_hdr(const struct sk_buff *skb, int mac_off,
 
 /* add vlan header into the user buffer for if tag was removed by offloads */
 static bool
-nft_payload_copy_vlan(u32 *d, const struct sk_buff *skb, u8 offset, u8 len)
+nft_payload_copy_vlan(u32 *d, const struct sk_buff *skb, u16 offset, u8 len)
 {
 	int mac_off = skb_mac_header(skb) - skb->data;
 	u8 *vlanh, *dst_u8 = (u8 *) d;
@@ -212,7 +212,7 @@ static const struct nla_policy nft_payload_policy[NFTA_PAYLOAD_MAX + 1] = {
 	[NFTA_PAYLOAD_SREG]		= { .type = NLA_U32 },
 	[NFTA_PAYLOAD_DREG]		= { .type = NLA_U32 },
 	[NFTA_PAYLOAD_BASE]		= { .type = NLA_U32 },
-	[NFTA_PAYLOAD_OFFSET]		= NLA_POLICY_MAX(NLA_BE32, 255),
+	[NFTA_PAYLOAD_OFFSET]		= { .type = NLA_BE32 },
 	[NFTA_PAYLOAD_LEN]		= NLA_POLICY_MAX(NLA_BE32, 255),
 	[NFTA_PAYLOAD_CSUM_TYPE]	= { .type = NLA_U32 },
 	[NFTA_PAYLOAD_CSUM_OFFSET]	= NLA_POLICY_MAX(NLA_BE32, 255),
@@ -797,7 +797,7 @@ static int nft_payload_csum_inet(struct sk_buff *skb, const u32 *src,
 
 struct nft_payload_set {
 	enum nft_payload_bases	base:8;
-	u8			offset;
+	u16			offset;
 	u8			len;
 	u8			sreg;
 	u8			csum_type;
@@ -812,7 +812,7 @@ struct nft_payload_vlan_hdr {
 };
 
 static bool
-nft_payload_set_vlan(const u32 *src, struct sk_buff *skb, u8 offset, u8 len,
+nft_payload_set_vlan(const u32 *src, struct sk_buff *skb, u16 offset, u8 len,
 		     int *vlan_hlen)
 {
 	struct nft_payload_vlan_hdr *vlanh;
@@ -940,14 +940,18 @@ static int nft_payload_set_init(const struct nft_ctx *ctx,
 				const struct nft_expr *expr,
 				const struct nlattr * const tb[])
 {
+	u32 csum_offset, offset, csum_type = NFT_PAYLOAD_CSUM_NONE;
 	struct nft_payload_set *priv = nft_expr_priv(expr);
-	u32 csum_offset, csum_type = NFT_PAYLOAD_CSUM_NONE;
 	int err;
 
 	priv->base        = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_BASE]));
-	priv->offset      = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_OFFSET]));
 	priv->len         = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_LEN]));
 
+	err = nft_parse_u32_check(tb[NFTA_PAYLOAD_OFFSET], U16_MAX, &offset);
+	if (err < 0)
+		return err;
+	priv->offset = offset;
+
 	if (tb[NFTA_PAYLOAD_CSUM_TYPE])
 		csum_type = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_CSUM_TYPE]));
 	if (tb[NFTA_PAYLOAD_CSUM_OFFSET]) {
@@ -1069,7 +1073,7 @@ nft_payload_select_ops(const struct nft_ctx *ctx,
 	if (tb[NFTA_PAYLOAD_DREG] == NULL)
 		return ERR_PTR(-EINVAL);
 
-	err = nft_parse_u32_check(tb[NFTA_PAYLOAD_OFFSET], U8_MAX, &offset);
+	err = nft_parse_u32_check(tb[NFTA_PAYLOAD_OFFSET], U16_MAX, &offset);
 	if (err < 0)
 		return ERR_PTR(err);
 
-- 
2.51.0

