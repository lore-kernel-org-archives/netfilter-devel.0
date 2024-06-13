Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D12143866;
	Thu, 13 Jun 2024 11:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279166; cv=none; b=XZrS4Fl19fEXVovGMBGx5/zU/g7M4M7XnHc27J4vZv6KfsCXuDnJWmceb9ku6Jb2pY5PlcwOxL57tGn22WGu9snAPmeBHIDaCBDnPEllpsPgoJMegTpHg33pSw1iavZQqU6zcY8Pkcc9wLVItRJXkvJngNkGPUgYhfxeiUHobzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279166; c=relaxed/simple;
	bh=CN0+qHWgPq6QsZ3DJ3v7WeUUd+oKP9vfbcSyX1FBq3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XwB7ce7FKIsVQec2hu/nXqZ/DTlQbNPwrtnfqb9HHHOkzJaZ/BSzygJJ0XBIsgd3Dygznqr4mXi2CCD01SeiV0bNzSLmIiNf45GYDxy6lZhSafxjsg0y/Yb/lgQtLfG1RQDBadGAaFajvKSNxrWaCX5WEz14YqVEv4L4eFz45Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VpCdDVxq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VpCdDVxq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0AC9C2BBFC;
	Thu, 13 Jun 2024 11:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279166;
	bh=CN0+qHWgPq6QsZ3DJ3v7WeUUd+oKP9vfbcSyX1FBq3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VpCdDVxqmXGDPhI9jAjwZgqL3o8PdZo1Cp1hL9l7apAiTujMvBKq6ECBKyN34Y7X9
	 xLffmljPB83QjjqbEmxrD1RHkm6UcyUw/HdZOTBhNKjbBfUpfmejnZ3ItqvN14kZTm
	 mslUWxgwwekRZzImBJATwF+FoIf+2uVHJy6VR0q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 198/213] netfilter: nf_tables: discard table flag update with pending basechain deletion
Date: Thu, 13 Jun 2024 13:34:06 +0200
Message-ID: <20240613113235.615589176@linuxfoundation.org>
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

commit 1bc83a019bbe268be3526406245ec28c2458a518 upstream.

Hook unregistration is deferred to the commit phase, same occurs with
hook updates triggered by the table dormant flag. When both commands are
combined, this results in deleting a basechain while leaving its hook
still registered in the core.

Fixes: 179d9ba5559a ("netfilter: nf_tables: fix table flag updates")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -877,6 +877,24 @@ static void nf_tables_table_disable(stru
 #define __NFT_TABLE_F_UPDATE		(__NFT_TABLE_F_WAS_DORMANT | \
 					 __NFT_TABLE_F_WAS_AWAKEN)
 
+static bool nft_table_pending_update(const struct nft_ctx *ctx)
+{
+	struct nftables_pernet *nft_net = net_generic(ctx->net, nf_tables_net_id);
+	struct nft_trans *trans;
+
+	if (ctx->table->flags & __NFT_TABLE_F_UPDATE)
+		return true;
+
+	list_for_each_entry(trans, &nft_net->commit_list, list) {
+		if (trans->ctx.table == ctx->table &&
+		    trans->msg_type == NFT_MSG_DELCHAIN &&
+		    nft_is_base_chain(trans->ctx.chain))
+			return true;
+	}
+
+	return false;
+}
+
 static int nf_tables_updtable(struct nft_ctx *ctx)
 {
 	struct nft_trans *trans;
@@ -894,7 +912,7 @@ static int nf_tables_updtable(struct nft
 		return 0;
 
 	/* No dormant off/on/off/on games in single transaction */
-	if (ctx->table->flags & __NFT_TABLE_F_UPDATE)
+	if (nft_table_pending_update(ctx))
 		return -EINVAL;
 
 	trans = nft_trans_alloc(ctx, NFT_MSG_NEWTABLE,


