From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ULOGD 2/4] improve netlink overrun handling of NFCT
Date: Thu, 15 May 2008 15:49:21 +0200
Message-ID: <482C3F61.1050402@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060808000503000007040206"
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51243 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753070AbYEONt7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 May 2008 09:49:59 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060808000503000007040206
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

[PATCH] improve netlink overrun handling of NFCT

This patch improves the overrun handling. The logic behind this patch
consists of two steps:

1) duplicate the netlink buffer size if the size does not goes after the
 upper boundary.
2) scheduling a resynchronization (in two seconds) with the kernel
conntrack table if we hit ENOBUFS. During the resynchronization, the
NFCT plugin dumps the current table and purges the objects that do not
exist anymore.

This patch also introduces two new clauses, the
netlink_socket_buffer_size and netlink_socket_buffer_maxsize that set
the size of the netlink socket buffer.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------060808000503000007040206
Content-Type: text/x-patch;
 name="01overrun.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01overrun.patch"

[PATCH] improve netlink overrun handling of NFCT

This patch improves the overrun handling. The logic behind this patch 
consists of two steps:

1) duplicate the netlink buffer size if the size does not goes after the 
upper boundary.
2) scheduling a resynchronization (in two seconds) with the kernel conntrack
table if we hit ENOBUFS. During the resynchronization, the NFCT plugin dumps
the current table and purges the objects that do not exist anymore.

This patch also introduces two new clauses, the netlink_socket_buffer_size
and netlink_socket_buffer_maxsize that set the size of the netlink socket 
buffer.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: ulogd2/input/flow/ulogd_inpflow_NFCT.c
===================================================================
--- ulogd2.orig/input/flow/ulogd_inpflow_NFCT.c	2008-05-14 13:48:10.000000000 +0200
+++ ulogd2/input/flow/ulogd_inpflow_NFCT.c	2008-05-15 14:42:40.000000000 +0200
@@ -15,6 +15,7 @@
  *
  * 11 May 2008, Pablo Neira Ayuso <pablo@netfilter.org>
  * 	Use a generic hashtable to store the existing flows
+ * 	Add netlink overrun handling
  *
  * TODO:
  * 	- add nanosecond-accurate packet receive timestamp of event-changing
@@ -53,9 +54,14 @@ struct ct_timestamp {
 
 struct nfct_pluginstance {
 	struct nfct_handle *cth;
+	struct nfct_handle *ovh;	/* overrun handler */
+	struct nfct_handle *pgh;	/* purge handler */
 	struct ulogd_fd nfct_fd;
+	struct ulogd_fd nfct_ov;
 	struct ulogd_timer timer;
+	struct ulogd_timer ov_timer;	/* overrun retry timer */
 	struct hashtable *ct_active;
+	int nlbufsiz;			/* current netlink buffer size */
 };
 
 #define HTABLE_SIZE	(8192)
@@ -63,7 +69,7 @@ struct nfct_pluginstance {
 #define EVENT_MASK	NF_NETLINK_CONNTRACK_NEW | NF_NETLINK_CONNTRACK_DESTROY
 
 static struct config_keyset nfct_kset = {
-	.num_ces = 5,
+	.num_ces = 7,
 	.ces = {
 		{
 			.key	 = "pollinterval",
@@ -95,7 +101,18 @@ static struct config_keyset nfct_kset = 
 			.options = CONFIG_OPT_NONE,
 			.u.value = EVENT_MASK,
 		},
-
+		{
+			.key	 = "netlink_socket_buffer_size",
+			.type	 = CONFIG_TYPE_INT,
+			.options = CONFIG_OPT_NONE,
+			.u.value = 0,
+		},
+		{
+			.key	 = "netlink_socket_buffer_maxsize",
+			.type	 = CONFIG_TYPE_INT,
+			.options = CONFIG_OPT_NONE,
+			.u.value = 0,
+		},
 	},
 };
 #define pollint_ce(x)	(x->ces[0])
@@ -103,6 +120,8 @@ static struct config_keyset nfct_kset = 
 #define buckets_ce(x)	(x->ces[2])
 #define maxentries_ce(x) (x->ces[3])
 #define eventmask_ce(x) (x->ces[4])
+#define nlsockbufsize_ce(x) (x->ces[5])
+#define nlsockbufmaxsize_ce(x) (x->ces[6])
 
 enum nfct_keys {
 	NFCT_ORIG_IP_SADDR = 0,
@@ -529,6 +548,25 @@ static int propagate_ct(struct ulogd_plu
 	return 0;
 }
 
+static void
+do_propagate_ct(struct ulogd_pluginstance *upi,
+		struct nf_conntrack *ct,
+		int type,
+		struct ct_timestamp *ts)
+{
+	struct ulogd_pluginstance *npi = NULL;
+
+	/* since we support the re-use of one instance in
+	 * several different stacks, we duplicate the message
+	 * to let them know */
+	llist_for_each_entry(npi, &upi->plist, plist) {
+		if (propagate_ct(npi, ct, type, ts) != 0)
+			break;
+	}
+
+	propagate_ct(upi, ct, type, ts);
+}
+
 /* XXX: pollinterval needs a different handler */
 static int event_handler(enum nf_conntrack_msg_type type,
 			 struct nf_conntrack *ct,
@@ -541,8 +579,6 @@ static int event_handler(enum nf_conntra
 	struct ct_timestamp tmp = {
 		.ct = ct,
 	};
-	struct ulogd_pluginstance *npi = NULL;
-	int ret = 0;
 
 	if (usehash_ce(upi->config_kset).u.value == 0)
 		return NFCT_CB_CONTINUE;
@@ -567,16 +603,7 @@ static int event_handler(enum nf_conntra
 		if (ts)
 			gettimeofday(&ts->time[STOP], NULL);
 
-		/* since we support the re-use of one instance in
-		 * several different stacks, we duplicate the message
-		 * to let them know */
-		llist_for_each_entry(npi, &upi->plist, plist) {
-			ret = propagate_ct(npi, ct, type, ts);
-			if (ret != 0)
-				break;
-		}
-
-		propagate_ct(upi, ct, type, ts);
+		do_propagate_ct(upi, ct, type, ts);
 
 		if (ts) {
 			hashtable_del(cpi->ct_active, ts);
@@ -591,24 +618,138 @@ static int event_handler(enum nf_conntra
 	return NFCT_CB_CONTINUE;
 }
 
+static int setnlbufsiz(struct ulogd_pluginstance *upi, int size)
+{
+	struct nfct_pluginstance *cpi =
+			(struct nfct_pluginstance *)upi->private;
+
+	if (size < nlsockbufmaxsize_ce(upi->config_kset).u.value) {
+		cpi->nlbufsiz = nfnl_rcvbufsiz(nfct_nfnlh(cpi->cth), size);
+		return 1;
+	}
+
+	ulogd_log(ULOGD_NOTICE, "Maximum buffer size (%d) in NFCT has been "
+				"reached. Please, consider rising "
+				"`netlink_socket_buffer_size` and "
+				"`netlink_socket_buffer_maxsize` "
+				"clauses.", cpi->nlbufsiz);
+	return 0;
+}
+
 static int read_cb_nfct(int fd, unsigned int what, void *param)
 {
 	struct nfct_pluginstance *cpi = (struct nfct_pluginstance *) param;
+	struct ulogd_pluginstance *upi = container_of(param,
+						      struct ulogd_pluginstance,
+						      private);
 
 	if (!(what & ULOGD_FD_READ))
 		return 0;
 
-	/* FIXME: implement this */
-	nfct_catch(cpi->cth);
+	if (nfct_catch(cpi->cth) == -1) {
+		if (errno == ENOBUFS) {
+			int family = AF_UNSPEC;
+
+			if (nlsockbufmaxsize_ce(upi->config_kset).u.value) {
+				int s = cpi->nlbufsiz * 2;
+				if (setnlbufsiz(upi, s)) {
+					ulogd_log(ULOGD_NOTICE,
+						  "We are losing events, "
+						  "increasing buffer size "
+						  "to %d\n", cpi->nlbufsiz);
+				}
+			} else {
+				ulogd_log(ULOGD_NOTICE,
+					  "We are losing events. Please, "
+					  "consider using the clauses "
+					  "`netlink_socket_buffer_size' and "
+					  "`netlink_socket_buffer_maxsize'");
+			}
+
+			nfct_send(cpi->ovh, NFCT_Q_DUMP, &family);
+			/* TODO: configurable retry timer */
+			ulogd_add_timer(&cpi->ov_timer, 2);
+		}
+	}
+
+	return 0;
+}
+
+static int do_purge(void *data1, void *data2)
+{
+	int ret;
+	struct ulogd_pluginstance *upi = data1;
+	struct ct_timestamp *ts = data2;
+	struct nfct_pluginstance *cpi =
+				(struct nfct_pluginstance *) upi->private;
+
+	/* if it is not in kernel anymore, purge it */
+	ret = nfct_query(cpi->pgh, NFCT_Q_GET, ts->ct);
+	if (ret == -1 && errno == ENOENT) {
+		do_propagate_ct(upi, ts->ct, NFCT_T_DESTROY, ts);
+		hashtable_del(cpi->ct_active, ts);
+		free(ts->ct);
+	}
+
+	return 0;
+}
+
+static int overrun_handler(enum nf_conntrack_msg_type type,
+			   struct nf_conntrack *ct,
+			   void *data)
+{
+	struct ulogd_pluginstance *upi = data;
+	struct nfct_pluginstance *cpi =
+				(struct nfct_pluginstance *) upi->private;
+	struct ct_timestamp *ts, tmp = {
+		.ct = ct,
+	};
+
+	/* if it does not exist, add it */
+	if (!hashtable_get(cpi->ct_active, &tmp)) {
+		ts = hashtable_add(cpi->ct_active, &tmp);
+		gettimeofday(&ts->time[START], NULL); /* do our best here */
+		return NFCT_CB_STOLEN;
+	}
+
+	return NFCT_CB_CONTINUE;
+}
+
+static int read_cb_ovh(int fd, unsigned int what, void *param)
+{
+	struct nfct_pluginstance *cpi = (struct nfct_pluginstance *) param;
+	struct ulogd_pluginstance *upi = container_of(param,
+						      struct ulogd_pluginstance,
+						      private);
+
+	if (!(what & ULOGD_FD_READ))
+		return 0;
+
+	/* handle the resync request, update our hashtable */
+	if (nfct_catch(cpi->ovh) == -1) {
+		/* enobufs in the overrun buffer? very rare */
+		if (errno == ENOBUFS) {
+			int family = AF_UNSPEC;
+
+			nfct_send(cpi->ovh, NFCT_Q_DUMP, &family);
+			/* TODO: configurable retry timer */
+			ulogd_add_timer(&cpi->ov_timer, 2);
+		}
+	}
+
+	/* purge unexistent entries */
+	hashtable_iterate(cpi->ct_active, upi, do_purge);
+
 	return 0;
 }
 
 static int get_ctr_zero(struct ulogd_pluginstance *upi)
 {
+	int family = 0; /* any */
 	struct nfct_pluginstance *cpi = 
 			(struct nfct_pluginstance *)upi->private;
 
-	return nfct_dump_conntrack_table_reset_counters(cpi->cth, AF_INET);
+	return nfct_query(cpi->cth, NFCT_Q_DUMP_RESET, &family);
 }
 
 static void getctr_timer_cb(struct ulogd_timer *t, void *data)
@@ -640,6 +781,18 @@ static int configure_nfct(struct ulogd_p
 	return 0;
 }
 
+static void overrun_timeout(struct ulogd_timer *a, void *data)
+{
+	int family = AF_UNSPEC;
+	struct ulogd_pluginstance *upi = data;
+	struct nfct_pluginstance *cpi =
+			(struct nfct_pluginstance *)upi->private;
+
+	nfct_send(cpi->ovh, NFCT_Q_DUMP, &family);
+	/* TODO: configurable retry timer */
+	ulogd_add_timer(&cpi->ov_timer, 2);
+}
+
 static int constructor_nfct(struct ulogd_pluginstance *upi)
 {
 	struct nfct_pluginstance *cpi = 
@@ -654,6 +807,28 @@ static int constructor_nfct(struct ulogd
 
 	nfct_callback_register(cpi->cth, NFCT_T_ALL, &event_handler, upi);
 
+	if (nlsockbufsize_ce(upi->config_kset).u.value) {
+		setnlbufsiz(upi, nlsockbufsize_ce(upi->config_kset).u.value);
+		ulogd_log(ULOGD_NOTICE, "NFCT netlink buffer size has been "
+					"set to %d\n", cpi->nlbufsiz);
+	}
+
+	cpi->ovh = nfct_open(NFNL_SUBSYS_CTNETLINK, 0);
+	if (!cpi->ovh) {
+		ulogd_log(ULOGD_FATAL, "error opening ctnetlink\n");
+		return -1;
+	}
+
+	nfct_callback_register(cpi->ovh, NFCT_T_ALL, &overrun_handler, upi);
+
+	cpi->pgh = nfct_open(NFNL_SUBSYS_CTNETLINK, 0);
+	if (!cpi->pgh) {
+		ulogd_log(ULOGD_FATAL, "error opening ctnetlink\n");
+		return -1;
+	}
+
+	ulogd_init_timer(&cpi->ov_timer, upi, overrun_timeout);
+
 	cpi->nfct_fd.fd = nfct_fd(cpi->cth);
 	cpi->nfct_fd.cb = &read_cb_nfct;
 	cpi->nfct_fd.data = cpi;
@@ -661,6 +836,13 @@ static int constructor_nfct(struct ulogd
 
 	ulogd_register_fd(&cpi->nfct_fd);
 
+	cpi->nfct_ov.fd = nfct_fd(cpi->ovh);
+	cpi->nfct_ov.cb = &read_cb_ovh;
+	cpi->nfct_ov.data = cpi;
+	cpi->nfct_ov.when = ULOGD_FD_READ;
+
+	ulogd_register_fd(&cpi->nfct_ov);
+
 	if (usehash_ce(upi->config_kset).u.value != 0) {
 		cpi->ct_active =
 		     hashtable_create(buckets_ce(upi->config_kset).u.value,
@@ -671,6 +853,8 @@ static int constructor_nfct(struct ulogd
 		if (!cpi->ct_active) {
 			ulogd_log(ULOGD_FATAL, "error allocating hash\n");
 			nfct_close(cpi->cth);
+			nfct_close(cpi->ovh);
+			nfct_close(cpi->pgh);
 			return -1;
 		}
 	}
@@ -689,6 +873,14 @@ static int destructor_nfct(struct ulogd_
 	if (rc < 0)
 		return rc;
 
+	rc = nfct_close(cpi->ovh);
+	if (rc < 0)
+		return rc;
+
+	rc = nfct_close(cpi->pgh);
+	if (rc < 0)
+		return rc;
+
 	return 0;
 }
 
Index: ulogd2/ulogd.conf.in
===================================================================
--- ulogd2.orig/ulogd.conf.in	2008-05-14 13:49:58.000000000 +0200
+++ ulogd2/ulogd.conf.in	2008-05-14 13:50:51.000000000 +0200
@@ -87,6 +87,8 @@ plugin="@libdir@/ulogd/ulogd_raw2packet_
 #stack=ct1:NFCT,ip2str1:IP2STR,nacct1:NACCT
 
 [ct1]
+#netlink_socket_buffer_size=217088
+#netlink_socket_buffer_maxsize=1085440
 
 # IPv4 logging through NFLOG
 [log1]

--------------060808000503000007040206--
