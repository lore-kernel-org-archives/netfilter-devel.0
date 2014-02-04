From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 4/8] erec: skip includes with INDESC_INTERNAL
Date: Tue,  4 Feb 2014 08:35:16 +0000
Message-ID: <1391502920-19186-5-git-send-email-kaber@trash.net>
References: <1391502920-19186-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43626 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbaBDIf1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Feb 2014 03:35:27 -0500
In-Reply-To: <1391502920-19186-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Don't display "In file included from internal:0:0-0:" for errors occuring
in a parsed file.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/erec.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/erec.c b/src/erec.c
index a157d2f..4930085 100644
--- a/src/erec.c
+++ b/src/erec.c
@@ -114,7 +114,9 @@ void erec_print(FILE *f, const struct error_record *erec)
 		if (indesc->location.indesc != NULL) {
 			const char *prefix = "In file included from";
 			iloc = &indesc->location;
-			for (tmp = iloc->indesc; tmp != NULL; tmp = iloc->indesc) {
+			for (tmp = iloc->indesc;
+			     tmp != NULL && tmp->type != INDESC_INTERNAL;
+			     tmp = iloc->indesc) {
 				fprintf(f, "%s %s:%u:%u-%u:\n", prefix,
 					tmp->name,
 					iloc->first_line, iloc->first_column,
-- 
1.8.5.3

