Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A8D3F65EC
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2026 11:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785236995; cv=none; b=l7tageheuqi7/wX/wHfU9P1ng4uF9mVdMJ6PbqQ3cqnEYyz8VfQeEgXMOc7WrUfMHDB1yHfjb+Y544Dh4qMt0MAHwb8hbkHxALSFTyPMC2oK8ub5Qz4vGiuXCWoleaOE90qhRvdaX/Fz8hRlGqX/wLF8DoDfmvwEbOT4p2M3f2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785236995; c=relaxed/simple;
	bh=hbgSRUjFbA/G+5RnAnowYL0CwzVsXsvg/H0Zua+aRlQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bcnMZ4YN+2geKxlbhNKFZnFbOvkuSAzkgXRSC8atmbVDtgQxNu4j43oFrOm3GqeBRVeEEU3ndyndvtSfIXLM5kZVLgydamBvm8C31e0e/fXWT96hII2f65tjF1DvuEWH2kOxzxJXk/hSSLnyrs62Es/WDifCRQaFXYbZXqrbBWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Kecu1Zn+; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Kecu1Zn+"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 23BD96019B
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2026 13:09:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785236991;
	bh=W7S82bahKFwD/0DEotjf/LYgeOrlTZyh1555sOz3A9k=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Kecu1Zn+LdOtgpXNsKD6C35p/OFAkqWNEtaqi13gtGY9jEC6uV8o+dyskI49KsL0+
	 W3sZwwu10YunZ2O+N42hgR+h6uG1TUQuigMhpXqKP9bB6DuTmrYVaYP6n/BwUIaf9c
	 RmYJbj77VTwXBQK3gRGVBCmjo0jgcQwWxaKx9Q9umdLL1vg8DtxMcNGv3FGt3Rq0+c
	 7T7yz2z/NFIr8iq8n7QRbtG+AJ1ticD3AoiI9ZEYDixNA8P+akvHfB7xSPf0CD7l1U
	 +gmQxOAFlyk7P8bp6cW5dFr6oj8nLIfgg8FecKJELMTYEpTP+MRxuW0vdBg04NWL3N
	 ix3iXNLqlzsuQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v3 3/5] net: do not advance stack index from dev_fwd_path()
Date: Tue, 28 Jul 2026 13:09:40 +0200
Message-ID: <20260728110943.124900-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260728110943.124900-1-pablo@netfilter.org>
References: <20260728110943.124900-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update stack index from dev_fill_forward_path() instead, once the
forward path slot has been populated.

Adjust existing drivers that recycle dev_fill_forward_path() as a
way to reach the mtk SoC WDMA info.

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: remove k index variable per Lorenzo.

 drivers/net/ethernet/airoha/airoha_ppe.c        | 2 +-
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c | 2 +-
 net/core/dev.c                                  | 8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_ppe.c b/drivers/net/ethernet/airoha/airoha_ppe.c
index e4c3644dd6ec..72755ca974fa 100644
--- a/drivers/net/ethernet/airoha/airoha_ppe.c
+++ b/drivers/net/ethernet/airoha/airoha_ppe.c
@@ -292,7 +292,7 @@ static int airoha_ppe_get_wdma_info(struct net_device *dev, const u8 *addr,
 	if (err)
 		return err;
 
-	path = &stack.path[stack.num_paths - 1];
+	path = &stack.path[stack.num_paths];
 	if (path->type != DEV_PATH_MTK_WDMA)
 		return -EINVAL;
 
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index cc8c4ef8038f..7dab360b8be3 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -107,7 +107,7 @@ mtk_flow_get_wdma_info(struct net_device *dev, const u8 *addr, struct mtk_wdma_i
 	if (err)
 		return err;
 
-	path = &stack.path[stack.num_paths - 1];
+	path = &stack.path[stack.num_paths];
 	if (path->type != DEV_PATH_MTK_WDMA)
 		return -1;
 
diff --git a/net/core/dev.c b/net/core/dev.c
index c1c1be1a6962..96c01f6e9dea 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -742,12 +742,10 @@ EXPORT_SYMBOL_GPL(dev_fill_metadata_dst);
 
 static struct net_device_path *dev_fwd_path(struct net_device_path_stack *stack)
 {
-	int k = stack->num_paths++;
-
-	if (k >= NET_DEVICE_PATH_STACK_MAX)
+	if (stack->num_paths + 1 >= NET_DEVICE_PATH_STACK_MAX)
 		return NULL;
 
-	return &stack->path[k];
+	return &stack->path[stack->num_paths];
 }
 
 int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
@@ -773,6 +771,7 @@ int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
 		if (ret < 0)
 			return -1;
 
+		stack->num_paths++;
 		if (WARN_ON_ONCE(last_dev == ctx.dev))
 			return -1;
 	}
@@ -785,6 +784,7 @@ int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
 		return -1;
 	path->type = DEV_PATH_ETHERNET;
 	path->dev = ctx.dev;
+	stack->num_paths++;
 
 	return ret;
 }
-- 
2.47.3

