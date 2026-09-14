Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435C3463B96
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Sep 2026 12:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789389222; cv=none; b=s1gv2fw1BCggm1Y6Eu2RxnzemQWpnAMml2I+Ygm9mLjcF4ihXlYyPYoPMQTSs9YAEsrwDgW/Y+mKOZQQw7mauQbz3sEWE5j8haez32+xjtGDPaNnTKD8RxzrGN43aVFQU4X40cDPN8/Emoe0tPyaztR+xTPLOa2r8LFsO9WxIvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789389222; c=relaxed/simple;
	bh=aFZduLWws3PfQNR14vltzqVwT9gBXOl50HVQnfIVy0s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LDAsPGxKkI0CV1ERR/w3loXWP3Z51rCIwyzQ1O4Kzt/0Ataku2Lt/KWQset+W4w9fYJPs8kwVCaoKUgmUdDl1h3iaUF89hG1QplrHXzkgCtZgCLD/JjrJUc+2UZmL6puchFkLealH2jTC7mwwzwsvNQA5hbni0kJ9sXkSEl4o9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=MAo8u+Wx; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="MAo8u+Wx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789389217;
	bh=wLPAcp7J3zwLeMDnznxHPnNcJyPKlkUvOCzDhEu1MfM=;
	h=From:To:Cc:Subject:Date:From;
	b=MAo8u+WxSE2mjOrtc8vitXu6g0BZR8fV3JTKdimj4wzHP25EYA/FKV1Rbkn9rJrPu
	 NoR0nBblGYyVxoh8+h10rRpvpuOfEHtEArQBbqEbmMj0LzJcx+XuOEssxCg8BiLoAC
	 dOklwYvk2b764jnx9k8kQPEhF5Dz8it/PAENNvRn3KSgk2xVNyY0fV+oiXQYYW9jjT
	 wLNC/uMbOk1tP+C2B4OQGamklvn5RmE4a9OVLYK2rJRe1ff0btHGFzvHCTO2PBEAcz
	 +mS3szOlOlZPq1V+TdW8t5YqzNTLYVn+COg1StanQfoa0J14rhg1GGsHeEahS2Ceyy
	 a4Srtd9wlc67Q==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8AEC960055;
	Mon, 14 Sep 2026 14:33:37 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: hauke@hauke-m.de
Subject: [PATCH nf,v2] net: update dev_fill_forward_path() to handle mac80211 special case
Date: Mon, 14 Sep 2026 14:33:34 +0200
Message-ID: <20260914123334.1964397-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Before commit b5964aac51e0 ("netfilter: flowtable: consolidate xmit
path"), there was a fallback to create a bypass in case
.ndo_fill_forward_path fails.

Commit d787a3e38f01 ("mac80211: add support for .ndo_fill_forward_path")
relies on such fallback, so most mac80211 drivers used to work since
they do not provide a net_fill_forward_path interface.

Add a special case to dev_fill_forward_path() by returning 1 in case
.ndo_fill_forward_path is implemented but this is expected to be the
last device in the forward path stack.

Fixes: b5964aac51e0 ("netfilter: flowtable: consolidate xmit path")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: do not incremental stack->num_path, use the existing empty slot.

 net/core/dev.c       | 4 +++-
 net/mac80211/iface.c | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index ecfbd72d5d1a..53140edfd1b4 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -787,6 +787,8 @@ int dev_fill_forward_path(struct net_device_path_ctx *ctx,
 		ret = ctx->dev->netdev_ops->ndo_fill_forward_path(ctx, path);
 		if (ret < 0)
 			goto err_out;
+		else if (ret > 0)
+			goto out;
 
 		stack->num_paths++;
 		if (WARN_ON_ONCE(last_dev == ctx->dev))
@@ -795,7 +797,7 @@ int dev_fill_forward_path(struct net_device_path_ctx *ctx,
 
 	if (!ctx->dev)
 		return ret;
-
+out:
 	path = dev_fwd_path(stack);
 	if (!path)
 		goto err_out;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 43460a705a6b..8c0cc2b4c6ed 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -998,7 +998,7 @@ static int ieee80211_netdev_fill_forward_path(struct net_device_path_ctx *ctx,
 	local = sdata->local;
 
 	if (!local->ops->net_fill_forward_path)
-		return -EOPNOTSUPP;
+		return 1;
 
 	rcu_read_lock();
 	switch (sdata->vif.type) {
-- 
2.47.3

