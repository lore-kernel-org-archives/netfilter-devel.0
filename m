Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925B21F09A8
	for <netfilter-devel@vger.kernel.org>; Mon, 22 Jun 2026 19:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782157782; cv=none; b=D19pGNap3vkdJmTg0RyVfDW1nvzNb69P+vbsWYWJ5W4LKY5WgjZaUH5Umufeou6dbPRl0imEt9wEXxon+jcdXLbKAmCnKDxl5ylZuSHSHtZsfv225ZsYl+1k4JjkHSr3Crvq8NsJA+g/Fwt2ntRNFKrZZLLCQSXXsXXjlXCQHrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782157782; c=relaxed/simple;
	bh=LpQxUb7c2PxgTYSYdSt/WDlA/vezw+j4xUCPLNYmie8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=a4qq5fPAXXZdWwJ3RofWtqMoCOj9CiIPQTDo4eCOUkx7h7iKHo8a3/jpD16WkeW5wk4MszhT922NR9t5fgeGDtsYF1X0GBPf3eml/7gyKQC3CkfrRwZ2BdMm461BI/h2iKqbB2t2INfkpnhFSy6qFMTJ6aTHpAzg6wRxiL0lcjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ee1QOYLd; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ee1QOYLd"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 797166019D
	for <netfilter-devel@vger.kernel.org>; Mon, 22 Jun 2026 21:49:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782157779;
	bh=BceX2Mnh0OKovKnwJZjvP/0ZaKfKo9YgUFRyIhVXXjM=;
	h=From:To:Subject:Date:From;
	b=ee1QOYLdQuIcyh/lxMFjQgB4dYQmCtdwk8cjf/+c4LMR2du/aEeKdzSvvA/Re5X82
	 75HlKCFYZWYSnE3w8ZJzrleum0gujPO097Q+iozSZFmXpO7rxh5Go6BKEXNhFMEEUY
	 wdDjdE5HVvj4b/EV5Sxi/tVz2Ua4hVivBrLeBcYxJVkfbD6RWyxtwHl/qzBWg635Z7
	 qZ4jepDVgz6dyuXK94hkoiSdRHX/ZL6TjhxupA0Q6l0hioRx4YMCOLU1UUiNBbIw9O
	 nRQ5oA0lM6yj/7pHo7Ah9SVverAFRwQ6eO40G8XL4SySK7tXmxAXsY0vAv5yiL33BK
	 gU9G41/FaIxAw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nf_conntrack_helper: cap maximum number of expectation at helper registration
Date: Mon, 22 Jun 2026 21:49:36 +0200
Message-ID: <20260622194936.290377-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On helper registration, the maximum number of expectations cannot go over
NF_CT_EXPECT_MAX_CNT (255), but zero can be specified then
nf_conntrack_expect_max applies. Turn zero into NF_CT_EXPECT_MAX_CNT
otherwise, expectation LRU eviction on insertion is disabled.

Moreover, expand this sanity check all expectation classes.

This max_expecy policy is only tunable since userspace helpers are
available, set Fixes: tag to the commit that adds such infrastructure.

Remove the check for p->max_expected given this field must always
be non-zero after this patch.

Fixes: 12f7a505331e ("netfilter: add user-space connection tracking helper infrastructure")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_expect.c | 3 +--
 net/netfilter/nf_conntrack_helper.c | 9 +++++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 113bb1cb1683..38630c5e006f 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -496,8 +496,7 @@ static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect,
 					   lockdep_is_held(&nf_conntrack_expect_lock));
 	if (helper) {
 		p = &helper->expect_policy[expect->class];
-		if (p->max_expected &&
-		    master_help->expecting[expect->class] >= p->max_expected)
+		if (master_help->expecting[expect->class] >= p->max_expected)
 			evict_oldest_expect(master_help, expect, p);
 	} else {
 		const struct nf_conntrack_expect_policy default_exp_policy = {
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 8b94001c2430..a7fffe26b830 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -374,8 +374,13 @@ int __nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 	if (!nf_ct_helper_hash)
 		return -ENOENT;
 
-	if (me->expect_policy->max_expected > NF_CT_EXPECT_MAX_CNT)
-		return -EINVAL;
+	for (i = 0; i < me->expect_class_max; i++) {
+		if (!me->expect_policy[i].max_expected)
+			me->expect_policy[i].max_expected = NF_CT_EXPECT_MAX_CNT;
+
+		if (me->expect_policy[i].max_expected > NF_CT_EXPECT_MAX_CNT)
+			return -EINVAL;
+	}
 
 	mutex_lock(&nf_ct_helper_mutex);
 	for (i = 0; i < nf_ct_helper_hsize; i++) {
-- 
2.47.3

