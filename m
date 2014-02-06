From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [PATCH 2/3] nft-arp: adds nft_arp_save_firewall
Date: Thu,  6 Feb 2014 14:31:10 +0100
Message-ID: <1391693471-7591-3-git-send-email-giuseppelng@gmail.com>
References: <1391693471-7591-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:52835 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbaBFNam (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Feb 2014 08:30:42 -0500
Received: by mail-ea0-f178.google.com with SMTP id a15so894423eae.37
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Feb 2014 05:30:41 -0800 (PST)
In-Reply-To: <1391693471-7591-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Adds nft_arp_save_firewall to arp family.
(Avoids the segfault in xtables-events)

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft-arp.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 1710136..bbb168d 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -570,6 +570,14 @@ after_devdst:
 		fputc('\n', stdout);
 }
 
+static void nft_arp_save_firewall(const void *data,
+				   unsigned int format)
+{
+	const struct arpt_entry *fw = data;
+
+	return;
+}
+
 static bool nft_arp_is_same(const void *data_a,
 			    const void *data_b)
 {
@@ -643,6 +651,7 @@ struct nft_family_ops nft_family_ops_arp = {
 	.parse_payload		= nft_arp_parse_payload,
 	.parse_immediate	= nft_arp_parse_immediate,
 	.print_firewall		= nft_arp_print_firewall,
+	.save_firewall		= nft_arp_save_firewall,
 	.post_parse		= NULL,
 	.rule_find		= nft_arp_rule_find,
 	.parse_target		= nft_arp_parse_target,
-- 
1.8.1.5

