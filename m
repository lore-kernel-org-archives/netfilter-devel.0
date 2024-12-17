Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36D231DD0C7
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Dec 2024 21:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734470130; cv=none; b=VCVUZ3eufyYee56h1irjWmFi8820DwXB8GBUYYsiVAA6miIPd8NFs/IYEDppjz8lks5wUhM1nXM02R+nJBIGFLGk/ikwvfPMbZQEh57CaKS1KfQSOl1HLzQu6xmeq9NigMx4V6aAIVCeDzDVFyw0M2LuywVQfk2QaueECAiLW2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734470130; c=relaxed/simple;
	bh=nTcdr8XEYXahW9MEKbBnQZtqQiQ7P9/MwmO4AoucH0U=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Y8hLCECFOWIRkruWEolaZJRd5XRS1C5afrhKLzfgEpaHM1Xefe/k9rDajJSaB3WRJ+9gzAtCmcQ10VlqUSRFO7zYYo3XevF0CrPXolG58gQaDJwki1HcvGv7j5TXfWUy5ZvvabCR2dI99Uc5xgRxNpD88FmJDj8g9hRk6BNlYm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 5/6] mnl: rename list of expression in mnl_nft_setelem_batch()
Date: Tue, 17 Dec 2024 22:15:15 +0100
Message-Id: <20241217211516.1644623-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20241217211516.1644623-1-pablo@netfilter.org>
References: <20241217211516.1644623-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rename set to init to prepare to pass struct set to this function in
the follow up patch. No functional changes are intended.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mnl.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index 88fac5bd0393..52085d6d960a 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1731,7 +1731,7 @@ static int mnl_nft_setelem_batch(const struct nftnl_set *nls, struct cmd *cmd,
 				 struct nftnl_batch *batch,
 				 enum nf_tables_msg_types msg_type,
 				 unsigned int flags, uint32_t *seqnum,
-				 const struct expr *set,
+				 const struct expr *init,
 				 struct netlink_ctx *ctx)
 {
 	struct nlattr *nest1, *nest2;
@@ -1743,8 +1743,8 @@ static int mnl_nft_setelem_batch(const struct nftnl_set *nls, struct cmd *cmd,
 	if (msg_type == NFT_MSG_NEWSETELEM)
 		flags |= NLM_F_CREATE;
 
-	if (set)
-		expr = list_first_entry(&set->expressions, struct expr, list);
+	if (init)
+		expr = list_first_entry(&init->expressions, struct expr, list);
 
 next:
 	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(batch), msg_type,
@@ -1764,13 +1764,13 @@ next:
 				 htonl(nftnl_set_get_u32(nls, NFTNL_SET_ID)));
 	}
 
-	if (!set || list_empty(&set->expressions))
+	if (!init || list_empty(&init->expressions))
 		return 0;
 
 	assert(expr);
 	nest1 = mnl_attr_nest_start(nlh, NFTA_SET_ELEM_LIST_ELEMENTS);
-	list_for_each_entry_from(expr, &set->expressions, list) {
-		nlse = alloc_nftnl_setelem(set, expr);
+	list_for_each_entry_from(expr, &init->expressions, list) {
+		nlse = alloc_nftnl_setelem(init, expr);
 
 		cmd_add_loc(cmd, nlh, &expr->location);
 		nest2 = mnl_attr_nest_start(nlh, ++i);
-- 
2.30.2

