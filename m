Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD91218629C
	for <netfilter-devel@vger.kernel.org>; Sat, 27 Jul 2024 21:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722116223; cv=none; b=AkD9cxexkxuMnS0QGqaDhKmTWIvNU66F0UENad9EDulx62LCiyXFHMHC+51qUHfUqU1Ha8rnxBg9uwyocinj02jg0mMuJ3agpePqu23LtbwjYs/OM0tZRyKFUB1rO8PIqe0wtF0VWZ2HmZ9fptohb4Y/4xSARhaJxl/T0b5R7nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722116223; c=relaxed/simple;
	bh=PwL9sGJMsWRbV9utDH6QJOzfmU/V5H4EVNJ67xTE3XA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sia4+bJOrTVGWRVFWeBVB1rEgjkM8IgF3c1Kb+/WZEmfmIG3a0wGu7QbPo/zoXcGxav+6mPwO611otY7daFuwdn/trn8cZ9cZMSI0Bd3RK4k8rZoAEVrMYJtbgMc8F1xE48IqDwcJT9tlVbAwMsc9Q3xVGK98wJX5Z2lSFrFgB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=qW+4X/ZM; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="qW+4X/ZM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/IFM1SIP8jzBG7TwayDbiyuLhv0Gw8i+5+JyCmL8G2k=; b=qW+4X/ZMvCD9VuW5WGPfvGuPTD
	J0oJjhslH8d5HNnmflUopckchVDxAX0mEveyF770DTY4iYjr+09lscraM/3TlRMf014UVpiLHkFzp
	DDPQnc5dAHmXheeyiUTBX+/SaBR0l9D6IFXgiEM99jsmcqE+6SRVrTCMIwIvtphfsjN68cYmijmGL
	2MUslo7La6GZOwoLA507MZwnU9l37Jo6YBlRccI2XkjJ9zNus5tp+4B+6JldFSDUaw4qnEGgjQHNb
	omIN91s1l9mieqjCuiRr60kaqwyBYpDaVnSSCRc1JuL/GAV5W9WY+wyyKBI51tEuCQahk9JPELrG4
	J28VPs7Q==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sXp64-000000002VB-0hmk
	for netfilter-devel@vger.kernel.org;
	Sat, 27 Jul 2024 23:37:00 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 06/14] nft: Add potentially missing init_cs calls
Date: Sat, 27 Jul 2024 23:36:40 +0200
Message-ID: <20240727213648.28761-7-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240727213648.28761-1-phil@nwl.cc>
References: <20240727213648.28761-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The callback is there for arptables only, so other family specific code
does not need it. Not calling it from family-agnostic code is wrong
though, as is ignoring it in arptables-specific code.

Fixes: cfdda18044d81 ("nft-shared: Introduce init_cs family ops callback")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-arp.c |  3 +++
 iptables/nft.c     | 11 +++++++++++
 2 files changed, 14 insertions(+)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 5d66e271720ec..2784f12ae33a9 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -356,6 +356,8 @@ nft_arp_save_rule(const struct iptables_command_state *cs, unsigned int format)
 	printf("\n");
 }
 
+static void nft_arp_init_cs(struct iptables_command_state *cs);
+
 static void
 nft_arp_print_rule(struct nft_handle *h, struct nftnl_rule *r,
 		   unsigned int num, unsigned int format)
@@ -365,6 +367,7 @@ nft_arp_print_rule(struct nft_handle *h, struct nftnl_rule *r,
 	if (format & FMT_LINENUMBERS)
 		printf("%u ", num);
 
+	nft_arp_init_cs(&cs);
 	nft_rule_to_iptables_command_state(h, r, &cs);
 
 	nft_arp_print_rule_details(&cs, format);
diff --git a/iptables/nft.c b/iptables/nft.c
index 243b794f3d826..8b1803181b207 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1797,6 +1797,8 @@ nft_rule_print_save(struct nft_handle *h, const struct nftnl_rule *r,
 	struct nft_family_ops *ops = h->ops;
 	bool ret;
 
+	if (ops->init_cs)
+		ops->init_cs(&cs);
 	ret = ops->rule_to_cs(h, r, &cs);
 
 	if (!(format & (FMT_NOCOUNTS | FMT_C_COUNTS)))
@@ -2395,6 +2397,11 @@ static bool nft_rule_cmp(struct nft_handle *h, struct nftnl_rule *r,
 	struct iptables_command_state _cs = {}, this = {}, *cs = &_cs;
 	bool ret = false, ret_this, ret_that;
 
+	if (h->ops->init_cs) {
+		h->ops->init_cs(&this);
+		h->ops->init_cs(cs);
+	}
+
 	ret_this = h->ops->rule_to_cs(h, r, &this);
 	ret_that = h->ops->rule_to_cs(h, rule, cs);
 
@@ -2679,6 +2686,8 @@ static int nft_rule_change_counters(struct nft_handle *h, const char *table,
 		(unsigned long long)
 		nftnl_rule_get_u64(r, NFTNL_RULE_HANDLE));
 
+	if (h->ops->init_cs)
+		h->ops->init_cs(&cs);
 	h->ops->rule_to_cs(h, r, &cs);
 
 	if (counter_op & CTR_OP_INC_PKTS)
@@ -2976,6 +2985,8 @@ int nft_rule_zero_counters(struct nft_handle *h, const char *chain,
 		goto error;
 	}
 
+	if (h->ops->init_cs)
+		h->ops->init_cs(&cs);
 	h->ops->rule_to_cs(h, r, &cs);
 	cs.counters.pcnt = cs.counters.bcnt = 0;
 	new_rule = nft_rule_new(h, &ctx, chain, table, &cs);
-- 
2.43.0

