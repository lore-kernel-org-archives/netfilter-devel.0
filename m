From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [PATCH 3/4] erec: Handle returned value properly in erec_print
Date: Thu,  2 Aug 2012 13:31:34 +0300
Message-ID: <1343903495-14486-4-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1343903495-14486-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:51950 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750Ab2HBKbn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Aug 2012 06:31:43 -0400
In-Reply-To: <1343903495-14486-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 src/erec.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/src/erec.c b/src/erec.c
index 501bf4b..554a406 100644
--- a/src/erec.c
+++ b/src/erec.c
@@ -78,7 +78,7 @@ void erec_print(FILE *f, const struct error_record *erec)
 	const char *line = NULL; /* silence gcc */
 	char buf[1024];
 	unsigned int i, end;
-	int l;
+	int l, ret;
 
 	switch (indesc->type) {
 	case INDESC_BUFFER:
@@ -88,8 +88,9 @@ void erec_print(FILE *f, const struct error_record *erec)
 	case INDESC_FILE:
 		memset(buf, 0, sizeof(buf));
 		lseek(indesc->fd, loc->line_offset, SEEK_SET);
-		read(indesc->fd, buf, sizeof(buf) - 1);
-		*strchrnul(buf, '\n') = '\0';
+		ret = read(indesc->fd, buf, sizeof(buf) - 1);
+		if (ret > 0)
+			*strchrnul(buf, '\n') = '\0';
 		line = buf;
 		break;
 	case INDESC_INTERNAL:
-- 
1.7.8.6

