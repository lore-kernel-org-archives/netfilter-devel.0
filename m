Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4E72F0660;
	Mon,  1 Sep 2025 08:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756714165; cv=none; b=NjijPF/sOi6U4+EZ6DzfHtrY7VhabDK+BAYAKrmRWixVA9jCPjcxbXjMqiLMXbLDjnM+NDjU/GUtuTgvb9J25ePFd5cqmedlgjznaFNzwdwshcKHHUGhG09yML3E41U1IOGn8nDkWhI+lGFwddl9qDrdD/YhTu8T+PDlXsNoULw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756714165; c=relaxed/simple;
	bh=eL5bPtEbyYPPnJn5IF5WihPsPiZTJSLjyL6UkYKZl/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H88TPg1h+NvQIA4FNn3zXefMhxqGOTqH1q3g+yDiEqnJxixdNp7OdDE1dK5jUJ9Z7kKcqb5Fn9TFuGMicNZEAY8DHTNGAlrg9X+Qqd4WdwiwHi19Gf1ngjFf3vDp4D+jRMvqL+EoSU6OVX5wKwUCjaWfEZZLFyv5MR7YEekVrwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 5DAD660819; Mon,  1 Sep 2025 10:09:22 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 8/8] netfilter: nft_payload: extend offset to 65535 bytes
Date: Mon,  1 Sep 2025 10:08:42 +0200
Message-ID: <20250901080843.1468-9-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250901080843.1468-1-fw@strlen.de>
References: <20250901080843.1468-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

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
Signed-off-by: Florian Westphal <fw@strlen.de>
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
index 059b28ffad0e..b0214418f75a 100644
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
2.49.1

