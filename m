Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85A016D4FA
	for <netfilter-devel@vger.kernel.org>; Wed, 31 Jul 2024 22:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722464833; cv=none; b=VWHL1O2S0ov23r71IhkQ9/BNHp3TCqYql4HPOIfI5Ir4xxNsPR2sQQTBmTA3Yt4oPJsDk3B+RLQdhpUVU/iRRZU3SGqQG5bdNAeRG5CBr9SDbxX0aH0olc5r89tUQaYWPN/KlghwNJIooFGT8LIv7NfTSTW6mjPxg/o9NnYiVv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722464833; c=relaxed/simple;
	bh=StSPAeUfHGeG6sPQZfkb4JUu3E9j20cAAYUaMkkVTA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kAPgYQTTZGK9k/lDH6sgvuMKTm7wmJLYUiKsN/peYAMEiYwuruSVGyfZioVVU3XSdLjqDlfly6uTQN0Sb5nM4uHgY1E1YXYecR7jNB5EG55PaHdRPOHEchr11ZmlQ+05PkXlSsruQX+lVh7Vhq9dMQ82mgIijHxk0TYnl0HQvDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=dwomQpCO; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="dwomQpCO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=zgD8wmxmgfQ5aloCHoLLw/QKf53e0igplQQgPUkaHPU=; b=dwomQpCO7fnJLdok1ClpEzfuTe
	m0Qn9UnbdBpT8lMLE4gaSdBEyvV91tITxhhFa3/0kuV//nkypcg/h3XYJwuJEyZ8MNDfPjM7h9/DC
	eb1Ff6qhlAXVEzEklhNYk1+Sgn5B2O91cpt7p8DAxvJp8OZqBTt3b/Cl8liVZ/8c9cJBLMDipSrDY
	RvfukSUCpXqfPO/VVNN6d1ADO2OVO9cc1T6mNZKrxqlmircqjIyXg3BzE62FYuhkG+K+7TGlPI7kj
	IAeEi0vqz5IIuUOKfX9dajGrfGwaxHxRh4etn+yl/aQEWGLEVrg+hhCq8RFEd+iUMKQeov5UEIvkK
	MFHiCdjw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sZHmo-000000003ij-0hyL;
	Thu, 01 Aug 2024 00:27:10 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jan Engelhardt <jengelh@inai.de>
Subject: [iptables PATCH 3/8] nft: Reduce overhead in nft_rule_find()
Date: Thu,  1 Aug 2024 00:26:58 +0200
Message-ID: <20240731222703.22741-4-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240731222703.22741-1-phil@nwl.cc>
References: <20240731222703.22741-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When iterating through the list of rules in a chain comparing against a
sample, there is no point in carrying that sample as nftnl_rule object
and converting into iptables_command_state object prior to each
comparison. Just do it up front and adjust the callback accordingly.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 8b1803181b207..88be5ede5171d 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2392,25 +2392,22 @@ static int __nft_rule_del(struct nft_handle *h, struct nftnl_rule *r)
 }
 
 static bool nft_rule_cmp(struct nft_handle *h, struct nftnl_rule *r,
-			 struct nftnl_rule *rule)
+			 struct iptables_command_state *cs)
 {
-	struct iptables_command_state _cs = {}, this = {}, *cs = &_cs;
-	bool ret = false, ret_this, ret_that;
+	struct iptables_command_state this = {};
+	bool ret = false, ret_this;
 
-	if (h->ops->init_cs) {
+	if (h->ops->init_cs)
 		h->ops->init_cs(&this);
-		h->ops->init_cs(cs);
-	}
 
 	ret_this = h->ops->rule_to_cs(h, r, &this);
-	ret_that = h->ops->rule_to_cs(h, rule, cs);
 
-	DEBUGP("comparing with... ");
+	DEBUGP("with ... ");
 #ifdef DEBUG_DEL
 	nft_rule_print_save(h, r, NFT_RULE_APPEND, 0);
 #endif
-	if (!ret_this || !ret_that)
-		DEBUGP("Cannot convert rules: %d %d\n", ret_this, ret_that);
+	if (!ret_this)
+		DEBUGP("Cannot convert rule: %d\n", ret_this);
 
 	if (!h->ops->is_same(cs, &this))
 		goto out;
@@ -2434,7 +2431,6 @@ static bool nft_rule_cmp(struct nft_handle *h, struct nftnl_rule *r,
 	ret = true;
 out:
 	h->ops->clear_cs(&this);
-	h->ops->clear_cs(cs);
 	return ret;
 }
 
@@ -2442,6 +2438,7 @@ static struct nftnl_rule *
 nft_rule_find(struct nft_handle *h, struct nft_chain *nc,
 	      struct nftnl_rule *rule, int rulenum)
 {
+	struct iptables_command_state cs = {};
 	struct nftnl_chain *c = nc->nftnl;
 	struct nftnl_rule *r;
 	struct nftnl_rule_iter *iter;
@@ -2455,9 +2452,20 @@ nft_rule_find(struct nft_handle *h, struct nft_chain *nc,
 	if (iter == NULL)
 		return 0;
 
+	if (h->ops->init_cs)
+		h->ops->init_cs(&cs);
+
+	if (!h->ops->rule_to_cs(h, rule, &cs))
+		return NULL;
+
+	DEBUGP("comparing ... ");
+#ifdef DEBUG_DEL
+	nft_rule_print_save(h, rule, NFT_RULE_APPEND, 0);
+#endif
+
 	r = nftnl_rule_iter_next(iter);
 	while (r != NULL) {
-		found = nft_rule_cmp(h, r, rule);
+		found = nft_rule_cmp(h, r, &cs);
 		if (found)
 			break;
 		r = nftnl_rule_iter_next(iter);
@@ -2465,6 +2473,8 @@ nft_rule_find(struct nft_handle *h, struct nft_chain *nc,
 
 	nftnl_rule_iter_destroy(iter);
 
+	h->ops->clear_cs(&cs);
+
 	return found ? r : NULL;
 }
 
-- 
2.43.0

