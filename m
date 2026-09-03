Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE6746A5FD
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2026 11:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788435276; cv=none; b=fiNBkCl0V8uc7csQOv/tOMMmm2i3FSrv0HVCTZNaXGVFfMJbe5De6066OWu6HwPiTFcXsVh9FFvGMovHGApOTVTjmSp/X4C/Iq2lQ6owW/HJeuoOrCmjJlS3o56LTbThdgwy0l38GLYkVSt3FBFFBTIEHHx8x1FrG8YPviIYEzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788435276; c=relaxed/simple;
	bh=QMt2Y1ED9KxDX+2irNYDMqUYl94EGdkbxlMvWdpDLpc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dCar+NJ025FrlAL6y7as3zvclRiVh5Dg/O81OWTyRI6KpWWEP4NfSVOes8/Ha3R4FA1XlKySULLJmSWv8B4+shshXODW4fWBjxM0DlqxA7rx2NbHlUyFcmzjNJRzSGr1YhcNQfLlpxjBMGjb6sfgWMfHgpLVacWF8g2tW6L1HPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=X9KBQ8BE; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="X9KBQ8BE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788435258;
	bh=eBJ8dTmzyyGRqvFSdLRGdOX105md0WvzUYtexExKHbY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=X9KBQ8BErKp0ieGnwh6pjD0v4TOeoSzvZprpY1LQP41I+66YipLYY3ytpLWBEcDT2
	 6+cXZIU8DrkifQ3RCXwwnPWn/ZeADAJbvmnI0zL+DvwDgkPzho84zr69VCm9QFSM+Z
	 WIYou1uf+/EIONVG9FX0Xhoik8PzNWkKuDu/0pTrJqYBUp99robKo6gV2k8rgmm4qc
	 ajLOj3y6uNgvDSNNgjYyuznNM2s5yoYAdRf0PTsgA7m6bYKDlUpaNCmOfZwaD1hJEf
	 HgqipLKlglayDHI8809Q7/Gw4vIKxDWISGsSiMjL0IoAH88YLt1IWnOXLfLI3MvTy3
	 XbpwyjiSPpBHw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9AA99607EA
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2026 13:34:18 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v2 2/8] netfilter: nfnetlink: use GFP_KERNEL_ACCOUNT
Date: Thu,  3 Sep 2026 13:34:07 +0200
Message-ID: <20260903113413.1122606-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260903113413.1122606-1-pablo@netfilter.org>
References: <20260903113413.1122606-1-pablo@netfilter.org>
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
v2: no changes

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

