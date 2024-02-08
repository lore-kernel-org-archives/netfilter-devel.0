Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD2C66EB73;
	Thu,  8 Feb 2024 11:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707391723; cv=none; b=UU2hkSLtnDc+w7zFg/N1ROILREugbHX+bcCZur1i5/v+r8Omfj0cLFfMYfZbw89B/pVEhh49ZnyNFBa0wkjpNYczd9iaXoz8j2pkFU1rxburjYcd5XsP+KpnNRWHBZhJHWUX/7g1iKhZwYNMnyvFqm9fvWeaAQzTIdOC6rDmOlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707391723; c=relaxed/simple;
	bh=u+nUvuRzQDGFtm1iYQtfjCZm5QnX9kkio2LKDuE+Hzk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=U4+T6PgyuZuWOdCL6JvTcbeaYH2HdkG7Wzq2fgO3/WtWTLwDZSZYDPEPHhVvdBQJV2RDwDnnQrf6KYspKjHnhIDNGgIp5Mrq7asHANxphUjDTgikjIoAtrduvRzyP+UFig/OwLsdsm7GP1EihuV4egtP6fkVmIilDBmH6Kjf3EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	kadlec@netfilter.org
Subject: [PATCH net 04/13] netfilter: nft_set_pipapo: remove static in nft_pipapo_get()
Date: Thu,  8 Feb 2024 12:28:25 +0100
Message-Id: <20240208112834.1433-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240208112834.1433-1-pablo@netfilter.org>
References: <20240208112834.1433-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This has slipped through when reducing memory footprint for set
elements, remove it.

Fixes: 9dad402b89e8 ("netfilter: nf_tables: expose opaque set element as struct nft_elem_priv")
Reported-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_pipapo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index efd523496be4..f24ecdaa1c1e 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -603,7 +603,7 @@ static struct nft_elem_priv *
 nft_pipapo_get(const struct net *net, const struct nft_set *set,
 	       const struct nft_set_elem *elem, unsigned int flags)
 {
-	static struct nft_pipapo_elem *e;
+	struct nft_pipapo_elem *e;
 
 	e = pipapo_get(net, set, (const u8 *)elem->key.val.data,
 		       nft_genmask_cur(net));
-- 
2.30.2

