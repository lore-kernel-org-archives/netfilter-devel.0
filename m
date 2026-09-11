Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680EE3F8251;
	Fri, 11 Sep 2026 08:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789116300; cv=none; b=IMolHeilhIjbfPCXFTiqorsKz/ybNvvmAeTMxe3FbtSp31nQfpYqdBpeDbm5v1zUFQaUm+0ghPBU7uSHEjJ7v7/LYfAEK/szAK+0sP84IUoj29Sa+MSn+0vupDY7KZe6QNM7ofaiea8g1bKrrjvu+7CmQyye0CVtuOHU9z7C8DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789116300; c=relaxed/simple;
	bh=bbNnZy1++/WI2BDpd/c2GFxjf/KAv+QmnbOV1x8G4Mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KSmtR4qQ81HUPaoSGe1BVtvHI+sUADdlpQavj20nPRhJnEhn9s+KLRbXGHnVkXlqvMYHzzFH/6eyT4iWXdLA9VwexbeP7GOZDPLyIUTXMQz9CTB8qDq4IcCeBpT6vFGai7Dz0n1E0OGwb15Br1gYYoLc+6NlzMRf1uTIAtr9L8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=GSkAOIVn; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="GSkAOIVn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789116288;
	bh=oMi1mBcWGUsb6kNQnHPoesXgCtuVeTHaQYnwenUQ0QU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GSkAOIVnTJV0ZhyXndt5hQ5Nl0SKkoHjy4dni92RFl5voNR5CDwPb0E599X8tDimu
	 qMh3MM2H9xuKpINC8zSKDCdHt6kt7oLX9ySd0GpuYXm0AgfVgWe9muz39yT1ErE/lN
	 bc8KDgYoRfvA3pMxX1QZwbV6OpdZUoeLo6JDWmh70PjDnkd7/xl9NEo1xl4w0dmOiG
	 hi5R82ReTD5rB2qzGpX1p9wXSTn9gny1YBviNfQJGn7JKgdF+JNFV4w4TXH8xyIekh
	 aCD8NOH4aCf2gDVXXAU3ZCP6XJH9eSG4lq2N+hvuv+iCcRZ+Bb2uMvTpaUV89YUxjF
	 RWJjUiwNaPa5A==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 49E96603E0;
	Fri, 11 Sep 2026 10:44:48 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 3/8] netfilter: nfnetlink: use GFP_KERNEL_ACCOUNT
Date: Fri, 11 Sep 2026 10:44:32 +0200
Message-ID: <20260911084437.1838161-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260911084437.1838161-1-pablo@netfilter.org>
References: <20260911084437.1838161-1-pablo@netfilter.org>
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
index e751f2b9c51d..c667a29d92f1 100644
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
 
-	timeout = kzalloc_obj(*timeout);
+	timeout = kzalloc_obj(*timeout, GFP_KERNEL_ACCOUNT);
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

