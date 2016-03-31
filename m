From: Guruswamy Basavaiah <guru2018@gmail.com>
Subject: [PATCH] iptables-translate: Moving of printing nft back to
 xtables_xlate_main
Date: Fri, 1 Apr 2016 00:06:24 +0530
Message-ID: <20160331183624.GA7030@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:33203 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbcCaSg3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Mar 2016 14:36:29 -0400
Received: by mail-pa0-f67.google.com with SMTP id q6so10999817pav.0
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Mar 2016 11:36:29 -0700 (PDT)
Received: from localhost.localdomain ([1.23.11.154])
        by smtp.gmail.com with ESMTPSA id xs10sm15140167pab.4.2016.03.31.11.36.26
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Thu, 31 Mar 2016 11:36:27 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Moving of printing "nft" back to xtables_xlate_main from
 function do_command_xlate.

This reverts of previous commit 4f75601d37349c5a983a969d46c1ff0604991b5c
which was breaking "iptables-restore-translate -f" and "./nft -f"
---
 iptables/xtables-translate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 354357c..44162a2 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -193,7 +193,6 @@ static int do_command_xlate(struct nft_handle *h, int argc, char *argv[],
 
 	do_parse(h, argc, argv, &p, &cs, &args);
 
-	printf("nft ");
 	switch (p.command) {
 	case CMD_APPEND:
 		ret = 1;
@@ -370,6 +369,7 @@ static int xtables_xlate_main(int family, const char *progname, int argc,
 		exit(EXIT_FAILURE);
 	}
 
+	printf("nft ");
 	ret = do_command_xlate(&h, argc, argv, &table, false);
 	if (!ret)
 		fprintf(stderr, "Translation not implemented\n");
-- 
2.5.0

