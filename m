From: Florian Westphal <fw@strlen.de>
Subject: [PATCH] qa: fix handling of ATTR_HELPER_INFO attribute
Date: Mon, 19 Nov 2012 22:40:32 +0100
Message-ID: <1353361232-2437-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:53906 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752331Ab2KSVqO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Nov 2012 16:46:14 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The attribute is variable-length and must be thus be set via set_attr_l().

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 I'll push this in a couple of days if noone objects.

 qa/test_api.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/qa/test_api.c b/qa/test_api.c
index 92cdafb..3c0f0f9 100644
--- a/qa/test_api.c
+++ b/qa/test_api.c
@@ -83,9 +83,6 @@ int main(void)
 	ret = fork();
 	if (ret == 0) {
 		for (i=0; i<ATTR_MAX; i++) {
-			data[0] = (uint8_t) i;
-			nfct_set_attr(ct, i, data);
-			val = nfct_get_attr(ct, i);
 			/* These attributes cannot be set, ignore them. */
 			switch(i) {
 			case ATTR_ORIG_COUNTER_PACKETS:
@@ -96,8 +93,18 @@ int main(void)
 			case ATTR_SECCTX:
 			case ATTR_TIMESTAMP_START:
 			case ATTR_TIMESTAMP_STOP:
+			case ATTR_CONNLABELS:
 				continue;
+			/* These attributes require special handling */
+			case ATTR_HELPER_INFO:
+				nfct_set_attr_l(ct, i, data, sizeof(data));
+				break;
+			default:
+				data[0] = (uint8_t) i;
+				nfct_set_attr(ct, i, data);
 			}
+			val = nfct_get_attr(ct, i);
+
 			if (val[0] != data[0]) {
 				printf("ERROR: set/get operations don't match "
 				       "for attribute %d (%x != %x)\n",
-- 
1.7.8.6

