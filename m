Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B367356328A
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2026 17:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792085853; cv=none; b=t3V+h+LNnxzFLMO8UVFRBA/MSWTAddRRwB4Gzvk3xa7F94X2Jq2RTulMaY3KA/Y0BV6EkxmYNSj4d3iR4vBDS+O/kWxa9ebrj/s3Qs/VsNafm/0DjCDw8a7xvV9I3FlZpRQtnhdEa3ELxakfILewzrKp+Vu8X9gtfaiKCwpKuiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792085853; c=relaxed/simple;
	bh=lsDpc1RT9RskWQdYLtZ+MmZWaPY9spwp5ZzSQbQRa5Y=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=ZLe+c0Zap9tzgRIBoad+p3rG62CfXSEemP9syawCV5LD9fpBW1J/q7pQ993yIKUIPCeLFz7xAlyDfJq2TrWpEB5VXveO5Icx+2bFYcuFUKnYJ/G9M+eiStxcHA+Dzgs6/f+ddpLFS7vf24y6AEgQIXlwHkJxqr3YdDgsWUoxh5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=tm7LyWWt; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="tm7LyWWt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792085833;
	bh=r9xE488MWqpEhKbcbdQCK95U4jUwFGx1tvCEJ8hESPw=;
	h=From:To:Subject:Date:From;
	b=tm7LyWWtAD71mImQFGpX5sstuzJFRLJzE9BLNcc5Jt2FFBP2r01fsT5+4EPRZZQ+X
	 /mTJkL4vKAmvp1SSS1Miuk/MbVw+U7giQu+EF3PgwkScqxkyeE/fNdTp+uHoSILP3W
	 LAj90Ak7OwPf/62ap1JD2T3x3eURGULBQC3W4wY37v7zffwlrGTkTc4XDGQ9hQDiX8
	 mjsuhLoBSVJuxq8v2bnpUOuAPRZW5SKeLYaN4R7ClMjjH/Fc1AzlwlbQ7ShkBXfkLX
	 4Tg4t8XNks05oOSTRvCqywlHr46+wXcQF6qt8HfAqobITmaLcUuWo5t/MRP9UAPo1J
	 EFxwTo6L38t2Q==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 985E960081
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2026 19:37:13 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: flowtable: move hardware offload refresh to GC worker
Date: Thu, 15 Oct 2026 19:37:10 +0200
Message-ID: <20261015173710.1622383-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
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

Fixes: 8b3646d6e0c4 ("net/sched: act_ct: Support refreshing the flow table entries")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
This replaces:
[PATCH nf] netfilter: flowtable: set on NF_FLOW_HW once flow has been offloaded

 net/netfilter/nf_flow_table_core.c    | 11 ++---------
 net/netfilter/nf_flow_table_offload.c |  3 +++
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 36bbc7be2f74..ba18c8f0e1b1 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -372,15 +372,6 @@ void flow_offload_refresh(struct nf_flowtable *flow_table,
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
 
@@ -608,6 +599,8 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 		nf_flow_offload_del(flow_table, flow);
 	} else if (test_bit(NF_FLOW_HW, &flow->flags)) {
 		nf_flow_offload_stats(flow_table, flow);
+	} else if (nf_flowtable_hw_offload(flow_table)) {
+		nf_flow_offload_refresh(flow_table, flow);
 	}
 }
 
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 4365859220e6..aa6fa2196765 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1116,6 +1116,9 @@ void nf_flow_offload_refresh(struct nf_flowtable *flowtable,
 {
 	struct flow_offload_work *offload;
 
+	if (nf_flow_offload_unsupported(flow))
+		return;
+
 	offload = nf_flow_offload_work_alloc(flowtable, flow, FLOW_CLS_REPLACE);
 	if (!offload)
 		return;
-- 
2.47.3

