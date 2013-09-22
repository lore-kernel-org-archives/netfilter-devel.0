From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [iptables-nftables PATCH 2/2] xtables: arp: zeroing chain counters
Date: Sun, 22 Sep 2013 10:18:56 +0200
Message-ID: <1379837936-2813-2-git-send-email-giuseppelng@gmail.com>
References: <1379837936-2813-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:59648 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615Ab3IVITO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 22 Sep 2013 04:19:14 -0400
Received: by mail-ea0-f169.google.com with SMTP id k11so1085048eaj.14
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Sep 2013 01:19:13 -0700 (PDT)
In-Reply-To: <1379837936-2813-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This small patch permit to reset the chain counters.

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/xtables-arp.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index 4537a58..2f43ce8 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -1462,9 +1462,8 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table)
 				   options&OPT_NUMERIC,
 				   /*options&OPT_EXPANDED*/0,
 				   options&OPT_LINENUMBERS);
-		/*if (ret)
-			ret = zero_entries(chain,
-						options&OPT_VERBOSE, handle);*/
+		if (ret && (command & CMD_ZERO))
+			ret = nft_chain_zero_counters(h, chain, *table);
 		break;
 	case CMD_NEW_CHAIN:
 		ret = nft_chain_user_add(h, chain, *table);
-- 
1.7.8.6

