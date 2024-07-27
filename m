Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88131862AE
	for <netfilter-devel@vger.kernel.org>; Sat, 27 Jul 2024 21:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722116223; cv=none; b=Ge7kuUBYAcuJsxthnAZqwbdf+WVnipnLrFLziyStNQZJFx8zmYL7jBH4jcVjeqasWoU8Bo1vsq0JuCikWk8wpW5Z5S8ff93yyKgvowl+OAB74GLmptBtuVMW4os0a+vY/tolFyGgTYkvkyJtmJp8WbyDqq6r7ZdhrOttr9C7Zks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722116223; c=relaxed/simple;
	bh=laJ4b50iABVewLmNan/yurHa/WUQoQWCNeSSkl3sy6w=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t5RwxjdElmVMD0CgPlLSLZtZ7+CYVH5EgzYfvjYIVgDA+5GV/hKFtzqV1xDGAfN6+bpM0MAxJgQhndxzzS18VyQXNFqdIoZUjTtR47ds5RHt/iroMp4SWWU+Tjn4w21kQWzQHXSKc77iTsMpW66EeFgYYRxhDTHBNmJqoB4JdOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=OKdxGHf3; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="OKdxGHf3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=vhJxW5RouVz/FPlXRxHVeYSuT2Sjfkr3lU76+nvsj1A=; b=OKdxGHf3cQaWXaINXboCEZq7Hd
	KBCzo8QIU+JYO16oLUFlRALNRvIuKYtav2iQ7p8rlMhLaaIhnlv8pWqWgsta3IeMuV05E7A22okZ7
	i12F0+rp5KdJ0ZreS5/9NsOBIW6MM+/8WjSqj4co/ZDXkamu8vNhe8e5FZ7bwsJRktuePMB2060CK
	39QdNpUg42qFj+skW5fOAtdcHVTRLa1QNLHSoA8d5YvXpQLrZbB/5i5atT2SnE5CuqDxAUzAWhsn1
	PaVYzd1glz/Zya0t9mOMXpPrZ/oj93bDDGusnpX1A3tVBpFd251kGJwj5QyMXlbNuquplC3qyM2Eh
	6fstmAkA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sXp64-000000002VG-2qtY
	for netfilter-devel@vger.kernel.org;
	Sat, 27 Jul 2024 23:37:00 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 02/14] nft: Fix for zeroing existent builtin chains
Date: Sat, 27 Jul 2024 23:36:36 +0200
Message-ID: <20240727213648.28761-3-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240727213648.28761-1-phil@nwl.cc>
References: <20240727213648.28761-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Previous attempt at fixing for non-existent chains actually broke
functionality by adding a check for NFTNL_CHAIN_HANDLE right after
unsetting the attribute.

The approach was flawed for another reason, too: Base chains added in
the same batch (cf. iptables-restore) have no handle either but zeroing
them may still be sensible.

Instead, make use of the new fake chain annotation which identifies
fakes more reliably.

Fixes: f462975fb8049 ("nft: Fix for zeroing non-existent builtin chains")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index fde3db2a22b79..243b794f3d826 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -3853,7 +3853,7 @@ static int __nft_chain_zero_counters(struct nft_chain *nc, void *data)
 		if (!o)
 			return -1;
 		/* may skip if it is a fake entry */
-		o->skip = !nftnl_chain_is_set(c, NFTNL_CHAIN_HANDLE);
+		o->skip = nc->fake;
 	}
 
 	iter = nftnl_rule_iter_create(c);
-- 
2.43.0

