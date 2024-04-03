Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 152C9156655
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Apr 2024 21:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712178827; cv=none; b=qnsyQU6dvAZwarVTLYuuXE0/xe9v+dBD1mcpiAouYldKg7EY3takpbA9Dibno5PCt18l54wotZAIfr/Heli3vtuAzVcCLAW2gKqUElbBWzd2ooFu3FKEhN5vHJV4BUWvOuj018+8fd8fABGCjkoYgBne8B0+0CyBL2Pu3t9GC00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712178827; c=relaxed/simple;
	bh=31TcPkjQL622qbKE5kav369a3C34Fy2UYSgDEvtKZ8A=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=Ry5+BosrfVA2ikBf/tOJdsFjZJW2VIy0YAMSXY9e/8Jyq+OE/E9Aw7NJ22wYkobxu7ecUcKBwLYNi+TmKgeryXzxUlmnvkEmzrKcVIeehnIs9m9Cj1PT3PUNByZVK2djvhyYJTWgm/XiKrlb9rIKMegP+R3ncTh3xadeyCuNdBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nf_tables: discard table flag update with pending basechain deletion
Date: Wed,  3 Apr 2024 23:03:40 +0200
Message-Id: <20240403210340.478255-1-pablo@netfilter.org>
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
More narrowing down for the dormant flag to fix issues as suggested by Florian.

 net/netfilter/nf_tables_api.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8fd9eb96408d..dce3c612d8da 100644
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
+		      nft_is_base_chain(nft_trans_chain(trans)))))
 			return true;
 	}
 
-- 
2.30.2

