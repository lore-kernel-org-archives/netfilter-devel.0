Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187A6143867;
	Thu, 13 Jun 2024 11:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279050; cv=none; b=RNrrPQOKozTd/A+xDqck6ZnesaQYqcRHQNhJxy6mZdtU5+LkYKARMmu1bTGF9jqHzAmO1fpf56mSyHq5qGa9F95YGCUMhNrtc455gXCzySN+rBXu6qfIaKzfJ0F7eEAqFZhyzuxczqoA9TBdJYK+C6Pzm2ODWIMSA2k+rxRc3Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279050; c=relaxed/simple;
	bh=Gr9vYNS+GuJaU9GReXpvF0X61Ws7GWNwz8YNfd70SZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F6TS4l4sWXqUP+gSb9lXOKaWHLV80ezlC8VIsvWBkLZjlgwnKNIQHjHig9ZaeLGZ/4vUngpokKzMeKqTgH2ASp5HkUuNhDTZWt5OESbaXxYItLPXHtkBWY91YFFDnlVlXsE00xtCs7wdNePvOJ2Xm9VX/SpJltHGkkZ/vlmptbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P2levDCj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P2levDCj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD85C2BBFC;
	Thu, 13 Jun 2024 11:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279050;
	bh=Gr9vYNS+GuJaU9GReXpvF0X61Ws7GWNwz8YNfd70SZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P2levDCjGPKI9oAPT53CjjWKXQ6RQvUgUr/T6/IEJ6giWpmVBg0bEsleNeJLgY2Ah
	 B+ggwnPfdtyWbGbzBM2wHD1Ow1LvbIst9cpE+1vJC5k7UJdo4fOr3AIVcvTkjmWAjW
	 j1o1TdwUFl1/tZ8Sa+xQ8ELNkUsWPs79PnOUAHFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 159/213] netfilter: nf_tables: pass context to nft_set_destroy()
Date: Thu, 13 Jun 2024 13:33:27 +0200
Message-ID: <20240613113234.121470444@linuxfoundation.org>
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

commit 0c2a85edd143162b3a698f31e94bf8cdc041da87 upstream.

The patch that adds support for stateful expressions in set definitions
require this.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3753,7 +3753,7 @@ err1:
 	return err;
 }
 
-static void nft_set_destroy(struct nft_set *set)
+static void nft_set_destroy(const struct nft_ctx *ctx, struct nft_set *set)
 {
 	if (WARN_ON(set->use > 0))
 		return;
@@ -3926,7 +3926,7 @@ EXPORT_SYMBOL_GPL(nf_tables_deactivate_s
 void nf_tables_destroy_set(const struct nft_ctx *ctx, struct nft_set *set)
 {
 	if (list_empty(&set->bindings) && nft_set_is_anonymous(set))
-		nft_set_destroy(set);
+		nft_set_destroy(ctx, set);
 }
 EXPORT_SYMBOL_GPL(nf_tables_destroy_set);
 
@@ -6503,7 +6503,7 @@ static void nft_commit_release(struct nf
 		nf_tables_rule_destroy(&trans->ctx, nft_trans_rule(trans));
 		break;
 	case NFT_MSG_DELSET:
-		nft_set_destroy(nft_trans_set(trans));
+		nft_set_destroy(&trans->ctx, nft_trans_set(trans));
 		break;
 	case NFT_MSG_DELSETELEM:
 		nf_tables_set_elem_destroy(&trans->ctx,
@@ -6857,7 +6857,7 @@ static void nf_tables_abort_release(stru
 		nf_tables_rule_destroy(&trans->ctx, nft_trans_rule(trans));
 		break;
 	case NFT_MSG_NEWSET:
-		nft_set_destroy(nft_trans_set(trans));
+		nft_set_destroy(&trans->ctx, nft_trans_set(trans));
 		break;
 	case NFT_MSG_NEWSETELEM:
 		nft_set_elem_destroy(nft_trans_elem_set(trans),
@@ -7604,7 +7604,7 @@ static void __nft_release_table(struct n
 	list_for_each_entry_safe(set, ns, &table->sets, list) {
 		list_del(&set->list);
 		nft_use_dec(&table->use);
-		nft_set_destroy(set);
+		nft_set_destroy(&ctx, set);
 	}
 	list_for_each_entry_safe(obj, ne, &table->objects, list) {
 		list_del(&obj->list);


