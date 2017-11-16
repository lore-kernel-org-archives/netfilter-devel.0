From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH] libnftables: Fix for multiple context instances
Date: Thu, 16 Nov 2017 20:10:24 +0100
Message-ID: <20171116191024.18908-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:32772 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934335AbdKPTKg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Nov 2017 14:10:36 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If a second context is created, the second call to nft_ctx_free() leads
to freeing invalid pointers in nft_exit(). Fix this by introducing a
reference counter so that neither nft_init() nor nft_exit() run more
than once in a row.

This reference counter has to be protected from parallel access. Do this
using a mutex in a way that once nft_init() returns, the first call to
that function running in parallel is guaranteed to be finished -
otherwise it could happen that things being initialized in one thread
are already accessed in another one.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/libnftables.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/src/libnftables.c b/src/libnftables.c
index e8fa6742f7d17..9df9658930c39 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -14,6 +14,7 @@
 #include <iface.h>
 
 #include <errno.h>
+#include <pthread.h>
 #include <stdlib.h>
 #include <string.h>
 
@@ -102,8 +103,16 @@ err1:
 	return ret;
 }
 
+static int nft_refcnt;
+static pthread_mutex_t nft_refcnt_mutex = PTHREAD_MUTEX_INITIALIZER;
+
 static void nft_init(void)
 {
+	pthread_mutex_lock(&nft_refcnt_mutex);
+
+	if (nft_refcnt++)
+		goto unlock;
+
 	mark_table_init();
 	realm_table_rt_init();
 	devgroup_table_init();
@@ -113,15 +122,26 @@ static void nft_init(void)
 #ifdef HAVE_LIBXTABLES
 	xt_init();
 #endif
+
+unlock:
+	pthread_mutex_unlock(&nft_refcnt_mutex);
 }
 
 static void nft_exit(void)
 {
+	pthread_mutex_lock(&nft_refcnt_mutex);
+
+	if (--nft_refcnt)
+		goto unlock;
+
 	ct_label_table_exit();
 	realm_table_rt_exit();
 	devgroup_table_exit();
 	realm_table_meta_exit();
 	mark_table_exit();
+
+unlock:
+	pthread_mutex_unlock(&nft_refcnt_mutex);
 }
 
 int nft_ctx_add_include_path(struct nft_ctx *ctx, const char *path)
-- 
2.13.1

