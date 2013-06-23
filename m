From: Florian Westphal <fw@strlen.de>
Subject: [PATCH lnf-ct 1/2] conntrack: labels: skip labels with non-alnum characters
Date: Sun, 23 Jun 2013 23:14:38 +0200
Message-ID: <1372022079-11719-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:44875 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751049Ab3FWVQN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Jun 2013 17:16:13 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Can always lift this restriction later but for now enforce
strict label naming.

This is mainly  to make sure that e.g. using
conntrack ... -o xml,connlabels

will output the expected format, without nasty surprises.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 I've split this into a separate patch since it has noting
 to do with the nfct_snprintf change.

 src/conntrack/labels.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/src/conntrack/labels.c b/src/conntrack/labels.c
index 7393c42..7dfb780 100644
--- a/src/conntrack/labels.c
+++ b/src/conntrack/labels.c
@@ -1,3 +1,4 @@
+#include <stdbool.h>
 #include <stdint.h>
 
 #include "internal/internal.h"
@@ -184,6 +185,30 @@ static struct nfct_labelmap *map_alloc(void)
 	return map;
 }
 
+/*
+ * We will only accept alpha numerical labels; else
+ * parses might choke on output when label named
+ * "foo;<&bar" exists.  ASCII machines only.
+ *
+ * Avoids libc isalnum() etc. to avoid issues with locale
+ * settings.
+ */
+static bool label_is_sane(const char *label)
+{
+	for (;*label; label++) {
+		if (*label >= 'a' && *label <= 'z')
+			continue;
+		if (*label >= 'A' && *label <= 'Z')
+			continue;
+		if (*label >= '0' && *label <= '9')
+			continue;
+		if (*label == ' ' || *label == '-')
+			continue;
+		return false;
+	}
+	return true;
+}
+
 struct nfct_labelmap *__labelmap_new(const char *name)
 {
 	struct nfct_labelmap *map;
@@ -219,7 +244,8 @@ struct nfct_labelmap *__labelmap_new(const char *name)
 		end = trim_label(end);
 		if (!end)
 			continue;
-		if (map_insert(map, end, bit) == 0) {
+
+		if (label_is_sane(end) && map_insert(map, end, bit) == 0) {
 			added++;
 			if (maxbit < bit)
 				maxbit = bit;
-- 
1.8.1.5

