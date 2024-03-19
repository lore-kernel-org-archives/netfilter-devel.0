Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5419825632
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Mar 2024 17:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710868360; cv=none; b=qPmLNHEMMguc3gReyPM9a8ULZ2GL0QrPmxIkIvQpdWMRa/90VLlWZG5eMDeUL3qlBX+yAU3O2RKm8l1RTqYWgXxD7doqu7rYfHWlDUv4zxtDj2lNGIGTUJteROSWhwmUbgOI+a7rlfuSUmmpVEHN6LdU62x6/xsL5LGCMcxewL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710868360; c=relaxed/simple;
	bh=3A8MWPkhorBgArg2hXf4U4+skJwUfzSNqIBXDKQe3Pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O5HmBcDkkbE1GGxhxlGmtariVG9AUZP44tN2C8eFQzatHP7K9NnuC16HfEWXU+mWb6/tnuI+07RTBPfA1GApLoZWshpalZ7sYBw48UEHzUu8YaTnx7dK+20C0R5vY1DHq+nnJ5Tr/upjSNendo2TsIiSzWH/QyusicDmhnGJ4rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=lN0IJCLv; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="lN0IJCLv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=jB4FBDUbniijQwcM6GcvuYn0Bzi71fQcnfa1Y/cimJM=; b=lN0IJCLv+tNb07rGW1CFXhiVEW
	99U10Kvt+14HBWZPBpZ0obn1BTSBJZu6AubnzC3Nyq+mhWNYtVrSnflA1aHpxPmEZ/nYNz9Pw6lKV
	BMToJZjy1g8OqyufJ2j4vZ64avTW4BfvW3KaP1j14dCOY5+EfrVmLl/rTSjVNcCJ5zcnwzIX0M4EM
	zSqTnWy7WMIenLaRar293SxyoPjX3qnkfrdML5I5lu2PL11EZKt/XuFQ39d+/Ez0/SYc4LrTtfg+H
	eDNhjvM4LbsE05O/w0PDxY28kl4YDCK8KMdpjwrFkf47+Pa+1MXXKqqJT4rXR19C/WX81SRqGDBYW
	TCaQKf4w==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rmd0w-000000007gq-0Aez;
	Tue, 19 Mar 2024 18:12:38 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 03/17] flowtable: Validate NFTNL_FLOWTABLE_SIZE, too
Date: Tue, 19 Mar 2024 18:12:10 +0100
Message-ID: <20240319171224.18064-4-phil@nwl.cc>
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

Fixes: cdaea7f1ced05 ("flowtable: allow to specify size")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/flowtable.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/flowtable.c b/src/flowtable.c
index e6c24753525c8..2f37cd4c7f04a 100644
--- a/src/flowtable.c
+++ b/src/flowtable.c
@@ -102,6 +102,7 @@ static uint32_t nftnl_flowtable_validate[NFTNL_FLOWTABLE_MAX + 1] = {
 	[NFTNL_FLOWTABLE_HOOKNUM]	= sizeof(uint32_t),
 	[NFTNL_FLOWTABLE_PRIO]		= sizeof(int32_t),
 	[NFTNL_FLOWTABLE_FAMILY]	= sizeof(uint32_t),
+	[NFTNL_FLOWTABLE_SIZE]		= sizeof(uint32_t),
 	[NFTNL_FLOWTABLE_FLAGS]		= sizeof(uint32_t),
 	[NFTNL_FLOWTABLE_HANDLE]	= sizeof(uint64_t),
 };
-- 
2.43.0

