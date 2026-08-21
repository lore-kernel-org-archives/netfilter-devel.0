Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D9643B6C4
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Aug 2026 11:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787311156; cv=none; b=V7wCIXw36lqR51hzlP9jPLV8zsowFWKpkRHwMC29dK5GZZS8jd7JO8qVa3zOCVDooy/3Z/+POXPWf4wVRGq/HOLX7Ax484SDynR4po8sGe3zz9Q5g7k9l1LLrzb6eLI1EHRuqU9hwnWpXvS3xJzDtx+AjwAcH89sSEgPK1lhJL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787311156; c=relaxed/simple;
	bh=owO4D/j2DsPAWEv7U6WBr5mSSYh0RdNX5E8QRq7m0Bg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=a/03xpbotY0q8v136lj2D1/SZnfC92eJO1uhK0HX0jj2nCvXNlXEgeIYFOpeTwmYcVN5o812TYssaZncD1QTie+n+vMy7dVqENAZGSe7Kp3t6xjfiuRKWEPVHbaAPyvUGV+9FHIcEKenoYcHC8IopftHCkGtO3XC+kEaDpenPmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=bLDTiZMv; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="bLDTiZMv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787311153;
	bh=OcV/QdKCG+BUkyROI3aCRjYIDbHi1Zfn9UWWLxJrqLQ=;
	h=From:To:Subject:Date:From;
	b=bLDTiZMvW5wMuN6WCfaMLgONWWKUUj9tWrkvlShxCAeR5R5QuNCMzmpmtvHeJMNnO
	 SqAmBMhmH9F2O/sFLex32FH/SsjPuE90a/et+iuhD3XeQPzw9ODCx2ibs6CDXJlSH1
	 y7skO9YxcLsEdxT5QviuYdiV9GnxGL5PtFWW53ddBWoEnKpVSR2KRkY4U0n25sJlLY
	 Lqoy/k4kLegGbgXZzQ3p6fKTtGxXm9oUC2X1unUAGA/aozdg7Xw32T38m0Y4pT0sbe
	 pWulB6wZ51SJtIcpZK939RxG+fp+hdf5vmI8DoJvLgwOR2bFW8hTSl0En4btjD2NA0
	 hNAsNxYEAdC8A==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4DF3160076
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Aug 2026 13:19:13 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf 1/2] netfilter: nf_tables: remove leftover set_update_list
Date: Fri, 21 Aug 2026 13:19:07 +0200
Message-ID: <20260821111908.20422-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This list has been moved to per-netns, remove onstack list which is not
used anymore.

Fixes: b343ededb3f9 netfilter: nf_tables: move set_update_list to nftables per-netns
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 20c562174b27..f89605e68ba1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -11291,7 +11291,6 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct nft_trans *trans, *next;
-	LIST_HEAD(set_update_list);
 	struct nft_trans_elem *te;
 	struct nft_ctx ctx = {
 		.net = net,
-- 
2.47.3

