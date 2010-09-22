From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 5/6] filter_MARK: code factorization.
Date: Wed, 22 Sep 2010 02:47:21 +0200
Message-ID: <1285116442-32490-6-git-send-email-eric@inl.fr>
References: <1285116442-32490-1-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:50846 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755604Ab0IVBEz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Sep 2010 21:04:55 -0400
In-Reply-To: <1285116442-32490-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch brings a light factorization in the decision making
process.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 filter/ulogd_filter_MARK.c |   24 +++++++++++-------------
 1 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/filter/ulogd_filter_MARK.c b/filter/ulogd_filter_MARK.c
index 1a7c2fd..85c146c 100644
--- a/filter/ulogd_filter_MARK.c
+++ b/filter/ulogd_filter_MARK.c
@@ -71,20 +71,18 @@ static struct ulogd_key mark_inp[] = {
 static int interp_mark(struct ulogd_pluginstance *pi)
 {
 	struct ulogd_key *inp = pi->input.keys;
-	if (pp_is_valid(inp, KEY_CT_MARK)) {
-		if ((ikey_get_u32(&inp[KEY_CT_MARK]) &
-			pi->config_kset->ces[MARK_MASK].u.value) !=
+	int index = 0;
+	if (pp_is_valid(inp, KEY_CT_MARK))
+		index = KEY_CT_MARK;
+	else if (pp_is_valid(inp, KEY_OOB_MARK))
+		index = KEY_OOB_MARK;
+	else
+		return ULOGD_IRET_OK;
+	if ((ikey_get_u32(&inp[index]) &
+				pi->config_kset->ces[MARK_MASK].u.value) !=
 			(u_int32_t) pi->config_kset->ces[MARK_MARK].u.value
-		   ) {
-			return ULOGD_IRET_STOP;
-		}
-	} else if (pp_is_valid(inp, KEY_OOB_MARK)) {
-		if ((ikey_get_u32(&inp[KEY_OOB_MARK]) &
-			pi->config_kset->ces[MARK_MASK].u.value) !=
-			(u_int32_t) pi->config_kset->ces[MARK_MARK].u.value
-		   ) {
-			return ULOGD_IRET_STOP;
-		}
+	   ) {
+		return ULOGD_IRET_STOP;
 	}
 	return ULOGD_IRET_OK;	
 }
-- 
1.6.1

