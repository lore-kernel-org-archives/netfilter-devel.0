From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 2/4] Improve IPFIX state.
Date: Wed, 23 Jul 2008 13:33:53 +0200
Message-ID: <1216812835-9851-3-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:43427 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751433AbYGWLd5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jul 2008 07:33:57 -0400
In-Reply-To: <>
References: <>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

IPFIX needs some huge work. This patch fixes some basic logic errors.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 output/ulogd_output_IPFIX.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/output/ulogd_output_IPFIX.c b/output/ulogd_output_IPFIX.c
index 9004e4d..88964ef 100644
--- a/output/ulogd_output_IPFIX.c
+++ b/output/ulogd_output_IPFIX.c
@@ -38,6 +38,8 @@
 #include <sys/socket.h>
 #include <netdb.h>
 
+#include <ulogd/linuxlist.h>
+
 #ifdef IPPROTO_SCTP
 /* temporarily disable sctp until we know which headers to use */
 #undef IPPROTO_SCTP
@@ -139,7 +141,7 @@ int bitmasks_equal(const struct bitmask *bm1, const struct bitmask *bm2)
 struct bitmask *bitmask_dup(const struct bitmask *bm_orig)
 {
 	struct bitmask *bm_new;
-	int size = sizoef(*bm_new) + SIZE_OCTETS(bm_orig->size_bits);
+	int size = sizeof(*bm_new) + SIZE_OCTETS(bm_orig->size_bits);
 
 	bm_new = malloc(size);
 	if (!bm_new)
@@ -222,13 +224,13 @@ build_template_for_bitmask(struct ulogd_pluginstance *upi,
 
 	tmpl = malloc(size);
 	if (!tmpl)
-		return -ENOMEM;
+		return NULL;
 	memset(tmpl, 0, size);
 
-	tmpl->bitmask = dup_bitmask(bm);
+	tmpl->bitmask = bitmask_dup(bm);
 	if (!tmpl->bitmask) {
 		free(tmpl);
-		return -ENOMEM;
+		return NULL;
 	}
 
 	/* initialize template header */
@@ -280,7 +282,7 @@ build_template_for_bitmask(struct ulogd_pluginstance *upi,
 
 	tmpl->tmpl.hdr.field_count = htons(j);
 
-	return 0;
+	return tmpl;
 }
 
 
-- 
1.5.4.3

