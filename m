From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/3] libxt_string: fix undefined behavior/incorrect patlen calculation
Date: Thu, 12 Feb 2009 07:19:12 +0100
Message-ID: <1234419553-4147-3-git-send-email-jengelh@medozas.de>
References: <1234419553-4147-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:60877 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbZBLGTP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2009 01:19:15 -0500
In-Reply-To: <1234419553-4147-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

strlen ran over the end of the string. Use strnlen to bound it.

Reference: http://bugs.debian.org/513516
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_string.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/extensions/libxt_string.c b/extensions/libxt_string.c
index 6bd27c0..aa52fa8 100644
--- a/extensions/libxt_string.c
+++ b/extensions/libxt_string.c
@@ -20,6 +20,7 @@
  *             updated to work with slightly modified
  *             ipt_string_info.
  */
+#define _GNU_SOURCE 1
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -207,7 +208,8 @@ string_parse(int c, char **argv, int invert, unsigned int *flags,
 			else
 				stringinfo->u.v1.flags |= XT_STRING_FLAG_INVERT;
 		}
-		stringinfo->patlen=strlen((char *)&stringinfo->pattern);
+		stringinfo->patlen = strnlen((char *)&stringinfo->pattern,
+			sizeof(stringinfo->patlen));
 		*flags |= STRING;
 		break;
 
-- 
1.6.1.2

