Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4CA46D2D8
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2026 11:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788435277; cv=none; b=MkAy+Y+de3kg9pN9PEJKsLAMO9d6HvCYFBrBDAwrNECr8meTlK0iwntx3a87tdg0c7W797JtQMx2h99IwQMzrSscn+6jIQUnXJoxu7N+EjmaPhX3niHJxKr4TxEJuthn4WX96s+2MDfshoL6JrWIrCI8c7KXu3xnmCQ+8zPNgNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788435277; c=relaxed/simple;
	bh=/FMW1Idn2bF5lExPvxaOgHNSB4FQzfEO9Zew7aAYlWs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IhMxcMD/QPmw73RDLk+dhMyi/NrEQaaRUOhAdxLbuVNiCn+rg31/tbjzJ1pVdDIeBVHhFypkRA02epHj/icl36cknSWLb5uQ6AghXf16JHWlweNl1Gc+GENOhS8RZxGU2G4iECTGR4Mvzqe4hXvcxHpt0FqCCjbQ0l7TQzJJV9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=h5/JdWDP; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="h5/JdWDP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788435259;
	bh=0OUDP/0mwxyaoU0ko0GYwRpWVlKCTEHLa6ACk+SsgmU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=h5/JdWDPGzB7l4rCw1CycCgKUdcqnQwskJI55R2NM1XkqODQ3HNPvmtgMslFNyl7S
	 MxfKnfWZVZYD1Kc/tZmlgao29EW8RSOme9uq8eeCkNubfEdA2ISSrTNy+14i/OTHMN
	 Zg+PyAC6XQdhSpHI3Sx/2ZXwbtDpmQmNq8MoI7dQOGWgYjSCgyzxVUUWxRGNe2oBQm
	 8xMAHORpAbcIWBeGns4anx8cf6BW4pKElX+s3jLBk9SMjY5PhAykEKGEVFAH/1M1Oa
	 Ruv7Ui2Vtv066dpM12e0IP8oo69jPNDx4kHGDqXcQHjnhOcASIu5pZEicXQXf/Afwq
	 qffv+twucVr7w==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A82F0607EB
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2026 13:34:19 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v2 3/8] netfilter: nf_tables: use GFP_KERNEL_ACCOUNT
Date: Thu,  3 Sep 2026 13:34:08 +0200
Message-ID: <20260903113413.1122606-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260903113413.1122606-1-pablo@netfilter.org>
References: <20260903113413.1122606-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

GFP_KERNEL_ACCOUNT is preferred these days for memcg, replace
GFP_KERNEL by GFP_KERNEL_ACCOUNT.

Just a few leftover in nft_ct and the pipapo set backend.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: do not use GFP_KERNEL_ACCOUNT with nft_ct_tmpl_alloc_pcpu()

 net/netfilter/nft_ct.c         | 5 +++--
 net/netfilter/nft_set_pipapo.c | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 9dbf127df9c8..3c4c2faa7398 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -848,7 +848,8 @@ nft_ct_timeout_parse_policy(void *timeouts,
 	struct nlattr **tb;
 	int ret = 0;
 
-	tb = kzalloc_objs(*tb, l4proto->ctnl_timeout.nlattr_max + 1);
+	tb = kzalloc_objs(*tb, l4proto->ctnl_timeout.nlattr_max + 1,
+			  GFP_KERNEL_ACCOUNT);
 
 	if (!tb)
 		return -ENOMEM;
@@ -934,7 +935,7 @@ static int nft_ct_timeout_obj_init(const struct nft_ctx *ctx,
 	}
 
 	timeout = kzalloc(sizeof(struct nf_ct_timeout) +
-			  l4proto->ctnl_timeout.obj_size, GFP_KERNEL);
+			  l4proto->ctnl_timeout.obj_size, GFP_KERNEL_ACCOUNT);
 	if (timeout == NULL) {
 		ret = -ENOMEM;
 		goto err_proto_put;
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 978bb0c01106..3617bb66094d 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -2298,7 +2298,7 @@ static int nft_pipapo_init(const struct nft_set *set,
 	if (field_count > NFT_PIPAPO_MAX_FIELDS)
 		return -EINVAL;
 
-	m = kmalloc_flex(*m, f, field_count);
+	m = kmalloc_flex(*m, f, field_count, GFP_KERNEL_ACCOUNT);
 	if (!m)
 		return -ENOMEM;
 
-- 
2.47.3

