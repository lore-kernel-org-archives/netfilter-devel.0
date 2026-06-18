Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D411532C316
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Jun 2026 06:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781763975; cv=none; b=QNYXieNqI1WUuRhcmpEJhOnBb4NKYjO6Q5K5JxuQ77iJkXw6E+H2ejLN90Wr7CxpV7EOwRjQeHQNUWrPEC/wq+dYIVi1zMLd9blcrOsLDFsAuSTSwSYKjOl3eol1ZdYGsk2c4ZHlmHkPdFivKyWvutJYbQpuUaKwM36Fd9QSAi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781763975; c=relaxed/simple;
	bh=oqoZQgSnpNni9jDGwGS3YkdEPt2ppDRNGfhiPV/pCrM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JRVv9+TCFo5OrB1E42uulCeZMEA0M1ZZBIro1I1I6+9tCkygFaQFEze0+SbHpyMbJETY1IrhRwt+BSUziqsq3sEVlekRXAen7xQcUTpNFEB6hDG2b21RlE71a2zvBCcv7j2cy+4+txNkjORpaDYlfS2Lv/WAswVBg82O85wUeNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D4D1E602B9; Thu, 18 Jun 2026 08:26:11 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH nf] netfilter: nft_flow_offload: zero device address for non-ether case
Date: Thu, 18 Jun 2026 08:25:47 +0200
Message-ID: <20260618062552.30006-1-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

LLM points out that the skip causes unitialised stack array to
propagate down into dev_fill_forward_path().  Its not clear to me that
there is a guarantee that a later ctx.dev->netdev_ops->ndo_fill_forward_path()
would always fix this up.

Cc: Felix Fietkau <nbd@nbd.name>
Fixes: 45ca3e61999e ("netfilter: nft_flow_offload: skip dst neigh lookup for ppp devices")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Please consider this a bug report, its possible this patch is junk.
 net/netfilter/nf_flow_table_path.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 9e88ea6a2eef..c0b07dde0434 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -53,8 +53,10 @@ static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
 	struct neighbour *n;
 	u8 nud_state;
 
-	if (!nft_is_valid_ether_device(dev))
+	if (!nft_is_valid_ether_device(dev)) {
+		eth_zero_addr(ha);
 		goto out;
+	}
 
 	n = dst_neigh_lookup(dst_cache, daddr);
 	if (!n)
-- 
2.53.0

