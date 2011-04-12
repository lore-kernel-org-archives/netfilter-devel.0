From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 01/28] libxtables: XTTYPE_UINT8 support
Date: Tue, 12 Apr 2011 16:23:16 +0200
Message-ID: <1302618224-9449-2-git-send-email-jengelh@medozas.de>
References: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51080 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755069Ab1DLOXr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:23:47 -0400
In-Reply-To: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/xtables.h.in |    2 ++
 xtoptions.c          |   10 +++++++++-
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index 14d7b04..dc074bc 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -51,6 +51,7 @@ struct in_addr;
  */
 enum xt_option_type {
 	XTTYPE_NONE,
+	XTTYPE_UINT8,
 	XTTYPE_UINT32,
 };
 
@@ -104,6 +105,7 @@ struct xt_option_call {
 	unsigned int xflags;
 	bool invert;
 	union {
+		uint8_t u8;
 		uint32_t u32;
 	} val;
 };
diff --git a/xtoptions.c b/xtoptions.c
index 6a119ec..693c06d 100644
--- a/xtoptions.c
+++ b/xtoptions.c
@@ -89,6 +89,8 @@ static void xtopt_parse_int(struct xt_option_call *cb)
 	unsigned int lmin = 0, lmax = UINT32_MAX;
 	unsigned int value;
 
+	if (entry->type == XTTYPE_UINT8)
+		lmax = UINT8_MAX;
 	if (cb->entry->min != 0)
 		lmin = cb->entry->min;
 	if (cb->entry->max != 0)
@@ -100,7 +102,11 @@ static void xtopt_parse_int(struct xt_option_call *cb)
 			"or out of range (%u-%u).\n",
 			cb->ext_name, entry->name, lmin, lmax);
 
-	if (entry->type == XTTYPE_UINT32) {
+	if (entry->type == XTTYPE_UINT8) {
+		cb->val.u8 = value;
+		if (entry->flags & XTOPT_PUT)
+			*(uint8_t *)XTOPT_MKPTR(cb) = cb->val.u8;
+	} else if (entry->type == XTTYPE_UINT32) {
 		cb->val.u32 = value;
 		if (entry->flags & XTOPT_PUT)
 			*(uint32_t *)XTOPT_MKPTR(cb) = cb->val.u32;
@@ -108,10 +114,12 @@ static void xtopt_parse_int(struct xt_option_call *cb)
 }
 
 static void (*const xtopt_subparse[])(struct xt_option_call *) = {
+	[XTTYPE_UINT8]       = xtopt_parse_int,
 	[XTTYPE_UINT32]      = xtopt_parse_int,
 };
 
 static const size_t xtopt_psize[] = {
+	[XTTYPE_UINT8]       = sizeof(uint8_t),
 	[XTTYPE_UINT32]      = sizeof(uint32_t),
 };
 
-- 
1.7.1

