Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F9D4BCADD
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Aug 2026 14:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787323124; cv=none; b=Br/tzm8r9cS9eKe35vs/03N4zTGOuWcCJFiQBXfCoToRCbJgVk2To/ugskZsdOdVsaaq7QnFl7nW6XaV6H4HghxT01NLB3NgJIaV946lUzd1mETLH2Z45pTO5rN+EwkCVZrHIWKhtRoAbNrZL74SnaLYqzumnBsFo8a0nnRazew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787323124; c=relaxed/simple;
	bh=AHT0MQzkosvOWTRlZNzRRXOL8ZFMBz1kZa+FTrgzBPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=swe5lU3FnaJdXdntinEtIa2v+Rk1VFW1dFWX+ALMuVv3309wpD10ULriHi3M6LmKMqVDDMnvzpRoMg8ywMrpvuRB115yg2Qpv4+AdSpwAyRNVUj5vSn1V6Ca8xc2kG1xzDwrzmOdgQHK6O4DI5otbTdjLj6slTRzymjafVd4fL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=pID0Ld73; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="pID0Ld73"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787323114;
	bh=23f9Ajpo5nJAvTLf+kGChG/0MuTwXUo/odxCWRKluik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pID0Ld73eK6/TezddwH4OvwHFJCSMPm+PsFm2C9/IdEd7ifEUGL3JB0FNNx8mztEq
	 nOk9ObCvkFGVW7/hsqhE+r2As61QB1NXjD/Z5li0RlVVp4tfXNJP/wEcVNkI6OP/d3
	 tI8IPm+RUPnc8tsihDpvQPo9RGaA7kw+7/h+0lXeCXda5uGHNyHRSRc2DUpFX5RpFc
	 eetdTQwu6hBzH0SMCZ0oBldEpifNhTq3cfguo1wOorI+bexZinj5a/prGeP8iSDSVR
	 0UBIoYQCveqfwtmEwG2gXzqgdgURicoRdYYqzZb6MUHjXRIlM2LbqfMOMiaqo406hm
	 HgptDrd0KFNUg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9E5E66007C;
	Fri, 21 Aug 2026 16:38:33 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf-next 02/10] netfilter: nfnetlink: use GFP_KERNEL_ACCOUNT
Date: Fri, 21 Aug 2026 16:38:19 +0200
Message-ID: <20260821143827.183963-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260821143827.183963-1-pablo@netfilter.org>
References: <20260821143827.183963-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

GFP_KERNEL_ACCOUNT is preferred these days for memcg, replace
GFP_KERNEL by GFP_KERNEL_ACCOUNT.

Use GFP_KERNEL_ACCOUNT for objects that are created from nfnetlink
subsystems.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_acct.c      | 2 +-
 net/netfilter/nfnetlink_cthelper.c  | 3 ++-
 net/netfilter/nfnetlink_cttimeout.c | 8 +++++---
 net/netfilter/nfnetlink_osf.c       | 2 +-
 4 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index 8ff1e0ad5cb0..1a366fbd8133 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -112,7 +112,7 @@ static int nfnl_acct_new(struct sk_buff *skb, const struct nfnl_info *info,
 		size += sizeof(u64);
 	}
 
-	nfacct = kzalloc(sizeof(struct nf_acct) + size, GFP_KERNEL);
+	nfacct = kzalloc(sizeof(struct nf_acct) + size, GFP_KERNEL_ACCOUNT);
 	if (nfacct == NULL)
 		return -ENOMEM;
 
diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index 5b6a09f46903..a09b2fdbf9b4 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -335,7 +335,8 @@ static int nfnl_cthelper_update_policy_all(struct nlattr *tb[],
 	struct nf_conntrack_expect_policy *policy;
 	int i, ret = 0;
 
-	new_policy = kmalloc_objs(*new_policy, helper->expect_class_max + 1);
+	new_policy = kmalloc_objs(*new_policy, helper->expect_class_max + 1,
+				  GFP_KERNEL_ACCOUNT);
 	if (!new_policy)
 		return -ENOMEM;
 
diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index 66c2016f6049..6b4adaaf61af 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -71,7 +71,8 @@ ctnl_timeout_parse_policy(void *timeout,
 	struct nlattr **tb;
 	int ret = 0;
 
-	tb = kzalloc_objs(*tb, l4proto->ctnl_timeout.nlattr_max + 1);
+	tb = kzalloc_objs(*tb, l4proto->ctnl_timeout.nlattr_max + 1,
+			  GFP_KERNEL_ACCOUNT);
 
 	if (!tb)
 		return -ENOMEM;
@@ -150,14 +151,15 @@ static int cttimeout_new_timeout(struct sk_buff *skb,
 		goto err_proto_put;
 	}
 
-	timeout = kzalloc(sizeof(*timeout), GFP_KERNEL);
+	timeout = kzalloc(sizeof(*timeout), GFP_KERNEL_ACCOUNT);
 	if (timeout == NULL) {
 		ret = -ENOMEM;
 		goto err_proto_put;
 	}
 
 	timeout->timeout = kzalloc(sizeof(*timeout->timeout) +
-				   l4proto->ctnl_timeout.obj_size, GFP_KERNEL);
+				   l4proto->ctnl_timeout.obj_size,
+				   GFP_KERNEL_ACCOUNT);
 	if (!timeout->timeout) {
 		ret = -ENOMEM;
 		goto err;
diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index 92002079f8ea..e4835b0f4bb1 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -325,7 +325,7 @@ static int nfnl_osf_add_callback(struct sk_buff *skb,
 	    !memchr(f->version, 0, MAXGENRELEN))
 		return -EINVAL;
 
-	kf = kmalloc_obj(struct nf_osf_finger);
+	kf = kmalloc_obj(struct nf_osf_finger, GFP_KERNEL_ACCOUNT);
 	if (!kf)
 		return -ENOMEM;
 
-- 
2.47.3

