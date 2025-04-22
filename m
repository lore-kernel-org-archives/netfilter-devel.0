Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6432BEC2A;
	Tue, 22 Apr 2025 20:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745353437; cv=none; b=f3sEwNiM0iMS1ULob5Cklo4A1s9jNnFVkFj8Q/VLlJxw3Sh8F4G4IeCKDq34Ceq4ldYAkTnbcQkvU4SQDw0UHZK4/oKitI6vB18bAtK0NEr6pfOtc3tdsDSjUVXKk5nwBwaGs6sd2BbYWoaUMw4aX8sXI8t9+aMH1HLrd2/Zue8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745353437; c=relaxed/simple;
	bh=kAkFT9NuZe6p88r2is5Q7cvNbgfrv31Ru3I3UFnHJCk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BvI15TnMSH7IVDpVE7/vAKElZXBrIbJQ/uybvepgBbodhnGC+cluHVnVgm14/IX5GomylVRVgiVxKDstnw4knLGDog6pZ6aClX8b6tQvqLhrlFjB7nPnZfgTbD+B7yRNjgUVwEy60BTStEhHT9c7WAxkhGafG1M/Ih4tMtouwX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XVgeu8c6; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=okNxpcFS; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XVgeu8c6";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="okNxpcFS"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 1BA24609D0; Tue, 22 Apr 2025 22:23:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745353434;
	bh=TJWsdXZPBpv31JOUX7/ndIWlXpxGLhaWGE0QhtWFExw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XVgeu8c6b6WUzYEe1s/DUj2sZ3ljF0HEI6krbL9TNhrM+bwh+QqyeoBNMFFEsk4hl
	 wdmIvk+FRvUHEv1bnd2/ioLXzxlqsfoLB5SJfCzZSHrtumRwkyiqmS0ZtpZzVFp44X
	 xwQkxeOLwrZoBoOSxhKZaL7IRubBbkXMH/N85dq5e1OPWqd5SAuQrvooZWrw5aS12a
	 +mQkNKY5VFDhq+0Iy9PAlaEi4ChZyu+tmHQ9SpFPZMlPoD8MqBXw4G5FKaej108soo
	 n+UkS3X1CCeIsKfUKtrA0erRJIkv6Veq/DPmhHwG5pr5l29gC748Cy37ey4XZ+Y6mt
	 Z/SIuPX9ufyUg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C59C4609BE;
	Tue, 22 Apr 2025 22:23:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745353430;
	bh=TJWsdXZPBpv31JOUX7/ndIWlXpxGLhaWGE0QhtWFExw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=okNxpcFSj4fstu/KngTvzO6x+2yJxkzzFSOxkh5XpmMnBMhkM6FNV064UNvXDrwOT
	 Le4d8oUraStHNRyHF9BIkcFF2nc46559IxUsZeXVzSNAOCSyhLRAfiUopGPxMGnQrW
	 ZG3Nlg5y/gKOk6pXgBJ1E7cBtGx1B+gPm9AFV7WnINilb1xDN1TBIptP86xqFtNg+7
	 ztIJq6ykWyvdzRxDQlGymwcbk/3nI3c3HWK1A4MpobOtm0dwmftSVNWxQ4cpcCKbyo
	 Fzeevez3yscoOiOUxFPqj1uEksabg2hjdpuRGOf1Cy5AfQALl0iktaCTN+wYTXr0tt
	 EaHchz5XIplRQ==
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
Date: Tue, 22 Apr 2025 22:23:22 +0200
Message-Id: <20250422202327.271536-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250422202327.271536-1-pablo@netfilter.org>
References: <20250422202327.271536-1-pablo@netfilter.org>
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

