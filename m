Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795442101;
	b=Xy/UPsbkohwrcuhXADD8cg8hHTVtPY5bG7of+5zGxxFlGqVfkqNksWZPRMNDnZ67DC4W
	 pAfUGzLhf7rog9cmqiy4Nffvt2du1sogEbR54LqWW9UeDi5Fxy8CP6AtFKaKGkpKG7xlG
	 MMIlkF0/zVxIiwuwchEs6owhqGYz/Q1CAT2Gz6X161i7Qen7M6VsfugT0mELClbaPZ2gp
	 Rh4+rxv7tOHoCQehCPTZ5dtTXVkW1/DisjZMQv0qEXYwfMnDudRzwImJPz3jKHW4FKfc8
	 Q/4Nb1R/0BYHDLoHp4MMdgpjxAV2QV0giz7nbeJLZAgV0YDu4SIUMKQ61z3qaXTO4aQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795442101;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=XTGSzWsqO5IhRgtp1bTPpZw7gQSyqLMNOnyJBMSJJz0=;
	b=Ti7rzZahEegZOrLFsWbLE4R//LU3pV5fLOmXiqdL6pGj1wC2AxLwC+rLy7jgl8RES9Ln
	 rVM6PZZEqYcQSebfoZ9fUBb3fryZ4g5bmC4euOcdk2Ef2LBSgYdngd6Kjg984eNVJZyu6
	 GMyg2tJf8WtDXv4NaZaBsnrOKT5vVy27X9WHqSIJLL1d6PFH8j0RsrmD98ZoYgRDdg200
	 Rq+qTCUG/TejrKzMhOPOEFMbeR/KdrFFuDBbOA0jRDVsg1NgENxdB0mqq1ju8kZ1qYjmC
	 mHnPJbyBOBWT/la1z8RYefoqni4uWONKMumRMYITipgt+fU1R7Fx+a3sis0cQ0qxY5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=s7RyOe0n;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7602E606A31E;
	Mon, 23 Nov 2026 13:55:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7602E606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=s7RyOe0n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795442098;
	bh=XTGSzWsqO5IhRgtp1bTPpZw7gQSyqLMNOnyJBMSJJz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s7RyOe0nctsVi8EN4Ebwc+yWZ9ir/T82pxBgq5xVb0U1BCv7B92Et+pIvVx0huIgr
	 2WE4i2dp7ZQCGgaP+gLhD0uzwB6jQeAk3ooO8tmBizSBeCbuxRe481CtNwngEPvkv7
	 sKQobwEjksrSeEjMQfNTncb+Z3gl+wAvHYzdnvl11/+DZI7bWiDtXM4+aTdPY60BEg
	 gaM/KqWnIpnlMEySW5n0xMJj9S1woBh74wOm6ryH83BpUvPWp3DSsj/ifn7eH9ICKF
	 +0vJrVLQeI2mVy7CEEhOnop8Nv3e48jSggEI2Q1EKZ78GNX//BF7BVAJwwxOz8mbtQ
	 wcTIzJ9tL7c6A==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 21EFC602D3;
	Mon, 23 Nov 2026 14:54:58 +0100 (CET)
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
Date: Mon, 23 Nov 2026 14:54:34 +0100
Message-ID: <20261123135442.3940372-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261123135442.3940372-1-pablo@netfilter.org>
References: <20261123135442.3940372-1-pablo@netfilter.org>
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

