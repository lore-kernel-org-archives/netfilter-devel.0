From: Guruswamy Basavaiah <guru2018@gmail.com>
Subject: [PATCH] iptables-translate: Printing the table name before chain name
Date: Tue, 5 Apr 2016 12:38:37 +0530
Message-ID: <20160405070837.GA12017@inbhdhcp21574.apac.nsn-net.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:37035 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938AbcDEHIm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Apr 2016 03:08:42 -0400
Received: by mail-wm0-f41.google.com with SMTP id n3so8541429wmn.0
        for <netfilter-devel@vger.kernel.org>; Tue, 05 Apr 2016 00:08:42 -0700 (PDT)
Received: from inbhdhcp21574.apac.nsn-net.net ([62.159.77.167])
        by smtp.gmail.com with ESMTPSA id 192sm17898685wmw.0.2016.04.05.00.08.39
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Tue, 05 Apr 2016 00:08:40 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Printing the table name before chain name.

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
index 44162a2..07cc98c 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -296,7 +296,7 @@ static const struct option options[] = {
 static int xlate_chain_user_add(struct nft_handle *h, const char *chain,
                                const char *table)
 {
-       printf("add chain %s %s %s\n", family2str[h->family], chain, table);
+       printf("add chain %s %s %s\n", family2str[h->family], table, chain);
        return 0;
 }

--
2.5.0
