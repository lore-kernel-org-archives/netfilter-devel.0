Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8203B18755C
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Nov 2024 08:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730966553; cv=none; b=Q8VRfjQOUQPzsstcRNy6Cz4hMtblo/0yVNqxCOILJzwp2GUt6cCoQfkYT22SQvpRGfrC6ObrahlDcehXBuy1qgPCoZ85IwUNCjo5TuBNSqVMKHHqzaUe1C+dVbh/2g4Vfel4DrbC0K1TMlHPjdeD2nN/g66jVxaiofLfNODfxbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730966553; c=relaxed/simple;
	bh=BrhPIX/rL5Qq5oxhJj5j03aEHr+svO2S8KLcmO9x2GQ=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=NUbUbrxvszTyyjbQCpCGzvMklRxmOSuMyFpWqFAvpFVKe4Cds6AEwZQ6xobyYU5CfMBNDDGbfFoBnIg8+9ZvYlXuocpbFXh+2HVGzs9mp4kfEpWAMsdt31gOyyhcWBgpw64v8XWKkbhi0Ywg1wxmwQk0AQ5hOgkuum1WIiKx2JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] mnl: restore --debug=netlink output with chains
Date: Thu,  7 Nov 2024 09:02:18 +0100
Message-Id: <20241107080218.3177-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

table and chain name are not displayed with --debug=netlink:

 # nft --debug=netlink -f /tmp/x
 inet (null) (null) use 0
 ...

Similar to 79acbfdbe536 ("mnl: restore --debug=netlink output with sets").

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mnl.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/src/mnl.c b/src/mnl.c
index 12a6345cbed8..45d63c94afdf 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -835,8 +835,16 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
 			nftnl_udata_buf_free(udbuf);
 		}
 	}
+
+
+	nftnl_chain_set_str(nlc, NFTNL_CHAIN_TABLE, cmd->handle.table.name);
+	nftnl_chain_set_str(nlc, NFTNL_CHAIN_NAME, cmd->handle.chain.name);
+
 	netlink_dump_chain(nlc, ctx);
 
+	nftnl_chain_unset(nlc, NFTNL_CHAIN_TABLE);
+	nftnl_chain_unset(nlc, NFTNL_CHAIN_NAME);
+
 	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(ctx->batch),
 				    NFT_MSG_NEWCHAIN,
 				    cmd->handle.family,
-- 
2.30.2

