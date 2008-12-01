From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 09/18] Fix stop function of NFCT plugin.
Date: Mon,  1 Dec 2008 22:36:07 +0100
Message-ID: <1228167376-22101-10-git-send-email-eric@inl.fr>
References: <1228167376-22101-1-git-send-email-eric@inl.fr>
Cc: pablo@netfilter.org, Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:39302 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752269AbYLAVgV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Dec 2008 16:36:21 -0500
In-Reply-To: <1228167376-22101-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes some crashes in NFCT plugin that were triggered
by the call of the destructor_nfct function (during stop).

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 input/flow/ulogd_inpflow_NFCT.c |    2 +-
 src/hash.c                      |    6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index a33ec35..a39bf08 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -884,7 +884,7 @@ static int constructor_nfct(struct ulogd_pluginstance *upi)
 
 static int destructor_nfct(struct ulogd_pluginstance *pi)
 {
-	struct nfct_pluginstance *cpi = (void *) pi;
+	struct nfct_pluginstance *cpi = (void *) pi->private;
 	int rc;
 
 	hashtable_destroy(cpi->ct_active);
diff --git a/src/hash.c b/src/hash.c
index 33541e8..700678c 100644
--- a/src/hash.c
+++ b/src/hash.c
@@ -75,8 +75,10 @@ hashtable_create(int hashsize, int limit, int datasize,
 
 void hashtable_destroy(struct hashtable *h)
 {
-	hashtable_flush(h);
-	free(h);
+	if (h) {
+		hashtable_flush(h);
+		free(h);
+	}
 }
 
 void *hashtable_add(struct hashtable *table, void *data)
-- 
1.5.6.3

