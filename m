Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B561340FD84;
	Mon,  9 Mar 2026 21:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773090540; cv=none; b=a8+3jDAAf4DrPp8AY0dvx25bhvm4q5sDOXTePvM6rKmUnV5YlFeyYHQ/CqCBw38mB/9tVa1bnN1embIDeVdUuEKR+7Ilaw0aWagYmoCqtgg3c01IZPnBIMPC0GuEXhxpgNPRi8M7brMQNLGJqgy3DtKKu6otVai3y2K+drR8hQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773090540; c=relaxed/simple;
	bh=YNWVfFLnqV+YQDTvfmDQZiSpb/Ras8f4F8fh+DJEhSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TlSfo51lwODbEOudh3rwrUoyGrxRChgq4wvCaqEEURK9M6W4r2Owm1G+oXpfz4WN+GYCQD8OUUYZzaQvcaYn3kTzItWvoTCltKxzTzTv4/xL2f29eyvzsVtA60PaWojKlJh9pb1HAgaSFltT/CM/ukdGZ68JFmHzPDXmJ6bJGIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 014EC6047A; Mon, 09 Mar 2026 22:08:57 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 02/10] netfilter: nf_tables: always walk all pending catchall elements
Date: Mon,  9 Mar 2026 22:08:37 +0100
Message-ID: <20260309210845.15657-3-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260309210845.15657-1-fw@strlen.de>
References: <20260309210845.15657-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During transaction processing we might have more than one catchall element:
1 live catchall element and 1 pending element that is coming as part of the
new batch.

If the map holding the catchall elements is also going away, its
required to toggle all catchall elements and not just the first viable
candidate.

Otherwise, we get:
 WARNING: ./include/net/netfilter/nf_tables.h:1281 at nft_data_release+0xb7/0xe0 [nf_tables], CPU#2: nft/1404
 RIP: 0010:nft_data_release+0xb7/0xe0 [nf_tables]
 [..]
 __nft_set_elem_destroy+0x106/0x380 [nf_tables]
 nf_tables_abort_release+0x348/0x8d0 [nf_tables]
 nf_tables_abort+0xcf2/0x3ac0 [nf_tables]
 nfnetlink_rcv_batch+0x9c9/0x20e0 [..]

Fixes: 628bd3e49cba ("netfilter: nf_tables: drop map element references from preparation phase")
Reported-by: Yiming Qian <yimingqian591@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 710f0ee21a34..dacec5f8a11c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -829,7 +829,6 @@ static void nft_map_catchall_deactivate(const struct nft_ctx *ctx,
 
 		nft_set_elem_change_active(ctx->net, set, ext);
 		nft_setelem_data_deactivate(ctx->net, set, catchall->elem);
-		break;
 	}
 }
 
@@ -5873,7 +5872,6 @@ static void nft_map_catchall_activate(const struct nft_ctx *ctx,
 
 		nft_clear(ctx->net, ext);
 		nft_setelem_data_activate(ctx->net, set, catchall->elem);
-		break;
 	}
 }
 
-- 
2.52.0

