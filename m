Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2E12B9B6
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Mar 2024 17:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710868352; cv=none; b=S+duUCTzPLNgIma0/fSNSzabzXaqzhbRMlHLcpNBxVIQZuYPfBUUC6+aPT74nkDN21RrA78+B6jYNS/RR+3iQ61cGlOjJNev/r18UyV5sI958J15bf/96m9mI5NudER3J54soF9FF8BFSSQ8ZAuAQG6LFaxfyFC8cAFkl2sK4lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710868352; c=relaxed/simple;
	bh=yjF8a7fhTA0VfIJXrywM54mWP8JNmLQ+yOn2MCte9PY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KMuzdNCxUidstJ3UIuHrIZoS8Ui45NrEOtp5IQ7qpOF8Cz/QYewKRuXoYPyfqZz+zYOMkDfnFaFfXeZJSgw+oZKuIAlLvCoGEkqTMatHLJU58Mf9Io0U6ZJ72VEBNfnFfT44GTYQAkvd00IebY31JQA8bR+743cPHVuYrO9iBw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=KiDntzap; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="KiDntzap"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=l1GIAkj8Hj9jGBdwNwzccCLHnEb25WCTGYgeHVSPDEk=; b=KiDntzapMqVBFBb0BONy89Jo6A
	hIv2ICwMZ/rwVm/YEKNnAlI+fSbs+34XKM84Y9luGhCOo+p3TVH2PXiD9Iy1qDqwsrAhkXubkClZH
	38l3LGqn1upc3D/a9ovMKG30RI73wE2plzpKAIgHzeUvxt2RNKK2YKo78o1c1IOR9Sw4whdwFemEG
	ivFoYdzPFbQoVXjzVDFo2gDZgrprUU5C+cJbZ6hwp0AlsmLMlkIltqWvrCR+qvc9+eFQJQ6K4LMtl
	Cqf07SyEb3pEGaWqynokCT2XK9Fj5xFcjZz2BXK9n4njZdUsUoNDvdOg4viuXiqv6ABQufEMFX46F
	MwuwpF2Q==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rmd0l-000000007fJ-2iNx;
	Tue, 19 Mar 2024 18:12:27 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 05/17] set: Validate NFTNL_SET_ID, too
Date: Tue, 19 Mar 2024 18:12:12 +0100
Message-ID: <20240319171224.18064-6-phil@nwl.cc>
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

Fixes: 26298a9ffc2e2 ("set: add set ID support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/set.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/set.c b/src/set.c
index b51ff9e0ba64d..a732bc032267a 100644
--- a/src/set.c
+++ b/src/set.c
@@ -128,6 +128,7 @@ static uint32_t nftnl_set_validate[NFTNL_SET_MAX + 1] = {
 	[NFTNL_SET_DATA_LEN]		= sizeof(uint32_t),
 	[NFTNL_SET_OBJ_TYPE]		= sizeof(uint32_t),
 	[NFTNL_SET_FAMILY]		= sizeof(uint32_t),
+	[NFTNL_SET_ID]			= sizeof(uint32_t),
 	[NFTNL_SET_POLICY]		= sizeof(uint32_t),
 	[NFTNL_SET_DESC_SIZE]	= sizeof(uint32_t),
 	[NFTNL_SET_TIMEOUT]		= sizeof(uint64_t),
-- 
2.43.0

