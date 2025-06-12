Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11988220F2A
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Jun 2025 11:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749729153; cv=none; b=kz0I6lTbGollnQ9nG5ZN4XgJ4AJiW+WihtFZv0DPg+noAcdjWfhnL5BY9T/nbVufPJCJWBlbwTpZEgQy9fPVkbddXSx1oAs2lwbVvAjujrI02OxTVK1iMXoDCOi/ulQbpNLC58HAslEZLwIzyJ3dUjkCT3A/kEOIlQzVmj1RrOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749729153; c=relaxed/simple;
	bh=cGPeQMd6KAwq+mtElxi3aFvGY3mqsWR4bn1BwC6VLM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BAkFAwFb6yuZBbqBpL0nLBO+skGbV4mF5A6W6TfERtgEsq4Ih129fuAJxf28Vjty3W6PnBtmWa0h4YvPVnyBZHtqbKMDVPqkyE+Y4DlZKOf0KJIWsC8nwFSZ006yzbFD+7q285OLBNPIPvtdvmP8WtMAD7zE4mpU4639wXBTMgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=cdGlAfBf; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="cdGlAfBf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=z56wLFDIO5QJcvtA6W5RZU1LcpYtVJqYe6DXcJ2/yJY=; b=cdGlAfBfeI9rSCJ5QEIynLutw/
	PUjzUvjQQA7JaPc7rmgX0HQElt5bCjThXq9wvf7kx6SqAYqe4xdgluq93ijhempIJ/DD7HCyu6kT9
	++d161MsuSb9xEY8JBuIcPZJDTY1nQulUXzMdQPWIoQZVReQwbfE8yewbKur/SdUzVCRZ16Q4K2qe
	4m9s/5ZBJnyt34S4t+VJKQDhQCOA7UDsaJwTQNkCDqOVzf+v9+goVIqF4/vPOd9mI9C93mZh2klUY
	vFMHf1A3B8yELq0CuW4rfsiEl//JlYN2iuuWTSbQBVH5Pk7r9mPZXM1FnjngOz/QSraIYuUq3Uf5U
	cMw0hQxA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uPgTu-000000006G6-0wXx;
	Thu, 12 Jun 2025 13:52:30 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 2/7] netlink: Do not allocate a bogus flowtable priority expr
Date: Thu, 12 Jun 2025 13:52:13 +0200
Message-ID: <20250612115218.4066-3-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250612115218.4066-1-phil@nwl.cc>
References: <20250612115218.4066-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Code accidentally treats missing NFTNL_FLOWTABLE_PRIO attribute as zero
prio value which may not be correct.

Fixes: db0697ce7f602 ("src: support for flowtable listing")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/netlink.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 0e0d32b846d6a..be1fefc068bfd 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1862,14 +1862,16 @@ netlink_delinearize_flowtable(struct netlink_ctx *ctx,
 		      sizeof(char *), qsort_device_cmp);
 	}
 
-	priority = nftnl_flowtable_get_u32(nlo, NFTNL_FLOWTABLE_PRIO);
-	flowtable->priority.expr =
+	if (nftnl_flowtable_is_set(nlo, NFTNL_FLOWTABLE_PRIO)) {
+		priority = nftnl_flowtable_get_u32(nlo, NFTNL_FLOWTABLE_PRIO);
+		flowtable->priority.expr =
 				constant_expr_alloc(&netlink_location,
 						    &integer_type,
 						    BYTEORDER_HOST_ENDIAN,
 						    sizeof(int) *
 						    BITS_PER_BYTE,
 						    &priority);
+	}
 	flowtable->hook.num =
 		nftnl_flowtable_get_u32(nlo, NFTNL_FLOWTABLE_HOOKNUM);
 	flowtable->flags =
-- 
2.49.0

