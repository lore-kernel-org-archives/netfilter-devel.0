Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917CE3B47CC
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Sep 2026 19:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788808278; cv=none; b=la4XnNc3ZBGG+iDlNGIrY9vdQDQYGdXn4TD+Xde/CYOrBgRt+NG5zlK2/yBrf5+4gvTJQ1JWclOL1VLxtjmAZ5tK3c7DpgPkYJrARbCyoIJ8gaFJbBnxTC7EpiSQBPJ2vqhxnuf1xwkdJzuJ0Zzc9nwnnS5Z5DBSQ9HeoiFN9GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788808278; c=relaxed/simple;
	bh=3IIYPdwmcth8l5tcNbFybsOMotg7dFDmnfMe+EEsGg0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ry0B/x2xKWVMwioq6OTIJEqvb+FGedw3CP2WUJFRKrUgDZTUsbliogeQpCICz70HAQjrfATHdbQenGd7atHTyb5hJkNCxVtpDb/TDcVCmFx6VHN2+UP/yXlX84eqwZXbmLj+S1V8wYeT78UKOuUCPvCR/yKIlxDSopZ7ghH5LL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=YP/VjSK+; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="YP/VjSK+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788808275;
	bh=3aHUdJCKJcMEyuP+fFCs/7MfU46x4lzn+N6U8/PHk2U=;
	h=From:To:Cc:Subject:Date:From;
	b=YP/VjSK+Q3i01l13EJdq8b65zdBy0W8SFxFYb3QIq4VoqCyO+ftT7xqJDJHOcdWB3
	 n2qFA240C23fMUaSLeM0e6DQj9NHmtQ+PVPgPMJ03EHX619WRXT4owSMj5oIhNTExv
	 EUqufjShv4zXJ4zsyPcyd8SxB2sL50/vKCpvMZZZkQfa5jgwySr5whtP9k7+S89YnH
	 kyHp1VB59UeSKwSD3bkuxaTHHWlFZ1pTSN4Ujb74nkbHadvgbH7uwEyHZiOcal9ayX
	 BJfqGgdfm8CVCen5MMZ55yq8I0lrtgPAr+tDRtqZQ6Xx/HN6VCFAzhXNQlCHLsmVCv
	 Btj0sJ0UO+uoA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 803AA607E5;
	Mon,  7 Sep 2026 21:11:15 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf] netfilter: flowtable: hold reference on ct until flow is released
Date: Mon,  7 Sep 2026 21:11:12 +0200
Message-ID: <20260907191112.1429780-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nf_ct_put() releases the ct->ext area inmediately, the rcu typesafe
semantics also allow to refer to the wrong conntrack from the flowtable
datapath. Hold reference on ct until flow is released after rcu grace
period.

Fixes: 0ff90b6c2034 ("netfilter: nf_flow_offload: fix use-after-free and a resource leak")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 03241d4bfd5e..141502081784 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -258,6 +258,14 @@ static void flow_offload_route_release(struct flow_offload *flow)
 	nft_flow_dst_release(flow, FLOW_OFFLOAD_DIR_REPLY);
 }
 
+static void flow_offload_free_rcu(struct rcu_head *rcu_head)
+{
+	struct flow_offload *flow = container_of(rcu_head, struct flow_offload, rcu_head);
+
+	nf_ct_put(flow->ct);
+	kfree(flow);
+}
+
 void flow_offload_free(struct flow_offload *flow)
 {
 	switch (flow->type) {
@@ -267,8 +275,7 @@ void flow_offload_free(struct flow_offload *flow)
 	default:
 		break;
 	}
-	nf_ct_put(flow->ct);
-	kfree_rcu(flow, rcu_head);
+	call_rcu(&flow->rcu_head, flow_offload_free_rcu);
 }
 EXPORT_SYMBOL_GPL(flow_offload_free);
 
-- 
2.47.3

