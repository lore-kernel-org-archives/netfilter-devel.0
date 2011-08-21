From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 16/21] libipt_ttl: document that negation is available
Date: Sun, 21 Aug 2011 13:09:31 +0200
Message-ID: <1313924977-8623-17-git-send-email-jengelh@medozas.de>
References: <1313924977-8623-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:38762 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754382Ab1HULJ5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Aug 2011 07:09:57 -0400
In-Reply-To: <1313924977-8623-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Glitch since commit v1.2.1~75.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libipt_ttl.c   |    2 +-
 extensions/libipt_ttl.man |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libipt_ttl.c b/extensions/libipt_ttl.c
index 6370cb6..5fe08cc 100644
--- a/extensions/libipt_ttl.c
+++ b/extensions/libipt_ttl.c
@@ -20,7 +20,7 @@ static void ttl_help(void)
 {
 	printf(
 "ttl match options:\n"
-"  --ttl-eq value	Match time to live value\n"
+"[!] --ttl-eq value	Match time to live value\n"
 "  --ttl-lt value	Match TTL < value\n"
 "  --ttl-gt value	Match TTL > value\n");
 }
diff --git a/extensions/libipt_ttl.man b/extensions/libipt_ttl.man
index 849f704..1f32277 100644
--- a/extensions/libipt_ttl.man
+++ b/extensions/libipt_ttl.man
@@ -1,6 +1,6 @@
 This module matches the time to live field in the IP header.
 .TP
-\fB\-\-ttl\-eq\fP \fIttl\fP
+[\fB!\fP] \fB\-\-ttl\-eq\fP \fIttl\fP
 Matches the given TTL value.
 .TP
 \fB\-\-ttl\-gt\fP \fIttl\fP
-- 
1.7.3.4

