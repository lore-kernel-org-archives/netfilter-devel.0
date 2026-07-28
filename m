Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2CA428498
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2026 12:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785241592; cv=none; b=gB8RuciK2Zu1sLe2nKKwL+aVKKDezMhGNBrf/DfR0kXMJUoZirkUNEzUa9E8ASklke4+23HNO5tme6PrI5oWHqMoxJOOl3BtdNvugvi5YZpxjpAlqnfw1OP366awcOfXqCl75iDZjAZvnXwLB1iBPxvlUrkSGudVQ94mrXHoFJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785241592; c=relaxed/simple;
	bh=bj1Ide9ULUrwQXUgjcfKdLPBwfQisqLpeeRZtNHtRxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZOrNq6Um94sb4j5o6zOQLEk4IB2Wpe72G3JLlvQEiloX9acFq1/ex4uHGnYLrgPrmcjBllcfqRX/cTLMxoWfEE64KGwR4wtYEJlIu2dPljhdXHbSpcUwYcfIfy4Qvsrjx6ZxvkEN2mbs+mvDxLAA6uTx3F8b4M2DpnV6if05jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=nxzzoQzu; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="nxzzoQzu"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7F40B601A4;
	Tue, 28 Jul 2026 14:26:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785241583;
	bh=lX5lW3qYPh/KfRImWO9P5UBaJ0YwfOKBY90pYWug4wY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nxzzoQzuwPjvIqzWF2G7eXAMaSBH+3lD9bUm940LDc59O0P6NMs5GZ5J4W9ALlgqH
	 nv4zQTn+6JGDM1U257i6w9q4FPXLRcT/PAQheiibGB1nWY1FZORWs3BQX8u2+qoDv6
	 FJHwk8Fi3SGoxQt5SgenQ2/39vKDj/4o41A2ZEPmc02XTd5H1JXyLehZLMb0GSrinj
	 suUAuNJiDTIbidDweCo6giGVHJKpsAawRDi/2ow3F2t2I8zLjZLERn158BYh1B8IMa
	 Amps6V8zl9Lz91TrltVf8c3uzWHMErD4H7DCxEw1kgclCI7nhepuMCe8kSc6G133eA
	 yx/2dHsyrxLIg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: lorenzo@kernel.org
Subject: [PATCH nf-next,v4 3/5] net: do not advance stack index from dev_fwd_path()
Date: Tue, 28 Jul 2026 14:26:13 +0200
Message-ID: <20260728122615.142843-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260728122615.142843-1-pablo@netfilter.org>
References: <20260728122615.142843-1-pablo@netfilter.org>
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
v4: - incorrect check for maximum NET_DEVICE_PATH_STACK_MAX in dev_fwd_path()
    - remove update on drivers that break access to path stack

 net/core/dev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index c1c1be1a6962..429a55fff667 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -742,12 +742,10 @@ EXPORT_SYMBOL_GPL(dev_fill_metadata_dst);
 
 static struct net_device_path *dev_fwd_path(struct net_device_path_stack *stack)
 {
-	int k = stack->num_paths++;
-
-	if (k >= NET_DEVICE_PATH_STACK_MAX)
+	if (stack->num_paths + 1 > NET_DEVICE_PATH_STACK_MAX)
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

