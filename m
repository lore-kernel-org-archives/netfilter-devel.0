From: Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH] netfilter: nf_tables: remove the duplicate NF_INET_LOCAL_OUT
Date: Fri, 28 Jun 2013 03:57:26 -0400
Message-ID: <1372406246-13739-1-git-send-email-xiaosuo@gmail.com>
Cc: Changli Gao <xiaosuo@gmail.com>, kaber@trash.net,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:40915 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab3F1H6i (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Jun 2013 03:58:38 -0400
Received: by mail-pb0-f48.google.com with SMTP id ma3so1960923pbc.7
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jun 2013 00:58:38 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The line for NF_INET_LOCAL_OUT is duplicated by mistake, so just remove it.

---
 net/ipv4/netfilter/nf_tables_ipv4.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv4/netfilter/nf_tables_ipv4.c b/net/ipv4/netfilter/nf_tables_ipv4.c
index ab6b407..5dfb2ae 100644
--- a/net/ipv4/netfilter/nf_tables_ipv4.c
+++ b/net/ipv4/netfilter/nf_tables_ipv4.c
@@ -100,7 +100,6 @@ static struct nf_chain_type filter_ipv4 = {
 	.fn		= {
 		[NF_INET_LOCAL_IN]	= nft_do_chain_ipv4,
 		[NF_INET_LOCAL_OUT]	= nft_do_chain_ipv4,
-		[NF_INET_LOCAL_OUT]	= nft_do_chain_ipv4,
 		[NF_INET_FORWARD]	= nft_do_chain_ipv4,
 		[NF_INET_PRE_ROUTING]	= nft_do_chain_ipv4,
 		[NF_INET_POST_ROUTING]	= nft_do_chain_ipv4,
-- 
1.7.9.5

