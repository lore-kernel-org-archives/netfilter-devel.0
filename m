Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0AA615689E
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Apr 2024 23:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712185862; cv=none; b=WZraILZygwNNyxOjmcIEIhg7uuwgyonZ9zXB4zOef5TK14iC/WGSEYQHXQD8BwT3KcqzKzeKWQ2YPiQ2BBgLnxQ5y87gP/IfGTD3NYQyXiMkxSBuxl8H9o3GK9IgAZxHjlFhi1ygs0vTE97wIOtgSwxCAldSD6bOclHmqQepJxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712185862; c=relaxed/simple;
	bh=e0XuhykxpVaQPPKm7q/HWgyN/JJhjYSdnHCsbkR2Mec=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=BX7q3WEKnh2Tb5J8z+v2eqaOsPEXc7bzhdbwlqjRBE424QbD1L6fnD1mFhlbfP1bTVU40NGMm9FyZ6w33un050vLaSldo3Wxe76J1nK5aJ0IuL7fBBItyymIIuC3QKbau9FfVgpa44A2bhESiwGfRjGuyaxxd7RRmL3v1HWt68k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v2] netfilter: nf_tables: discard table flag update with pending basechain deletion
Date: Thu,  4 Apr 2024 01:10:53 +0200
Message-Id: <20240403231053.2387-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hook unregistration is deferred to the commit phase, same occurs with
hook updates triggered by the table dormant flag. When both commands are
combined, this results in deleting a basechain while leaving its hook
still registered in the core.

Fixes: 179d9ba5559a ("netfilter: nf_tables: fix table flag updates")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: nft_trans_chain() is not set by nf_tables_updtable() with NFT_MSG_DELCHAIN,
    use trans->ctx.chain instead otherwise null-ptr dereference is possible.

 net/netfilter/nf_tables_api.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8fd9eb96408d..aee02a1cfa82 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1210,10 +1210,11 @@ static bool nft_table_pending_update(const struct nft_ctx *ctx)
 		return true;
 
 	list_for_each_entry(trans, &nft_net->commit_list, list) {
-		if ((trans->msg_type == NFT_MSG_NEWCHAIN ||
-		     trans->msg_type == NFT_MSG_DELCHAIN) &&
-		    trans->ctx.table == ctx->table &&
-		    nft_trans_chain_update(trans))
+		if (trans->ctx.table == ctx->table &&
+		    ((trans->msg_type == NFT_MSG_NEWCHAIN &&
+		      nft_trans_chain_update(trans)) ||
+		     (trans->msg_type == NFT_MSG_DELCHAIN &&
+		      nft_is_base_chain(trans->ctx.chain))))
 			return true;
 	}
 
-- 
2.30.2

