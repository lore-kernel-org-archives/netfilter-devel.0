Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747E23446A7
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Jun 2026 05:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782193604; cv=none; b=sF0g2OIVCBzkah4MDTKLOrczIOyUqb4SpQV6xH/FsXOJcRaB3vl06wZoCDz9lm2Zgkdv+Plwr52T3AhFayLcn1pH+aC8gHbTnEwz3yOjt5VxfLf/RJAbOr61RhcV5qrZwbOEUPmhRbGSdZ4VaJYlJEOoP0b2c0CSLaZndym/ysA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782193604; c=relaxed/simple;
	bh=zHBuTbzZW550waKC4ZsA98k1TkJdP/ptGqw4k54JOH4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e37NYjcwBPI/D1AJ4kCrie6k5uHhT6h7+tOkZTuRW50pFX+MHuXzTMepIZay4uF6w4Q5zgr1SGLSEpX88APNKcpGx77In6wGKxS9a5/JsDcxTH8+qJ+857nACsTfzE4EBznXc8ZWAXACT0H/c45prJ9AMH33x4rz6LwM+7UTOBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=c+z86n0v; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="c+z86n0v"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E1C1C605A4
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Jun 2026 07:46:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782193602;
	bh=uKp5wqKqB/EWJ0RmjGU8fyXBLZc0C9RUly+BAL4EX+w=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=c+z86n0vAAweno63NLm9oHiNpDOgfiEhbSMDnHNJ8fHMGS9UQEGyi76Sq/aCpuxss
	 GtmyfmUF+RGimYJLw8PaHNXTC/zeSmr4krrzVwdm9Gy9ORfDNHUMU8bTR/25mv+oJW
	 S8U8IiXnhlfKwjLzGK82lgzo5BL+Hc1SdLjZc6FZF/rqr5cZYqtSOFpfJed1wJJ1c9
	 WedLQrkZHfM/EEozB8P4chjoZxyYa8E36xy74DS6iu4BTe6c8VEMW11anv3EsuHJlD
	 8YU8xchzoX1EvVAxV0FwIDdOrMKM2KnHluziAy1439bxhThKz4ZzqrF/QRtK2hzttA
	 NTFJ4QXug2rtQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v1 4/4] netfilter: nf_conntrack_helper: cap maximum number of expectation at helper registration
Date: Tue, 23 Jun 2026 07:46:35 +0200
Message-ID: <20260623054635.335065-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260623054635.335065-1-pablo@netfilter.org>
References: <20260623054635.335065-1-pablo@netfilter.org>
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
v1: resend to let sashiko pick in with this batch.

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

