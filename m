Received: from n169-110.mail.139.com (n169-110.mail.139.com [120.232.169.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23BAF3B19D9;
	Tue, 19 May 2026 07:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779177320; cv=none; b=XA7pIZJau/Yak2fPmDVnwXL2HS6FNRA/MvCY/xAGVDEInuwHvK1aD6/PIgGgS+3ByQXr+TTqIH/BeOvkJ0OpBNLzNCwhfWHzT+CDA6THbymTv5V/DRRYcXSna+zMLaP+oTrkWTBRatRUKzk6XlH1t4ncFcDuKxn0NDMVGNqW9PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779177320; c=relaxed/simple;
	bh=tDuDIK3V3CGm8L/unmZRnnQnobIt9tRlnUeRADbdy2s=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cltqXW6L6V58Ue6xS4zqbKDxOuif3Ldytphfgv4ZiVSuhidpqyDmmDFF3mMhHwkDU4XLGWZL8L9nIeDxOs+Jpq3r+p8zroR/zDXhXS1vGNvD1l850Ehuq0zqiSKwyz0cpbkHEs5eIYQS5+Hb2qk4nQbAn2lEQ91ofpq5eU8pR/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=mFoonKzu; arc=none smtp.client-ip=120.232.169.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="mFoonKzu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=mFoonKzuehcIcBc2VCeG++kZwtLT213ZfUdKMu+GK+fh/onrUFhHwxce1rTiIazej5NJ11by82cko
	 geOHrZ5ntX6+PTDMtNXkrdIYIHs1gkPY4sF8aC87UwWPQUbN8dW7KnWPSbiXhIVDC8lvQRkP8PRDIp
	 NnZWuLjBGG271j6Q=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from NTT-kernel-dev (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-09-12087 (RichMail) with SMTP id 2f376a0c1757369-033a8;
	Tue, 19 May 2026 15:55:05 +0800 (CST)
X-RM-TRANSID:2f376a0c1757369-033a8
From: Li hongliang <1468888505@139.com>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	pablo@netfilter.org
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kadlec@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	y0un9sa@gmail.com,
	fw@strlen.de
Subject: [PATCH 6.12.y] netfilter: nf_tables: unconditionally bump set->nelems before insertion
Date: Tue, 19 May 2026 15:55:04 +0800
Message-Id: <20260519075504.2064229-1-1468888505@139.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit def602e498a4f951da95c95b1b8ce8ae68aa733a ]

In case that the set is full, a new element gets published then removed
without waiting for the RCU grace period, while RCU reader can be
walking over it already.

To address this issue, add the element transaction even if set is full,
but toggle the set_full flag to report -ENFILE so the abort path safely
unwinds the set to its previous state.

As for element updates, decrement set->nelems to restore it.

A simpler fix is to call synchronize_rcu() in the error path.
However, with a large batch adding elements to already maxed-out set,
this could cause noticeable slowdown of such batches.

Fixes: 35d0ac9070ef ("netfilter: nf_tables: fix set->nelems counting with no NLM_F_EXCL")
Reported-by: Inseo An <y0un9sa@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
[ Minor conflict resolved. ]
Signed-off-by: Li hongliang <1468888505@139.com>
---
 net/netfilter/nf_tables_api.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index e373afdf0f07..838c9f49e4e0 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6981,6 +6981,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	enum nft_registers dreg;
 	struct nft_trans *trans;
 	u8 update_flags;
+	bool set_full = false;
 	u64 expiration;
 	u64 timeout;
 	int err, i;
@@ -7267,10 +7268,18 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
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
@@ -7312,7 +7321,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 						nft_trans_elem_priv(trans) = elem_priv;
 						nft_trans_elem_update_flags(trans) = update_flags;
 						nft_trans_commit_list_add_tail(ctx->net, trans);
-						goto err_elem_free;
+						goto err_set_size;
 					}
 				}
 			}
@@ -7330,23 +7339,16 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
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
 	nft_trans_elem_priv(trans) = elem.priv;
 	nft_trans_commit_list_add_tail(ctx->net, trans);
-	return 0;
 
-err_set_full:
-	nft_setelem_remove(ctx->net, set, elem.priv);
+	return set_full ? -ENFILE : 0;
+
 err_element_clash:
 	kfree(trans);
+err_set_size:
+	if (!(flags & NFT_SET_ELEM_CATCHALL))
+		atomic_dec(&set->nelems);
 err_elem_free:
 	nf_tables_set_elem_destroy(ctx, set, elem.priv);
 err_parse_data:
-- 
2.34.1


