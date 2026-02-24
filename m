Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB9D3A0B3D
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Feb 2026 18:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771957380; cv=none; b=n+gkfWuDbGLMLYn41E6qC0s/AlBGD3Ctm45mGvbz86YH+z05QqDGbJEpUC9937YWuXqeXxbLyVkd2CblIbyR7lVkGKLKwstghtDWw2uK9bWjboTpUD54sPoZrVoKDO5psTeo3cGdm33U1ew7A0jeZr5YDFFS099TpISs9CFeWPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771957380; c=relaxed/simple;
	bh=PzToTlyQTK9MSeIf4jTyBoKdvuFHUfwZ2IchhgekZlU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pjcrBaOAO3tStCZdjqcQWwoLVKXzqmpCsJSSy4V3SKpbofQrrYEqE3t78u2aOHFenV+cbDHVgqPrDLcKFlJeWnEjMQlKP43dTjD2XFrKRcL+4OwciQV1s57JsnD9c9PqCTg4tAcTG5qmHC4WEukUPfo9Y0jcO1Hm565QVdp7X/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=eiOwJHzo; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="eiOwJHzo"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 0E1196054C;
	Tue, 24 Feb 2026 19:22:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1771957372;
	bh=Q0QxlpU/dttKpL7PHovYwkFrAisVSBe7KAtD0J0wPz8=;
	h=From:To:Cc:Subject:Date:From;
	b=eiOwJHzodqMwOT1OmU+/aLJhIvIH6AFQf/l1iaLAVVOL5/zoKYwe0px3WVaJeUkzW
	 hHeEfbFPTumfeHCCQMTKmPkCPn3nB9Mtd9VcfP7aaAaC/Rw+nWZtqkjxOTH9JyI4D+
	 lAMudw2ZUSYBQof6qk4AvjUmKQXXospI2uML/df73+7eOzte8DsqPp8HZlYrdyn0va
	 +8erw/8cR0CKqK6fQ66PUs5J+OqJlfT/90jdvOkmfnm41J5gOeE7WGc2Xfw1vypT8O
	 e489kYEixGXOMKCWsE50SdjD5cGwlX/1xozz2xfnOUmczx2v695/qOMHPQvD/hooN8
	 oDpb3n+NVMDUg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf] netfilter: nf_tables: inconditionally bump set->nelems before insertion
Date: Tue, 24 Feb 2026 19:22:47 +0100
Message-ID: <20260224182247.2343607-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In case that the set is full, a new element gets published then removed
without waiting for the RCU grace period, while RCU reader can be
walking over it already.

To address this issue, add the element transaction even if set is full,
but toggle the set_full flag to report -ENFILE so the abort path safely
unwinds the set to its previous state.

As for element updates, decrement set->nelems to restore it.

Fixes: 35d0ac9070ef ("netfilter: nf_tables: fix set->nelems counting with no NLM_F_EXCL")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0c5a4855b97d..834736237b09 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7171,6 +7171,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_data_desc desc;
 	enum nft_registers dreg;
 	struct nft_trans *trans;
+	bool set_full = false;
 	u64 expiration;
 	u64 timeout;
 	int err, i;
@@ -7462,10 +7463,18 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	if (err < 0)
 		goto err_elem_free;
 
+	if (!(flags & NFT_SET_ELEM_CATCHALL)) {
+		unsigned int max = nft_set_maxsize(set), nelems;
+
+		nelems = atomic_inc_return(&set->nelems);
+		if (nelems > max)
+			set_full = true;
+	}
+
 	trans = nft_trans_elem_alloc(ctx, NFT_MSG_NEWSETELEM, set);
 	if (trans == NULL) {
 		err = -ENOMEM;
-		goto err_elem_free;
+		goto err_set_size;
 	}
 
 	ext->genmask = nft_genmask_cur(ctx->net);
@@ -7517,7 +7526,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 
 						ue->priv = elem_priv;
 						nft_trans_commit_list_add_elem(ctx->net, trans);
-						goto err_elem_free;
+						goto err_set_size;
 					}
 				}
 			}
@@ -7535,23 +7544,16 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		goto err_element_clash;
 	}
 
-	if (!(flags & NFT_SET_ELEM_CATCHALL)) {
-		unsigned int max = nft_set_maxsize(set);
-
-		if (!atomic_add_unless(&set->nelems, 1, max)) {
-			err = -ENFILE;
-			goto err_set_full;
-		}
-	}
-
 	nft_trans_container_elem(trans)->elems[0].priv = elem.priv;
 	nft_trans_commit_list_add_elem(ctx->net, trans);
-	return 0;
 
-err_set_full:
-	nft_setelem_remove(ctx->net, set, elem.priv);
+	return set_full ? -ENFILE : 0;
+
 err_element_clash:
 	kfree(trans);
+err_set_size:
+	if (!(flags & NFT_SET_ELEM_CATCHALL) && !set_full)
+		atomic_dec(&set->nelems);
 err_elem_free:
 	nf_tables_set_elem_destroy(ctx, set, elem.priv);
 err_parse_data:
-- 
2.47.3

