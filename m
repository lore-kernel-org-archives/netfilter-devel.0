From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH conntrackd] expect: Fix wrong memset usage
Date: Fri, 29 May 2015 14:55:10 +0200
Message-ID: <1432904110-7777-1-git-send-email-pablo@netfilter.org>
Cc: paitken@brocade.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59708 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755712AbbE2MuN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 May 2015 08:50:13 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

memset fills bytes, not ulongs - so the second parameter
(the fill value) has to be a byte.

Reported-by: Paul Aitken <paitken@brocade.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expect.c |   23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/src/expect.c b/src/expect.c
index bba0ed7..5add7be 100644
--- a/src/expect.c
+++ b/src/expect.c
@@ -39,8 +39,7 @@ cthelper_expect_init(struct nf_expect *exp, struct nf_conntrack *master,
 
 	if (saddr) {
 		switch(nfct_get_attr_u8(master, ATTR_L3PROTO)) {
-		int i;
-		uint32_t addr[4] = {};
+		uint32_t addr[4];
 
 		case AF_INET:
 			nfct_set_attr_u8(expected, ATTR_L3PROTO, AF_INET);
@@ -52,10 +51,7 @@ cthelper_expect_init(struct nf_expect *exp, struct nf_conntrack *master,
 		case AF_INET6:
 			nfct_set_attr_u8(expected, ATTR_L3PROTO, AF_INET6);
 			nfct_set_attr(expected, ATTR_IPV6_SRC, saddr->ip6);
-
-			for (i=0; i<4; i++)
-				memset(&addr[i], 0xffffffff, sizeof(uint32_t));
-
+			memset(addr, 0xff, sizeof(addr));
 			nfct_set_attr_u8(mask, ATTR_L3PROTO, AF_INET6);
 			nfct_set_attr(mask, ATTR_IPV6_SRC, addr);
 			break;
@@ -64,8 +60,7 @@ cthelper_expect_init(struct nf_expect *exp, struct nf_conntrack *master,
 		}
 	} else {
 		switch(nfct_get_attr_u8(master, ATTR_L3PROTO)) {
-		int i;
-		uint32_t addr[4] = {};
+		uint32_t addr[4];
 
 		case AF_INET:
 			nfct_set_attr_u8(expected, ATTR_L3PROTO, AF_INET);
@@ -75,9 +70,7 @@ cthelper_expect_init(struct nf_expect *exp, struct nf_conntrack *master,
 			nfct_set_attr_u32(mask, ATTR_IPV4_SRC, 0x00000000);
 			break;
 		case AF_INET6:
-			for (i=0; i<4; i++)
-				memset(&addr[i], 0x00000000, sizeof(uint32_t));
-
+			memset(addr, 0x00, sizeof(addr));
 			nfct_set_attr_u8(expected, ATTR_L3PROTO, AF_INET6);
 			nfct_set_attr(expected, ATTR_IPV6_SRC, addr);
 
@@ -116,8 +109,7 @@ cthelper_expect_init(struct nf_expect *exp, struct nf_conntrack *master,
 	}
 
 	switch(nfct_get_attr_u8(master, ATTR_L3PROTO)) {
-	uint32_t addr[4] = {};
-	int i;
+	uint32_t addr[4];
 
 	case AF_INET:
 		nfct_set_attr_u8(expected, ATTR_L3PROTO, AF_INET);
@@ -127,10 +119,7 @@ cthelper_expect_init(struct nf_expect *exp, struct nf_conntrack *master,
 	case AF_INET6:
 		nfct_set_attr_u8(expected, ATTR_L3PROTO, AF_INET6);
 		nfct_set_attr(expected, ATTR_IPV6_DST, daddr->ip6);
-
-		for (i=0; i<4; i++)
-			memset(addr, 0xffffffff, sizeof(uint32_t));
-
+		memset(addr, 0xff, sizeof(addr));
 		nfct_set_attr(mask, ATTR_IPV6_DST, addr);
 		break;
 	default:
-- 
1.7.10.4

