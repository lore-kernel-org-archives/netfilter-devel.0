Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E824F5616AC
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2026 17:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792086830; cv=none; b=p2m/4zfwNdbraSZR97Xv3Sru6n9ObUQHvxvjvZmmzrgBfzT5KtSj7r84MRwgEOxXn6q/sCuO3dlrx5swDuf0rjH0kClmEPkPfmnhK1hF2+p/jSpP7h9n6iJK7sl/b3Oevmr9fnanLaDpektYL+Wjyj6T24JRIwf8ZB3uvYoi5SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792086830; c=relaxed/simple;
	bh=n4xxrs85tW8YbaCwtfs3S3QYKjdkepv4puxFOEExVmw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=GHWeEV+qLJEChTYmHazb/xagKKO2+3Y1PrDLOxZmYDiGckrpUXnPuUyAXziZQj+6G2b5pFHqjDCMPOhQ2gELur7qTkSjcccAOwvIubRh6WR8mTogQB++MuuKlQ1lz7gAkvFWc7HCo7VS0l9W87HkRS6cN+wj79XGgM/JKJ235wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=qsA9RMX5; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="qsA9RMX5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792086820;
	bh=y07IqhPOOcC+A/Qk5b+hgRaGMt3GEJIIDVTMqjiXQ6I=;
	h=From:To:Subject:Date:From;
	b=qsA9RMX5OfLQka8qKwVvbtig98Ku2BoAWlPzoxzGow/pNojgIB2FX5fWOkOBnjirH
	 J4GcT7bYkQcEKUwQsiSklElcFj18nn1ujW22MMtDVyNi68LuTuPv9uNQOotMElPMEz
	 CTSY9C+nXoSkByIwRLMWgpQpjPvSX47v4XVLArzy5RjKhhcdLDOe7V8t/W73ENebLk
	 jbBcRofwK2Sj4ioPNp+QWbpF1Ir3+UeQzSYT/vO0Sd4+WjUbKRYyRn3tAly1kqdi+Z
	 SciZ6rqmoAEH3br6bsz5UpaGTWAF3wTShR5oTfuGh/lW/wd53fx0u2dQAN+l5z+HFL
	 fQCd+pA1quEzw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9A563600B8
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2026 19:53:40 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 1/2] netfilter: flowtable: consolidate unsupported hardware offload check
Date: Thu, 15 Oct 2026 19:53:36 +0200
Message-ID: <20261015175337.1632721-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move this check to the function that allocates and enqueues the hardware
offload work.

Fixes: 6c5dcab95f4c ("netfilter: flowtable: IPIP tunnel hardware offload is not yet support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
new in this series, this is required by patch 2/2

 net/netfilter/nf_flow_table_offload.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 4365859220e6..44e4c6a64431 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1079,12 +1079,24 @@ static void flow_offload_queue_work(struct flow_offload_work *offload)
 	}
 }
 
+static bool nf_flow_offload_unsupported(struct flow_offload *flow)
+{
+	if (flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.tun_num ||
+	    flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.tun_num)
+		return true;
+
+	return false;
+}
+
 static struct flow_offload_work *
 nf_flow_offload_work_alloc(struct nf_flowtable *flowtable,
 			   struct flow_offload *flow, unsigned int cmd)
 {
 	struct flow_offload_work *offload;
 
+	if (nf_flow_offload_unsupported(flow))
+		return NULL;
+
 	if (test_and_set_bit(NF_FLOW_PENDING, &flow->flags))
 		return NULL;
 
@@ -1102,15 +1114,6 @@ nf_flow_offload_work_alloc(struct nf_flowtable *flowtable,
 	return offload;
 }
 
-static bool nf_flow_offload_unsupported(struct flow_offload *flow)
-{
-	if (flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.tun_num ||
-	    flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.tun_num)
-		return true;
-
-	return false;
-}
-
 void nf_flow_offload_refresh(struct nf_flowtable *flowtable,
 			     struct flow_offload *flow)
 {
-- 
2.47.3

