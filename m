From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [RFC PATCH libnetfilter_conntrack] add userspace dump filter
Date: Tue, 17 Jun 2014 21:37:18 +0900
Message-ID: <20140617123718.GC24712@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:46480 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932209AbaFQMhZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Jun 2014 08:37:25 -0400
Received: by mail-pb0-f51.google.com with SMTP id rp16so5655057pbb.38
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Jun 2014 05:37:24 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 Hello,

I tried to filter dump by zone in userspace. But it seems for me
that CTA_ZONE is classified larger class than CTA_MARK, then I
think it allows to be filtered in kernel like CTA_MARK/CTA_MARK_MASK.

Which is preferable way?

--------

This patch adds more type to filter_dump, working in userspace,
just only for nf_callback_register, not nf_callback_register2.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 include/internal/object.h                          |  5 +++
 include/internal/types.h                           |  4 ++-
 .../libnetfilter_conntrack.h                       |  6 ++++
 src/callback.c                                     |  4 +--
 src/conntrack/api.c                                | 41 ++++++++++++++++++++--
 src/conntrack/filter_dump.c                        | 17 +++++++++
 6 files changed, 72 insertions(+), 5 deletions(-)

diff --git a/include/internal/object.h b/include/internal/object.h
index 83d9010..c1515ae 100644
--- a/include/internal/object.h
+++ b/include/internal/object.h
@@ -49,6 +49,10 @@ struct nfct_handle {
 struct __data_container {
 	struct nfct_handle *h;
 	enum nf_conntrack_msg_type type;
+	int (*cb)(enum nf_conntrack_msg_type type,
+		  struct nf_conntrack *ct,
+		  void *data);
+	struct nf_conntrack *filter_ct;
 	void *data;
 };
 
@@ -284,6 +288,7 @@ struct nfct_filter {
 struct nfct_filter_dump {
 	struct nfct_filter_dump_mark	mark;
 	u_int8_t			l3num;
+	struct nf_conntrack		*ct;
 	u_int32_t			set;
 };
 
diff --git a/include/internal/types.h b/include/internal/types.h
index 49bac2e..0520ff4 100644
--- a/include/internal/types.h
+++ b/include/internal/types.h
@@ -15,7 +15,9 @@ typedef int (*getobjopt)(const struct nf_conntrack *ct);
 typedef void (*setobjopt)(struct nf_conntrack *ct);
 typedef void (*set_attr_grp)(struct nf_conntrack *ct, const void *value);
 typedef void (*get_attr_grp)(const struct nf_conntrack *ct, void *data);
-typedef void (*set_filter_dump_attr)(struct nfct_filter_dump *filter_dump, const void *value);
+typedef void (*set_filter_dump_attr)(struct nfct_filter_dump *filter_dump,
+				     const enum nfct_filter_dump_attr type,
+				     const void *value);
 
 /*
  * expectation types
diff --git a/include/libnetfilter_conntrack/libnetfilter_conntrack.h b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
index 52fee85..d5a18db 100644
--- a/include/libnetfilter_conntrack/libnetfilter_conntrack.h
+++ b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
@@ -536,9 +536,15 @@ struct nfct_filter_dump_mark {
 enum nfct_filter_dump_attr {
 	NFCT_FILTER_DUMP_MARK = 0,	/* struct nfct_filter_dump_mark */
 	NFCT_FILTER_DUMP_L3NUM,		/* u_int8_t */
+	NFCT_FILTER_DUMP_L4PROTO,	/* u_int8_t */
+	NFCT_FILTER_DUMP_ZONE,		/* u_int16_t */
 	NFCT_FILTER_DUMP_MAX
 };
 
+#define NFCT_FILTER_DUMP_USER \
+  (1 << NFCT_FILTER_DUMP_ZONE | \
+   1 << NFCT_FILTER_DUMP_L4PROTO)
+
 struct nfct_filter_dump *nfct_filter_dump_create(void);
 
 void nfct_filter_dump_destroy(struct nfct_filter_dump *filter);
diff --git a/src/callback.c b/src/callback.c
index 19cc663..e7db2bb 100644
--- a/src/callback.c
+++ b/src/callback.c
@@ -54,8 +54,8 @@ int __callback(struct nlmsghdr *nlh, struct nfattr *nfa[], void *data)
 
 		__parse_conntrack(nlh, nfa, ct);
 
-		if (container->h->cb) {
-			ret = container->h->cb(type, ct, container->data);
+		if (container->cb) {
+			ret = container->cb(type, ct, container->data);
 		} else if (container->h->cb2) {
 			ret = container->h->cb2(nlh, type, ct,
 						container->data);
diff --git a/src/conntrack/api.c b/src/conntrack/api.c
index 77b4a49..4404cc2 100644
--- a/src/conntrack/api.c
+++ b/src/conntrack/api.c
@@ -941,6 +941,18 @@ int nfct_parse_conntrack(enum nf_conntrack_msg_type type,
  * @{
  */
 
+int __simple_filtered_cb(enum nf_conntrack_msg_type type,
+			 struct nf_conntrack *ct,
+			 void *data)
+{
+	struct __data_container *container = data;
+
+	if (!nfct_cmp(container->filter_ct, ct,
+		      NFCT_CMP_ALL | NFCT_CMP_MASK))
+		return NFNL_CB_CONTINUE;
+	return container->h->cb(type, ct, container->data);
+}
+
 /**
  * nfct_query - send a query to ctnetlink and handle the reply
  * \param h library handler
@@ -959,6 +971,7 @@ int nfct_query(struct nfct_handle *h,
 		char buffer[size];
 		struct nfnlhdr req;
 	} u;
+	struct __data_container *container = h->nfnl_cb_ct.data;
 
 	assert(h != NULL);
 	assert(data != NULL);
@@ -966,6 +979,17 @@ int nfct_query(struct nfct_handle *h,
 	if (__build_query_ct(h->nfnlssh_ct, qt, data, &u.req, size) == -1)
 		return -1;
 
+	if (container) {
+		if ((qt == NFCT_Q_DUMP_FILTER || qt == NFCT_Q_DUMP_FILTER_RESET)
+		    && ((struct nfct_filter_dump *)data)->set
+			& NFCT_FILTER_DUMP_USER) {
+			container->cb = __simple_filtered_cb;
+			container->filter_ct = ((struct nfct_filter_dump *)data)->ct;
+		} else {
+			container->cb = h->cb;
+		}
+	}
+
 	return nfnl_query(h->nfnlh, &u.req.nlh);
 }
 
@@ -1464,7 +1488,19 @@ int nfct_filter_detach(int fd)
  */
 struct nfct_filter_dump *nfct_filter_dump_create(void)
 {
-	return calloc(sizeof(struct nfct_filter_dump), 1);
+	struct nfct_filter_dump *filter;
+
+	filter = calloc(sizeof(struct nfct_filter_dump), 1);
+	if (filter == NULL)
+		return NULL;
+
+	filter->ct = nfct_new();
+	if (filter->ct == NULL) {
+		free(filter);
+		return NULL;
+	}
+
+	return filter;
 }
 
 /**
@@ -1476,6 +1512,7 @@ struct nfct_filter_dump *nfct_filter_dump_create(void)
 void nfct_filter_dump_destroy(struct nfct_filter_dump *filter)
 {
 	assert(filter != NULL);
+	nfct_destroy(filter->ct);
 	free(filter);
 	filter = NULL;
 }
@@ -1497,7 +1534,7 @@ void nfct_filter_dump_set_attr(struct nfct_filter_dump *filter_dump,
 		return;
 
 	if (set_filter_dump_attr_array[type]) {
-		set_filter_dump_attr_array[type](filter_dump, value);
+		set_filter_dump_attr_array[type](filter_dump, type, value);
 		filter_dump->set |= (1 << type);
 	}
 }
diff --git a/src/conntrack/filter_dump.c b/src/conntrack/filter_dump.c
index 4819759..0da4794 100644
--- a/src/conntrack/filter_dump.c
+++ b/src/conntrack/filter_dump.c
@@ -11,6 +11,7 @@
 
 static void
 set_filter_dump_attr_mark(struct nfct_filter_dump *filter_dump,
+			  const enum nfct_filter_dump_attr type,
 			  const void *value)
 {
 	const struct nfct_filter_dump_mark *this = value;
@@ -21,14 +22,30 @@ set_filter_dump_attr_mark(struct nfct_filter_dump *filter_dump,
 
 static void
 set_filter_dump_attr_family(struct nfct_filter_dump *filter_dump,
+			    const enum nfct_filter_dump_attr type,
 			    const void *value)
 {
 	filter_dump->l3num = *((u_int8_t *)value);
 }
 
+const enum nf_conntrack_attr simple_dump_attr_array[] = {
+	[NFCT_FILTER_DUMP_ZONE]		= ATTR_ZONE,
+	[NFCT_FILTER_DUMP_L4PROTO]	= ATTR_L4PROTO,
+};
+
+static void
+set_filter_dump_attr_simple(struct nfct_filter_dump *filter_dump,
+			    const enum nfct_filter_dump_attr type,
+			    const void *value)
+{
+	nfct_set_attr(filter_dump->ct, simple_dump_attr_array[type], value);
+}
+
 const set_filter_dump_attr set_filter_dump_attr_array[NFCT_FILTER_DUMP_MAX] = {
 	[NFCT_FILTER_DUMP_MARK]		= set_filter_dump_attr_mark,
 	[NFCT_FILTER_DUMP_L3NUM]	= set_filter_dump_attr_family,
+	[NFCT_FILTER_DUMP_ZONE]		= set_filter_dump_attr_simple,
+	[NFCT_FILTER_DUMP_L4PROTO]	= set_filter_dump_attr_simple,
 };
 
 void __build_filter_dump(struct nfnlhdr *req, size_t size,
-- 
1.9.1

