Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78CE6238C04
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Aug 2025 10:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754302260; cv=none; b=fT4dI9P9fckvoahBbisHae/HHkh5pNh4Sg33tXyQnMEqzDlRWUXwvSOPk8v7c8eGY1QfjjoY2+MFEBOgVJKkRknkYD/2idoGfBPn+n9TsiG2ChFd2FbdwnMVqrMI/SlHB5jmi0qCb4D2txj6qRkpGRiX4Oi8NpduABdocQF4BDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754302260; c=relaxed/simple;
	bh=XM2xtfW+L0MJS4Y4nzJVha8DpljdE0cEgVex+FKgzZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KhyVSws3+FjtfZr9Fy/QRCIzYJ2bk3wCBBo1i3XyW92rshPtjsttmZ13mZXOaQ4ZeuXr0PZn0EtB9ZRNTyj6Mc5I8guhNNidNFUWe8931vNn26EorBTLly97EFuwmOa5PgNlLyQ15CZgQOCp6GqpifbwC4JqnXJRhGwtc4WDXvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1A86560532; Mon,  4 Aug 2025 12:10:56 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH nf] netfilter: nft_set_pipapo: don't return bogus extension pointer
Date: Mon,  4 Aug 2025 12:10:41 +0200
Message-ID: <20250804101046.54725-1-fw@strlen.de>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Dan Carpenter says:
Commit 17a20e09f086 ("netfilter: nft_set: remove one argument from
lookup and update functions") [..] leads to the following Smatch
static checker warning:

 net/netfilter/nft_set_pipapo_avx2.c:1269 nft_pipapo_avx2_lookup()
 error: uninitialized symbol 'ext'.

Fix this by initing ext to NULL and set it only once we've found
a match.

Fixes: 17a20e09f086 ("netfilter: nft_set: remove one argument from lookup and update functions")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/netfilter-devel/aJBzc3V5wk-yPOnH@stanley.mountain/
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo_avx2.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index db5d367e43c4..2f090e253caf 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1150,12 +1150,12 @@ nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 		       const u32 *key)
 {
 	struct nft_pipapo *priv = nft_set_priv(set);
+	const struct nft_set_ext *ext = NULL;
 	struct nft_pipapo_scratch *scratch;
 	u8 genmask = nft_genmask_cur(net);
 	const struct nft_pipapo_match *m;
 	const struct nft_pipapo_field *f;
 	const u8 *rp = (const u8 *)key;
-	const struct nft_set_ext *ext;
 	unsigned long *res, *fill;
 	bool map_index;
 	int i;
@@ -1246,13 +1246,13 @@ nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 			goto out;
 
 		if (last) {
-			ext = &f->mt[ret].e->ext;
-			if (unlikely(nft_set_elem_expired(ext) ||
-				     !nft_set_elem_active(ext, genmask))) {
-				ext = NULL;
+			const struct nft_set_ext *e = &f->mt[ret].e->ext;
+
+			if (unlikely(nft_set_elem_expired(e) ||
+				     !nft_set_elem_active(e, genmask)))
 				goto next_match;
-			}
 
+			ext = e;
 			goto out;
 		}
 
-- 
2.50.1

