Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2BE4E80D0
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2026 13:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789650603; cv=none; b=VjqMI7rs+8tcRQG/0p4oXt6SIIFwILWgZoAh0VCbGb365RSdfcihAeoQcJ4mbu4aU66umeNsGCY/c49I4A/kINw39reR3YoWLE6EIEozX9kmQwApfr5Ojxc8/tgX/7MMi2+JB0apbx27FR3axKsf/tEw3QY+gh4/XBAYDqABf/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789650603; c=relaxed/simple;
	bh=a9SRH/kTcWpSqe5MWZBhEhRpR0z39mlAaE6Gv1yTFM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CTvrQBIy2LHFT/9c4y67FVr8t/x6Wk7X5lXykK2JTJN1SdZOgRXVo+sONrV5LiJCzbNwlgs/qAZMLBZE+LtuZbnQNmGE/co3H6RB1O0d0ya5Zhu252RpMyfijP50YXlb9o0t85oqG609Q4RnKFdgOFcgQHyth4uIv/cPRJCJpQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 573E6602FF; Thu, 17 Sep 2026 15:09:55 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Kyle Zeng <kylebot@openai.com>
Subject: [PATCH v2 nf 6/6] netfilter: nft_ct: validate timeout object protocol
Date: Thu, 17 Sep 2026 15:09:22 +0200
Message-ID: <20260917130922.17699-7-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917130922.17699-1-fw@strlen.de>
References: <20260917130922.17699-1-fw@strlen.de>
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
 v2:
 keep nft_ct expectation as is, LLM claims this broke nft expectation support.
 changelog: I'm too stupid to fix all bugs at once.

 net/netfilter/nft_ct.c | 48 +++++++++++++++++++++++++++++++++---------
 1 file changed, 38 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index a1093311414b..1cecdcae1f4e 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -839,6 +839,38 @@ static struct nft_expr_type nft_notrack_type __read_mostly = {
 	.owner		= THIS_MODULE,
 };
 
+/**
+ * nft_ct_get_safe() - Return nf_conn with extra checks
+ * @pkt:     nftables packet information structure
+ * @l4proto: The expected Layer 4 protocol
+ * @ctinfop: packet ip_conntrack_info storage
+ *
+ * Returns the conntrack entry only if it is unconfirmed, non-template and
+ * matches the expected L4 protocol.
+ *
+ * Return: Pointer to the &struct nf_conn if all checks pass; NULL otherwise.
+ */
+static struct nf_conn *nft_ct_get_safe(const struct nft_pktinfo *pkt,
+				       u8 l4proto, enum ip_conntrack_info *ctinfop)
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
+	if (ctinfop)
+		*ctinfop = ctinfo;
+	return ct;
+}
+
 #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 static int
 nft_ct_timeout_parse_policy(void *timeouts,
@@ -878,14 +910,12 @@ static void nft_ct_timeout_obj_eval(struct nft_object *obj,
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
+	ct = nft_ct_get_safe(pkt, priv->l4proto, NULL);
+	if (!ct)
 		return;
 
 	timeout = nf_ct_timeout_find(ct);
@@ -1114,14 +1144,12 @@ static void nft_ct_helper_obj_eval(struct nft_object *obj,
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
+	ct = nft_ct_get_safe(pkt, priv->l4proto, NULL);
+	if (!ct)
 		return;
 
 	switch (nf_ct_l3num(ct)) {
-- 
2.55.0

