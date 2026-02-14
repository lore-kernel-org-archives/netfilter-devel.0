Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E0D27EC80
	for <netfilter-devel@vger.kernel.org>; Sat, 14 Feb 2026 15:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771081741; cv=none; b=URCpf1iZNttDoVxrggCnxGcxT4Pd3MN10Y221kZ7uZBhfgBvMCDXiyr5F4Vcjvb7wDyDFHSozGjFr1OOBTNVXVhB0Q43ld2niXVnntM6AEpUxRiss3JNCb1PQJIpqZddhykq3teZQi6/GsEQ6IJqEUVouh7ek0SAosfPhziiZUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771081741; c=relaxed/simple;
	bh=CALbPl2hUAGkU4px/JCvqLQKbZG0rk5AKXMyM1h6ffk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YCHLgDYIEYjvkKUE9eNlKSIezubmDdvfW9HBt0KKFllz+IyXVVijXj4nWJAcWf034LdxJoOjz7I8cm9ynbx7QJsKYxKXu4ZUm5r8yPY1JVCuWACVDCzoh4R/G7rZCVCXAMlarQl7Aemh868z86MEz0wmOltEGS2mKKObgtzCcMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=n7Su7PX4; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="n7Su7PX4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Faxg9YXC04GUJcsawnlby1MTaUdOvP29H4zL9KbmdDI=; b=n7Su7PX45Pzs3gRMUaPFHoJ2MH
	oCL04MhCrWFNq1DSt6IvJixG14bTskgJ8fPQo/g0Tw34wzcA+IpRgx3YMK74VxTE3bysaqSoWxhFr
	3I5bvvTfCCF99M84SmRqrc2hSmVX031fO6YPz35aWkNtn5svIW4M3sN4niWrQOmRh7/MgfmKcOpGA
	7dqlehnLXy01U/IFXH1sbbWzYpHyo0tZa+ko8/otAk6l6O0t48Ceog3KPzj0Plcd/Zshv69sMH1pQ
	UVXeJ2j0RRju2SStVxhCQYxFv48U2c3jlKVLAgY+PZru2XMDBh7lGNavWKfV3Z72Ww5N0g57KWRLO
	7Nq2Ybog==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vrHGT-000000000cs-3qC2;
	Sat, 14 Feb 2026 16:08:57 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	"Remy D . Farley" <one-d-wide@protonmail.com>
Subject: [iptables PATCH 2/2] nft: Use the current name for the desired NFTNL_EXPR_BITWISE_OP
Date: Sat, 14 Feb 2026 16:08:51 +0100
Message-ID: <20260214150851.31936-2-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214150851.31936-1-phil@nwl.cc>
References: <20260214150851.31936-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since refreshing nf_tables.h, the new name is available.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index da008070e3016..5c9cc6b389cff 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -4035,7 +4035,7 @@ static int nft_is_expr_compatible(struct nftnl_expr *expr, void *data)
 		return 0;
 
 	if (!strcmp(name, "bitwise") &&
-	    nftnl_expr_get_u32(expr, NFTNL_EXPR_BITWISE_OP) == NFT_BITWISE_BOOL)
+	    nftnl_expr_get_u32(expr, NFTNL_EXPR_BITWISE_OP) == NFT_BITWISE_MASK_XOR)
 		return 0;
 
 	return -1;
-- 
2.51.0

