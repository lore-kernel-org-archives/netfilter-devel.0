Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263FA478E56;
	Thu, 27 Aug 2026 14:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787840274; cv=none; b=oJs348lMjnF8imMQthdLXG2ekgLACzvXbi70UsihCuXOjEpobqG3N4YVTGq3zZMmF+KIu2GBFDazkOKrYrd8mHRjcP/cfAHk8SXK9Ie5E8kB8EnhfIk6UlYOHEwOkxy/CHpAMYHKgTBGLH8PoUP9AOrqtOyn1JKr1nW4iVed1g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787840274; c=relaxed/simple;
	bh=5Vv+QuJUuCkF0LBukL35awWCCPKJAuRZ4SCRzcOI6ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKOyjI+ryWv7Wt7MPi5oHHwVwZ3Lb7y/eOhRiOqMcw9Xccgy/vQEEHNmZagQy83hQFFz1j5VvItZ5EeSw6ixBSeEM4oqMSznweIDldfqN7QipNQiP4xLESVC1uKRnN9dUnfrsNs0QTI2++WaneMyMt2CnnnoVg2YUSM2V2vrcmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=tWWs662E; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="tWWs662E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787840267;
	bh=mLZKSw33hDHbPVV4FT1i6gKL8I+uO4dEuGF1lHW3tQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tWWs662E3yKSweTr8dILEaR2dGhy/4Ks5xyjiw2IZWB38UC3j7h5zeldhksnMkhxm
	 Bkc/5HCbEDmWF1JpJu06sYTulozi7B57KHoYtnYc02C6sQZsJl98W2BeVX+g8ieWZr
	 9hTtKpIvxr8lKkjZJsNlz/c2tDLR43vkg5PZi+Iq2L8RML/TEOzQSRiQBaV8b4Xvxp
	 CgIppIOELet7my1o1WiKni+Ssyw97BvXqgAWlly9rZ0r4ORCpCWNXf8rdPbAlvVlK5
	 5NrJWCjknP5QSeUuui3oLVulF8P6+8xHittM3ac3r2tjH08axAEpdneZBbXOWYUSjh
	 CQLDEeC+6zBSQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 595946008C;
	Thu, 27 Aug 2026 16:17:47 +0200 (CEST)
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
Subject: [PATCH net 6/9] netfilter: x_tables: replace pr_{info,err}() by pr_info_ratelimited()
Date: Thu, 27 Aug 2026 16:17:30 +0200
Message-ID: <20260827141733.423453-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260827141733.423453-1-pablo@netfilter.org>
References: <20260827141733.423453-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Several xtables extension still use pr_err() or pr_info() without
ratelimit.

For xt_cgroup, while at this, remove redundant "xt_cgroup:" prefix
since pr_fmt is already set on.

Fixes: c38c4597e4bf ("netfilter: implement xt_cgroup cgroup2 path match")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_cgroup.c | 12 ++++++------
 net/netfilter/xt_hl.c     |  4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/xt_cgroup.c b/net/netfilter/xt_cgroup.c
index 43d2ae2be628..28e6cd51b2fb 100644
--- a/net/netfilter/xt_cgroup.c
+++ b/net/netfilter/xt_cgroup.c
@@ -23,7 +23,7 @@ MODULE_DESCRIPTION("Xtables: process control group matching");
 MODULE_ALIAS("ipt_cgroup");
 MODULE_ALIAS("ip6t_cgroup");
 
-#define NET_CLS_CLASSID_INVALID_MSG "xt_cgroup: classid invalid without net_cls cgroups\n"
+#define NET_CLS_CLASSID_INVALID_MSG "classid invalid without net_cls cgroups\n"
 
 static int cgroup_mt_check_v0(const struct xt_mtchk_param *par)
 {
@@ -33,7 +33,7 @@ static int cgroup_mt_check_v0(const struct xt_mtchk_param *par)
 		return -EINVAL;
 
 	if (!IS_ENABLED(CONFIG_CGROUP_NET_CLASSID)) {
-		pr_info(NET_CLS_CLASSID_INVALID_MSG);
+		pr_info_ratelimited(NET_CLS_CLASSID_INVALID_MSG);
 		return -EINVAL;
 	}
 
@@ -49,7 +49,7 @@ static int cgroup_mt_check_v1(const struct xt_mtchk_param *par)
 		return -EINVAL;
 
 	if (!info->has_path && !info->has_classid) {
-		pr_info("xt_cgroup: no path or classid specified\n");
+		pr_info_ratelimited("no path or classid specified\n");
 		return -EINVAL;
 	}
 
@@ -59,7 +59,7 @@ static int cgroup_mt_check_v1(const struct xt_mtchk_param *par)
 	}
 
 	if (info->has_classid && !IS_ENABLED(CONFIG_CGROUP_NET_CLASSID)) {
-		pr_info(NET_CLS_CLASSID_INVALID_MSG);
+		pr_info_ratelimited(NET_CLS_CLASSID_INVALID_MSG);
 		return -EINVAL;
 	}
 
@@ -89,7 +89,7 @@ static int cgroup_mt_check_v2(const struct xt_mtchk_param *par)
 		return -EINVAL;
 
 	if (!info->has_path && !info->has_classid) {
-		pr_info("xt_cgroup: no path or classid specified\n");
+		pr_info_ratelimited("no path or classid specified\n");
 		return -EINVAL;
 	}
 
@@ -99,7 +99,7 @@ static int cgroup_mt_check_v2(const struct xt_mtchk_param *par)
 	}
 
 	if (info->has_classid && !IS_ENABLED(CONFIG_CGROUP_NET_CLASSID)) {
-		pr_info(NET_CLS_CLASSID_INVALID_MSG);
+		pr_info_ratelimited(NET_CLS_CLASSID_INVALID_MSG);
 		return -EINVAL;
 	}
 
diff --git a/net/netfilter/xt_hl.c b/net/netfilter/xt_hl.c
index 4a12a757ecbf..59e93d97b507 100644
--- a/net/netfilter/xt_hl.c
+++ b/net/netfilter/xt_hl.c
@@ -28,7 +28,7 @@ static int ttl_mt_check(const struct xt_mtchk_param *par)
 	const struct ipt_ttl_info *info = par->matchinfo;
 
 	if (info->mode > IPT_TTL_GT) {
-		pr_err("Unknown TTL match mode: %d\n", info->mode);
+		pr_info_ratelimited("Unknown TTL match mode: %d\n", info->mode);
 		return -EINVAL;
 	}
 
@@ -59,7 +59,7 @@ static int hl_mt6_check(const struct xt_mtchk_param *par)
 	const struct ip6t_hl_info *info = par->matchinfo;
 
 	if (info->mode > IP6T_HL_GT) {
-		pr_err("Unknown Hop Limit match mode: %d\n", info->mode);
+		pr_info_ratelimited("Unknown Hop Limit match mode: %d\n", info->mode);
 		return -EINVAL;
 	}
 
-- 
2.47.3

