Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6981413E233
	for <netfilter-devel@vger.kernel.org>; Fri,  2 Feb 2024 12:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706875594; cv=none; b=pdb+CiuFsJaJVVIMV7FhYD+GlzAdK7GVuCTkpfyXgBLQ7xKg2XDASe0gOuSqUPELRdeTCx8GPeA1bycAkuUTS2HAdd9BUPhT61ShGbxrztZ0nBRqzgKBTXAWCBaT2h+EXHghuqciBLUzwOGO2e10eu2rdoH57GKdw6YgHXfORzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706875594; c=relaxed/simple;
	bh=JGqMyZn5PUS5Jyme6daszsMDNgGgUpdJmxZYXdcblb0=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=TicWT2EhSI/GetOCUgUvhz3Lw5iUZQsCN5N4SE6psV9AajXSV753mr8TW/DaV7NBn6rQfmEJ+vw3vB0PuVP0Mus59dXlb9ZAxl+h5GamzkCCNKnXvi5kuZzZYjYJ1SyUR9FGH1Rs393GfgXQPE8l1911mVS9C2HT+0ea9d1Ta8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nft_compat: narrow down revision to unsigned 8-bits
Date: Fri,  2 Feb 2024 13:06:27 +0100
Message-Id: <20240202120627.5190-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xt_find_revision() expects u8, restrict it to this datatype.

Fixes: 0ca743a55991 ("netfilter: nf_tables: add compatibility layer for x_tables")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_compat.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index f0eeda97bfcd..001b6841a4b6 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -135,7 +135,7 @@ static void nft_target_eval_bridge(const struct nft_expr *expr,
 
 static const struct nla_policy nft_target_policy[NFTA_TARGET_MAX + 1] = {
 	[NFTA_TARGET_NAME]	= { .type = NLA_NUL_STRING },
-	[NFTA_TARGET_REV]	= { .type = NLA_U32 },
+	[NFTA_TARGET_REV]	= NLA_POLICY_MAX(NLA_BE32, 255),
 	[NFTA_TARGET_INFO]	= { .type = NLA_BINARY },
 };
 
@@ -419,7 +419,7 @@ static void nft_match_eval(const struct nft_expr *expr,
 
 static const struct nla_policy nft_match_policy[NFTA_MATCH_MAX + 1] = {
 	[NFTA_MATCH_NAME]	= { .type = NLA_NUL_STRING },
-	[NFTA_MATCH_REV]	= { .type = NLA_U32 },
+	[NFTA_MATCH_REV]	= NLA_POLICY_MAX(NLA_BE32, 255),
 	[NFTA_MATCH_INFO]	= { .type = NLA_BINARY },
 };
 
@@ -724,7 +724,7 @@ static int nfnl_compat_get_rcu(struct sk_buff *skb,
 static const struct nla_policy nfnl_compat_policy_get[NFTA_COMPAT_MAX+1] = {
 	[NFTA_COMPAT_NAME]	= { .type = NLA_NUL_STRING,
 				    .len = NFT_COMPAT_NAME_MAX-1 },
-	[NFTA_COMPAT_REV]	= { .type = NLA_U32 },
+	[NFTA_COMPAT_REV]	= NLA_POLICY_MAX(NLA_BE32, 255),
 	[NFTA_COMPAT_TYPE]	= { .type = NLA_U32 },
 };
 
-- 
2.30.2

