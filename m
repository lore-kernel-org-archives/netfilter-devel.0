Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D34518E74A
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Jul 2024 14:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721052964; cv=none; b=Le/uhe0n0SCmByJRxXgQC/RHpPM8u2xpDyDdpEk6zEwfkpvt5QHNly5ICmaXd3bvPontS2YFzKb5+24hLDTekMIPvzb3k3VK9oEXWtg2CyofF7Uc/1Sf+QrCOiDqhbr21d44g9+/ZTjMLJBosWCPDTDpEatRA68Hq64hcaiFCJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721052964; c=relaxed/simple;
	bh=zDvzuCBWy3rdfdTp3uohB3LAH85nUpp0EzdDX5jhV14=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=XhW9Ryds4Y1PWGGaA+B/DAp+6pc0VHxw1afbGRu3cyOx70NdXUcuOAi6Mq/3Iuq8iX8RiySHeDUudI1Ya7e0/aNVk379N4pZ9iEwDR77zkUiRzVkiwl6RuFJvrF3IkoJvVd9Bg7fy6AhqYy08QEpI1oQ13i7c9kH0iCKv6RG5JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: nf_tables: do not remove elements if set backend implements .abort
Date: Mon, 15 Jul 2024 16:15:56 +0200
Message-Id: <20240715141556.44047-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
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
index 70d0bad029fd..f1b5bfe18691 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10713,7 +10713,10 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
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

