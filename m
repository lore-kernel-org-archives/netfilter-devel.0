From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2/4] erec: fix error markup for errors starting at column 0
Date: Fri, 10 Jan 2014 09:31:32 +0000
Message-ID: <1389346294-7242-3-git-send-email-kaber@trash.net>
References: <1389346294-7242-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57690 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbaAJJc0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jan 2014 04:32:26 -0500
In-Reply-To: <1389346294-7242-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

For errors starting at column 0, we must not subtract 1 to avoid underflow.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/erec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/erec.c b/src/erec.c
index 7451d94..a157d2f 100644
--- a/src/erec.c
+++ b/src/erec.c
@@ -138,7 +138,8 @@ void erec_print(FILE *f, const struct error_record *erec)
 		end = 0;
 		for (l = erec->num_locations - 1; l >= 0; l--) {
 			loc = &erec->locations[l];
-			for (i = loc->first_column - 1; i < loc->last_column; i++)
+			for (i = loc->first_column ? loc->first_column - 1 : 0;
+			     i < loc->last_column; i++)
 				buf[i] = l ? '~' : '^';
 			end = max(end, loc->last_column);
 		}
-- 
1.8.4.2

