From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/6] NFCT: use new hashtable implementation for better
	performance
Date: Wed, 13 Jan 2010 12:43:12 +0100
Message-ID: <20100113114312.12994.7680.stgit@decadence>
References: <20100113114009.12994.26386.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35917 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754912Ab0AMLnu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jan 2010 06:43:50 -0500
In-Reply-To: <20100113114009.12994.26386.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch replaces the existing hashtable implementation with
a newer that provide better performance since it reduces the
number of hash computations.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/ulogd/hash.h            |   34 +++-----
 input/flow/ulogd_inpflow_NFCT.c |  119 ++++++++++++++++++----------
 src/hash.c                      |  168 +++++++++++++--------------------------
 3 files changed, 152 insertions(+), 169 deletions(-)

diff --git a/include/ulogd/hash.h b/include/ulogd/hash.h
index 45d2f48..d4aedb8 100644
--- a/include/ulogd/hash.h
+++ b/include/ulogd/hash.h
@@ -2,8 +2,7 @@
 #define _NF_SET_HASH_H_
 
 #include <unistd.h>
-#include "slist.h"
-#include <ulogd/linuxlist.h>
+#include "linuxlist.h"
 
 #include <stdint.h>
 
@@ -15,34 +14,31 @@ struct hashtable {
 	uint32_t limit;
 	uint32_t count;
 	uint32_t initval;
-	uint32_t datasize;
+	
+	uint32_t (*hash)(const void *data, const struct hashtable *table);
+	int	 (*compare)(const void *data1, const void *data2);
 
-	uint32_t	(*hash)(const void *data, struct hashtable *table);
-	int		(*compare)(const void *data1, const void *data2);
-
-	struct slist_head 	members[0];
+	struct llist_head 	members[0];
 };
 
 struct hashtable_node {
-	struct slist_head head;
-	char data[0];
+	struct llist_head head;
 };
 
-struct hashtable_node *hashtable_alloc_node(int datasize, void *data);
-void hashtable_destroy_node(struct hashtable_node *h);
-
 struct hashtable *
-hashtable_create(int hashsize, int limit, int datasize,
-		 uint32_t (*hash)(const void *data, struct hashtable *table),
+hashtable_create(int hashsize, int limit,
+		 uint32_t (*hash)(const void *data,
+		 		  const struct hashtable *table),
 		 int (*compare)(const void *data1, const void *data2));
 void hashtable_destroy(struct hashtable *h);
-
-void *hashtable_add(struct hashtable *table, void *data);
-void *hashtable_get(struct hashtable *table, const void *data);
-int hashtable_del(struct hashtable *table, void *data);
+int hashtable_hash(const struct hashtable *table, const void *data);
+struct hashtable_node *hashtable_find(const struct hashtable *table, const void *data, int id);
+int hashtable_add(struct hashtable *table, struct hashtable_node *n, int id);
+void hashtable_del(struct hashtable *table, struct hashtable_node *node);
 int hashtable_flush(struct hashtable *table);
 int hashtable_iterate(struct hashtable *table, void *data,
-		      int (*iterate)(void *data1, void *data2));
+		      int (*iterate)(void *data, void *n));
+int hashtable_iterate_limit(struct hashtable *table, void *data, uint32_t from, uint32_t steps, int (*iterate)(void *data1, void *n));
 unsigned int hashtable_counter(const struct hashtable *table);
 
 #endif
diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index d76649e..96aa8ea 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -49,6 +49,7 @@
 typedef enum TIMES_ { START, STOP, __TIME_MAX } TIMES;
 
 struct ct_timestamp {
+	struct hashtable_node hashnode;
 	struct timeval time[__TIME_MAX];
 	struct nf_conntrack *ct;
 };
@@ -380,7 +381,8 @@ static struct ulogd_key nfct_okeys[] = {
 	},
 };
 
-static uint32_t __hash4(const struct nf_conntrack *ct, struct hashtable *table)
+static uint32_t
+__hash4(const struct nf_conntrack *ct, const struct hashtable *table)
 {
 	unsigned int a, b;
 
@@ -402,7 +404,8 @@ static uint32_t __hash4(const struct nf_conntrack *ct, struct hashtable *table)
 	return ((uint64_t)jhash_2words(a, b, 0) * table->hashsize) >> 32;
 }
 
-static uint32_t __hash6(const struct nf_conntrack *ct, struct hashtable *table)
+static uint32_t
+__hash6(const struct nf_conntrack *ct, const struct hashtable *table)
 {
 	unsigned int a, b;
 
@@ -417,17 +420,17 @@ static uint32_t __hash6(const struct nf_conntrack *ct, struct hashtable *table)
 	return ((uint64_t)jhash_2words(a, b, 0) * table->hashsize) >> 32;
 }
 
-static uint32_t hash(const void *data, struct hashtable *table)
+static uint32_t hash(const void *data, const struct hashtable *table)
 {
 	int ret = 0;
-	const struct ct_timestamp *ts = data;
+	const struct nf_conntrack *ct = data;
 
-	switch(nfct_get_attr_u8(ts->ct, ATTR_L3PROTO)) {
+	switch(nfct_get_attr_u8(ct, ATTR_L3PROTO)) {
 		case AF_INET:
-			ret = __hash4(ts->ct, table);
+			ret = __hash4(ct, table);
 			break;
 		case AF_INET6:
-			ret = __hash6(ts->ct, table);
+			ret = __hash6(ct, table);
 			break;
 		default:
 			break;
@@ -439,9 +442,9 @@ static uint32_t hash(const void *data, struct hashtable *table)
 static int compare(const void *data1, const void *data2)
 {
 	const struct ct_timestamp *u1 = data1;
-	const struct ct_timestamp *u2 = data2;
+	const struct nf_conntrack *ct = data2;
 
-	return nfct_cmp(u1->ct, u2->ct, NFCT_CMP_ORIG | NFCT_CMP_REPL);
+	return nfct_cmp(u1->ct, ct, NFCT_CMP_ORIG | NFCT_CMP_REPL);
 }
 
 static int propagate_ct(struct ulogd_pluginstance *upi,
@@ -574,12 +577,13 @@ static int event_handler(enum nf_conntrack_msg_type type,
 	struct ulogd_pluginstance *upi = data;
 	struct nfct_pluginstance *cpi =
 				(struct nfct_pluginstance *) upi->private;
-	struct ct_timestamp *ts = NULL;
-	struct ct_timestamp tmp = {
-		.ct = ct,
-	};
+	struct ct_timestamp *ts;
+	int ret, id;
 
 	if (!usehash_ce(upi->config_kset).u.value) {
+		struct ct_timestamp tmp = {
+			.ct = ct,
+		};
 		switch(type) {
 		case NFCT_T_NEW:
 			gettimeofday(&tmp.time[START], NULL);
@@ -601,41 +605,61 @@ static int event_handler(enum nf_conntrack_msg_type type,
 
 	switch(type) {
 	case NFCT_T_NEW:
-		ts = hashtable_add(cpi->ct_active, &tmp);
+		ts = calloc(sizeof(struct ct_timestamp), 1);
 		if (ts == NULL)
 			return NFCT_CB_CONTINUE;
 
+		ts->ct = ct;
 		gettimeofday(&ts->time[START], NULL);
+
+		id = hashtable_hash(cpi->ct_active, ct);
+		ret = hashtable_add(cpi->ct_active, &ts->hashnode, id);
+		if (ret < 0) {
+			free(ts);
+			return NFCT_CB_CONTINUE;
+		}
 		return NFCT_CB_STOLEN;
 	case NFCT_T_UPDATE:
-		ts = hashtable_get(cpi->ct_active, &tmp);
+		id = hashtable_hash(cpi->ct_active, ct);
+		ts = (struct ct_timestamp *)
+			hashtable_find(cpi->ct_active, ct, id);
 		if (ts)
 			nfct_copy(ts->ct, ct, NFCT_CP_META);
 		else {
-			ts = hashtable_add(cpi->ct_active, &tmp);
+			ts = calloc(sizeof(struct ct_timestamp), 1);
 			if (ts == NULL)
 				return NFCT_CB_CONTINUE;
 
+			ts->ct = ct;
 			gettimeofday(&ts->time[START], NULL);
+
+			ret = hashtable_add(cpi->ct_active, &ts->hashnode, id);
+			if (ret < 0) {
+				free(ts);
+				return NFCT_CB_CONTINUE;
+			}
 			return NFCT_CB_STOLEN;
 		}
 		break;
 	case NFCT_T_DESTROY:
-		ts = hashtable_get(cpi->ct_active, &tmp);
+		id = hashtable_hash(cpi->ct_active, ct);
+		ts = (struct ct_timestamp *)
+			hashtable_find(cpi->ct_active, ct, id);
 		if (ts) {
 			gettimeofday(&ts->time[STOP], NULL);
 			do_propagate_ct(upi, ct, type, ts);
+			hashtable_del(cpi->ct_active, &ts->hashnode);
+			nfct_destroy(ts->ct);
+			free(ts);
 		} else {
+			struct ct_timestamp tmp = {
+				.ct = ct,
+			};
 			gettimeofday(&tmp.time[STOP], NULL);
 			tmp.time[START].tv_sec = 0;
 			tmp.time[START].tv_usec = 0;
 			do_propagate_ct(upi, ct, type, &tmp);
 		}
-
-		if (ts) {
-			hashtable_del(cpi->ct_active, ts);
-			free(ts->ct);
-		}
 		break;
 	default:
 		ulogd_log(ULOGD_NOTICE, "unknown netlink message type\n");
@@ -652,22 +676,29 @@ polling_handler(enum nf_conntrack_msg_type type,
 	struct ulogd_pluginstance *upi = data;
 	struct nfct_pluginstance *cpi =
 				(struct nfct_pluginstance *) upi->private;
-	struct ct_timestamp *ts = NULL;
-	struct ct_timestamp tmp = {
-		.ct = ct,
-	};
+	struct ct_timestamp *ts;
+	int ret, id;
 
 	switch(type) {
 	case NFCT_T_UPDATE:
-		ts = hashtable_get(cpi->ct_active, &tmp);
+		id = hashtable_hash(cpi->ct_active, ct);
+		ts = (struct ct_timestamp *)
+			hashtable_find(cpi->ct_active, ct, id);
 		if (ts)
 			nfct_copy(ts->ct, ct, NFCT_CP_META);
 		else {
-			ts = hashtable_add(cpi->ct_active, &tmp);
+			ts = calloc(sizeof(struct ct_timestamp), 1);
 			if (ts == NULL)
 				return NFCT_CB_CONTINUE;
 
+			ts->ct = ct;
 			gettimeofday(&ts->time[START], NULL);
+
+			ret = hashtable_add(cpi->ct_active, &ts->hashnode, id);
+			if (ret < 0) {
+				free(ts);
+				return NFCT_CB_CONTINUE;
+			}
 			return NFCT_CB_STOLEN;
 		}
 		break;
@@ -753,7 +784,8 @@ static int read_cb_nfct(int fd, unsigned int what, void *param)
 static int do_free(void *data1, void *data2)
 {
 	struct ct_timestamp *ts = data2;
-	free(ts->ct);
+	nfct_destroy(ts->ct);
+	free(ts);
 	return 0;
 }
 
@@ -770,8 +802,9 @@ static int do_purge(void *data1, void *data2)
 	ret = nfct_query(cpi->pgh, NFCT_Q_GET, ts->ct);
 	if (ret == -1 && errno == ENOENT) {
 		do_propagate_ct(upi, ts->ct, NFCT_T_DESTROY, ts);
-		hashtable_del(cpi->ct_active, ts);
-		free(ts->ct);
+		hashtable_del(cpi->ct_active, &ts->hashnode);
+		nfct_destroy(ts->ct);
+		free(ts);
 	}
 
 	return 0;
@@ -784,17 +817,25 @@ static int overrun_handler(enum nf_conntrack_msg_type type,
 	struct ulogd_pluginstance *upi = data;
 	struct nfct_pluginstance *cpi =
 				(struct nfct_pluginstance *) upi->private;
-	struct ct_timestamp *ts, tmp = {
-		.ct = ct,
-	};
-
-	/* if it does not exist, add it */
-	if (!hashtable_get(cpi->ct_active, &tmp)) {
-		ts = hashtable_add(cpi->ct_active, &tmp);
+	struct ct_timestamp *ts;
+	int id, ret;
+
+	id = hashtable_hash(cpi->ct_active, ct);
+	ts = (struct ct_timestamp *)
+		hashtable_find(cpi->ct_active, ct, id);
+	if (ts == NULL) {
+		ts = calloc(sizeof(struct ct_timestamp), 1);
 		if (ts == NULL)
 			return NFCT_CB_CONTINUE;
 
+		ts->ct = ct;
 		gettimeofday(&ts->time[START], NULL); /* do our best here */
+
+		ret = hashtable_add(cpi->ct_active, &ts->hashnode, id);
+		if (ret < 0) {
+			free(ts);
+			return NFCT_CB_CONTINUE;
+		}
 		return NFCT_CB_STOLEN;
 	}
 
@@ -912,7 +953,6 @@ static int constructor_nfct_events(struct ulogd_pluginstance *upi)
 		cpi->ct_active =
 		     hashtable_create(buckets_ce(upi->config_kset).u.value,
 				      maxentries_ce(upi->config_kset).u.value,
-				      sizeof(struct ct_timestamp),
 				      hash,
 				      compare);
 		if (!cpi->ct_active) {
@@ -987,7 +1027,6 @@ static int constructor_nfct_polling(struct ulogd_pluginstance *upi)
 	cpi->ct_active =
 	     hashtable_create(buckets_ce(upi->config_kset).u.value,
 			      maxentries_ce(upi->config_kset).u.value,
-			      sizeof(struct ct_timestamp),
 			      hash,
 			      compare);
 	if (!cpi->ct_active) {
diff --git a/src/hash.c b/src/hash.c
index 700678c..1d99130 100644
--- a/src/hash.c
+++ b/src/hash.c
@@ -1,6 +1,6 @@
 /*
- * (C) 2006-2007 by Pablo Neira Ayuso <pablo@netfilter.org>
- *
+ * (C) 2006-2009 by Pablo Neira Ayuso <pablo@netfilter.org>
+ * 
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
@@ -18,55 +18,35 @@
  * Description: generic hash table implementation
  */
 
-#include <ulogd/hash.h>
-#include <ulogd/slist.h>
+#include "ulogd/hash.h"
 
 #include <errno.h>
 #include <stdlib.h>
 #include <string.h>
-
-struct hashtable_node *hashtable_alloc_node(int datasize, void *data)
-{
-	struct hashtable_node *n;
-	int size = sizeof(struct hashtable_node) + datasize;
-
-	n = malloc(size);
-	if (!n)
-		return NULL;
-	memset(n, 0, size);
-	memcpy(n->data, data, datasize);
-
-	return n;
-}
-
-void hashtable_destroy_node(struct hashtable_node *h)
-{
-	free(h);
-}
+#include <limits.h>
 
 struct hashtable *
-hashtable_create(int hashsize, int limit, int datasize,
-		 uint32_t (*hash)(const void *data, struct hashtable *table),
+hashtable_create(int hashsize, int limit,
+		 uint32_t (*hash)(const void *data,
+		 		  const struct hashtable *table),
 		 int (*compare)(const void *data1, const void *data2))
 {
 	int i;
 	struct hashtable *h;
 	int size = sizeof(struct hashtable)
-		   + hashsize * sizeof(struct slist_head);
+		   + hashsize * sizeof(struct llist_head);
 
-	h = (struct hashtable *) malloc(size);
-	if (!h) {
+	h = (struct hashtable *) calloc(size, 1);
+	if (h == NULL) {
 		errno = ENOMEM;
 		return NULL;
 	}
 
-	memset(h, 0, size);
 	for (i=0; i<hashsize; i++)
-		INIT_SLIST_HEAD(h->members[i]);
+		INIT_LLIST_HEAD(&h->members[i]);
 
 	h->hashsize = hashsize;
 	h->limit = limit;
-	h->datasize = datasize;
 	h->hash = hash;
 	h->compare = compare;
 
@@ -75,118 +55,86 @@ hashtable_create(int hashsize, int limit, int datasize,
 
 void hashtable_destroy(struct hashtable *h)
 {
-	if (h) {
-		hashtable_flush(h);
-		free(h);
-	}
+	free(h);
 }
 
-void *hashtable_add(struct hashtable *table, void *data)
+int hashtable_hash(const struct hashtable *table, const void *data)
 {
-	uint32_t id;
-	struct slist_head *e;
-	struct hashtable_node *n;
-
-	/* hash table is full */
-	if (table->count >= table->limit) {
-		errno = ENOSPC;
-		return 0;
-	}
-
-	id = table->hash(data, table);
-
-	slist_for_each(e, &table->members[id]) {
-		n = slist_entry(e, struct hashtable_node, head);
-		if (table->compare(n->data, data)) {
-			errno = EEXIST;
-			return 0;
-		}
-	}
-
-	n = hashtable_alloc_node(table->datasize, data);
-	if (n == NULL) {
-		errno = ENOMEM;
-		return NULL;
-	}
-
-	slist_add(&table->members[id], &n->head);
-	table->count++;
-
-	return n->data;
+	return table->hash(data, table);
 }
 
-void *hashtable_get(struct hashtable *table, const void *data)
+struct hashtable_node *
+hashtable_find(const struct hashtable *table, const void *data, int id)
 {
-	struct slist_head *e;
-	uint32_t id;
+	struct llist_head *e;
 	struct hashtable_node *n;
 
-	id = table->hash(data, table);
-
-	slist_for_each(e, &table->members[id]) {
-		n = slist_entry(e, struct hashtable_node, head);
-		if (table->compare(n->data, data))
-			return n->data;
+	llist_for_each(e, &table->members[id]) {
+		n = llist_entry(e, struct hashtable_node, head);
+		if (table->compare(n, data)) {
+			return n;
+		}
 	}
-
 	errno = ENOENT;
 	return NULL;
 }
 
-int hashtable_del(struct hashtable *table, void *data)
+int hashtable_add(struct hashtable *table, struct hashtable_node *n, int id)
 {
-	struct slist_head *e, *next, *prev;
-	uint32_t id;
-	struct hashtable_node *n;
-
-	id = table->hash(data, table);
-
-	slist_for_each_safe(e, prev, next, &table->members[id]) {
-		n = slist_entry(e, struct hashtable_node, head);
-		if (table->compare(n->data, data)) {
-			slist_del(e, prev);
-			hashtable_destroy_node(n);
-			table->count--;
-			return 0;
-		}
+	/* hash table is full */
+	if (table->count >= table->limit) {
+		errno = ENOSPC;
+		return -1;
 	}
-	errno = ENOENT;
-	return -1;
+	llist_add(&n->head, &table->members[id]);
+	table->count++;
+	return 0;
+}
+
+void hashtable_del(struct hashtable *table, struct hashtable_node *n)
+{
+	llist_del(&n->head);
+	table->count--;
 }
 
 int hashtable_flush(struct hashtable *table)
 {
 	uint32_t i;
-	struct slist_head *e, *next, *prev;
+	struct llist_head *e, *tmp;
 	struct hashtable_node *n;
 
-	for (i=0; i < table->hashsize; i++)
-		slist_for_each_safe(e, prev, next, &table->members[i]) {
-			n = slist_entry(e, struct hashtable_node, head);
-			slist_del(e, prev);
-			hashtable_destroy_node(n);
+	for (i=0; i < table->hashsize; i++) {
+		llist_for_each_safe(e, tmp, &table->members[i]) {
+			n = llist_entry(e, struct hashtable_node, head);
+			free(n);
 		}
-
-	table->count = 0;
-
+	}
 	return 0;
 }
 
-int hashtable_iterate(struct hashtable *table, void *data,
-		      int (*iterate)(void *data1, void *data2))
+int
+hashtable_iterate_limit(struct hashtable *table, void *data,
+			uint32_t from, uint32_t steps,
+		        int (*iterate)(void *data1, void *n))
 {
 	uint32_t i;
-	struct slist_head *e, *next, *prev;
+	struct llist_head *e, *tmp;
 	struct hashtable_node *n;
 
-	for (i=0; i < table->hashsize; i++) {
-		slist_for_each_safe(e, prev, next, &table->members[i]) {
-			n = slist_entry(e, struct hashtable_node, head);
-			if (iterate(data, n->data) == -1)
+	for (i=from; i < table->hashsize && i < from+steps; i++) {
+		llist_for_each_safe(e, tmp, &table->members[i]) {
+			n = llist_entry(e, struct hashtable_node, head);
+			if (iterate(data, n) == -1)
 				return -1;
 		}
 	}
-	return 0;
+	return i;
+}
+
+int hashtable_iterate(struct hashtable *table, void *data,
+		      int (*iterate)(void *data1, void *n))
+{
+	return hashtable_iterate_limit(table, data, 0, UINT_MAX, iterate);
 }
 
 unsigned int hashtable_counter(const struct hashtable *table)

