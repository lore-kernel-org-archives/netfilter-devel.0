Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0579E3F2110;
	Wed,  1 Apr 2026 10:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775039819; cv=none; b=LFsEHTwuGqvYbw2U9G0vGUWaDflZlg6k2siBGZuVqB27+gPSsdQAoRfynJ1sWIeoTZLaNVW9lqjgjKBDmGKZGcxgyvbfX/DxYoKsV3r4MlkKuOHYO3NITMB3ZpBMOt34ekcpv5E9YshNk3im1u4TATuKCidCL6DGj/uedDhC9oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775039819; c=relaxed/simple;
	bh=lHbfzDCL4CQjhVTC9VBEUuxaFaMpd1hReq6nHALFb4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JfYH7EdOZ+Nsk5+3XheUIupyVx0V2dydHHsuXyHJdKPFLNOSI6jY0W/vXZjPZtI7gqHP4uc4ftphQe9fwYX9G4ZGf6ZUFYNceA6VDs4DN3Pq9+MI5y5lEJCqNWI37QMIbKuQxqekc7TioiTjj7zREQ2PFCnVm9KrYfC4p04dk00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=L7ZILSZ/; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="L7ZILSZ/"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id EE26D60262;
	Wed,  1 Apr 2026 12:36:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1775039816;
	bh=iUs+PYCF8WXjzWUpXuoiflvf9L6KRJafjcWAbyG9VH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L7ZILSZ/+1bi+ZkJLcUQ/Bqq8XPysVheENKtX0DUTvrEv6aE6RvanR8eCPy8doJM1
	 HI9SrJ5mNEVmNlT8qffKyve29ef/FCyJUUPfMtRxHThBJpwMMJBpgWzSaMwx8xUbUe
	 gL52e8pU/V2+pkkL7PGiyszw6KNl5WxcA32oyMCqrsNTDz3i5TTbJB4VFYDlZ6WDrm
	 F52+P9a30aWfb3hoZFlAyc9sJbCGt7IodSUk7SqHDSr5u8vr/gdxh560M1dP4Im+w1
	 SspZjjqUhG9yl7aTmIm5Ekf9AqkOfCS2QjK31qJCOYz3Ph5B33RWTdB/gPrclq83Et
	 0b72PVr/1OhWg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 03/10] netfilter: x_tables: ensure names are nul-terminated
Date: Wed,  1 Apr 2026 12:36:39 +0200
Message-ID: <20260401103646.1015423-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260401103646.1015423-1-pablo@netfilter.org>
References: <20260401103646.1015423-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Reject names that lack a \0 character before feeding them
to functions that expect c-strings.

Fixes tag is the most recent commit that needs this change.

Fixes: c38c4597e4bf ("netfilter: implement xt_cgroup cgroup2 path match")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_cgroup.c  | 6 ++++++
 net/netfilter/xt_rateest.c | 5 +++++
 2 files changed, 11 insertions(+)

diff --git a/net/netfilter/xt_cgroup.c b/net/netfilter/xt_cgroup.c
index c437fbd59ec1..43d2ae2be628 100644
--- a/net/netfilter/xt_cgroup.c
+++ b/net/netfilter/xt_cgroup.c
@@ -65,6 +65,9 @@ static int cgroup_mt_check_v1(const struct xt_mtchk_param *par)
 
 	info->priv = NULL;
 	if (info->has_path) {
+		if (strnlen(info->path, sizeof(info->path)) >= sizeof(info->path))
+			return -ENAMETOOLONG;
+
 		cgrp = cgroup_get_from_path(info->path);
 		if (IS_ERR(cgrp)) {
 			pr_info_ratelimited("invalid path, errno=%ld\n",
@@ -102,6 +105,9 @@ static int cgroup_mt_check_v2(const struct xt_mtchk_param *par)
 
 	info->priv = NULL;
 	if (info->has_path) {
+		if (strnlen(info->path, sizeof(info->path)) >= sizeof(info->path))
+			return -ENAMETOOLONG;
+
 		cgrp = cgroup_get_from_path(info->path);
 		if (IS_ERR(cgrp)) {
 			pr_info_ratelimited("invalid path, errno=%ld\n",
diff --git a/net/netfilter/xt_rateest.c b/net/netfilter/xt_rateest.c
index 72324bd976af..b1d736c15fcb 100644
--- a/net/netfilter/xt_rateest.c
+++ b/net/netfilter/xt_rateest.c
@@ -91,6 +91,11 @@ static int xt_rateest_mt_checkentry(const struct xt_mtchk_param *par)
 		goto err1;
 	}
 
+	if (strnlen(info->name1, sizeof(info->name1)) >= sizeof(info->name1))
+		return -ENAMETOOLONG;
+	if (strnlen(info->name2, sizeof(info->name2)) >= sizeof(info->name2))
+		return -ENAMETOOLONG;
+
 	ret  = -ENOENT;
 	est1 = xt_rateest_lookup(par->net, info->name1);
 	if (!est1)
-- 
2.47.3

