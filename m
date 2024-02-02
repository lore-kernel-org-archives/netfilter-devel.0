Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEF7C7763D
	for <netfilter-devel@vger.kernel.org>; Fri,  2 Feb 2024 09:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706865613; cv=none; b=IDPCSLiHZfE6yZEKvp95mQi1Uk72Ntq0Q2aUENN/sCjpaV3KTb3MQt17+GTveTTSClENC0d87jemlT8CK9sOxqV1aQyXwk2fpcUcJ4m6MR20fEx4hWwZ243d1ppQ6+Rd2T1VYPEh4nMORFX69HexXKCZGuEUYCMEZSHuHjXTjMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706865613; c=relaxed/simple;
	bh=PU7UEUpSNPhUkPIkmvSRc9uwekEDT0k6Y67J10CevyU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=WanuQprl6K1YLe1N+DWvYUI/BHHtc8Ka9Ig2MHUqkTo9I5NI8m9Ak4cDGo1+dNMraGgVHo24wLF/qPwa0n4R+zOXsC4GKJU7lRFE6ntuhsgV5X8Rj9DPVsZLttYfiieTDKDQ7ted8+vWGzUdjieWr3fjE2N5u1gnvEEWcVEw6wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf] netfilter: nft_set_pipapo: remove static in nft_pipapo_get()
Date: Fri,  2 Feb 2024 10:11:16 +0100
Message-Id: <20240202091116.16988-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This has slipped through when reducing memory footprint for set
elements, remove it.

Fixes: 9dad402b89e8 ("netfilter: nf_tables: expose opaque set elementas struct nft_elem_priv")
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

