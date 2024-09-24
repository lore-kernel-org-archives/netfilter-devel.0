Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B6E80043
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Sep 2024 19:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727207153; cv=none; b=mnyIV8YQ6hz+df3LXjSWu/2iwvC1ke58DjxG+NPdu5SN2fjAh29aBlNEiXw0FMouVWpT0x8eV078HnnhL3tCUhvlaJXYr3sxxcLW51c2ZCc8ocZXOIbso8AA60eRIUByplxqLgC1VGShEw0OALO3CbItlE+jY9sweuaBPVo1xE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727207153; c=relaxed/simple;
	bh=EvPZaoN6IvIWxxcUjTLpbMa47UgKPKLjtLrl3Hhi3Kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bj+T9cJd/jpK0E8vyzsas12RQT0SybMrUbB3dK4KTkrfdC9mgLHNujucB+ckgdzomtX9tkOs24+symo8NckUHLqhzAEHDRzq/9qHedeKkhjDPON2rH1e+BYBFh93HR2e273tlHJCjmPnMShwQXhxO5V3KMUUhiSI5/PtGDo2n3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1stBTp-0004o4-LG; Tue, 24 Sep 2024 21:45:49 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: cmi@nvidia.com,
	nbd@nbd.name,
	sven.auhagen@voleatech.de,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 4/7] netfilter: flowtable: prefer plain nf_ct_refresh for setting initial timeout
Date: Tue, 24 Sep 2024 21:44:12 +0200
Message-ID: <20240924194419.29936-5-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
In-Reply-To: <20240924194419.29936-1-fw@strlen.de>
References: <20240924194419.29936-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This allows to remove the nf_ct_offload_timeout helper in followup
patches.

Its safe to use in the add case, but not on teardown.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_flow_table_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index bdde469bbbd1..4569917dbe0a 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -304,7 +304,7 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 		return err;
 	}
 
-	nf_ct_offload_timeout(flow->ct);
+	nf_ct_refresh(flow->ct, NF_CT_DAY);
 
 	if (nf_flowtable_hw_offload(flow_table)) {
 		__set_bit(NF_FLOW_HW, &flow->flags);
-- 
2.44.2

