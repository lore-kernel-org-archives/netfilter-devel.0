Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0CA023776
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Mar 2024 17:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710868359; cv=none; b=Ayrifo5pkc3HCrcf6Zbd737SPIZjO41DprTEOOljcAFz1CMo8WMkWdaOdvOXBZ/EP/AwfaG4wPd/Zcsujc1uiSMUOpp7KmouiJ33AI/wzgwzEMfF1Jz1jl/nfTow1K0IecJjBzUfYMvDHjt6saz6GmV6NwTpwTkiVHX6AfOctAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710868359; c=relaxed/simple;
	bh=nN4vTicuq5j61xNz62XobuvZXTR6gaHzGaY0eeIVpn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WgdUPuLmgCgMQ49rGjscODSqL8eQ6FzyufNkbNKS81zngF32sYIblGpbFAUV5EA1K1MJQ1OgZGEBknidHf26RA2U4j58gr4yBx8Hz2bfiXkmwPcoONK1dSercXPDLkXviS+d/Uwp4tSzn9zYdFb10cwUNmWQFxYalyXd+cipurw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=KRCzUK/l; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="KRCzUK/l"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=iec3IXnP3dYmNM8YEjH9JSNo75Fbw8CabJVABdh7FbI=; b=KRCzUK/lm1/SgHxEYW6nmG9/Ln
	FfVQt7vlWUK7NbgyQ3b6XoAVRMAafe0IcA1YOM58fUtA8GaJ5bjAsdC1yj+1Aw3hapmZzUM2P02D9
	WW7x0UcGFXa4rGTQdzwD0UodOGqluUWuaVOmk0hprGrXmDNd8FCSQSmeTt6bLsEjKNBna4HXi19+2
	oiqVwADPqIPLrIc+wZ4x+g0zlW34w7NGww8GNcjiHGELzecJqNcIo06bmEBbuvquwtLlJZ2Q4y5Rt
	ikJzqZon1T1Y0IDGhI5T8yeM2UxIke3mzrR/PpmF+AE8pA/NZRtPGvKM9f2hM3owP/861WIMFJJly
	/llJ8jqw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rmd0u-000000007gd-1aJ1;
	Tue, 19 Mar 2024 18:12:36 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 04/17] obj: Validate NFTNL_OBJ_TYPE, too
Date: Tue, 19 Mar 2024 18:12:11 +0100
Message-ID: <20240319171224.18064-5-phil@nwl.cc>
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

Fixes: 5573d0146c1ae ("src: support for stateful objects")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/object.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/object.c b/src/object.c
index 0814be744448b..d3bfd16df532e 100644
--- a/src/object.c
+++ b/src/object.c
@@ -98,6 +98,7 @@ void nftnl_obj_unset(struct nftnl_obj *obj, uint16_t attr)
 }
 
 static uint32_t nftnl_obj_validate[NFTNL_OBJ_MAX + 1] = {
+	[NFTNL_OBJ_TYPE]	= sizeof(uint32_t),
 	[NFTNL_OBJ_FAMILY]	= sizeof(uint32_t),
 	[NFTNL_OBJ_USE]		= sizeof(uint32_t),
 	[NFTNL_OBJ_HANDLE]	= sizeof(uint64_t),
-- 
2.43.0

