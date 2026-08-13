Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781DA20DD51
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Aug 2026 00:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786580169; cv=none; b=fcAMvUTKzfc3b7uvUWdZ4Oo3u+lzc8ojK02xaBh3KX2eGc9J4iBI1noG8KWRHDIQHwA0qN3n6ChO97mUORsbsGwG6re4T1YvIFcXxwLWV5wntZsfa7l5TroDX5DTM/R+CwuGwE5PKNbcREZGjBaJ4DwE7EpTOqJkWr9/pvI2f+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786580169; c=relaxed/simple;
	bh=5OJtlDZ7TE8nBzvARvr2ifMhwe1vFQpzsuJrv0ocPLs=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=ni3FL2vjrcDJiFCemf6NXMbF4qgpgLp0Of7SFWxE2UUreAiYw9/4oaLiCfhohcBh8ldJSLyM/bK8X89ZVI75dQs3W2ztRl87o2TQszq0VXi8EIp7+v+nqe0nW1Agw3U7GhNgNAnalYAJSGvBTP2o4xyFIGj1yDPM3deavseVWIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QRW9Rkl0; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QRW9Rkl0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786580165;
	bh=UEZeeqPoEjXQtdcSC5sE5uytl/imYjEh1F6f4q2pAqA=;
	h=From:To:Subject:Date:From;
	b=QRW9Rkl0w6utQnEDrXxPhbGJccAMZBW03sBRg8C/RZXLQWukfK/82WkInoRm+2cce
	 oyCU30QE53X4VC15h6hf0nisgNmGo+nyAgBIoc6stE03UpVPbhNrN6pZYBDCy+eU26
	 qQELIlFkqwTxxDzYF45DSbsKfjUngak4ZsneRgUaPANlMlh/22Ca1IoVLlr2XRiZlX
	 DzwWF/PqD3/4skszDNHInIGN014NYL1x917u7DFkk8kF12pd0t8F4h3tXpPwPda0bj
	 Hl3P5w8cE2gdqO8TlQ/U3P2Jbt+qdEZ9tWAJT45GNV+KfmVLPkBTQUfy+jqH5VbPsm
	 GbFNcGv3emJCQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 318936007B
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Aug 2026 02:16:05 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,RESEND] netfilter: nf_tables: move hardware offload step after building the chain blob
Date: Thu, 13 Aug 2026 02:16:02 +0200
Message-ID: <20260813001602.1062381-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allocate the chain blob before the ruleset offload to reduce chances of
entering an inconsistent state where the offloaded ruleset in the nic
and the software ruleset differ.

Fixes: c9626a2cbdb2 ("netfilter: nf_tables: add hardware offload support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
just a report, this based lying on top of the set ops .commit, then sashiko
failed to apply.

 net/netfilter/nf_tables_api.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index af357f6c5070..f398792673db 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10931,10 +10931,6 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		return -EAGAIN;
 	}
 
-	err = nft_flow_rule_offload_commit(net);
-	if (err < 0)
-		return err;
-
 	/* 1.  Allocate space for next generation rules_gen_X[] */
 	list_for_each_entry_safe(trans, next, &nft_net->commit_list, list) {
 		struct nft_table *table = trans->table;
@@ -10959,6 +10955,16 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		}
 	}
 
+	/* must be last, so audit and chain blob set up does not leave hardware
+	 * in consistent state.
+	 */
+	err = nft_flow_rule_offload_commit(net);
+	if (err < 0) {
+		nf_tables_commit_chain_prepare_cancel(net);
+		nf_tables_commit_audit_free(&adl);
+		return err;
+	}
+
 	/* step 2.  Make rules_gen_X visible to packet path */
 	list_for_each_entry(table, &nft_net->tables, list) {
 		list_for_each_entry(chain, &table->chains, list)
-- 
2.47.3

