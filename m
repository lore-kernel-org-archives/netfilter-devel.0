From: gapsf@yandex.ru
Subject: [PATCH] nftables kernel tree: nf_tables_ipv4.c: typo in struct filter_ipv4 initialization
Date: Sat, 22 Jun 2013 23:40:40 +0700
Message-ID: <1371919240-2216-1-git-send-email-gapsf@yandex.ru>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forward4h.mail.yandex.net ([84.201.186.22]:33034 "EHLO
	forward4h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab3FVQtG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 22 Jun 2013 12:49:06 -0400
Received: from smtp2h.mail.yandex.net (smtp2h.mail.yandex.net [84.201.187.145])
	by forward4h.mail.yandex.net (Yandex) with ESMTP id 187B51B2C28D
	for <netfilter-devel@vger.kernel.org>; Sat, 22 Jun 2013 20:41:39 +0400 (MSK)
Received: from smtp2h.mail.yandex.net (localhost [127.0.0.1])
	by smtp2h.mail.yandex.net (Yandex) with ESMTP id E8FB41700F60
	for <netfilter-devel@vger.kernel.org>; Sat, 22 Jun 2013 20:41:38 +0400 (MSK)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: gapsf <gapsf@yandex.ru>

---
 net/ipv4/netfilter/nf_tables_ipv4.c | 1 -
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
1.8.3.msysgit.0

