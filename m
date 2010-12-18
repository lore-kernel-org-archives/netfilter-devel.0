From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/3] src: declare non-modified data as const
Date: Sat, 18 Dec 2010 21:16:09 +0100
Message-ID: <1292703371-15946-3-git-send-email-jengelh@medozas.de>
References: <1292703371-15946-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:47383 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932156Ab0LRUQO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Dec 2010 15:16:14 -0500
In-Reply-To: <1292703371-15946-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/internal/extern.h     |   28 ++++++++++++++--------------
 src/conntrack/api.c           |    4 ++--
 src/conntrack/bsf.c           |    2 +-
 src/conntrack/copy.c          |    2 +-
 src/conntrack/filter.c        |    2 +-
 src/conntrack/getter.c        |    2 +-
 src/conntrack/grp.c           |    2 +-
 src/conntrack/grp_getter.c    |    2 +-
 src/conntrack/grp_setter.c    |    4 ++--
 src/conntrack/setter.c        |    4 ++--
 src/conntrack/snprintf.c      |   10 +++++-----
 src/expect/getter.c           |    2 +-
 src/expect/setter.c           |    2 +-
 src/expect/snprintf_default.c |    2 +-
 14 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/include/internal/extern.h b/include/internal/extern.h
index e1bbc13..2a3ef06 100644
--- a/include/internal/extern.h
+++ b/include/internal/extern.h
@@ -1,23 +1,23 @@
 #ifndef _NFCT_EXTERN_H_
 #define _NFCT_EXTERN_H_
 
-extern set_attr 	set_attr_array[];
-extern get_attr 	get_attr_array[];
-extern copy_attr 	copy_attr_array[];
-extern filter_attr 	filter_attr_array[];
-extern set_attr_grp	set_attr_grp_array[];
-extern get_attr_grp	get_attr_grp_array[];
+extern const set_attr 	set_attr_array[];
+extern const get_attr 	get_attr_array[];
+extern const copy_attr 	copy_attr_array[];
+extern const filter_attr 	filter_attr_array[];
+extern const set_attr_grp	set_attr_grp_array[];
+extern const get_attr_grp	get_attr_grp_array[];
 
-extern set_exp_attr	set_exp_attr_array[];
-extern get_exp_attr	get_exp_attr_array[];
+extern const set_exp_attr	set_exp_attr_array[];
+extern const get_exp_attr	get_exp_attr_array[];
 
-extern uint32_t attr_grp_bitmask[ATTR_GRP_MAX][__NFCT_BITSET];
+extern const uint32_t attr_grp_bitmask[ATTR_GRP_MAX][__NFCT_BITSET];
 
 /* for the snprintf infrastructure */
-extern const char 	*l3proto2str[AF_MAX];
-extern const char	*proto2str[IPPROTO_MAX];
-extern const char	*states[TCP_CONNTRACK_MAX];
-extern const char	*sctp_states[SCTP_CONNTRACK_MAX];
-extern const char	*dccp_states[DCCP_CONNTRACK_MAX];
+extern const char *const l3proto2str[AF_MAX];
+extern const char *const proto2str[IPPROTO_MAX];
+extern const char *const states[TCP_CONNTRACK_MAX];
+extern const char *const sctp_states[SCTP_CONNTRACK_MAX];
+extern const char *const dccp_states[DCCP_CONNTRACK_MAX];
 
 #endif
diff --git a/src/conntrack/api.c b/src/conntrack/api.c
index 825afba..7a5767b 100644
--- a/src/conntrack/api.c
+++ b/src/conntrack/api.c
@@ -1103,7 +1103,7 @@ void nfct_copy(struct nf_conntrack *ct1,
 		return;
 	}
 
-	static int cp_orig_mask[] = {
+	static const int cp_orig_mask[] = {
 		ATTR_ORIG_IPV4_SRC,
 		ATTR_ORIG_IPV4_DST,
 		ATTR_ORIG_IPV6_SRC,
@@ -1128,7 +1128,7 @@ void nfct_copy(struct nf_conntrack *ct1,
 		}
 	}
 
-	static int cp_repl_mask[] = {
+	static const int cp_repl_mask[] = {
 		ATTR_REPL_IPV4_SRC,
 		ATTR_REPL_IPV4_DST,
 		ATTR_REPL_IPV6_SRC,
diff --git a/src/conntrack/bsf.c b/src/conntrack/bsf.c
index ae7fa4a..3e2ac98 100644
--- a/src/conntrack/bsf.c
+++ b/src/conntrack/bsf.c
@@ -305,7 +305,7 @@ add_state_filter(struct sock_filter *this,
 		 u_int16_t flags,
 		 unsigned int logic)
 {
-	struct {
+	static const struct {
 		unsigned int cta_protoinfo;
 		unsigned int cta_state;
 	} cta[IPPROTO_MAX] = {
diff --git a/src/conntrack/copy.c b/src/conntrack/copy.c
index dc31f07..8d8a6b7 100644
--- a/src/conntrack/copy.c
+++ b/src/conntrack/copy.c
@@ -415,7 +415,7 @@ static void copy_attr_zone(struct nf_conntrack *dest,
 	dest->zone = orig->zone;
 }
 
-copy_attr copy_attr_array[ATTR_MAX] = {
+const copy_attr copy_attr_array[ATTR_MAX] = {
 	[ATTR_ORIG_IPV4_SRC]		= copy_attr_orig_ipv4_src,
 	[ATTR_ORIG_IPV4_DST] 		= copy_attr_orig_ipv4_dst,
 	[ATTR_REPL_IPV4_SRC]		= copy_attr_repl_ipv4_src,
diff --git a/src/conntrack/filter.c b/src/conntrack/filter.c
index bf29f96..6af4fe8 100644
--- a/src/conntrack/filter.c
+++ b/src/conntrack/filter.c
@@ -77,7 +77,7 @@ static void filter_attr_dst_ipv6(struct nfct_filter *filter, const void *value)
 	filter->l3proto_elems_ipv6[1]++;
 }
 
-filter_attr filter_attr_array[NFCT_FILTER_MAX] = {
+const filter_attr filter_attr_array[NFCT_FILTER_MAX] = {
 	[NFCT_FILTER_L4PROTO]		= filter_attr_l4proto,
 	[NFCT_FILTER_L4PROTO_STATE]	= filter_attr_l4proto_state,
 	[NFCT_FILTER_SRC_IPV4]		= filter_attr_src_ipv4,
diff --git a/src/conntrack/getter.c b/src/conntrack/getter.c
index e288d62..056fe8a 100644
--- a/src/conntrack/getter.c
+++ b/src/conntrack/getter.c
@@ -317,7 +317,7 @@ static const void *get_attr_zone(const struct nf_conntrack *ct)
 	return &ct->zone;
 }
 
-get_attr get_attr_array[ATTR_MAX] = {
+const get_attr get_attr_array[ATTR_MAX] = {
 	[ATTR_ORIG_IPV4_SRC]		= get_attr_orig_ipv4_src,
 	[ATTR_ORIG_IPV4_DST] 		= get_attr_orig_ipv4_dst,
 	[ATTR_REPL_IPV4_SRC]		= get_attr_repl_ipv4_src,
diff --git a/src/conntrack/grp.c b/src/conntrack/grp.c
index 739f8c6..3034011 100644
--- a/src/conntrack/grp.c
+++ b/src/conntrack/grp.c
@@ -7,7 +7,7 @@
 
 #include "internal/internal.h"
 
-uint32_t attr_grp_bitmask[ATTR_GRP_MAX][__NFCT_BITSET] = {
+const uint32_t attr_grp_bitmask[ATTR_GRP_MAX][__NFCT_BITSET] = {
 	[ATTR_GRP_ORIG_IPV4] = {
 		[0] = (1 << ATTR_ORIG_IPV4_SRC) |
 		      (1 << ATTR_ORIG_IPV4_DST) |
diff --git a/src/conntrack/grp_getter.c b/src/conntrack/grp_getter.c
index 60e0b7e..943e065 100644
--- a/src/conntrack/grp_getter.c
+++ b/src/conntrack/grp_getter.c
@@ -92,7 +92,7 @@ static void get_attr_grp_repl_ctrs(const struct nf_conntrack *ct, void *data)
 	this->bytes = ct->counters[__DIR_REPL].bytes;
 }
 
-get_attr_grp get_attr_grp_array[ATTR_GRP_MAX] = {
+const get_attr_grp get_attr_grp_array[ATTR_GRP_MAX] = {
 	[ATTR_GRP_ORIG_IPV4]		= get_attr_grp_orig_ipv4,
 	[ATTR_GRP_REPL_IPV4]		= get_attr_grp_repl_ipv4,
 	[ATTR_GRP_ORIG_IPV6]		= get_attr_grp_orig_ipv6,
diff --git a/src/conntrack/grp_setter.c b/src/conntrack/grp_setter.c
index 99ae4f8..70b5fef 100644
--- a/src/conntrack/grp_setter.c
+++ b/src/conntrack/grp_setter.c
@@ -28,7 +28,7 @@ static const u_int8_t invmap_icmp[] = {
 #define ICMPV6_NI_REPLY 140
 #endif
 
-static u_int8_t invmap_icmpv6[] = {
+static const u_int8_t invmap_icmpv6[] = {
 	[ICMPV6_ECHO_REQUEST - 128]	= ICMPV6_ECHO_REPLY + 1,
 	[ICMPV6_ECHO_REPLY - 128]	= ICMPV6_ECHO_REQUEST + 1,
 	[ICMPV6_NI_QUERY - 128]		= ICMPV6_NI_QUERY + 1,
@@ -140,7 +140,7 @@ static void set_attr_grp_do_nothing(struct nf_conntrack *ct, const void *value)
 {
 }
 
-set_attr_grp set_attr_grp_array[ATTR_GRP_MAX] = {
+const set_attr_grp set_attr_grp_array[ATTR_GRP_MAX] = {
 	[ATTR_GRP_ORIG_IPV4]		= set_attr_grp_orig_ipv4,
 	[ATTR_GRP_REPL_IPV4]		= set_attr_grp_repl_ipv4,
 	[ATTR_GRP_ORIG_IPV6]		= set_attr_grp_orig_ipv6,
diff --git a/src/conntrack/setter.c b/src/conntrack/setter.c
index e14d683..0f907ab 100644
--- a/src/conntrack/setter.c
+++ b/src/conntrack/setter.c
@@ -28,7 +28,7 @@ static const u_int8_t invmap_icmp[] = {
 #define ICMPV6_NI_REPLY 140
 #endif
 
-static u_int8_t invmap_icmpv6[] = {
+static const u_int8_t invmap_icmpv6[] = {
 	[ICMPV6_ECHO_REQUEST - 128]	= ICMPV6_ECHO_REPLY + 1,
 	[ICMPV6_ECHO_REPLY - 128]	= ICMPV6_ECHO_REQUEST + 1,
 	[ICMPV6_NI_QUERY - 128]		= ICMPV6_NI_QUERY + 1,
@@ -347,7 +347,7 @@ static void set_attr_zone(struct nf_conntrack *ct, const void *value)
 
 static void set_attr_do_nothing(struct nf_conntrack *ct, const void *value) {}
 
-set_attr set_attr_array[ATTR_MAX] = {
+const set_attr set_attr_array[ATTR_MAX] = {
 	[ATTR_ORIG_IPV4_SRC]	= set_attr_orig_ipv4_src,
 	[ATTR_ORIG_IPV4_DST] 	= set_attr_orig_ipv4_dst,
 	[ATTR_REPL_IPV4_SRC]	= set_attr_repl_ipv4_src,
diff --git a/src/conntrack/snprintf.c b/src/conntrack/snprintf.c
index 1104c63..5e45073 100644
--- a/src/conntrack/snprintf.c
+++ b/src/conntrack/snprintf.c
@@ -8,12 +8,12 @@
 #include "internal/internal.h"
 
 /* these arrays are used by snprintf_default.c and snprintf_xml.c */
-const char *l3proto2str[AF_MAX] = {
+const char *const l3proto2str[AF_MAX] = {
 	[AF_INET]			= "ipv4",
 	[AF_INET6]			= "ipv6",
 };
 
-const char *proto2str[IPPROTO_MAX] = {
+const char *const proto2str[IPPROTO_MAX] = {
 	[IPPROTO_TCP]			= "tcp",
 	[IPPROTO_UDP]			= "udp",
 	[IPPROTO_UDPLITE]		= "udplite",
@@ -24,7 +24,7 @@ const char *proto2str[IPPROTO_MAX] = {
 	[IPPROTO_DCCP]			= "dccp",
 };
 
-const char *states[TCP_CONNTRACK_MAX] = {
+const char *const states[TCP_CONNTRACK_MAX] = {
 	[TCP_CONNTRACK_NONE]		= "NONE",
 	[TCP_CONNTRACK_SYN_SENT]	= "SYN_SENT",
 	[TCP_CONNTRACK_SYN_RECV]	= "SYN_RECV",
@@ -37,7 +37,7 @@ const char *states[TCP_CONNTRACK_MAX] = {
 	[TCP_CONNTRACK_SYN_SENT2]	= "SYN_SENT2",
 };
 
-const char *sctp_states[SCTP_CONNTRACK_MAX] = {
+const char *const sctp_states[SCTP_CONNTRACK_MAX] = {
 	[SCTP_CONNTRACK_NONE]		= "NONE",
 	[SCTP_CONNTRACK_CLOSED]		= "CLOSED",
 	[SCTP_CONNTRACK_COOKIE_WAIT]	= "COOKIE_WAIT",
@@ -48,7 +48,7 @@ const char *sctp_states[SCTP_CONNTRACK_MAX] = {
 	[SCTP_CONNTRACK_SHUTDOWN_ACK_SENT] = "SHUTDOWN_ACK_SENT",
 };
 
-const char *dccp_states[DCCP_CONNTRACK_MAX] = {
+const char *const dccp_states[DCCP_CONNTRACK_MAX] = {
 	[DCCP_CONNTRACK_NONE]		= "NONE",
 	[DCCP_CONNTRACK_REQUEST]	= "REQUEST",
 	[DCCP_CONNTRACK_RESPOND]	= "RESPOND",
diff --git a/src/expect/getter.c b/src/expect/getter.c
index f2022d9..9cb6ede 100644
--- a/src/expect/getter.c
+++ b/src/expect/getter.c
@@ -37,7 +37,7 @@ static const void *get_exp_attr_flags(const struct nf_expect *exp)
 	return &exp->flags;
 }
 
-get_exp_attr get_exp_attr_array[ATTR_EXP_MAX] = {
+const get_exp_attr get_exp_attr_array[ATTR_EXP_MAX] = {
 	[ATTR_EXP_MASTER]		= get_exp_attr_master,
 	[ATTR_EXP_EXPECTED]		= get_exp_attr_expected,
 	[ATTR_EXP_MASK]			= get_exp_attr_mask,
diff --git a/src/expect/setter.c b/src/expect/setter.c
index 1270860..040b958 100644
--- a/src/expect/setter.c
+++ b/src/expect/setter.c
@@ -37,7 +37,7 @@ static void set_exp_attr_flags(struct nf_expect *exp, const void *value)
 	exp->flags = *((u_int32_t *) value);
 }
 
-set_exp_attr set_exp_attr_array[ATTR_EXP_MAX] = {
+const set_exp_attr set_exp_attr_array[ATTR_EXP_MAX] = {
 	[ATTR_EXP_MASTER]		= set_exp_attr_master,
 	[ATTR_EXP_EXPECTED]		= set_exp_attr_expected,
 	[ATTR_EXP_MASK]			= set_exp_attr_mask,
diff --git a/src/expect/snprintf_default.c b/src/expect/snprintf_default.c
index be8d267..a20a3ad 100644
--- a/src/expect/snprintf_default.c
+++ b/src/expect/snprintf_default.c
@@ -23,7 +23,7 @@ int __snprintf_expect_default(char *buf,
 			      unsigned int flags) 
 {
 	int ret = 0, size = 0, offset = 0;
-	char *delim = "";
+	const char *delim = "";
 
 	switch(msg_type) {
 		case NFCT_T_NEW:
-- 
1.7.1

