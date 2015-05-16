From: Felix Janda <felix.janda@posteo.de>
Subject: [conntrack-tools PATCH 3/6] include: Use stdint types
Date: Sat, 16 May 2015 11:38:53 +0200
Message-ID: <20150516092807.GE14201@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:59653 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339AbbEPJjZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 May 2015 05:39:25 -0400
Received: from dovecot03.posteo.de (unknown [185.67.36.28])
	by mx02.posteo.de (Postfix) with ESMTPS id 4028525A3DFA
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 11:39:23 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3lphQL6xWbz5vN7
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 11:39:22 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 extensions/libct_proto_dccp.c    |  2 +-
 extensions/libct_proto_gre.c     |  2 +-
 extensions/libct_proto_icmp.c    |  4 ++--
 extensions/libct_proto_icmpv6.c  |  4 ++--
 extensions/libct_proto_sctp.c    |  4 ++--
 extensions/libct_proto_tcp.c     |  2 +-
 extensions/libct_proto_udp.c     |  2 +-
 extensions/libct_proto_udplite.c |  2 +-
 include/bitops.h                 | 14 +++++++-------
 include/helper.h                 |  2 +-
 src/filter.c                     |  4 ++--
 src/helpers/amanda.c             |  4 ++--
 src/helpers/ftp.c                |  2 +-
 src/helpers/ssdp.c               |  2 +-
 src/internal_bypass.c            |  4 ++--
 src/sync-notrack.c               |  2 +-
 16 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/extensions/libct_proto_dccp.c b/extensions/libct_proto_dccp.c
index f37ef68..f6258ad 100644
--- a/extensions/libct_proto_dccp.c
+++ b/extensions/libct_proto_dccp.c
@@ -118,7 +118,7 @@ static int parse_options(char c,
 			 unsigned int *flags)
 {
 	int i;
-	u_int16_t port;
+	uint16_t port;
 
 	switch(c) {
 	case 1:
diff --git a/extensions/libct_proto_gre.c b/extensions/libct_proto_gre.c
index 0274a37..2dc63d1 100644
--- a/extensions/libct_proto_gre.c
+++ b/extensions/libct_proto_gre.c
@@ -91,7 +91,7 @@ static int parse_options(char c,
 			 unsigned int *flags)
 {
 	switch(c) {
-	u_int16_t port;
+	uint16_t port;
 	case '1':
 		port = htons(strtoul(optarg, NULL, 0));
 		nfct_set_attr_u16(ct, ATTR_ORIG_PORT_SRC, port);
diff --git a/extensions/libct_proto_icmp.c b/extensions/libct_proto_icmp.c
index d04397f..2ce1c65 100644
--- a/extensions/libct_proto_icmp.c
+++ b/extensions/libct_proto_icmp.c
@@ -72,8 +72,8 @@ static int parse(char c,
 		 unsigned int *flags)
 {
 	switch(c) {
-		u_int8_t tmp;
-		u_int16_t id;
+		uint8_t tmp;
+		uint16_t id;
 		case '1':
 			tmp = atoi(optarg);
 			nfct_set_attr_u8(ct, ATTR_ICMP_TYPE, tmp);
diff --git a/extensions/libct_proto_icmpv6.c b/extensions/libct_proto_icmpv6.c
index f8c2c68..18dd3e5 100644
--- a/extensions/libct_proto_icmpv6.c
+++ b/extensions/libct_proto_icmpv6.c
@@ -75,8 +75,8 @@ static int parse(char c,
 		 unsigned int *flags)
 {
 	switch(c) {
-		u_int8_t tmp;
-		u_int16_t id;
+		uint8_t tmp;
+		uint16_t id;
 		case '1':
 			tmp = atoi(optarg);
 			nfct_set_attr_u8(ct, ATTR_ICMP_TYPE, tmp);
diff --git a/extensions/libct_proto_sctp.c b/extensions/libct_proto_sctp.c
index 97042c3..04828bf 100644
--- a/extensions/libct_proto_sctp.c
+++ b/extensions/libct_proto_sctp.c
@@ -120,8 +120,8 @@ parse_options(char c, struct nf_conntrack *ct,
 	      unsigned int *flags)
 {
 	int i;
-	u_int16_t port;
-	u_int32_t vtag;
+	uint16_t port;
+	uint32_t vtag;
 
 	switch(c) {
 	case 1:
diff --git a/extensions/libct_proto_tcp.c b/extensions/libct_proto_tcp.c
index 65acd5a..8a37a55 100644
--- a/extensions/libct_proto_tcp.c
+++ b/extensions/libct_proto_tcp.c
@@ -106,7 +106,7 @@ static int parse_options(char c,
 			 unsigned int *flags)
 {
 	int i;
-	u_int16_t port;
+	uint16_t port;
 
 	switch(c) {
 	case '1':
diff --git a/extensions/libct_proto_udp.c b/extensions/libct_proto_udp.c
index 768304b..e30637c 100644
--- a/extensions/libct_proto_udp.c
+++ b/extensions/libct_proto_udp.c
@@ -87,7 +87,7 @@ static int parse_options(char c,
 			 unsigned int *flags)
 {
 	switch(c) {
-		u_int16_t port;
+		uint16_t port;
 		case '1':
 			port = htons(atoi(optarg));
 			nfct_set_attr_u16(ct, ATTR_ORIG_PORT_SRC, port);
diff --git a/extensions/libct_proto_udplite.c b/extensions/libct_proto_udplite.c
index 9b67bef..f46cef0 100644
--- a/extensions/libct_proto_udplite.c
+++ b/extensions/libct_proto_udplite.c
@@ -95,7 +95,7 @@ static int parse_options(char c,
 			 unsigned int *flags)
 {
 	switch(c) {
-	u_int16_t port;
+	uint16_t port;
 	case '1':
 		port = htons(atoi(optarg));
 		nfct_set_attr_u16(ct, ATTR_ORIG_PORT_SRC, port);
diff --git a/include/bitops.h b/include/bitops.h
index 51f4289..27fe58d 100644
--- a/include/bitops.h
+++ b/include/bitops.h
@@ -1,34 +1,34 @@
 #ifndef _BITOPS_H_
 #define _BITOPS_H_
 
-#include <stdlib.h>
+#include <stdint.h>
 
-static inline void set_bit_u32(int nr, u_int32_t *addr)
+static inline void set_bit_u32(int nr, uint32_t *addr)
 {
 	addr[nr >> 5] |= (1UL << (nr & 31));
 }
 
-static inline void unset_bit_u32(int nr, u_int32_t *addr)
+static inline void unset_bit_u32(int nr, uint32_t *addr)
 {
 	addr[nr >> 5] &= ~(1UL << (nr & 31));
 }
 
-static inline int test_bit_u32(int nr, const u_int32_t *addr)
+static inline int test_bit_u32(int nr, const uint32_t *addr)
 {
 	return ((1UL << (nr & 31)) & (addr[nr >> 5])) != 0;
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
 
-static inline int test_bit_u16(int nr, const u_int16_t *addr)
+static inline int test_bit_u16(int nr, const uint16_t *addr)
 {
 	return ((1UL << (nr & 15)) & (addr[nr >> 4])) != 0;
 }
diff --git a/include/helper.h b/include/helper.h
index bd69af6..f412e55 100644
--- a/include/helper.h
+++ b/include/helper.h
@@ -25,7 +25,7 @@ struct ctd_helper {
 	int			(*cb)(struct pkt_buff *pkt,
 				      uint32_t protoff,
 				      struct myct *ct,
-				      u_int32_t ctinfo);
+				      uint32_t ctinfo);
 
 	struct ctd_helper_policy policy[CTD_HELPER_POLICY_MAX];
 
diff --git a/src/filter.c b/src/filter.c
index 8fac71b..1ae2cc5 100644
--- a/src/filter.c
+++ b/src/filter.c
@@ -33,8 +33,8 @@
 
 struct ct_filter {
 	int logic[CT_FILTER_MAX];
-	u_int32_t l4protomap[IPPROTO_MAX/32];
-	u_int16_t statemap[IPPROTO_MAX];
+	uint32_t l4protomap[IPPROTO_MAX/32];
+	uint16_t statemap[IPPROTO_MAX];
 	struct hashtable *h;
 	struct hashtable *h6;
 	struct vector *v;
diff --git a/src/helpers/amanda.c b/src/helpers/amanda.c
index c0cf701..9e6c4e7 100644
--- a/src/helpers/amanda.c
+++ b/src/helpers/amanda.c
@@ -34,7 +34,7 @@ static int nat_amanda(struct pkt_buff *pkt, uint32_t ctinfo,
 		      struct nf_expect *exp)
 {
 	char buffer[sizeof("65535")];
-	u_int16_t port, initial_port;
+	uint16_t port, initial_port;
 	unsigned int ret;
 	const struct nf_conntrack *expected;
 	struct nf_conntrack *nat_tuple;
@@ -111,7 +111,7 @@ amanda_helper_cb(struct pkt_buff *pkt, uint32_t protoff,
 	struct nf_expect *exp;
 	char *data, *data_limit, *tmp;
 	unsigned int dataoff, i;
-	u_int16_t port, len;
+	uint16_t port, len;
 	int ret = NF_ACCEPT;
 	struct iphdr *iph;
 	union nfct_attr_grp_addr saddr, daddr;
diff --git a/src/helpers/ftp.c b/src/helpers/ftp.c
index 2c8dcd6..e7fe7f7 100644
--- a/src/helpers/ftp.c
+++ b/src/helpers/ftp.c
@@ -58,7 +58,7 @@ enum nf_ct_ftp_type {
 };
 
 static int
-get_ipv6_addr(const char *src, size_t dlen, struct in6_addr *dst, u_int8_t term)
+get_ipv6_addr(const char *src, size_t dlen, struct in6_addr *dst, uint8_t term)
 {
 	const char *end;
 	int ret = in6_pton(src, min_t(size_t, dlen, 0xffff),
diff --git a/src/helpers/ssdp.c b/src/helpers/ssdp.c
index 2713f23..bc41087 100644
--- a/src/helpers/ssdp.c
+++ b/src/helpers/ssdp.c
@@ -44,7 +44,7 @@ static int ssdp_helper_cb(struct pkt_buff *pkt, uint32_t protoff,
 	struct iphdr *net_hdr = (struct iphdr *)pktb_network_header(pkt);
 	int good_packet = 0;
 	struct nf_expect *exp;
-	u_int16_t port;
+	uint16_t port;
 	unsigned int dataoff;
 	void *sb_ptr;
 
diff --git a/src/internal_bypass.c b/src/internal_bypass.c
index ce2ae46..61988c7 100644
--- a/src/internal_bypass.c
+++ b/src/internal_bypass.c
@@ -49,7 +49,7 @@ internal_bypass_ct_dump_cb(enum nf_conntrack_msg_type type,
 static void internal_bypass_ct_dump(int fd, int type)
 {
 	struct nfct_handle *h;
-	u_int32_t family = AF_UNSPEC;
+	uint32_t family = AF_UNSPEC;
 	int ret;
 
 	h = nfct_open(CONFIG(netlink).subsys_id, 0);
@@ -180,7 +180,7 @@ internal_bypass_exp_dump_cb(enum nf_conntrack_msg_type type,
 static void internal_bypass_exp_dump(int fd, int type)
 {
 	struct nfct_handle *h;
-	u_int32_t family = AF_UNSPEC;
+	uint32_t family = AF_UNSPEC;
 	int ret;
 
 	h = nfct_open(CONFIG(netlink).subsys_id, 0);
diff --git a/src/sync-notrack.c b/src/sync-notrack.c
index a7df4e7..c810bbb 100644
--- a/src/sync-notrack.c
+++ b/src/sync-notrack.c
@@ -99,7 +99,7 @@ static int kernel_resync_cb(enum nf_conntrack_msg_type type,
 static void kernel_resync(void)
 {
 	struct nfct_handle *h;
-	u_int32_t family = AF_UNSPEC;
+	uint32_t family = AF_UNSPEC;
 	int ret;
 
 	h = nfct_open(CONFIG(netlink).subsys_id, 0);
-- 
2.3.6
