Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5C4377004
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Jun 2026 10:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782211307; cv=none; b=nSpVFfqDxHKPJqBIIBYSN/RiPu+9o2sqBMkJ3fEz8a1+AxzU2vFnq/uTL9LHKwbckC2CizyK+TV+VdKsGN/Yz9Ffd3pgIQx/tCmbj9UCILLZjraQIFuxouEJVy7e16KvJN5mLZhuAMKpJ1QpYuaQqVbO+GJ4QuYehsp7dfXWf+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782211307; c=relaxed/simple;
	bh=aKGrfONpbpXVeeSnSfqIJtGLMWKpZqW5gjChyDSYrt8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=m8aKFsOQZ3pq9B4+ViG96MFTuYKZZ2mwaITffXLW+kV4K49/mp0Tq5C0/dwsG7OKjAII5+fyQkqPWHJZuCQOI63fCbVzGNI2HW8xK0PNuNiBdgfna8t6KNmnKUPTavfU71R4cBWXcHDsGh7GgtyTCa52AMncblGIGtuF0w9AhiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=O1d6TFaR; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="O1d6TFaR"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2B1B760582
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Jun 2026 12:41:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782211303;
	bh=dMiRWzEF8Lww/fb9LBFFvWxqlJi8LGkKWfPDgbnNTkI=;
	h=From:To:Subject:Date:From;
	b=O1d6TFaRRbsEED1hBdxhF1J6xkG3qimwNEsEcuuZZjzO6BaD8Tyd0Mzg5HBp4q6nf
	 8QNdx49flG32iVwIt+JJU/HtBQxZHTC0YsKN5PxX6iqtRL5V+s0D/PZBRhO8jgZ6tN
	 qCgRNiXECmNhCDLtdsMbLfEDP3PkoqYaULQhM7Wj6yFBV9ENsJ+1nQBmdjKUwJejAr
	 fWnCV9jS6XidKnvQtldHUMUkAk08WUR3wimO7Oh1pWJkGOjQeiKDO/4oOzgj2Lil54
	 BbtkBQnCGmhNAmhC+21FFZ6RiwSK/f1EMVtwKgAtjBEsMutPGnyKZ+s8ZR8+TQz2dO
	 f2m8/jeUpKVbg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v2] netfilter: nf_conntrack_helper: cap maximum number of expectation at helper registration
Date: Tue, 23 Jun 2026 12:41:39 +0200
Message-ID: <20260623104139.358192-1-pablo@netfilter.org>
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
v2: Use +	for (i = 0; i <= me->expect_class_max; i++) {
    because expect_class_max is class_max - 1 for historical reasons.

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
index 8b94001c2430..500509b17663 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -374,8 +374,13 @@ int __nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 	if (!nf_ct_helper_hash)
 		return -ENOENT;
 
-	if (me->expect_policy->max_expected > NF_CT_EXPECT_MAX_CNT)
-		return -EINVAL;
+	for (i = 0; i <= me->expect_class_max; i++) {
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

