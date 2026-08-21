Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6443A4C77AA
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Aug 2026 14:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787323126; cv=none; b=QOsksowpta2pXsDIOGFAeIvjcR6UqvoTuOuQTs6094jgy0dmGv3uOBYXEKs8Sdorqq/elWXS2YlRRFIGr/grBHxA2n5h5V3w0AJoOaY9IrL1udN7afN3HAi+lHo8Cg6VgqdFlA7nLoCWEgLxlNGr907iAHUYjKEwcmBJT6KWrVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787323126; c=relaxed/simple;
	bh=eOS3R92hJGz0I4aGzmWyv42x9LGveoGL147bNHW3264=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QNMxhMwVkRQYvMbLH/YB/KG9iPE3HrjPO52PeY07Yv45tzVWJaPy9zaiTw8nb5oLYVl/ysdCEQkdtStDRLHbSED1DLPhTN5FQBgBkfEQLBEOvREXuyJZzJxyxoT6QHSK8vbUoyAiVSuqlT4koVQnzAdYGk4W/YVVrgBeatQSWEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XkM+8M4m; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XkM+8M4m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787323120;
	bh=50pB1EyFAzI6WAR9cmJym3zvggQtBlNleHkV3shbnnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XkM+8M4mahTQSXv3TU9PR37JdCO2bIyZvlGahjJpkmo8QJscEJHh3soaFVHD2pPoU
	 IWXR8qFgq9LHdXsPpYSJmtuR2NYyTnU0M6gERXM8mcIYPtNmkSbS6BA3XkiUAe2X5i
	 NKxDL4sXc1mw7aGqZaX2hro1qqW3Rs57N0tiVoaqzYEF8Dxz9WiLBcrX5m6CXeRPRJ
	 5ff7koAeDMydIXQriHGBYfhFunQlhFdWZamD/V8W4R4/DvQbY1JKjzloicGQ0zS6OX
	 CZTI3HmCoMqy0uLTNXP0r0xYCk2GmdU1NBsS01KcVkPxR1PZhf8IEQoiIANGXtdFI2
	 owGpTlpN1MJRg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7935960091;
	Fri, 21 Aug 2026 16:38:40 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf-next 07/10] netfilter: lwtunnel: use GFP_KERNEL_ACCOUNT
Date: Fri, 21 Aug 2026 16:38:24 +0200
Message-ID: <20260821143827.183963-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260821143827.183963-1-pablo@netfilter.org>
References: <20260821143827.183963-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

GFP_KERNEL_ACCOUNT is preferred these days for memcg, replace
GFP_KERNEL by GFP_KERNEL_ACCOUNT.

Allocate per-netns sysctl via GFP_KERNEL_ACCOUNT.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_standalone.c | 2 +-
 net/netfilter/nf_hooks_lwtunnel.c       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index f4f2d82192d5..d88a10230862 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -1009,7 +1009,7 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 	BUILD_BUG_ON(ARRAY_SIZE(nf_ct_sysctl_table) != NF_SYSCTL_CT_LAST_SYSCTL);
 
 	table = kmemdup(nf_ct_sysctl_table, sizeof(nf_ct_sysctl_table),
-			GFP_KERNEL);
+			GFP_KERNEL_ACCOUNT);
 	if (!table)
 		return -ENOMEM;
 
diff --git a/net/netfilter/nf_hooks_lwtunnel.c b/net/netfilter/nf_hooks_lwtunnel.c
index 4e1eef1ba0f1..40c6fce14a63 100644
--- a/net/netfilter/nf_hooks_lwtunnel.c
+++ b/net/netfilter/nf_hooks_lwtunnel.c
@@ -73,7 +73,7 @@ static int __net_init nf_lwtunnel_net_init(struct net *net)
 	if (!net_eq(net, &init_net)) {
 		table = kmemdup(nf_lwtunnel_sysctl_table,
 				sizeof(nf_lwtunnel_sysctl_table),
-				GFP_KERNEL);
+				GFP_KERNEL_ACCOUNT);
 		if (!table)
 			goto err_alloc;
 	}
-- 
2.47.3

