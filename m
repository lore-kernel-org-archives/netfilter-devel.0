From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH iptables 1/2] iptables-translate: print nft command for each expand rules via dns names
Date: Wed,  8 Mar 2017 14:16:09 +0100
Message-ID: <1488978970-30802-1-git-send-email-pablo@netfilter.org>
Cc: alexander@alemayhu.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55168 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753030AbdCHNZq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Mar 2017 08:25:46 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D253F1A208A
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2017 14:16:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C387BDA725
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2017 14:16:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 507FDDA804
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2017 14:16:14 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We have to print nft at the very beginning for each rule that rules from
the expansion, otherwise the output is not correct:

 # iptables-translate -I INPUT -s yahoo.com
 nft insert rule ip filter INPUT ip saddr 206.190.36.45 counter
 insert rule ip filter INPUT ip saddr 98.138.253.109 counter
 insert rule ip filter INPUT ip saddr 98.139.183.24 counter

After this patch:

 # iptables-translate -I INPUT -s yahoo.com
 nft insert rule ip filter INPUT ip saddr 206.190.36.45 counter
 nft insert rule ip filter INPUT ip saddr 98.138.253.109 counter
 nft insert rule ip filter INPUT ip saddr 98.139.183.24 counter

Reported-by: Alexander Alemayhu <alexander@alemayhu.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/xtables-translate.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 153bd6503c59..1e35b90d77a2 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -195,6 +195,8 @@ static int xlate(struct nft_handle *h, struct nft_xt_cmd_parse *p,
 			}
 			break;
 		}
+		if (!cs->restore)
+			printf("nft ");
 	}
 
 	return ret;
-- 
2.1.4

