From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [PATCH] nft: arp: add parse_target to nft_family_ops_arp
Date: Sun,  6 Oct 2013 14:36:47 +0200
Message-ID: <1381063007-6184-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:56923 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab3JFMgg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Oct 2013 08:36:36 -0400
Received: by mail-ea0-f170.google.com with SMTP id h14so2713388eak.1
        for <netfilter-devel@vger.kernel.org>; Sun, 06 Oct 2013 05:36:34 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds parse_target for arp family, fixing segfaults
for xtables-arp -L after rules like:

- xtables-arp -A OUTPUT -o eth0 -j CLASSIFY --set-class 0:7
- xtables-arp -A OUTPUT -o eth1 --h-length 6 -j mangle --mangle-mac-s 01:00:5e:00:01:01

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft-arp.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 570962d..08f8814 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -643,4 +643,5 @@ struct nft_family_ops nft_family_ops_arp = {
 	.print_firewall		= nft_arp_print_firewall,
 	.post_parse		= NULL,
 	.rule_find		= nft_arp_rule_find,
+	.parse_target		= nft_arp_parse_target,
 };
-- 
1.7.8.6

