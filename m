Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B416442B03;
	Fri, 31 Jul 2026 15:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785512061; cv=none; b=g5fvoQwzWQ+2CMuH4beKixIbjnqsk6BwvHRxAQxWUnQ3VQqAvHQg1Dvbn2A5IJDLrrVeT2ylRJcHXuUd518fM2jhc3G5xmmulBTzuUXEHJRQ963Fy6k9esvGjUTGR/2BDo3wf4WuCb2sarXoMLjP1adG6uGYbQgHNJNsb4ElUW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785512061; c=relaxed/simple;
	bh=brlzHYIoS88nrQnv4HN65dJGmR1V3gir4H9eZ3fZcQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C/mAwovSawufY1NjM1OZ/Z7IUNf4h31cBelCDsfcHksAFnKlwYqMLCmfW+JRYFYGxyGDOi/X1TjbFmTCOQn4ftq3FDwOS3y+47NVNLxzOYafb6P4v/vxDK+1hVGg8nyyK93YPOazb+jIBohITbCiZd7vW6OmwXrG1JITcp3cGbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=hUMFCgMT; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="hUMFCgMT"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 310FF602B2;
	Fri, 31 Jul 2026 17:34:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785512057;
	bh=yFYvJMu3h8X5ZAFuwVlvoNYHsw2+sPJS2LG2ZSUag7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hUMFCgMTuCLXwebf9MGPKLfwtU8N+iNTpkNaxvJtyi1pQw0G1ks+Isc3AI62MUOgO
	 vSjtF3uUXMJsWPD7pIoP91roBuPV3z415qn/FWCHHoJsQRc9awShnVbWD/FrYm54eY
	 +7eZjS/8iMAM7hnxbvokYWXNMh1MsRvqf+6ww1Igj/Pd1fSZqf5I7iJhoSYMl+s2Gf
	 zKH9sHYbHRHzjfABM0DCIfqqDpivJOMHeEzdInwEZZjAwaxjvwntyyKuOVPulH6A+Y
	 7zpnGwxJRl2OKUFIz+PBxPAXDQvEkM7qFeOpH7rHGabgTG2wkt+hf+Bhyx1mwIyR1k
	 3No4peWFUyscg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 4/9] net: dsa: stop at the user device in .fill_forward_path
Date: Fri, 31 Jul 2026 17:33:57 +0200
Message-ID: <20260731153402.851224-5-pablo@netfilter.org>
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

The flowtable path discovery stops at the DSA user device when setting
up the forward path. Let's just report there is no more devices after
the DSA user port through the .fill_forward_path interface.

No functional changes are intended.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/dsa/user.c                     | 3 +--
 net/netfilter/nf_flow_table_path.c | 7 ++-----
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/net/dsa/user.c b/net/dsa/user.c
index 03c7af6abe18..4065c6ee6fc6 100644
--- a/net/dsa/user.c
+++ b/net/dsa/user.c
@@ -2547,14 +2547,13 @@ static int dsa_user_fill_forward_path(struct net_device_path_ctx *ctx,
 				      struct net_device_path *path)
 {
 	struct dsa_port *dp = dsa_user_to_port(ctx->dev);
-	struct net_device *conduit = dsa_port_to_conduit(dp);
 	struct dsa_port *cpu_dp = dp->cpu_dp;
 
 	path->dev = ctx->dev;
 	path->type = DEV_PATH_DSA;
 	path->dsa.proto = cpu_dp->tag_ops->proto;
 	path->dsa.port = dp->index;
-	ctx->dev = conduit;
+	ctx->dev = NULL;
 
 	return 0;
 }
diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 8f04a4487897..004dc75ac357 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -114,12 +114,9 @@ static int nft_dev_path_info(const struct net_device_path_stack *stack,
 			if (is_zero_ether_addr(info->h_source))
 				memcpy(info->h_source, path->dev->dev_addr, ETH_ALEN);
 
-			if (path->type == DEV_PATH_ETHERNET)
+			if (path->type == DEV_PATH_ETHERNET ||
+			    path->type == DEV_PATH_DSA)
 				break;
-			if (path->type == DEV_PATH_DSA) {
-				i = stack->num_paths;
-				break;
-			}
 
 			/* DEV_PATH_VLAN, DEV_PATH_PPPOE and DEV_PATH_TUN */
 			if (path->type == DEV_PATH_TUN) {
-- 
2.47.3

