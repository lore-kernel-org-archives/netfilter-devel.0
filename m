From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 4/4] Suppress usage of deprecated enum
Date: Thu, 15 May 2008 00:54:39 +0200
Message-ID: <1210805679-11813-5-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:33856 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752588AbYENWy3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 May 2008 18:54:29 -0400
In-Reply-To: <>
References: <>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes a problem linked with the usage of a deprecated enum.
This was causing the misdetection of DESTROY message.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 input/flow/ulogd_inpflow_NFCT.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index cce06aa..ef6232e 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -608,7 +608,7 @@ static int event_handler(enum nf_conntrack_msg_type type,
 	struct ulogd_pluginstance *npi = NULL;
 	int ret = 0;
 
-	if (type == NFCT_MSG_NEW) {
+	if (type == NF_NETLINK_CONNTRACK_NEW) {
 		if (usehash_ce(upi->config_kset).u.value != 0) {
 			ct_hash_add(cpi->ct_active, nfct_get_attr_u32(ct, ATTR_ID));
 			return 0;
@@ -617,7 +617,7 @@ static int event_handler(enum nf_conntrack_msg_type type,
 			gettimeofday(&ts->time[START], NULL);
 			ts->time[STOP].tv_sec = 0;
 		}
-	} else if (type == NFCT_MSG_DESTROY) {
+	} else if (type == NF_NETLINK_CONNTRACK_DESTROY) {
 		if (usehash_ce(upi->config_kset).u.value != 0)
 			ts = ct_hash_get(cpi->ct_active, nfct_get_attr_u32(ct, ATTR_ID));
 		else {
-- 
1.5.4.3

