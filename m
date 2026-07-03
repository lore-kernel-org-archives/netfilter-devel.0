Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D02D3D3CE4;
	Fri,  3 Jul 2026 12:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783083449; cv=none; b=S/ZrP4iC4cT7PDaCr/2uj1wSg9UMm1WPRrqACpXgKo278R+PTy/HEndIsLE3SG390kPRUEPhzyRHNIdIKCgoinckkmF/ei+jwdqUpDWKTAOtxeZ0pZYaHhqcDFKpovcY3cBiB2x8S2OfM+FRhn4fZO6i2Ts5wXXyONhhd2Y9tVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783083449; c=relaxed/simple;
	bh=0ADNQjVgXFYRbrk7DTLyNIItjo2bOJG4p9io0hMTItU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tOZwlOsUphb/mOKQcqmMe8SG+dSkhCJ8N7SkwJPN2NzosCxEiMahZLjjJqltRdqIaExyCe+8OjeoF/3hIP5SEQAG3Lpoko6PUop6tbWyQyPJh9HidZURStmRbSpkDD4aETZlmKzJYAFSKM/TK7P2g3CVp8WL/tZ/Omd8s8Fj+qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 18C3B60687; Fri, 03 Jul 2026 14:57:27 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 3/9] netfilter: xt_rateest: fix u64 truncation in xt_rateest_mt()
Date: Fri,  3 Jul 2026 14:57:03 +0200
Message-ID: <20260703125709.16493-4-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260703125709.16493-1-fw@strlen.de>
References: <20260703125709.16493-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Feng Wu <wufengwufengwufeng@gmail.com>

On links faster than ~34 Gbps, where byte rate may exceed 2^32-1
(~ 4.3 GBps), the comparison result becomes incorrect because the
truncated value no longer reflects the actual estimator rate.

Fix by changing the local variables to u64.

Fixes: 1c0d32fde5bd ("net_sched: gen_estimator: complete rewrite of rate estimators")
Signed-off-by: Feng Wu <wufengwufengwufeng@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/xt_rateest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_rateest.c b/net/netfilter/xt_rateest.c
index b1d736c15fcb..7c05b6342578 100644
--- a/net/netfilter/xt_rateest.c
+++ b/net/netfilter/xt_rateest.c
@@ -16,7 +16,7 @@ xt_rateest_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_rateest_match_info *info = par->matchinfo;
 	struct gnet_stats_rate_est64 sample = {0};
-	u_int32_t bps1, bps2, pps1, pps2;
+	u64 bps1, bps2, pps1, pps2;
 	bool ret = true;
 
 	gen_estimator_read(&info->est1->rate_est, &sample);
-- 
2.54.0

