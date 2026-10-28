Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.227.136
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793168574;
	b=0cYpCtBk9CSLDWFtgxdhIe3Y4KuJ0KNYde+m3sEDcu6OR44obvjatix7MFHuz4ay0J7i
	 SpB2bJFds/suJj3IqPorp7NQ9VGb/1fLcgnMQdSXc/yAcWTr4I57D1/mWbp1wzKm2SjKh
	 ZNrhPItvibrAA16TyzYQh/dfEEOJxRk+zM3b2dFaHM8YvQHa9QEwNS5uRqIAjSel/Sdmv
	 Y/3PWyHIbhTEPcAi1lDNp2xDuxB4bjr7T5y1FODTXpLYWvtISfs73S1d0uO/P/xDBfjgT
	 GOyCQ2l4U/BECpdIz0Ra2K8d46OfURiMtvqjFAsC92pAk8WnCPL8slNBiO7fL9EZC2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793168574;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:X-Mailer;
	bh=SulABahkU3rLao+I7j5g0Ph09Yg6H2vGeWdscwhFpIs=;
	b=S/CaGT9MfqbYAbuKuBV+5mhABf0EprRnn3zsu85Z+bGZETnmUa6ullLH2ifRJFLzbBWP
	 aXs4kXBhOxj8ptrw9uJXM7Qgj+iI8c7UIQPyxSXHueIZ4kCt9cfZ+XoNxVcK9yEv8Qs02
	 L2aUjEmQQSMbCt9Z3wziGnWaEXErbkEYghiczbRFslEGfxvVmwiz6Sr/QX7MuqKkMFL+V
	 4aOmkSi6bWyZI18X+w4PsF+xIOjNIMZmHjZj0kEviVAG6x+mhNslYriq4RA5EUqK5RcC0
	 C8bIuJksJaPa1/k2+iKWjKz4pLO3rLs6qEom6gDQIeT8n9a2lOtpm20ME6EcPZuYLdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Bk++MV6k;
	arc=none smtp.remote-ip=74.125.227.136
Received: from mail-pj2-f8.google.com (mail-pj2-f8.google.com [74.125.227.136])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6324606A31A
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Oct 2026 06:22:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A6324606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Bk++MV6k
Received: by mail-pj2-f8.google.com with SMTP id d9443c01a7336-2e609985789so1589425ad.1
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Oct 2026 23:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793168573; x=1793773373; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SulABahkU3rLao+I7j5g0Ph09Yg6H2vGeWdscwhFpIs=;
        b=Bk++MV6kwfBaTPsFQ9sPW6xVdQXu8QHBLNBmXn+4O5/4UZqCRMXj2JVrOkA0O73ASK
         UjmfdxIzc591iBllQHPYUS8Ru4hTCYR2k7f5FbUeYKYAjjWddLDzfKFvfFG/tE/iWG7G
         kdIkEkNgFScyzvf90nJziUXX66iSajGdCM9mpd1XJS5P5JjZVERSO9upDyUKUGCpPLP2
         l+BaJE36fU2n6FPqKPUz+fXH1HGgGhfJnC4i6Crg0DJFPEcI9WG6MYtV7KFaBPtMBx4t
         kcnIOMBDqZr88IhosTjC1ODmw/JZP7bnUSLnYqZJEQovxNIYaDtF8V7sVJ5vOpLE1xCB
         MJIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793168573; x=1793773373;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SulABahkU3rLao+I7j5g0Ph09Yg6H2vGeWdscwhFpIs=;
        b=yTDqoPbU5zdZ8SkkhHPaD1ozsHWQxbVb0Q/PhXiXwNrHLHW/rtpAqnjpnqu8ZIriNj
         bt7BYG7CN7GwKnKykG1OjMQTj9sRP5V3E2/diSd0vRgm4jWP8yVig4MR9vEGTbLciGzu
         Rzvh0BliOmnQaBrS+y3WURVEdygBRlEo6ZjzDcZ3qWbpIxwb3Owy3KdRFvYKWXtfjhbk
         eUSZGUYO/2GXGl+6ODy0iVxdj30/YKXSlI38PJh9tZ3W0ATD6SBTd8W5vb0yfcT9dDFm
         3kirHGSXWz8jTaQrc/USDgYj5Y7xR7LbT8HnDL+hZkT3krw1dJMweLc1T9G2zLp1F2K0
         63mw==
X-Forwarded-Encrypted: i=1; AKwUvBwE9B1LHfTGwr0d+53IP3gHdpLxgiNu8HoAreJuH/U6kTfe/o+KoR8o2EGHLaoDjvZ8x4CKz96pB3lh4mBMGu4=@vger.kernel.org
X-Gm-Message-State: AFq9FYIyieVZbYBM5gYQ288BkiXiplX+8CVVP3KPEDg/2TrARbzG7rWC
	4o0wQUjzhCxsV/BOCnF/CgAfoKkzxH5tKVF5Sjjg8HtRavHtMwCPF7xc
X-Gm-Gg: AYBFou0hTmrhNGk8PkH4GFIxZipSxJ2ZcH7QUbofdaElu/JbvgTZX73D9t6Rl8iyF12
	Yg2StoumJcMqynGGge197XG9ZK43D/XoFc8bmdGaKxpK9m0w4UI6ZNsG0ohf6h+/T5akRfLJ9fE
	xmZllR4FHSt47LJkpehiSwXzye1jmbgYmv6QS059YlqjN6OFGrdEppA4a3H1bYyWU5K5TUgFiCn
	cquIz7PweEc0KI2sV+YUNICtpN0Wn2ibodqZl/YDZvjPMVAsE9kRTWMojRNJ252kAqw0ds6+a/X
	AEj6WjM+PXleauN2DgSv0XCKWUjLkM4ov//g3eCBO1EcyU7DPmYXiaS2bkG5srooyLjDKtzt1MP
	AwLfbmo8ji3o23j2Mq1qOGH3Gvgw67Zd+P3twB9OdEdiBOyn7Qy9RJw4j/yK1EuuSl/ywYAugap
	QE1WlI5u4xzX05oG6BSV2xqWpQn5zZpI1r0ocTj2xpOJL5PhmldoO8itum7wi0pK+bOQCD0RBCI
	oR4zWfQgpykkNZM8b2Z7InKmCC8RlBZomqEqGsGE327c3Gj4f/rAPFKimdNGBbmkaRz8knhntbp
	eser/k1vPIq9k2EN1hNg
X-Received: by 2002:a17:90b:55ce:b0:3ac:9d83:8861 with SMTP id 98e67ed59e1d1-3ae5832af4dmr1018817a91.67.1793168573088;
        Tue, 27 Oct 2026 23:22:53 -0700 (PDT)
Received: from hhost ([120.231.212.153])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae5a27f7c7sm1558410a91.2.2026.10.27.23.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 23:22:52 -0700 (PDT)
Date: Wed, 28 Oct 2026 14:22:42 +0800
From: Xingyuan Mo <hdthky0@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	"open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
	"open list:NETFILTER" <coreteam@netfilter.org>,
	"open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Cc: Xingyuan Mo <hdthky0@gmail.com>
Subject: [PATCH nf] netfilter: nf_tables: fix flow rule leak in nft_delrule()
 error path
Message-ID: <20261028062204.1079089-1-hdthky0@gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.43.0

On the nf_tables_delrule_deactivate() failure path, nft_trans_destroy()
frees the transaction but not the attached HW offload flow rule. Destroy
the flow after the transaction to avoid memory leak.

Fixes: 63b48c73ff56 ("netfilter: nf_tables_offload: undo updates if transaction fails")
Assisted-by: opencode:deepseek-v4
Signed-off-by: Xingyuan Mo <hdthky0@gmail.com>
---
 net/netfilter/nf_tables_api.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 59ac623e6805..ec56ea8c8436 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -752,7 +752,7 @@ static struct nft_trans *nft_trans_rule_add(struct nft_ctx *ctx, int msg_type,
 
 static int nft_delrule(struct nft_ctx *ctx, struct nft_rule *rule)
 {
-	struct nft_flow_rule *flow;
+	struct nft_flow_rule *flow = NULL;
 	struct nft_trans *trans;
 	int err;
 
@@ -773,6 +773,8 @@ static int nft_delrule(struct nft_ctx *ctx, struct nft_rule *rule)
 	err = nf_tables_delrule_deactivate(ctx, rule);
 	if (err < 0) {
 		nft_trans_destroy(trans);
+		if (flow)
+			nft_flow_rule_destroy(flow);
 		return err;
 	}
 	nft_rule_expr_deactivate(ctx, rule, NFT_TRANS_PREPARE);
-- 
2.43.0

