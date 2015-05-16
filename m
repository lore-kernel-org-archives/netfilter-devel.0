From: Felix Janda <felix.janda@posteo.de>
Subject: [libnetfilter_conntrack PATCH 2/2] Use stdint types everywhere
Date: Sat, 16 May 2015 13:31:38 +0200
Message-ID: <20150516110347.GO14201@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:55408 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007AbbEPLc6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 May 2015 07:32:58 -0400
Received: from dovecot03.posteo.de (unknown [185.67.36.28])
	by mx02.posteo.de (Postfix) with ESMTPS id 0172125AF530
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 13:32:55 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3lpkxM1ynrz5vN4
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 13:32:55 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 include/internal/bitops.h                          |  14 +--
 include/internal/internal.h                        |   4 +-
 include/internal/object.h                          | 126 ++++++++++-----------
 include/internal/prototypes.h                      |  12 +-
 .../libnetfilter_conntrack.h                       |  84 +++++++-------
 qa/ct_echo_event.c                                 |   4 +-
 qa/ct_mark_filter.c                                |   4 +-
 qa/nssocket.c                                      |  14 +--
 qa/nssocket.h                                      |   6 +-
 src/callback.c                                     |   6 +-
 src/conntrack/api.c                                |  44 +++----
 src/conntrack/bsf.c                                |  14 +--
 src/conntrack/build.c                              |  50 ++++----
 src/conntrack/filter.c                             |   8 +-
 src/conntrack/filter_dump.c                        |   2 +-
 src/conntrack/grp_getter.c                         |  12 +-
 src/conntrack/grp_setter.c                         |  18 +--
 src/conntrack/parse.c                              |  82 +++++++-------
 src/conntrack/parse_mnl.c                          |   6 +-
 src/conntrack/setter.c                             | 126 ++++++++++-----------
 src/conntrack/snprintf_xml.c                       |   4 +-
 src/expect/api.c                                   |  26 ++---
 src/expect/build.c                                 |   6 +-
 src/expect/parse.c                                 |  14 +--
 src/expect/setter.c                                |  10 +-
 src/main.c                                         |   4 +-
 utils/conntrack_dump.c                             |   2 +-
 utils/conntrack_flush.c                            |   2 +-
 utils/expect_dump.c                                |   2 +-
 utils/expect_flush.c                               |   2 +-
 30 files changed, 354 insertions(+), 354 deletions(-)

diff --git a/include/internal/bitops.h b/include/internal/bitops.h
index aefff0e..34d12c3 100644
--- a/include/internal/bitops.h
+++ b/include/internal/bitops.h
@@ -4,28 +4,28 @@
 #ifndef _NFCT_BITOPS_H_
 #define _NFCT_BITOPS_H_
 
-static inline void set_bit(int nr, u_int32_t *addr)
+static inline void set_bit(int nr, uint32_t *addr)
 {
 	addr[nr >> 5] |= (1UL << (nr & 31));
 }
 
-static inline void unset_bit(int nr, u_int32_t *addr)
+static inline void unset_bit(int nr, uint32_t *addr)
 {
 	addr[nr >> 5] &= ~(1UL << (nr & 31));
 }
 
-static inline void set_bit_u16(int nr, u_int16_t *addr)
+static inline void set_bit_u16(int nr, uint16_t *addr)
 {
 	addr[nr >> 4] |= (1UL << (nr & 15));
 }
 
-static inline void unset_bit_u16(int nr, u_int16_t *addr)
+static inline void unset_bit_u16(int nr, uint16_t *addr)
 {
 	addr[nr >> 4] &= ~(1UL << (nr & 15));
 }
 
 static inline void
-set_bitmask_u32(u_int32_t *buf1, const u_int32_t *buf2, int len)
+set_bitmask_u32(uint32_t *buf1, const uint32_t *buf2, int len)
 {
 	int i;
 
@@ -34,7 +34,7 @@ set_bitmask_u32(u_int32_t *buf1, const u_int32_t *buf2, int len)
 }
 
 static inline void
-unset_bitmask_u32(u_int32_t *buf1, const u_int32_t *buf2, int len)
+unset_bitmask_u32(uint32_t *buf1, const uint32_t *buf2, int len)
 {
 	int i;
 
@@ -42,7 +42,7 @@ unset_bitmask_u32(u_int32_t *buf1, const u_int32_t *buf2, int len)
 		buf1[i] &= ~buf2[i];
 }
 
-static inline int test_bit(int nr, const u_int32_t *addr)
+static inline int test_bit(int nr, const uint32_t *addr)
 {
 	return ((1UL << (nr & 31)) & (addr[nr >> 5])) != 0;
 }
diff --git a/include/internal/internal.h b/include/internal/internal.h
index aaf6bd4..45b4aa7 100644
--- a/include/internal/internal.h
+++ b/include/internal/internal.h
@@ -78,8 +78,8 @@
 
 /* extracted from include/linux/netfilter/nf_conntrack_tcp.h .*/
 struct nf_ct_tcp_flags {
-	u_int8_t flags;
-	u_int8_t mask;
+	uint8_t flags;
+	uint8_t mask;
 };
 
 #define NFCT_BITMASK_AND	0
diff --git a/include/internal/object.h b/include/internal/object.h
index 1259467..6f5d2e5 100644
--- a/include/internal/object.h
+++ b/include/internal/object.h
@@ -58,46 +58,46 @@ struct __data_container {
 
 union __nfct_l4_src {
 	/* Add other protocols here. */
-	u_int16_t 		all;
+	uint16_t 		all;
 	struct {
-		u_int16_t 	port;
+		uint16_t 	port;
 	} tcp;
 	struct {
-		u_int16_t 	port;
+		uint16_t 	port;
 	} udp;
 	struct {
-		u_int16_t 	id;
+		uint16_t 	id;
 	} icmp;
 	struct {
-		u_int16_t 	port;
+		uint16_t 	port;
 	} sctp;
 	struct {
-		u_int16_t 	port;
+		uint16_t 	port;
 	} dccp;
 };
 
 union __nfct_l4_dst {
 	/* Add other protocols here. */
-	u_int16_t 		all;
+	uint16_t 		all;
 	struct {
-		u_int16_t 	port;
+		uint16_t 	port;
 	} tcp;
 	struct {
-		u_int16_t 	port;
+		uint16_t 	port;
 	} udp;
 	struct {
-		u_int8_t 	type, code;
+		uint8_t 	type, code;
 	} icmp;
 	struct {
-		u_int16_t 	port;
+		uint16_t 	port;
 	} sctp;
 	struct {
-		u_int16_t 	port;
+		uint16_t 	port;
 	} dccp;
 };
 
 union __nfct_address {
-	u_int32_t 		v4;
+	uint32_t 		v4;
 	struct in6_addr 	v6;
 };
 
@@ -105,8 +105,8 @@ struct __nfct_tuple {
 	union __nfct_address	src;
 	union __nfct_address 	dst;
 
-	u_int8_t		l3protonum;
-	u_int8_t		protonum;
+	uint8_t			l3protonum;
+	uint8_t			protonum;
 	union __nfct_l4_src	l4src;
 	union __nfct_l4_dst	l4dst;
 };
@@ -118,31 +118,31 @@ struct __nfct_tuple {
 
 union __nfct_protoinfo {
 	struct {
-		u_int8_t 		state;
+		uint8_t 		state;
 		struct {
-			u_int8_t 	value;
-			u_int8_t 	mask;
+			uint8_t 	value;
+			uint8_t 	mask;
 		} flags[__DIR_MAX];
-		u_int8_t		wscale[__DIR_MAX];
+		uint8_t			wscale[__DIR_MAX];
 	} tcp;
 	struct {
-		u_int8_t 		state;
-		u_int32_t 		vtag[__DIR_MAX];
+		uint8_t 		state;
+		uint32_t 		vtag[__DIR_MAX];
 	} sctp;
 	struct {
-		u_int8_t 		state;
-		u_int8_t		role;
-		u_int64_t		handshake_seq;
+		uint8_t 		state;
+		uint8_t			role;
+		uint64_t		handshake_seq;
 	} dccp;
 };
 
 struct __nfct_counters {
-	u_int64_t 	packets;
-	u_int64_t 	bytes;
+	uint64_t 	packets;
+	uint64_t 	bytes;
 };
 
 struct __nfct_nat {
-	u_int32_t 		min_ip, max_ip;
+	uint32_t 		min_ip, max_ip;
 	union __nfct_l4_src 	l4min, l4max;
 };
 
@@ -150,7 +150,7 @@ struct nfct_tuple_head {
 	struct __nfct_tuple 	orig;
 
 #define __NFCT_BITSET			3
-	u_int32_t               set[__NFCT_BITSET];
+	uint32_t               set[__NFCT_BITSET];
 };
 
 struct nf_conntrack {
@@ -158,13 +158,13 @@ struct nf_conntrack {
 	struct __nfct_tuple	repl;
 	struct __nfct_tuple	master;
 
-	u_int32_t 	timeout;
-	u_int32_t	mark;
-	u_int32_t	secmark;
-	u_int32_t 	status;
-	u_int32_t	use;
-	u_int32_t	id;
-	u_int16_t	zone;
+	uint32_t 	timeout;
+	uint32_t	mark;
+	uint32_t	secmark;
+	uint32_t 	status;
+	uint32_t	use;
+	uint32_t	id;
+	uint16_t	zone;
 
 	char 		helper_name[NFCT_HELPER_NAME_MAX];
 /* According to Eric Paris <eparis@redhat.com> this field can be up to 4096
@@ -177,14 +177,14 @@ struct nf_conntrack {
 	struct __nfct_nat 	dnat;
 
 	struct {
-		u_int32_t 	correction_pos;
-		u_int32_t 	offset_before;
-		u_int32_t 	offset_after;
+		uint32_t 	correction_pos;
+		uint32_t 	offset_before;
+		uint32_t 	offset_after;
 	} natseq[__DIR_MAX];
 
 	struct {
-		u_int64_t	start;
-		u_int64_t	stop;
+		uint64_t	start;
+		uint64_t	stop;
 	} timestamp;
 
 	void *helper_info;
@@ -220,8 +220,8 @@ struct nfct_filter {
 	 * I doubt that anyone can reach such a limit.
 	 */
 #define __FILTER_L4PROTO_MAX	255
-	u_int32_t 		l4proto_map[IPPROTO_MAX/32];
-	u_int32_t		l4proto_len;
+	uint32_t 		l4proto_map[IPPROTO_MAX/32];
+	uint32_t		l4proto_len;
 
 	struct {
 	/*
@@ -230,8 +230,8 @@ struct nfct_filter {
 	 * 10 states, SCTP has 8 state. Therefore, 16 bits is enough.
 	 */
 #define __FILTER_PROTO_MAX	16
-		u_int16_t 	map;
-		u_int16_t	len;
+		uint16_t 	map;
+		uint16_t	len;
 	} l4proto_state[IPPROTO_MAX];
 
 #define __FILTER_ADDR_SRC 0
@@ -243,11 +243,11 @@ struct nfct_filter {
 	 * (two BSF lines per comparison) and the fact that the maximum 
 	 * jump offset is 0xff which is 255.
 	 */
-	u_int32_t 		l3proto_elems[2];
+	uint32_t 		l3proto_elems[2];
 	struct {
 #define __FILTER_ADDR_MAX	127
-		u_int32_t 	addr;
-		u_int32_t 	mask;
+		uint32_t 	addr;
+		uint32_t 	mask;
 	} l3proto[2][__FILTER_ADDR_MAX];
 
 	/*
@@ -256,21 +256,21 @@ struct nfct_filter {
 	 * more than that for performance reasons. It seems that oprofile
 	 * shows bad numbers for very large BSF code.
 	 */
-	u_int32_t 		l3proto_elems_ipv6[2];
+	uint32_t 		l3proto_elems_ipv6[2];
 	struct {
 #define __FILTER_IPV6_MAX	20
-		u_int32_t 	addr[4];
-		u_int32_t 	mask[4];
+		uint32_t 	addr[4];
+		uint32_t 	mask[4];
 	} l3proto_ipv6[2][__FILTER_IPV6_MAX];
 
-	u_int32_t 		mark_elems;
+	uint32_t 		mark_elems;
 	struct {
 #define __FILTER_MARK_MAX	127
-		u_int32_t 	val;
-		u_int32_t 	mask;
+		uint32_t 	val;
+		uint32_t 	mask;
 	} mark[__FILTER_MARK_MAX];
 
-	u_int32_t 		set[1];
+	uint32_t 		set[1];
 };
 
 /*
@@ -279,8 +279,8 @@ struct nfct_filter {
 
 struct nfct_filter_dump {
 	struct nfct_filter_dump_mark	mark;
-	u_int8_t			l3num;
-	u_int32_t			set;
+	uint8_t				l3num;
+	uint32_t			set;
 };
 
 /*
@@ -295,16 +295,16 @@ struct nf_expect {
 	struct nfct_tuple_head	mask;
 	struct nfct_tuple_head	nat;
 
-	u_int32_t 		timeout;
-	u_int32_t 		id;
-	u_int16_t		zone;
-	u_int32_t		flags;
-	u_int32_t		class;
+	uint32_t 		timeout;
+	uint32_t 		id;
+	uint16_t		zone;
+	uint32_t		flags;
+	uint32_t		class;
 	char 			helper_name[NFCT_HELPER_NAME_MAX];
-	u_int32_t		nat_dir;
+	uint32_t		nat_dir;
 	char			expectfn[__NFCT_EXPECTFN_MAX];
 
-	u_int32_t 		set[1];
+	uint32_t 		set[1];
 };
 
 /*
diff --git a/include/internal/prototypes.h b/include/internal/prototypes.h
index 21aa7f3..a984a2f 100644
--- a/include/internal/prototypes.h
+++ b/include/internal/prototypes.h
@@ -4,11 +4,11 @@
 /*
  * conntrack internal prototypes
  */
-int __build_conntrack(struct nfnl_subsys_handle *ssh, struct nfnlhdr *req, size_t size, u_int16_t type, u_int16_t flags, const struct nf_conntrack *ct);
+int __build_conntrack(struct nfnl_subsys_handle *ssh, struct nfnlhdr *req, size_t size, uint16_t type, uint16_t flags, const struct nf_conntrack *ct);
 void __build_tuple(struct nfnlhdr *req, size_t size, const struct __nfct_tuple *t, const int type);
 int __parse_message_type(const struct nlmsghdr *nlh);
 void __parse_conntrack(const struct nlmsghdr *nlh, struct nfattr *cda[], struct nf_conntrack *ct);
-void __parse_tuple(const struct nfattr *attr, struct __nfct_tuple *tuple, int dir, u_int32_t *set);
+void __parse_tuple(const struct nfattr *attr, struct __nfct_tuple *tuple, int dir, uint32_t *set);
 int __snprintf_conntrack(char *buf, unsigned int len, const struct nf_conntrack *ct, unsigned int type, unsigned int msg_output, unsigned int flags, struct nfct_labelmap *);
 int __snprintf_address(char *buf, unsigned int len, const struct __nfct_tuple *tuple, const char *src_tag, const char *dst_tag);
 int __snprintf_protocol(char *buf, unsigned int len, const struct nf_conntrack *ct);
@@ -25,8 +25,8 @@ int __snprintf_addr_xml(char *buf, unsigned int len, const struct __nfct_tuple *
 int __snprintf_proto_xml(char *buf, unsigned int len, const struct __nfct_tuple *tuple, enum __nfct_addr type);
 int __snprintf_localtime_xml(char *buf, unsigned int len, const struct tm *tm);
 
-const char *__proto2str(u_int8_t protonum);
-const char *__l3proto2str(u_int8_t protonum);
+const char *__proto2str(uint8_t protonum);
+const char *__l3proto2str(uint8_t protonum);
 
 int __callback(struct nlmsghdr *nlh, struct nfattr *nfa[], void *data);
 
@@ -41,12 +41,12 @@ int __setup_netlink_socket_filter(int fd, struct nfct_filter *filter);
 void __build_filter_dump(struct nfnlhdr *req, size_t size, const struct nfct_filter_dump *filter_dump);
 
 int nfct_build_tuple(struct nlmsghdr *nlh, const struct __nfct_tuple *t, int type);
-int nfct_parse_tuple(const struct nlattr *attr, struct __nfct_tuple *tuple, int dir, u_int32_t *set);
+int nfct_parse_tuple(const struct nlattr *attr, struct __nfct_tuple *tuple, int dir, uint32_t *set);
 
 /*
  * expectation internal prototypes
  */
-int __build_expect(struct nfnl_subsys_handle *ssh, struct nfnlhdr *req, size_t size, u_int16_t type, u_int16_t flags, const struct nf_expect *exp);
+int __build_expect(struct nfnl_subsys_handle *ssh, struct nfnlhdr *req, size_t size, uint16_t type, uint16_t flags, const struct nf_expect *exp);
 int __parse_expect_message_type(const struct nlmsghdr *nlh);
 void __parse_expect(const struct nlmsghdr *nlh, struct nfattr *cda[], struct nf_expect *exp);
 int __expect_callback(struct nlmsghdr *nlh, struct nfattr *nfa[], void *data);
diff --git a/include/libnetfilter_conntrack/libnetfilter_conntrack.h b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
index cea9a78..3a0a131 100644
--- a/include/libnetfilter_conntrack/libnetfilter_conntrack.h
+++ b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
@@ -38,9 +38,9 @@ struct nfct_handle;
 /*
  * [Open|close] a conntrack handler
  */
-extern struct nfct_handle *nfct_open(u_int8_t, unsigned);
+extern struct nfct_handle *nfct_open(uint8_t, unsigned);
 extern struct nfct_handle *nfct_open_nfnl(struct nfnl_handle *nfnlh,
-					  u_int8_t subsys_id,
+					  uint8_t subsys_id,
 					  unsigned int subscriptions);
 extern int nfct_close(struct nfct_handle *cth);
 
@@ -161,31 +161,31 @@ enum nf_conntrack_attr_grp {
 };
 
 struct nfct_attr_grp_ipv4 {
-	u_int32_t src, dst;
+	uint32_t src, dst;
 };
 
 struct nfct_attr_grp_ipv6 {
-	u_int32_t src[4], dst[4];
+	uint32_t src[4], dst[4];
 };
 
 struct nfct_attr_grp_port {
-	u_int16_t sport, dport;
+	uint16_t sport, dport;
 };
 
 struct nfct_attr_grp_icmp {
-	u_int16_t id;
-	u_int8_t code, type;
+	uint16_t id;
+	uint8_t code, type;
 };
 
 struct nfct_attr_grp_ctrs {
-	u_int64_t packets;
-	u_int64_t bytes;
+	uint64_t packets;
+	uint64_t bytes;
 };
 
 union nfct_attr_grp_addr {
-	u_int32_t ip;
-	u_int32_t ip6[4];
-	u_int32_t addr[4];
+	uint32_t ip;
+	uint32_t ip6[4];
+	uint32_t addr[4];
 };
 
 /* message type */
@@ -305,19 +305,19 @@ extern void nfct_set_attr(struct nf_conntrack *ct,
 
 extern void nfct_set_attr_u8(struct nf_conntrack *ct,
 			     const enum nf_conntrack_attr type,
-			     u_int8_t value);
+			     uint8_t value);
 
 extern void nfct_set_attr_u16(struct nf_conntrack *ct,
 			      const enum nf_conntrack_attr type,
-			      u_int16_t value);
+			      uint16_t value);
 
 extern void nfct_set_attr_u32(struct nf_conntrack *ct,
 			      const enum nf_conntrack_attr type,
-			      u_int32_t value);
+			      uint32_t value);
 
 extern void nfct_set_attr_u64(struct nf_conntrack *ct,
 			      const enum nf_conntrack_attr type,
-			      u_int64_t value);
+			      uint64_t value);
 
 extern void nfct_set_attr_l(struct nf_conntrack *ct,
 			    const enum nf_conntrack_attr type,
@@ -328,16 +328,16 @@ extern void nfct_set_attr_l(struct nf_conntrack *ct,
 extern const void *nfct_get_attr(const struct nf_conntrack *ct,
 				 const enum nf_conntrack_attr type);
 
-extern u_int8_t nfct_get_attr_u8(const struct nf_conntrack *ct,
+extern uint8_t nfct_get_attr_u8(const struct nf_conntrack *ct,
 				 const enum nf_conntrack_attr type);
 
-extern u_int16_t nfct_get_attr_u16(const struct nf_conntrack *ct,
+extern uint16_t nfct_get_attr_u16(const struct nf_conntrack *ct,
 				   const enum nf_conntrack_attr type);
 
-extern u_int32_t nfct_get_attr_u32(const struct nf_conntrack *ct,
+extern uint32_t nfct_get_attr_u32(const struct nf_conntrack *ct,
 				   const enum nf_conntrack_attr type);
 
-extern u_int64_t nfct_get_attr_u64(const struct nf_conntrack *ct,
+extern uint64_t nfct_get_attr_u64(const struct nf_conntrack *ct,
 				   const enum nf_conntrack_attr type);
 
 /* checker */
@@ -480,20 +480,20 @@ extern struct nfct_filter *nfct_filter_create(void);
 extern void nfct_filter_destroy(struct nfct_filter *filter);
 
 struct nfct_filter_proto {
-	u_int16_t proto;
-	u_int16_t state;
+	uint16_t proto;
+	uint16_t state;
 };
 struct nfct_filter_ipv4 {
-	u_int32_t addr;
-	u_int32_t mask;
+	uint32_t addr;
+	uint32_t mask;
 };
 struct nfct_filter_ipv6 {
-	u_int32_t addr[4];
-	u_int32_t mask[4];
+	uint32_t addr[4];
+	uint32_t mask[4];
 };
 
 enum nfct_filter_attr {
-	NFCT_FILTER_L4PROTO = 0,	/* u_int32_t */
+	NFCT_FILTER_L4PROTO = 0,	/* uint32_t */
 	NFCT_FILTER_L4PROTO_STATE,	/* struct nfct_filter_proto */
 	NFCT_FILTER_SRC_IPV4,		/* struct nfct_filter_ipv4 */
 	NFCT_FILTER_DST_IPV4,		/* struct nfct_filter_ipv4 */
@@ -509,7 +509,7 @@ extern void nfct_filter_add_attr(struct nfct_filter *filter,
 
 extern void nfct_filter_add_attr_u32(struct nfct_filter *filter,
 				     const enum nfct_filter_attr attr,
-				     const u_int32_t value);
+				     const uint32_t value);
 
 enum nfct_filter_logic {
 	NFCT_FILTER_LOGIC_POSITIVE,
@@ -529,13 +529,13 @@ extern int nfct_filter_detach(int fd);
 struct nfct_filter_dump;
 
 struct nfct_filter_dump_mark {
-	u_int32_t val;
-	u_int32_t mask;
+	uint32_t val;
+	uint32_t mask;
 };
 
 enum nfct_filter_dump_attr {
 	NFCT_FILTER_DUMP_MARK = 0,	/* struct nfct_filter_dump_mark */
-	NFCT_FILTER_DUMP_L3NUM,		/* u_int8_t */
+	NFCT_FILTER_DUMP_L3NUM,		/* uint8_t */
 	NFCT_FILTER_DUMP_MAX
 };
 
@@ -549,7 +549,7 @@ void nfct_filter_dump_set_attr(struct nfct_filter_dump *filter_dump,
 
 void nfct_filter_dump_set_attr_u8(struct nfct_filter_dump *filter_dump,
 				  const enum nfct_filter_dump_attr type,
-				  u_int8_t data);
+				  uint8_t data);
 
 /* low level API: netlink functions */
 
@@ -557,8 +557,8 @@ extern __attribute__((deprecated)) int
 nfct_build_conntrack(struct nfnl_subsys_handle *ssh,
 				void *req,
 				size_t size,
-				u_int16_t type,
-				u_int16_t flags,
+				uint16_t type,
+				uint16_t flags,
 				const struct nf_conntrack *ct);
 
 extern __attribute__((deprecated))
@@ -644,27 +644,27 @@ extern void nfexp_set_attr(struct nf_expect *exp,
 
 extern void nfexp_set_attr_u8(struct nf_expect *exp,
 			      const enum nf_expect_attr type,
-			      u_int8_t value);
+			      uint8_t value);
 
 extern void nfexp_set_attr_u16(struct nf_expect *exp,
 			       const enum nf_expect_attr type,
-			       u_int16_t value);
+			       uint16_t value);
 
 extern void nfexp_set_attr_u32(struct nf_expect *exp,
 			       const enum nf_expect_attr type,
-			       u_int32_t value);
+			       uint32_t value);
 
 /* getter */
 extern const void *nfexp_get_attr(const struct nf_expect *exp,
 				  const enum nf_expect_attr type);
 
-extern u_int8_t nfexp_get_attr_u8(const struct nf_expect *exp,
+extern uint8_t nfexp_get_attr_u8(const struct nf_expect *exp,
 				  const enum nf_expect_attr type);
 
-extern u_int16_t nfexp_get_attr_u16(const struct nf_expect *exp,
+extern uint16_t nfexp_get_attr_u16(const struct nf_expect *exp,
 				    const enum nf_expect_attr type);
 
-extern u_int32_t nfexp_get_attr_u32(const struct nf_expect *exp,
+extern uint32_t nfexp_get_attr_u32(const struct nf_expect *exp,
 				    const enum nf_expect_attr type);
 
 /* checker */
@@ -704,8 +704,8 @@ extern __attribute__((deprecated))
 int nfexp_build_expect(struct nfnl_subsys_handle *ssh,
 			      void *req,
 			      size_t size,
-			      u_int16_t type,
-			      u_int16_t flags,
+			      uint16_t type,
+			      uint16_t flags,
 			      const struct nf_expect *exp);
 
 extern __attribute__((deprecated))
diff --git a/qa/ct_echo_event.c b/qa/ct_echo_event.c
index 6874395..eb9c82f 100644
--- a/qa/ct_echo_event.c
+++ b/qa/ct_echo_event.c
@@ -11,7 +11,7 @@
 static void udp_echo(const struct mnl_socket *nl,
 		     const char *pre, const char *post)
 {
-	u_int8_t proto = IPPROTO_UDP;
+	uint8_t proto = IPPROTO_UDP;
 
 	sync_fifo(pre);
 	timeout.tv_sec = INIT_TIMEOUT;
@@ -25,7 +25,7 @@ static void udp_echo(const struct mnl_socket *nl,
 static void icmp_echo(const struct mnl_socket *nl,
 		      const char *pre, const char *post)
 {
-	u_int8_t proto = IPPROTO_ICMP;
+	uint8_t proto = IPPROTO_ICMP;
 
 	sync_fifo(pre);
 	timeout.tv_sec = INIT_TIMEOUT;
diff --git a/qa/ct_mark_filter.c b/qa/ct_mark_filter.c
index 276344a..cd6dd27 100644
--- a/qa/ct_mark_filter.c
+++ b/qa/ct_mark_filter.c
@@ -12,7 +12,7 @@
 static void tcp_echo_before_fin(const struct mnl_socket *nl,
 			       const char *pre, const char *post)
 {
-	u_int8_t proto = IPPROTO_TCP;
+	uint8_t proto = IPPROTO_TCP;
 
 	sync_fifo(pre);
 	timeout.tv_sec = INIT_TIMEOUT;
@@ -26,7 +26,7 @@ static void tcp_echo_before_fin(const struct mnl_socket *nl,
 static void tcp_echo_after_fin(const struct mnl_socket *nl,
 			       const char *pre, const char *post)
 {
-	u_int8_t proto = IPPROTO_TCP;
+	uint8_t proto = IPPROTO_TCP;
 
 	sync_fifo(pre);
 	timeout.tv_sec = INIT_TIMEOUT;
diff --git a/qa/nssocket.c b/qa/nssocket.c
index a5f606d..114938c 100644
--- a/qa/nssocket.c
+++ b/qa/nssocket.c
@@ -435,7 +435,7 @@ struct nf_conntrack *author_new(const struct nlmsghdr *nlh, void *data)
 	ct = nfct_new();
 	assert(ct != NULL);
 	assert(nfct_nlmsg_parse((nlh), ct) == 0);
-	assert_proto(ct, AF_INET, *(u_int8_t *) data);
+	assert_proto(ct, AF_INET, *(uint8_t *) data);
 	assert_inaddr(ct, VETH_PARENT_ADDR, VETH_CHILD_ADDR);
 	assert((nfct_get_attr_u32(ct, ATTR_STATUS) & IPS_SEEN_REPLY) == 0);
 	timeout.tv_sec = nfct_get_attr_u32(ct, ATTR_TIMEOUT) + 1;
@@ -452,7 +452,7 @@ struct nf_conntrack *author_update(const struct nlmsghdr *nlh, void *data)
 	ct = nfct_new();
 	assert(ct != NULL);
 	assert(nfct_nlmsg_parse((nlh), ct) == 0);
-	assert_proto(ct, AF_INET, *(u_int8_t *) data);
+	assert_proto(ct, AF_INET, *(uint8_t *) data);
 	assert_inaddr(ct, VETH_PARENT_ADDR, VETH_CHILD_ADDR);
 	assert((nfct_get_attr_u32(ct, ATTR_STATUS) & IPS_SEEN_REPLY));
 	timeout.tv_sec = nfct_get_attr_u32(ct, ATTR_TIMEOUT) + 1;
@@ -469,7 +469,7 @@ struct nf_conntrack *author_destroy(const struct nlmsghdr *nlh, void *data)
 	ct = nfct_new();
 	assert(ct != NULL);
 	assert(nfct_nlmsg_parse((nlh), ct) == 0);
-	assert_proto(ct, AF_INET, *(u_int8_t *) data);
+	assert_proto(ct, AF_INET, *(uint8_t *) data);
 	assert_inaddr(ct, VETH_PARENT_ADDR, VETH_CHILD_ADDR);
 	assert((nfct_get_attr_u32(ct, ATTR_STATUS) & IPS_SEEN_REPLY));
 
@@ -477,7 +477,7 @@ struct nf_conntrack *author_destroy(const struct nlmsghdr *nlh, void *data)
 }
 
 void assert_proto(const struct nf_conntrack *ct,
-		  u_int8_t l3proto, u_int8_t l4proto)
+		  uint8_t l3proto, uint8_t l4proto)
 {
 	assert(nfct_get_attr_u8(ct, ATTR_ORIG_L3PROTO) == l3proto);
 	assert(nfct_get_attr_u8(ct, ATTR_REPL_L3PROTO) == l3proto);
@@ -498,7 +498,7 @@ void assert_inaddr(const struct nf_conntrack *ct,
 }
 
 void assert_port(const struct nf_conntrack *ct,
-		 u_int16_t src, u_int16_t dst)
+		 uint16_t src, uint16_t dst)
 {
 	if ((src)) {
 		assert(nfct_get_attr_u16((ct), ATTR_ORIG_PORT_SRC) == htons((src)));
@@ -511,7 +511,7 @@ void assert_port(const struct nf_conntrack *ct,
 }
 
 void assert_typecode(const struct nf_conntrack *ct,
-		     u_int8_t type, u_int8_t code)
+		     uint8_t type, uint8_t code)
 {
 	assert(nfct_get_attr_u8((ct), ATTR_ICMP_TYPE) == type);
 	assert(nfct_get_attr_u8((ct), ATTR_ICMP_CODE) == code);
@@ -636,7 +636,7 @@ int cb_tcp_destroy(const struct nlmsghdr *nlh, void *data)
 void tcp_echo(const struct mnl_socket *nl,
 	      const char *pre, const char *post)
 {
-	u_int8_t proto = IPPROTO_TCP;
+	uint8_t proto = IPPROTO_TCP;
 
 	sync_fifo(pre);
 	timeout.tv_sec = INIT_TIMEOUT;
diff --git a/qa/nssocket.h b/qa/nssocket.h
index 17c859f..338ed2f 100644
--- a/qa/nssocket.h
+++ b/qa/nssocket.h
@@ -29,13 +29,13 @@ struct nf_conntrack *author_new(const struct nlmsghdr *nlh, void *data);
 struct nf_conntrack *author_update(const struct nlmsghdr *nlh, void *data);
 struct nf_conntrack *author_destroy(const struct nlmsghdr *nlh, void *data);
 void assert_proto(const struct nf_conntrack *ct,
-		  u_int8_t l3proto, u_int8_t l4proto);
+		  uint8_t l3proto, uint8_t l4proto);
 void assert_inaddr(const struct nf_conntrack *ct,
 		   const char *src, const char *dst);
 void assert_port(const struct nf_conntrack *ct,
-		 u_int16_t src, u_int16_t dst);
+		 uint16_t src, uint16_t dst);
 void assert_typecode(const struct nf_conntrack *ct,
-		     u_int8_t type, u_int8_t code);
+		     uint8_t type, uint8_t code);
 int cb_icmp_new(const struct nlmsghdr *nlh, void *data);
 int cb_icmp_update(const struct nlmsghdr *nlh, void *data);
 int cb_icmp_destroy(const struct nlmsghdr *nlh, void *data);
diff --git a/src/callback.c b/src/callback.c
index 19cc663..69640da 100644
--- a/src/callback.c
+++ b/src/callback.c
@@ -11,8 +11,8 @@
 
 static int __parse_message(const struct nlmsghdr *nlh)
 {
-	u_int16_t type = NFNL_MSG_TYPE(nlh->nlmsg_type);
-	u_int16_t flags = nlh->nlmsg_flags;
+	uint16_t type = NFNL_MSG_TYPE(nlh->nlmsg_type);
+	uint16_t flags = nlh->nlmsg_flags;
 	int ret = NFCT_T_UNKNOWN;
 
 	switch(type) {
@@ -36,7 +36,7 @@ int __callback(struct nlmsghdr *nlh, struct nfattr *nfa[], void *data)
 	struct nf_conntrack *ct = NULL;
 	struct nf_expect *exp = NULL;
 	struct __data_container *container = data;
-	u_int8_t subsys = NFNL_SUBSYS_ID(nlh->nlmsg_type);
+	uint8_t subsys = NFNL_SUBSYS_ID(nlh->nlmsg_type);
 
 	if (nlh->nlmsg_len < NLMSG_LENGTH(sizeof(struct nfgenmsg))) {
 		errno = EINVAL;
diff --git a/src/conntrack/api.c b/src/conntrack/api.c
index fede302..ed235ff 100644
--- a/src/conntrack/api.c
+++ b/src/conntrack/api.c
@@ -411,9 +411,9 @@ void nfct_set_attr(struct nf_conntrack *ct,
  */
 void nfct_set_attr_u8(struct nf_conntrack *ct,
 		      const enum nf_conntrack_attr type, 
-		      u_int8_t value)
+		      uint8_t value)
 {
-	nfct_set_attr_l(ct, type, &value, sizeof(u_int8_t));
+	nfct_set_attr_l(ct, type, &value, sizeof(uint8_t));
 }
 
 /**
@@ -424,9 +424,9 @@ void nfct_set_attr_u8(struct nf_conntrack *ct,
  */
 void nfct_set_attr_u16(struct nf_conntrack *ct,
 		       const enum nf_conntrack_attr type, 
-		       u_int16_t value)
+		       uint16_t value)
 {
-	nfct_set_attr_l(ct, type, &value, sizeof(u_int16_t));
+	nfct_set_attr_l(ct, type, &value, sizeof(uint16_t));
 }
 
 /**
@@ -437,9 +437,9 @@ void nfct_set_attr_u16(struct nf_conntrack *ct,
  */
 void nfct_set_attr_u32(struct nf_conntrack *ct,
 		       const enum nf_conntrack_attr type, 
-		       u_int32_t value)
+		       uint32_t value)
 {
-	nfct_set_attr_l(ct, type, &value, sizeof(u_int32_t));
+	nfct_set_attr_l(ct, type, &value, sizeof(uint32_t));
 }
 
 /**
@@ -450,9 +450,9 @@ void nfct_set_attr_u32(struct nf_conntrack *ct,
  */
 void nfct_set_attr_u64(struct nf_conntrack *ct,
 		       const enum nf_conntrack_attr type, 
-		       u_int64_t value)
+		       uint64_t value)
 {
-	nfct_set_attr_l(ct, type, &value, sizeof(u_int64_t));
+	nfct_set_attr_l(ct, type, &value, sizeof(uint64_t));
 }
 
 /**
@@ -492,10 +492,10 @@ const void *nfct_get_attr(const struct nf_conntrack *ct,
  * set, 0 is returned. In order to check if the attribute is set or not,
  * use nfct_attr_is_set.
  */
-u_int8_t nfct_get_attr_u8(const struct nf_conntrack *ct,
+uint8_t nfct_get_attr_u8(const struct nf_conntrack *ct,
 			  const enum nf_conntrack_attr type)
 {
-	const u_int8_t *ret = nfct_get_attr(ct, type);
+	const uint8_t *ret = nfct_get_attr(ct, type);
 	return ret == NULL ? 0 : *ret;
 }
 
@@ -508,10 +508,10 @@ u_int8_t nfct_get_attr_u8(const struct nf_conntrack *ct,
  * set, 0 is returned. In order to check if the attribute is set or not,
  * use nfct_attr_is_set.
  */
-u_int16_t nfct_get_attr_u16(const struct nf_conntrack *ct,
+uint16_t nfct_get_attr_u16(const struct nf_conntrack *ct,
 			    const enum nf_conntrack_attr type)
 {
-	const u_int16_t *ret = nfct_get_attr(ct, type);
+	const uint16_t *ret = nfct_get_attr(ct, type);
 	return ret == NULL ? 0 : *ret;
 }
 
@@ -524,10 +524,10 @@ u_int16_t nfct_get_attr_u16(const struct nf_conntrack *ct,
  * set, 0 is returned. In order to check if the attribute is set or not,
  * use nfct_attr_is_set.
  */
-u_int32_t nfct_get_attr_u32(const struct nf_conntrack *ct,
+uint32_t nfct_get_attr_u32(const struct nf_conntrack *ct,
 			    const enum nf_conntrack_attr type)
 {
-	const u_int32_t *ret = nfct_get_attr(ct, type);
+	const uint32_t *ret = nfct_get_attr(ct, type);
 	return ret == NULL ? 0 : *ret;
 }
 
@@ -540,10 +540,10 @@ u_int32_t nfct_get_attr_u32(const struct nf_conntrack *ct,
  * set, 0 is returned. In order to check if the attribute is set or not,
  * use nfct_attr_is_set.
  */
-u_int64_t nfct_get_attr_u64(const struct nf_conntrack *ct,
+uint64_t nfct_get_attr_u64(const struct nf_conntrack *ct,
 			    const enum nf_conntrack_attr type)
 {
-	const u_int64_t *ret = nfct_get_attr(ct, type);
+	const uint64_t *ret = nfct_get_attr(ct, type);
 	return ret == NULL ? 0 : *ret;
 }
 
@@ -770,8 +770,8 @@ int nfct_attr_grp_unset(struct nf_conntrack *ct,
 int nfct_build_conntrack(struct nfnl_subsys_handle *ssh,
 			 void *req,
 			 size_t size,
-			 u_int16_t type,
-			 u_int16_t flags,
+			 uint16_t type,
+			 uint16_t flags,
 			 const struct nf_conntrack *ct)
 {
 	assert(ssh != NULL);
@@ -787,7 +787,7 @@ __build_query_ct(struct nfnl_subsys_handle *ssh,
 		 const void *data, void *buffer, unsigned int size)
 {
 	struct nfnlhdr *req = buffer;
-	const u_int32_t *family = data;
+	const uint32_t *family = data;
 
 	assert(ssh != NULL);
 	assert(data != NULL);
@@ -866,7 +866,7 @@ __build_query_ct(struct nfnl_subsys_handle *ssh,
  * 	- NFCT_Q_DUMP_FILTER: dump the conntrack table
  * 	- NFCT_Q_DUMP_FILTER_RESET: dump the conntrack table and reset counters
  *
- * Pass a valid pointer to the protocol family (u_int32_t)
+ * Pass a valid pointer to the protocol family (uint32_t)
  *
  * On success, 0 is returned. On error, -1 is returned and errno is set
  * appropiately.
@@ -1379,7 +1379,7 @@ void nfct_filter_add_attr(struct nfct_filter *filter,
  */
 void nfct_filter_add_attr_u32(struct nfct_filter *filter,
 			      const enum nfct_filter_attr type,
-			      u_int32_t value)
+			      uint32_t value)
 {
 	nfct_filter_add_attr(filter, type, &value);
 }
@@ -1511,7 +1511,7 @@ void nfct_filter_dump_set_attr(struct nfct_filter_dump *filter_dump,
  */
 void nfct_filter_dump_set_attr_u8(struct nfct_filter_dump *filter_dump,
 				  const enum nfct_filter_dump_attr type,
-				  u_int8_t value)
+				  uint8_t value)
 {
 	nfct_filter_dump_set_attr(filter_dump, type, &value);
 }
diff --git a/src/conntrack/bsf.c b/src/conntrack/bsf.c
index bc73369..1549815 100644
--- a/src/conntrack/bsf.c
+++ b/src/conntrack/bsf.c
@@ -25,7 +25,7 @@
 #define NFCT_FILTER_ACCEPT	~0U
 
 #if 0
-static char *code2str(u_int16_t code)
+static char *code2str(uint16_t code)
 {
 	switch(code) {
 	case BPF_LD|BPF_IMM:
@@ -156,8 +156,8 @@ nfct_bsf_find_attr_nest(struct sock_filter *this, int attr, int pos)
 
 struct jump {
 	int line;
-	u_int8_t jt;
-	u_int8_t jf;
+	uint8_t jt;
+	uint8_t jf;
 };
 
 static int
@@ -290,7 +290,7 @@ nfct_bsf_jump_to(struct sock_filter *this, int line, int pos)
 
 /* this helps to skip messages coming from the ctnetlink expectation subsys. */
 static int
-bsf_cmp_subsys(struct sock_filter *this, int pos, u_int8_t subsys)
+bsf_cmp_subsys(struct sock_filter *this, int pos, uint8_t subsys)
 {
 	struct sock_filter __code[] = {
 		[0] = {
@@ -301,7 +301,7 @@ bsf_cmp_subsys(struct sock_filter *this, int pos, u_int8_t subsys)
 		[1] = {
 			/* A = skb->data[X+k:B] (subsys_id) */
 			.code	= BPF_LD|BPF_B|BPF_IND,
-			.k	= sizeof(u_int8_t),
+			.k	= sizeof(uint8_t),
 		},
 		[2] = {
 			/* A == subsys ? jump +1 : accept */
@@ -319,7 +319,7 @@ static int
 add_state_filter_cta(struct sock_filter *this,
 		     unsigned int cta_protoinfo_proto,
 		     unsigned int cta_protoinfo_state,
-		     u_int16_t state_flags,
+		     uint16_t state_flags,
 		     unsigned int logic)
 {
 	unsigned int i, j;
@@ -375,7 +375,7 @@ add_state_filter_cta(struct sock_filter *this,
 static int 
 add_state_filter(struct sock_filter *this, 
 		 int proto,
-		 u_int16_t flags,
+		 uint16_t flags,
 		 unsigned int logic)
 {
 	static const struct {
diff --git a/src/conntrack/build.c b/src/conntrack/build.c
index 4852536..0549084 100644
--- a/src/conntrack/build.c
+++ b/src/conntrack/build.c
@@ -20,9 +20,9 @@ static void __build_tuple_ip(struct nfnlhdr *req,
 	switch(t->l3protonum) {
 	case AF_INET:
 	        nfnl_addattr_l(&req->nlh, size, CTA_IP_V4_SRC, &t->src.v4,
-			       sizeof(u_int32_t));
+			       sizeof(uint32_t));
 		nfnl_addattr_l(&req->nlh, size, CTA_IP_V4_DST, &t->dst.v4,
-			       sizeof(u_int32_t));
+			       sizeof(uint32_t));
 		break;
 	case AF_INET6:
 		nfnl_addattr_l(&req->nlh, size, CTA_IP_V6_SRC, &t->src.v6,
@@ -46,7 +46,7 @@ static void __build_tuple_proto(struct nfnlhdr *req,
 	nest = nfnl_nest(&req->nlh, size, CTA_TUPLE_PROTO);
 
 	nfnl_addattr_l(&req->nlh, size, CTA_PROTO_NUM, &t->protonum,
-		       sizeof(u_int8_t));
+		       sizeof(uint8_t));
 
 	switch(t->protonum) {
 	case IPPROTO_UDP:
@@ -56,27 +56,27 @@ static void __build_tuple_proto(struct nfnlhdr *req,
 	case IPPROTO_GRE:
 	case IPPROTO_UDPLITE:
 		nfnl_addattr_l(&req->nlh, size, CTA_PROTO_SRC_PORT,
-			       &t->l4src.tcp.port, sizeof(u_int16_t));
+			       &t->l4src.tcp.port, sizeof(uint16_t));
 		nfnl_addattr_l(&req->nlh, size, CTA_PROTO_DST_PORT,
-			       &t->l4dst.tcp.port, sizeof(u_int16_t));
+			       &t->l4dst.tcp.port, sizeof(uint16_t));
 		break;
 
 	case IPPROTO_ICMP:
 		nfnl_addattr_l(&req->nlh, size, CTA_PROTO_ICMP_CODE,
-			       &t->l4dst.icmp.code, sizeof(u_int8_t));
+			       &t->l4dst.icmp.code, sizeof(uint8_t));
 		nfnl_addattr_l(&req->nlh, size, CTA_PROTO_ICMP_TYPE,
-			       &t->l4dst.icmp.type, sizeof(u_int8_t));
+			       &t->l4dst.icmp.type, sizeof(uint8_t));
 		nfnl_addattr_l(&req->nlh, size, CTA_PROTO_ICMP_ID,
-			       &t->l4src.icmp.id, sizeof(u_int16_t));
+			       &t->l4src.icmp.id, sizeof(uint16_t));
 		break;
 
 	case IPPROTO_ICMPV6:
 		nfnl_addattr_l(&req->nlh, size, CTA_PROTO_ICMPV6_CODE,
-			       &t->l4dst.icmp.code, sizeof(u_int8_t));
+			       &t->l4dst.icmp.code, sizeof(uint8_t));
 		nfnl_addattr_l(&req->nlh, size, CTA_PROTO_ICMPV6_TYPE,
-			       &t->l4dst.icmp.type, sizeof(u_int8_t));
+			       &t->l4dst.icmp.type, sizeof(uint8_t));
 		nfnl_addattr_l(&req->nlh, size, CTA_PROTO_ICMPV6_ID,
-			       &t->l4src.icmp.id, sizeof(u_int16_t));
+			       &t->l4src.icmp.id, sizeof(uint16_t));
 		break;
 
 	default:
@@ -126,7 +126,7 @@ static void __build_protoinfo(struct nfnlhdr *req, size_t size,
 			nfnl_addattr_l(&req->nlh, size,
 				       CTA_PROTOINFO_TCP_STATE,
 				       &ct->protoinfo.tcp.state,
-				       sizeof(u_int8_t));
+				       sizeof(uint8_t));
 		if (test_bit(ATTR_TCP_FLAGS_ORIG, ct->head.set) &&
 		    test_bit(ATTR_TCP_MASK_ORIG, ct->head.set))
 			nfnl_addattr_l(&req->nlh, size,
@@ -143,12 +143,12 @@ static void __build_protoinfo(struct nfnlhdr *req, size_t size,
 			nfnl_addattr_l(&req->nlh, size,
 				       CTA_PROTOINFO_TCP_WSCALE_ORIGINAL,
 				       &ct->protoinfo.tcp.wscale[__DIR_ORIG],
-				       sizeof(u_int8_t));
+				       sizeof(uint8_t));
 		if (test_bit(ATTR_TCP_WSCALE_REPL, ct->head.set))
 			nfnl_addattr_l(&req->nlh, size,
 				       CTA_PROTOINFO_TCP_WSCALE_REPLY,
 				       &ct->protoinfo.tcp.wscale[__DIR_REPL],
-				       sizeof(u_int8_t));
+				       sizeof(uint8_t));
 		nfnl_nest_end(&req->nlh, nest_proto);
 		nfnl_nest_end(&req->nlh, nest);
 		break;
@@ -165,7 +165,7 @@ static void __build_protoinfo(struct nfnlhdr *req, size_t size,
 			nfnl_addattr_l(&req->nlh, size,
 				       CTA_PROTOINFO_SCTP_STATE,
 				       &ct->protoinfo.sctp.state,
-				       sizeof(u_int8_t));
+				       sizeof(uint8_t));
 		if (test_bit(ATTR_SCTP_VTAG_ORIG, ct->head.set))
 			nfnl_addattr32(&req->nlh, size,
 				    CTA_PROTOINFO_SCTP_VTAG_ORIGINAL,
@@ -190,23 +190,23 @@ static void __build_protoinfo(struct nfnlhdr *req, size_t size,
 			nfnl_addattr_l(&req->nlh, size,
 				       CTA_PROTOINFO_DCCP_STATE,
 				       &ct->protoinfo.dccp.state,
-				       sizeof(u_int8_t));
+				       sizeof(uint8_t));
 		if (test_bit(ATTR_DCCP_ROLE, ct->head.set))
 			nfnl_addattr_l(&req->nlh, size,
 				       CTA_PROTOINFO_DCCP_ROLE,
 				       &ct->protoinfo.dccp.role,
-				       sizeof(u_int8_t));
+				       sizeof(uint8_t));
 		if (test_bit(ATTR_DCCP_HANDSHAKE_SEQ, ct->head.set)) {
 			/* FIXME: use __cpu_to_be64() instead which is the
 			 * correct operation. This is a semantic abuse but
 			 * we have no function to do it in libnfnetlink. */
-			u_int64_t handshake_seq =
+			uint64_t handshake_seq =
 				__be64_to_cpu(ct->protoinfo.dccp.handshake_seq);
 
 			nfnl_addattr_l(&req->nlh, size,
 				       CTA_PROTOINFO_DCCP_HANDSHAKE_SEQ,
 				       &handshake_seq,
-				       sizeof(u_int64_t));
+				       sizeof(uint64_t));
 		}
 		nfnl_nest_end(&req->nlh, nest_proto);
 		nfnl_nest_end(&req->nlh, nest);
@@ -263,9 +263,9 @@ static void __build_protonat(struct nfnlhdr *req,
 	case IPPROTO_TCP:
 	case IPPROTO_UDP:
 		nfnl_addattr_l(&req->nlh, size, CTA_PROTONAT_PORT_MIN,
-			       &nat->l4min.tcp.port, sizeof(u_int16_t));
+			       &nat->l4min.tcp.port, sizeof(uint16_t));
 		nfnl_addattr_l(&req->nlh, size, CTA_PROTONAT_PORT_MAX,
-			       &nat->l4max.tcp.port, sizeof(u_int16_t));
+			       &nat->l4max.tcp.port, sizeof(uint16_t));
 		break;
 	}
 	nfnl_nest_end(&req->nlh, nest);
@@ -276,7 +276,7 @@ static void __build_nat(struct nfnlhdr *req,
 			const struct __nfct_nat *nat)
 {
 	nfnl_addattr_l(&req->nlh, size, CTA_NAT_MINIP,
-		       &nat->min_ip, sizeof(u_int32_t));
+		       &nat->min_ip, sizeof(uint32_t));
 }
 
 static void __build_snat(struct nfnlhdr *req,
@@ -425,11 +425,11 @@ static void __build_labels(struct nfnlhdr *req,
 int __build_conntrack(struct nfnl_subsys_handle *ssh,
 		      struct nfnlhdr *req,
 		      size_t size,
-		      u_int16_t type,
-		      u_int16_t flags,
+		      uint16_t type,
+		      uint16_t flags,
 		      const struct nf_conntrack *ct)
 {
-	u_int8_t l3num = ct->head.orig.l3protonum;
+	uint8_t l3num = ct->head.orig.l3protonum;
 
 	if (!test_bit(ATTR_ORIG_L3PROTO, ct->head.set)) {
 		errno = EINVAL;
diff --git a/src/conntrack/filter.c b/src/conntrack/filter.c
index 78fbbc5..4cbc116 100644
--- a/src/conntrack/filter.c
+++ b/src/conntrack/filter.c
@@ -59,9 +59,9 @@ static void filter_attr_src_ipv6(struct nfct_filter *filter, const void *value)
 		return;
 
 	memcpy(filter->l3proto_ipv6[0][filter->l3proto_elems_ipv6[0]].addr,
-	       this->addr, sizeof(u_int32_t)*4);
+	       this->addr, sizeof(uint32_t)*4);
 	memcpy(filter->l3proto_ipv6[0][filter->l3proto_elems_ipv6[0]].mask,
-	       this->mask, sizeof(u_int32_t)*4);
+	       this->mask, sizeof(uint32_t)*4);
 	filter->l3proto_elems_ipv6[0]++;
 }
 
@@ -73,9 +73,9 @@ static void filter_attr_dst_ipv6(struct nfct_filter *filter, const void *value)
 		return;
 
 	memcpy(filter->l3proto_ipv6[1][filter->l3proto_elems_ipv6[1]].addr,
-	       this->addr, sizeof(u_int32_t)*4);
+	       this->addr, sizeof(uint32_t)*4);
 	memcpy(filter->l3proto_ipv6[1][filter->l3proto_elems_ipv6[1]].mask,
-	       this->mask, sizeof(u_int32_t)*4);
+	       this->mask, sizeof(uint32_t)*4);
 	filter->l3proto_elems_ipv6[1]++;
 }
 
diff --git a/src/conntrack/filter_dump.c b/src/conntrack/filter_dump.c
index 4819759..158b4cb 100644
--- a/src/conntrack/filter_dump.c
+++ b/src/conntrack/filter_dump.c
@@ -23,7 +23,7 @@ static void
 set_filter_dump_attr_family(struct nfct_filter_dump *filter_dump,
 			    const void *value)
 {
-	filter_dump->l3num = *((u_int8_t *)value);
+	filter_dump->l3num = *((uint8_t *)value);
 }
 
 const set_filter_dump_attr set_filter_dump_attr_array[NFCT_FILTER_DUMP_MAX] = {
diff --git a/src/conntrack/grp_getter.c b/src/conntrack/grp_getter.c
index 9770340..2756aea 100644
--- a/src/conntrack/grp_getter.c
+++ b/src/conntrack/grp_getter.c
@@ -26,15 +26,15 @@ static void get_attr_grp_repl_ipv4(const struct nf_conntrack *ct, void *data)
 static void get_attr_grp_orig_ipv6(const struct nf_conntrack *ct, void *data)
 {
 	struct nfct_attr_grp_ipv6 *this = data;
-	memcpy(this->src, &ct->head.orig.src.v6, sizeof(u_int32_t)*4);
-	memcpy(this->dst, &ct->head.orig.dst.v6, sizeof(u_int32_t)*4);
+	memcpy(this->src, &ct->head.orig.src.v6, sizeof(uint32_t)*4);
+	memcpy(this->dst, &ct->head.orig.dst.v6, sizeof(uint32_t)*4);
 }
 
 static void get_attr_grp_repl_ipv6(const struct nf_conntrack *ct, void *data)
 {
 	struct nfct_attr_grp_ipv6 *this = data;
-	memcpy(this->src, &ct->repl.src.v6, sizeof(u_int32_t)*4);
-	memcpy(this->dst, &ct->repl.dst.v6, sizeof(u_int32_t)*4);
+	memcpy(this->src, &ct->repl.src.v6, sizeof(uint32_t)*4);
+	memcpy(this->dst, &ct->repl.dst.v6, sizeof(uint32_t)*4);
 }
 
 static void get_attr_grp_orig_port(const struct nf_conntrack *ct, void *data)
@@ -69,8 +69,8 @@ static void get_attr_grp_master_ipv4(const struct nf_conntrack *ct, void *data)
 static void get_attr_grp_master_ipv6(const struct nf_conntrack *ct, void *data)
 {
 	struct nfct_attr_grp_ipv6 *this = data;
-	memcpy(this->src, &ct->master.src.v6, sizeof(u_int32_t)*4);
-	memcpy(this->dst, &ct->master.dst.v6, sizeof(u_int32_t)*4);
+	memcpy(this->src, &ct->master.src.v6, sizeof(uint32_t)*4);
+	memcpy(this->dst, &ct->master.dst.v6, sizeof(uint32_t)*4);
 }
 
 static void get_attr_grp_master_port(const struct nf_conntrack *ct, void *data)
diff --git a/src/conntrack/grp_setter.c b/src/conntrack/grp_setter.c
index 0cc5f18..fccf578 100644
--- a/src/conntrack/grp_setter.c
+++ b/src/conntrack/grp_setter.c
@@ -11,7 +11,7 @@
 #include <linux/icmp.h>
 #include <linux/icmpv6.h>
 
-static const u_int8_t invmap_icmp[] = {
+static const uint8_t invmap_icmp[] = {
 	[ICMP_ECHO]		= ICMP_ECHOREPLY + 1,
 	[ICMP_ECHOREPLY]	= ICMP_ECHO + 1,
 	[ICMP_TIMESTAMP]	= ICMP_TIMESTAMPREPLY + 1,
@@ -30,7 +30,7 @@ static const u_int8_t invmap_icmp[] = {
 #define ICMPV6_NI_REPLY 140
 #endif
 
-static const u_int8_t invmap_icmpv6[] = {
+static const uint8_t invmap_icmpv6[] = {
 	[ICMPV6_ECHO_REQUEST - 128]	= ICMPV6_ECHO_REPLY + 1,
 	[ICMPV6_ECHO_REPLY - 128]	= ICMPV6_ECHO_REQUEST + 1,
 	[ICMPV6_NI_QUERY - 128]		= ICMPV6_NI_QUERY + 1,
@@ -56,16 +56,16 @@ static void set_attr_grp_repl_ipv4(struct nf_conntrack *ct, const void *value)
 static void set_attr_grp_orig_ipv6(struct nf_conntrack *ct, const void *value)
 {
 	const struct nfct_attr_grp_ipv6 *this = value;
-	memcpy(&ct->head.orig.src.v6, this->src, sizeof(u_int32_t)*4);
-	memcpy(&ct->head.orig.dst.v6, this->dst, sizeof(u_int32_t)*4);
+	memcpy(&ct->head.orig.src.v6, this->src, sizeof(uint32_t)*4);
+	memcpy(&ct->head.orig.dst.v6, this->dst, sizeof(uint32_t)*4);
 	ct->head.orig.l3protonum = AF_INET6;
 }
 
 static void set_attr_grp_repl_ipv6(struct nf_conntrack *ct, const void *value)
 {
 	const struct nfct_attr_grp_ipv6 *this = value;
-	memcpy(&ct->repl.src.v6, this->src, sizeof(u_int32_t)*4);
-	memcpy(&ct->repl.dst.v6, this->dst, sizeof(u_int32_t)*4);
+	memcpy(&ct->repl.src.v6, this->src, sizeof(uint32_t)*4);
+	memcpy(&ct->repl.dst.v6, this->dst, sizeof(uint32_t)*4);
 	ct->repl.l3protonum = AF_INET6;
 }
 
@@ -85,7 +85,7 @@ static void set_attr_grp_repl_port(struct nf_conntrack *ct, const void *value)
 
 static void set_attr_grp_icmp(struct nf_conntrack *ct, const void *value)
 {
-	u_int8_t rtype;
+	uint8_t rtype;
 	const struct nfct_attr_grp_icmp *this = value;
 
 	ct->head.orig.l4dst.icmp.type = this->type;
@@ -126,8 +126,8 @@ static void set_attr_grp_master_ipv4(struct nf_conntrack *ct, const void *value)
 static void set_attr_grp_master_ipv6(struct nf_conntrack *ct, const void *value)
 {
 	const struct nfct_attr_grp_ipv6 *this = value;
-	memcpy(&ct->master.src.v6, this->src, sizeof(u_int32_t)*4);
-	memcpy(&ct->master.dst.v6, this->dst, sizeof(u_int32_t)*4);
+	memcpy(&ct->master.src.v6, this->src, sizeof(uint32_t)*4);
+	memcpy(&ct->master.dst.v6, this->dst, sizeof(uint32_t)*4);
 	ct->master.l3protonum = AF_INET6;
 }
 
diff --git a/src/conntrack/parse.c b/src/conntrack/parse.c
index c003744..3eb8b81 100644
--- a/src/conntrack/parse.c
+++ b/src/conntrack/parse.c
@@ -14,14 +14,14 @@
 static void __parse_ip(const struct nfattr *attr,
 		       struct __nfct_tuple *tuple,
 		       const int dir,
-		       u_int32_t *set)
+		       uint32_t *set)
 {
 	struct nfattr *tb[CTA_IP_MAX];
 
         nfnl_parse_nested(tb, CTA_IP_MAX, attr);
 
 	if (tb[CTA_IP_V4_SRC-1]) {
-		tuple->src.v4 = *(u_int32_t *)NFA_DATA(tb[CTA_IP_V4_SRC-1]);
+		tuple->src.v4 = *(uint32_t *)NFA_DATA(tb[CTA_IP_V4_SRC-1]);
 		switch(dir) {
 		case __DIR_ORIG:
 			set_bit(ATTR_ORIG_IPV4_SRC, set);
@@ -36,7 +36,7 @@ static void __parse_ip(const struct nfattr *attr,
 	}
 
 	if (tb[CTA_IP_V4_DST-1]) {
-		tuple->dst.v4 = *(u_int32_t *)NFA_DATA(tb[CTA_IP_V4_DST-1]);
+		tuple->dst.v4 = *(uint32_t *)NFA_DATA(tb[CTA_IP_V4_DST-1]);
 		switch(dir) {
 		case __DIR_ORIG:
 			set_bit(ATTR_ORIG_IPV4_DST, set);
@@ -86,14 +86,14 @@ static void __parse_ip(const struct nfattr *attr,
 static void __parse_proto(const struct nfattr *attr,
 			  struct __nfct_tuple *tuple,
 		   const int dir,
-		   u_int32_t *set)
+		   uint32_t *set)
 {
 	struct nfattr *tb[CTA_PROTO_MAX];
 
 	nfnl_parse_nested(tb, CTA_PROTO_MAX, attr);
 
 	if (tb[CTA_PROTO_NUM-1]) {
-		tuple->protonum = *(u_int8_t *)NFA_DATA(tb[CTA_PROTO_NUM-1]);
+		tuple->protonum = *(uint8_t *)NFA_DATA(tb[CTA_PROTO_NUM-1]);
 		switch(dir) {
 		case __DIR_ORIG:
 			set_bit(ATTR_ORIG_L4PROTO, set);
@@ -109,7 +109,7 @@ static void __parse_proto(const struct nfattr *attr,
 
 	if (tb[CTA_PROTO_SRC_PORT-1]) {
 		tuple->l4src.tcp.port =
-			*(u_int16_t *)NFA_DATA(tb[CTA_PROTO_SRC_PORT-1]);
+			*(uint16_t *)NFA_DATA(tb[CTA_PROTO_SRC_PORT-1]);
 		switch(dir) {
 		case __DIR_ORIG:
 			set_bit(ATTR_ORIG_PORT_SRC, set);
@@ -125,7 +125,7 @@ static void __parse_proto(const struct nfattr *attr,
 	
 	if (tb[CTA_PROTO_DST_PORT-1]) {
 		tuple->l4dst.tcp.port =
-			*(u_int16_t *)NFA_DATA(tb[CTA_PROTO_DST_PORT-1]);
+			*(uint16_t *)NFA_DATA(tb[CTA_PROTO_DST_PORT-1]);
 		switch(dir) {
 		case __DIR_ORIG:
 			set_bit(ATTR_ORIG_PORT_DST, set);
@@ -141,37 +141,37 @@ static void __parse_proto(const struct nfattr *attr,
 	
 	if (tb[CTA_PROTO_ICMP_TYPE-1]) {
 		tuple->l4dst.icmp.type =
-			*(u_int8_t *)NFA_DATA(tb[CTA_PROTO_ICMP_TYPE-1]);
+			*(uint8_t *)NFA_DATA(tb[CTA_PROTO_ICMP_TYPE-1]);
 		set_bit(ATTR_ICMP_TYPE, set);
 	}
 	
 	if (tb[CTA_PROTO_ICMP_CODE-1]) {
 		tuple->l4dst.icmp.code =
-			*(u_int8_t *)NFA_DATA(tb[CTA_PROTO_ICMP_CODE-1]);
+			*(uint8_t *)NFA_DATA(tb[CTA_PROTO_ICMP_CODE-1]);
 		set_bit(ATTR_ICMP_CODE, set);
 	}
 	
 	if (tb[CTA_PROTO_ICMP_ID-1]) {
 		tuple->l4src.icmp.id =
-			*(u_int16_t *)NFA_DATA(tb[CTA_PROTO_ICMP_ID-1]);
+			*(uint16_t *)NFA_DATA(tb[CTA_PROTO_ICMP_ID-1]);
 		set_bit(ATTR_ICMP_ID, set);
 	}
 
 	if (tb[CTA_PROTO_ICMPV6_TYPE-1]) {
 		tuple->l4dst.icmp.type =
-			*(u_int8_t *)NFA_DATA(tb[CTA_PROTO_ICMPV6_TYPE-1]);
+			*(uint8_t *)NFA_DATA(tb[CTA_PROTO_ICMPV6_TYPE-1]);
 		set_bit(ATTR_ICMP_TYPE, set);
 	}
 	
 	if (tb[CTA_PROTO_ICMPV6_CODE-1]) {
 		tuple->l4dst.icmp.code =
-			*(u_int8_t *)NFA_DATA(tb[CTA_PROTO_ICMPV6_CODE-1]);
+			*(uint8_t *)NFA_DATA(tb[CTA_PROTO_ICMPV6_CODE-1]);
 		set_bit(ATTR_ICMP_CODE, set);
 	}
 	
 	if (tb[CTA_PROTO_ICMPV6_ID-1]) {
 		tuple->l4src.icmp.id =
-			*(u_int16_t *)NFA_DATA(tb[CTA_PROTO_ICMPV6_ID-1]);
+			*(uint16_t *)NFA_DATA(tb[CTA_PROTO_ICMPV6_ID-1]);
 		set_bit(ATTR_ICMP_ID, set);
 	}
 }
@@ -179,7 +179,7 @@ static void __parse_proto(const struct nfattr *attr,
 void __parse_tuple(const struct nfattr *attr,
 		   struct __nfct_tuple *tuple, 
 		   int dir,
-		   u_int32_t *set)
+		   uint32_t *set)
 {
 	struct nfattr *tb[CTA_TUPLE_MAX];
 
@@ -200,21 +200,21 @@ static void __parse_protoinfo_tcp(const struct nfattr *attr,
 
 	if (tb[CTA_PROTOINFO_TCP_STATE-1]) {
                 ct->protoinfo.tcp.state =
-                        *(u_int8_t *)NFA_DATA(tb[CTA_PROTOINFO_TCP_STATE-1]);
+                        *(uint8_t *)NFA_DATA(tb[CTA_PROTOINFO_TCP_STATE-1]);
 		set_bit(ATTR_TCP_STATE, ct->head.set);
 	}
 
 	if (tb[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL-1]) {
 		memcpy(&ct->protoinfo.tcp.wscale[__DIR_ORIG],
 		       NFA_DATA(tb[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL-1]),
-		       sizeof(u_int8_t));
+		       sizeof(uint8_t));
 		set_bit(ATTR_TCP_WSCALE_ORIG, ct->head.set);
 	}
 
 	if (tb[CTA_PROTOINFO_TCP_WSCALE_REPLY-1]) {
 		memcpy(&ct->protoinfo.tcp.wscale[__DIR_REPL],
 		       NFA_DATA(tb[CTA_PROTOINFO_TCP_WSCALE_REPLY-1]),
-		       sizeof(u_int8_t));
+		       sizeof(uint8_t));
 		set_bit(ATTR_TCP_WSCALE_REPL, ct->head.set);
 	}
 
@@ -244,19 +244,19 @@ static void __parse_protoinfo_sctp(const struct nfattr *attr,
 
 	if (tb[CTA_PROTOINFO_SCTP_STATE-1]) {
                 ct->protoinfo.sctp.state =
-                        *(u_int8_t *)NFA_DATA(tb[CTA_PROTOINFO_SCTP_STATE-1]);
+                        *(uint8_t *)NFA_DATA(tb[CTA_PROTOINFO_SCTP_STATE-1]);
 		set_bit(ATTR_SCTP_STATE, ct->head.set);
 	}
 
 	if (tb[CTA_PROTOINFO_SCTP_VTAG_ORIGINAL-1]) {
 		ct->protoinfo.sctp.vtag[__DIR_ORIG] = 
-			ntohl(*(u_int32_t *)NFA_DATA(tb[CTA_PROTOINFO_SCTP_VTAG_ORIGINAL-1]));
+			ntohl(*(uint32_t *)NFA_DATA(tb[CTA_PROTOINFO_SCTP_VTAG_ORIGINAL-1]));
 		set_bit(ATTR_SCTP_VTAG_ORIG, ct->head.set);
 	}
 
 	if (tb[CTA_PROTOINFO_SCTP_VTAG_REPLY-1]) {
 		ct->protoinfo.sctp.vtag[__DIR_REPL] = 
-			ntohl(*(u_int32_t *)NFA_DATA(tb[CTA_PROTOINFO_SCTP_VTAG_REPLY-1]));
+			ntohl(*(uint32_t *)NFA_DATA(tb[CTA_PROTOINFO_SCTP_VTAG_REPLY-1]));
 		set_bit(ATTR_SCTP_VTAG_REPL, ct->head.set);
 	}
 
@@ -271,16 +271,16 @@ static void __parse_protoinfo_dccp(const struct nfattr *attr,
 
 	if (tb[CTA_PROTOINFO_DCCP_STATE-1]) {
                 ct->protoinfo.dccp.state =
-                        *(u_int8_t *)NFA_DATA(tb[CTA_PROTOINFO_DCCP_STATE-1]);
+                        *(uint8_t *)NFA_DATA(tb[CTA_PROTOINFO_DCCP_STATE-1]);
 		set_bit(ATTR_DCCP_STATE, ct->head.set);
 	}
 	if (tb[CTA_PROTOINFO_DCCP_ROLE-1]) {
                 ct->protoinfo.dccp.role =
-                        *(u_int8_t *)NFA_DATA(tb[CTA_PROTOINFO_DCCP_ROLE-1]);
+                        *(uint8_t *)NFA_DATA(tb[CTA_PROTOINFO_DCCP_ROLE-1]);
 		set_bit(ATTR_DCCP_ROLE, ct->head.set);
 	}
 	if (tb[CTA_PROTOINFO_DCCP_HANDSHAKE_SEQ-1]) {
-		u_int64_t tmp;
+		uint64_t tmp;
 		memcpy(&tmp,
 		       NFA_DATA(tb[CTA_PROTOINFO_DCCP_HANDSHAKE_SEQ-1]),
 		       sizeof(tmp));
@@ -317,11 +317,11 @@ static void __parse_counters(const struct nfattr *attr,
 
 		if (tb[CTA_COUNTERS32_PACKETS-1])
 			ct->counters[dir].packets
-				= ntohl(*(u_int32_t *)
+				= ntohl(*(uint32_t *)
 					NFA_DATA(tb[CTA_COUNTERS32_PACKETS-1]));
 
 		if (tb[CTA_COUNTERS_PACKETS-1]) {
-			u_int64_t tmp;
+			uint64_t tmp;
 			memcpy(&tmp,
 			       NFA_DATA(tb[CTA_COUNTERS_PACKETS-1]),
 			       sizeof(tmp));
@@ -341,11 +341,11 @@ static void __parse_counters(const struct nfattr *attr,
 
 		if (tb[CTA_COUNTERS32_BYTES-1])
 			ct->counters[dir].bytes
-				= ntohl(*(u_int32_t *)
+				= ntohl(*(uint32_t *)
 					NFA_DATA(tb[CTA_COUNTERS32_BYTES-1]));
 
 		if (tb[CTA_COUNTERS_BYTES-1]) {
-			u_int64_t tmp;
+			uint64_t tmp;
 			memcpy(&tmp,
 			       NFA_DATA(tb[CTA_COUNTERS_BYTES-1]),
 			       sizeof(tmp));
@@ -372,7 +372,7 @@ __parse_nat_seq(const struct nfattr *attr, struct nf_conntrack *ct, int dir)
 
 	if (tb[CTA_NAT_SEQ_CORRECTION_POS-1]) {
 		ct->natseq[dir].correction_pos =
-			ntohl(*(u_int32_t *)NFA_DATA(tb[CTA_NAT_SEQ_CORRECTION_POS-1]));
+			ntohl(*(uint32_t *)NFA_DATA(tb[CTA_NAT_SEQ_CORRECTION_POS-1]));
 		switch(dir) {
 		case __DIR_ORIG:
 			set_bit(ATTR_ORIG_NAT_SEQ_CORRECTION_POS, ct->head.set);
@@ -385,7 +385,7 @@ __parse_nat_seq(const struct nfattr *attr, struct nf_conntrack *ct, int dir)
 					
 	if (tb[CTA_NAT_SEQ_OFFSET_BEFORE-1]) {
 		ct->natseq[dir].offset_before =
-		ntohl(*(u_int32_t *)NFA_DATA(tb[CTA_NAT_SEQ_OFFSET_BEFORE-1]));
+		ntohl(*(uint32_t *)NFA_DATA(tb[CTA_NAT_SEQ_OFFSET_BEFORE-1]));
 		switch(dir) {
 		case __DIR_ORIG:
 			set_bit(ATTR_ORIG_NAT_SEQ_OFFSET_BEFORE, ct->head.set);
@@ -398,7 +398,7 @@ __parse_nat_seq(const struct nfattr *attr, struct nf_conntrack *ct, int dir)
 
 	if (tb[CTA_NAT_SEQ_OFFSET_AFTER-1]) {
 		ct->natseq[dir].offset_after =
-		ntohl(*(u_int32_t *)NFA_DATA(tb[CTA_NAT_SEQ_OFFSET_AFTER-1]));
+		ntohl(*(uint32_t *)NFA_DATA(tb[CTA_NAT_SEQ_OFFSET_AFTER-1]));
 		switch(dir) {
 		case __DIR_ORIG:
 			set_bit(ATTR_ORIG_NAT_SEQ_OFFSET_AFTER, ct->head.set);
@@ -442,8 +442,8 @@ __parse_secctx(const struct nfattr *attr, struct nf_conntrack *ct)
 
 int __parse_message_type(const struct nlmsghdr *nlh)
 {
-	u_int16_t type = NFNL_MSG_TYPE(nlh->nlmsg_type);
-	u_int16_t flags = nlh->nlmsg_flags;
+	uint16_t type = NFNL_MSG_TYPE(nlh->nlmsg_type);
+	uint16_t flags = nlh->nlmsg_flags;
 	int ret = NFCT_T_UNKNOWN;
 
 	if (type == IPCTNL_MSG_CT_NEW) {
@@ -464,13 +464,13 @@ __parse_timestamp(const struct nfattr *attr, struct nf_conntrack *ct)
 
 	nfnl_parse_nested(tb, CTA_TIMESTAMP_MAX, attr);
 	if (tb[CTA_TIMESTAMP_START-1]) {
-		u_int64_t tmp;
+		uint64_t tmp;
 		memcpy(&tmp, NFA_DATA(tb[CTA_TIMESTAMP_START-1]), sizeof(tmp));
 		ct->timestamp.start = __be64_to_cpu(tmp);
 		set_bit(ATTR_TIMESTAMP_START, ct->head.set);
 	}
 	if (tb[CTA_TIMESTAMP_STOP-1]) {
-		u_int64_t tmp;
+		uint64_t tmp;
 		memcpy(&tmp, NFA_DATA(tb[CTA_TIMESTAMP_STOP-1]), sizeof(tmp));
 		ct->timestamp.stop = __be64_to_cpu(tmp);
 		set_bit(ATTR_TIMESTAMP_STOP, ct->head.set);
@@ -530,7 +530,7 @@ void __parse_conntrack(const struct nlmsghdr *nlh,
 		__parse_nat_seq(cda[CTA_NAT_SEQ_ADJ_REPLY-1], ct, __DIR_REPL);
 
 	if (cda[CTA_STATUS-1]) {
-		ct->status = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_STATUS-1]));
+		ct->status = ntohl(*(uint32_t *)NFA_DATA(cda[CTA_STATUS-1]));
 		set_bit(ATTR_STATUS, ct->head.set);
 	}
 
@@ -538,17 +538,17 @@ void __parse_conntrack(const struct nlmsghdr *nlh,
 		__parse_protoinfo(cda[CTA_PROTOINFO-1], ct);
 
 	if (cda[CTA_TIMEOUT-1]) {
-		ct->timeout = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_TIMEOUT-1]));
+		ct->timeout = ntohl(*(uint32_t *)NFA_DATA(cda[CTA_TIMEOUT-1]));
 		set_bit(ATTR_TIMEOUT, ct->head.set);
 	}
 	
 	if (cda[CTA_MARK-1]) {
-		ct->mark = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_MARK-1]));
+		ct->mark = ntohl(*(uint32_t *)NFA_DATA(cda[CTA_MARK-1]));
 		set_bit(ATTR_MARK, ct->head.set);
 	}
 
 	if (cda[CTA_SECMARK-1]) {
-		ct->secmark = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_SECMARK-1]));
+		ct->secmark = ntohl(*(uint32_t *)NFA_DATA(cda[CTA_SECMARK-1]));
 		set_bit(ATTR_SECMARK, ct->head.set);
 	}
 
@@ -559,12 +559,12 @@ void __parse_conntrack(const struct nlmsghdr *nlh,
 		__parse_counters(cda[CTA_COUNTERS_REPLY-1], ct, __DIR_REPL);
 
 	if (cda[CTA_USE-1]) {
-		ct->use = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_USE-1]));
+		ct->use = ntohl(*(uint32_t *)NFA_DATA(cda[CTA_USE-1]));
 		set_bit(ATTR_USE, ct->head.set);
 	}
 
 	if (cda[CTA_ID-1]) {
-		ct->id = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_ID-1]));
+		ct->id = ntohl(*(uint32_t *)NFA_DATA(cda[CTA_ID-1]));
 		set_bit(ATTR_ID, ct->head.set);
 	}
 
@@ -572,7 +572,7 @@ void __parse_conntrack(const struct nlmsghdr *nlh,
 		__parse_helper(cda[CTA_HELP-1], ct);
 
 	if (cda[CTA_ZONE-1]) {
-		ct->zone = ntohs(*(u_int16_t *)NFA_DATA(cda[CTA_ZONE-1]));
+		ct->zone = ntohs(*(uint16_t *)NFA_DATA(cda[CTA_ZONE-1]));
 		set_bit(ATTR_ZONE, ct->head.set);
 	}
 
diff --git a/src/conntrack/parse_mnl.c b/src/conntrack/parse_mnl.c
index 98b680b..5da9933 100644
--- a/src/conntrack/parse_mnl.c
+++ b/src/conntrack/parse_mnl.c
@@ -44,7 +44,7 @@ nfct_parse_ip_attr_cb(const struct nlattr *attr, void *data)
 
 static int
 nfct_parse_ip(const struct nlattr *attr, struct __nfct_tuple *tuple,
-	     const int dir, u_int32_t *set)
+	     const int dir, uint32_t *set)
 {
 	struct nlattr *tb[CTA_IP_MAX+1] = {};
 
@@ -147,7 +147,7 @@ nfct_parse_proto_attr_cb(const struct nlattr *attr, void *data)
 
 static int
 nfct_parse_proto(const struct nlattr *attr, struct __nfct_tuple *tuple,
-		const int dir, u_int32_t *set)
+		const int dir, uint32_t *set)
 {
 	struct nlattr *tb[CTA_PROTO_MAX+1] = {};
 
@@ -261,7 +261,7 @@ static int nfct_parse_tuple_attr_cb(const struct nlattr *attr, void *data)
 
 int
 nfct_parse_tuple(const struct nlattr *attr, struct __nfct_tuple *tuple,
-		int dir, u_int32_t *set)
+		int dir, uint32_t *set)
 {
 	struct nlattr *tb[CTA_TUPLE_MAX+1] = {};
 
diff --git a/src/conntrack/setter.c b/src/conntrack/setter.c
index 4dda6c9..c648a10 100644
--- a/src/conntrack/setter.c
+++ b/src/conntrack/setter.c
@@ -11,7 +11,7 @@
 #include <linux/icmp.h>
 #include <linux/icmpv6.h>
 
-static const u_int8_t invmap_icmp[] = {
+static const uint8_t invmap_icmp[] = {
 	[ICMP_ECHO]		= ICMP_ECHOREPLY + 1,
 	[ICMP_ECHOREPLY]	= ICMP_ECHO + 1,
 	[ICMP_TIMESTAMP]	= ICMP_TIMESTAMPREPLY + 1,
@@ -30,7 +30,7 @@ static const u_int8_t invmap_icmp[] = {
 #define ICMPV6_NI_REPLY 140
 #endif
 
-static const u_int8_t invmap_icmpv6[] = {
+static const uint8_t invmap_icmpv6[] = {
 	[ICMPV6_ECHO_REQUEST - 128]	= ICMPV6_ECHO_REPLY + 1,
 	[ICMPV6_ECHO_REPLY - 128]	= ICMPV6_ECHO_REQUEST + 1,
 	[ICMPV6_NI_QUERY - 128]		= ICMPV6_NI_QUERY + 1,
@@ -40,89 +40,89 @@ static const u_int8_t invmap_icmpv6[] = {
 static void
 set_attr_orig_ipv4_src(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->head.orig.src.v4 = *((u_int32_t *) value);
+	ct->head.orig.src.v4 = *((uint32_t *) value);
 }
 
 static void
 set_attr_orig_ipv4_dst(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->head.orig.dst.v4 = *((u_int32_t *) value);
+	ct->head.orig.dst.v4 = *((uint32_t *) value);
 }
 
 static void
 set_attr_repl_ipv4_src(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->repl.src.v4 = *((u_int32_t *) value);
+	ct->repl.src.v4 = *((uint32_t *) value);
 }
 
 static void
 set_attr_repl_ipv4_dst(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->repl.dst.v4 = *((u_int32_t *) value);
+	ct->repl.dst.v4 = *((uint32_t *) value);
 }
 
 static void
 set_attr_orig_ipv6_src(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	memcpy(&ct->head.orig.src.v6, value, sizeof(u_int32_t)*4);
+	memcpy(&ct->head.orig.src.v6, value, sizeof(uint32_t)*4);
 }
 
 static void
 set_attr_orig_ipv6_dst(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	memcpy(&ct->head.orig.dst.v6, value, sizeof(u_int32_t)*4);
+	memcpy(&ct->head.orig.dst.v6, value, sizeof(uint32_t)*4);
 }
 
 static void
 set_attr_repl_ipv6_src(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	memcpy(&ct->repl.src.v6, value, sizeof(u_int32_t)*4);
+	memcpy(&ct->repl.src.v6, value, sizeof(uint32_t)*4);
 }
 
 static void
 set_attr_repl_ipv6_dst(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	memcpy(&ct->repl.dst.v6, value, sizeof(u_int32_t)*4);
+	memcpy(&ct->repl.dst.v6, value, sizeof(uint32_t)*4);
 }
 
 static void
 set_attr_orig_port_src(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->head.orig.l4src.all = *((u_int16_t *) value);
+	ct->head.orig.l4src.all = *((uint16_t *) value);
 }
 
 static void
 set_attr_orig_port_dst(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->head.orig.l4dst.all = *((u_int16_t *) value);
+	ct->head.orig.l4dst.all = *((uint16_t *) value);
 }
 
 static void
 set_attr_repl_port_src(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->repl.l4src.all = *((u_int16_t *) value);
+	ct->repl.l4src.all = *((uint16_t *) value);
 }
 
 static void
 set_attr_repl_port_dst(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->repl.l4dst.all = *((u_int16_t *) value);
+	ct->repl.l4dst.all = *((uint16_t *) value);
 }
 
 static void
 set_attr_icmp_type(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	u_int8_t rtype;
+	uint8_t rtype;
 
-	ct->head.orig.l4dst.icmp.type = *((u_int8_t *) value);
+	ct->head.orig.l4dst.icmp.type = *((uint8_t *) value);
 
 	switch(ct->head.orig.l3protonum) {
 		case AF_INET:
-			rtype = invmap_icmp[*((u_int8_t *) value)];
+			rtype = invmap_icmp[*((uint8_t *) value)];
 			break;
 
 		case AF_INET6:
-			rtype = invmap_icmpv6[*((u_int8_t *) value) - 128];
+			rtype = invmap_icmpv6[*((uint8_t *) value) - 128];
 			break;
 
 		default:
@@ -139,225 +139,225 @@ set_attr_icmp_type(struct nf_conntrack *ct, const void *value, size_t len)
 static void
 set_attr_icmp_code(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->head.orig.l4dst.icmp.code = *((u_int8_t *) value);
-	ct->repl.l4dst.icmp.code = *((u_int8_t *) value);
+	ct->head.orig.l4dst.icmp.code = *((uint8_t *) value);
+	ct->repl.l4dst.icmp.code = *((uint8_t *) value);
 }
 
 static void
 set_attr_icmp_id(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->head.orig.l4src.icmp.id = *((u_int16_t *) value);
-	ct->repl.l4src.icmp.id = *((u_int16_t *) value);
+	ct->head.orig.l4src.icmp.id = *((uint16_t *) value);
+	ct->repl.l4src.icmp.id = *((uint16_t *) value);
 }
 
 static void
 set_attr_orig_l3proto(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->head.orig.l3protonum = *((u_int8_t *) value);
+	ct->head.orig.l3protonum = *((uint8_t *) value);
 }
 
 static void
 set_attr_repl_l3proto(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->repl.l3protonum = *((u_int8_t *) value);
+	ct->repl.l3protonum = *((uint8_t *) value);
 }
 
 static void
 set_attr_orig_l4proto(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->head.orig.protonum = *((u_int8_t *) value);
+	ct->head.orig.protonum = *((uint8_t *) value);
 }
 
 static void
 set_attr_repl_l4proto(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->repl.protonum = *((u_int8_t *) value);
+	ct->repl.protonum = *((uint8_t *) value);
 }
 
 static void
 set_attr_tcp_state(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->protoinfo.tcp.state = *((u_int8_t *) value);
+	ct->protoinfo.tcp.state = *((uint8_t *) value);
 }
 
 static void
 set_attr_tcp_flags_orig(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->protoinfo.tcp.flags[__DIR_ORIG].value = *((u_int8_t *) value);
+	ct->protoinfo.tcp.flags[__DIR_ORIG].value = *((uint8_t *) value);
 }
 
 static void
 set_attr_tcp_mask_orig(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->protoinfo.tcp.flags[__DIR_ORIG].mask = *((u_int8_t *) value);
+	ct->protoinfo.tcp.flags[__DIR_ORIG].mask = *((uint8_t *) value);
 }
 
 static void
 set_attr_tcp_flags_repl(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->protoinfo.tcp.flags[__DIR_REPL].value = *((u_int8_t *) value);
+	ct->protoinfo.tcp.flags[__DIR_REPL].value = *((uint8_t *) value);
 }
 
 static void
 set_attr_tcp_mask_repl(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->protoinfo.tcp.flags[__DIR_REPL].mask = *((u_int8_t *) value);
+	ct->protoinfo.tcp.flags[__DIR_REPL].mask = *((uint8_t *) value);
 }
 
 static void
 set_attr_sctp_state(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->protoinfo.sctp.state = *((u_int8_t *) value);
+	ct->protoinfo.sctp.state = *((uint8_t *) value);
 }
 
 static void
 set_attr_sctp_vtag_orig(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->protoinfo.sctp.vtag[__DIR_ORIG] = *((u_int32_t *) value);
+	ct->protoinfo.sctp.vtag[__DIR_ORIG] = *((uint32_t *) value);
 }
 
 static void
 set_attr_sctp_vtag_repl(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->protoinfo.sctp.vtag[__DIR_REPL] = *((u_int32_t *) value);
+	ct->protoinfo.sctp.vtag[__DIR_REPL] = *((uint32_t *) value);
 }
 
 static void
 set_attr_snat_ipv4(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->snat.min_ip = ct->snat.max_ip = *((u_int32_t *) value);
+	ct->snat.min_ip = ct->snat.max_ip = *((uint32_t *) value);
 }
 
 static void
 set_attr_dnat_ipv4(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->dnat.min_ip = ct->snat.max_ip = *((u_int32_t *) value);
+	ct->dnat.min_ip = ct->snat.max_ip = *((uint32_t *) value);
 }
 
 static void
 set_attr_snat_port(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->snat.l4min.all = ct->snat.l4max.all = *((u_int16_t *) value);
+	ct->snat.l4min.all = ct->snat.l4max.all = *((uint16_t *) value);
 }
 
 static void
 set_attr_dnat_port(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->dnat.l4min.all = ct->dnat.l4max.all = *((u_int16_t *) value);
+	ct->dnat.l4min.all = ct->dnat.l4max.all = *((uint16_t *) value);
 }
 
 static void
 set_attr_timeout(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->timeout = *((u_int32_t *) value);
+	ct->timeout = *((uint32_t *) value);
 }
 
 static void
 set_attr_mark(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->mark = *((u_int32_t *) value);
+	ct->mark = *((uint32_t *) value);
 }
 
 static void
 set_attr_secmark(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->secmark = *((u_int32_t *) value);
+	ct->secmark = *((uint32_t *) value);
 }
 
 static void
 set_attr_status(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->status = *((u_int32_t *) value);
+	ct->status = *((uint32_t *) value);
 }
 
 static void
 set_attr_id(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->id = *((u_int32_t *) value);
+	ct->id = *((uint32_t *) value);
 }
 
 static void
 set_attr_master_ipv4_src(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->master.src.v4 = *((u_int32_t *) value);
+	ct->master.src.v4 = *((uint32_t *) value);
 }
 
 static void
 set_attr_master_ipv4_dst(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->master.dst.v4 = *((u_int32_t *) value);
+	ct->master.dst.v4 = *((uint32_t *) value);
 }
 
 static void
 set_attr_master_ipv6_src(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	memcpy(&ct->master.src.v6, value, sizeof(u_int32_t)*4);
+	memcpy(&ct->master.src.v6, value, sizeof(uint32_t)*4);
 }
 
 static void
 set_attr_master_ipv6_dst(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	memcpy(&ct->master.dst.v6, value, sizeof(u_int32_t)*4);
+	memcpy(&ct->master.dst.v6, value, sizeof(uint32_t)*4);
 }
 
 static void
 set_attr_master_port_src(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->master.l4src.all = *((u_int16_t *) value);
+	ct->master.l4src.all = *((uint16_t *) value);
 }
 
 static void
 set_attr_master_port_dst(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->master.l4dst.all = *((u_int16_t *) value);
+	ct->master.l4dst.all = *((uint16_t *) value);
 }
 
 static void
 set_attr_master_l3proto(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->master.l3protonum = *((u_int8_t *) value);
+	ct->master.l3protonum = *((uint8_t *) value);
 }
 
 static void
 set_attr_master_l4proto(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->master.protonum = *((u_int8_t *) value);
+	ct->master.protonum = *((uint8_t *) value);
 }
 
 static void
 set_attr_orig_cor_pos(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->natseq[__DIR_ORIG].correction_pos = *((u_int32_t *) value);
+	ct->natseq[__DIR_ORIG].correction_pos = *((uint32_t *) value);
 }
 
 static void
 set_attr_orig_off_bfr(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->natseq[__DIR_ORIG].offset_before = *((u_int32_t *) value);
+	ct->natseq[__DIR_ORIG].offset_before = *((uint32_t *) value);
 }
 
 static void
 set_attr_orig_off_aft(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->natseq[__DIR_ORIG].offset_after = *((u_int32_t *) value);
+	ct->natseq[__DIR_ORIG].offset_after = *((uint32_t *) value);
 }
 
 static void
 set_attr_repl_cor_pos(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->natseq[__DIR_REPL].correction_pos = *((u_int32_t *) value);
+	ct->natseq[__DIR_REPL].correction_pos = *((uint32_t *) value);
 }
 
 static void
 set_attr_repl_off_bfr(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->natseq[__DIR_REPL].offset_before = *((u_int32_t *) value);
+	ct->natseq[__DIR_REPL].offset_before = *((uint32_t *) value);
 }
 
 static void
 set_attr_repl_off_aft(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->natseq[__DIR_REPL].offset_after = *((u_int32_t *) value);
+	ct->natseq[__DIR_REPL].offset_after = *((uint32_t *) value);
 }
 
 static void
@@ -370,38 +370,38 @@ set_attr_helper_name(struct nf_conntrack *ct, const void *value, size_t len)
 static void
 set_attr_dccp_state(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->protoinfo.dccp.state = *((u_int8_t *) value);
+	ct->protoinfo.dccp.state = *((uint8_t *) value);
 }
 
 static void
 set_attr_dccp_role(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->protoinfo.dccp.role = *((u_int8_t *) value);
+	ct->protoinfo.dccp.role = *((uint8_t *) value);
 }
 
 static void
 set_attr_dccp_handshake_seq(struct nf_conntrack *ct, const void *value,
 				size_t len)
 {
-	ct->protoinfo.dccp.handshake_seq = *((u_int64_t *) value);
+	ct->protoinfo.dccp.handshake_seq = *((uint64_t *) value);
 }
 
 static void
 set_attr_tcp_wscale_orig(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->protoinfo.tcp.wscale[__DIR_ORIG] = *((u_int8_t *) value);
+	ct->protoinfo.tcp.wscale[__DIR_ORIG] = *((uint8_t *) value);
 }
 
 static void
 set_attr_tcp_wscale_repl(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->protoinfo.tcp.wscale[__DIR_REPL] = *((u_int8_t *) value);
+	ct->protoinfo.tcp.wscale[__DIR_REPL] = *((uint8_t *) value);
 }
 
 static void
 set_attr_zone(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	ct->zone = *((u_int16_t *) value);
+	ct->zone = *((uint16_t *) value);
 }
 
 static void
diff --git a/src/conntrack/snprintf_xml.c b/src/conntrack/snprintf_xml.c
index 37f51b4..bf52362 100644
--- a/src/conntrack/snprintf_xml.c
+++ b/src/conntrack/snprintf_xml.c
@@ -53,12 +53,12 @@
  * </flow>
  */
 
-const char *__proto2str(u_int8_t protonum)
+const char *__proto2str(uint8_t protonum)
 {
 	return proto2str[protonum] ? proto2str[protonum] : "unknown";
 }
 
-const char *__l3proto2str(u_int8_t protonum)
+const char *__l3proto2str(uint8_t protonum)
 {
 	return l3proto2str[protonum] ? l3proto2str[protonum] : "unknown";
 }
diff --git a/src/expect/api.c b/src/expect/api.c
index a1dbbff..8ff20e2 100644
--- a/src/expect/api.c
+++ b/src/expect/api.c
@@ -329,7 +329,7 @@ void nfexp_set_attr(struct nf_expect *exp,
  */
 void nfexp_set_attr_u8(struct nf_expect *exp,
 		       const enum nf_expect_attr type, 
-		       u_int8_t value)
+		       uint8_t value)
 {
 	nfexp_set_attr(exp, type, &value);
 }
@@ -342,7 +342,7 @@ void nfexp_set_attr_u8(struct nf_expect *exp,
  */
 void nfexp_set_attr_u16(struct nf_expect *exp,
 			const enum nf_expect_attr type, 
-			u_int16_t value)
+			uint16_t value)
 {
 	nfexp_set_attr(exp, type, &value);
 }
@@ -355,7 +355,7 @@ void nfexp_set_attr_u16(struct nf_expect *exp,
  */
 void nfexp_set_attr_u32(struct nf_expect *exp,
 			const enum nf_expect_attr type, 
-			u_int32_t value)
+			uint32_t value)
 {
 	nfexp_set_attr(exp, type, &value);
 }
@@ -395,10 +395,10 @@ const void *nfexp_get_attr(const struct nf_expect *exp,
  * set, 0 is returned. In order to check if the attribute is set or not,
  * use nfexp_attr_is_set.
  */
-u_int8_t nfexp_get_attr_u8(const struct nf_expect *exp,
+uint8_t nfexp_get_attr_u8(const struct nf_expect *exp,
 			   const enum nf_expect_attr type)
 {
-	const u_int8_t *ret = nfexp_get_attr(exp, type);
+	const uint8_t *ret = nfexp_get_attr(exp, type);
 	return ret == NULL ? 0 : *ret;
 }
 
@@ -411,10 +411,10 @@ u_int8_t nfexp_get_attr_u8(const struct nf_expect *exp,
  * set, 0 is returned. In order to check if the attribute is set or not,
  * use nfexp_attr_is_set.
  */
-u_int16_t nfexp_get_attr_u16(const struct nf_expect *exp,
+uint16_t nfexp_get_attr_u16(const struct nf_expect *exp,
 			     const enum nf_expect_attr type)
 {
-	const u_int16_t *ret = nfexp_get_attr(exp, type);
+	const uint16_t *ret = nfexp_get_attr(exp, type);
 	return ret == NULL ? 0 : *ret;
 }
 
@@ -427,10 +427,10 @@ u_int16_t nfexp_get_attr_u16(const struct nf_expect *exp,
  * set, 0 is returned. In order to check if the attribute is set or not,
  * use nfexp_attr_is_set.
  */
-u_int32_t nfexp_get_attr_u32(const struct nf_expect *exp,
+uint32_t nfexp_get_attr_u32(const struct nf_expect *exp,
 			    const enum nf_expect_attr type)
 {
-	const u_int32_t *ret = nfexp_get_attr(exp, type);
+	const uint32_t *ret = nfexp_get_attr(exp, type);
 	return ret == NULL ? 0 : *ret;
 }
 
@@ -504,8 +504,8 @@ int nfexp_attr_unset(struct nf_expect *exp,
 int nfexp_build_expect(struct nfnl_subsys_handle *ssh,
 		       void *req,
 		       size_t size,
-		       u_int16_t type,
-		       u_int16_t flags,
+		       uint16_t type,
+		       uint16_t flags,
 		       const struct nf_expect *exp)
 {
 	assert(ssh != NULL);
@@ -521,7 +521,7 @@ __build_query_exp(struct nfnl_subsys_handle *ssh,
 		  const void *data, void *buffer, unsigned int size)
 {
 	struct nfnlhdr *req = buffer;
-	const u_int8_t *family = data;
+	const uint8_t *family = data;
 
 	assert(ssh != NULL);
 	assert(data != NULL);
@@ -580,7 +580,7 @@ __build_query_exp(struct nfnl_subsys_handle *ssh,
  * 	NFEXP_Q_FLUSH
  * 	NFEXP_Q_DUMP
  * 
- * Pass a valid pointer to the protocol family (u_int8_t)
+ * Pass a valid pointer to the protocol family (uint8_t)
  * 
  * On success, 0 is returned. On error, -1 is returned and errno is set
  * appropiately.
diff --git a/src/expect/build.c b/src/expect/build.c
index d480fad..da59022 100644
--- a/src/expect/build.c
+++ b/src/expect/build.c
@@ -52,11 +52,11 @@ static void __build_expectfn(struct nfnlhdr *req,
 int __build_expect(struct nfnl_subsys_handle *ssh,
 		   struct nfnlhdr *req,
 		   size_t size,
-		   u_int16_t type,
-		   u_int16_t flags,
+		   uint16_t type,
+		   uint16_t flags,
 		   const struct nf_expect *exp)
 {
-	u_int8_t l3num;
+	uint8_t l3num;
 
 	if (test_bit(ATTR_ORIG_L3PROTO, exp->master.set))
 		l3num = exp->master.orig.l3protonum;
diff --git a/src/expect/parse.c b/src/expect/parse.c
index e71118b..9b944a6 100644
--- a/src/expect/parse.c
+++ b/src/expect/parse.c
@@ -11,8 +11,8 @@
 
 int __parse_expect_message_type(const struct nlmsghdr *nlh)
 {
-	u_int16_t type = NFNL_MSG_TYPE(nlh->nlmsg_type);
-	u_int16_t flags = nlh->nlmsg_flags;
+	uint16_t type = NFNL_MSG_TYPE(nlh->nlmsg_type);
+	uint16_t flags = nlh->nlmsg_flags;
 	int ret = NFCT_T_UNKNOWN;
 
 	if (type == IPCTNL_MSG_EXP_NEW) {
@@ -65,18 +65,18 @@ void __parse_expect(const struct nlmsghdr *nlh,
 	}
 	if (cda[CTA_EXPECT_TIMEOUT-1]) {
 		exp->timeout = 
-		      ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_EXPECT_TIMEOUT-1]));
+		      ntohl(*(uint32_t *)NFA_DATA(cda[CTA_EXPECT_TIMEOUT-1]));
 		set_bit(ATTR_EXP_TIMEOUT, exp->set);
 	}
 
 	if (cda[CTA_EXPECT_ZONE-1]) {
 		exp->zone =
-		      ntohs(*(u_int16_t *)NFA_DATA(cda[CTA_EXPECT_ZONE-1]));
+		      ntohs(*(uint16_t *)NFA_DATA(cda[CTA_EXPECT_ZONE-1]));
 		set_bit(ATTR_EXP_ZONE, exp->set);
 	}
 	if (cda[CTA_EXPECT_FLAGS-1]) {
 		exp->flags =
-		      ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_EXPECT_FLAGS-1]));
+		      ntohl(*(uint32_t *)NFA_DATA(cda[CTA_EXPECT_FLAGS-1]));
 		set_bit(ATTR_EXP_FLAGS, exp->set);
 	}
 	if (cda[CTA_EXPECT_HELP_NAME-1]) {
@@ -86,7 +86,7 @@ void __parse_expect(const struct nlmsghdr *nlh,
 	}
 	if (cda[CTA_EXPECT_CLASS-1]) {
 		exp->class =
-		      ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_EXPECT_CLASS-1]));
+		      ntohl(*(uint32_t *)NFA_DATA(cda[CTA_EXPECT_CLASS-1]));
 		set_bit(ATTR_EXP_CLASS, exp->set);
 	}
 	if (cda[CTA_EXPECT_NAT-1]) {
@@ -107,7 +107,7 @@ void __parse_expect(const struct nlmsghdr *nlh,
 		}
 		if (tb[CTA_EXPECT_NAT_DIR-1]) {
 			exp->nat_dir =
-			      ntohl(*((u_int32_t *)
+			      ntohl(*((uint32_t *)
 				NFA_DATA(tb[CTA_EXPECT_NAT_DIR-1])));
 			set_bit(ATTR_EXP_NAT_DIR, exp->set);
 		}
diff --git a/src/expect/setter.c b/src/expect/setter.c
index 2cf29c2..18c925a 100644
--- a/src/expect/setter.c
+++ b/src/expect/setter.c
@@ -26,22 +26,22 @@ static void set_exp_attr_mask(struct nf_expect *exp, const void *value)
 
 static void set_exp_attr_timeout(struct nf_expect *exp, const void *value)
 {
-	exp->timeout = *((u_int32_t *) value);
+	exp->timeout = *((uint32_t *) value);
 }
 
 static void set_exp_attr_zone(struct nf_expect *exp, const void *value)
 {
-	exp->zone = *((u_int16_t *) value);
+	exp->zone = *((uint16_t *) value);
 }
 
 static void set_exp_attr_flags(struct nf_expect *exp, const void *value)
 {
-	exp->flags = *((u_int32_t *) value);
+	exp->flags = *((uint32_t *) value);
 }
 
 static void set_exp_attr_class(struct nf_expect *exp, const void *value)
 {
-	exp->class = *((u_int32_t *) value);
+	exp->class = *((uint32_t *) value);
 }
 
 static void set_exp_attr_helper_name(struct nf_expect *exp, const void *value)
@@ -52,7 +52,7 @@ static void set_exp_attr_helper_name(struct nf_expect *exp, const void *value)
 
 static void set_exp_attr_nat_dir(struct nf_expect *exp, const void *value)
 {
-	exp->nat_dir = *((u_int32_t *) value);
+	exp->nat_dir = *((uint32_t *) value);
 }
 
 static void set_exp_attr_nat_tuple(struct nf_expect *exp, const void *value)
diff --git a/src/main.c b/src/main.c
index 82b2644..2cbf79e 100644
--- a/src/main.c
+++ b/src/main.c
@@ -13,7 +13,7 @@
 #include "internal/internal.h"
 
 struct nfct_handle *nfct_open_nfnl(struct nfnl_handle *nfnlh,
-				   u_int8_t subsys_id,
+				   uint8_t subsys_id,
 				   unsigned int subscriptions)
 {
 	struct nfct_handle *cth;
@@ -81,7 +81,7 @@ out_free:
  *
  * On error, NULL is returned and errno is explicitly set.
  */
-struct nfct_handle *nfct_open(u_int8_t subsys_id, unsigned subscriptions)
+struct nfct_handle *nfct_open(uint8_t subsys_id, unsigned subscriptions)
 {
 	struct nfnl_handle *nfnlh = nfnl_open();
 	struct nfct_handle *nfcth;
diff --git a/utils/conntrack_dump.c b/utils/conntrack_dump.c
index f1d63bb..8da5c8c 100644
--- a/utils/conntrack_dump.c
+++ b/utils/conntrack_dump.c
@@ -20,7 +20,7 @@ static int cb(enum nf_conntrack_msg_type type,
 int main(void)
 {
 	int ret;
-	u_int32_t family = AF_INET;
+	uint32_t family = AF_INET;
 	struct nfct_handle *h;
 
 	h = nfct_open(CONNTRACK, 0);
diff --git a/utils/conntrack_flush.c b/utils/conntrack_flush.c
index 36437e2..265c4ae 100644
--- a/utils/conntrack_flush.c
+++ b/utils/conntrack_flush.c
@@ -8,7 +8,7 @@
 int main(void)
 {
 	int ret;
-	u_int8_t family = AF_INET;
+	uint8_t family = AF_INET;
 	struct nfct_handle *h;
 
 	h = nfct_open(CONNTRACK, 0);
diff --git a/utils/expect_dump.c b/utils/expect_dump.c
index b227e1a..d80c4c8 100644
--- a/utils/expect_dump.c
+++ b/utils/expect_dump.c
@@ -20,7 +20,7 @@ static int cb(enum nf_conntrack_msg_type type,
 int main(void)
 {
 	int ret;
-	u_int8_t family = AF_INET;
+	uint8_t family = AF_INET;
 	struct nfct_handle *h;
 
 	h = nfct_open(EXPECT, 0);
diff --git a/utils/expect_flush.c b/utils/expect_flush.c
index 1ae69c9..8a4897f 100644
--- a/utils/expect_flush.c
+++ b/utils/expect_flush.c
@@ -8,7 +8,7 @@
 int main(void)
 {
 	int ret;
-	u_int8_t family = AF_INET;
+	uint8_t family = AF_INET;
 	struct nfct_handle *h;
 
 	h = nfct_open(EXPECT, 0);
-- 
2.3.6
