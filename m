Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E93733D512
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Sep 2026 15:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789746028; cv=none; b=CS7JxjCMU3ogS8c+YJRZ33Xk+RBedat1GKIVIuQ5p/lI62Bh+SnydFFIYqZEGiYGGM/N2ZuLOr2WfWyjvtuhcmRhtTZckOtzZ0lx2474Vc/fe2MvnL0QTcnm+ueKagOOiGtJOQZ4ZcWcye+WBiY+2YBzesZuRvzL/uvEVeNYEAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789746028; c=relaxed/simple;
	bh=rFCOhdWXfbC5joJoqSyJd8+XeI4ylrwkWZBd92/+/3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QHc+rV3YAiT0ztIA/9bWFD/k7wgFlaot5nPwuJ0Bx5QreeppQSkAfVm6dOJBeGB0bjP9h/UP2yaeU2SGM+D0BrCz7knY7qIoCPKcZQlH3f9v6b3l96dIBDrhFG2la+bMFoZYuIixHIYln6OHh5jLnKBFyvspvaNoNdYs3tl5dno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 29B786055C; Fri, 18 Sep 2026 17:40:16 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Kyle Zeng <kylebot@openai.com>
Subject: [PATCH v3 nf 6/6] netfilter: nft_ct: validate timeout object protocol
Date: Fri, 18 Sep 2026 16:58:09 +0200
Message-ID: <20260918145809.12938-7-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260918145809.12938-1-fw@strlen.de>
References: <20260918145809.12938-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
 v3: remove 'ctinfop' arg from nft_ct_get_safe(), it was unused
 since v2.

 net/netfilter/nft_ct.c | 44 ++++++++++++++++++++++++++++++++----------
 1 file changed, 34 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index a1093311414b..21c5d14b0d08 100644
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
@@ -878,14 +906,12 @@ static void nft_ct_timeout_obj_eval(struct nft_object *obj,
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
@@ -1114,14 +1140,12 @@ static void nft_ct_helper_obj_eval(struct nft_object *obj,
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
2.55.0

