Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 659C7CD8C9C
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Oct 2023 14:54:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbjJJOym (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Oct 2023 10:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232586AbjJJOym (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Oct 2023 10:54:42 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A45799;
        Tue, 10 Oct 2023 07:54:41 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qqE7o-0001RC-7N; Tue, 10 Oct 2023 16:54:20 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>,
        George Guo <guodongtai@kylinos.cn>
Subject: [PATCH net-next 8/8] netfilter: cleanup struct nft_table
Date:   Tue, 10 Oct 2023 16:53:38 +0200
Message-ID: <20231010145343.12551-9-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231010145343.12551-1-fw@strlen.de>
References: <20231010145343.12551-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: George Guo <guodongtai@kylinos.cn>

Add comments for nlpid, family, udlen and udata in struct nft_table, and
afinfo is no longer a member of struct nft_table, so remove the comment
for it.

Signed-off-by: George Guo <guodongtai@kylinos.cn>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 7c816359d5a9..9fb16485d08f 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1198,10 +1198,13 @@ static inline void nft_use_inc_restore(u32 *use)
  *	@hgenerator: handle generator state
  *	@handle: table handle
  *	@use: number of chain references to this table
+ *	@family:address family
  *	@flags: table flag (see enum nft_table_flags)
  *	@genmask: generation mask
- *	@afinfo: address family info
+ *	@nlpid: netlink port ID
  *	@name: name of the table
+ *	@udlen: length of the user data
+ *	@udata: user data
  *	@validate_state: internal, set when transaction adds jumps
  */
 struct nft_table {
-- 
2.41.0

