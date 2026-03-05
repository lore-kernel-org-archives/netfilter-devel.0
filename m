Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FAD1917CD
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Mar 2026 21:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772745468; cv=none; b=r+0clit+mofY3TYBp+WeZqK2EUcZ9ggWkyjRQ0JLAKjb6Lbdp29wmRRD5yc+FLalqg2tFtn8GyndD5j0KhP1STwZnVTeLN0K/6r/0wl8y/eEqeHIFKPkUWngjBHlN5c4U8DGUdIP6T7GPyoZOOkVJ86BykYiv1WkiwTgXKxndis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772745468; c=relaxed/simple;
	bh=XoXV+w+RuR4abIzLpMKKoxxm/O0Aqic60BxWPO1P6Wc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RJWSWt0euTyvvxa87q8n4ssxV05ssEA1tKONIF9XeEa/DWrlQJKD9r8rG+9cnAYrM4NnC2XQrAQ4J4xSkLak7oQCUMUdK/hfaJq/Z+O97OBoLzikUzuqG2YBV94CbqX4cKr4rS0lD6dfU4xyf5tAu1/kMbrLBWpUpGvFNq4+F3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7660A60735; Thu, 05 Mar 2026 22:17:44 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Yiming Qian <yimingqian591@gmail.com>
Subject: [PATCH nf] netfilter: nf_tables: always walk all pending catchall elements
Date: Thu,  5 Mar 2026 22:17:21 +0100
Message-ID: <20260305211726.25841-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
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
index c2b8c6f2c442..6fbbef1db99f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -829,7 +829,6 @@ static void nft_map_catchall_deactivate(const struct nft_ctx *ctx,
 
 		nft_set_elem_change_active(ctx->net, set, ext);
 		nft_setelem_data_deactivate(ctx->net, set, catchall->elem);
-		break;
 	}
 }
 
@@ -5872,7 +5871,6 @@ static void nft_map_catchall_activate(const struct nft_ctx *ctx,
 
 		nft_clear(ctx->net, ext);
 		nft_setelem_data_activate(ctx->net, set, catchall->elem);
-		break;
 	}
 }
 
-- 
2.52.0

