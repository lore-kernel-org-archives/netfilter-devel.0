Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC46A3F8DFD;
	Wed,  1 Apr 2026 10:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775039828; cv=none; b=l5ROR0De9XK4u9IHa0hSdjaxb/v04HqWaPGRmy6OK0rHftXx+90vBX/APmMCaBvVmPuSWlvg2ZfkqzJeWiegr1Uy3SYp2OT6Zgli7HUquuA0MHzMija0IHl317bhddTonbb+Pea+bzu8quYzIc2ml8F9pJgPg4zZBB++UrkyL8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775039828; c=relaxed/simple;
	bh=nOrYf/IMx6gxtyNB26R22xBOp5onhSiSZFVuQ29Nk68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bbaMVSUppdbc0y7QKf1cqTwZ2SvsglUU/0eJ3Lxzl0F2LkxbqmcUoy1XWF8y1NFG22zX84ekmt1VwXSx+bpXSwn9gsKJa/Vblr/tMex4/Yq1sQSW3Zdo2PM2oE3kXyWkJcjJ9F2wgWTQZ1UWxkFAqw1AiCGUZp6ZHSdNTwuhiSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=SwHPz7XY; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="SwHPz7XY"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9B74C60273;
	Wed,  1 Apr 2026 12:37:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1775039825;
	bh=+IqVeh6fcqQR1yjRdh4IDMPM19qNlFOEOVlD6u4VHlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SwHPz7XYeISSIn6nrk7vy5p99BE2IgKvg6lYqLpBvnEctCkcZeRj6zkVwHlBroEEQ
	 q5bAdzAwLvCByiZ8kgmIv1rLBKcSOGz3hi7bwCWcazAM44u5X603OycElhfXwolHKp
	 Dz4wejQDMusrh0CNxqnJrRm5nyrN4pkcDuQX6VPiYNy+iRr4kXn9UxncFohCU7Rzo5
	 jddqbroKBlPbvWRaJLeYIOaiMiJJeuhMVWV1dF28bjUtmUy1/u1pfuNwdsRxc2aiGb
	 FRMT28AiSZwjkK6oIpClj7fwtgUo1KPJDnYYKAvzhO7w2NBkRKWf1jNM40F58mi2vb
	 ZcjEQIhFw9IKw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 10/10] netfilter: nf_tables: reject immediate NF_QUEUE verdict
Date: Wed,  1 Apr 2026 12:36:46 +0200
Message-ID: <20260401103646.1015423-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260401103646.1015423-1-pablo@netfilter.org>
References: <20260401103646.1015423-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nft_queue is always used from userspace nftables to deliver the NF_QUEUE
verdict. Immediately emitting an NF_QUEUE verdict is never used by the
userspace nft tools, so reject immediate NF_QUEUE verdicts.

The arp family does not provide queue support, but such an immediate
verdict is still reachable. Globally reject NF_QUEUE immediate verdicts
to address this issue.

Fixes: f342de4e2f33 ("netfilter: nf_tables: reject QUEUE/DROP verdict parameters")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3922cff1bb3d..8c42247a176c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -11667,8 +11667,6 @@ static int nft_verdict_init(const struct nft_ctx *ctx, struct nft_data *data,
 	switch (data->verdict.code) {
 	case NF_ACCEPT:
 	case NF_DROP:
-	case NF_QUEUE:
-		break;
 	case NFT_CONTINUE:
 	case NFT_BREAK:
 	case NFT_RETURN:
@@ -11703,6 +11701,11 @@ static int nft_verdict_init(const struct nft_ctx *ctx, struct nft_data *data,
 
 		data->verdict.chain = chain;
 		break;
+	case NF_QUEUE:
+		/* The nft_queue expression is used for this purpose, an
+		 * immediate NF_QUEUE verdict should not ever be seen here.
+		 */
+		fallthrough;
 	default:
 		return -EINVAL;
 	}
-- 
2.47.3

