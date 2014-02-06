From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [PATCH 3/3] xtables-events: prints arp rules
Date: Thu,  6 Feb 2014 14:31:11 +0100
Message-ID: <1391693471-7591-4-git-send-email-giuseppelng@gmail.com>
References: <1391693471-7591-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:51827 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756377AbaBFNap (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Feb 2014 08:30:45 -0500
Received: by mail-ea0-f180.google.com with SMTP id o10so908998eaj.39
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Feb 2014 05:30:44 -0800 (PST)
In-Reply-To: <1391693471-7591-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch permits to print arp rules,
avoiding the segfault that you got currently.

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/xtables-events.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/iptables/xtables-events.c b/iptables/xtables-events.c
index 408e091..7ce1d4f 100644
--- a/iptables/xtables-events.c
+++ b/iptables/xtables-events.c
@@ -59,7 +59,11 @@ static bool counters;
 static int rule_cb(const struct nlmsghdr *nlh, int type)
 {
 	struct iptables_command_state cs = {};
+	struct arpt_entry fw_arp = {};
+	struct xtables_ebt_entry fw_eb = {};
 	struct nft_rule *r;
+	void *fw = NULL;
+	uint8_t family;
 
 	r = nft_rule_alloc();
 	if (r == NULL) {
@@ -72,21 +76,23 @@ static int rule_cb(const struct nlmsghdr *nlh, int type)
 		goto err_free;
 	}
 
-	nft_rule_to_iptables_command_state(r, &cs);
-
-	switch(nft_rule_attr_get_u8(r, NFT_RULE_ATTR_FAMILY)) {
+	family = nft_rule_attr_get_u8(r, NFT_RULE_ATTR_FAMILY);
+	switch(family) {
 	case AF_INET:
-		printf("-4 ");
-		break;
 	case AF_INET6:
-		printf("-6 ");
+		printf("-%c ", family == AF_INET ? '4' : '6');
+		nft_rule_to_iptables_command_state(r, &cs);
+		fw = &cs;
 		break;
+	case NFPROTO_ARP:
+		nft_rule_to_arpt_entry(r, &fw_arp);
+		fw = &fw_arp;
 	default:
 		break;
 	}
 
 
-	nft_rule_print_save(&cs, r,
+	nft_rule_print_save(fw, r,
 			    type == NFT_MSG_NEWRULE ? NFT_RULE_APPEND :
 						      NFT_RULE_DEL,
 			    counters ? 0 : FMT_NOCOUNTS);
-- 
1.8.1.5

