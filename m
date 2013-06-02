From: Eric Leblond <eric@regit.org>
Subject: [nftables PATCH 5/5] cli: reset terminal when CTRL+d is pressed
Date: Sun,  2 Jun 2013 12:38:32 +0200
Message-ID: <1370169512-23500-6-git-send-email-eric@regit.org>
References: <1370169512-23500-1-git-send-email-eric@regit.org>
Cc: Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:36300 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab3FBKi7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 2 Jun 2013 06:38:59 -0400
In-Reply-To: <1370169512-23500-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The terminal was not correctly resetted when CTRL+d was pressed.
The result was that reset has to be called from shell after exit.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/cli.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/src/cli.c b/src/cli.c
index 541c26c..8875207 100644
--- a/src/cli.c
+++ b/src/cli.c
@@ -90,8 +90,11 @@ static void cli_complete(char *line)
 	LIST_HEAD(msgs);
 
 	line = cli_append_multiline(line);
-	if (line == NULL)
+	if (line == NULL) {
+		printf("\n");
+		cli_exit();
 		return;
+	}
 
 	for (c = line; *c != '\0'; c++)
 		if (!isspace(*c))
-- 
1.7.10.4

