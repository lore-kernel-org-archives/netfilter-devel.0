From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 8/8] Duplication of message in NFCT input plugin
Date: Sun,  9 Mar 2008 23:36:29 +0100
Message-ID: <1205102190545-git-send-email-eric@inl.fr>
References: <12051021893015-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:57603 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753456AbYCIWgc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Mar 2008 18:36:32 -0400
In-Reply-To: <12051021893015-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds support for duplication of the message to be
able to use multiple time the same instance of NFCT.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 input/flow/ulogd_inpflow_NFCT.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index 7d3aa91..1843acb 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -559,8 +559,10 @@ static int event_handler(void *arg, unsigned int flags, int type,
 {
 	struct nfct_conntrack *ct = arg;
 	struct ulogd_pluginstance *upi = data;
+	struct ulogd_pluginstance *npi = NULL;
 	struct nfct_pluginstance *cpi = 
 				(struct nfct_pluginstance *) upi->private;
+	int ret = 0;
 
 	if (type == NFCT_MSG_NEW) {
 		if (usehash_ce(upi->config_kset).u.value != 0)
@@ -571,6 +573,11 @@ static int event_handler(void *arg, unsigned int flags, int type,
 		if (usehash_ce(upi->config_kset).u.value != 0)
 			ts = ct_hash_get(cpi->ct_active, ct->id);
 
+		llist_for_each_entry(npi, &upi->plist, plist) {
+			ret = propagate_ct(npi, ct, flags, ts);
+			if (ret != 0)
+				return ret;
+		}
 		return propagate_ct(upi, ct, flags, ts);
 	}
 	return 0;
-- 
1.5.4.3

