Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE613306F;
	Fri, 24 Nov 2023 19:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QvTn3kjd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF65DC433C7;
	Fri, 24 Nov 2023 19:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700854047;
	bh=wKu62tLRv5jmcPT8IRNnGR4od+TQvZA+ZhFn9QRY1OE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QvTn3kjdRWy52/ujo2NRhVqboK3OaUeOtACCtu/XtS9fCsPO6yQaPbFksnXrNKg4x
	 4BzAohf1+3wDIaXo6DEs34tuDWpWIG0DyXEVgN6Lul9BH/FVE3EuLWqdleJs0QDB0D
	 fSh4W9oDPxQtqk19AxqFNLd01JOGxxn8EzVk1g84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 135/159] netfilter: nftables: rename set element data activation/deactivation functions
Date: Fri, 24 Nov 2023 17:55:52 +0000
Message-ID: <20231124171947.423527943@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171941.909624388@linuxfoundation.org>
References: <20231124171941.909624388@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4602,8 +4602,8 @@ void nft_set_elem_destroy(const struct n
 }
 EXPORT_SYMBOL_GPL(nft_set_elem_destroy);
 
-/* Only called from commit path, nft_set_elem_deactivate() already deals with
- * the refcounting from the preparation phase.
+/* Only called from commit path, nft_setelem_data_deactivate() already deals
+ * with the refcounting from the preparation phase.
  */
 static void nf_tables_set_elem_destroy(const struct nft_ctx *ctx,
 				       const struct nft_set *set, void *elem)
@@ -4919,9 +4919,9 @@ void nft_data_hold(const struct nft_data
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
 
@@ -4931,9 +4931,9 @@ static void nft_set_elem_activate(const
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
 
@@ -5000,7 +5000,7 @@ static int nft_del_setelem(struct nft_ct
 	kfree(elem.priv);
 	elem.priv = priv;
 
-	nft_set_elem_deactivate(ctx->net, set, &elem);
+	nft_setelem_data_deactivate(ctx->net, set, &elem);
 
 	nft_trans_elem(trans) = elem;
 	nft_trans_commit_list_add_tail(ctx->net, trans);
@@ -5034,7 +5034,7 @@ static int nft_flush_set(const struct nf
 	}
 	set->ndeact++;
 
-	nft_set_elem_deactivate(ctx->net, set, elem);
+	nft_setelem_data_deactivate(ctx->net, set, elem);
 	nft_trans_elem_set(trans) = set;
 	nft_trans_elem(trans) = *elem;
 	nft_trans_commit_list_add_tail(ctx->net, trans);
@@ -7277,7 +7277,7 @@ static int __nf_tables_abort(struct net
 		case NFT_MSG_DELSETELEM:
 			te = (struct nft_trans_elem *)trans->data;
 
-			nft_set_elem_activate(net, te->set, &te->elem);
+			nft_setelem_data_activate(net, te->set, &te->elem);
 			te->set->ops->activate(net, te->set, &te->elem);
 			te->set->ndeact--;
 


