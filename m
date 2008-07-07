From: Patrick McHardy <kaber@trash.net>
Subject: textsearch 10/13: ts_kmp: support case insensitive searching in Knuth-Morris-Pratt algorithm
Date: Mon,  7 Jul 2008 14:05:28 +0200 (MEST)
Message-ID: <20080707120527.4975.23121.sendpatchset@localhost.localdomain>
References: <20080707120514.4975.88670.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58397 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608AbYGGMFa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jul 2008 08:05:30 -0400
In-Reply-To: <20080707120514.4975.88670.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

textsearch: ts_kmp: support case insensitive searching in Knuth-Morris-Pratt algorithm

Add support for case insensitive search to Knuth-Morris-Pratt algorithm.

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit f7bf6c69848b78c6244bf9d6d963c6d685e91a58
tree fdf158caff0f667f9602dfe6071ae98e1b38fb97
parent 457ff20e4a6f48e8ff049ad9323b76b9a4e110a7
author Joonwoo Park <joonwpark81@gmail.com> Mon, 07 Jul 2008 13:00:17 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 07 Jul 2008 13:00:17 +0200

 lib/ts_kmp.c |   29 +++++++++++++++++++++--------
 1 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/lib/ts_kmp.c b/lib/ts_kmp.c
index 3ced628..632f783 100644
--- a/lib/ts_kmp.c
+++ b/lib/ts_kmp.c
@@ -33,6 +33,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/string.h>
+#include <linux/ctype.h>
 #include <linux/textsearch.h>
 
 struct ts_kmp
@@ -47,6 +48,7 @@ static unsigned int kmp_find(struct ts_config *conf, struct ts_state *state)
 	struct ts_kmp *kmp = ts_config_priv(conf);
 	unsigned int i, q = 0, text_len, consumed = state->offset;
 	const u8 *text;
+	const int icase = conf->flags & TS_IGNORECASE;
 
 	for (;;) {
 		text_len = conf->get_next_block(consumed, &text, conf, state);
@@ -55,9 +57,11 @@ static unsigned int kmp_find(struct ts_config *conf, struct ts_state *state)
 			break;
 
 		for (i = 0; i < text_len; i++) {
-			while (q > 0 && kmp->pattern[q] != text[i])
+			while (q > 0 && kmp->pattern[q]
+			    != (icase ? toupper(text[i]) : text[i]))
 				q = kmp->prefix_tbl[q - 1];
-			if (kmp->pattern[q] == text[i])
+			if (kmp->pattern[q]
+			    == (icase ? toupper(text[i]) : text[i]))
 				q++;
 			if (unlikely(q == kmp->pattern_len)) {
 				state->offset = consumed + i + 1;
@@ -72,24 +76,28 @@ static unsigned int kmp_find(struct ts_config *conf, struct ts_state *state)
 }
 
 static inline void compute_prefix_tbl(const u8 *pattern, unsigned int len,
-				      unsigned int *prefix_tbl)
+				      unsigned int *prefix_tbl, int flags)
 {
 	unsigned int k, q;
+	const u8 icase = flags & TS_IGNORECASE;
 
 	for (k = 0, q = 1; q < len; q++) {
-		while (k > 0 && pattern[k] != pattern[q])
+		while (k > 0 && (icase ? toupper(pattern[k]) : pattern[k])
+		    != (icase ? toupper(pattern[q]) : pattern[q]))
 			k = prefix_tbl[k-1];
-		if (pattern[k] == pattern[q])
+		if ((icase ? toupper(pattern[k]) : pattern[k])
+		    == (icase ? toupper(pattern[q]) : pattern[q]))
 			k++;
 		prefix_tbl[q] = k;
 	}
 }
 
 static struct ts_config *kmp_init(const void *pattern, unsigned int len,
-				  gfp_t gfp_mask)
+				  gfp_t gfp_mask, int flags)
 {
 	struct ts_config *conf;
 	struct ts_kmp *kmp;
+	int i;
 	unsigned int prefix_tbl_len = len * sizeof(unsigned int);
 	size_t priv_size = sizeof(*kmp) + len + prefix_tbl_len;
 
@@ -97,11 +105,16 @@ static struct ts_config *kmp_init(const void *pattern, unsigned int len,
 	if (IS_ERR(conf))
 		return conf;
 
+	conf->flags = flags;
 	kmp = ts_config_priv(conf);
 	kmp->pattern_len = len;
-	compute_prefix_tbl(pattern, len, kmp->prefix_tbl);
+	compute_prefix_tbl(pattern, len, kmp->prefix_tbl, flags);
 	kmp->pattern = (u8 *) kmp->prefix_tbl + prefix_tbl_len;
-	memcpy(kmp->pattern, pattern, len);
+	if (flags & TS_IGNORECASE)
+		for (i = 0; i < len; i++)
+			kmp->pattern[i] = toupper(((u8 *)pattern)[i]);
+	else
+		memcpy(kmp->pattern, pattern, len);
 
 	return conf;
 }
