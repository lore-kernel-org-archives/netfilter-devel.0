From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 17/18] Fix memory leak in destructor_nfct().
Date: Mon,  1 Dec 2008 22:36:15 +0100
Message-ID: <1228167376-22101-18-git-send-email-eric@inl.fr>
References: <1228167376-22101-1-git-send-email-eric@inl.fr>
Cc: pablo@netfilter.org, Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:39320 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752637AbYLAVgW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Dec 2008 16:36:22 -0500
In-Reply-To: <1228167376-22101-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes a memroy leak in the destructor function which was not
releasing the memory allocated for each connection tracking entry.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 input/flow/ulogd_inpflow_NFCT.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index a39bf08..1730ec9 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -692,6 +692,13 @@ static int read_cb_nfct(int fd, unsigned int what, void *param)
 	return 0;
 }
 
+static int do_free(void *data1, void *data2)
+{
+	struct ct_timestamp *ts = data2;
+	free(ts->ct);
+}
+
+
 static int do_purge(void *data1, void *data2)
 {
 	int ret;
@@ -887,6 +894,9 @@ static int destructor_nfct(struct ulogd_pluginstance *pi)
 	struct nfct_pluginstance *cpi = (void *) pi->private;
 	int rc;
 
+	/* free existent entries */
+	hashtable_iterate(cpi->ct_active, NULL, do_free);
+
 	hashtable_destroy(cpi->ct_active);
 
 	rc = nfct_close(cpi->cth);
-- 
1.5.6.3

