From: Anatole Denis <anatole@rezel.net>
Subject: [PATCH nft] erec: Fix input descriptors for included files
Date: Tue, 21 Feb 2017 15:48:05 +0100
Message-ID: <20170221144805.22472-1-anatole@rezel.net>
Cc: Anatole Denis <anatole@rezel.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from inara.rezel.net ([212.129.30.46]:57114 "EHLO inara.rezel.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752529AbdBUO7T (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Feb 2017 09:59:19 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently, when creating an error record (erec), the current location in the
file is duplicated, but not the input_descriptor inside it. Input descriptors
are added and removed by the parser when including files, and memory references
in the error record thus become incorrect when a subsequent file is included.

This patch copies the input descriptors recursively to ensure each erec has the
correct chain of input descriptors at the time of printing.

For example:
badinclude.nft:
```
include "error.nft"
include "empty.nft"
```
a.nft:
```
add rule t c obvious syntax error
```
b.nft: (empty file)

Results in the last included file being referenced and quoted for all errors
$ nft -f badinclude.nft
In file included from badinclude.nft:2:1-20:
./empty.nft:1:34-34: Error: syntax error, unexpected newline

                                 ^

Expected behavior:
$ nft -f badinclude.nft -I.
In file included from badinclude.nft:1:1-20:
./error.nft:1:34-34: Error: syntax error, unexpected newline
add rule t c obvious syntax error
                                 ^

Signed-off-by: Anatole Denis <anatole@rezel.net>
---
 src/erec.c | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/src/erec.c b/src/erec.c
index 3603216..eacdd97 100644
--- a/src/erec.c
+++ b/src/erec.c
@@ -33,15 +33,45 @@ static const char *error_record_names[] = {
 	[EREC_ERROR]		= "Error"
 };
 
+static void input_descriptor_destroy(const struct input_descriptor *indesc)
+{
+	if (indesc->location.indesc &&
+	    indesc->location.indesc->type != INDESC_INTERNAL) {
+		input_descriptor_destroy(indesc->location.indesc);
+	}
+	xfree(indesc);
+}
+
+static struct input_descriptor *input_descriptor_dup(const struct input_descriptor *indesc)
+{
+	struct input_descriptor *dup_indesc;
+
+	dup_indesc = xmalloc(sizeof(struct input_descriptor));
+	*dup_indesc = *indesc;
+
+	if (indesc->location.indesc &&
+	    indesc->location.indesc->type != INDESC_INTERNAL)
+		dup_indesc->location.indesc = input_descriptor_dup(indesc->location.indesc);
+
+	return dup_indesc;
+}
+
 void erec_add_location(struct error_record *erec, const struct location *loc)
 {
 	assert(erec->num_locations < EREC_LOCATIONS_MAX);
-	erec->locations[erec->num_locations++] = *loc;
+	erec->locations[erec->num_locations] = *loc;
+	erec->locations[erec->num_locations].indesc = input_descriptor_dup(loc->indesc);
+	erec->num_locations++;
 }
 
 static void erec_destroy(struct error_record *erec)
 {
+	unsigned int i;
+
 	xfree(erec->msg);
+	for (i = 0; i < erec->num_locations; i++) {
+		input_descriptor_destroy(erec->locations[i].indesc);
+	}
 	xfree(erec);
 }
 
-- 
2.11.1

