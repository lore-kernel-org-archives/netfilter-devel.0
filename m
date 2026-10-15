Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC372559C8E
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2026 17:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792086831; cv=none; b=AdSMNizFLgWpDUuRWTjkblJal09bhllmu10/xNJ0rPC8DukqYk0OQso0jaAdKSZrR48r9dzU63swNxu8a/rZ0XuM/LtJX3HR51eakRNICUXqPerwnd0jpxVJM2O5ddy2nZQvFpaY9ow8LKjScQkI6r4jE2h+0BtwMbbh//nJW8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792086831; c=relaxed/simple;
	bh=IXbp1Ar4N65XuLCTpSoieGE6js0jkXylKvF7LSfAI8o=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BHrKgNyVJI8D1RYkn/7KkjwfnyurNhW+AfdjYC5N8tnZJN5g5cbu0/ZBYNBicLEArq28QHkOL5y8ynnQEfHXTVK28KCayMAGj5Q7yttYkMOi2VbjdiEka/hzcI+4agMZeqk0S1zyqeiKinKfERWAA0Y1FbyLJqVThlTGEq2Z8mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=opKCq0AP; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="opKCq0AP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792086822;
	bh=l9Sn0QgRQyMl4IkCdztH11n6ZAEIAlSX30WjZqx783w=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=opKCq0APztXO+VpnSvk4Ct/Yty/oZxmWnAzETIYHfX0QHy3GAwiIebQKVwxjVm44O
	 VDAHmhkuomfF9saqvDlmw7hugI1tcJTGbNkWq9VmwNma3nfpLqM4OkQ2XISylWF0Ib
	 z7EP60ukf6jtXno6J0oTAvHYzIRJJO7M1kugW47nbronyAOwdWplTU69HwptluKL6W
	 9Qo9qvuBP5kmtgji+RyfKMRVKDhRylOqCathpGPcVYaNrMmEovhi+1vUxE+pEScmS3
	 Flsd0nVcI1VzFD16GHwn49X4Ld8Ic1LaXv1VNFdBsK91lEwl6Zy4E6EsOJY+dG48JK
	 TSxoImKoSoAXw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 270A860177
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2026 19:53:42 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 2/2] netfilter: flowtable: move hardware offload refresh to GC worker
Date: Thu, 15 Oct 2026 19:53:37 +0200
Message-ID: <20261015175337.1632721-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261015175337.1632721-1-pablo@netfilter.org>
References: <20261015175337.1632721-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sashiko reports that refreshing hw offload from packet path is racy
since the flow might be already going away. Refresh the flow instead via
GC worker to address this, ie. if hardware offload fails, next GC run
will give this flow a chance to offload it to hardware.

Since commit 7c549fb7eecd ("netfilter: flowtable: generalize pending
status bit"), GC skips flow entries that are still pending to be
offloaded, then it is possible to set NF_FLOW_HW flag once the flow
entry has been offloaded. If this fails, GC will give it another offload
try later.

Fixes: 8b3646d6e0c4 ("net/sched: act_ct: Support refreshing the flow table entries")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: re-target to nf-next, restore postponing NF_FLOW_HW bit

 net/netfilter/nf_flow_table_core.c    | 11 ++---------
 net/netfilter/nf_flow_table_offload.c |  6 +-----
 2 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 2f5df3bf3943..6ed542d1f57d 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -374,15 +374,6 @@ void flow_offload_refresh(struct nf_flowtable *flow_table,
 	timeout = nf_flowtable_time_stamp + flow_offload_get_timeout(flow);
 	if (force || timeout - READ_ONCE(flow->timeout) > HZ)
 		WRITE_ONCE(flow->timeout, timeout);
-	else
-		return;
-
-	if (likely(!nf_flowtable_hw_offload(flow_table)) ||
-	    test_bit(NF_FLOW_CLOSING, &flow->flags))
-		return;
-
-	if (test_bit(NF_FLOW_HW, &flow->flags))
-		nf_flow_offload_refresh(flow_table, flow);
 }
 EXPORT_SYMBOL_GPL(flow_offload_refresh);
 
@@ -656,6 +647,8 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 		nf_flow_offload_del(flow_table, flow);
 	} else if (test_bit(NF_FLOW_HW, &flow->flags)) {
 		nf_flow_offload_stats(flow_table, flow);
+	} else if (nf_flowtable_hw_offload(flow_table)) {
+		nf_flow_offload_refresh(flow_table, flow);
 	}
 }
 
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 44e4c6a64431..5955b520d0a2 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -984,7 +984,7 @@ static void flow_offload_work_add(struct flow_offload_work *offload)
 		goto out;
 
 	set_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
-
+	set_bit(NF_FLOW_HW, &offload->flow->flags);
 out:
 	nf_flow_offload_destroy(flow_rule);
 }
@@ -1129,10 +1129,6 @@ void nf_flow_offload_refresh(struct nf_flowtable *flowtable,
 void nf_flow_offload_add(struct nf_flowtable *flowtable,
 			 struct flow_offload *flow)
 {
-	if (nf_flow_offload_unsupported(flow))
-		return;
-
-	set_bit(NF_FLOW_HW, &flow->flags);
 	nf_flow_offload_refresh(flowtable, flow);
 }
 
-- 
2.47.3

