Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3E82116F5;
	Mon, 28 Apr 2025 22:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745878400; cv=none; b=nQqXvsBsntoQSBpBzOyFyGWLl1OObOgH6e3DfITDotWoJ2lFf0C7Lhn0+JzC5m/7gMAKc3FR48IiLHGKkVC+aeI+o3IaEUBLd6hckAyXGbfXXUUYO4a/YSgCvp6chb3g4KrSAaRl5NpJUM4owidypbswiUl5pKXmf+MuSZKa5I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745878400; c=relaxed/simple;
	bh=kAkFT9NuZe6p88r2is5Q7cvNbgfrv31Ru3I3UFnHJCk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kmyg0tTjjngbkf0ABawecku2mssD3R5SNjyidPkSF7BEtUZvSouMbu21hB4px4AeaGooZdM+sW9Zcpj/CbQ4j0UfxYoz2STG2Jf2amoQLj9UKaXfv5AhoELF/Ff06fNNLJn4gFlD/SHAw2gd3WZoKNROgioEbargKbw3lfXOkpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=EBw+Wd84; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=sp4ktBhS; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="EBw+Wd84";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="sp4ktBhS"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 23B486060F; Tue, 29 Apr 2025 00:13:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745878396;
	bh=TJWsdXZPBpv31JOUX7/ndIWlXpxGLhaWGE0QhtWFExw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EBw+Wd84ft/AUeJIRqcAvf+kBn53SS0Tmzd+4V4JFl90hlJyyLN2iTVXNytIDVg9J
	 MPsFoMFx3p8122GsSey2F99Vemv6Ru9LSodGWPaZwPwoEhXuOZTKccQveqdTy4Z+jx
	 svIq9zMLL1MDxVC9YANloARkIrEDN7MM2w2f5f8IlNsbX5MIzvNGQTAAKPnTPGoAsE
	 3tx+IA7jdbCjsIr8sU3zlS0Me/QjMY9Rbm/5bi9zMjA1fHWcUF52gFetpeCWMnd3WJ
	 bCyBiJllN+rA51gN4ZZCqZnSOw1GTqTFRFLgpq9xQAuf2lkY2CzEN8EJIlYEzrzxNN
	 kP35aOp5w4NlA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9016460560;
	Tue, 29 Apr 2025 00:13:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745878393;
	bh=TJWsdXZPBpv31JOUX7/ndIWlXpxGLhaWGE0QhtWFExw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sp4ktBhS3mNlPqWvfImhXFzvMYLOEJMbcYWKJfCDAt0B524KQ22FdqG4UA3GJVEnm
	 +6dE+DqrlqB1ABbOBnqdrM+lkhEZa9oujZzC6a4q1SpBGsJMBP9xSZdI2Tlr5tNqS9
	 RmQuoT20Emg+A9zYCyQQX/umpz++6Fvn+Vx9Z5w5VNuFec8GBNq+Cm1No9zOrIocqU
	 7tFCwQ0LtyYjF4kT1N+D3ZxQVG2lWhfpyC4F6piWmsNRex5T++pp9FDrQukD3tkybR
	 qMFQTHsTobKdQkQ2CPNOzc9PtHK/4DAtY89XdUcu4YGiRHo/ubh9itNy/ZO0XDyxeq
	 SK3Sb4JuoZzMg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 2/6] netfilter: xt_cgroup: Make it independent from net_cls
Date: Tue, 29 Apr 2025 00:12:50 +0200
Message-Id: <20250428221254.3853-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250428221254.3853-1-pablo@netfilter.org>
References: <20250428221254.3853-1-pablo@netfilter.org>
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

