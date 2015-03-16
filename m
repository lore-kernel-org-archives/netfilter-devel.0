From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH 2/3] rule: export the ruleset using the new node "add"
Date: Mon, 16 Mar 2015 16:06:10 +0100
Message-ID: <1426518371-11717-2-git-send-email-alvaroneay@gmail.com>
References: <1426518371-11717-1-git-send-email-alvaroneay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:36937 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137AbbCPPF4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2015 11:05:56 -0400
Received: by wixw10 with SMTP id w10so46073707wix.0
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Mar 2015 08:05:55 -0700 (PDT)
Received: from localhost.localdomain (129.166.216.87.static.jazztel.es. [87.216.166.129])
        by mx.google.com with ESMTPSA id s19sm15725928wik.18.2015.03.16.08.05.53
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Mar 2015 08:05:54 -0700 (PDT)
In-Reply-To: <1426518371-11717-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/rule.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/rule.c b/src/rule.c
index 8d76fd0..b392ead 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -754,7 +754,7 @@ static int do_command_export(struct netlink_ctx *ctx, struct cmd *cmd)
 	if (rs == NULL)
 		return -1;
 
-	nft_ruleset_fprintf(stdout, rs, cmd->export->format, 0);
+	nft_ruleset_fprintf(stdout, rs, cmd->export->format, NFT_OF_EVENT_NEW);
 	fprintf(stdout, "\n");
 
 	nft_ruleset_free(rs);
-- 
1.7.10.4

