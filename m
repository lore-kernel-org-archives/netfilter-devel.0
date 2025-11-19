Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4DF33C187
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Nov 2025 12:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763556138; cv=none; b=VGx29excm0WMOibuevjSXVrHyqx/TXXp5pqWLJpsQzcWFOnyBR0Gb2S56hJPisHaPdJMGxgPcu9js5+tRYV4gU80+IzeSK2VrdpTaL39JqzkBWqJDXy9G9yKNddCYggZlGtkx85c721ZSdxnJvMiD0Mn7zObddGyyODfsEPwbdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763556138; c=relaxed/simple;
	bh=fw1gDkbuFNAdP8X4ikFw72KuSYEjLVfgyhYuWBtuLp0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=odUHRyYGIqiafap89AzYLLZDnmO7buDJW+NLv9B963HejmN6jLIUrCI/OzdrJMdwAtFRIzfMtq60VgOirpHYTZYlK7RHZy62+DFCzScRhroXwqs0cdOMy6oIjIKzeY3ScnPoXFfj4ME/Zug6EBFDs/pjXEyIkW0RgZqZv2pSKq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=t179rMVJ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="t179rMVJ"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id F34AD60279;
	Wed, 19 Nov 2025 13:42:10 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1763556131;
	bh=yNwpYi5Jaxyq5e3I654VBSywCrp0kg39AbDFND+khSE=;
	h=From:To:Cc:Subject:Date:From;
	b=t179rMVJrJZ+KhR760PKUsJ1rWx6oWLV8iZFBSGNUvTZRXnBCDiH7626nteuBVIoD
	 d6POySKpN3TV01irFhuQqdRUk5FWQA/sG0cleXtT8rxh97UYn77sCG4XcPKUzwgfwn
	 Q4kHIMIdu56gEIAXtb9r6wjNVGhHQqTi38XuNlh3sEZkO+zkPc9UJahYICF23Ax54u
	 Y3oeHb4KaYAKSnGPnPlRNgAdzSXR+Xaw89po8HdLI5CPonuGc0Z+y1PeJMK04fRvYX
	 N26JwvA1Ss9ue4S2SM+BFlRpFndxq1YVybDlTF/F7pRihKcXpe5PQfnvgUG2wKutbT
	 mRHJohH9dyZ8A==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf-next] netfilter: nf_tables: remove redundant chain validation on register store
Date: Wed, 19 Nov 2025 13:42:05 +0100
Message-Id: <20251119124205.124376-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This validation predates the introduction of the state machine that
determines when to enter slow path validation for error reporting.

Currently, table validation is perform when:

- new rule contains expressions that need validation.
- new set element with jump/goto verdict.

Validation on register store skips most checks with no basechains, still
this walks the graph searching for loops and ensuring expressions are
called from the right hook. Remove this.

Fixes: a654de8fdc18 ("netfilter: nf_tables: fix chain dependency validation")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Supersedes: ("netfilter: nf_tables: skip register jump/goto validation for non-base chain")

No rush to apply this, still running a few more tests here on it.

 net/netfilter/nf_tables_api.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f3de2f9bbebf..c46b1bb0efe0 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -11676,21 +11676,10 @@ static int nft_validate_register_store(const struct nft_ctx *ctx,
 				       enum nft_data_types type,
 				       unsigned int len)
 {
-	int err;
-
 	switch (reg) {
 	case NFT_REG_VERDICT:
 		if (type != NFT_DATA_VERDICT)
 			return -EINVAL;
-
-		if (data != NULL &&
-		    (data->verdict.code == NFT_GOTO ||
-		     data->verdict.code == NFT_JUMP)) {
-			err = nft_chain_validate(ctx, data->verdict.chain);
-			if (err < 0)
-				return err;
-		}
-
 		break;
 	default:
 		if (type != NFT_DATA_VALUE)
-- 
2.30.2

