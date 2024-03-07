Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC5882D7F
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Mar 2024 08:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709801200; cv=none; b=XyeT+E7PwbchuvZScu2v12JzLOqsZ8D85HVmYy+InwGPeiCvH/1KLa+HuMWiUHSBKP+IrxJ0DrLIYSiE4zSx6GBeIRyejvmEDDYZ5WZuq2oXbxkKViCDjcJTBVZtvR660u0JH+pkzq7iyW7q67nGNEf1iGW+ZFmYaugpKwLYAwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709801200; c=relaxed/simple;
	bh=6H+hbhNqLu6rxOoEvhLXLQIrPHM1WpTTV2Onh/ILzcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BanBRgyEAvSZFvtwvyC8IWl/W/DW0OGGiL/snE0fZkwc8frYfyl92DkhYLPB9Gu6Yhr94Cc9uY6u0UhwJNPCV8Q2L3sanHdO75mjDUWp59cM/9X2ehvrtQbsH9G60lhQ9ubSyT1IlNHieSm/YNSsTZa/tUWJB26F+hOk5+65+lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1ri9Of-0005Km-00; Thu, 07 Mar 2024 09:46:37 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 3/9] netfilter: nf_tables: add lockdep assertion for chain use counter
Date: Thu,  7 Mar 2024 09:40:07 +0100
Message-ID: <20240307084018.2219-4-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240307084018.2219-1-fw@strlen.de>
References: <20240307084018.2219-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nft_set_elem_destroy() callers need to hold the transaction mutex
for maps holding chain or object references.

This helper is also called from the nft_dynset error path,
without mutex.

nft_dynset doesn't support verdict or objref maps, however.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index bac5847a5499..d6448d6e9a18 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6404,7 +6404,19 @@ static void nft_set_elem_expr_destroy(const struct nft_ctx *ctx,
 		__nft_set_elem_expr_destroy(ctx, expr);
 }
 
-/* Drop references and destroy. Called from gc, dynset and abort path. */
+/**
+ * nft_set_elem_destroy - free a set element instantly
+ * @set: the set the element was supposed to be added to
+ * @elem: the private element pointer to be free'd
+ * @destroy_expr: true if embedded expression was initialised before
+ *
+ * Immediately releases an element without going through any synchronization.
+ * This function can only be used for error unwinding BEFORE the element was
+ * added to the set, else concurrent data path access may result in
+ * use-after-free.
+ * For datapath error unwinding, jumps-to-chain or objref are
+ * not supported.
+ */
 void nft_set_elem_destroy(const struct nft_set *set,
 			  const struct nft_elem_priv *elem_priv,
 			  bool destroy_expr)
@@ -6415,6 +6427,13 @@ void nft_set_elem_destroy(const struct nft_set *set,
 		.family	= set->table->family,
 	};
 
+	/* We can only do error unwind for vmaps or objref types
+	 * if the caller is holding the transaction mutex.
+	 */
+	if (set->dtype == NFT_DATA_VERDICT ||
+	    nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF))
+		WARN_ON_ONCE(!lockdep_commit_lock_is_held(read_pnet(&set->net)));
+
 	nft_data_release(nft_set_ext_key(ext), NFT_DATA_VALUE);
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA))
 		nft_data_release(nft_set_ext_data(ext), set->dtype);
-- 
2.43.0

