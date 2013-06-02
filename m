From: Eric Leblond <eric@regit.org>
Subject: [nftables PATCH 4/5] cli: add quit command
Date: Sun,  2 Jun 2013 12:38:31 +0200
Message-ID: <1370169512-23500-5-git-send-email-eric@regit.org>
References: <1370169512-23500-1-git-send-email-eric@regit.org>
Cc: Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:36298 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab3FBKi5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 2 Jun 2013 06:38:57 -0400
In-Reply-To: <1370169512-23500-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/cli.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/src/cli.c b/src/cli.c
index a5a891e..541c26c 100644
--- a/src/cli.c
+++ b/src/cli.c
@@ -99,6 +99,11 @@ static void cli_complete(char *line)
 	if (*c == '\0')
 		return;
 
+	if (!strcmp(line, "quit")) {
+		cli_exit();
+		exit(0);
+	}
+
 	/* avoid duplicate history entries */
 	hist = history_get(history_length);
 	if (hist == NULL || strcmp(hist->line, line))
-- 
1.7.10.4

