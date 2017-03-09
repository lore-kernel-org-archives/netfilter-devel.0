From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH iptables] iptables-translate: print nft iff there are more expanded rules to print
Date: Thu,  9 Mar 2017 12:00:44 +0100
Message-ID: <1489057244-3611-1-git-send-email-pablo@netfilter.org>
Cc: alexander@alemayhu.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52960 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752887AbdCILBf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Mar 2017 06:01:35 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F16671AEA87
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Mar 2017 12:00:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E3090DA81B
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Mar 2017 12:00:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 27690DA863
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Mar 2017 12:00:49 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

$ iptables-translate -I INPUT -s yahoo.com
nft insert rule ip filter INPUT ip saddr 98.139.183.24 counter
nft insert rule ip filter INPUT ip saddr 206.190.36.45 counter
nft insert rule ip filter INPUT ip saddr 98.138.253.109 counter
nft

This extra 'nft' print is incorrect, just print it if there are more
rules to be printed.

Reported-by: Alexander Alemayhu <alexander@alemayhu.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/xtables-translate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index d9885f20dce6..00de019000f3 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -195,7 +195,7 @@ static int xlate(struct nft_handle *h, struct nft_xt_cmd_parse *p,
 			}
 			break;
 		}
-		if (!cs->restore)
+		if (!cs->restore && i < args->s.naddrs - 1)
 			printf("nft ");
 	}
 
-- 
2.1.4

