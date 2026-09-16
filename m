Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D7A511180;
	Wed, 16 Sep 2026 23:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600631; cv=none; b=sFh31Zrq6nvYMBc37WVO6gGCeDx5sEOrJL2+88XEhtpcOAvl+fah80jHEBfsTSsyAoOiJQTx3BIzZT0NfuroJq8aEqOCFkSSm0y+l7KevpvoBi/9uY3pOxgdzpAVXpmrTloLjFZ5V3MvTgLrBWg+vnYP1qS5wdBx4rxBRAc8LBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600631; c=relaxed/simple;
	bh=2woUwebNozG9SC/ZhcyZWpi0EhdbBv0LkaCr2U7PIpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bBD2NHDQ3iZL7myG1xKbGYdGsgAwy42dR5ulCtN27HjCvUJP4KDdzK4SyDaYYegIRTO9lCWM7IFoNfBkwIRWzPLwOzqxsn3py6fSAIWE15OxASriXkujtlUFm2+sIwQuO075T/dbYTG0r3qXv5AYnvhzf3iE5DT4yLaDtJ6yYMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=q/qA1fjN; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="q/qA1fjN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789600628;
	bh=LfLDKDbros6AeCuQZJqhSAeSTHK42cKZ1cwPHtxZpqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q/qA1fjNjigNj8TQbJBtwD3+qPnMmrsArAZ+ewyXBSQaXvtaXQPB3HGCYYDqgQ94x
	 rhIuc/unkWOWMEhZ7HcqjZZtPDrcrdW+Vx52PpqRXT1zRAxS659vd0O5+zBtRXUo9G
	 PxfTKAmgOrbHQDKN6xHMse1zVZT58vj30X46uWqX6iE4u7pTAj2BlK3R6Q7J/rVbBv
	 GHADQ5FPFL3l76gS8WS7XRnTm4ekXjmvJbghAm9Cpjqeu66xYsacmcvLMuQp0wWFsh
	 sLPM+Fp/X6kMEdis8xT0L1kQtt6nKtBNvOOECt+r2eKYyBbCwANwpr21TGANaw2fMS
	 Dc0oXVDfapADA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 13A416008E;
	Thu, 17 Sep 2026 01:17:08 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 09/10] net: remove WARN_ON_ONCE() from the dev_fill_forward_path() loop check
Date: Thu, 17 Sep 2026 01:16:50 +0200
Message-ID: <20260916231652.127456-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260916231652.127456-1-pablo@netfilter.org>
References: <20260916231652.127456-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Farhad Alemi <farhad.alemi@berkeley.edu>

ipip_fill_forward_path() and ip6_tnl_fill_forward_path() look up the
route to the tunnel's remote endpoint and set ctx->dev to its device,
which is the tunnel itself when that route resolves back to the tunnel.
dev_fill_forward_path() then makes no progress and trips
WARN_ON_ONCE(last_dev == ctx->dev) as soon as a flowtable tries to
offload a flow through the tunnel. That routing loop is a configuration
any CAP_NET_ADMIN user can set up, and ip_tunnel_xmit() and
ip6_tnl_xmit() already treat it as a tx error, so remove the warning and
just fail the walk, as commit 008e7a7c293b ("net: remove WARN_ON_ONCE
when accessing forward path array") did for the path stack overflow.

Fixes: ab427db17885 ("netfilter: flowtable: Add IPIP rx sw acceleration")
Fixes: d98103575dcd ("netfilter: flowtable: Add IP6IP6 rx sw acceleration")
Closes: https://lore.kernel.org/all/CA+0ovCgaRvbd0Udj70b2xxG8Cx3CaCpNhnf1V4RWQuDveZYZhA@mail.gmail.com/
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Assisted-by: Claude:claude-opus-5 syzkaller
Signed-off-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index ecfbd72d5d1a..c67900354fa6 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -789,7 +789,7 @@ int dev_fill_forward_path(struct net_device_path_ctx *ctx,
 			goto err_out;
 
 		stack->num_paths++;
-		if (WARN_ON_ONCE(last_dev == ctx->dev))
+		if (last_dev == ctx->dev)
 			goto err_out;
 	}
 
-- 
2.47.3

