From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [PATCH 2/2] xtables-events: prints arp rules
Date: Wed, 19 Feb 2014 13:10:29 +0100
Message-ID: <1392811829-5303-2-git-send-email-giuseppelng@gmail.com>
References: <1392811829-5303-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:34043 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbaBSMJ5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Feb 2014 07:09:57 -0500
Received: by mail-ee0-f48.google.com with SMTP id t10so182787eei.7
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Feb 2014 04:09:54 -0800 (PST)
In-Reply-To: <1392811829-5303-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch permits to print arp rules,
avoiding the segfault that you got currently.

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/xtables-events.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/iptables/xtables-events.c b/iptables/xtables-events.c
index 4be8ab8..535dd91 100644
--- a/iptables/xtables-events.c
+++ b/iptables/xtables-events.c
@@ -59,7 +59,10 @@ static bool counters;
 static int rule_cb(const struct nlmsghdr *nlh, int type)
 {
 	struct iptables_command_state cs = {};
+	struct arpt_entry fw_arp = {};
 	struct nft_rule *r;
+	void *fw = NULL;
+	uint8_t family;
 
 	r = nft_rule_alloc();
 	if (r == NULL) {
@@ -72,21 +75,24 @@ static int rule_cb(const struct nlmsghdr *nlh, int type)
 		goto err_free;
 	}
 
-	nft_rule_to_iptables_command_state(r, &cs);
-
-	switch(nft_rule_attr_get_u8(r, NFT_RULE_ATTR_FAMILY)) {
+	family = nft_rule_attr_get_u8(r, NFT_RULE_ATTR_FAMILY);
+	switch (family) {
 	case AF_INET:
-		printf("-4 ");
-		break;
 	case AF_INET6:
-		printf("-6 ");
+		printf("-%c ", family == AF_INET ? '4' : '6');
+		nft_rule_to_iptables_command_state(r, &cs);
+		fw = &cs;
 		break;
-	default:
+	case NFPROTO_ARP:
+		nft_rule_to_arpt_entry(r, &fw_arp);
+		fw = &fw_arp;
 		break;
+	default:
+		goto err_free;
 	}
 
 
-	nft_rule_print_save(&cs, r,
+	nft_rule_print_save(fw, r,
 			    type == NFT_MSG_NEWRULE ? NFT_RULE_APPEND :
 						      NFT_RULE_DEL,
 			    counters ? 0 : FMT_NOCOUNTS);
-- 
1.8.3.2

