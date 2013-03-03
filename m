From: Eric Leblond <eric@regit.org>
Subject: [PATCH] nfct: use timestamp of conntrack object.
Date: Sun,  3 Mar 2013 23:10:58 +0100
Message-ID: <1362348658-19291-2-git-send-email-eric@regit.org>
References: <1362348658-19291-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:43622 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432Ab3CCWLn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Mar 2013 17:11:43 -0500
In-Reply-To: <1362348658-19291-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If conntrack object sent by connection tracking system is containing
a timestamp we use it instead of a gettimeofday() based counter.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 input/flow/ulogd_inpflow_NFCT.c |   42 +++++++++++++++++++++++++++++----------
 1 file changed, 32 insertions(+), 10 deletions(-)

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index 3889b10..d9dae66 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -48,6 +48,10 @@
 
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
 
+#ifndef NSEC_PER_SEC
+#define NSEC_PER_SEC    1000000000L
+#endif
+
 typedef enum TIMES_ { START, STOP, __TIME_MAX } TIMES;
 
 struct ct_timestamp {
@@ -617,6 +621,25 @@ do_propagate_ct(struct ulogd_pluginstance *upi,
 	propagate_ct(upi, upi, ct, type, ts);
 }
 
+static void _set_timestamp_from_ct(struct ct_timestamp *ts,
+				   struct nf_conntrack *ct, int name)
+{
+	int attr_name;
+
+	if (name == START)
+		attr_name = ATTR_TIMESTAMP_START;
+	else
+		attr_name = ATTR_TIMESTAMP_STOP;
+
+	if (nfct_attr_is_set(ct, attr_name)) {
+		ts->time[name].tv_sec =
+		     nfct_get_attr_u64(ct, attr_name) / NSEC_PER_SEC;
+		ts->time[name].tv_usec =
+		     (nfct_get_attr_u64(ct, attr_name) % NSEC_PER_SEC) / 1000;
+	} else
+		gettimeofday(&ts->time[name], NULL);
+}
+
 static int
 event_handler_hashtable(enum nf_conntrack_msg_type type,
 			struct nf_conntrack *ct, void *data)
@@ -634,8 +657,8 @@ event_handler_hashtable(enum nf_conntrack_msg_type type,
 			return NFCT_CB_CONTINUE;
 
 		ts->ct = ct;
-		gettimeofday(&ts->time[START], NULL);
 
+		_set_timestamp_from_ct(ts, ct, START);
 		id = hashtable_hash(cpi->ct_active, ct);
 		ret = hashtable_add(cpi->ct_active, &ts->hashnode, id);
 		if (ret < 0) {
@@ -655,8 +678,7 @@ event_handler_hashtable(enum nf_conntrack_msg_type type,
 				return NFCT_CB_CONTINUE;
 
 			ts->ct = ct;
-			gettimeofday(&ts->time[START], NULL);
-
+			_set_timestamp_from_ct(ts, ct, START);
 			ret = hashtable_add(cpi->ct_active, &ts->hashnode, id);
 			if (ret < 0) {
 				free(ts);
@@ -670,7 +692,7 @@ event_handler_hashtable(enum nf_conntrack_msg_type type,
 		ts = (struct ct_timestamp *)
 			hashtable_find(cpi->ct_active, ct, id);
 		if (ts) {
-			gettimeofday(&ts->time[STOP], NULL);
+			_set_timestamp_from_ct(ts, ct, STOP);
 			do_propagate_ct(upi, ct, type, ts);
 			hashtable_del(cpi->ct_active, &ts->hashnode);
 			nfct_destroy(ts->ct);
@@ -679,7 +701,7 @@ event_handler_hashtable(enum nf_conntrack_msg_type type,
 			struct ct_timestamp tmp = {
 				.ct = ct,
 			};
-			gettimeofday(&tmp.time[STOP], NULL);
+			_set_timestamp_from_ct(&tmp, ct, STOP);
 			tmp.time[START].tv_sec = 0;
 			tmp.time[START].tv_usec = 0;
 			do_propagate_ct(upi, ct, type, &tmp);
@@ -704,12 +726,12 @@ event_handler_no_hashtable(enum nf_conntrack_msg_type type,
 
 	switch(type) {
 	case NFCT_T_NEW:
-		gettimeofday(&tmp.time[START], NULL);
+		_set_timestamp_from_ct(&tmp, ct, START);
 		tmp.time[STOP].tv_sec = 0;
 		tmp.time[STOP].tv_usec = 0;
 		break;
 	case NFCT_T_DESTROY:
-		gettimeofday(&tmp.time[STOP], NULL);
+		_set_timestamp_from_ct(&tmp, ct, STOP);
 		tmp.time[START].tv_sec = 0;
 		tmp.time[START].tv_usec = 0;
 		break;
@@ -744,7 +766,7 @@ polling_handler(enum nf_conntrack_msg_type type,
 				return NFCT_CB_CONTINUE;
 
 			ts->ct = ct;
-			gettimeofday(&ts->time[START], NULL);
+			_set_timestamp_from_ct(ts, ct, START);
 
 			ret = hashtable_add(cpi->ct_active, &ts->hashnode, id);
 			if (ret < 0) {
@@ -881,7 +903,7 @@ static int overrun_handler(enum nf_conntrack_msg_type type,
 			return NFCT_CB_CONTINUE;
 
 		ts->ct = ct;
-		gettimeofday(&ts->time[START], NULL); /* do our best here */
+		_set_timestamp_from_ct(ts, ct, START);
 
 		ret = hashtable_add(cpi->ct_active, &ts->hashnode, id);
 		if (ret < 0) {
@@ -944,7 +966,7 @@ dump_reset_handler(enum nf_conntrack_msg_type type,
 				return NFCT_CB_CONTINUE;
 
 			ts->ct = ct;
-			gettimeofday(&ts->time[START], NULL);
+			_set_timestamp_from_ct(ts, ct, START);
 
 			rc = hashtable_add(cpi->ct_active, &ts->hashnode, id);
 			if (rc < 0) {
-- 
1.7.10.4

