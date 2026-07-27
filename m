Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A463EE1E9
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Jul 2026 11:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785153591; cv=none; b=c/b2E1IvZRoj172v9n4THw3EFrhBzbGzmFeRXURzchvbivjhdCT3xUysxm5SEoIZ/B7AbxhiS2AY+a8dVRyKh7lSHNVlVALQsEUTk/JNn8lfhIauTyF1Bd5EWumeOfSwrvHYE7C/X40nY7BuVnodFqmj454Uux0OiaP96M2/Llk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785153591; c=relaxed/simple;
	bh=E3cmr1joymIzI+RPdeNKfDQxQJrtxf2VIqqlOhcmNR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sZk6rpVud+mshl1RXGa1/YVrgFolIgaMA+GgxRUkg39HW/7lcPwun98N4BV3MlK2GxWwxCOfG2aEUkjBu2aieiiNNY3cyVnnC5eGrOyYdZbkAr5wuSCewM00oiODS5F8xru9YZvZXFvmqN5fsmG/6l+ddU8X+OMCHnl+NE6GCKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Tfyauhk6; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Tfyauhk6"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9E4B6601A4;
	Mon, 27 Jul 2026 13:59:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785153581;
	bh=I7GO9QdCUZwt23I1mzBAnla1z9SN5COWfzMOSBzMI0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tfyauhk6iV3z3aMe3fkGr1elnjXWWCFhhxJXN35Q/h4oHGbozpPnW3BvF0UjRRjx0
	 j4Sfenrn8aRBD61rpgd4Zlpfdq6WzEk6677A5+qq9ioPF9L6Et9Oi9YKY5AY/1VMYQ
	 h5Qax06twpXOWNPH93mvPuz0xYworfux/cGcYmR1ZKKbxEY1rKF33bzTi4M2fcKsKJ
	 Ada0p+PESA0MUV0mNgDI5EScO54tsvhl+9n63Sz+v8zErFfnlewvQZRmfamebKcyzA
	 qKJIT4oXctAgmAC2neQC2qWH1iJqp+jZkERy9EGhVknJDCh2TIk6h4SPkXUJNdGvAy
	 UfEQauvRlTNJw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: lorenzo@kernel.org
Subject: [PATCH nf-next,v2 3/5] net: do not advance stack index from dev_fwd_path()
Date: Mon, 27 Jul 2026 13:59:30 +0200
Message-ID: <20260727115932.88335-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727115932.88335-1-pablo@netfilter.org>
References: <20260727115932.88335-1-pablo@netfilter.org>
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

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: new in this series to address sashiko report on possible access
    to uninitialized path in stack in case tunnel route reference
    need to be dropped.

 drivers/net/ethernet/airoha/airoha_ppe.c        | 2 +-
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c | 2 +-
 net/core/dev.c                                  | 6 ++++--
 3 files changed, 6 insertions(+), 4 deletions(-)

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
index c1c1be1a6962..ca65d1dcd604 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -742,9 +742,9 @@ EXPORT_SYMBOL_GPL(dev_fill_metadata_dst);
 
 static struct net_device_path *dev_fwd_path(struct net_device_path_stack *stack)
 {
-	int k = stack->num_paths++;
+	int k = stack->num_paths;
 
-	if (k >= NET_DEVICE_PATH_STACK_MAX)
+	if (k + 1 >= NET_DEVICE_PATH_STACK_MAX)
 		return NULL;
 
 	return &stack->path[k];
@@ -773,6 +773,7 @@ int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
 		if (ret < 0)
 			return -1;
 
+		stack->num_paths++;
 		if (WARN_ON_ONCE(last_dev == ctx.dev))
 			return -1;
 	}
@@ -785,6 +786,7 @@ int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
 		return -1;
 	path->type = DEV_PATH_ETHERNET;
 	path->dev = ctx.dev;
+	stack->num_paths++;
 
 	return ret;
 }
-- 
2.47.3

