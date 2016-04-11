From: Guruswamy Basavaiah <guru2018@gmail.com>
Subject: [PATCH] Not printing "nft" in iptables-restore-translate command
Date: Mon, 11 Apr 2016 13:10:33 +0530
Message-ID: <1460360433-14709-1-git-send-email-guru2018@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34021 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbcDKHkm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Apr 2016 03:40:42 -0400
Received: by mail-wm0-f67.google.com with SMTP id n3so19208093wmn.1
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Apr 2016 00:40:41 -0700 (PDT)
Received: from inbhdhcp214179.apac.nsn-net.net ([62.159.77.165])
        by smtp.gmail.com with ESMTPSA id m6sm26264349wje.21.2016.04.11.00.40.39
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Mon, 11 Apr 2016 00:40:40 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

No need to print "nft" in function do_command_xlate,
if the function is called from iptables-restore-translate command.

Signed-off-by: Guruswamy Basavaiah <guru2018@gmail.com>
---
 iptables/xtables-translate.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 0b2c0bf..1c64178 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -193,7 +193,9 @@ static int do_command_xlate(struct nft_handle *h, int argc, char *argv[],
 
 	do_parse(h, argc, argv, &p, &cs, &args);
 
-	printf("nft ");
+	if (!restore) {
+		printf("nft ");
+	}
 	switch (p.command) {
 	case CMD_APPEND:
 		ret = 1;
-- 
2.5.5

