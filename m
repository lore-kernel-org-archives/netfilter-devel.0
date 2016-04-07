From: Guruswamy Basavaiah <guru2018@gmail.com>
Subject: [PATCH] Printing the table name before chain name.
Date: Fri,  8 Apr 2016 01:08:14 +0530
Message-ID: <1460057894-20466-1-git-send-email-guru2018@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:35103 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078AbcDGTiS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Apr 2016 15:38:18 -0400
Received: by mail-pa0-f65.google.com with SMTP id zy2so7465967pac.2
        for <netfilter-devel@vger.kernel.org>; Thu, 07 Apr 2016 12:38:18 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([1.23.8.201])
        by smtp.gmail.com with ESMTPSA id f8sm13942112pfj.49.2016.04.07.12.38.16
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Thu, 07 Apr 2016 12:38:17 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Command ./iptables-restore-translate, was printing
table name before the chain name for user added chains.
This is breaking ./nft -f command.

Before fix, output of "./iptables-restore-translate"
add chain ip OUTPUT_direct raw

After fix:
add chain ip raw OUTPUT_direct

Signed-off-by: Guruswamy Basavaiah <guru2018@gmail.com>
---
 iptables/xtables-translate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 354357c..0b2c0bf 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -297,7 +297,7 @@ static const struct option options[] = {
 static int xlate_chain_user_add(struct nft_handle *h, const char *chain,
 				const char *table)
 {
-	printf("add chain %s %s %s\n", family2str[h->family], chain, table);
+	printf("add chain %s %s %s\n", family2str[h->family], table, chain);
 	return 0;
 }
 
-- 
2.5.5

