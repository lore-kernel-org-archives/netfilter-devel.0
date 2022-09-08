Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC038ECAAD5
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Sep 2022 09:58:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbiIHJ6z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Sep 2022 05:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbiIHJ6u (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Sep 2022 05:58:50 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01472E4DDA;
        Thu,  8 Sep 2022 02:58:45 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oWEIy-0002xR-7M; Thu, 08 Sep 2022 11:58:40 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net 4/4] netfilter: nfnetlink_osf: fix possible bogus match in nf_osf_find()
Date:   Thu,  8 Sep 2022 11:57:57 +0200
Message-Id: <20220908095757.1755-5-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220908095757.1755-1-fw@strlen.de>
References: <20220908095757.1755-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

nf_osf_find() incorrectly returns true on mismatch, this leads to
copying uninitialized memory area in nft_osf which can be used to leak
stale kernel stack data to userspace.

Fixes: 22c7652cdaa8 ("netfilter: nft_osf: Add version option support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink_osf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index 0fa2e2030427..ee6840bd5933 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -269,6 +269,7 @@ bool nf_osf_find(const struct sk_buff *skb,
 	struct nf_osf_hdr_ctx ctx;
 	const struct tcphdr *tcp;
 	struct tcphdr _tcph;
+	bool found = false;
 
 	memset(&ctx, 0, sizeof(ctx));
 
@@ -283,10 +284,11 @@ bool nf_osf_find(const struct sk_buff *skb,
 
 		data->genre = f->genre;
 		data->version = f->version;
+		found = true;
 		break;
 	}
 
-	return true;
+	return found;
 }
 EXPORT_SYMBOL_GPL(nf_osf_find);
 
-- 
2.35.1

