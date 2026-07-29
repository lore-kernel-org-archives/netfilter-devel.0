Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDAD47A0B8
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 11:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785325797; cv=none; b=ddJDaTjTwI0xrvc5Kh0l9Dc/DB5Pey0Jl0G4Spj03MGzGA4YregUMxCMOE7dl3IOmiiJhCPn1CVr0bmgpzyTewzIMXPmmR79/KbZI22qNRTL2zyNFNhE6gVkqG/yt88uco9CXONFOQVnHvuBM4h1mLF8AaW+q5jOk8qr4nEDxtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785325797; c=relaxed/simple;
	bh=jSOu3E0tCM1Cv8n/VQZpDVlsnL2yHvgS+Roc78CJqr8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iCbolwtZbUErpI/yJG3eMtr9oM/bdkIZT+35HPZwz1ju6N0GN9mqTwHDXcahd36LnIek5Td+a9/rctzRHY2Om3Ewu5ArmQSp2UHO4ewJcZCFuaeDJJvw8Rq1pwSbMZfZdx8MrJ2AN/HZL2ExNSWXGy8TXctqnULBLVSgxKOSn6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=KYGMfJTR; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="KYGMfJTR"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A3F376019C
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 13:49:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785325793;
	bh=lQkat3112YkquITSO4S/QPYKRLWsg2wK2em+uqcsggk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=KYGMfJTRcABZItvhC9zqJN4zu2DyGCbJ/q3XNGi+pBebUb5KMfqho6/DDleDUNu33
	 pS47jsCv4jkkZ3TfzX7YOIarrBQRrOAA0qQI7cljjjtAKJiE7Th43z0XKphRtbEyvv
	 wgkdL4a5XITe0iDGfY6zJa1B4aauWJ8e3iMC3orDlGxdoQPveUnZ0TFRyZSi6uouUt
	 Wa8ZNZdUKzzteyhtnbvSP/wpmugxlPEzFs0O/I7Ot1rTGb+Z1EzzDhGi3mHowfDsXr
	 0LDUwfeiuONLs9denOJ+GApcb9yyUP1ieaFn3F4tibBvbiTOjkVmrZc9qA/UU/IKMN
	 CV2F8U4iPVTww==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v5 3/6] net: dsa: stop at the user device in .fill_forward_path
Date: Wed, 29 Jul 2026 13:49:44 +0200
Message-ID: <20260729114947.403782-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260729114947.403782-1-pablo@netfilter.org>
References: <20260729114947.403782-1-pablo@netfilter.org>
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
v5: new in this series. This is a cleanup so flowtable path discovery
    does not need to break at the user DSA device, skipping remaining
    ones; sashiko reports a hypothetical dst leak otherwise.

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

