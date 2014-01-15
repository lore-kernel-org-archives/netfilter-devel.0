From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 3/3] payload: fix inconsistency in ethertype output
Date: Wed, 15 Jan 2014 21:30:23 +0100
Message-ID: <1389817823-7251-3-git-send-email-pablo@netfilter.org>
References: <1389817823-7251-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52342 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618AbaAOUaf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jan 2014 15:30:35 -0500
In-Reply-To: <1389817823-7251-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use ip6 instead of ipv6.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/payload.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/payload.c b/src/payload.c
index decfcd6..bfd8ba4 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -982,7 +982,7 @@ static const struct symbol_table ethertype_tbl = {
 	.symbols	= {
 		SYMBOL("ip",		ETH_P_IP),
 		SYMBOL("arp",		ETH_P_ARP),
-		SYMBOL("ipv6",		ETH_P_IPV6),
+		SYMBOL("ip6",		ETH_P_IPV6),
 		SYMBOL("vlan",		ETH_P_8021Q),
 		SYMBOL_LIST_END
 	},
-- 
1.7.10.4

