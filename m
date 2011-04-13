From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 15/26] libxtables: XTTYPE_UINT16 support
Date: Wed, 13 Apr 2011 18:13:36 +0200
Message-ID: <1302711228-15947-16-git-send-email-jengelh@medozas.de>
References: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42463 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933062Ab1DMQOG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:14:06 -0400
In-Reply-To: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/xtables.h.in |    3 ++-
 xtoptions.c          |    8 ++++++++
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index 325c04c..6167f4d 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -55,6 +55,7 @@ struct in_addr;
 enum xt_option_type {
 	XTTYPE_NONE,
 	XTTYPE_UINT8,
+	XTTYPE_UINT16,
 	XTTYPE_UINT32,
 	XTTYPE_UINT64,
 	XTTYPE_UINT8RC,
@@ -118,7 +119,7 @@ struct xt_option_call {
 	uint8_t nvals;
 	union {
 		uint8_t u8, u8_range[2];
-		uint16_t u16_range[2];
+		uint16_t u16, u16_range[2];
 		uint32_t u32, u32_range[2];
 		uint64_t u64, u64_range[2];
 		struct {
diff --git a/xtoptions.c b/xtoptions.c
index a74938f..939e686 100644
--- a/xtoptions.c
+++ b/xtoptions.c
@@ -92,6 +92,8 @@ static void xtopt_parse_int(struct xt_option_call *cb)
 
 	if (entry->type == XTTYPE_UINT8)
 		lmax = UINT8_MAX;
+	else if (entry->type == XTTYPE_UINT16)
+		lmax = UINT16_MAX;
 	else if (entry->type == XTTYPE_UINT64)
 		lmax = UINT64_MAX;
 	if (cb->entry->min != 0)
@@ -109,6 +111,10 @@ static void xtopt_parse_int(struct xt_option_call *cb)
 		cb->val.u8 = value;
 		if (entry->flags & XTOPT_PUT)
 			*(uint8_t *)XTOPT_MKPTR(cb) = cb->val.u8;
+	} else if (entry->type == XTTYPE_UINT16) {
+		cb->val.u16 = value;
+		if (entry->flags & XTOPT_PUT)
+			*(uint16_t *)XTOPT_MKPTR(cb) = cb->val.u16;
 	} else if (entry->type == XTTYPE_UINT32) {
 		cb->val.u32 = value;
 		if (entry->flags & XTOPT_PUT)
@@ -247,6 +253,7 @@ static void xtopt_parse_markmask(struct xt_option_call *cb)
 
 static void (*const xtopt_subparse[])(struct xt_option_call *) = {
 	[XTTYPE_UINT8]       = xtopt_parse_int,
+	[XTTYPE_UINT16]      = xtopt_parse_int,
 	[XTTYPE_UINT32]      = xtopt_parse_int,
 	[XTTYPE_UINT64]      = xtopt_parse_int,
 	[XTTYPE_UINT8RC]     = xtopt_parse_mint,
@@ -259,6 +266,7 @@ static void (*const xtopt_subparse[])(struct xt_option_call *) = {
 
 static const size_t xtopt_psize[] = {
 	[XTTYPE_UINT8]       = sizeof(uint8_t),
+	[XTTYPE_UINT16]      = sizeof(uint16_t),
 	[XTTYPE_UINT32]      = sizeof(uint32_t),
 	[XTTYPE_UINT64]      = sizeof(uint64_t),
 	[XTTYPE_UINT8RC]     = sizeof(uint8_t[2]),
-- 
1.7.1

