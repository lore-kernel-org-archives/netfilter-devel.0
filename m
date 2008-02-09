From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 1/5] Fix treatment of return from function
Date: Sat,  9 Feb 2008 13:36:31 +0100
Message-ID: <12025605953450-git-send-email-eric@inl.fr>
References: <12025605952271-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:54966 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753256AbYBIMgh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 9 Feb 2008 07:36:37 -0500
In-Reply-To: <12025605952271-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The treatment of the return of some functions from libnetfilter_log API was wrong and this
was preventing some fields to be propagated through the stack.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
:100644 100644 be46fa2... 1b8e32c... M	input/packet/ulogd_inppkt_NFLOG.c
 input/packet/ulogd_inppkt_NFLOG.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt_NFLOG.c
index be46fa2..1b8e32c 100644
--- a/input/packet/ulogd_inppkt_NFLOG.c
+++ b/input/packet/ulogd_inppkt_NFLOG.c
@@ -317,11 +317,11 @@ interp_packet(struct ulogd_pluginstance *upi, struct nflog_data *ldata)
 		ret[NFLOG_KEY_OOB_IFINDEX_OUT].flags |= ULOGD_RETF_VALID;
 	}
 
-	if (nflog_get_seq(ldata, &seq)) {
+	if (nflog_get_seq(ldata, &seq) == 0) {
 		ret[NFLOG_KEY_OOB_SEQ_LOCAL].u.value.ui32 = seq;
 		ret[NFLOG_KEY_OOB_SEQ_LOCAL].flags |= ULOGD_RETF_VALID;
 	}
-	if (nflog_get_seq_global(ldata, &seq)) {
+	if (nflog_get_seq_global(ldata, &seq) == 0) {
 		ret[NFLOG_KEY_OOB_SEQ_GLOBAL].u.value.ui32 = seq;
 		ret[NFLOG_KEY_OOB_SEQ_GLOBAL].flags |= ULOGD_RETF_VALID;
 	}
-- 
1.5.2.5

