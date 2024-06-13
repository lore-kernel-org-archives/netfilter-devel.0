Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDF96AFAE;
	Thu, 13 Jun 2024 11:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279053; cv=none; b=Rdsu5eGhi0mfSPjZehbK+JpBn7C/QqSVFa609DBkdyLCUTmeU2/uUUpWqx9Wj4mXdJvTJyW5aSEQ04v4AK1bkt6dOJ9kOTUsKcgvhHiov2HoqPpMTpWvDn9TGqe/YK5bztvSME2V1eLmtw+fvIzyonqZto3M5OOclOz/wQdokeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279053; c=relaxed/simple;
	bh=aeHYQVNUMxr6Lh5cv6hUrFIMgv2nBF5Zm/HpyNTmiXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gh5koGaMbH9M2BvBoWKQODBr43YNif5G4U17NTahGqHCDCyxbbqk3UxaEQFw5XloVcFenmFxFb/9ZCsGxqzzdjtxn/2qrvafJw20y+Xf9vn35vWJaQ4/jnRoQZL+meo5nTVpfoYIun5BLkvnMhLDi6LBdBoTeLfd9LSTgjUimdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jLgNnY5W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jLgNnY5W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B45FC2BBFC;
	Thu, 13 Jun 2024 11:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279052;
	bh=aeHYQVNUMxr6Lh5cv6hUrFIMgv2nBF5Zm/HpyNTmiXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jLgNnY5WOogV02j5U+zmFkqNb5cR/nhhhVLkO/71iovlZZhsMu1Qj+XjviHIwST4o
	 6HPs9iz9suhEcgEWnwUw92erQMqs0hva//fRH31G+VA3uDqrVKrQThIHtWgMSpcqsc
	 ELd/eoLBCzTi1KBiHLmjv2P5Wcwzwu1pAkv4iYRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 160/213] netfilter: nftables: rename set element data activation/deactivation functions
Date: Thu, 13 Jun 2024 13:33:28 +0200
Message-ID: <20240613113234.159451615@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit f8bb7889af58d8e74d2d61c76b1418230f1610fa upstream.

Rename:

- nft_set_elem_activate() to nft_set_elem_data_activate().
- nft_set_elem_deactivate() to nft_set_elem_data_deactivate().

To prepare for updates in the set element infrastructure to add support
for the special catch-all element.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4501,8 +4501,8 @@ void nft_set_elem_destroy(const struct n
 }
 EXPORT_SYMBOL_GPL(nft_set_elem_destroy);
 
-/* Only called from commit path, nft_set_elem_deactivate() already deals with
- * the refcounting from the preparation phase.
+/* Only called from commit path, nft_setelem_data_deactivate() already deals
+ * with the refcounting from the preparation phase.
  */
 static void nf_tables_set_elem_destroy(const struct nft_ctx *ctx,
 				       const struct nft_set *set, void *elem)
@@ -4806,9 +4806,9 @@ void nft_data_hold(const struct nft_data
 	}
 }
 
-static void nft_set_elem_activate(const struct net *net,
-				  const struct nft_set *set,
-				  struct nft_set_elem *elem)
+static void nft_setelem_data_activate(const struct net *net,
+				      const struct nft_set *set,
+				      struct nft_set_elem *elem)
 {
 	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
 
@@ -4818,9 +4818,9 @@ static void nft_set_elem_activate(const
 		nft_use_inc_restore(&(*nft_set_ext_obj(ext))->use);
 }
 
-static void nft_set_elem_deactivate(const struct net *net,
-				    const struct nft_set *set,
-				    struct nft_set_elem *elem)
+static void nft_setelem_data_deactivate(const struct net *net,
+					const struct nft_set *set,
+					struct nft_set_elem *elem)
 {
 	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
 
@@ -4887,7 +4887,7 @@ static int nft_del_setelem(struct nft_ct
 	kfree(elem.priv);
 	elem.priv = priv;
 
-	nft_set_elem_deactivate(ctx->net, set, &elem);
+	nft_setelem_data_deactivate(ctx->net, set, &elem);
 
 	nft_trans_elem(trans) = elem;
 	nft_trans_commit_list_add_tail(ctx->net, trans);
@@ -4921,7 +4921,7 @@ static int nft_flush_set(const struct nf
 	}
 	set->ndeact++;
 
-	nft_set_elem_deactivate(ctx->net, set, elem);
+	nft_setelem_data_deactivate(ctx->net, set, elem);
 	nft_trans_elem_set(trans) = set;
 	nft_trans_elem(trans) = *elem;
 	nft_trans_commit_list_add_tail(ctx->net, trans);
@@ -6954,7 +6954,7 @@ static int __nf_tables_abort(struct net
 		case NFT_MSG_DELSETELEM:
 			te = (struct nft_trans_elem *)trans->data;
 
-			nft_set_elem_activate(net, te->set, &te->elem);
+			nft_setelem_data_activate(net, te->set, &te->elem);
 			te->set->ops->activate(net, te->set, &te->elem);
 			te->set->ndeact--;
 


