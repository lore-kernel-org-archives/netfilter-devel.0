Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D53285CBA
	for <netfilter-devel@vger.kernel.org>; Sun,  4 Oct 2026 22:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791152254; cv=none; b=DObPueMDkO2+4hZlAFynH+RFvbsgNXSf36Gugoo7hAJDfXPws/wzbWKwWvSuSCN63N5lc0t2mYuLfvTUVvxszd0LFQV2pS9xF8mbMZ/xLXmJ1cnkoUPczIMea8tizctuYxV/zPcX5IlKptGPG6dnh4N5LKGgXTOMSv3ZIIjGTxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791152254; c=relaxed/simple;
	bh=e8geVghGg4HIZkb8Al7IMph1UTCZNLNpVyb7eXX7hjg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=hPx2miiS4qD7NsAJP8YyLNZ7lmGUZUxqSWNje4XcXuHyBobex1vnicsvYuUiEvBv4iMufn4Pl3Ko+rKT7RbqceciFCYDjDshcjZaFTlo3+tXOl/AF3w6f/2mn+67W4PpNAKbZH0UH9pkRpn4vrEwXj+Zq79FI7OQeyJcNKt/Jsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=MPAJAjlR; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="MPAJAjlR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791152249;
	bh=mS8uzdj6gYbEIgozTSq9TgBHSwvpmbcHpNh5cCjXqR4=;
	h=From:To:Subject:Date:From;
	b=MPAJAjlRJnC0hu/BmymkcfTcwQgafTikg2CZFBwQr0X22eFwymv7hty3HkinWRZYr
	 Vuqp92q5A/XmZefbAFm1Os0aqfAE+/+g7MyJukxVfYAvj4ThoWNNxFUKdmpyS3Fxko
	 rPqk/HJzBFPE/fr9zWY3n2sJXPs8JpDt1HpGdzKWWccwtTzYWYaygYeAJrLzE4g694
	 5PdJhO55+TkIMP+UnjPciRXGloaCHDuF044Yt59DyhBupppsIzytlPsD2QBEtm0t6m
	 fIq9f1nAurt79ElY1FjqFfzRj04SP74+E0C6RkWX1DuzIHY0KABdY+PGtCpJbeovkt
	 wXQokVSHL3cAQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 21EFC60058
	for <netfilter-devel@vger.kernel.org>; Mon,  5 Oct 2026 00:17:29 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: flowtable: set on NF_FLOW_HW once flow has been offloaded
Date: Mon,  5 Oct 2026 00:17:25 +0200
Message-ID: <20261004221725.367327-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sashiko reports that refreshing hw offload from packet path is racy
since flow might be already going away. Since commit 7c549fb7eecd
("netfilter: flowtable: generalize pending status bit"), GC skips flow
entries that are still pending to be offloaded. Set on NF_FLOW_HW flag
once the flow entry has been offloaded.

Fixes: 8b3646d6e0c4 ("net/sched: act_ct: Support refreshing the flow table entries")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c    | 2 +-
 net/netfilter/nf_flow_table_offload.c | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 36bbc7be2f74..3603e72a662c 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -379,7 +379,7 @@ void flow_offload_refresh(struct nf_flowtable *flow_table,
 	    test_bit(NF_FLOW_CLOSING, &flow->flags))
 		return;
 
-	if (test_bit(NF_FLOW_HW, &flow->flags))
+	if (!test_bit(NF_FLOW_HW, &flow->flags))
 		nf_flow_offload_refresh(flow_table, flow);
 }
 EXPORT_SYMBOL_GPL(flow_offload_refresh);
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 4365859220e6..c40e17bd91a4 100644
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
@@ -1129,7 +1129,6 @@ void nf_flow_offload_add(struct nf_flowtable *flowtable,
 	if (nf_flow_offload_unsupported(flow))
 		return;
 
-	set_bit(NF_FLOW_HW, &flow->flags);
 	nf_flow_offload_refresh(flowtable, flow);
 }
 
-- 
2.47.3

