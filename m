Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61F8973178
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Mar 2024 20:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710447377; cv=none; b=PXdnZXNC+PUMUgNChJEjyTrxd0eeBTwTNKRjcxVfaJTvOlXrErZuj6JbxrWGCs8Tdhx3oURN2cAQN9h4trSgJXU834+OjL/8Sps3Zy+P5bK8+lQ+VPJz1vWH+k5ujvSdhHjp7NbJQfXOQpiu58jo6hznyAQwwoJnB/a5nilvtxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710447377; c=relaxed/simple;
	bh=bA7JmZBCKNGKkyECEMBVkLTDzfLq1c7W5lOyl/Ru89M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CceU208ZoORX8gm+qWksWGyzR1vhpa3bh5nwnTLvuKyrazBvcoVfioQvMFUgbLh0Z5B4JpZqrKJaID1FHJQ+wibDPbs2dFHGKqMqc+Dih8idzitk6a2YHRr/nuy1jE83k1XWpqMDzCcHbaN3OrUVQgxiqgmRod7DXYVLSbmQMy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	tianquan23@gmail.com
Subject: [PATCH nf] netfilter: nf_tables: do not compare internal table flags on updates
Date: Thu, 14 Mar 2024 21:16:02 +0100
Message-Id: <20240314201602.5137-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Restore skipping transaction if table update does not modify flags.

Fixes: 179d9ba5559a ("netfilter: nf_tables: fix table flag updates")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
This restores:

nft -f -<<EOF
add table ip t { flags dormant ; }
EOF

nft -f -<<EOF
add table ip t
add chain ip t c1 { type filter hook input priority 1; }
add table ip t
add chain ip t c2 { type filter hook input priority 2; }
EOF

after c9bd26513b3a ("netfilter: nf_tables: disable toggling dormant
table state more than once") which IMO is not the real issue.

This provides an alternative fix for:
[PATCH nf] netfilter: nf_tables: fix consistent table updates being rejected

 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index fb319a3cd923..2d8828dbe980 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1211,7 +1211,7 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 	if (flags & ~NFT_TABLE_F_MASK)
 		return -EOPNOTSUPP;
 
-	if (flags == ctx->table->flags)
+	if (flags == (ctx->table->flags & NFT_TABLE_F_MASK))
 		return 0;
 
 	if ((nft_table_has_owner(ctx->table) &&
-- 
2.30.2

