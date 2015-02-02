From: Jarno Rajahalme <jrajahalme@nicira.com>
Subject: [PATCH] Fix setting labels in updates.
Date: Mon,  2 Feb 2015 12:35:12 -0800
Message-ID: <1422909312-72122-1-git-send-email-jrajahalme@nicira.com>
Cc: jrajahalme@nicira.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from na3sys009aog136.obsmtp.com ([74.125.149.85]:57075 "HELO
	na3sys009aog136.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S964902AbbBBUg3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Feb 2015 15:36:29 -0500
Received: by mail-pa0-f44.google.com with SMTP id rd3so86595609pab.3
        for <netfilter-devel@vger.kernel.org>; Mon, 02 Feb 2015 12:36:28 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When updating labels we always have to send the same sized bitmask as
we received, as the bits we do omit will otherwise cleared as "padding".

Mask has to have the same size as the labels, otherwise it will not be
encoded by libnetfilter_conntrack, as different sizes are not accepted
by the kernel either.

Finally, kernel only retains old bit values that we send as zeroes in
BOTH the label and the mask, due to XOR used in bit manipulation.

This patch fixes all these issues and allows updates to set new labels
without accidentally clearing old ones.

Signed-off-by: Jarno Rajahalme <jrajahalme@nicira.com>
---
 src/conntrack.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 1e45ca8..97564f9 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -1422,17 +1422,29 @@ static void copy_label(struct nf_conntrack *tmp, const struct nf_conntrack *ct)
 
 	if (options & CT_OPT_ADD_LABEL) {
 		if (ctb == NULL) {
-			newmask = xnfct_bitmask_clone(tmpl.label_modify);
-			nfct_set_attr(tmp, ATTR_CONNLABELS, newmask);
+			nfct_set_attr(tmp, ATTR_CONNLABELS,
+					xnfct_bitmask_clone(tmpl.label_modify));
 			return;
 		}
+		/* If we send a bitmask shorter than the kernel sent to us, the bits we
+		   omit will be cleared (as "padding").  So we always have to send the
+		   same sized bitmask as we received.
+
+		   Mask has to have the same size as the labels, otherwise it will not
+		   be encoded by libnetfilter_conntrack, as different sizes are not
+		   accepted by the kernel. */
+		newmask = nfct_bitmask_new(nfct_bitmask_maxbit(ctb));
 
 		for (i = 0; i <= nfct_bitmask_maxbit(ctb); i++) {
-			if (nfct_bitmask_test_bit(tmpl.label_modify, i))
+			if (nfct_bitmask_test_bit(tmpl.label_modify, i)) {
 				nfct_bitmask_set_bit(ctb, i);
+				nfct_bitmask_set_bit(newmask, i);
+			} else if (nfct_bitmask_test_bit(ctb, i)) {
+				/* Kernel only retains old bit values that are sent as
+				   zeroes in BOTH labels and mask. */
+				nfct_bitmask_unset_bit(ctb, i);
+			}
 		}
-
-		newmask = xnfct_bitmask_clone(tmpl.label_modify);
 		nfct_set_attr(tmp, ATTR_CONNLABELS_MASK, newmask);
 	} else if (ctb != NULL) {
 		/* CT_OPT_DEL_LABEL */
-- 
1.7.10.4

