Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795442264;
	b=YSd/ATiMiP5orFmVnLoGdfQ6cZZ4AMclMuYwOY2UnkfXZEwtpHTBSakJNRErLIZmQGEz
	 t0IUQliufK9KZRJzX8RQ8fl0WsrPhZYEDmfTsE5UC3CPeq61GcSGT+dhewUJ6vJrn/QdK
	 WApDYSZX4nL7rfPcpGNhyMJS1zn1liPKzP802WPIPwMt6O6Vp+8VK1o0399CGDQuuV1GG
	 4fzcTAMROG/QHqZFoayMJDhhYKHUStFX+kVxg2eL1VTKU0teu8WBE+Vee5htLt9bw1Ass
	 vN26H7hiWGy72qtHXada6OIotXu3ECCe8Mawfr0vjEz/jiMY6Z5Kb7OYL11U2NsPpWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795442264;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=XTGSzWsqO5IhRgtp1bTPpZw7gQSyqLMNOnyJBMSJJz0=;
	b=AtQWZFTbfyoVzpKinimt785SsOa0wqTtthK445khfOZopyzoogvdFtupKvZMrf5sCKLg
	 4e0ubVuJCmdk1ldPIiW2zCzfDKUktu5X2gt7ghaHYWCLwaZByyWks4r0XQ7bNMJFTEfXy
	 RAmjwQ8u+G8LuhSkDwqOs2rA+bPB+76AHIWWN3nr9Kc/DlOI0kdssH5AOJX8gyA3sOZfN
	 Hdpnpd9RKpIKN1tEwjZthnZpxB+TlLX20zSkNoqBMkMy+i3gaO22bdEQn9tQWkeivX1df
	 4Wpw+5TZsddOTC5SWIB+yi419oXbQgm7bdD8+o++YT2B0gjf1A01vE2wHm8gk6ilLAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b="A/LNbMoA";
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA72606A69F;
	Mon, 23 Nov 2026 13:57:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9FA72606A69F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=A/LNbMoA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795442261;
	bh=XTGSzWsqO5IhRgtp1bTPpZw7gQSyqLMNOnyJBMSJJz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A/LNbMoAzPvN+H4Rml+5HPWMW3d0Vch6ObgVX3AIbi9uQcOy7jCvzcYeeyCyGA4Q4
	 4v7fsKkGnaGe6eqywRzCfxefrrTd7BojmJq+uwV5sDKsI51W/acyTvDLT/hD1/h0T2
	 NyYv+VjZuLRWv2EJILL4LH2V3D0N7Itz4uJGfjFmT+QNTxR4A3il8tYxPJiiE1LWlw
	 Cs/bM7+qOe44kp8Uwk2heyZY3iX8M84nDx5zwceOiDGbk/s0oCozObzJUe4+C6JN5v
	 DSimtQnulbKgUrZ+jLWBcw2oV2TR00wk6fqcpn1NS5LnIe+Er04FotPtBxTkTyS1lh
	 LelMT1KzGg70g==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5AA53602F4;
	Mon, 23 Nov 2026 14:57:41 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 07/15] netfilter: nft_ct: validate timeout object protocol
Date: Mon, 23 Nov 2026 14:57:18 +0100
Message-ID: <20261123135726.3940688-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261123135726.3940688-1-pablo@netfilter.org>
References: <20261123135726.3940688-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

nft_ct_timeout_obj_eval() only compares the timeout object protocol with
packet metadata. A packet header can be changed after conntrack attaches
an entry, so this metadata does not necessarily describe the entry.

Timeout objects contain protocol-specific arrays. Attaching an object for
a protocol with fewer timeout states to an entry for one with more states
lets the conntrack tracker read beyond the object.

Require the object protocol to match the conntrack tuple protocol before
attaching it. This mirrors validation by named timeout policies and
nftables conntrack helper objects.

Based on original patch from Kyle Zheng, who also authored this commit
message.

LLM review complains about _ext_add() races with cloned unconfirmed skbs.
conntrack never supported this; fixing it is hard and out of scope for this
change.

Fixes: 0434ccdcf883 ("netfilter: nf_tables: rework ct timeout set support")
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_ct.c | 44 ++++++++++++++++++++++++++++++++----------
 1 file changed, 34 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 58846bc405b7..a19a839a0fc0 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -839,6 +839,34 @@ static struct nft_expr_type nft_notrack_type __read_mostly = {
 	.owner		= THIS_MODULE,
 };
 
+/**
+ * nft_ct_get_safe() - Return nf_conn with extra checks
+ * @pkt:     nftables packet information structure
+ * @l4proto: The expected Layer 4 protocol
+ *
+ * Returns the conntrack entry only if it is unconfirmed, non-template and
+ * matches the expected L4 protocol.
+ *
+ * Return: Pointer to the &struct nf_conn if all checks pass; NULL otherwise.
+ */
+static struct nf_conn *nft_ct_get_safe(const struct nft_pktinfo *pkt, u8 l4proto)
+{
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct;
+
+	ct = nf_ct_get(pkt->skb, &ctinfo);
+	if (!ct || l4proto != pkt->tprot)
+		return NULL;
+
+	if (l4proto != nf_ct_protonum(ct))
+		return NULL;
+
+	if (READ_ONCE(ct->status) & (IPS_TEMPLATE | IPS_CONFIRMED))
+		return NULL;
+
+	return ct;
+}
+
 #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 static int
 nft_ct_timeout_parse_policy(void *timeouts,
@@ -879,14 +907,12 @@ static void nft_ct_timeout_obj_eval(struct nft_object *obj,
 				    const struct nft_pktinfo *pkt)
 {
 	const struct nft_ct_timeout_obj *priv = nft_obj_data(obj);
-	struct nf_conn *ct = (struct nf_conn *)skb_nfct(pkt->skb);
 	struct nf_conn_timeout *timeout;
 	const unsigned int *values;
+	struct nf_conn *ct;
 
-	if (priv->l4proto != pkt->tprot)
-		return;
-
-	if (!ct || nf_ct_is_template(ct) || nf_ct_is_confirmed(ct))
+	ct = nft_ct_get_safe(pkt, priv->l4proto);
+	if (!ct)
 		return;
 
 	timeout = nf_ct_timeout_find(ct);
@@ -1115,14 +1141,12 @@ static void nft_ct_helper_obj_eval(struct nft_object *obj,
 				   const struct nft_pktinfo *pkt)
 {
 	const struct nft_ct_helper_obj *priv = nft_obj_data(obj);
-	struct nf_conn *ct = (struct nf_conn *)skb_nfct(pkt->skb);
 	struct nf_conntrack_helper *to_assign = NULL;
 	struct nf_conn_help *help;
+	struct nf_conn *ct;
 
-	if (!ct ||
-	    nf_ct_is_confirmed(ct) ||
-	    nf_ct_is_template(ct) ||
-	    priv->l4proto != nf_ct_protonum(ct))
+	ct = nft_ct_get_safe(pkt, priv->l4proto);
+	if (!ct)
 		return;
 
 	switch (nf_ct_l3num(ct)) {
-- 
2.47.3

