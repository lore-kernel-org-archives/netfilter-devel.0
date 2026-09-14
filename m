Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39108421EF4
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Sep 2026 12:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789388706; cv=none; b=ssXXiUoVPPrtHPvCsP45PiO2Rk5c0xAyn1+r6rcskzG+uHKZNx4aMuJcNUKxS4qHAq8SQ/lR0LX6teEZPeaU8Aa+YXgjd7qL2r5SXB3G0jpSnsMLXS3TpRiBoxRauBVWZ+5AIo7HQvTbX8VTAYZG5xaTE1JPaP9I6CLjqakDFoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789388706; c=relaxed/simple;
	bh=RNZ2QmOCWgc6YcoYgWqxxzAu7Go0FZkMZInw2knM3iI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZhiuDkrJeppSU3EwiXANdjw6u5sxbPJPmQV6BNwp9b8oYl0UVLAZQ/W8xmSrge2m0u6HdUgb5dzXApYlBQZ/gxlKPASMcLObz4/OGeWu8Z688EpcbBowI+iycSiQDSFet2i3PL/in5ZLgmkPLeyzNcywe9aKbMMLiia2fgFTDNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=P++j/UUa; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="P++j/UUa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789388699;
	bh=TJVmMabaQmAZV6/XCOC58WlWAkbVFRvUCtuFlslTPio=;
	h=From:To:Cc:Subject:Date:From;
	b=P++j/UUa3OSmTG4S5RgjRAoJc0yvEF3969tXLAdaZqdZ7snX9qLnrFCO0V201cyJY
	 IOq03t01I3CMKZcJXTcrQNuOXDt0BO6OKwxeq2vTIQf9+if83HJmnwFTxBBFcOvtg2
	 O2lY/r12cbi1SBXgqjWzqLjP+50yIIwCAgSfhMryPDPTvFLVmRCmOl3il6ZCvtzcP9
	 EJQM0K7s7xDwq56wfqf3yupKyu0Q72RY/r1EdxC6VfpmKmAKLeWsC3bz3b+4UUiAMl
	 B7IisNqRPCb3qYI1WGzi9DVl+NFOxKcd6t7vX8zqFSI1QyCeLOj42BM8tPsEZB0/ld
	 jnwW8sVZhm7Mg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B276760055;
	Mon, 14 Sep 2026 14:24:59 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: hauke@hauke-m.de
Subject: [PATCH nf] net: update dev_fill_forward_path() to handle mac80211 special case
Date: Mon, 14 Sep 2026 14:24:56 +0200
Message-ID: <20260914122456.1963453-1-pablo@netfilter.org>
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
 net/core/dev.c       | 5 ++++-
 net/mac80211/iface.c | 2 +-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index ecfbd72d5d1a..0f80cce3f02d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -789,13 +789,16 @@ int dev_fill_forward_path(struct net_device_path_ctx *ctx,
 			goto err_out;
 
 		stack->num_paths++;
+		if (ret > 0)
+			goto out;
+
 		if (WARN_ON_ONCE(last_dev == ctx->dev))
 			goto err_out;
 	}
 
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

