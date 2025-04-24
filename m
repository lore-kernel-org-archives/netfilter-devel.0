Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB00219995E;
	Thu, 24 Apr 2025 21:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745529321; cv=none; b=ooT6YeHfATjhka2rAX6IyyXihj8qlajFC6pa3hzbxAwjzkjg1KfNWMKGJ7eh5cVNE6mpB3rFXTIp5Bl9k58e57BFJulJVwpzef3itiD9cney8erdCksbI8J2PorGY51kk79C+RwxFomjZbCPcTdaYV+s1UwBXtjiZklk9dcb89E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745529321; c=relaxed/simple;
	bh=kAkFT9NuZe6p88r2is5Q7cvNbgfrv31Ru3I3UFnHJCk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fp1wD7+klHC3XsRiA0FpvcMveEHxQuk1dlpMHydMjIUdcw/4j2YvYIQM+97qJVqob1r5IsBs+qAuS4luEdZ3j33Bh5JP58rqJ2+kTDHWghqVAdEpQYRXW4z++cA/c/M2syW+1zZnewyvE4xAuyUf9tuYnpq/oyNag296hs2Jshk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=cJYdQdwG; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lR1wF74E; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="cJYdQdwG";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lR1wF74E"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 17A626071A; Thu, 24 Apr 2025 23:15:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745529316;
	bh=TJWsdXZPBpv31JOUX7/ndIWlXpxGLhaWGE0QhtWFExw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cJYdQdwGA4L3KccCGJK70zHX+jlx2MTEv0X5UNWZLNj0yZI0l7GrkzXr9vLo/ucnG
	 dLmzrXDHlV2GJKJDlNxSTTKQs2s+Tl25yemUK9vVZubU1Lfe2JqG9ZALZdkdjbcOZO
	 VLB9+Fm8yd4Omnoimk2VZCJ0Nm553KtP5SqUwo0WFASFdnjgE/ORGYNzINCrybHnj6
	 R202Ioor+fy5VageDjlRYPHOvPtdS+ZJEexVeMd4bWdALNhcgx3tOgdbQlPkv1rx9O
	 iXqCF/CYE11TWHDkTTXlYZCZ6p28NGdwG9ngZoVADlapgpfZg2nIwJ17S/zEG/FZuJ
	 k1xgQNyujUH6A==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 29B2B6070B;
	Thu, 24 Apr 2025 23:15:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745529312;
	bh=TJWsdXZPBpv31JOUX7/ndIWlXpxGLhaWGE0QhtWFExw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lR1wF74EPCNxtRUMJRH5qdZXWxn4K3CEsFiXV/8VysQCY4P2msiNwQyxLeXNJjBMm
	 bnNUacPHBTdFEFmImJsCNZS9BaTyjIZCGjnaAV338QXGQkVDNU2kzuv7nRg84zhJdf
	 VkGfxve0ebkk08daEVd5q3Zn2Nja/8IMz1/oiYqrhVn/RVu80fNC9bVQRW8HRY8UO3
	 Mb7sSODoHl5dJPqhrCmsHGqoRjzI6EV0KZMuymGwLtqYZKFFDVWlvNpqM7GckmcErz
	 IhbfwlqFbf1GwVtKU42j4W/jMUTxbmxSSOLmEfz/2xSDO4ZF/VZ/OzYfrfiKExKyHN
	 mQbglP9hjGQvw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 2/7] netfilter: xt_cgroup: Make it independent from net_cls
Date: Thu, 24 Apr 2025 23:14:50 +0200
Message-Id: <20250424211455.242482-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250424211455.242482-1-pablo@netfilter.org>
References: <20250424211455.242482-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michal Koutný <mkoutny@suse.com>

The xt_group matching supports the default hierarchy since commit
c38c4597e4bf3 ("netfilter: implement xt_cgroup cgroup2 path match").
The cgroup v1 matching (based on clsid) and cgroup v2 matching (based on
path) are rather independent. Downgrade the Kconfig dependency to
mere CONFIG_SOCK_GROUP_DATA so that xt_group can be built even without
CONFIG_NET_CLS_CGROUP for path matching.
Also add a message for users when they attempt to specify any clsid.

Link: https://lists.opensuse.org/archives/list/kernel@lists.opensuse.org/thread/S23NOILB7MUIRHSKPBOQKJHVSK26GP6X/
Cc: Jan Engelhardt <ej@inai.de>
Cc: Florian Westphal <fw@strlen.de>
Signed-off-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/Kconfig     |  2 +-
 net/netfilter/xt_cgroup.c | 17 +++++++++++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 047ba81865ed..3b2183fc7e56 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -1180,7 +1180,7 @@ config NETFILTER_XT_MATCH_CGROUP
 	tristate '"control group" match support'
 	depends on NETFILTER_ADVANCED
 	depends on CGROUPS
-	select CGROUP_NET_CLASSID
+	select SOCK_CGROUP_DATA
 	help
 	Socket/process control group matching allows you to match locally
 	generated packets based on which net_cls control group processes
diff --git a/net/netfilter/xt_cgroup.c b/net/netfilter/xt_cgroup.c
index c0f5e9a4f3c6..66915bf0d89a 100644
--- a/net/netfilter/xt_cgroup.c
+++ b/net/netfilter/xt_cgroup.c
@@ -23,6 +23,8 @@ MODULE_DESCRIPTION("Xtables: process control group matching");
 MODULE_ALIAS("ipt_cgroup");
 MODULE_ALIAS("ip6t_cgroup");
 
+#define NET_CLS_CLASSID_INVALID_MSG "xt_cgroup: classid invalid without net_cls cgroups\n"
+
 static int cgroup_mt_check_v0(const struct xt_mtchk_param *par)
 {
 	struct xt_cgroup_info_v0 *info = par->matchinfo;
@@ -30,6 +32,11 @@ static int cgroup_mt_check_v0(const struct xt_mtchk_param *par)
 	if (info->invert & ~1)
 		return -EINVAL;
 
+	if (!IS_ENABLED(CONFIG_CGROUP_NET_CLASSID)) {
+		pr_info(NET_CLS_CLASSID_INVALID_MSG);
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
@@ -51,6 +58,11 @@ static int cgroup_mt_check_v1(const struct xt_mtchk_param *par)
 		return -EINVAL;
 	}
 
+	if (info->has_classid && !IS_ENABLED(CONFIG_CGROUP_NET_CLASSID)) {
+		pr_info(NET_CLS_CLASSID_INVALID_MSG);
+		return -EINVAL;
+	}
+
 	info->priv = NULL;
 	if (info->has_path) {
 		cgrp = cgroup_get_from_path(info->path);
@@ -83,6 +95,11 @@ static int cgroup_mt_check_v2(const struct xt_mtchk_param *par)
 		return -EINVAL;
 	}
 
+	if (info->has_classid && !IS_ENABLED(CONFIG_CGROUP_NET_CLASSID)) {
+		pr_info(NET_CLS_CLASSID_INVALID_MSG);
+		return -EINVAL;
+	}
+
 	info->priv = NULL;
 	if (info->has_path) {
 		cgrp = cgroup_get_from_path(info->path);
-- 
2.30.2

