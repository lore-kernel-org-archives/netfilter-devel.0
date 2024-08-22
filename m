Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C96A1D1F73;
	Thu, 22 Aug 2024 22:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724365192; cv=none; b=L2i8P1piUkjccDpciqL7xrQbC51PWC2pp7iHxVl2kXq1DUCQFHrR9qnjUYehe8k2N+XR7HYJuinOzDmGusJrzcuPVZPihvGreypG5vWtWvz1d8wLLcjhoGuIDfNjIRhi/p/KJxTwUvfFj9NYoCYnkTTt9PuWEKC72E/LfKJFJUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724365192; c=relaxed/simple;
	bh=5b5h28OVv58h4Qa2YgM9+gDTcrEVSP+IRJCZ0oC9c1E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WrP3+qTXG3UKgdKDcIBngMTaxV0UFTPxyV/1/1zIGvMA9BpMIiAvGwV4d2+a9w5exLCxnKL6vcur2XcVox0rEfZuuLcQOcSjf60mzs0au7yyykIktvi2tZR7oejC+NjmYKvWumi6TysB/ZTtgNrp3yh946AuAVc2+vQqibvcu0M=
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
Subject: [PATCH net-next 5/9] netfilter: nf_tables: do not remove elements if set backend implements .abort
Date: Fri, 23 Aug 2024 00:19:35 +0200
Message-Id: <20240822221939.157858-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240822221939.157858-1-pablo@netfilter.org>
References: <20240822221939.157858-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pipapo set backend maintains two copies of the datastructure, removing
the elements from the copy that is going to be discarded slows down
the abort path significantly, from several minutes to few seconds after
this patch.

This patch was previously reverted by

  f86fb94011ae ("netfilter: nf_tables: revert do not remove elements if set backend implements .abort")

but it is now possible since recent work by Florian Westphal to perform
on-demand clone from insert/remove path:

  532aec7e878b ("netfilter: nft_set_pipapo: remove dirty flag")
  3f1d886cc7c3 ("netfilter: nft_set_pipapo: move cloning of match info to insert/removal path")
  a238106703ab ("netfilter: nft_set_pipapo: prepare pipapo_get helper for on-demand clone")
  c5444786d0ea ("netfilter: nft_set_pipapo: merge deactivate helper into caller")
  6c108d9bee44 ("netfilter: nft_set_pipapo: prepare walk function for on-demand clone")
  8b8a2417558c ("netfilter: nft_set_pipapo: prepare destroy function for on-demand clone")
  80efd2997fb9 ("netfilter: nft_set_pipapo: make pipapo_clone helper return NULL")
  a590f4760922 ("netfilter: nft_set_pipapo: move prove_locking helper around")

after this series, the clone is fully released once aborted, no need to
take it back to previous state. Thus, no stale reference to elements can
occur.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3ea5d0163510..c85d037a363b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10789,7 +10789,10 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 				break;
 			}
 			te = nft_trans_container_elem(trans);
-			nft_setelem_remove(net, te->set, te->elem_priv);
+			if (!te->set->ops->abort ||
+			    nft_setelem_is_catchall(te->set, te->elem_priv))
+				nft_setelem_remove(net, te->set, te->elem_priv);
+
 			if (!nft_setelem_is_catchall(te->set, te->elem_priv))
 				atomic_dec(&te->set->nelems);
 
-- 
2.30.2

