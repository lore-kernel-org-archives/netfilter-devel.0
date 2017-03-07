From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnetfilter_conntrack] src: remove old libnfnetlink parsers
Date: Tue,  7 Mar 2017 14:34:03 +0100
Message-ID: <1488893643-23108-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54838 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755246AbdCGOAA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Mar 2017 09:00:00 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C156D19D8A3
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Mar 2017 14:34:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A297EDA818
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Mar 2017 14:34:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5F67EDA807
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Mar 2017 14:34:07 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use the new parsers that are based on libmnl, yet another small step to
reduce dependencies with the old libnfnetlink library.

Backward compatibility is preserved after this change. Otherwise, report
a bug since this patch should not affect existing behaviour.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/internal/prototypes.h |   5 -
 src/callback.c                |   8 +-
 src/conntrack/Makefile.am     |   2 +-
 src/conntrack/api.c           |  31 ++-
 src/conntrack/parse.c         | 599 ------------------------------------------
 src/expect/Makefile.am        |   2 +-
 src/expect/api.c              |  30 ++-
 src/expect/parse.c            | 120 ---------
 8 files changed, 45 insertions(+), 752 deletions(-)
 delete mode 100644 src/conntrack/parse.c
 delete mode 100644 src/expect/parse.c

diff --git a/include/internal/prototypes.h b/include/internal/prototypes.h
index 251e57d4b277..c0047b3b2f01 100644
--- a/include/internal/prototypes.h
+++ b/include/internal/prototypes.h
@@ -6,9 +6,6 @@
  */
 int __build_conntrack(struct nfnl_subsys_handle *ssh, struct nfnlhdr *req, size_t size, uint16_t type, uint16_t flags, const struct nf_conntrack *ct);
 void __build_tuple(struct nfnlhdr *req, size_t size, const struct __nfct_tuple *t, const int type);
-int __parse_message_type(const struct nlmsghdr *nlh);
-void __parse_conntrack(const struct nlmsghdr *nlh, struct nfattr *cda[], struct nf_conntrack *ct);
-void __parse_tuple(const struct nfattr *attr, struct __nfct_tuple *tuple, int dir, uint32_t *set);
 int __snprintf_conntrack(char *buf, unsigned int len, const struct nf_conntrack *ct, unsigned int type, unsigned int msg_output, unsigned int flags, struct nfct_labelmap *);
 int __snprintf_address(char *buf, unsigned int len, const struct __nfct_tuple *tuple, const char *src_tag, const char *dst_tag);
 int __snprintf_protocol(char *buf, unsigned int len, const struct nf_conntrack *ct);
@@ -47,8 +44,6 @@ int nfct_parse_tuple(const struct nlattr *attr, struct __nfct_tuple *tuple, int
  * expectation internal prototypes
  */
 int __build_expect(struct nfnl_subsys_handle *ssh, struct nfnlhdr *req, size_t size, uint16_t type, uint16_t flags, const struct nf_expect *exp);
-int __parse_expect_message_type(const struct nlmsghdr *nlh);
-void __parse_expect(const struct nlmsghdr *nlh, struct nfattr *cda[], struct nf_expect *exp);
 int __expect_callback(struct nlmsghdr *nlh, struct nfattr *nfa[], void *data);
 int __cmp_expect(const struct nf_expect *exp1, const struct nf_expect *exp2, unsigned int flags);
 int __snprintf_expect(char *buf, unsigned int len, const struct nf_expect *exp, unsigned int type, unsigned int msg_output, unsigned int flags);
diff --git a/src/callback.c b/src/callback.c
index 69640dacd71d..7671dd64ffe8 100644
--- a/src/callback.c
+++ b/src/callback.c
@@ -8,6 +8,7 @@
  */
 
 #include "internal/internal.h"
+#include <libmnl/libmnl.h>
 
 static int __parse_message(const struct nlmsghdr *nlh)
 {
@@ -29,6 +30,9 @@ static int __parse_message(const struct nlmsghdr *nlh)
 	return ret;
 }
 
+/* This function uses libmnl helpers, the nfa[] array is intentionally not used
+ * since it has a different layout.
+ */
 int __callback(struct nlmsghdr *nlh, struct nfattr *nfa[], void *data)
 {
 	int ret = NFNL_CB_STOP;
@@ -52,7 +56,7 @@ int __callback(struct nlmsghdr *nlh, struct nfattr *nfa[], void *data)
 		if (ct == NULL)
 			return NFNL_CB_FAILURE;
 
-		__parse_conntrack(nlh, nfa, ct);
+		nfct_nlmsg_parse(nlh, ct);
 
 		if (container->h->cb) {
 			ret = container->h->cb(type, ct, container->data);
@@ -66,7 +70,7 @@ int __callback(struct nlmsghdr *nlh, struct nfattr *nfa[], void *data)
 		if (exp == NULL)
 			return NFNL_CB_FAILURE;
 
-		__parse_expect(nlh, nfa, exp);
+		nfexp_nlmsg_parse(nlh, exp);
 
 		if (container->h->expect_cb) {
 			ret = container->h->expect_cb(type, exp,
diff --git a/src/conntrack/Makefile.am b/src/conntrack/Makefile.am
index e1d8768b7850..602ed33ffe60 100644
--- a/src/conntrack/Makefile.am
+++ b/src/conntrack/Makefile.am
@@ -5,7 +5,7 @@ noinst_LTLIBRARIES = libnfconntrack.la
 libnfconntrack_la_SOURCES = api.c \
 			    getter.c setter.c \
 			    labels.c \
-			    parse.c build.c \
+			    build.c \
 			    parse_mnl.c build_mnl.c \
 			    snprintf.c \
 			    snprintf_default.c snprintf_xml.c \
diff --git a/src/conntrack/api.c b/src/conntrack/api.c
index bed2e42c8f43..3a1746e4c050 100644
--- a/src/conntrack/api.c
+++ b/src/conntrack/api.c
@@ -12,6 +12,7 @@
 #include <string.h> /* for memset */
 #include <errno.h>
 #include <assert.h>
+#include <libmnl/libmnl.h>
 
 #include "internal/internal.h"
 
@@ -880,6 +881,23 @@ int nfct_build_query(struct nfnl_subsys_handle *ssh,
 	return __build_query_ct(ssh, qt, data, buffer, size);
 }
 
+static int __parse_message_type(const struct nlmsghdr *nlh)
+{
+	uint16_t type = NFNL_MSG_TYPE(nlh->nlmsg_type);
+	uint16_t flags = nlh->nlmsg_flags;
+	int ret = NFCT_T_UNKNOWN;
+
+	if (type == IPCTNL_MSG_CT_NEW) {
+		if (flags & (NLM_F_CREATE|NLM_F_EXCL))
+			ret = NFCT_T_NEW;
+		else
+			ret = NFCT_T_UPDATE;
+	} else if (type == IPCTNL_MSG_CT_DELETE)
+		ret = NFCT_T_DESTROY;
+
+	return ret;
+}
+
 /**
  * nfct_parse_conntrack - translate a netlink message to a conntrack object
  * \param type do the translation iif the message type is of a certain type
@@ -909,26 +927,15 @@ int nfct_parse_conntrack(enum nf_conntrack_msg_type type,
 			 struct nf_conntrack *ct)
 {
 	unsigned int flags;
-	int len = nlh->nlmsg_len;
-	struct nfgenmsg *nfhdr = NLMSG_DATA(nlh);
-	struct nfattr *cda[CTA_MAX];
 
 	assert(nlh != NULL);
 	assert(ct != NULL);
 
-	len -= NLMSG_LENGTH(sizeof(struct nfgenmsg));
-	if (len < 0) {
-		errno = EINVAL;
-		return NFCT_T_ERROR;
-	}
-
 	flags = __parse_message_type(nlh);
 	if (!(flags & type))
 		return 0;
 
-	nfnl_parse_attr(cda, CTA_MAX, NFA_DATA(nfhdr), len);
-
-	__parse_conntrack(nlh, cda, ct);
+	nfct_nlmsg_parse(nlh, ct);
 
 	return flags;
 }
diff --git a/src/conntrack/parse.c b/src/conntrack/parse.c
deleted file mode 100644
index b52454b182de..000000000000
--- a/src/conntrack/parse.c
+++ /dev/null
@@ -1,599 +0,0 @@
-/*
- * (C) 2005-2011 by Pablo Neira Ayuso <pablo@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#include "internal/internal.h"
-#include <limits.h>
-#include <libmnl/libmnl.h>
-
-static void __parse_ip(const struct nfattr *attr,
-		       struct __nfct_tuple *tuple,
-		       const int dir,
-		       uint32_t *set)
-{
-	struct nfattr *tb[CTA_IP_MAX];
-
-        nfnl_parse_nested(tb, CTA_IP_MAX, attr);
-
-	if (tb[CTA_IP_V4_SRC-1]) {
-		tuple->src.v4 = *(uint32_t *)NFA_DATA(tb[CTA_IP_V4_SRC-1]);
-		switch(dir) {
-		case __DIR_ORIG:
-			set_bit(ATTR_ORIG_IPV4_SRC, set);
-			break;
-		case __DIR_REPL:
-			set_bit(ATTR_REPL_IPV4_SRC, set);
-			break;
-		case __DIR_MASTER:
-			set_bit(ATTR_MASTER_IPV4_SRC, set);
-			break;
-		}
-	}
-
-	if (tb[CTA_IP_V4_DST-1]) {
-		tuple->dst.v4 = *(uint32_t *)NFA_DATA(tb[CTA_IP_V4_DST-1]);
-		switch(dir) {
-		case __DIR_ORIG:
-			set_bit(ATTR_ORIG_IPV4_DST, set);
-			break;
-		case __DIR_REPL:
-			set_bit(ATTR_REPL_IPV4_DST, set);
-			break;
-		case __DIR_MASTER:
-			set_bit(ATTR_MASTER_IPV4_DST, set);
-			break;
-		}
-	}
-
-	if (tb[CTA_IP_V6_SRC-1]) {
-		memcpy(&tuple->src.v6, NFA_DATA(tb[CTA_IP_V6_SRC-1]), 
-		       sizeof(struct in6_addr));
-		switch(dir) {
-		case __DIR_ORIG:
-			set_bit(ATTR_ORIG_IPV6_SRC, set);
-			break;
-		case __DIR_REPL:
-			set_bit(ATTR_REPL_IPV6_SRC, set);
-			break;
-		case __DIR_MASTER:
-			set_bit(ATTR_MASTER_IPV6_SRC, set);
-			break;
-		}
-	}
-
-	if (tb[CTA_IP_V6_DST-1]) {
-		memcpy(&tuple->dst.v6, NFA_DATA(tb[CTA_IP_V6_DST-1]),
-		       sizeof(struct in6_addr));
-		switch(dir) {
-		case __DIR_ORIG:
-			set_bit(ATTR_ORIG_IPV6_DST, set);
-			break;
-		case __DIR_REPL:
-			set_bit(ATTR_REPL_IPV6_DST, set);
-			break;
-		case __DIR_MASTER:
-			set_bit(ATTR_MASTER_IPV6_DST, set);
-			break;
-		}
-	}
-}
-
-static void __parse_proto(const struct nfattr *attr,
-			  struct __nfct_tuple *tuple,
-		   const int dir,
-		   uint32_t *set)
-{
-	struct nfattr *tb[CTA_PROTO_MAX];
-
-	nfnl_parse_nested(tb, CTA_PROTO_MAX, attr);
-
-	if (tb[CTA_PROTO_NUM-1]) {
-		tuple->protonum = *(uint8_t *)NFA_DATA(tb[CTA_PROTO_NUM-1]);
-		switch(dir) {
-		case __DIR_ORIG:
-			set_bit(ATTR_ORIG_L4PROTO, set);
-			break;
-		case __DIR_REPL:
-			set_bit(ATTR_REPL_L4PROTO, set);
-			break;
-		case __DIR_MASTER:
-			set_bit(ATTR_MASTER_L4PROTO, set);
-			break;
-		}
-	}
-
-	if (tb[CTA_PROTO_SRC_PORT-1]) {
-		tuple->l4src.tcp.port =
-			*(uint16_t *)NFA_DATA(tb[CTA_PROTO_SRC_PORT-1]);
-		switch(dir) {
-		case __DIR_ORIG:
-			set_bit(ATTR_ORIG_PORT_SRC, set);
-			break;
-		case __DIR_REPL:
-			set_bit(ATTR_REPL_PORT_SRC, set);
-			break;
-		case __DIR_MASTER:
-			set_bit(ATTR_MASTER_PORT_SRC, set);
-			break;
-		}
-	}
-	
-	if (tb[CTA_PROTO_DST_PORT-1]) {
-		tuple->l4dst.tcp.port =
-			*(uint16_t *)NFA_DATA(tb[CTA_PROTO_DST_PORT-1]);
-		switch(dir) {
-		case __DIR_ORIG:
-			set_bit(ATTR_ORIG_PORT_DST, set);
-			break;
-		case __DIR_REPL:
-			set_bit(ATTR_REPL_PORT_DST, set);
-			break;
-		case __DIR_MASTER:
-			set_bit(ATTR_MASTER_PORT_DST, set);
-			break;
-		}
-	}
-	
-	if (tb[CTA_PROTO_ICMP_TYPE-1]) {
-		tuple->l4dst.icmp.type =
-			*(uint8_t *)NFA_DATA(tb[CTA_PROTO_ICMP_TYPE-1]);
-		set_bit(ATTR_ICMP_TYPE, set);
-	}
-	
-	if (tb[CTA_PROTO_ICMP_CODE-1]) {
-		tuple->l4dst.icmp.code =
-			*(uint8_t *)NFA_DATA(tb[CTA_PROTO_ICMP_CODE-1]);
-		set_bit(ATTR_ICMP_CODE, set);
-	}
-	
-	if (tb[CTA_PROTO_ICMP_ID-1]) {
-		tuple->l4src.icmp.id =
-			*(uint16_t *)NFA_DATA(tb[CTA_PROTO_ICMP_ID-1]);
-		set_bit(ATTR_ICMP_ID, set);
-	}
-
-	if (tb[CTA_PROTO_ICMPV6_TYPE-1]) {
-		tuple->l4dst.icmp.type =
-			*(uint8_t *)NFA_DATA(tb[CTA_PROTO_ICMPV6_TYPE-1]);
-		set_bit(ATTR_ICMP_TYPE, set);
-	}
-	
-	if (tb[CTA_PROTO_ICMPV6_CODE-1]) {
-		tuple->l4dst.icmp.code =
-			*(uint8_t *)NFA_DATA(tb[CTA_PROTO_ICMPV6_CODE-1]);
-		set_bit(ATTR_ICMP_CODE, set);
-	}
-	
-	if (tb[CTA_PROTO_ICMPV6_ID-1]) {
-		tuple->l4src.icmp.id =
-			*(uint16_t *)NFA_DATA(tb[CTA_PROTO_ICMPV6_ID-1]);
-		set_bit(ATTR_ICMP_ID, set);
-	}
-}
-
-void __parse_tuple(const struct nfattr *attr,
-		   struct __nfct_tuple *tuple, 
-		   int dir,
-		   uint32_t *set)
-{
-	struct nfattr *tb[CTA_TUPLE_MAX];
-
-	nfnl_parse_nested(tb, CTA_TUPLE_MAX, attr);
-
-	if (tb[CTA_TUPLE_IP-1])
-		__parse_ip(tb[CTA_TUPLE_IP-1], tuple, dir, set);
-	if (tb[CTA_TUPLE_PROTO-1])
-		__parse_proto(tb[CTA_TUPLE_PROTO-1], tuple, dir, set);
-
-	if (tb[CTA_TUPLE_ZONE-1]) {
-		tuple->zone = ntohs(*(uint16_t *)NFA_DATA(tb[CTA_TUPLE_ZONE-1]));
-		switch(dir) {
-		case __DIR_ORIG:
-			set_bit(ATTR_ORIG_ZONE, set);
-			break;
-		case __DIR_REPL:
-			set_bit(ATTR_REPL_ZONE, set);
-			break;
-		}
-	}
-}
-
-static void __parse_protoinfo_tcp(const struct nfattr *attr, 
-				  struct nf_conntrack *ct)
-{
-	struct nfattr *tb[CTA_PROTOINFO_TCP_MAX];
-
-	nfnl_parse_nested(tb, CTA_PROTOINFO_TCP_MAX, attr);
-
-	if (tb[CTA_PROTOINFO_TCP_STATE-1]) {
-                ct->protoinfo.tcp.state =
-                        *(uint8_t *)NFA_DATA(tb[CTA_PROTOINFO_TCP_STATE-1]);
-		set_bit(ATTR_TCP_STATE, ct->head.set);
-	}
-
-	if (tb[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL-1]) {
-		memcpy(&ct->protoinfo.tcp.wscale[__DIR_ORIG],
-		       NFA_DATA(tb[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL-1]),
-		       sizeof(uint8_t));
-		set_bit(ATTR_TCP_WSCALE_ORIG, ct->head.set);
-	}
-
-	if (tb[CTA_PROTOINFO_TCP_WSCALE_REPLY-1]) {
-		memcpy(&ct->protoinfo.tcp.wscale[__DIR_REPL],
-		       NFA_DATA(tb[CTA_PROTOINFO_TCP_WSCALE_REPLY-1]),
-		       sizeof(uint8_t));
-		set_bit(ATTR_TCP_WSCALE_REPL, ct->head.set);
-	}
-
-	if (tb[CTA_PROTOINFO_TCP_FLAGS_ORIGINAL-1]) {
-		memcpy(&ct->protoinfo.tcp.flags[0], 
-		       NFA_DATA(tb[CTA_PROTOINFO_TCP_FLAGS_ORIGINAL-1]),
-		       sizeof(struct nf_ct_tcp_flags));
-		set_bit(ATTR_TCP_FLAGS_ORIG, ct->head.set);
-		set_bit(ATTR_TCP_MASK_ORIG, ct->head.set);
-	}
-
-	if (tb[CTA_PROTOINFO_TCP_FLAGS_REPLY-1]) {
-		memcpy(&ct->protoinfo.tcp.flags[1], 
-		       NFA_DATA(tb[CTA_PROTOINFO_TCP_FLAGS_REPLY-1]),
-		       sizeof(struct nf_ct_tcp_flags));
-		set_bit(ATTR_TCP_FLAGS_REPL, ct->head.set);
-		set_bit(ATTR_TCP_MASK_REPL, ct->head.set);
-	}
-}
-
-static void __parse_protoinfo_sctp(const struct nfattr *attr, 
-				   struct nf_conntrack *ct)
-{
-	struct nfattr *tb[CTA_PROTOINFO_SCTP_MAX];
-
-	nfnl_parse_nested(tb, CTA_PROTOINFO_SCTP_MAX, attr);
-
-	if (tb[CTA_PROTOINFO_SCTP_STATE-1]) {
-                ct->protoinfo.sctp.state =
-                        *(uint8_t *)NFA_DATA(tb[CTA_PROTOINFO_SCTP_STATE-1]);
-		set_bit(ATTR_SCTP_STATE, ct->head.set);
-	}
-
-	if (tb[CTA_PROTOINFO_SCTP_VTAG_ORIGINAL-1]) {
-		ct->protoinfo.sctp.vtag[__DIR_ORIG] = 
-			ntohl(*(uint32_t *)NFA_DATA(tb[CTA_PROTOINFO_SCTP_VTAG_ORIGINAL-1]));
-		set_bit(ATTR_SCTP_VTAG_ORIG, ct->head.set);
-	}
-
-	if (tb[CTA_PROTOINFO_SCTP_VTAG_REPLY-1]) {
-		ct->protoinfo.sctp.vtag[__DIR_REPL] = 
-			ntohl(*(uint32_t *)NFA_DATA(tb[CTA_PROTOINFO_SCTP_VTAG_REPLY-1]));
-		set_bit(ATTR_SCTP_VTAG_REPL, ct->head.set);
-	}
-
-}
-
-static void __parse_protoinfo_dccp(const struct nfattr *attr, 
-				   struct nf_conntrack *ct)
-{
-	struct nfattr *tb[CTA_PROTOINFO_DCCP_MAX];
-
-	nfnl_parse_nested(tb, CTA_PROTOINFO_DCCP_MAX, attr);
-
-	if (tb[CTA_PROTOINFO_DCCP_STATE-1]) {
-                ct->protoinfo.dccp.state =
-                        *(uint8_t *)NFA_DATA(tb[CTA_PROTOINFO_DCCP_STATE-1]);
-		set_bit(ATTR_DCCP_STATE, ct->head.set);
-	}
-	if (tb[CTA_PROTOINFO_DCCP_ROLE-1]) {
-                ct->protoinfo.dccp.role =
-                        *(uint8_t *)NFA_DATA(tb[CTA_PROTOINFO_DCCP_ROLE-1]);
-		set_bit(ATTR_DCCP_ROLE, ct->head.set);
-	}
-	if (tb[CTA_PROTOINFO_DCCP_HANDSHAKE_SEQ-1]) {
-		uint64_t tmp;
-		memcpy(&tmp,
-		       NFA_DATA(tb[CTA_PROTOINFO_DCCP_HANDSHAKE_SEQ-1]),
-		       sizeof(tmp));
-		ct->protoinfo.dccp.handshake_seq = __be64_to_cpu(tmp);
-		set_bit(ATTR_DCCP_HANDSHAKE_SEQ, ct->head.set);
-	}
-}
-
-static void __parse_protoinfo(const struct nfattr *attr,
-			      struct nf_conntrack *ct)
-{
-	struct nfattr *tb[CTA_PROTOINFO_MAX];
-
-	nfnl_parse_nested(tb, CTA_PROTOINFO_MAX, attr);
-
-	if (tb[CTA_PROTOINFO_TCP-1])
-		__parse_protoinfo_tcp(tb[CTA_PROTOINFO_TCP-1], ct);
-
-	if (tb[CTA_PROTOINFO_SCTP-1])
-		__parse_protoinfo_sctp(tb[CTA_PROTOINFO_SCTP-1], ct);
-
-	if (tb[CTA_PROTOINFO_DCCP-1])
-		__parse_protoinfo_dccp(tb[CTA_PROTOINFO_DCCP-1], ct);
-}
-
-static void __parse_counters(const struct nfattr *attr,
-			     struct nf_conntrack *ct,
-			     int dir)
-{
-	struct nfattr *tb[CTA_COUNTERS_MAX];
-
-	nfnl_parse_nested(tb, CTA_COUNTERS_MAX, attr);
-	if (tb[CTA_COUNTERS_PACKETS-1] || tb[CTA_COUNTERS32_PACKETS-1]) {
-
-		if (tb[CTA_COUNTERS32_PACKETS-1])
-			ct->counters[dir].packets
-				= ntohl(*(uint32_t *)
-					NFA_DATA(tb[CTA_COUNTERS32_PACKETS-1]));
-
-		if (tb[CTA_COUNTERS_PACKETS-1]) {
-			uint64_t tmp;
-			memcpy(&tmp,
-			       NFA_DATA(tb[CTA_COUNTERS_PACKETS-1]),
-			       sizeof(tmp));
-			ct->counters[dir].packets = __be64_to_cpu(tmp);
-		}
-
-		switch(dir) {
-		case __DIR_ORIG:
-			set_bit(ATTR_ORIG_COUNTER_PACKETS, ct->head.set);
-			break;
-		case __DIR_REPL:
-			set_bit(ATTR_REPL_COUNTER_PACKETS, ct->head.set);
-			break;
-		}
-	}
-	if (tb[CTA_COUNTERS_BYTES-1] || tb[CTA_COUNTERS32_BYTES-1]) {
-
-		if (tb[CTA_COUNTERS32_BYTES-1])
-			ct->counters[dir].bytes
-				= ntohl(*(uint32_t *)
-					NFA_DATA(tb[CTA_COUNTERS32_BYTES-1]));
-
-		if (tb[CTA_COUNTERS_BYTES-1]) {
-			uint64_t tmp;
-			memcpy(&tmp,
-			       NFA_DATA(tb[CTA_COUNTERS_BYTES-1]),
-			       sizeof(tmp));
-			ct->counters[dir].bytes = __be64_to_cpu(tmp);
-		}
-
-		switch(dir) {
-		case __DIR_ORIG:
-			set_bit(ATTR_ORIG_COUNTER_BYTES, ct->head.set);
-			break;
-		case __DIR_REPL:
-			set_bit(ATTR_REPL_COUNTER_BYTES, ct->head.set);
-			break;
-		}
-	}
-}
-
-static void 
-__parse_nat_seq(const struct nfattr *attr, struct nf_conntrack *ct, int dir)
-{
-	struct nfattr *tb[CTA_NAT_SEQ_MAX];
-
-	nfnl_parse_nested(tb, CTA_NAT_SEQ_MAX, attr);
-
-	if (tb[CTA_NAT_SEQ_CORRECTION_POS-1]) {
-		ct->natseq[dir].correction_pos =
-			ntohl(*(uint32_t *)NFA_DATA(tb[CTA_NAT_SEQ_CORRECTION_POS-1]));
-		switch(dir) {
-		case __DIR_ORIG:
-			set_bit(ATTR_ORIG_NAT_SEQ_CORRECTION_POS, ct->head.set);
-			break;
-		case __DIR_REPL:
-			set_bit(ATTR_REPL_NAT_SEQ_CORRECTION_POS, ct->head.set);
-			break;
-		}
-	}
-					
-	if (tb[CTA_NAT_SEQ_OFFSET_BEFORE-1]) {
-		ct->natseq[dir].offset_before =
-		ntohl(*(uint32_t *)NFA_DATA(tb[CTA_NAT_SEQ_OFFSET_BEFORE-1]));
-		switch(dir) {
-		case __DIR_ORIG:
-			set_bit(ATTR_ORIG_NAT_SEQ_OFFSET_BEFORE, ct->head.set);
-			break;
-		case __DIR_REPL:
-			set_bit(ATTR_REPL_NAT_SEQ_OFFSET_BEFORE, ct->head.set);
-			break;
-		}
-	}
-
-	if (tb[CTA_NAT_SEQ_OFFSET_AFTER-1]) {
-		ct->natseq[dir].offset_after =
-		ntohl(*(uint32_t *)NFA_DATA(tb[CTA_NAT_SEQ_OFFSET_AFTER-1]));
-		switch(dir) {
-		case __DIR_ORIG:
-			set_bit(ATTR_ORIG_NAT_SEQ_OFFSET_AFTER, ct->head.set);
-			break;
-		case __DIR_REPL:
-			set_bit(ATTR_REPL_NAT_SEQ_OFFSET_AFTER, ct->head.set);
-			break;
-		}
-	}
-}
-
-static void 
-__parse_helper(const struct nfattr *attr, struct nf_conntrack *ct)
-{
-	struct nfattr *tb[CTA_HELP_MAX];
-
-	nfnl_parse_nested(tb, CTA_HELP_MAX, attr);
-	if (!tb[CTA_HELP_NAME-1])
-		return;
-
-	strncpy(ct->helper_name, 
-		NFA_DATA(tb[CTA_HELP_NAME-1]),
-		NFCT_HELPER_NAME_MAX);
-	ct->helper_name[NFCT_HELPER_NAME_MAX-1] = '\0';
-	set_bit(ATTR_HELPER_NAME, ct->head.set);
-}
-
-static void
-__parse_secctx(const struct nfattr *attr, struct nf_conntrack *ct)
-{
-	struct nfattr *tb[CTA_SECCTX_MAX];
-
-	nfnl_parse_nested(tb, CTA_SECCTX_MAX, attr);
-	if (!tb[CTA_SECCTX_NAME-1])
-		return;
-
-	ct->secctx = strdup(NFA_DATA(tb[CTA_SECCTX_NAME-1]));
-	if (ct->secctx)
-		set_bit(ATTR_SECCTX, ct->head.set);
-}
-
-int __parse_message_type(const struct nlmsghdr *nlh)
-{
-	uint16_t type = NFNL_MSG_TYPE(nlh->nlmsg_type);
-	uint16_t flags = nlh->nlmsg_flags;
-	int ret = NFCT_T_UNKNOWN;
-
-	if (type == IPCTNL_MSG_CT_NEW) {
-		if (flags & (NLM_F_CREATE|NLM_F_EXCL))
-			ret = NFCT_T_NEW;
-		else
-			ret = NFCT_T_UPDATE;
-	} else if (type == IPCTNL_MSG_CT_DELETE)
-		ret = NFCT_T_DESTROY;
-
-	return ret;
-}
-
-static void
-__parse_timestamp(const struct nfattr *attr, struct nf_conntrack *ct)
-{
-	struct nfattr *tb[CTA_TIMESTAMP_MAX];
-
-	nfnl_parse_nested(tb, CTA_TIMESTAMP_MAX, attr);
-	if (tb[CTA_TIMESTAMP_START-1]) {
-		uint64_t tmp;
-		memcpy(&tmp, NFA_DATA(tb[CTA_TIMESTAMP_START-1]), sizeof(tmp));
-		ct->timestamp.start = __be64_to_cpu(tmp);
-		set_bit(ATTR_TIMESTAMP_START, ct->head.set);
-	}
-	if (tb[CTA_TIMESTAMP_STOP-1]) {
-		uint64_t tmp;
-		memcpy(&tmp, NFA_DATA(tb[CTA_TIMESTAMP_STOP-1]), sizeof(tmp));
-		ct->timestamp.stop = __be64_to_cpu(tmp);
-		set_bit(ATTR_TIMESTAMP_STOP, ct->head.set);
-	}
-}
-
-static void
-__parse_labels(const struct nfattr *attr, struct nf_conntrack *ct)
-{
-	struct nfct_bitmask *mask;
-	uint16_t len;
-
-	len = NFA_PAYLOAD(attr);
-	if (len) {
-		mask = nfct_bitmask_new((len * CHAR_BIT) - 1);
-		if (!mask)
-			return;
-		memcpy(mask->bits, NFA_DATA(attr), len);
-		nfct_set_attr(ct, ATTR_CONNLABELS, mask);
-	}
-}
-
-void __parse_conntrack(const struct nlmsghdr *nlh,
-		       struct nfattr *cda[],
-		       struct nf_conntrack *ct)
-{
-	struct nfgenmsg *nfhdr = NLMSG_DATA(nlh);
-
-	if (cda[CTA_TUPLE_ORIG-1]) {
-		ct->head.orig.l3protonum = nfhdr->nfgen_family;
-		set_bit(ATTR_ORIG_L3PROTO, ct->head.set);
-
-		__parse_tuple(cda[CTA_TUPLE_ORIG-1], 
-			      &ct->head.orig, __DIR_ORIG, ct->head.set);
-	}
-
-	if (cda[CTA_TUPLE_REPLY-1]) {
-		ct->repl.l3protonum = nfhdr->nfgen_family;
-		set_bit(ATTR_REPL_L3PROTO, ct->head.set);
-
-		__parse_tuple(cda[CTA_TUPLE_REPLY-1], 
-			      &ct->repl, __DIR_REPL, ct->head.set);
-	}
-
-	if (cda[CTA_TUPLE_MASTER-1]) {
-		ct->master.l3protonum = nfhdr->nfgen_family;
-		set_bit(ATTR_MASTER_L3PROTO, ct->head.set);
-
-		__parse_tuple(cda[CTA_TUPLE_MASTER-1], 
-			      &ct->master, __DIR_MASTER, ct->head.set);
-	}
-
-	if (cda[CTA_NAT_SEQ_ADJ_ORIG-1])
-		__parse_nat_seq(cda[CTA_NAT_SEQ_ADJ_ORIG-1], ct, __DIR_ORIG);
-
-	if (cda[CTA_NAT_SEQ_ADJ_REPLY-1])
-		__parse_nat_seq(cda[CTA_NAT_SEQ_ADJ_REPLY-1], ct, __DIR_REPL);
-
-	if (cda[CTA_STATUS-1]) {
-		ct->status = ntohl(*(uint32_t *)NFA_DATA(cda[CTA_STATUS-1]));
-		set_bit(ATTR_STATUS, ct->head.set);
-	}
-
-	if (cda[CTA_PROTOINFO-1])
-		__parse_protoinfo(cda[CTA_PROTOINFO-1], ct);
-
-	if (cda[CTA_TIMEOUT-1]) {
-		ct->timeout = ntohl(*(uint32_t *)NFA_DATA(cda[CTA_TIMEOUT-1]));
-		set_bit(ATTR_TIMEOUT, ct->head.set);
-	}
-	
-	if (cda[CTA_MARK-1]) {
-		ct->mark = ntohl(*(uint32_t *)NFA_DATA(cda[CTA_MARK-1]));
-		set_bit(ATTR_MARK, ct->head.set);
-	}
-
-	if (cda[CTA_SECMARK-1]) {
-		ct->secmark = ntohl(*(uint32_t *)NFA_DATA(cda[CTA_SECMARK-1]));
-		set_bit(ATTR_SECMARK, ct->head.set);
-	}
-
-	if (cda[CTA_COUNTERS_ORIG-1])
-		__parse_counters(cda[CTA_COUNTERS_ORIG-1], ct, __DIR_ORIG);
-
-	if (cda[CTA_COUNTERS_REPLY-1])
-		__parse_counters(cda[CTA_COUNTERS_REPLY-1], ct, __DIR_REPL);
-
-	if (cda[CTA_USE-1]) {
-		ct->use = ntohl(*(uint32_t *)NFA_DATA(cda[CTA_USE-1]));
-		set_bit(ATTR_USE, ct->head.set);
-	}
-
-	if (cda[CTA_ID-1]) {
-		ct->id = ntohl(*(uint32_t *)NFA_DATA(cda[CTA_ID-1]));
-		set_bit(ATTR_ID, ct->head.set);
-	}
-
-	if (cda[CTA_HELP-1])
-		__parse_helper(cda[CTA_HELP-1], ct);
-
-	if (cda[CTA_ZONE-1]) {
-		ct->zone = ntohs(*(uint16_t *)NFA_DATA(cda[CTA_ZONE-1]));
-		set_bit(ATTR_ZONE, ct->head.set);
-	}
-
-	if (cda[CTA_SECCTX-1])
-		__parse_secctx(cda[CTA_SECCTX-1], ct);
-
-	if (cda[CTA_TIMESTAMP-1])
-		__parse_timestamp(cda[CTA_TIMESTAMP-1], ct);
-
-	if (cda[CTA_LABELS-1])
-		__parse_labels(cda[CTA_LABELS-1], ct);
-}
diff --git a/src/expect/Makefile.am b/src/expect/Makefile.am
index 61d5cbdc709e..8f07daff7758 100644
--- a/src/expect/Makefile.am
+++ b/src/expect/Makefile.am
@@ -5,7 +5,7 @@ noinst_LTLIBRARIES = libnfexpect.la
 libnfexpect_la_SOURCES = api.c \
 			 compare.c \
 			 getter.c setter.c \
-			 parse.c build.c \
+			 build.c \
 			 snprintf.c \
 			 snprintf_default.c \
 			 snprintf_xml.c \
diff --git a/src/expect/api.c b/src/expect/api.c
index 3f1763038ede..b50a47f171c1 100644
--- a/src/expect/api.c
+++ b/src/expect/api.c
@@ -594,6 +594,23 @@ int nfexp_build_query(struct nfnl_subsys_handle *ssh,
 	return __build_query_exp(ssh, qt, data, buffer, size);
 }
 
+static int __parse_expect_message_type(const struct nlmsghdr *nlh)
+{
+	uint16_t type = NFNL_MSG_TYPE(nlh->nlmsg_type);
+	uint16_t flags = nlh->nlmsg_flags;
+	int ret = NFCT_T_UNKNOWN;
+
+	if (type == IPCTNL_MSG_EXP_NEW) {
+		if (flags & (NLM_F_CREATE|NLM_F_EXCL))
+			ret = NFCT_T_NEW;
+		else
+			ret = NFCT_T_UPDATE;
+	} else if (type == IPCTNL_MSG_EXP_DELETE)
+		ret = NFCT_T_DESTROY;
+
+	return ret;
+}
+
 /**
  * nfexp_parse_expect - translate a netlink message to a conntrack object
  * \param type do the translation iif the message type is of a certain type
@@ -623,26 +640,15 @@ int nfexp_parse_expect(enum nf_conntrack_msg_type type,
 		       struct nf_expect *exp)
 {
 	unsigned int flags;
-	int len = nlh->nlmsg_len;
-	struct nfgenmsg *nfhdr = NLMSG_DATA(nlh);
-	struct nfattr *cda[CTA_EXPECT_MAX];
 
 	assert(nlh != NULL);
 	assert(exp != NULL);
 
-	len -= NLMSG_LENGTH(sizeof(struct nfgenmsg));
-	if (len < 0) {
-		errno = EINVAL;
-		return NFCT_T_ERROR;
-	}
-
 	flags = __parse_expect_message_type(nlh);
 	if (!(flags & type))
 		return 0;
 
-	nfnl_parse_attr(cda, CTA_EXPECT_MAX, NFA_DATA(nfhdr), len);
-
-	__parse_expect(nlh, cda, exp);
+	nfexp_nlmsg_parse(nlh, exp);
 
 	return flags;
 }
diff --git a/src/expect/parse.c b/src/expect/parse.c
deleted file mode 100644
index 9b944a6accca..000000000000
--- a/src/expect/parse.c
+++ /dev/null
@@ -1,120 +0,0 @@
-/*
- * (C) 2005-2011 by Pablo Neira Ayuso <pablo@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#include "internal/internal.h"
-
-int __parse_expect_message_type(const struct nlmsghdr *nlh)
-{
-	uint16_t type = NFNL_MSG_TYPE(nlh->nlmsg_type);
-	uint16_t flags = nlh->nlmsg_flags;
-	int ret = NFCT_T_UNKNOWN;
-
-	if (type == IPCTNL_MSG_EXP_NEW) {
-		if (flags & (NLM_F_CREATE|NLM_F_EXCL))
-			ret = NFCT_T_NEW;
-		else
-			ret = NFCT_T_UPDATE;
-	} else if (type == IPCTNL_MSG_EXP_DELETE)
-		ret = NFCT_T_DESTROY;
-
-	return ret;
-}
-
-void __parse_expect(const struct nlmsghdr *nlh,
-		    struct nfattr *cda[],
-		    struct nf_expect *exp)
-{
-	struct nfgenmsg *nfhdr = NLMSG_DATA(nlh);
-
-	/* XXX: this is ugly, clean it up, please */
-	exp->expected.orig.l3protonum = nfhdr->nfgen_family;
-	set_bit(ATTR_ORIG_L3PROTO, exp->expected.set);
-
-	exp->mask.orig.l3protonum = nfhdr->nfgen_family;
-	set_bit(ATTR_ORIG_L3PROTO, exp->mask.set);
-
-	exp->master.orig.l3protonum = nfhdr->nfgen_family;
-	set_bit(ATTR_ORIG_L3PROTO, exp->master.set);
-
-	if (cda[CTA_EXPECT_MASTER-1]) {
-		__parse_tuple(cda[CTA_EXPECT_MASTER-1], 
-			      &exp->master.orig,
-			      __DIR_ORIG,
-			      exp->master.set);
-		set_bit(ATTR_EXP_MASTER, exp->set);
-	}
-	if (cda[CTA_EXPECT_TUPLE-1]) {
-		__parse_tuple(cda[CTA_EXPECT_TUPLE-1], 
-			      &exp->expected.orig,
-			      __DIR_ORIG,
-			      exp->expected.set);
-		set_bit(ATTR_EXP_EXPECTED, exp->set);
-	}
-	if (cda[CTA_EXPECT_MASK-1]) {
-		__parse_tuple(cda[CTA_EXPECT_MASK-1], 
-			      &exp->mask.orig,
-			      __DIR_ORIG,
-			      exp->mask.set);
-		set_bit(ATTR_EXP_MASK, exp->set);
-	}
-	if (cda[CTA_EXPECT_TIMEOUT-1]) {
-		exp->timeout = 
-		      ntohl(*(uint32_t *)NFA_DATA(cda[CTA_EXPECT_TIMEOUT-1]));
-		set_bit(ATTR_EXP_TIMEOUT, exp->set);
-	}
-
-	if (cda[CTA_EXPECT_ZONE-1]) {
-		exp->zone =
-		      ntohs(*(uint16_t *)NFA_DATA(cda[CTA_EXPECT_ZONE-1]));
-		set_bit(ATTR_EXP_ZONE, exp->set);
-	}
-	if (cda[CTA_EXPECT_FLAGS-1]) {
-		exp->flags =
-		      ntohl(*(uint32_t *)NFA_DATA(cda[CTA_EXPECT_FLAGS-1]));
-		set_bit(ATTR_EXP_FLAGS, exp->set);
-	}
-	if (cda[CTA_EXPECT_HELP_NAME-1]) {
-		strncpy(exp->helper_name, NFA_DATA(cda[CTA_EXPECT_HELP_NAME-1]),
-			NFA_PAYLOAD(cda[CTA_EXPECT_HELP_NAME-1]));
-		set_bit(ATTR_EXP_HELPER_NAME, exp->set);
-	}
-	if (cda[CTA_EXPECT_CLASS-1]) {
-		exp->class =
-		      ntohl(*(uint32_t *)NFA_DATA(cda[CTA_EXPECT_CLASS-1]));
-		set_bit(ATTR_EXP_CLASS, exp->set);
-	}
-	if (cda[CTA_EXPECT_NAT-1]) {
-		struct nfattr *tb[CTA_EXPECT_NAT_MAX];
-
-		exp->nat.orig.l3protonum = nfhdr->nfgen_family;
-		set_bit(ATTR_ORIG_L3PROTO, exp->nat.set);
-
-		nfnl_parse_nested(tb, CTA_EXPECT_NAT_MAX,
-					cda[CTA_EXPECT_NAT-1]);
-
-		if (tb[CTA_EXPECT_NAT_TUPLE-1]) {
-			__parse_tuple(tb[CTA_EXPECT_NAT_TUPLE-1],
-				      &exp->nat.orig,
-				      __DIR_ORIG,
-				      exp->nat.set);
-			set_bit(ATTR_EXP_NAT_TUPLE, exp->set);
-		}
-		if (tb[CTA_EXPECT_NAT_DIR-1]) {
-			exp->nat_dir =
-			      ntohl(*((uint32_t *)
-				NFA_DATA(tb[CTA_EXPECT_NAT_DIR-1])));
-			set_bit(ATTR_EXP_NAT_DIR, exp->set);
-		}
-	}
-	if (cda[CTA_EXPECT_FN-1]) {
-		strcpy(exp->expectfn, NFA_DATA(cda[CTA_EXPECT_FN-1]));
-		exp->expectfn[__NFCT_EXPECTFN_MAX-1] = '\0';
-		set_bit(ATTR_EXP_FN, exp->set);
-	}
-}
-- 
2.1.4

