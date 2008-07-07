From: Patrick McHardy <kaber@trash.net>
Subject: textsearch 09/13: ts_bm: support case insensitive searching in Boyer-Moore algorithm
Date: Mon,  7 Jul 2008 14:05:27 +0200 (MEST)
Message-ID: <20080707120526.4975.57912.sendpatchset@localhost.localdomain>
References: <20080707120514.4975.88670.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58391 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693AbYGGMF2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jul 2008 08:05:28 -0400
In-Reply-To: <20080707120514.4975.88670.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

textsearch: ts_bm: support case insensitive searching in Boyer-Moore algorithm

Add support for case insensitive search to Boyer-Moore algorithm.

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 457ff20e4a6f48e8ff049ad9323b76b9a4e110a7
tree a777e8054a470dcc262b32653e1fe795d8d66d62
parent ad089136c547ef33e2375e64dd13a0f09825d4d0
author Joonwoo Park <joonwpark81@gmail.com> Mon, 07 Jul 2008 13:00:17 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 07 Jul 2008 13:00:17 +0200

 lib/ts_bm.c |   26 ++++++++++++++++++++------
 1 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/lib/ts_bm.c b/lib/ts_bm.c
index 4a7fce7..9e66ee4 100644
--- a/lib/ts_bm.c
+++ b/lib/ts_bm.c
@@ -39,6 +39,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/string.h>
+#include <linux/ctype.h>
 #include <linux/textsearch.h>
 
 /* Alphabet size, use ASCII */
@@ -64,6 +65,7 @@ static unsigned int bm_find(struct ts_config *conf, struct ts_state *state)
 	unsigned int i, text_len, consumed = state->offset;
 	const u8 *text;
 	int shift = bm->patlen - 1, bs;
+	const u8 icase = conf->flags & TS_IGNORECASE;
 
 	for (;;) {
 		text_len = conf->get_next_block(consumed, &text, conf, state);
@@ -75,7 +77,9 @@ static unsigned int bm_find(struct ts_config *conf, struct ts_state *state)
 			DEBUGP("Searching in position %d (%c)\n", 
 				shift, text[shift]);
 			for (i = 0; i < bm->patlen; i++) 
-			     if (text[shift-i] != bm->pattern[bm->patlen-1-i])
+				if ((icase ? toupper(text[shift-i])
+				    : text[shift-i])
+					!= bm->pattern[bm->patlen-1-i])
 				     goto next;
 
 			/* London calling... */
@@ -111,14 +115,18 @@ static int subpattern(u8 *pattern, int i, int j, int g)
 	return ret;
 }
 
-static void compute_prefix_tbl(struct ts_bm *bm)
+static void compute_prefix_tbl(struct ts_bm *bm, int flags)
 {
 	int i, j, g;
 
 	for (i = 0; i < ASIZE; i++)
 		bm->bad_shift[i] = bm->patlen;
-	for (i = 0; i < bm->patlen - 1; i++)
+	for (i = 0; i < bm->patlen - 1; i++) {
 		bm->bad_shift[bm->pattern[i]] = bm->patlen - 1 - i;
+		if (flags & TS_IGNORECASE)
+			bm->bad_shift[tolower(bm->pattern[i])]
+			    = bm->patlen - 1 - i;
+	}
 
 	/* Compute the good shift array, used to match reocurrences 
 	 * of a subpattern */
@@ -135,10 +143,11 @@ static void compute_prefix_tbl(struct ts_bm *bm)
 }
 
 static struct ts_config *bm_init(const void *pattern, unsigned int len,
-				 gfp_t gfp_mask)
+				 gfp_t gfp_mask, int flags)
 {
 	struct ts_config *conf;
 	struct ts_bm *bm;
+	int i;
 	unsigned int prefix_tbl_len = len * sizeof(unsigned int);
 	size_t priv_size = sizeof(*bm) + len + prefix_tbl_len;
 
@@ -146,11 +155,16 @@ static struct ts_config *bm_init(const void *pattern, unsigned int len,
 	if (IS_ERR(conf))
 		return conf;
 
+	conf->flags = flags;
 	bm = ts_config_priv(conf);
 	bm->patlen = len;
 	bm->pattern = (u8 *) bm->good_shift + prefix_tbl_len;
-	memcpy(bm->pattern, pattern, len);
-	compute_prefix_tbl(bm);
+	if (flags & TS_IGNORECASE)
+		for (i = 0; i < len; i++)
+			bm->pattern[i] = toupper(((u8 *)pattern)[i]);
+	else
+		memcpy(bm->pattern, pattern, len);
+	compute_prefix_tbl(bm, flags);
 
 	return conf;
 }
