Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA2C2641CA
	for <netfilter-devel@vger.kernel.org>; Wed, 21 May 2025 13:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747833179; cv=none; b=f8gJgLDSLucPwl37kopgjwMdNkeqV6BIihMna+ctANkwWM1Odf62JE1QzCZeYnEm09fre4/66AXzsmTV4NhcWCk+s0yvAWoeQjIRLqdg5Y/jO2MSVhLOQ0c50WY+Facv/Tt7XUgQ1c0KfCW0eL2tSPE+n9M9JY3bb39fUKYlix4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747833179; c=relaxed/simple;
	bh=BdaafgBrOh650ijDqfQ2D7pm9+Sz/XKjf0jo8LGPURY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L5YsDk+Vew9Dt4sIpANrQ86nKDHcciJmyMlcEv1mF5vyQq4Xb3v4F3tzfLbJlc510YhyUC3BJfPGZIr1vOlCTbXRgS7GdRQkRXnFah/tzbTzndE87D6CFFw1IBKTAqEgXzIy3JUrl34zzLXjExPL0/Q4dZvEuFdUkfBPbtMrDVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=odGjdlGS; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="odGjdlGS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=R1Fvv1lBzerEl8s19C+Lkh98ml2p54rRzg57uBi/Iss=; b=odGjdlGSdzgBYrbsbpryUhg0uF
	wCyapOJCQonyAFSoBBsxLJYpZdo/3b7UiyjprzlBjlj2wSDMbFSEX3acBM7rb+JDLN58bHxHra7ad
	fUUbZVnOmJyklM6Ols1Wrgcx/Y3UXcz4udtI9TS9IunGbdR7bkYz3l/YV7VTje3j8U/vp+De/zix4
	y2G6qmAaAvvp1lhCSd2UaMyNwgGTXKU4BjreGqnkVagWLD3BMA+OCEire7iyVbBXyuLllgDhav8XI
	jfvB0xLRbiwCWgSH8eEJQUBC5ZqCCsV659G9BrEsT5NFZH9o0VfO0/ZGqvfg9nmRBAUz8VlTyJTw2
	Mx23+Mhg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uHjFZ-0000000083q-26by;
	Wed, 21 May 2025 15:12:49 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [nft PATCH 4/4] cache: Tolerate object deserialization failures
Date: Wed, 21 May 2025 15:12:42 +0200
Message-ID: <20250521131242.2330-5-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250521131242.2330-1-phil@nwl.cc>
References: <20250521131242.2330-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If netlink_delinearize_obj() fails, it will print an error message. Skip
this object and keep going.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/cache.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/src/cache.c b/src/cache.c
index e89acdf55a9b0..3ac819cf68fb7 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -871,12 +871,11 @@ static int obj_cache_cb(struct nftnl_obj *nlo, void *arg)
 		return 0;
 
 	obj = netlink_delinearize_obj(ctx->nlctx, nlo);
-	if (!obj)
-		return -1;
-
-	obj_name = nftnl_obj_get_str(nlo, NFTNL_OBJ_NAME);
-	hash = djb_hash(obj_name) % NFT_CACHE_HSIZE;
-	cache_add(&obj->cache, &ctx->table->obj_cache, hash);
+	if (obj) {
+		obj_name = nftnl_obj_get_str(nlo, NFTNL_OBJ_NAME);
+		hash = djb_hash(obj_name) % NFT_CACHE_HSIZE;
+		cache_add(&obj->cache, &ctx->table->obj_cache, hash);
+	}
 
 	nftnl_obj_list_del(nlo);
 	nftnl_obj_free(nlo);
-- 
2.49.0

