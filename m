Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728F42B9B3
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Mar 2024 17:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710868352; cv=none; b=P2MOu9KVHEe2mXt3Jtj1qbyeScLjjrQBk5KLdcyj9JGabjyxe3wsCjsbEm8kPnXELpimUekMHfOZ+EkxsIM13t8kKIP5d/fPiFKGhvyfpGtQSTr7Hoe9KhtGy7hrqvHfYDMbUhyFbUl1+gf8N6BQ7vLB9NE0oH6rXDwljtGowLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710868352; c=relaxed/simple;
	bh=joaT5qXcpoYy45ohc3q38RHapRLSe0FobxbGJStYpC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oEB+yMC/v0cX7O5Eqlk0qyZ0qPyOPTgRk6OjzNry02KmztNSM6JVPjhqIi5Lzu/H540zXthPr7KrxVe7wptlHMyU1UzB2Qh2qhA+rPwPVuveEFcnIFHJhKZF6ickAj+A2xhdAzNEdfu5Jy69ZWogO5YFlva8wJGwwzs5nqsi8Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Wj1dsLfG; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Wj1dsLfG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=GG/ajz4S6q3ZRquV8B6RlCYdYhhD84El14q90RK3thk=; b=Wj1dsLfGtVUQY4FcI5xmemvDvu
	/uTc0wsG15J2M4fRaWahwUwSIzVfDVyY54NYd0pr2VLvfxhOVCpFAexV2W46oCaadUM6TjJIEyN98
	UzsEtvdJWr70Ox6gdzGHVWUxUv1IzPndPQdMUb/Dl37IzLwmVB8LWYPTW9M7A13dlSKsyVaMiRpI3
	g1xZx445QNzYt0atD9+7VsLs4wV+CSceSZm81W6+a7d+nCBklwpcmfyv+YFLluUAbzi1pVw6/zLlV
	cm/PjpyPnfxQlqQbsKfNwCbljr7qdlkAmYLV7plob+Zy8qx4Y4XKjcAS57wcU3b/LtECshWhRyL/G
	FB39rsIQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rmd0m-000000007fX-3HlM;
	Tue, 19 Mar 2024 18:12:28 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 06/17] table: Validate NFTNL_TABLE_OWNER, too
Date: Tue, 19 Mar 2024 18:12:13 +0100
Message-ID: <20240319171224.18064-7-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240319171224.18064-1-phil@nwl.cc>
References: <20240319171224.18064-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fixes: 985955fe41f53 ("table: add table owner support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/table.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/table.c b/src/table.c
index 4a439ff5ab996..4f48e8c9e73e1 100644
--- a/src/table.c
+++ b/src/table.c
@@ -89,6 +89,7 @@ static uint32_t nftnl_table_validate[NFTNL_TABLE_MAX + 1] = {
 	[NFTNL_TABLE_FAMILY]	= sizeof(uint32_t),
 	[NFTNL_TABLE_HANDLE]	= sizeof(uint64_t),
 	[NFTNL_TABLE_USE]	= sizeof(uint32_t),
+	[NFTNL_TABLE_OWNER]	= sizeof(uint32_t),
 };
 
 EXPORT_SYMBOL(nftnl_table_set_data);
-- 
2.43.0

