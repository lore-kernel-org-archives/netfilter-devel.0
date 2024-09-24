Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E084A3E
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Sep 2024 19:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727207162; cv=none; b=OluQvtOxMosDBsmw/jim9+Bjb8nSqWYUmen6scZugXOs5iIpXFUKS0Fy7B5EdT/EXlXoc2cAEFYonrruXc7+Ajr7BLM7zotklOmNa1PfTx7bf5Bwy2bTJJyCsMlr7qBHH3NzLMdd2/49aO3RY2D5JBJTQ/ECLojbiPBmH2+LwJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727207162; c=relaxed/simple;
	bh=e/E4UBASAtTkXzmnUVWnvMDpZ2EHTH+eSFLlPALlbTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vF72DWCPA2Y1F+hHEGudCht4ziwo3Az0FHmoBvMohjGUrK+LnqlTTTLOetz8bWt+DIivpV3tV2gE6m8S74oIbCMkCQSfCgeOOLvcgDe9NssWuRCaN9J8Dvll/hS2wTtMv2ad27WvrewIjacFN+/XH7DqUP0+9RZ5X4xOZjrld4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1stBTy-0004pK-S7; Tue, 24 Sep 2024 21:45:58 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: cmi@nvidia.com,
	nbd@nbd.name,
	sven.auhagen@voleatech.de,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 7/7] netfilter: nft_flow_offload: do not remove flowtable entry for fin packets
Date: Tue, 24 Sep 2024 21:44:15 +0200
Message-ID: <20240924194419.29936-8-fw@strlen.de>
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

Treat fin packets like tcp packets with IP options or packets that would
need fragmentation: pass them to slow path, but keep the flowtable entry
around.

This allows to keep connections where one peer closes early but keeps
receiving data for a long time in forwarding fast path.

Conntrack should be moving the nf_conn entry towards a much lower
timeout, (default fin_wait 2 minutes).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_flow_table_ip.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 98edcaa37b38..94d83003acf0 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -28,11 +28,14 @@ static int nf_flow_state_check(struct flow_offload *flow, int proto,
 		return 0;
 
 	tcph = (void *)(skb_network_header(skb) + thoff);
-	if (unlikely(tcph->fin || tcph->rst)) {
+	if (unlikely(tcph->rst)) {
 		flow_offload_teardown(flow);
 		return -1;
 	}
 
+	if (unlikely(tcph->fin))
+		return -1;
+
 	return 0;
 }
 
-- 
2.44.2

