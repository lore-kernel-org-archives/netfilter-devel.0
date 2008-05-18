From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD 1/4] rework NFCT to use a generic hashtable [was Re:	[ULOGD
   1/4]  improve netlink overrun handling of NFCT]
Date: Sun, 18 May 2008 03:21:28 +0200
Message-ID: <482F8498.9070602@netfilter.org>
References: <482C3E63.80006@netfilter.org> <482C3F36.4050907@netfilter.org> <20080515202458.GA22245@bayen.regit.org> <482D6776.8000502@netfilter.org> <20080517234042.GA14902@bayen.regit.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010903000009040907070800"
To: Eric Leblond <eric@inl.fr>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45386 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752024AbYERBVn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 May 2008 21:21:43 -0400
In-Reply-To: <20080517234042.GA14902@bayen.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010903000009040907070800
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Eric,

Eric Leblond wrote:
> Hello,
> 
> On Friday, 2008 May 16 at 12:52:38 +0200, Pablo Neira Ayuso wrote:
>> Eric Leblond wrote:
>>> Hello,
>>>
>>> On Thursday, 2008 May 15 at 15:48:38 +0200, Pablo Neira Ayuso wrote:
>> Missing chunks. Sorry. Attached a new patch.
> 
> Ok, that's better but the latest subversion^W git version of
> libnetfilter_conntrack is needed to compile.

Yes, the patch attached (04configure.patch) should be fine to check for
the appropriate library versions.

> I've got some remaark regarding the patch:
> 
>>  struct ct_timestamp {
>> -	struct llist_head list;
>>  	struct timeval time[__TIME_MAX];
>> -	int id;
>> -};
> 
> Why do we get completly get rid of the ID ? It will be available in the
> upcoming kernel version and it will be more efficient to use it if the
> kernel has support for it.

The ID is inside the nf_conntrack object. However, if we use the ID to
index the conntracks in the hash, we'll have to explicitly request a
linux kernel >= 2.6.25 for ulogd2. Also, I consider that the ID is not
enough to identify a conntrack, the tuple plus the ID provides a better
unique identifier. By using this patch, we only use the tuple to
identify a conntrack as for now.

>> -	if (type == NFCT_MSG_NEW) {
>> -		if (usehash_ce(upi->config_kset).u.value != 0) {
>> -			ct_hash_add(cpi->ct_active, nfct_get_attr_u32(ct, ATTR_ID));
>> -			return 0;
>> +	if (usehash_ce(upi->config_kset).u.value == 0)
>> +		return NFCT_CB_CONTINUE;
> 
> This one is really rude ! it is equivalent to no logging at all if we
> don't use the hash system.

I have fixed it. Thanks for noticing it. Attached a new patch.

> I've encounter an other problem which is that hash.c is not compiled
> because it has not been included in a Makefile.am (at least it is not in
> the patch).

Also fixed, the change was in my tree, I forgot to include it in the patch.

> I will send soon a rework of my patch about timestamp issue with a modification
> of this behaviour (in testing phase for now).

OK, thanks. I have also attached a new version of 00fixnfct.patch. The
complete patchset is available at my people.netfilter.org place [1].

[1] http://people.netfilter.org/pablo/ulogd2/

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------010903000009040907070800
Content-Type: text/x-patch;
 name="00fixnfct.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="00fixnfct.patch"

[PATCH] rework NFCT to use a generic hashtable

This patch introduces a generic hashtable to store the nf_conntrack objects.
The objects are identified by the original and reply tuples instead of the
conntrack ID which is not dumped in the event message of linux kernel < 2.6.25.
This patch also fixes the NFCT_MSG_* by NFCT_T_* which is the appropriate
message type tag.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: ulogd2/input/flow/ulogd_inpflow_NFCT.c
===================================================================
--- ulogd2.orig/input/flow/ulogd_inpflow_NFCT.c	2008-05-16 12:51:24.000000000 +0200
+++ ulogd2/input/flow/ulogd_inpflow_NFCT.c	2008-05-18 03:09:15.000000000 +0200
@@ -13,12 +13,13 @@
  *      Added timestamp accounting support of the conntrack entries,
  *      reworked by Harald Welte.
  *
+ * 11 May 2008, Pablo Neira Ayuso <pablo@netfilter.org>
+ * 	Use a generic hashtable to store the existing flows
+ *
  * TODO:
  * 	- add nanosecond-accurate packet receive timestamp of event-changing
  * 	  packets to {ip,nf}_conntrack_netlink, so we can have accurate IPFIX
  *	  flowStart / flowEnd NanoSeconds.
- *	- if using preallocated data structure, get rid of all list heads and
- *	  use per-bucket arrays instead.
  *	- SIGHUP for reconfiguration without loosing hash table contents, but
  *	  re-read of config and reallocation / rehashing of table, if required
  *	- Split hashtable code into separate [filter] plugin, so we can run 
@@ -34,6 +35,8 @@
 #include <sys/time.h>
 #include <time.h>
 #include <ulogd/linuxlist.h>
+#include <ulogd/jhash.h>
+#include <ulogd/hash.h>
 
 #include <ulogd/ulogd.h>
 #include <ulogd/timer.h>
@@ -44,24 +47,15 @@
 typedef enum TIMES_ { START, STOP, __TIME_MAX } TIMES;
  
 struct ct_timestamp {
-	struct llist_head list;
 	struct timeval time[__TIME_MAX];
-	int id;
-};
-
-struct ct_htable {
-	struct llist_head *buckets;
-	int num_buckets;
-	int prealloc;
-	struct llist_head idle;
-	struct ct_timestamp *ts;
+	struct nf_conntrack *ct;
 };
 
 struct nfct_pluginstance {
 	struct nfct_handle *cth;
 	struct ulogd_fd nfct_fd;
 	struct ulogd_timer timer;
-	struct ct_htable *ct_active;
+	struct hashtable *ct_active;
 };
 
 #define HTABLE_SIZE	(8192)
@@ -69,7 +63,7 @@ struct nfct_pluginstance {
 #define EVENT_MASK	NF_NETLINK_CONNTRACK_NEW | NF_NETLINK_CONNTRACK_DESTROY
 
 static struct config_keyset nfct_kset = {
-	.num_ces = 6,
+	.num_ces = 5,
 	.ces = {
 		{
 			.key	 = "pollinterval",
@@ -84,12 +78,6 @@ static struct config_keyset nfct_kset = 
 			.u.value = 1,
 		},
 		{
-			.key	 = "hash_prealloc",
-			.type	 = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
-			.u.value = 1,
-		},
-		{
 			.key	 = "hash_buckets",
 			.type	 = CONFIG_TYPE_INT,
 			.options = CONFIG_OPT_NONE,
@@ -112,10 +100,9 @@ static struct config_keyset nfct_kset = 
 };
 #define pollint_ce(x)	(x->ces[0])
 #define usehash_ce(x)	(x->ces[1])
-#define prealloc_ce(x)	(x->ces[2])
-#define buckets_ce(x)	(x->ces[3])
-#define maxentries_ce(x) (x->ces[4])
-#define eventmask_ce(x) (x->ces[5])
+#define buckets_ce(x)	(x->ces[2])
+#define maxentries_ce(x) (x->ces[3])
+#define eventmask_ce(x) (x->ces[4])
 
 enum nfct_keys {
 	NFCT_ORIG_IP_SADDR = 0,
@@ -366,117 +353,68 @@ static struct ulogd_key nfct_okeys[] = {
 	},
 };
 
-static struct ct_htable *htable_alloc(int htable_size, int prealloc)
+static uint32_t __hash4(const struct nf_conntrack *ct, struct hashtable *table)
 {
-	struct ct_htable *htable;
-	struct ct_timestamp *ct;
-	int i;
-
-	htable = malloc(sizeof(*htable)
-			+ sizeof(struct llist_head)*htable_size);
-	if (!htable)
-		return NULL;
-
-	htable->buckets = (void *)htable + sizeof(*htable);
-	htable->num_buckets = htable_size;
-	htable->prealloc = prealloc;
-	INIT_LLIST_HEAD(&htable->idle);
-
-	for (i = 0; i < htable->num_buckets; i++)
-		INIT_LLIST_HEAD(&htable->buckets[i]);
-	
-	if (!htable->prealloc)
-		return htable;
-
-	ct = malloc(sizeof(struct ct_timestamp)
-		    * htable->num_buckets * htable->prealloc);
-	if (!ct) {
-		free(htable);
-		return NULL;
-	}
+	unsigned int a, b;
 
-	/* save the pointer for later free()ing */
-	htable->ts = ct;
+	a = jhash(nfct_get_attr(ct, ATTR_ORIG_IPV4_SRC), sizeof(uint32_t),
+		  ((nfct_get_attr_u8(ct, ATTR_ORIG_L3PROTO) << 16) |
+		   (nfct_get_attr_u8(ct, ATTR_ORIG_L4PROTO))));
 
-	for (i = 0; i < htable->num_buckets * htable->prealloc; i++)
-		llist_add(&ct[i].list, &htable->idle);
+	b = jhash(nfct_get_attr(ct, ATTR_ORIG_IPV4_DST), sizeof(uint32_t),
+		  ((nfct_get_attr_u16(ct, ATTR_ORIG_PORT_SRC) << 16) |
+		   (nfct_get_attr_u16(ct, ATTR_ORIG_PORT_DST))));
 
-	return htable;
+	/*
+	 * Instead of returning hash % table->hashsize (implying a divide)
+	 * we return the high 32 bits of the (hash * table->hashsize) that will
+	 * give results between [0 and hashsize-1] and same hash distribution,
+	 * but using a multiply, less expensive than a divide. See:
+	 * http://www.mail-archive.com/netdev@vger.kernel.org/msg56623.html
+	 */
+	return ((uint64_t)jhash_2words(a, b, 0) * table->hashsize) >> 32;
 }
 
-static void htable_free(struct ct_htable *htable)
+static uint32_t __hash6(const struct nf_conntrack *ct, struct hashtable *table)
 {
-	struct llist_head *ptr, *ptr2;
-	int i;
+	unsigned int a, b;
 
-	if (htable->prealloc) {
-		/* the easy case */
-		free(htable->ts);
-		free(htable);
+	a = jhash(nfct_get_attr(ct, ATTR_ORIG_IPV6_SRC), sizeof(uint32_t)*4,
+		  ((nfct_get_attr_u8(ct, ATTR_ORIG_L3PROTO) << 16) |
+		   (nfct_get_attr_u8(ct, ATTR_ORIG_L4PROTO))));
 
-		return;
-	}
-
-	/* non-prealloc case */
-
-	for (i = 0; i < htable->num_buckets; i++) {
-		llist_for_each_safe(ptr, ptr2, &htable->buckets[i])
-			free(container_of(ptr, struct ct_timestamp, list));
-	}
+	b = jhash(nfct_get_attr(ct, ATTR_ORIG_IPV6_DST), sizeof(uint32_t)*4,
+		  ((nfct_get_attr_u16(ct, ATTR_ORIG_PORT_SRC) << 16) |
+		   (nfct_get_attr_u16(ct, ATTR_ORIG_PORT_DST))));
 
-	/* don't need to check for 'idle' list, since it is only used in
-	 * the preallocated case */
+	return ((uint64_t)jhash_2words(a, b, 0) * table->hashsize) >> 32;
 }
 
-static int ct_hash_add(struct ct_htable *htable, unsigned int id)
+static uint32_t hash(const void *data, struct hashtable *table)
 {
-	struct ct_timestamp *ct;
-
-	if (htable->prealloc) {
-		if (llist_empty(&htable->idle)) {
-			ulogd_log(ULOGD_ERROR, "Not enough ct_timestamp entries\n");
-			return -1;
-		}
-
-		ct = container_of(htable->idle.next, struct ct_timestamp, list);
-
-		ct->id = id;
-		gettimeofday(&ct->time[START], NULL);
-
-		llist_move(&ct->list, &htable->buckets[id % htable->num_buckets]);
-	} else {
-		ct = malloc(sizeof *ct);
-		if (!ct) {
-			ulogd_log(ULOGD_ERROR, "Not enough memory\n");
-			return -1;
-		}
-
-		ct->id = id;
-		gettimeofday(&ct->time[START], NULL);
+	int ret = 0;
+	const struct ct_timestamp *ts = data;
 
-		llist_add(&ct->list, &htable->buckets[id % htable->num_buckets]);
+	switch(nfct_get_attr_u8(ts->ct, ATTR_L3PROTO)) {
+		case AF_INET:
+			ret = __hash4(ts->ct, table);
+			break;
+		case AF_INET6:
+			ret = __hash6(ts->ct, table);
+			break;
+		default:
+			break;
 	}
 
-	return 0;
+	return ret;
 }
 
-static struct ct_timestamp *ct_hash_get(struct ct_htable *htable, uint32_t id)
+static int compare(const void *data1, const void *data2)
 {
-	struct ct_timestamp *ct = NULL;
-	struct llist_head *ptr;
+	const struct ct_timestamp *u1 = data1;
+	const struct ct_timestamp *u2 = data2;
 
-	llist_for_each(ptr, &htable->buckets[id % htable->num_buckets]) {
-		ct = container_of(ptr, struct ct_timestamp, list);
-		if (ct->id == id) {
-			gettimeofday(&ct->time[STOP], NULL);
-			if (htable->prealloc)
-				llist_move(&ct->list, &htable->idle);
-			else
-				free(ct);
-			break;
-		}
-	}
-	return ct;
+	return nfct_cmp(u1->ct, u2->ct, NFCT_CMP_ORIG | NFCT_CMP_REPL);
 }
 
 static int propagate_ct(struct ulogd_pluginstance *upi,
@@ -600,28 +538,69 @@ static int event_handler(enum nf_conntra
 	struct nfct_pluginstance *cpi = 
 				(struct nfct_pluginstance *) upi->private;
 	struct ct_timestamp *ts = NULL;
+	struct ct_timestamp tmp = {
+		.ct = ct,
+	};
 	struct ulogd_pluginstance *npi = NULL;
 	int ret = 0;
 
-	if (type == NFCT_MSG_NEW) {
-		if (usehash_ce(upi->config_kset).u.value != 0) {
-			ct_hash_add(cpi->ct_active, nfct_get_attr_u32(ct, ATTR_ID));
-			return 0;
+	if (!usehash_ce(upi->config_kset).u.value && type == NFCT_T_DESTROY) {
+		/* since we support the re-use of one instance in
+		 * several different stacks, we duplicate the message
+		 * to let them know */
+		llist_for_each_entry(npi, &upi->plist, plist) {
+			ret = propagate_ct(npi, ct, type, ts);
+			if (ret != 0)
+				break;
 		}
-	} else if (type == NFCT_MSG_DESTROY) {
-		if (usehash_ce(upi->config_kset).u.value != 0)
-			ts = ct_hash_get(cpi->ct_active, nfct_get_attr_u32(ct, ATTR_ID));
+
+		propagate_ct(upi, ct, type, ts);
+
+		return NFCT_CB_CONTINUE;
 	}
 
-	/* since we support the re-use of one instance in
-	 * several different stacks, we duplicate the message
-	 * to let them know */
-	llist_for_each_entry(npi, &upi->plist, plist) {
-		ret = propagate_ct(npi, ct, type, ts);
-		if (ret != 0)
-			return ret;
+	switch(type) {
+	case NFCT_T_NEW:
+		ts = hashtable_add(cpi->ct_active, &tmp);
+		gettimeofday(&ts->time[START], NULL);
+		return NFCT_CB_STOLEN;
+	case NFCT_T_UPDATE:
+		ts = hashtable_get(cpi->ct_active, &tmp);
+		if (ts)
+			nfct_copy(ts->ct, ct, NFCT_CP_META);
+		else {
+			ts = hashtable_add(cpi->ct_active, &tmp);
+			gettimeofday(&ts->time[START], NULL);
+			return NFCT_CB_STOLEN;
+		}
+		break;
+	case NFCT_T_DESTROY:
+		ts = hashtable_get(cpi->ct_active, &tmp);
+		if (ts)
+			gettimeofday(&ts->time[STOP], NULL);
+
+		/* since we support the re-use of one instance in
+		 * several different stacks, we duplicate the message
+		 * to let them know */
+		llist_for_each_entry(npi, &upi->plist, plist) {
+			ret = propagate_ct(npi, ct, type, ts);
+			if (ret != 0)
+				break;
+		}
+
+		propagate_ct(upi, ct, type, ts);
+
+		if (ts) {
+			hashtable_del(cpi->ct_active, ts);
+			free(ts->ct);
+		}
+		break;
+	default:
+		ulogd_log(ULOGD_NOTICE, "unknown netlink message type\n");
+		break;
 	}
-	return propagate_ct(upi, ct, type, ts);
+
+	return NFCT_CB_CONTINUE;
 }
 
 static int read_cb_nfct(int fd, unsigned int what, void *param)
@@ -677,7 +656,6 @@ static int constructor_nfct(struct ulogd
 {
 	struct nfct_pluginstance *cpi = 
 			(struct nfct_pluginstance *)upi->private;
-	int prealloc;
 
 	cpi->cth = nfct_open(NFNL_SUBSYS_CTNETLINK,
 			     eventmask_ce(upi->config_kset).u.value);
@@ -695,15 +673,13 @@ static int constructor_nfct(struct ulogd
 
 	ulogd_register_fd(&cpi->nfct_fd);
 
-	if (prealloc_ce(upi->config_kset).u.value != 0)
-		prealloc = maxentries_ce(upi->config_kset).u.value / 
-				buckets_ce(upi->config_kset).u.value;
-	else
-		prealloc = 0;
-
 	if (usehash_ce(upi->config_kset).u.value != 0) {
-		cpi->ct_active = htable_alloc(buckets_ce(upi->config_kset).u.value,
-					      prealloc);
+		cpi->ct_active =
+		     hashtable_create(buckets_ce(upi->config_kset).u.value,
+		     		      maxentries_ce(upi->config_kset).u.value,
+				      sizeof(struct ct_timestamp),
+				      hash,
+				      compare);
 		if (!cpi->ct_active) {
 			ulogd_log(ULOGD_FATAL, "error allocating hash\n");
 			nfct_close(cpi->cth);
@@ -719,7 +695,7 @@ static int destructor_nfct(struct ulogd_
 	struct nfct_pluginstance *cpi = (void *) pi;
 	int rc;
 	
-	htable_free(cpi->ct_active);
+	hashtable_destroy(cpi->ct_active);
 
 	rc = nfct_close(cpi->cth);
 	if (rc < 0)
Index: ulogd2/src/hash.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ ulogd2/src/hash.c	2008-05-16 12:51:30.000000000 +0200
@@ -0,0 +1,193 @@
+/*
+ * (C) 2006-2007 by Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ * Description: generic hash table implementation
+ */
+
+#include <ulogd/hash.h>
+#include <ulogd/slist.h>
+
+#include <errno.h>
+#include <stdlib.h>
+#include <string.h>
+
+struct hashtable_node *hashtable_alloc_node(int datasize, void *data)
+{
+	struct hashtable_node *n;
+	int size = sizeof(struct hashtable_node) + datasize;
+
+	n = malloc(size);
+	if (!n)
+		return NULL;
+	memset(n, 0, size);
+	memcpy(n->data, data, datasize);
+
+	return n;
+}
+
+void hashtable_destroy_node(struct hashtable_node *h)
+{
+	free(h);
+}
+
+struct hashtable *
+hashtable_create(int hashsize, int limit, int datasize,
+		 uint32_t (*hash)(const void *data, struct hashtable *table),
+		 int (*compare)(const void *data1, const void *data2))
+{
+	int i;
+	struct hashtable *h;
+	int size = sizeof(struct hashtable)
+		   + hashsize * sizeof(struct slist_head);
+
+	h = (struct hashtable *) malloc(size);
+	if (!h) {
+		errno = ENOMEM;
+		return NULL;
+	}
+
+	memset(h, 0, size);
+	for (i=0; i<hashsize; i++)
+		INIT_SLIST_HEAD(h->members[i]);
+
+	h->hashsize = hashsize;
+	h->limit = limit;
+	h->datasize = datasize;
+	h->hash = hash;
+	h->compare = compare;
+
+	return h;
+}
+
+void hashtable_destroy(struct hashtable *h)
+{
+	hashtable_flush(h);
+	free(h);
+}
+
+void *hashtable_add(struct hashtable *table, void *data)
+{
+	uint32_t id;
+	struct slist_head *e;
+	struct hashtable_node *n;
+
+	/* hash table is full */
+	if (table->count >= table->limit) {
+		errno = ENOSPC;
+		return 0;
+	}
+
+	id = table->hash(data, table);
+
+	slist_for_each(e, &table->members[id]) {
+		n = slist_entry(e, struct hashtable_node, head);
+		if (table->compare(n->data, data)) {
+			errno = EEXIST;
+			return 0;
+		}
+	}
+
+	n = hashtable_alloc_node(table->datasize, data);
+	if (n == NULL) {
+		errno = ENOMEM;
+		return NULL;
+	}
+
+	slist_add(&table->members[id], &n->head);
+	table->count++;
+
+	return n->data;
+}
+
+void *hashtable_get(struct hashtable *table, const void *data)
+{
+	struct slist_head *e;
+	uint32_t id;
+	struct hashtable_node *n;
+
+	id = table->hash(data, table);
+
+	slist_for_each(e, &table->members[id]) {
+		n = slist_entry(e, struct hashtable_node, head);
+		if (table->compare(n->data, data))
+			return n->data;
+	}
+
+	errno = ENOENT;
+	return NULL;
+}
+
+int hashtable_del(struct hashtable *table, void *data)
+{
+	struct slist_head *e, *next, *prev;
+	uint32_t id;
+	struct hashtable_node *n;
+
+	id = table->hash(data, table);
+
+	slist_for_each_safe(e, prev, next, &table->members[id]) {
+		n = slist_entry(e, struct hashtable_node, head);
+		if (table->compare(n->data, data)) {
+			slist_del(e, prev);
+			hashtable_destroy_node(n);
+			table->count--;
+			return 0;
+		}
+	}
+	errno = ENOENT;
+	return -1;
+}
+
+int hashtable_flush(struct hashtable *table)
+{
+	uint32_t i;
+	struct slist_head *e, *next, *prev;
+	struct hashtable_node *n;
+
+	for (i=0; i < table->hashsize; i++)
+		slist_for_each_safe(e, prev, next, &table->members[i]) {
+			n = slist_entry(e, struct hashtable_node, head);
+			slist_del(e, prev);
+			hashtable_destroy_node(n);
+		}
+
+	table->count = 0;
+
+	return 0;
+}
+
+int hashtable_iterate(struct hashtable *table, void *data,
+		      int (*iterate)(void *data1, void *data2))
+{
+	uint32_t i;
+	struct slist_head *e, *next, *prev;
+	struct hashtable_node *n;
+
+	for (i=0; i < table->hashsize; i++) {
+		slist_for_each_safe(e, prev, next, &table->members[i]) {
+			n = slist_entry(e, struct hashtable_node, head);
+			if (iterate(data, n->data) == -1)
+				return -1;
+		}
+	}
+	return 0;
+}
+
+unsigned int hashtable_counter(const struct hashtable *table)
+{
+	return table->count;
+}
Index: ulogd2/include/ulogd/hash.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ ulogd2/include/ulogd/hash.h	2008-05-16 12:51:30.000000000 +0200
@@ -0,0 +1,48 @@
+#ifndef _NF_SET_HASH_H_
+#define _NF_SET_HASH_H_
+
+#include <unistd.h>
+#include "slist.h"
+#include <ulogd/linuxlist.h>
+
+#include <stdint.h>
+
+struct hashtable;
+struct hashtable_node;
+
+struct hashtable {
+	uint32_t hashsize;
+	uint32_t limit;
+	uint32_t count;
+	uint32_t initval;
+	uint32_t datasize;
+
+	uint32_t	(*hash)(const void *data, struct hashtable *table);
+	int		(*compare)(const void *data1, const void *data2);
+
+	struct slist_head 	members[0];
+};
+
+struct hashtable_node {
+	struct slist_head head;
+	char data[0];
+};
+
+struct hashtable_node *hashtable_alloc_node(int datasize, void *data);
+void hashtable_destroy_node(struct hashtable_node *h);
+
+struct hashtable *
+hashtable_create(int hashsize, int limit, int datasize,
+		 uint32_t (*hash)(const void *data, struct hashtable *table),
+		 int (*compare)(const void *data1, const void *data2));
+void hashtable_destroy(struct hashtable *h);
+
+void *hashtable_add(struct hashtable *table, void *data);
+void *hashtable_get(struct hashtable *table, const void *data);
+int hashtable_del(struct hashtable *table, void *data);
+int hashtable_flush(struct hashtable *table);
+int hashtable_iterate(struct hashtable *table, void *data,
+		      int (*iterate)(void *data1, void *data2));
+unsigned int hashtable_counter(const struct hashtable *table);
+
+#endif
Index: ulogd2/include/ulogd/slist.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ ulogd2/include/ulogd/slist.h	2008-05-16 12:51:30.000000000 +0200
@@ -0,0 +1,40 @@
+#ifndef _SLIST_H_
+#define _SLIST_H_
+
+#include "linuxlist.h"
+
+#define INIT_SLIST_HEAD(ptr) ((ptr).next = NULL)
+
+struct slist_head {
+	struct slist_head *next;
+};
+
+static inline int slist_empty(const struct slist_head *h)
+{
+	return !h->next;
+}
+
+static inline void slist_del(struct slist_head *t, struct slist_head *prev)
+{
+	prev->next = t->next;
+}
+
+static inline void slist_add(struct slist_head *head, struct slist_head *t)
+{
+	struct slist_head *tmp = head->next;
+	head->next = t;
+	t->next = tmp;
+}
+
+#define slist_entry(ptr, type, member) container_of(ptr,type,member)
+
+#define slist_for_each(pos, head) \
+	for (pos = (head)->next; pos; \
+	     pos = pos->next)
+
+#define slist_for_each_safe(pos, prev, next, head) \
+	for (pos = (head)->next, prev = (head); \
+	     pos && ({ next = pos->next; 1; }); \
+	     ({ prev = (prev->next != next) ? prev->next : prev; }), pos = next)
+
+#endif
Index: ulogd2/include/ulogd/jhash.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ ulogd2/include/ulogd/jhash.h	2008-05-16 12:51:30.000000000 +0200
@@ -0,0 +1,146 @@
+#ifndef _LINUX_JHASH_H
+#define _LINUX_JHASH_H
+
+#define u32 unsigned int
+#define u8  char
+
+/* jhash.h: Jenkins hash support.
+ *
+ * Copyright (C) 1996 Bob Jenkins (bob_jenkins@burtleburtle.net)
+ *
+ * http://burtleburtle.net/bob/hash/
+ *
+ * These are the credits from Bob's sources:
+ *
+ * lookup2.c, by Bob Jenkins, December 1996, Public Domain.
+ * hash(), hash2(), hash3, and mix() are externally useful functions.
+ * Routines to test the hash are included if SELF_TEST is defined.
+ * You can use this free for any purpose.  It has no warranty.
+ *
+ * Copyright (C) 2003 David S. Miller (davem@redhat.com)
+ *
+ * I've modified Bob's hash to be useful in the Linux kernel, and
+ * any bugs present are surely my fault.  -DaveM
+ */
+
+/* NOTE: Arguments are modified. */
+#define __jhash_mix(a, b, c) \
+{ \
+  a -= b; a -= c; a ^= (c>>13); \
+  b -= c; b -= a; b ^= (a<<8); \
+  c -= a; c -= b; c ^= (b>>13); \
+  a -= b; a -= c; a ^= (c>>12);  \
+  b -= c; b -= a; b ^= (a<<16); \
+  c -= a; c -= b; c ^= (b>>5); \
+  a -= b; a -= c; a ^= (c>>3);  \
+  b -= c; b -= a; b ^= (a<<10); \
+  c -= a; c -= b; c ^= (b>>15); \
+}
+
+/* The golden ration: an arbitrary value */
+#define JHASH_GOLDEN_RATIO	0x9e3779b9
+
+/* The most generic version, hashes an arbitrary sequence
+ * of bytes.  No alignment or length assumptions are made about
+ * the input key.
+ */
+static inline u32 jhash(const void *key, u32 length, u32 initval)
+{
+	u32 a, b, c, len;
+	const u8 *k = key;
+
+	len = length;
+	a = b = JHASH_GOLDEN_RATIO;
+	c = initval;
+
+	while (len >= 12) {
+		a += (k[0] +((u32)k[1]<<8) +((u32)k[2]<<16) +((u32)k[3]<<24));
+		b += (k[4] +((u32)k[5]<<8) +((u32)k[6]<<16) +((u32)k[7]<<24));
+		c += (k[8] +((u32)k[9]<<8) +((u32)k[10]<<16)+((u32)k[11]<<24));
+
+		__jhash_mix(a,b,c);
+
+		k += 12;
+		len -= 12;
+	}
+
+	c += length;
+	switch (len) {
+	case 11: c += ((u32)k[10]<<24);
+	case 10: c += ((u32)k[9]<<16);
+	case 9 : c += ((u32)k[8]<<8);
+	case 8 : b += ((u32)k[7]<<24);
+	case 7 : b += ((u32)k[6]<<16);
+	case 6 : b += ((u32)k[5]<<8);
+	case 5 : b += k[4];
+	case 4 : a += ((u32)k[3]<<24);
+	case 3 : a += ((u32)k[2]<<16);
+	case 2 : a += ((u32)k[1]<<8);
+	case 1 : a += k[0];
+	};
+
+	__jhash_mix(a,b,c);
+
+	return c;
+}
+
+/* A special optimized version that handles 1 or more of u32s.
+ * The length parameter here is the number of u32s in the key.
+ */
+static inline u32 jhash2(u32 *k, u32 length, u32 initval)
+{
+	u32 a, b, c, len;
+
+	a = b = JHASH_GOLDEN_RATIO;
+	c = initval;
+	len = length;
+
+	while (len >= 3) {
+		a += k[0];
+		b += k[1];
+		c += k[2];
+		__jhash_mix(a, b, c);
+		k += 3; len -= 3;
+	}
+
+	c += length * 4;
+
+	switch (len) {
+	case 2 : b += k[1];
+	case 1 : a += k[0];
+	};
+
+	__jhash_mix(a,b,c);
+
+	return c;
+}
+
+
+/* A special ultra-optimized versions that knows they are hashing exactly
+ * 3, 2 or 1 word(s).
+ *
+ * NOTE: In partilar the "c += length; __jhash_mix(a,b,c);" normally
+ *       done at the end is not done here.
+ */
+static inline u32 jhash_3words(u32 a, u32 b, u32 c, u32 initval)
+{
+	a += JHASH_GOLDEN_RATIO;
+	b += JHASH_GOLDEN_RATIO;
+	c += initval;
+
+	__jhash_mix(a, b, c);
+
+	return c;
+}
+
+static inline u32 jhash_2words(u32 a, u32 b, u32 initval)
+{
+	return jhash_3words(a, b, 0, initval);
+}
+
+static inline u32 jhash_1word(u32 a, u32 initval)
+{
+	return jhash_3words(a, 0, 0, initval);
+}
+
+#endif /* _LINUX_JHASH_H */
Index: ulogd2/src/Makefile.am
===================================================================
--- ulogd2.orig/src/Makefile.am	2008-05-18 02:50:57.000000000 +0200
+++ ulogd2/src/Makefile.am	2008-05-18 02:51:03.000000000 +0200
@@ -5,5 +5,5 @@ AM_CPPFLAGS = $(all_includes) -I$(top_sr
 
 sbin_PROGRAMS = ulogd
 
-ulogd_SOURCES = ulogd.c select.c timer.c rbtree.c conffile.c
+ulogd_SOURCES = ulogd.c select.c timer.c rbtree.c conffile.c hash.c
 ulogd_LDFLAGS = -export-dynamic

--------------010903000009040907070800
Content-Type: text/x-patch;
 name="04configure.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="04configure.patch"

[PATCH] check for required libraries for compilation in configure.in

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: ulogd2/configure.in
===================================================================
--- ulogd2.orig/configure.in	2008-05-18 03:03:47.000000000 +0200
+++ ulogd2/configure.in	2008-05-18 03:13:33.000000000 +0200
@@ -32,14 +32,14 @@ AC_CHECK_FUNCS(socket strerror)
 
 dnl Check for the right nfnetlink version
 LIBNFNETLINK_REQUIRED=0.0.30
-PKG_CHECK_MODULES(LIBNFNETLINK, libnfnetlink >= $LIBNFNETLINK_REQUIRED,,
-               AC_MSG_ERROR(Cannot find libnfnetlink >= $LIBNFNETLINK_REQUIRED))
+LIBNETFILTER_CONNTRACK_REQUIRED=0.0.94
+LIBNETFILTER_LOG_REQUIRED=0.0.13
 
-AC_CHECK_HEADER([libnetfilter_log/linux_nfnetlink_log.h], [AC_MSG_RESULT([found])],
-		[AC_MSG_ERROR([libnetfilter_log Version 0.0.11 or later needed])])
+PKG_CHECK_MODULES(LIBNFNETLINK, libnfnetlink >= $LIBNFNETLINK_REQUIRED,, AC_MSG_ERROR(Cannot find libnfnetlink >= $LIBNFNETLINK_REQUIRED))
 
-AC_CHECK_HEADER([libnetfilter_conntrack/libnetfilter_conntrack.h], [AC_MSG_RESULT([found])],
-		[AC_MSG_ERROR([libnetfilter_conntrack Version 0.0.11 or later needed])])
+PKG_CHECK_MODULES(LIBNETFILTER_CONNTRACK, libnetfilter_conntrack >= $LIBNETFILTER_CONNTRACK_REQUIRED,, AC_MSG_ERROR(Cannot find libnetfilter_conntrack >= $LIBNETFILTER_CONNTRACK_REQUIRED))
+
+PKG_CHECK_MODULES(LIBNETFILTER_LOG, libnetfilter_log >= $LIBNETFILTER_LOG_REQUIRED,, AC_MSG_ERROR(Cannot find libnetfilter_log >= $LIBNETFILTER_LOG_REQUIRED))
 
 AC_CHECK_LIB([netfilter_log], [nflog_get_gid],
 	     AC_DEFINE_UNQUOTED([HAVE_NFLOG_GET_GID],[1],[libnetfilter_log has GID support]),,

--------------010903000009040907070800--
