Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906A84446F0;
	Fri, 31 Jul 2026 15:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785512062; cv=none; b=TEuSe/f13hGEOJmFpfIO7yT7D58bhUaQx4nM4D3EwkdhWAUXtBIWeOYHrvEaPGbZI8d6mnqJqyN5d3/LQ1VpO1LHqk1446oXAsQmbPz4K+C3fp3M2ZF5gl16NZB7KUDZ+YiZZRd01e9XJ5JYpqcinCX/LUreO82zlkn5QgVR8EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785512062; c=relaxed/simple;
	bh=Hkq1tS/vmesi5fDUZAhxYv5zQhHR2AKZXI75/c6mx/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KzE4yDjFjON+zOm2Hb1Xl4wbcaJ8unAmxGzbrTLFJpH4fUQm9OphQZVEw3SSy6afjmpYN9r5DhEQuS7pCWadAePaeuxzZdkn7IjMSqXzV286DLvoTtbevPbB/ys99qesbX9KN3Zy1ueYB/T4Vl+uw1Yybd3jAyuTf1suRTuQSE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=W69HcRre; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="W69HcRre"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6F12E602B3;
	Fri, 31 Jul 2026 17:34:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785512058;
	bh=Z5tJPqo2J9RRbztj9b+C22Me666yYLAH1Q41Qscf/qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W69HcRre680iu2cx73ybzWNbmGauQoQtjFsHlsRxCBfJt7dKjtYGrjDNdHLsjKoJx
	 i/1g0vaTvAN3Ck80sczIIMnINDQU7cH/hEDHpfGpCu8NVObKOUjm4KCNETjt3zycPY
	 K3NKFTN/E8cAjzC9gxqQgJCi0+HUD/ZmBekNK6Qndarz3W1ipprYMgwjSSAt1LiMmD
	 kYIfXlhHrOV9AlkMIP0IEUYJsNT+OE4LgyJvRyJ8fx3im42eOWTJwSasvaeRT8L03a
	 YPNom4OctsAmt+chORRM596zQhemKJ6evHHw5nPMVphfg/66A6XNX3B8c6NNHkNqAC
	 J01JBm9gxbSyQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 5/9] net: do not advance stack index from dev_fwd_path()
Date: Fri, 31 Jul 2026 17:33:58 +0200
Message-ID: <20260731153402.851224-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260731153402.851224-1-pablo@netfilter.org>
References: <20260731153402.851224-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update stack index from dev_fill_forward_path() instead, once the
forward path slot has been populated.

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
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

