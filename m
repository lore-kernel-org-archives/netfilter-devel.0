From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: [conntrack-tools PATCH 2/4] conntrackd: warn users about queue
 allocation errors
Date: Thu, 20 Apr 2017 19:28:06 +0200
Message-ID: <149270928606.1751.8172963085482513292.stgit@nfdev2.cica.es>
References: <149270928083.1751.9498250834672625764.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:36723 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S938918AbdDTR2O (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Apr 2017 13:28:14 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id 5D90951F360
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Apr 2017 17:28:12 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id sxxRpomRyc63 for <netfilter-devel@vger.kernel.org>;
        Thu, 20 Apr 2017 19:28:06 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id C09A351F35C
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Apr 2017 19:28:06 +0200 (CEST)
In-Reply-To: <149270928083.1751.9498250834672625764.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These warnings, if they happen, should help users.

Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
---
 src/channel.c  |    6 +++++-
 src/queue_tx.c |   11 +++++++++--
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/src/channel.c b/src/channel.c
index acbfa7d..b2f114d 100644
--- a/src/channel.c
+++ b/src/channel.c
@@ -19,6 +19,7 @@
 #include "channel.h"
 #include "network.h"
 #include "queue.h"
+#include "log.h"
 
 static struct channel_ops *ops[CHANNEL_MAX];
 extern struct channel_ops channel_mcast;
@@ -161,8 +162,11 @@ static void channel_enqueue_errors(struct channel *c)
 	struct channel_error *error;
 
 	qobj = queue_object_new(Q_ELEM_ERR, sizeof(struct channel_error));
-	if (qobj == NULL)
+	if (qobj == NULL) {
+		dlog(LOG_WARNING, "could not enqueue channel errors, failed to"
+		     " allocate memory");
 		return;
+	}
 
 	error		= (struct channel_error *)qobj->data;
 	error->len	= c->buffer->len;
diff --git a/src/queue_tx.c b/src/queue_tx.c
index 0c99163..83eb111 100644
--- a/src/queue_tx.c
+++ b/src/queue_tx.c
@@ -22,6 +22,7 @@
 #include "queue.h"
 #include "conntrackd.h"
 #include "network.h"
+#include "log.h"
 
 void tx_queue_add_ctlmsg(uint32_t flags, uint32_t from, uint32_t to)
 {
@@ -29,8 +30,11 @@ void tx_queue_add_ctlmsg(uint32_t flags, uint32_t from, uint32_t to)
 	struct nethdr_ack *ack;
 
 	qobj = queue_object_new(Q_ELEM_CTL, sizeof(struct nethdr_ack));
-	if (qobj == NULL)
+	if (qobj == NULL) {
+		dlog(LOG_WARNING, "could not queue ACK message. Failed to "
+		     "allocate memory");
 		return;
+	}
 
 	ack		= (struct nethdr_ack *)qobj->data;
 	ack->type 	= NET_T_CTL;
@@ -48,8 +52,11 @@ void tx_queue_add_ctlmsg2(uint32_t flags)
 	struct nethdr *ctl;
 
 	qobj = queue_object_new(Q_ELEM_CTL, sizeof(struct nethdr_ack));
-	if (qobj == NULL)
+	if (qobj == NULL) {
+		dlog(LOG_WARNING, "could not queue CTL message. Failed to "
+		     "allocate memory");
 		return;
+	}
 
 	ctl		= (struct nethdr *)qobj->data;
 	ctl->type 	= NET_T_CTL;

