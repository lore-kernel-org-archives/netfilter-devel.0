Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 643A11D557;
	Wed,  7 Feb 2024 23:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707349058; cv=none; b=KDYKrA1kgmvcUBp5jhNl9l/TJ784wd0JNM3McL6ZPB17lSmwQfO38UZ7UGftIc0y1svUwAANwfbzEVAJ7q0pic+IuAV4859sLha0ookWs1DFxytIxFRodntGDwErzlryhMSaUbUskbMS/qm02AtKyp8h+oPiPSN6m8MBpn/jPYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707349058; c=relaxed/simple;
	bh=PU7UEUpSNPhUkPIkmvSRc9uwekEDT0k6Y67J10CevyU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Mtij0xBYApYYd/mVMRkUFtTemYRm3e5eyVEpeDEg0eUZGcoPa1WO7yxhVI05QssP+/E5kRlzGdsHJzIVpojTA4XwLTTBM+xeszFQK5tbOfgNkyXHP9xkKVeBhIHONa2sPR+4QhopkQREgIj/Nd/0/tCB2MuKkiRPVEb20+d8sJU=
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
	fw@strlen.de
Subject: [PATCH net 04/13] netfilter: nft_set_pipapo: remove static in nft_pipapo_get()
Date: Thu,  8 Feb 2024 00:37:17 +0100
Message-Id: <20240207233726.331592-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240207233726.331592-1-pablo@netfilter.org>
References: <20240207233726.331592-1-pablo@netfilter.org>
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

