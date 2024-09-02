Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C208F13DB88
	for <netfilter-devel@vger.kernel.org>; Mon,  2 Sep 2024 23:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725319432; cv=none; b=GArZnm346Tu/EQd0aqwVwIvkzXHWRMSciCkNL9VQBFWpkUhbduB9J2/CN3pv2RblQbevYfh3qJvWZzw1ds3zpkdIuqZIpqSNuugnegD0xMAzA/L6KuzbFqQxXo1ngHIooQlBXHCZBsXOoGY26lSf5WhDFVX+fCzM2gCYNeEG9jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725319432; c=relaxed/simple;
	bh=KPHVOKL1Yq8vGv57OjoAxWybCExgJfLtjPGxU6DCXCA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UV05SFy/7trpGqszE63aBU7I+R1I230Jfszhj+7P/GbTsk66r2PiRWKnOZoNRvG/BnCaIpa7CRvktFC8Qg+Z5VjSSFTYbHx9+UCzMDySJvEznhlQreJXAm1eF/uCWqMFJWE41XGVFT9e22bPYV9XWliNXU66Tf6IeLdau4jSf9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: phil@nwl.cc,
	fw@strlen.de
Subject: [PATCH nf-next,v2 4/9] netfilter: nf_tables: remove annotation to access set timeout while holding lock
Date: Tue,  3 Sep 2024 01:17:21 +0200
Message-Id: <20240902231726.171964-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240902231726.171964-1-pablo@netfilter.org>
References: <20240902231726.171964-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Mutex is held when adding an element, no need for READ_ONCE, remove it.

Fixes: 123b99619cca ("netfilter: nf_tables: honor set timeout and garbage collection updates")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes.

 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 684dff68b2c3..f183a82cc3c1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6910,7 +6910,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			return err;
 	} else if (set->flags & NFT_SET_TIMEOUT &&
 		   !(flags & NFT_SET_ELEM_INTERVAL_END)) {
-		timeout = READ_ONCE(set->timeout);
+		timeout = set->timeout;
 	}
 
 	expiration = 0;
@@ -7017,7 +7017,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		if (err < 0)
 			goto err_parse_key_end;
 
-		if (timeout != READ_ONCE(set->timeout)) {
+		if (timeout != set->timeout) {
 			err = nft_set_ext_add(&tmpl, NFT_SET_EXT_TIMEOUT);
 			if (err < 0)
 				goto err_parse_key_end;
-- 
2.30.2

