Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7503845AE
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Mar 2026 19:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772564555; cv=none; b=JpkACNIwwS5Iy5MYUNMtaVsxtzgFU8OLWASeoPIVukpyYetgnNBPW2PnEpQh1QA4IRzj/BBFyVB5h6kx3igYH2a4rGzhmPQgIImohrg7TDRTggBmisr6JBosstaHtov1e10irFFt7orvSi33Z0iU7D2JAr9CPFfe0zs9Y+nzb98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772564555; c=relaxed/simple;
	bh=mbT+axmjV0Dix4eewmadmAwDsytzxa+b69LGD1dze6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=prH7ycxcuJJNGh2MYp2A5eSI7iQyKBI+YrAeHmwPMPwPU+sILFBsjiH71kAB5jIkNYDgiVYnV1H28qJM0TU7lA+o5Sr70X3pZ7Q2N+sJJ7UV2ERVuQbt/kVsMK7sYrw3LqE/YMcHjfDaSXvE7iS7m9y24Y+UcERnvKUwepdXSOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3E70A60D28; Tue, 03 Mar 2026 20:02:32 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>,
	Yiming Qian <yimingqian591@gmail.com>
Subject: [PATCH nf 2/2] netfilter: nft_set_pipapo: prevent soft lockup during gc walk
Date: Tue,  3 Mar 2026 20:02:08 +0100
Message-ID: <20260303190218.19781-3-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260303190218.19781-1-fw@strlen.de>
References: <20260303190218.19781-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The gc scan+shrinking process can take a very long time.

Add an upper ceiling: If we've queued up some elements for removal
already give up after spending up to 10s on gc compaction.

Note this intentionally doesn't add a call to cond_resched();
PREEMPT_NONE and _VOLUNTARY preemption models have been removed
recently.

Reported-by: Yiming Qian <yimingqian591@gmail.com>
Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index d850166b8e45..0cd91f809655 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1686,6 +1686,7 @@ static void nft_pipapo_gc_deactivate(struct net *net, struct nft_set *set,
  */
 static void pipapo_gc_scan(struct nft_set *set, struct nft_pipapo_match *m)
 {
+	unsigned long stop_time = jiffies + 10 * HZ;
 	struct nft_pipapo *priv = nft_set_priv(set);
 	struct net *net = read_pnet(&set->net);
 	unsigned int rules_f0, first_rule = 0;
@@ -1697,6 +1698,9 @@ static void pipapo_gc_scan(struct nft_set *set, struct nft_pipapo_match *m)
 		const struct nft_pipapo_field *f;
 		unsigned int i, start, rules_fx;
 
+		if (priv->to_free && time_after(jiffies, stop_time))
+			return;
+
 		start = first_rule;
 		rules_fx = rules_f0;
 
-- 
2.52.0

