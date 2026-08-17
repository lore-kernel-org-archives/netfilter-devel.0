Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8D6448D19
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Aug 2026 16:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786985266; cv=none; b=goObq3Pu3JsfYeT43ZXOkdn/HSnMyodIRrXeBaqBEa7/1x6jyKD7QBanijikzs04hvYPpHEzIP1JSO5W2pykaNdcQJVBeT1riddLQVSujbUPIYdoHqvLhJeNi43j8VgKUwO165Ky0CcA1nQBp+2Kh9aL4T0v38sgi1Xml0MFAAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786985266; c=relaxed/simple;
	bh=0p3WOnL6yw5tZfwzP2qcXDJvyiasKkqMukDZYDj/kXs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q46wwgxXU1xm5PRncbxCONPZ9D6xBfYiBeGZKX07Hy7LeMPDEPnpMeYrVyNqBooUogZIEWshFVGxT7vkn+YLmobpdpdbXsEsiG5ip+u1Lb9O0eoFDjhJsTzvxHbWlW6vfmtgMs9R3jqoFTpuZcMHfOsoioPcCe8T2bmnK3XphsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=pkeZvZQu; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="pkeZvZQu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786985263;
	bh=C0pojBgWaOuLGrlCJBCAzFqFk0YXLdy7nwlopEAvRBE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=pkeZvZQu264eD4x9Sj9NVAKBK0WzdEcvGaxMgVsTjamrfV9Mm2XYMUlQOqc4mZtWm
	 B7wyZEIbkxLq4woXDtASpIXojLn743JinGbEgWpBe7CIvTyxi6MA+lPbu+iTp5o57J
	 a1psXn5gv4jFk9jezDHGLpw3+fcSVVFrp86mpgrccHojOvcSqXzHHCckbqWrYTuoYw
	 kYUFUSi2v/fPJEYg2jy0APFzOU+N8aK+WoHRFFFj22uw2cqFfKAykycjdU4BWNi/lO
	 eNLyWs5HflTXYyiCYfs078fKCfm3YwMw75zTftBrAMBlECSfm2bzOPuRbbA6ZoQRdW
	 eF15XndtB4mZw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id EA5076007A
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Aug 2026 18:47:42 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v3 4/4] netfilter: flowtable: let GC handle partially set up flow
Date: Mon, 17 Aug 2026 18:47:35 +0200
Message-ID: <20260817164735.1207999-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260817164735.1207999-1-pablo@netfilter.org>
References: <20260817164735.1207999-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the reply tuple cannot be inserted into the rhashtable, let GC remove
the tuple in the original direction. Otherwise, the flowtable lockless
rcu iterator might be already walking over such flow entry and access
different recycled ct due to the typesafe rcu semantics.

The rhashtable_remove_fast() call in flow_offload_del() will just report
ENOENT for the reply tuple.

Let the GC clear the offload bit when setting up the

While at it, remove WARN_ON_ONCE() which is reachable in case of OOM
in tc act_ct.

Fixes: ac2a66665e23 ("netfilter: add generic flow table infrastructure")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: new in this series

 net/netfilter/nf_flow_table_core.c |  8 +++++---
 net/netfilter/nft_flow_offload.c   |  8 +-------
 net/sched/act_ct.c                 | 12 ++----------
 3 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 8c84f02c4dd3..27cbabc092d0 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -341,9 +341,11 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 				     &flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].node,
 				     nf_flow_offload_rhash_params);
 	if (err < 0) {
-		rhashtable_remove_fast(&flow_table->rhashtable,
-				       &flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].node,
-				       nf_flow_offload_rhash_params);
+		/* Let GC handle this flow in partial state, confirm it so it
+		 * is handled as an expired flow. The rhashtable_remove_fast()
+		 * call will just report ENOENT for the reply tuple.
+		 */
+		set_bit(NF_FLOW_CONFIRMED, &flow->flags);
 		return err;
 	}
 
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 32b4281038dd..54671006ce98 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -59,7 +59,6 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	struct flow_offload *flow;
 	enum ip_conntrack_dir dir;
 	struct nf_conn *ct;
-	int ret;
 
 	if (nft_flow_offload_skip(pkt->skb, nft_pf(pkt)))
 		goto out;
@@ -118,14 +117,9 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 		flow_offload_ct_tcp(ct);
 
 	__set_bit(NF_FLOW_HW_BIDIRECTIONAL, &flow->flags);
-	ret = flow_offload_add(flowtable, flow);
-	if (ret < 0)
-		goto err_flow_add;
-
+	flow_offload_add(flowtable, flow);
 	return;
 
-err_flow_add:
-	flow_offload_free(flow);
 err_flow_alloc:
 	dst_release(route.tuple[dir].dst);
 	dst_release(route.tuple[!dir].dst);
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index e250969c84ac..31df7f9bce86 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -427,16 +427,13 @@ static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
 {
 	struct nf_conn_act_ct_ext *act_ct_ext;
 	struct flow_offload *entry;
-	int err;
 
 	if (test_and_set_bit(IPS_OFFLOAD_BIT, &ct->status))
 		return;
 
 	entry = flow_offload_alloc(ct);
-	if (!entry) {
-		WARN_ON_ONCE(1);
+	if (!entry)
 		goto err_alloc;
-	}
 
 	if (tcp) {
 		ct->proto.tcp.seen[0].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
@@ -451,14 +448,9 @@ static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
 		tcf_ct_flow_tc_ifidx(entry, act_ct_ext, FLOW_OFFLOAD_DIR_REPLY);
 	}
 
-	err = flow_offload_add(&ct_ft->nf_ft, entry);
-	if (err)
-		goto err_add;
-
+	flow_offload_add(&ct_ft->nf_ft, entry);
 	return;
 
-err_add:
-	flow_offload_free(entry);
 err_alloc:
 	clear_bit(IPS_OFFLOAD_BIT, &ct->status);
 }
-- 
2.47.3

