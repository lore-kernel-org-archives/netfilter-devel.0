Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADCFB3A5E64;
	Wed,  4 Mar 2026 11:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772625013; cv=none; b=E+f8aO8up7CQ5KHUsQIAR73bW51/+Q60aNl7JTTNfF3mvKeRKa1eUznDvjALO3ihYprnuvFESztAEhlJ4Jfu/zj0XJgIlpyTONuXZK15oCRs5s04vLUEmBGo9DI7aH+hNpNDSQVsQW26lcawwWz8dHx1gRcW3cghBecXDTTaVHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772625013; c=relaxed/simple;
	bh=iSN1ZRa3eqkeR94gc6FinW5lZh8m2CQij2HX705d5q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g3oFMmMVvylOlTDG9SEHeatNUWGJRXsxYwX+CPQtYs37sHbt2aG36OEcTEvrY9yeFeO2vR0WPgQmkuoM+b2psoV9s03qZpdArPws/bXkpt9qGgA2DZnJ/DFzefz6h3PEqYfr2fWrk60WCh8f0x/GVFJ/r0jk4p3O1cCTSGhSK8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 321BD60492; Wed, 04 Mar 2026 12:50:09 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 09/14] netfilter: nfnetlink_queue: remove locking in nfqnl_get_sk_secctx
Date: Wed,  4 Mar 2026 12:49:16 +0100
Message-ID: <20260304114921.31042-10-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260304114921.31042-1-fw@strlen.de>
References: <20260304114921.31042-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We don't need the cb lock here.
Also, if skb was NULL we'd have crashed already.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink_queue.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 27300d3663da..5379d8ff39c0 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -592,15 +592,8 @@ static int nfqnl_get_sk_secctx(struct sk_buff *skb, struct lsm_context *ctx)
 {
 	int seclen = 0;
 #if IS_ENABLED(CONFIG_NETWORK_SECMARK)
-
-	if (!skb || !sk_fullsock(skb->sk))
-		return 0;
-
-	read_lock_bh(&skb->sk->sk_callback_lock);
-
 	if (skb->secmark)
 		seclen = security_secid_to_secctx(skb->secmark, ctx);
-	read_unlock_bh(&skb->sk->sk_callback_lock);
 #endif
 	return seclen;
 }
-- 
2.52.0

