From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [RFC] new API for libnetfilter_conntrack
Date: Mon, 30 Oct 2006 03:25:09 +0100
Message-ID: <45456285.4010609@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000203070703030809040604"
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>,
	Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------000203070703030809040604
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

Attached a patch, yet incomplete, that introduces the new API for
libnetfilter_conntrack. Basically the idea consists of providing
"conntrack" objects constructor/destructor functions and an interface to
get and set object attributes. The conntrack object structure is
encapsulated therefore we can add new attributes without breaking binary
backward compatibility. There is an example of the new API use in the
patch (see test.c file)

See that conntrack object attributes are different from the netlink
attributes therefore they provide a high level interface that abstract
from netlink details. The idea is to let the programmer make the choice
to work with high level (objects) or low level (netlink) and provide the
gateways to switch from high to low level and vice-versa by means of
functions to build/parse netlink messages from/to conntrack objects.

The reason why I posted this patch is because I'm thinking about
generalizing this a bit more and provide a complete high level API that
would be the same for all the netfilter subsystems. This will result in
a single library to rules them all with a subdirectory that contains the
details of every specific subsystem.

nfh = nf_open();                   /* encapsulate nfnl_open() */
ssh = nf_setup_subsys(nfnlh, CONNTRACK); /* encapsulate
nfnl_subsys_open() */
...
ct = nf_new_object(NF_CONNTRACK_OBJECT);
nf_set_attr_u8(ct, ATTR_XXX, value);
nf_set_attr_u16(ct, ATTR_XXX, value);
...
nf_query_object(ssh, NF_CT_CREATE, ct);
nf_free_object(ct);
nf_close(nfh);

I'd like to hear from you before going ahead, always appreciate your
feedback guys. Comments welcome.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------000203070703030809040604
Content-Type: text/plain;
 name="api.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="api.patch"

Index: libnetfilter_conntrack/include/libnetfilter_conntrack/libnetfilter_conntrack.h
===================================================================
--- libnetfilter_conntrack.orig/include/libnetfilter_conntrack/libnetfilter_conntrack.h	2006-10-30 02:11:10.000000000 +0100
+++ libnetfilter_conntrack/include/libnetfilter_conntrack/libnetfilter_conntrack.h	2006-10-30 02:11:18.000000000 +0100
@@ -238,6 +238,9 @@ extern int nfct_close(struct nfct_handle
 
 extern int nfct_fd(struct nfct_handle *cth);
 
+extern struct nfnl_handle *nfct_get_nfnl(struct nfct_handle *h);
+extern struct nfnl_subsys_handle *nfct_get_nfnlssh_ct(struct nfct_handle *h);
+
 /*
  * [Register|unregister] callbacks
  */
@@ -332,6 +335,113 @@ extern int nfct_sprintf_expect_id(char *
 extern void nfct_build_tuple(struct nfnlhdr *req, int size, 
 			     struct nfct_tuple *t, int type);
 
+/* 
+ * New libnetfilter_conntrack API 
+ */
+
+/* high level API */
+
+#include <sys/types.h>
+
+/* conntrack object */
+struct nf_conntrack;
+
+/* conntrack attributes */
+enum nf_conntrack_attr {
+	ATTR_ORIG_IPV4_SRC = 0,
+	ATTR_ORIG_IPV4_DST,
+	ATTR_REPL_IPV4_SRC,
+	ATTR_REPL_IPV4_DST,
+	ATTR_ORIG_IPV6_SRC,
+	ATTR_ORIG_IPV6_DST,
+	ATTR_REPL_IPV6_SRC,
+	ATTR_REPL_IPV6_DST,
+	ATTR_ORIG_PORT_SRC,
+	ATTR_ORIG_PORT_DST,
+	ATTR_REPL_PORT_SRC,
+	ATTR_REPL_PORT_DST,
+	ATTR_ICMP_TYPE,
+	ATTR_ICMP_CODE,
+	ATTR_ICMP_ID,
+	ATTR_ORIG_L3PROTO,
+	ATTR_REPL_L3PROTO,
+	ATTR_ORIG_L4PROTO,
+	ATTR_REPL_L4PROTO,
+	ATTR_TCP_STATE,
+	ATTR_SNAT_IPV4,
+	ATTR_DNAT_IPV4,
+	ATTR_SNAT_PORT,
+	ATTR_DNAT_PORT,
+	ATTR_TIMEOUT,
+	ATTR_MARK,
+	ATTR_ORIG_COUNTER_PACKETS,
+	ATTR_REPL_COUNTER_PACKETS,
+	ATTR_ORIG_COUNTER_BYTES,
+	ATTR_REPL_COUNTER_BYTES,
+	ATTR_USE,
+	ATTR_ID,
+	ATTR_ASSURED,
+	ATTR_SEEN_REPLY,
+	ATTR_MAX
+};
+
+/* constructor / destructor */
+extern struct nf_conntrack *nfct_new(void);
+extern void nfct_destroy(struct nf_conntrack *ct);
+
+/* setter */
+extern void nfct_set_attr(struct nf_conntrack *ct,
+			  const enum nf_conntrack_attr type,
+			  void *value);
+
+extern void nfct_set_attr_u8(struct nf_conntrack *ct,
+			     const enum nf_conntrack_attr type,
+			     u_int8_t value);
+
+extern void nfct_set_attr_u16(struct nf_conntrack *ct,
+			      const enum nf_conntrack_attr type,
+			      u_int16_t value);
+
+extern void nfct_set_attr_u32(struct nf_conntrack *ct,
+			      const enum nf_conntrack_attr type,
+			      u_int32_t value);
+
+/* getter */
+extern void * nfct_get_attr(const struct nf_conntrack *ct,
+			    const enum nf_conntrack_attr type);
+
+extern u_int8_t nfct_get_attr_u8(const struct nf_conntrack *ct,
+				 const enum nf_conntrack_attr type);
+
+extern u_int16_t nfct_get_attr_u16(const struct nf_conntrack *ct,
+				   const enum nf_conntrack_attr type);
+
+extern u_int32_t nfct_get_attr_u32(const struct nf_conntrack *ct,
+				   const enum nf_conntrack_attr type);
+
+/* query */
+enum nf_conntrack_query {
+	NFCT_Q_CREATE,
+	NFCT_Q_UPDATE,
+	NFCT_Q_DESTROY
+};
+
+extern int nfct_query(const struct nfct_handle *h,
+		      const enum nf_conntrack_query query,
+		      const struct nf_conntrack *ct);
+
+extern int nfct_sprintf(char *buf, const struct nf_conntrack *ct);
+
+/* low level API: netlink functions */
+
+extern int nfct_nl_build_conntrack(struct nfnl_subsys_handle *ssh,
+				   struct nfnlhdr *req,
+				   size_t size,
+				   u_int16_t type,
+				   u_int16_t flags,
+				   const struct nf_conntrack *ct);
 
+extern int nfct_nl_parse_conntrack(const struct nlmsghdr *nlh, 
+				   struct nf_conntrack *ct);
 
 #endif	/* _LIBNETFILTER_CONNTRACK_H_ */
Index: libnetfilter_conntrack/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
===================================================================
--- libnetfilter_conntrack.orig/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h	2006-10-30 02:11:10.000000000 +0100
+++ libnetfilter_conntrack/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h	2006-10-30 02:11:18.000000000 +0100
@@ -27,13 +27,15 @@ enum ctattr_type {
 	CTA_STATUS,
 	CTA_PROTOINFO,
 	CTA_HELP,
-	CTA_NAT,
+	CTA_NAT_SRC,
+#define CTA_NAT	CTA_NAT_SRC	/* backwards compatibility */
 	CTA_TIMEOUT,
 	CTA_MARK,
 	CTA_COUNTERS_ORIG,
 	CTA_COUNTERS_REPLY,
 	CTA_USE,
 	CTA_ID,
+	CTA_NAT_DST,
 	__CTA_MAX
 };
 #define CTA_MAX (__CTA_MAX - 1)
Index: libnetfilter_conntrack/src/Makefile.am
===================================================================
--- libnetfilter_conntrack.orig/src/Makefile.am	2006-10-30 02:11:15.000000000 +0100
+++ libnetfilter_conntrack/src/Makefile.am	2006-10-30 02:11:18.000000000 +0100
@@ -11,4 +11,6 @@ lib_LTLIBRARIES = libnetfilter_conntrack
 
 libnetfilter_conntrack_la_LDFLAGS = -Wc,-nostartfiles -lnfnetlink -ldl 	\
 				    -version-info $(LIBVERSION)
-libnetfilter_conntrack_la_SOURCES = libnetfilter_conntrack.c 
+libnetfilter_conntrack_la_SOURCES = libnetfilter_conntrack.c \
+				    api.c build.c parse.c sprint.c \
+				    setter.c getter.c
Index: libnetfilter_conntrack/src/libnetfilter_conntrack.c
===================================================================
--- libnetfilter_conntrack.orig/src/libnetfilter_conntrack.c	2006-10-30 02:11:15.000000000 +0100
+++ libnetfilter_conntrack/src/libnetfilter_conntrack.c	2006-10-30 02:11:18.000000000 +0100
@@ -37,6 +37,16 @@ struct nfct_handle {
 	nfct_handler handler;		/* netlink handler */
 };
 
+struct nfnl_subsys_handle *nfct_get_nfnlssh_ct(struct nfct_handle *h)
+{
+	return h->nfnlssh_ct;
+}
+
+extern struct nfnl_handle *nfct_get_nfnl(struct nfct_handle *h)
+{
+	return h->nfnlh;
+}
+
 static char *lib_dir = LIBNETFILTER_CONNTRACK_DIR;
 static LIST_HEAD(proto_list);
 static LIST_HEAD(l3proto_list);
Index: libnetfilter_conntrack/src/api.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ libnetfilter_conntrack/src/api.c	2006-10-30 02:11:18.000000000 +0100
@@ -0,0 +1,344 @@
+/*
+ * (C) 2006 by Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This software may be used and distributed according to the terms
+ * of the GNU General Public License, incorporated herein by reference.
+ */
+
+#include <stdlib.h>
+#include <string.h> /* for memset */
+#include <errno.h>
+#include <assert.h>
+
+#include "internal.h"
+#include <libnetfilter_conntrack/libnetfilter_conntrack.h>
+
+/**
+ * nfct_conntrack_new - allocate a new conntrack
+ *
+ * In case of success, this function returns a valid pointer to a memory blob,
+ * otherwise NULL is returned and errno is set appropiately.
+ */
+struct nf_conntrack *nfct_new()
+{
+	struct nf_conntrack *ct;
+
+	ct = malloc(sizeof(struct nf_conntrack));
+	if (!ct)
+		return NULL;
+
+	memset(ct, 0, sizeof(struct nf_conntrack));
+
+	/* always work with confirmed conntracks */
+	ct->status |= IPS_CONFIRMED;
+
+	return ct;
+}
+
+/**
+ * nf_conntrack_destroy - release a conntrack object
+ * @ct: pointer to the conntrack object
+ */
+void nfct_destroy(struct nf_conntrack *ct)
+{
+	assert(ct != NULL);
+	free(ct);
+	ct = NULL; /* bugtrap for bad programmers: assertions ;) */
+}
+
+/**
+ * nfct_set_attr - set the value of a certain conntrack attribute
+ * @ct: pointer to a valid conntrack
+ * @type: attribute type
+ * @value: pointer to the attribute value
+ */
+void nfct_set_attr(struct nf_conntrack *ct,
+		   const enum nf_conntrack_attr type, 
+		   void *value)
+{
+	assert(ct != NULL);
+	assert(value != NULL);
+
+	if (type > ATTR_MAX)
+		return;
+
+	set_attr_array[type](ct, value);
+	set_bit(type, ct->set);
+}
+
+/**
+ * nfct_set_attr_u8 - set the value of a certain conntrack attribute
+ * @ct: pointer to a valid conntrack
+ * @type: attribute type
+ * @value: unsigned 8 bits attribute value
+ */
+void nfct_set_attr_u8(struct nf_conntrack *ct,
+		      const enum nf_conntrack_attr type, 
+		      u_int8_t value)
+{
+	nfct_set_attr(ct, type, &value);
+}
+
+/**
+ * nfct_set_attr_u16 - set the value of a certain conntrack attribute
+ * @ct: pointer to a valid conntrack
+ * @type: attribute type
+ * @value: unsigned 16 bits attribute value
+ */
+void nfct_set_attr_u16(struct nf_conntrack *ct,
+		       const enum nf_conntrack_attr type, 
+		       u_int16_t value)
+{
+	nfct_set_attr(ct, type, &value);
+}
+
+/**
+ * nfct_set_attr_u32 - set the value of a certain conntrack attribute
+ * @ct: pointer to a valid conntrack
+ * @type: attribute type
+ * @value: unsigned 32 bits attribute value
+ */
+void nfct_set_attr_u32(struct nf_conntrack *ct,
+		       const enum nf_conntrack_attr type, 
+		       u_int32_t value)
+{
+	nfct_set_attr(ct, type, &value);
+}
+
+/**
+ * nfct_get_attr - get a conntrack attribute
+ * @ct: pointer to a valid conntrack
+ * @type: attribute type
+ */
+void *nfct_get_attr(const struct nf_conntrack *ct,
+		    const enum nf_conntrack_attr type)
+{
+	assert(ct != NULL);
+
+	if (type > ATTR_MAX)
+		return NULL;
+
+	if (test_bit(type, ct->set))
+		return NULL;
+
+	return get_attr_array[type](ct);
+}
+
+u_int8_t nfct_get_attr_u8(const struct nf_conntrack *ct,
+			  const enum nf_conntrack_attr type)
+{
+	return *((u_int8_t *) nfct_get_attr(ct, type));
+}
+
+u_int16_t nfct_get_attr_u16(const struct nf_conntrack *ct,
+			    const enum nf_conntrack_attr type)
+{
+	return *((u_int16_t *) nfct_get_attr(ct, type));
+}
+
+u_int32_t nfct_get_attr_u32(const struct nf_conntrack *ct,
+			    const enum nf_conntrack_attr type)
+{
+	return *((u_int32_t *) nfct_get_attr(ct, type));
+}
+
+int nfct_nl_build_conntrack(struct nfnl_subsys_handle *ssh,
+			    struct nfnlhdr *req,
+			    size_t size,
+			    u_int16_t type,
+			    u_int16_t flags,
+			    const struct nf_conntrack *ct)
+{
+	u_int8_t l3num = ct->tuple[NFCT_DIR_ORIGINAL].l3protonum;
+
+	assert(ssh != NULL);
+	assert(req != NULL);
+	assert(ct != NULL);
+
+	if (!test_bit(ATTR_ORIG_L3PROTO, ct->set)) {
+		errno = EINVAL;
+		return -1;
+	}
+
+	memset(req, 0, size);
+
+	nfnl_fill_hdr(ssh, &req->nlh, 0, l3num, 0, type, flags);
+
+	__build_tuple(req, size, &ct->tuple[__DIR_ORIG], CTA_TUPLE_ORIG);
+	__build_tuple(req, size, &ct->tuple[__DIR_REPL], CTA_TUPLE_REPLY);
+
+	/* always build IPS_CONFIRMED */
+	__build_status(req, size, ct);
+
+	if (test_bit(ATTR_TIMEOUT, ct->set))
+		__build_timeout(req, size, ct);
+
+	if (test_bit(ATTR_MARK, ct->set))
+		__build_mark(req, size, ct);
+
+	if (test_bit(ATTR_TCP_STATE, ct->set))
+		__build_protoinfo(req, size, ct);
+
+	if (test_bit(ATTR_SNAT_IPV4, ct->set) &&
+	    test_bit(ATTR_SNAT_PORT, ct->set))
+		__build_snat(req, size, ct);
+
+	if (test_bit(ATTR_SNAT_IPV4, ct->set))
+		__build_snat_ipv4(req, size, ct);
+
+	if (test_bit(ATTR_SNAT_PORT, ct->set))
+		__build_snat_port(req, size, ct);
+
+	if (test_bit(ATTR_DNAT_IPV4, ct->set) &&
+	    test_bit(ATTR_DNAT_PORT, ct->set))
+		__build_dnat(req, size, ct);
+
+	if (test_bit(ATTR_DNAT_IPV4, ct->set))
+		__build_dnat_ipv4(req, size, ct);
+
+	if (test_bit(ATTR_DNAT_PORT, ct->set))
+		__build_dnat_port(req, size, ct);
+
+	return 0;
+}
+
+int nfct_nl_parse_conntrack(const struct nlmsghdr *nlh, struct nf_conntrack *ct)
+{
+	int ret;
+	struct nfgenmsg *nfhdr = NLMSG_DATA(nlh);
+	int len = nlh->nlmsg_len;
+	struct nfattr *cda[CTA_MAX];
+
+	len -= NLMSG_LENGTH(sizeof(struct nfgenmsg));
+	if (len < 0)
+		return -EINVAL;
+
+	ret = __msgtype2enum(nlh);
+
+	memset(ct, 0, sizeof(struct nfct_conntrack));
+
+	ct->tuple[NFCT_DIR_ORIGINAL].l3protonum = nfhdr->nfgen_family;
+	ct->tuple[__DIR_REPL].l3protonum = nfhdr->nfgen_family;
+
+	nfnl_parse_attr(cda, CTA_MAX, NFA_DATA(nfhdr), len);
+
+	if (cda[CTA_TUPLE_ORIG-1])
+		__parse_tuple(cda[CTA_TUPLE_ORIG-1], 
+			      &ct->tuple[NFCT_DIR_ORIGINAL], ct->set);
+
+	if (cda[CTA_TUPLE_REPLY-1])
+		__parse_tuple(cda[CTA_TUPLE_REPLY-1], 
+			      &ct->tuple[__DIR_REPL], ct->set);
+
+	if (cda[CTA_STATUS-1]) {
+		ct->status = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_STATUS-1]));
+		if (ct->status & IPS_ASSURED)
+			set_bit(ATTR_ASSURED, ct->set);
+		if (ct->status & IPS_SEEN_REPLY)
+			set_bit(ATTR_SEEN_REPLY, ct->set);
+	}
+
+	if (cda[CTA_PROTOINFO-1])
+		__parse_protoinfo(cda[CTA_PROTOINFO-1], ct);
+
+	if (cda[CTA_TIMEOUT-1]) {
+		ct->timeout = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_TIMEOUT-1]));
+		set_bit(ATTR_TIMEOUT, ct->set);
+	}
+	
+	if (cda[CTA_MARK-1]) {
+		ct->mark = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_MARK-1]));
+		set_bit(ATTR_MARK, ct->set);
+	}
+
+	if (cda[CTA_COUNTERS_ORIG-1])
+		__parse_counters(cda[CTA_COUNTERS_ORIG-1], ct, 
+				 NFA_TYPE(cda[CTA_COUNTERS_ORIG-1])-1);
+
+	if (cda[CTA_COUNTERS_REPLY-1])
+		__parse_counters(cda[CTA_COUNTERS_REPLY-1], ct, 
+				 NFA_TYPE(cda[CTA_COUNTERS_REPLY-1])-1);
+
+	if (cda[CTA_USE-1]) {
+		ct->use = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_USE-1]));
+		set_bit(ATTR_USE, ct->set);
+	}
+
+	if (cda[CTA_ID-1]) {
+		ct->id = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_ID-1]));
+		set_bit(ATTR_ID, ct->set);
+	}
+
+	return 0;
+}
+
+int nfct_query(const struct nfct_handle *h,
+	       const enum nf_conntrack_query query,
+	       const struct nf_conntrack *ct)
+{
+	size_t size = 4096;
+	char buffer[size];
+	struct nfnlhdr *req = buffer;
+
+	memset(req, 0, size);
+
+	switch(query) {
+	case NFCT_Q_CREATE:
+		nfct_nl_build_conntrack(nfct_get_nfnlssh_ct(h), req, size, IPCTNL_MSG_CT_NEW, NLM_F_REQUEST|NLM_F_CREATE|NLM_F_ACK|NLM_F_EXCL, ct);
+		break;
+	case NFCT_Q_UPDATE:
+		nfct_nl_build_conntrack(nfct_get_nfnlssh_ct(h), req, size, IPCTNL_MSG_CT_NEW, NLM_F_REQUEST|NLM_F_ACK, ct);
+		break;
+	case NFCT_Q_DESTROY:
+		nfct_nl_build_conntrack(nfct_get_nfnlssh_ct(h), req, size, IPCTNL_MSG_CT_DELETE, NLM_F_ROOT|NLM_F_MATCH|NLM_F_REQUEST|NLM_F_ACK, ct);
+		break;
+	default:
+		return -1;
+	}
+
+	return nfnl_talk(nfct_get_nfnl(h), &req->nlh, 0, 0, NULL, NULL, NULL);
+}
+
+int nfct_sprintf(char *buf, const struct nf_conntrack *ct) 
+{
+	int size = 0;
+
+	size += __sprintf_protocol(buf, ct);
+
+	if (test_bit(ATTR_TIMEOUT, ct->set))
+		size += __sprintf_timeout(buf+size, ct);
+
+        if (test_bit(ATTR_TCP_STATE, ct->set))
+		size += __sprintf_protoinfo(buf+size, ct);
+
+	size += __sprintf_address(buf+size, &ct->tuple[__DIR_ORIG]);
+	size += __sprintf_proto(buf+size, &ct->tuple[__DIR_ORIG]);
+
+	if (test_bit(ATTR_ORIG_COUNTER_PACKETS, ct->set) &&
+	    test_bit(ATTR_ORIG_COUNTER_BYTES, ct->set))
+		size += __sprintf_counters(buf+size, ct, __DIR_ORIG);
+
+	if (test_bit(ATTR_SEEN_REPLY, ct->set))
+		size += __sprintf_status_seen_reply(buf+size, ct);
+
+	size += __sprintf_address(buf+size, &ct->tuple[__DIR_REPL]);
+	size += __sprintf_proto(buf+size, &ct->tuple[__DIR_REPL]);
+
+	if (test_bit(ATTR_REPL_COUNTER_PACKETS, ct->set) &&
+	    test_bit(ATTR_REPL_COUNTER_BYTES, ct->set))
+		size += __sprintf_counters(buf+size, ct, __DIR_REPL);
+
+	if (test_bit(ATTR_ASSURED, ct->set))
+		size += __sprintf_status_assured(buf+size, ct);
+
+	if (test_bit(ATTR_MARK, ct->set))
+		size += __sprintf_mark(buf+size, ct);
+
+	if (test_bit(ATTR_USE, ct->set))
+		size += __sprintf_use(buf+size, ct);
+
+	/* Delete the last blank space */
+	size--;
+
+	return size;
+}
Index: libnetfilter_conntrack/src/build.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ libnetfilter_conntrack/src/build.c	2006-10-30 02:11:18.000000000 +0100
@@ -0,0 +1,240 @@
+/*
+ * (C) 2006 by Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This software may be used and distributed according to the terms
+ * of the GNU General Public License, incorporated herein by reference.
+ */
+
+#include "internal.h"
+
+void __build_tuple_ip(struct nfnlhdr *req, 
+		      size_t size,
+		      const struct __nfct_tuple *t)
+{
+	struct nfattr *nest;
+
+	nest = nfnl_nest(&req->nlh, size, CTA_TUPLE_IP);
+
+	switch(t->l3protonum) {
+	case AF_INET:
+	        nfnl_addattr_l(&req->nlh, size, CTA_IP_V4_SRC, &t->src.v4,
+			       sizeof(u_int32_t));
+		nfnl_addattr_l(&req->nlh, size, CTA_IP_V4_DST, &t->dst.v4,
+			       sizeof(u_int32_t));
+		break;
+	case AF_INET6:
+		nfnl_addattr_l(&req->nlh, size, CTA_IP_V6_SRC, &t->src.v6,
+			       sizeof(struct in6_addr));
+		nfnl_addattr_l(&req->nlh, size, CTA_IP_V6_DST, &t->dst.v6,
+			       sizeof(struct in6_addr));
+		break;
+	default:
+		break;
+	}
+
+	nfnl_nest_end(&req->nlh, nest);
+}
+
+void __build_tuple_proto(struct nfnlhdr *req,
+			 size_t size,
+			 const struct __nfct_tuple *t)
+{
+	struct nfattr *nest;
+
+	nest = nfnl_nest(&req->nlh, size, CTA_TUPLE_PROTO);
+
+	nfnl_addattr_l(&req->nlh, size, CTA_PROTO_NUM, &t->protonum,
+		       sizeof(u_int8_t));
+
+	switch(t->protonum) {
+	case IPPROTO_UDP:
+	case IPPROTO_TCP:
+	case IPPROTO_SCTP:
+		nfnl_addattr_l(&req->nlh, size, CTA_PROTO_SRC_PORT,
+			       &t->l4src.tcp.port, sizeof(u_int16_t));
+		nfnl_addattr_l(&req->nlh, size, CTA_PROTO_DST_PORT,
+			       &t->l4dst.tcp.port, sizeof(u_int16_t));
+		break;
+	case IPPROTO_ICMP:
+		nfnl_addattr_l(&req->nlh, size, CTA_PROTO_ICMP_CODE,
+			       &t->l4dst.icmp.code, sizeof(u_int8_t));
+		nfnl_addattr_l(&req->nlh, size, CTA_PROTO_ICMP_TYPE,
+			       &t->l4dst.icmp.type, sizeof(u_int8_t));
+		nfnl_addattr_l(&req->nlh, size, CTA_PROTO_ICMP_ID,
+			       &t->l4src.icmp.id, sizeof(u_int16_t));
+		break;
+	default:
+		break;
+	}
+
+	nfnl_nest_end(&req->nlh, nest);
+}
+
+void __build_tuple(struct nfnlhdr *req, 
+		   size_t size, 
+		   const struct __nfct_tuple *t, 
+		   const int type)
+{
+	struct nfattr *nest;
+
+	nest = nfnl_nest(&req->nlh, size, type);
+
+	__build_tuple_ip(req, size, t);
+	__build_tuple_proto(req, size, t);
+
+	nfnl_nest_end(&req->nlh, nest);
+}
+
+void __build_protoinfo(struct nfnlhdr *req,
+		       size_t size,
+		       const struct nf_conntrack *ct)
+{
+	struct nfattr *nest, *nest_proto;
+	struct nfct_proto *h;
+
+	switch(ct->tuple[__DIR_ORIG].protonum) {
+	case IPPROTO_TCP:
+		nest = nfnl_nest(&req->nlh, size, CTA_PROTOINFO);
+		nest_proto = nfnl_nest(&req->nlh, size, CTA_PROTOINFO_TCP);
+		nfnl_addattr_l(&req->nlh, size, CTA_PROTOINFO_TCP_STATE,
+			       &ct->protoinfo.tcp.state, sizeof(u_int8_t));
+		nfnl_nest_end(&req->nlh, nest_proto);
+		nfnl_nest_end(&req->nlh, nest);
+		break;
+	default:
+		break;
+	}
+}
+
+void __build_protonat(struct nfnlhdr *req,
+		      size_t size,
+		      const struct nf_conntrack *ct,
+		      struct __nfct_nat *nat)
+{
+	struct nfattr *nest;
+
+	nest = nfnl_nest(&req->nlh, size, CTA_NAT_PROTO);
+
+	switch (ct->tuple[NFCT_DIR_ORIGINAL].protonum) {
+#if 0
+	case IPPROTO_TCP:
+		nfnl_addattr_l(&req->nlh, size, CTA_PROTONAT_TCP_MIN,
+			       &ct->nat.l4min.tcp.port, sizeof(u_int16_t));
+		nfnl_addattr_l(&req->nlh, size, CTA_PROTONAT_TCP_MAX,
+			       &ct->nat.l4max.tcp.port, sizeof(u_int16_t));
+		break;
+	case IPPROTO_UDP:
+		nfnl_addattr_l(&req->nlh, size, CTA_PROTONAT_UDP_MIN,
+			       &ct->nat.l4min.udp.port, sizeof(u_int16_t));
+		nfnl_addattr_l(&req->nlh, size, CTA_PROTONAT_UDP_MAX,
+			       &ct->nat.l4max.udp.port, sizeof(u_int16_t));
+		break;
+#endif
+	}
+	nfnl_nest_end(&req->nlh, nest);
+}
+
+void __build_nat(struct nfnlhdr *req,
+		 size_t size,
+		 const struct __nfct_nat *nat)
+{
+	nfnl_addattr_l(&req->nlh, size, CTA_NAT_MINIP,
+		       &nat->min_ip, sizeof(u_int32_t));
+}
+
+void __build_snat(struct nfnlhdr *req,
+		  size_t size,
+		  const struct nf_conntrack *ct)
+{
+	struct nfattr *nest;
+
+	nest = nfnl_nest(&req->nlh, size, CTA_NAT_SRC);
+	__build_nat(req, size, &ct->snat);
+	__build_protonat(req, size, ct, &ct->snat);
+	nfnl_nest_end(&req->nlh, nest);
+}
+
+void __build_snat_ipv4(struct nfnlhdr *req,
+		       size_t size,
+		       const struct nf_conntrack *ct)
+{
+	struct nfattr *nest;
+
+	nest = nfnl_nest(&req->nlh, size, CTA_NAT_SRC);
+	__build_nat(req, size, &ct->snat);
+	nfnl_nest_end(&req->nlh, nest);
+}
+
+void __build_snat_port(struct nfnlhdr *req,
+		       size_t size,
+		       const struct nf_conntrack *ct)
+{
+	struct nfattr *nest;
+
+	nest = nfnl_nest(&req->nlh, size, CTA_NAT_SRC);
+	__build_protonat(req, size, ct, &ct->snat);
+	nfnl_nest_end(&req->nlh, nest);
+}
+
+void __build_dnat(struct nfnlhdr *req,
+		  size_t size, 
+		  const struct nf_conntrack *ct)
+{
+	struct nfattr *nest;
+
+	nest = nfnl_nest(&req->nlh, size, CTA_NAT_SRC);
+	__build_nat(req, size, &ct->dnat);
+	__build_protonat(req, size, ct, &ct->dnat);
+	nfnl_nest_end(&req->nlh, nest);
+}
+
+void __build_dnat_ipv4(struct nfnlhdr *req,
+		       size_t size, 
+		       const struct nf_conntrack *ct)
+{
+	struct nfattr *nest;
+
+	nest = nfnl_nest(&req->nlh, size, CTA_NAT_SRC);
+	__build_nat(req, size, &ct->dnat);
+	nfnl_nest_end(&req->nlh, nest);
+}
+
+void __build_dnat_port(struct nfnlhdr *req,
+		       size_t size, 
+		       const struct nf_conntrack *ct)
+{
+	struct nfattr *nest;
+
+	nest = nfnl_nest(&req->nlh, size, CTA_NAT_SRC);
+        __build_protonat(req, size, ct, &ct->dnat);
+	nfnl_nest_end(&req->nlh, nest);
+}
+
+void __build_status(struct nfnlhdr *req,
+		    size_t size,
+		    const struct nf_conntrack *ct)
+{
+	nfnl_addattr32(&req->nlh, size, CTA_STATUS,
+		       htonl(ct->status | IPS_CONFIRMED));
+}
+
+void __build_timeout(struct nfnlhdr *req,
+			size_t size,
+			const struct nf_conntrack *ct)
+{
+	nfnl_addattr32(&req->nlh, size, CTA_TIMEOUT, htonl(ct->timeout));
+}
+
+void __build_mark(struct nfnlhdr *req,
+		  size_t size,
+		  const struct nf_conntrack *ct)
+{
+	nfnl_addattr32(&req->nlh, size, CTA_MARK, htonl(ct->mark));
+}
+
+void __build_id(struct nfnlhdr *req,
+		size_t size,
+		const const struct nf_conntrack *ct)
+{
+	nfnl_addattr32(&req->nlh, size, CTA_ID, htonl(ct->id));
+}
Index: libnetfilter_conntrack/src/getter.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ libnetfilter_conntrack/src/getter.c	2006-10-30 02:11:18.000000000 +0100
@@ -0,0 +1,179 @@
+/*
+ * (C) 2006 by Pablo Neira Ayuso <pablo@netfilter.net>
+ *
+ * This software may be used and distributed according to the terms
+ * of the GNU General Public License, incorporated herein by reference.
+ */
+
+#include "internal.h"
+
+static const void *get_attr_orig_ipv4_src(const struct nf_conntrack *ct)
+{
+	return &ct->tuple[__DIR_ORIG].src.v4;
+}
+
+static const void *get_attr_orig_ipv4_dst(const struct nf_conntrack *ct)
+{
+	return &ct->tuple[__DIR_ORIG].dst.v4;
+}
+
+static const void *get_attr_repl_ipv4_src(const struct nf_conntrack *ct)
+{
+	return &ct->tuple[__DIR_REPL].src.v4;
+}
+
+static const void *get_attr_repl_ipv4_dst(const struct nf_conntrack *ct)
+{
+	return &ct->tuple[__DIR_REPL].dst.v4;
+}
+
+static const void *get_attr_orig_ipv6_src(const struct nf_conntrack *ct)
+{
+	return &ct->tuple[__DIR_ORIG].src.v6;
+}
+
+static const void *get_attr_orig_ipv6_dst(const struct nf_conntrack *ct)
+{
+	return &ct->tuple[__DIR_ORIG].dst.v6;
+}
+
+static const void *get_attr_repl_ipv6_src(const struct nf_conntrack *ct)
+{
+	return &ct->tuple[__DIR_REPL].src.v6;
+}
+
+static const void *get_attr_repl_ipv6_dst(const struct nf_conntrack *ct)
+{
+	return &ct->tuple[__DIR_REPL].dst.v6;
+}
+
+static const void *get_attr_orig_port_src(const struct nf_conntrack *ct)
+{
+	return &ct->tuple[__DIR_ORIG].l4src.all; 
+}
+
+static const void *get_attr_orig_port_dst(const struct nf_conntrack *ct)
+{
+	return &ct->tuple[__DIR_ORIG].l4dst.all; 
+}
+
+static const void *get_attr_repl_port_src(const struct nf_conntrack *ct)
+{
+	return &ct->tuple[__DIR_REPL].l4src.all; 
+}
+
+static const void *get_attr_repl_port_dst(const struct nf_conntrack *ct)
+{
+	return &ct->tuple[__DIR_REPL].l4dst.all;
+}
+
+static const void *get_attr_icmp_type(const struct nf_conntrack *ct)
+{
+	return &ct->tuple[__DIR_ORIG].l4dst.icmp.type;
+}
+
+static const void *get_attr_icmp_code(const struct nf_conntrack *ct)
+{
+	return &ct->tuple[__DIR_ORIG].l4dst.icmp.code;
+}
+
+static const void *get_attr_icmp_id(const struct nf_conntrack *ct)
+{
+	return &ct->tuple[__DIR_ORIG].l4src.icmp.id;
+}
+
+static const void *get_attr_orig_l3proto(const struct nf_conntrack *ct)
+{
+	return &ct->tuple[__DIR_ORIG].l3protonum;
+}
+
+static const void *get_attr_repl_l3proto(const struct nf_conntrack *ct)
+{
+	return &ct->tuple[__DIR_REPL].l3protonum;
+}
+
+static const void *get_attr_orig_l4proto(const struct nf_conntrack *ct)
+{
+	return &ct->tuple[__DIR_ORIG].protonum;
+}
+
+static const void *get_attr_repl_l4proto(const struct nf_conntrack *ct)
+{
+	return &ct->tuple[__DIR_REPL].protonum;
+}
+
+static const void *get_attr_tcp_state(const struct nf_conntrack *ct)
+{
+	return &ct->protoinfo.tcp.state;
+}
+
+static const void *get_attr_snat_ipv4(const struct nf_conntrack *ct)
+{
+	return &ct->snat.min_ip;
+}
+
+static const void *get_attr_dnat_ipv4(const struct nf_conntrack *ct)
+{
+	return &ct->dnat.min_ip;
+}
+
+static const void *get_attr_snat_port(const struct nf_conntrack *ct)
+{
+	return &ct->snat.l4min.all;
+}
+
+static const void *get_attr_dnat_port(const struct nf_conntrack *ct)
+{
+	return &ct->dnat.l4min.all;
+}
+
+static const void *get_attr_timeout(const struct nf_conntrack *ct)
+{
+	return &ct->timeout;
+}
+
+static const void *get_attr_mark(const struct nf_conntrack *ct)
+{
+	return &ct->mark;
+}
+
+static const void *get_attr_assured(const struct nf_conntrack *ct)
+{
+	return &ct->status;
+}
+
+static const void *get_attr_seen_reply(const struct nf_conntrack *ct)
+{
+	return &ct->status;
+}
+
+get_attr get_attr_array[] = {
+	[ATTR_ORIG_IPV4_SRC]	= get_attr_orig_ipv4_src,
+	[ATTR_ORIG_IPV4_DST] 	= get_attr_orig_ipv4_dst,
+	[ATTR_REPL_IPV4_SRC]	= get_attr_repl_ipv4_src,
+	[ATTR_REPL_IPV4_DST]	= get_attr_repl_ipv4_dst,
+	[ATTR_ORIG_IPV6_SRC]	= get_attr_orig_ipv6_src,
+	[ATTR_ORIG_IPV6_DST]	= get_attr_orig_ipv6_dst,
+	[ATTR_REPL_IPV6_SRC]	= get_attr_repl_ipv6_src,
+	[ATTR_REPL_IPV6_DST]	= get_attr_repl_ipv6_dst,
+	[ATTR_ORIG_PORT_SRC]	= get_attr_orig_port_src,
+	[ATTR_ORIG_PORT_DST]	= get_attr_orig_port_dst,
+	[ATTR_REPL_PORT_SRC]	= get_attr_repl_port_src,
+	[ATTR_REPL_PORT_DST]	= get_attr_repl_port_dst,
+	[ATTR_ICMP_TYPE]	= get_attr_icmp_type,
+	[ATTR_ICMP_CODE]	= get_attr_icmp_code,
+	[ATTR_ICMP_ID]		= get_attr_icmp_id,
+	[ATTR_ORIG_L3PROTO]	= get_attr_orig_l3proto,
+	[ATTR_REPL_L3PROTO]	= get_attr_repl_l3proto,
+	[ATTR_ORIG_L4PROTO]	= get_attr_orig_l4proto,
+	[ATTR_REPL_L4PROTO]	= get_attr_repl_l4proto,
+	[ATTR_TCP_STATE]	= get_attr_tcp_state,
+	[ATTR_SNAT_IPV4]	= get_attr_snat_ipv4,
+	[ATTR_DNAT_IPV4]	= get_attr_dnat_ipv4,
+	[ATTR_SNAT_PORT]	= get_attr_snat_port,
+	[ATTR_DNAT_PORT]	= get_attr_dnat_port,
+	[ATTR_TIMEOUT]		= get_attr_timeout,
+	[ATTR_MARK]		= get_attr_mark,
+	[ATTR_ASSURED]		= get_attr_assured,
+	[ATTR_SEEN_REPLY]	= get_attr_seen_reply,
+};
Index: libnetfilter_conntrack/src/setter.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ libnetfilter_conntrack/src/setter.c	2006-10-30 02:11:18.000000000 +0100
@@ -0,0 +1,179 @@
+/*
+ * (C) 2006 by Pablo Neira Ayuso <pablo@netfilter.net>
+ *
+ * This software may be used and distributed according to the terms
+ * of the GNU General Public License, incorporated herein by reference.
+ */
+
+#include "internal.h"
+
+static void set_attr_orig_ipv4_src(struct nf_conntrack *ct, const void *value)
+{
+	ct->tuple[__DIR_ORIG].src.v4 = *((u_int32_t *) value);
+}
+
+static void set_attr_orig_ipv4_dst(struct nf_conntrack *ct, const void *value)
+{
+	ct->tuple[__DIR_ORIG].dst.v4 = *((u_int32_t *) value);
+}
+
+static void set_attr_repl_ipv4_src(struct nf_conntrack *ct, const void *value)
+{
+	ct->tuple[__DIR_REPL].src.v4 = *((u_int32_t *) value);
+}
+
+static void set_attr_repl_ipv4_dst(struct nf_conntrack *ct, const void *value)
+{
+	ct->tuple[__DIR_REPL].dst.v4 = *((u_int32_t *) value);
+}
+
+static void set_attr_orig_ipv6_src(struct nf_conntrack *ct, const void *value)
+{
+	memcpy(&ct->tuple[__DIR_ORIG].src.v6, value, sizeof(u_int32_t)*4);
+}
+
+static void set_attr_orig_ipv6_dst(struct nf_conntrack *ct, const void *value)
+{
+	memcpy(&ct->tuple[__DIR_ORIG].dst.v6, value, sizeof(u_int32_t)*4);
+}
+
+static void set_attr_repl_ipv6_src(struct nf_conntrack *ct, const void *value)
+{
+	memcpy(&ct->tuple[__DIR_REPL].src.v6, value, sizeof(u_int32_t)*4);
+}
+
+static void set_attr_repl_ipv6_dst(struct nf_conntrack *ct, const void *value)
+{
+	memcpy(&ct->tuple[__DIR_REPL].dst.v6, value, sizeof(u_int32_t)*4);
+}
+
+static void set_attr_orig_port_src(struct nf_conntrack *ct, const void *value)
+{
+	ct->tuple[__DIR_ORIG].l4src.all = *((u_int16_t *) value);
+}
+
+static void set_attr_orig_port_dst(struct nf_conntrack *ct, const void *value)
+{
+	ct->tuple[__DIR_ORIG].l4dst.all = *((u_int16_t *) value);
+}
+
+static void set_attr_repl_port_src(struct nf_conntrack *ct, const void *value)
+{
+	ct->tuple[__DIR_REPL].l4src.all = *((u_int16_t *) value);
+}
+
+static void set_attr_repl_port_dst(struct nf_conntrack *ct, const void *value)
+{
+	ct->tuple[__DIR_REPL].l4dst.all = *((u_int16_t *) value);
+}
+
+static void set_attr_icmp_type(struct nf_conntrack *ct, const void *value)
+{
+	ct->tuple[__DIR_ORIG].l4dst.icmp.type = *((u_int8_t *) value);
+}
+
+static void set_attr_icmp_code(struct nf_conntrack *ct, const void *value)
+{
+	ct->tuple[__DIR_ORIG].l4dst.icmp.code = *((u_int8_t *) value);
+}
+
+static void set_attr_icmp_id(struct nf_conntrack *ct, const void *value)
+{
+	ct->tuple[__DIR_ORIG].l4src.icmp.id = *((u_int8_t *) value);
+}
+
+static void set_attr_orig_l3proto(struct nf_conntrack *ct, const void *value)
+{
+	ct->tuple[__DIR_ORIG].l3protonum = *((u_int8_t *) value);
+}
+
+static void set_attr_repl_l3proto(struct nf_conntrack *ct, const void *value)
+{
+	ct->tuple[__DIR_REPL].l3protonum = *((u_int8_t *) value);
+}
+
+static void set_attr_orig_l4proto(struct nf_conntrack *ct, const void *value)
+{
+	ct->tuple[__DIR_ORIG].protonum = *((u_int8_t *) value);
+}
+
+static void set_attr_repl_l4proto(struct nf_conntrack *ct, const void *value)
+{
+	ct->tuple[__DIR_REPL].protonum = *((u_int8_t *) value);
+}
+
+static void set_attr_tcp_state(struct nf_conntrack *ct, const void *value)
+{
+	ct->protoinfo.tcp.state = *((u_int8_t *) value);
+}
+
+static void set_attr_snat_ipv4(struct nf_conntrack *ct, const void *value)
+{
+	ct->snat.min_ip = ct->snat.max_ip = *((u_int32_t *) value);
+}
+
+static void set_attr_dnat_ipv4(struct nf_conntrack *ct, const void *value)
+{
+	ct->dnat.min_ip = ct->snat.max_ip = *((u_int32_t *) value);
+}
+
+static void set_attr_snat_port(struct nf_conntrack *ct, const void *value)
+{
+	ct->snat.l4min.all = ct->snat.l4max.all = *((u_int16_t *) value);
+}
+
+static void set_attr_dnat_port(struct nf_conntrack *ct, const void *value)
+{
+	ct->dnat.l4min.all = ct->dnat.l4max.all = *((u_int16_t *) value);
+}
+
+static void set_attr_timeout(struct nf_conntrack *ct, const void *value)
+{
+	ct->timeout = *((u_int32_t *) value);
+}
+
+static void set_attr_mark(struct nf_conntrack *ct, const void *value)
+{
+	ct->mark = *((u_int32_t *) value);
+}
+
+static void set_attr_assured(struct nf_conntrack *ct, const void *value)
+{
+	ct->status |= IPS_ASSURED;
+}
+
+static void set_attr_seen_reply(struct nf_conntrack *ct, const void *value)
+{
+	ct->status |= IPS_SEEN_REPLY;
+}
+
+set_attr set_attr_array[] = {
+	[ATTR_ORIG_IPV4_SRC]	= set_attr_orig_ipv4_src,
+	[ATTR_ORIG_IPV4_DST] 	= set_attr_orig_ipv4_dst,
+	[ATTR_REPL_IPV4_SRC]	= set_attr_repl_ipv4_src,
+	[ATTR_REPL_IPV4_DST]	= set_attr_repl_ipv4_dst,
+	[ATTR_ORIG_IPV6_SRC]	= set_attr_orig_ipv6_src,
+	[ATTR_ORIG_IPV6_DST]	= set_attr_orig_ipv6_dst,
+	[ATTR_REPL_IPV6_SRC]	= set_attr_repl_ipv6_src,
+	[ATTR_REPL_IPV6_DST]	= set_attr_repl_ipv6_dst,
+	[ATTR_ORIG_PORT_SRC]	= set_attr_orig_port_src,
+	[ATTR_ORIG_PORT_DST]	= set_attr_orig_port_dst,
+	[ATTR_REPL_PORT_SRC]	= set_attr_repl_port_src,
+	[ATTR_REPL_PORT_DST]	= set_attr_repl_port_dst,
+	[ATTR_ICMP_TYPE]	= set_attr_icmp_type,
+	[ATTR_ICMP_CODE]	= set_attr_icmp_code,
+	[ATTR_ICMP_ID]		= set_attr_icmp_id,
+	[ATTR_ORIG_L3PROTO]	= set_attr_orig_l3proto,
+	[ATTR_REPL_L3PROTO]	= set_attr_repl_l3proto,
+	[ATTR_ORIG_L4PROTO]	= set_attr_orig_l4proto,
+	[ATTR_REPL_L4PROTO]	= set_attr_repl_l4proto,
+	[ATTR_TCP_STATE]	= set_attr_tcp_state,
+	[ATTR_SNAT_IPV4]	= set_attr_snat_ipv4,
+	[ATTR_DNAT_IPV4]	= set_attr_dnat_ipv4,
+	[ATTR_SNAT_PORT]	= set_attr_snat_port,
+	[ATTR_DNAT_PORT]	= set_attr_dnat_port,
+	[ATTR_TIMEOUT]		= set_attr_timeout,
+	[ATTR_MARK]		= set_attr_mark,
+	[ATTR_ASSURED]		= set_attr_assured,
+	[ATTR_SEEN_REPLY]	= set_attr_seen_reply,
+};
Index: libnetfilter_conntrack/src/internal.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ libnetfilter_conntrack/src/internal.h	2006-10-30 02:11:18.000000000 +0100
@@ -0,0 +1,133 @@
+/*
+ * (C) 2006 by Pablo Neira Ayuso <pablo@netfilter.net>
+ *
+ * This software may be used and distributed according to the terms
+ * of the GNU General Public License, incorporated herein by reference.
+ * 
+ * WARNING: Do *NOT* ever include this file, only for internal use!
+ * 	    Use the set/get API in order to set/get the conntrack attributes
+ */
+
+#ifndef __LIBNETFILTER_CONNTRACK_INTERNAL__
+#define __LIBNETFILTER_CONNTRACK_INTERNAL__
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/types.h>
+#include <arpa/inet.h>
+#include <libnetfilter_conntrack/libnetfilter_conntrack.h>
+
+struct nfct_handle;
+
+typedef void (*set_attr)(struct nf_conntrack *ct, const void *value);
+typedef const void *(*get_attr)(const struct nf_conntrack *ct);
+
+extern set_attr set_attr_array[];
+extern get_attr get_attr_array[];
+
+union __nfct_l4 {
+	/* Add other protocols here. */
+	u_int16_t all;
+	struct {
+		u_int16_t port;
+	} tcp;
+	struct {
+		u_int16_t port;
+	} udp;
+	struct {
+		u_int8_t type, code;
+		u_int16_t id;
+	} icmp;
+	struct {
+		u_int16_t port;
+	} sctp;
+};
+
+union __nfct_address {
+	u_int32_t v4;
+	struct in6_addr v6;
+};
+
+struct __nfct_tuple {
+	union __nfct_address src;
+	union __nfct_address dst;
+
+	u_int8_t l3protonum;
+	u_int8_t protonum;
+	union __nfct_l4 l4src;
+	union __nfct_l4 l4dst;
+};
+
+union __nfct_protoinfo {
+	struct {
+		u_int8_t state;
+	} tcp;
+};
+
+struct __nfct_counters {
+	u_int64_t packets;
+	u_int64_t bytes;
+};
+
+struct __nfct_nat {
+	u_int32_t min_ip, max_ip;
+	union __nfct_l4 l4min, l4max;
+};
+
+#define __DIR_ORIG 0
+#define __DIR_REPL 1
+#define __DIR_MAX __DIR_REPL+1
+
+struct nf_conntrack {
+	struct __nfct_tuple tuple[__DIR_MAX];
+	
+	u_int32_t 	timeout;
+	u_int32_t	mark;
+	u_int32_t 	status;
+	u_int32_t	use;
+	u_int32_t	id;
+
+	union __nfct_protoinfo protoinfo;
+	struct __nfct_counters counters[__DIR_MAX];
+	struct __nfct_nat snat;
+	struct __nfct_nat dnat;
+
+	u_int32_t set[2];
+};
+
+static inline void set_bit(int nr, u_int32_t *addr)
+{
+	addr[nr >> 5] |= (1UL << (nr & 31));
+}
+
+static inline int test_bit(int nr, const u_int32_t *addr)
+{
+	return ((1UL << (nr & 31)) & (addr[nr >> 5])) != 0;
+}
+
+static char *proto2str[IPPROTO_MAX] = {
+	[IPPROTO_TCP] = "tcp",
+        [IPPROTO_UDP] = "udp",
+        [IPPROTO_ICMP] = "icmp",
+        [IPPROTO_SCTP] = "sctp"
+};
+static char *l3proto2str[AF_MAX] = {
+	[AF_INET] = "ipv4",
+	[AF_INET6] = "ipv6"
+};
+
+static const char *states[] = {
+	"NONE",
+	"SYN_SENT",
+	"SYN_RECV",
+	"ESTABLISHED",
+	"FIN_WAIT",
+	"CLOSE_WAIT",
+	"LAST_ACK",
+	"TIME_WAIT",
+	"CLOSE",
+	"LISTEN"
+};
+
+#endif
Index: libnetfilter_conntrack/src/parse.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ libnetfilter_conntrack/src/parse.c	2006-10-30 02:11:18.000000000 +0100
@@ -0,0 +1,231 @@
+/*
+ * (C) 2006 by Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This software may be used and distributed according to the terms
+ * of the GNU General Public License, incorporated herein by reference.
+ */
+
+#include "internal.h"
+
+void __parse_ip(const struct nfattr *attr,
+		struct __nfct_tuple *tuple,
+		const int dir,
+		u_int32_t *set)
+{
+	struct nfattr *tb[CTA_IP_MAX];
+
+        nfnl_parse_nested(tb, CTA_IP_MAX, attr);
+
+	if (tb[CTA_IP_V4_SRC-1]) {
+		tuple->src.v4 = *(u_int32_t *)NFA_DATA(tb[CTA_IP_V4_SRC-1]);
+		switch(dir) {
+		case __DIR_ORIG:
+			set_bit(ATTR_ORIG_IPV4_SRC, set);
+			break;
+		case __DIR_REPL:
+			set_bit(ATTR_REPL_IPV4_SRC, set);
+			break;
+		}
+	}
+
+	if (tb[CTA_IP_V4_DST-1]) {
+		tuple->dst.v4 = *(u_int32_t *)NFA_DATA(tb[CTA_IP_V4_DST-1]);
+		switch(dir) {
+		case __DIR_ORIG:
+			set_bit(ATTR_ORIG_IPV4_DST, set);
+			break;
+		case __DIR_REPL:
+			set_bit(ATTR_REPL_IPV4_DST, set);
+			break;
+		}
+	}
+
+	if (tb[CTA_IP_V6_SRC-1]) {
+		memcpy(&tuple->src.v6, NFA_DATA(tb[CTA_IP_V6_SRC-1]), 
+		       sizeof(struct in6_addr));
+		switch(dir) {
+		case __DIR_ORIG:
+			set_bit(ATTR_ORIG_IPV6_SRC, set);
+			break;
+		case __DIR_REPL:
+			set_bit(ATTR_REPL_IPV6_SRC, set);
+			break;
+		}
+	}
+
+	if (tb[CTA_IP_V6_DST-1]) {
+		memcpy(&tuple->dst.v6, NFA_DATA(tb[CTA_IP_V6_DST-1]),
+		       sizeof(struct in6_addr));
+		switch(dir) {
+		case __DIR_ORIG:
+			set_bit(ATTR_ORIG_IPV6_DST, set);
+			break;
+		case __DIR_REPL:
+			set_bit(ATTR_REPL_IPV6_DST, set);
+			break;
+		}
+	}
+}
+
+void __parse_proto(const struct nfattr *attr,
+		   struct __nfct_tuple *tuple,
+		   const int dir,
+		   u_int32_t *set)
+{
+	struct nfattr *tb[CTA_PROTO_MAX];
+
+	nfnl_parse_nested(tb, CTA_PROTO_MAX, attr);
+
+	if (tb[CTA_PROTO_NUM-1]) {
+		tuple->protonum = *(u_int8_t *)NFA_DATA(tb[CTA_PROTO_NUM-1]);
+		switch(dir) {
+		case __DIR_ORIG:
+			set_bit(ATTR_ORIG_L4PROTO, set);
+			break;
+		case __DIR_REPL:
+			set_bit(ATTR_REPL_L4PROTO, set);
+			break;
+		}
+	}
+
+	if (tb[CTA_PROTO_SRC_PORT-1]) {
+		tuple->l4src.tcp.port =
+			*(u_int16_t *)NFA_DATA(tb[CTA_PROTO_SRC_PORT-1]);
+		switch(dir) {
+		case __DIR_ORIG:
+			set_bit(ATTR_ORIG_PORT_SRC, set);
+			break;
+		case __DIR_REPL:
+			set_bit(ATTR_REPL_PORT_SRC, set);
+			break;
+		}
+	}
+	
+	if (tb[CTA_PROTO_DST_PORT-1]) {
+		tuple->l4dst.tcp.port =
+			*(u_int16_t *)NFA_DATA(tb[CTA_PROTO_DST_PORT-1]);
+		switch(dir) {
+		case __DIR_ORIG:
+			set_bit(ATTR_ORIG_PORT_DST, set);
+			break;
+		case __DIR_REPL:
+			set_bit(ATTR_REPL_PORT_DST, set);
+			break;
+		}
+	}
+	
+	if (tb[CTA_PROTO_ICMP_TYPE-1]) {
+		tuple->l4dst.icmp.type =
+			*(u_int8_t *)NFA_DATA(tb[CTA_PROTO_ICMP_TYPE-1]);
+		set_bit(ATTR_ICMP_TYPE, set);
+	}
+	
+	if (tb[CTA_PROTO_ICMP_CODE-1]) {
+		tuple->l4dst.icmp.code =
+			*(u_int8_t *)NFA_DATA(tb[CTA_PROTO_ICMP_CODE-1]);
+		set_bit(ATTR_ICMP_CODE, set);
+	}
+	
+	if (tb[CTA_PROTO_ICMP_ID-1]) {
+		tuple->l4src.icmp.id =
+			*(u_int16_t *)NFA_DATA(tb[CTA_PROTO_ICMP_ID-1]);
+		set_bit(ATTR_ICMP_ID, set);
+	}
+}
+
+void __parse_tuple(const struct nfattr *attr,
+		   struct __nfct_tuple *tuple, 
+		   int dir,
+		   u_int32_t *set)
+{
+	struct nfattr *tb[CTA_TUPLE_MAX];
+
+	nfnl_parse_nested(tb, CTA_TUPLE_MAX, attr);
+
+	if (tb[CTA_TUPLE_IP-1])
+		__parse_ip(tb[CTA_TUPLE_IP-1], tuple, dir, set);
+	if (tb[CTA_TUPLE_PROTO-1])
+		__parse_proto(tb[CTA_TUPLE_PROTO-1], tuple, dir, set);
+}
+
+void __parse_mask(const struct nfattr *attr,
+		 struct __nfct_tuple *tuple,
+		 const u_int8_t l3protonum, 
+		 const u_int16_t protonum,
+		 u_int32_t *set)
+{
+	__parse_tuple(attr, tuple, __DIR_ORIG, set);
+}
+
+void __parse_protoinfo(const struct nfattr *attr, struct nf_conntrack *ct)
+{
+	struct nfattr *tb[CTA_PROTOINFO_MAX];
+
+	nfnl_parse_nested(tb, CTA_PROTOINFO_MAX, attr);
+
+	if (!tb[CTA_PROTOINFO_TCP-1])
+		return 0;
+
+	nfnl_parse_nested(tb, CTA_PROTOINFO_TCP_MAX, tb[CTA_PROTOINFO_TCP-1]);
+
+	if (tb[CTA_PROTOINFO_TCP_STATE-1]) {
+                ct->protoinfo.tcp.state =
+                        *(u_int8_t *)NFA_DATA(tb[CTA_PROTOINFO_TCP_STATE-1]);
+		set_bit(ATTR_TCP_STATE, ct->set);
+	}
+}
+
+void __parse_counters(const struct nfattr *attr,
+	 	      struct nf_conntrack *ct,
+		      enum ctattr_type parent)
+{
+	struct nfattr *tb[CTA_COUNTERS_MAX];
+	int dir = (parent == CTA_COUNTERS_ORIG ? __DIR_REPL 
+					       : __DIR_ORIG);
+
+	nfnl_parse_nested(tb, CTA_COUNTERS_MAX, attr);
+	if (tb[CTA_COUNTERS_PACKETS-1]) {
+		ct->counters[dir].packets
+			= __be64_to_cpu(*(u_int64_t *)
+					NFA_DATA(tb[CTA_COUNTERS_PACKETS-1]));
+		switch(dir) {
+		case __DIR_ORIG:
+			set_bit(ATTR_ORIG_COUNTER_PACKETS, ct->set);
+			break;
+		case __DIR_REPL:
+			set_bit(ATTR_REPL_COUNTER_PACKETS, ct->set);
+			break;
+		}
+	}
+	if (tb[CTA_COUNTERS_BYTES-1]) {
+		ct->counters[dir].bytes
+			= __be64_to_cpu(*(u_int64_t *)
+					NFA_DATA(tb[CTA_COUNTERS_BYTES-1]));
+		switch(dir) {
+		case __DIR_ORIG:
+			set_bit(ATTR_ORIG_COUNTER_BYTES, ct->set);
+			break;
+		case __DIR_REPL:
+			set_bit(ATTR_REPL_COUNTER_BYTES, ct->set);
+			break;
+		}
+	}
+}
+
+int __msgtype2enum(struct nlmsghdr *nlh)
+{
+	u_int16_t type = NFNL_MSG_TYPE(nlh->nlmsg_type);
+	u_int16_t flags = nlh->nlmsg_flags;
+	int ret = NFCT_MSG_UNKNOWN;
+
+	if (type == IPCTNL_MSG_CT_NEW) {
+		if (flags & (NLM_F_CREATE|NLM_F_EXCL))
+			ret = NFCT_MSG_NEW;
+		else
+			ret = NFCT_MSG_UPDATE;
+	} else if (type == IPCTNL_MSG_CT_DELETE)
+		ret = NFCT_MSG_DESTROY;
+
+	return ret;
+}
+
Index: libnetfilter_conntrack/src/sprint.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ libnetfilter_conntrack/src/sprint.c	2006-10-30 02:11:18.000000000 +0100
@@ -0,0 +1,137 @@
+/*
+ * (C) 2006 by Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This software may be used and distributed according to the terms
+ * of the GNU General Public License, incorporated herein by reference.
+ */
+
+#include "internal.h"
+
+int __sprintf_protocol(char *buf, struct nf_conntrack *ct)
+{
+	return (sprintf(buf, "%-8s %u ", 
+		proto2str[ct->tuple[__DIR_ORIG].protonum] == NULL ?
+		"unknown" : proto2str[ct->tuple[__DIR_ORIG].protonum], 
+		 ct->tuple[__DIR_ORIG].protonum));
+}
+
+int __sprintf_timeout(char *buf, struct nf_conntrack *ct)
+{
+	return sprintf(buf, "%u ", ct->timeout);
+}
+
+int __sprintf_protoinfo(char *buf, struct nf_conntrack *ct)
+{
+	int size = 0;
+
+	if (test_bit(ATTR_TCP_STATE, ct->set))
+		size = sprintf(buf, "%s ", states[ct->protoinfo.tcp.state]);
+
+	return size;
+}
+
+int __sprintf_address(char *buf, struct nfct_tuple *tuple)
+{
+	int size = 0;
+
+	switch (tuple->l3protonum) {
+	case AF_INET:
+		{
+		struct in_addr src = { .s_addr = tuple->src.v4 };
+		struct in_addr dst = { .s_addr = tuple->dst.v4 };
+
+		size = sprintf(buf, "src=%s ", inet_ntoa(src));
+		size += sprintf(buf+size, "dst=%s ", inet_ntoa(dst));
+		}
+		break;
+	case AF_INET6:
+		{
+		struct in6_addr src;
+		struct in6_addr dst;
+		char tmp[INET6_ADDRSTRLEN];
+
+		memcpy(&src.in6_u, tuple->src.v6, sizeof(struct in6_addr));
+		memcpy(&dst.in6_u, tuple->dst.v6, sizeof(struct in6_addr));
+
+		if (!inet_ntop(AF_INET6, &src, tmp, sizeof(tmp)))
+			return 0;
+
+		size = sprintf(buf, "src=%s ", tmp); 
+
+		if (!inet_ntop(AF_INET6, &dst, tmp, sizeof(tmp)))
+			return 0;
+
+		size += sprintf(buf + size, "dst=%s ", tmp);
+		}
+		break;
+	}
+
+	return size;
+}
+
+int __sprintf_proto(char *buf, struct nfct_tuple *tuple)
+{
+	int size = 0;
+
+	switch(tuple->protonum) {
+	case IPPROTO_TCP:
+	case IPPROTO_UDP:
+	case IPPROTO_SCTP:
+		sprintf(buf, "sport=%u dport=%u ",
+			htons(tuple->l4src.tcp.port),
+			htons(tuple->l4dst.tcp.port));
+		break;
+	case IPPROTO_ICMP:
+		/* The ID only makes sense some ICMP messages but we want to
+		 * display the same output that /proc/net/ip_conntrack does */
+		return (sprintf(buf, "type=%d code=%d id=%d ",
+			tuple->l4dst.icmp.type,
+			tuple->l4dst.icmp.code,
+			ntohs(tuple->l4src.icmp.id)));
+		break;
+	}
+
+	return size;
+}
+
+int __sprintf_status_assured(char *buf, struct nf_conntrack *ct)
+{
+	int size = 0;
+	
+	if (ct->status & IPS_ASSURED)
+		size = sprintf(buf, "[ASSURED] ");
+
+	return size;
+}
+
+int __sprintf_status_seen_reply(char *buf, struct nf_conntrack *ct)
+{
+	int size = 0;
+	
+        if (!(ct->status & IPS_SEEN_REPLY))
+                size = sprintf(buf, "[UNREPLIED] ");
+
+	return size;
+}
+
+int __sprintf_counters(char *buf, struct nf_conntrack *ct, int dir)
+{
+	return (sprintf(buf, "packets=%llu bytes=%llu ",
+			(unsigned long long) ct->counters[dir].packets,
+			(unsigned long long) ct->counters[dir].bytes));
+}
+
+int __sprintf_mark(char *buf, struct nf_conntrack *ct)
+{
+	return (sprintf(buf, "mark=%u ", ct->mark));
+}
+
+int __sprintf_use(char *buf, struct nf_conntrack *ct)
+{
+	return (sprintf(buf, "use=%u ", ct->use));
+}
+
+int __sprintf_id(char *buf, u_int32_t id)
+{
+	return (sprintf(buf, "id=%u ", id));
+}
Index: libnetfilter_conntrack/utils/test.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ libnetfilter_conntrack/utils/test.c	2006-10-30 02:11:18.000000000 +0100
@@ -0,0 +1,58 @@
+#include <stdio.h>
+#include <libnetfilter_conntrack/libnetfilter_conntrack.h>
+
+int main()
+{
+	int ret;
+	struct nfct_handle *h;
+	struct nf_conntrack *ct;
+	char buf[1024];
+
+	ct = nfct_new();
+	if (!ct) {
+		perror("nfct_new");
+		return 0;
+	}
+
+	nfct_set_attr_u8(ct, ATTR_ORIG_L3PROTO, AF_INET);
+	nfct_set_attr_u32(ct, ATTR_ORIG_IPV4_SRC, inet_addr("1.1.1.1"));
+	nfct_set_attr_u32(ct, ATTR_ORIG_IPV4_DST, inet_addr("2.2.2.2"));
+	
+	nfct_set_attr_u8(ct, ATTR_ORIG_L4PROTO, IPPROTO_TCP);
+	nfct_set_attr_u16(ct, ATTR_ORIG_PORT_SRC, ntohs(20));
+	nfct_set_attr_u16(ct, ATTR_ORIG_PORT_DST, ntohs(10));
+
+	nfct_set_attr_u8(ct, ATTR_REPL_L3PROTO, AF_INET);
+	nfct_set_attr_u32(ct, ATTR_REPL_IPV4_SRC, inet_addr("2.2.2.2"));
+	nfct_set_attr_u32(ct, ATTR_REPL_IPV4_DST, inet_addr("1.1.1.1"));
+	
+	nfct_set_attr_u8(ct, ATTR_REPL_L4PROTO, IPPROTO_TCP);
+	nfct_set_attr_u16(ct, ATTR_REPL_PORT_SRC, ntohs(10));
+	nfct_set_attr_u16(ct, ATTR_REPL_PORT_DST, ntohs(20));
+
+	nfct_set_attr_u8(ct, ATTR_TCP_STATE, 1);
+	nfct_set_attr_u32(ct, ATTR_TIMEOUT, 100);
+
+	nfct_sprintf(buf, ct);
+	printf("Test conntrack: %s\n", buf);
+
+	h = nfct_open(CONNTRACK, 0);
+	if (!h) {
+		fprintf(stderr, "Can't open handler\n");
+		return -1;
+	}
+
+	ret = nfct_query(h, NFCT_Q_CREATE, ct);
+
+	printf("create ret = %d\n", ret);
+
+	ret = nfct_query(h, NFCT_Q_UPDATE, ct);
+
+	printf("update ret = %d\n", ret);
+
+	ret = nfct_query(h, NFCT_Q_DESTROY, ct);
+
+	printf("destroy ret = %d\n", ret);
+
+	nfct_close(h);
+}

--------------000203070703030809040604--
