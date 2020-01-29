Return-Path: <SRS0=bO8k=3S=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E28DC33CB7
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Jan 2020 09:56:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E47DA20708
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Jan 2020 09:56:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbgA2J42 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Jan 2020 04:56:28 -0500
Received: from fourcot.fr ([217.70.191.14]:49236 "EHLO olfflo.fourcot.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726091AbgA2J42 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Jan 2020 04:56:28 -0500
From:   Romain Bellan <romain.bellan@wifirst.fr>
To:     netfilter-devel@vger.kernel.org
Cc:     Romain Bellan <romain.bellan@wifirst.fr>,
        Florent Fourcot <florent.fourcot@wifirst.fr>
Subject: [PATCH libnftnl 1/2] Adding NFCT_FILTER_DUMP_TUPLE in filter_dump_attr, using kernel CTA_FILTER API
Date:   Wed, 29 Jan 2020 10:47:18 +0100
Message-Id: <20200129094719.670-1-romain.bellan@wifirst.fr>
X-Mailer: git-send-email 2.11.0
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Following kernel side new conntrack filtering API, this patch implements
userspace part. This patch:

 * Update headers to get new flag value from kernel
 * Use a conntrack struct to configure filtering
 * Set netlink flags according to values set in conntrack struct

Signed-off-by: Romain Bellan <romain.bellan@wifirst.fr>
Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
---
 include/internal/object.h                     |  1 +
 include/internal/prototypes.h                 |  2 +-
 .../libnetfilter_conntrack.h                  |  1 +
 .../linux_nfnetlink_conntrack.h               | 22 +++++
 src/conntrack/api.c                           |  2 +-
 src/conntrack/filter_dump.c                   | 98 ++++++++++++++++++-
 6 files changed, 120 insertions(+), 6 deletions(-)

diff --git a/include/internal/object.h b/include/internal/object.h
index 3f6904f..cd385b7 100644
--- a/include/internal/object.h
+++ b/include/internal/object.h
@@ -286,6 +286,7 @@ struct nfct_filter {
  */
 
 struct nfct_filter_dump {
+	struct nf_conntrack		ct;
 	struct nfct_filter_dump_mark	mark;
 	uint8_t				l3num;
 	uint32_t			set;
diff --git a/include/internal/prototypes.h b/include/internal/prototypes.h
index c0047b3..5e935f0 100644
--- a/include/internal/prototypes.h
+++ b/include/internal/prototypes.h
@@ -35,7 +35,7 @@ void __copy_fast(struct nf_conntrack *ct1, const struct nf_conntrack *ct);
 
 int __setup_netlink_socket_filter(int fd, struct nfct_filter *filter);
 
-void __build_filter_dump(struct nfnlhdr *req, size_t size, const struct nfct_filter_dump *filter_dump);
+int __build_filter_dump(struct nfnlhdr *req, size_t size, const struct nfct_filter_dump *filter_dump);
 
 int nfct_build_tuple(struct nlmsghdr *nlh, const struct __nfct_tuple *t, int type);
 int nfct_parse_tuple(const struct nlattr *attr, struct __nfct_tuple *tuple, int dir, uint32_t *set);
diff --git a/include/libnetfilter_conntrack/libnetfilter_conntrack.h b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
index c5c6b61..be31722 100644
--- a/include/libnetfilter_conntrack/libnetfilter_conntrack.h
+++ b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
@@ -545,6 +545,7 @@ struct nfct_filter_dump_mark {
 enum nfct_filter_dump_attr {
 	NFCT_FILTER_DUMP_MARK = 0,	/* struct nfct_filter_dump_mark */
 	NFCT_FILTER_DUMP_L3NUM,		/* uint8_t */
+	NFCT_FILTER_DUMP_TUPLE,
 	NFCT_FILTER_DUMP_MAX
 };
 
diff --git a/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h b/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
index aa45723..36ada55 100644
--- a/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
+++ b/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
@@ -58,6 +58,7 @@ enum ctattr_type {
 	CTA_LABELS,
 	CTA_LABELS_MASK,
 	CTA_SYNPROXY,
+	CTA_FILTER,
 	__CTA_MAX
 };
 #define CTA_MAX (__CTA_MAX - 1)
@@ -275,6 +276,27 @@ enum ctattr_expect_stats {
 };
 #define CTA_STATS_EXP_MAX (__CTA_STATS_EXP_MAX - 1)
 
+enum ctattr_filter {
+       CTA_FILTER_UNSPEC,
+       CTA_FILTER_ORIG_FLAGS,
+       CTA_FILTER_REPLY_FLAGS,
+       __CTA_FILTER_MAX
+};
+#define CTA_FILTER_MAX (__CTA_FILTER_MAX - 1)
+
+#define CTA_FILTER_FLAG_CTA_IP_SRC             (1 << 0)
+#define CTA_FILTER_FLAG_CTA_IP_DST             (1 << 1)
+#define CTA_FILTER_FLAG_CTA_TUPLE_ZONE         (1 << 2)
+#define CTA_FILTER_FLAG_CTA_PROTO_NUM          (1 << 3)
+#define CTA_FILTER_FLAG_CTA_PROTO_SRC_PORT     (1 << 4)
+#define CTA_FILTER_FLAG_CTA_PROTO_DST_PORT     (1 << 5)
+#define CTA_FILTER_FLAG_CTA_PROTO_ICMP_TYPE    (1 << 6)
+#define CTA_FILTER_FLAG_CTA_PROTO_ICMP_CODE    (1 << 7)
+#define CTA_FILTER_FLAG_CTA_PROTO_ICMP_ID      (1 << 8)
+#define CTA_FILTER_FLAG_CTA_PROTO_ICMPV6_TYPE	(1 << 9)
+#define CTA_FILTER_FLAG_CTA_PROTO_ICMPV6_CODE	(1 << 10)
+#define CTA_FILTER_FLAG_CTA_PROTO_ICMPV6_ID	(1 << 11)
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/src/conntrack/api.c b/src/conntrack/api.c
index ffa5216..d03e18f 100644
--- a/src/conntrack/api.c
+++ b/src/conntrack/api.c
@@ -845,7 +845,7 @@ __build_query_ct(struct nfnl_subsys_handle *ssh,
 	case NFCT_Q_DUMP_FILTER:
 		nfct_fill_hdr(req, IPCTNL_MSG_CT_GET, NLM_F_DUMP, AF_UNSPEC,
 			      NFNETLINK_V0);
-		__build_filter_dump(req, size, data);
+		assert(__build_filter_dump(req, size, data) == 0);
 		break;
 	case NFCT_Q_DUMP_FILTER_RESET:
 		nfct_fill_hdr(req, IPCTNL_MSG_CT_GET_CTRZERO, NLM_F_DUMP,
diff --git a/src/conntrack/filter_dump.c b/src/conntrack/filter_dump.c
index 158b4cb..70249fc 100644
--- a/src/conntrack/filter_dump.c
+++ b/src/conntrack/filter_dump.c
@@ -7,6 +7,8 @@
  * (at your option) any later version.
  */
 
+#include <libmnl/libmnl.h>
+
 #include "internal/internal.h"
 
 static void
@@ -26,22 +28,110 @@ set_filter_dump_attr_family(struct nfct_filter_dump *filter_dump,
 	filter_dump->l3num = *((uint8_t *)value);
 }
 
+static void
+set_filter_dump_attr_tuple(struct nfct_filter_dump *filter_dump,
+			   const void *value)
+{
+	memcpy(&filter_dump->ct, value, sizeof(struct nf_conntrack));
+}
+
 const set_filter_dump_attr set_filter_dump_attr_array[NFCT_FILTER_DUMP_MAX] = {
 	[NFCT_FILTER_DUMP_MARK]		= set_filter_dump_attr_mark,
 	[NFCT_FILTER_DUMP_L3NUM]	= set_filter_dump_attr_family,
+	[NFCT_FILTER_DUMP_TUPLE]	= set_filter_dump_attr_tuple,
 };
 
-void __build_filter_dump(struct nfnlhdr *req, size_t size,
-			 const struct nfct_filter_dump *filter_dump)
+uint32_t get_flags_from_ct(const struct nf_conntrack *ct, int family)
 {
+	uint32_t	tuple_flags = 0;
+
+	if (family == AF_INET)
+	{
+		if (test_bit(ATTR_ORIG_IPV4_SRC, ct->head.set))
+			tuple_flags |= CTA_FILTER_FLAG_CTA_IP_SRC;
+		if (test_bit(ATTR_ORIG_IPV4_DST, ct->head.set))
+			tuple_flags |= CTA_FILTER_FLAG_CTA_IP_DST;
+
+		if (test_bit(ATTR_ICMP_TYPE, ct->head.set))
+			tuple_flags |= CTA_FILTER_FLAG_CTA_PROTO_ICMP_TYPE;
+		if (test_bit(ATTR_ICMP_CODE, ct->head.set))
+			tuple_flags |= CTA_FILTER_FLAG_CTA_PROTO_ICMP_CODE;
+		if (test_bit(ATTR_ICMP_ID, ct->head.set))
+			tuple_flags |= CTA_FILTER_FLAG_CTA_PROTO_ICMP_ID;
+	}
+	else if (family == AF_INET6)
+	{
+		if (test_bit(ATTR_ORIG_IPV6_SRC, ct->head.set))
+			tuple_flags |= CTA_FILTER_FLAG_CTA_IP_SRC;
+		if (test_bit(ATTR_ORIG_IPV6_DST, ct->head.set))
+			tuple_flags |= CTA_FILTER_FLAG_CTA_IP_DST;
+
+		if (test_bit(ATTR_ICMP_TYPE, ct->head.set))
+			tuple_flags |= CTA_FILTER_FLAG_CTA_PROTO_ICMPV6_TYPE;
+		if (test_bit(ATTR_ICMP_CODE, ct->head.set))
+			tuple_flags |= CTA_FILTER_FLAG_CTA_PROTO_ICMPV6_CODE;
+		if (test_bit(ATTR_ICMP_ID, ct->head.set))
+			tuple_flags |= CTA_FILTER_FLAG_CTA_PROTO_ICMPV6_ID;
+	}
+
+	if (test_bit(ATTR_ORIG_ZONE, ct->head.set))
+		tuple_flags |= CTA_FILTER_FLAG_CTA_TUPLE_ZONE;
+
+	if (test_bit(ATTR_ORIG_L4PROTO, ct->head.set))
+		tuple_flags |= CTA_FILTER_FLAG_CTA_PROTO_NUM;
+	if (test_bit(ATTR_ORIG_PORT_SRC, ct->head.set))
+		tuple_flags |= CTA_FILTER_FLAG_CTA_PROTO_SRC_PORT;
+	if (test_bit(ATTR_ORIG_PORT_DST, ct->head.set))
+		tuple_flags |= CTA_FILTER_FLAG_CTA_PROTO_DST_PORT;
+
+	return tuple_flags;
+}
+
+int __build_filter_dump(struct nfnlhdr *req, size_t size,
+			const struct nfct_filter_dump *filter_dump)
+{
+	int ret;
+	struct nlattr *nest;
+	int l3num_changed = 0;
+
 	if (filter_dump->set & (1 << NFCT_FILTER_DUMP_MARK)) {
 		nfnl_addattr32(&req->nlh, size, CTA_MARK,
-				htonl(filter_dump->mark.val));
+			       htonl(filter_dump->mark.val));
 		nfnl_addattr32(&req->nlh, size, CTA_MARK_MASK,
-				htonl(filter_dump->mark.mask));
+			       htonl(filter_dump->mark.mask));
 	}
 	if (filter_dump->set & (1 << NFCT_FILTER_DUMP_L3NUM)) {
 		struct nfgenmsg *nfg = NLMSG_DATA(&req->nlh);
 		nfg->nfgen_family = filter_dump->l3num;
+		l3num_changed = 1;
+	}
+	if (filter_dump->set & (1 << NFCT_FILTER_DUMP_TUPLE)) {
+		const struct nf_conntrack *ct = &filter_dump->ct;
+		struct nfgenmsg *nfg = NLMSG_DATA(&req->nlh);
+
+		ret = nfct_nlmsg_build(&req->nlh, ct);
+		if (ret == -1)
+			return -1;
+
+		nest = mnl_attr_nest_start(&req->nlh, CTA_FILTER);
+		if (nest == NULL)
+			return -1;
+
+		if (test_bit(ATTR_ORIG_L3PROTO, ct->head.set))
+		{
+			if (l3num_changed && filter_dump->l3num !=
+			    ct->head.orig.l3protonum)
+				return -1;
+
+			nfg->nfgen_family = ct->head.orig.l3protonum;
+		}
+
+		mnl_attr_put_u32(&req->nlh, CTA_FILTER_ORIG_FLAGS,
+				 get_flags_from_ct(&filter_dump->ct,
+						   nfg->nfgen_family));
+		mnl_attr_put_u32(&req->nlh, CTA_FILTER_REPLY_FLAGS, 0);
+		mnl_attr_nest_end(&req->nlh, nest);
 	}
+
+	return 0;
 }
-- 
2.20.1

