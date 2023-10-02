Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2BA2E784AF
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Oct 2023 09:57:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236297AbjJBJ5t (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Oct 2023 05:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236306AbjJBJ5s (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Oct 2023 05:57:48 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1384D8E
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Oct 2023 02:57:46 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc, fw@strlen.de
Subject: [PATCH nf,v2] netfilter: nf_tables: do not refresh timeout when resetting element
Date:   Mon,  2 Oct 2023 11:57:42 +0200
Message-Id: <20231002095742.3203033-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The dump and reset command should not refresh the timeout, this command
is intended to allow users to list existing stateful objects and reset
them, element expiration should be refresh via transaction instead with
a specific command to achieve this, otherwise this is entering combo
semantics that will be hard to be undone later (eg. a user asking to
retrieve counters but _not_ requiring to refresh expiration).

Fixes: 079cd633219d ("netfilter: nf_tables: Introduce NFT_MSG_GETSETELEM_RESET")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: remove 'u64 timeout', leave things as before 079cd633219d.

 net/netfilter/nf_tables_api.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3bb5ea5d4eed..8b5407843149 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5556,7 +5556,6 @@ static int nf_tables_fill_setelem(struct sk_buff *skb,
 	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
 	unsigned char *b = skb_tail_pointer(skb);
 	struct nlattr *nest;
-	u64 timeout = 0;
 
 	nest = nla_nest_start_noflag(skb, NFTA_LIST_ELEM);
 	if (nest == NULL)
@@ -5592,15 +5591,11 @@ static int nf_tables_fill_setelem(struct sk_buff *skb,
 		         htonl(*nft_set_ext_flags(ext))))
 		goto nla_put_failure;
 
-	if (nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT)) {
-		timeout = *nft_set_ext_timeout(ext);
-		if (nla_put_be64(skb, NFTA_SET_ELEM_TIMEOUT,
-				 nf_jiffies64_to_msecs(timeout),
-				 NFTA_SET_ELEM_PAD))
-			goto nla_put_failure;
-	} else if (set->flags & NFT_SET_TIMEOUT) {
-		timeout = READ_ONCE(set->timeout);
-	}
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT) &&
+	    nla_put_be64(skb, NFTA_SET_ELEM_TIMEOUT,
+			 nf_jiffies64_to_msecs(*nft_set_ext_timeout(ext)),
+			 NFTA_SET_ELEM_PAD))
+		goto nla_put_failure;
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPIRATION)) {
 		u64 expires, now = get_jiffies_64();
@@ -5615,9 +5610,6 @@ static int nf_tables_fill_setelem(struct sk_buff *skb,
 				 nf_jiffies64_to_msecs(expires),
 				 NFTA_SET_ELEM_PAD))
 			goto nla_put_failure;
-
-		if (reset)
-			*nft_set_ext_expiration(ext) = now + timeout;
 	}
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_USERDATA)) {
-- 
2.30.2

