From: Jan Engelhardt <jengelh@medozas.de>
Subject: libxt_string: fix undefined behavior/incorrect patlen calculation
Date: Thu, 12 Feb 2009 01:21:46 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902120121250.21248@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58364 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbZBLAVt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 19:21:49 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


commit 19b0cd770d1e042c85bf0b278261a61d4cea8193
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Thu Feb 12 01:18:35 2009 +0100

libxt_string: fix undefined behavior/incorrect patlen calculation

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
# Created with git-export-patch

