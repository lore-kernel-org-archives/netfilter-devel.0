Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50AC6EDE9A6
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Sep 2023 11:17:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236323AbjINLRY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Sep 2023 07:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236413AbjINLRX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Sep 2023 07:17:23 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7994C1A5
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Sep 2023 04:17:19 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qgkLV-00033M-1P; Thu, 14 Sep 2023 13:17:17 +0200
From:   Florian Westphal <fw@strlen.de>
To:     netfilter-devel@vger.kernel.org
Cc:     Romain Bellan <romain.bellan@wifirst.fr>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 libnetfilter_conntrack 1/2] Adding NFCT_FILTER_DUMP_TUPLE in filter_dump_attr, using kernel CTA_FILTER API
Date:   Thu, 14 Sep 2023 13:16:52 +0200
Message-ID: <20230914111703.1145582-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Romain Bellan <romain.bellan@wifirst.fr>

Following kernel side new conntrack filtering API, this patch implements
userspace part. This patch:

 * Update headers to get new flag value from kernel
 * Use a conntrack struct to configure filtering
 * Set netlink flags according to values set in conntrack struct

Signed-off-by: Romain Bellan <romain.bellan@wifirst.fr>
Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 This is a rebase of the old patches to make this apply
 to current libnetfilter_conntrack.

 This supersedes:
  https://patchwork.ozlabs.org/project/netfilter-devel/patch/20200129094719.670-1-romain.bellan@wifirst.fr/

 It lacks a minor kernel patch to move some constants from
 nf_internals.h to uapi, but its not essential to have
 (The header is duplicated here).


 include/internal/object.h                     |  1 +
 include/internal/prototypes.h                 |  2 +-
 .../libnetfilter_conntrack.h                  |  1 +
 .../linux_nfnetlink_conntrack.h               | 13 ++++
 src/conntrack/api.c                           |  2 +-
 src/conntrack/build_mnl.c                     | 72 +++++++++++++++++++
 src/conntrack/filter_dump.c                   | 14 +++-
 7 files changed, 100 insertions(+), 5 deletions(-)

diff --git a/include/internal/object.h b/include/internal/object.h
index b919f5784df3..4cac4f163da6 100644
--- a/include/internal/object.h
+++ b/include/internal/object.h
@@ -288,6 +288,7 @@ struct nfct_filter {
  */
 
 struct nfct_filter_dump {
+	struct nf_conntrack		ct;
 	struct nfct_filter_dump_mark	mark;
 	struct nfct_filter_dump_mark	status;
 	uint8_t				l3num;
diff --git a/include/internal/prototypes.h b/include/internal/prototypes.h
index c0047b3b2f01..5e935f07c4ac 100644
--- a/include/internal/prototypes.h
+++ b/include/internal/prototypes.h
@@ -35,7 +35,7 @@ void __copy_fast(struct nf_conntrack *ct1, const struct nf_conntrack *ct);
 
 int __setup_netlink_socket_filter(int fd, struct nfct_filter *filter);
 
-void __build_filter_dump(struct nfnlhdr *req, size_t size, const struct nfct_filter_dump *filter_dump);
+int __build_filter_dump(struct nfnlhdr *req, size_t size, const struct nfct_filter_dump *filter_dump);
 
 int nfct_build_tuple(struct nlmsghdr *nlh, const struct __nfct_tuple *t, int type);
 int nfct_parse_tuple(const struct nlattr *attr, struct __nfct_tuple *tuple, int dir, uint32_t *set);
diff --git a/include/libnetfilter_conntrack/libnetfilter_conntrack.h b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
index e2294723cd51..76b5c27e2ecd 100644
--- a/include/libnetfilter_conntrack/libnetfilter_conntrack.h
+++ b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
@@ -547,6 +547,7 @@ enum nfct_filter_dump_attr {
 	NFCT_FILTER_DUMP_MARK = 0,	/* struct nfct_filter_dump_mark */
 	NFCT_FILTER_DUMP_L3NUM,		/* uint8_t */
 	NFCT_FILTER_DUMP_STATUS,	/* struct nfct_filter_dump_mark */
+	NFCT_FILTER_DUMP_TUPLE,
 	NFCT_FILTER_DUMP_MAX
 };
 
diff --git a/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h b/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
index a365cf5427ee..b8ffe02cba42 100644
--- a/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
+++ b/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
@@ -291,6 +291,19 @@ enum ctattr_filter {
 };
 #define CTA_FILTER_MAX (__CTA_FILTER_MAX - 1)
 
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
index 7f72d07f2e7f..d27bad2703d3 100644
--- a/src/conntrack/api.c
+++ b/src/conntrack/api.c
@@ -850,7 +850,7 @@ __build_query_ct(struct nfnl_subsys_handle *ssh,
 	case NFCT_Q_DUMP_FILTER:
 		nfct_fill_hdr(req, IPCTNL_MSG_CT_GET, NLM_F_DUMP, AF_UNSPEC,
 			      NFNETLINK_V0);
-		__build_filter_dump(req, size, data);
+		assert(__build_filter_dump(req, size, data) == 0);
 		break;
 	case NFCT_Q_DUMP_FILTER_RESET:
 		nfct_fill_hdr(req, IPCTNL_MSG_CT_GET_CTRZERO, NLM_F_DUMP,
diff --git a/src/conntrack/build_mnl.c b/src/conntrack/build_mnl.c
index af5d0e7ce290..eb9fcbf03d31 100644
--- a/src/conntrack/build_mnl.c
+++ b/src/conntrack/build_mnl.c
@@ -595,9 +595,53 @@ nfct_nlmsg_build(struct nlmsghdr *nlh, const struct nf_conntrack *ct)
 	return 0;
 }
 
+static uint32_t get_flags_from_ct(const struct nf_conntrack *ct, int family)
+{
+	uint32_t tuple_flags = 0;
+
+	if (family == AF_INET) {
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
+	} else if (family == AF_INET6) {
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
 int nfct_nlmsg_build_filter(struct nlmsghdr *nlh,
 			    const struct nfct_filter_dump *filter_dump)
 {
+	bool l3num_changed = false;
 	struct nfgenmsg *nfg;
 
 	if (filter_dump->set & (1 << NFCT_FILTER_DUMP_MARK)) {
@@ -607,12 +651,40 @@ int nfct_nlmsg_build_filter(struct nlmsghdr *nlh,
 	if (filter_dump->set & (1 << NFCT_FILTER_DUMP_L3NUM)) {
 		nfg = mnl_nlmsg_get_payload(nlh);
 		nfg->nfgen_family = filter_dump->l3num;
+		l3num_changed = true;
 	}
 	if (filter_dump->set & (1 << NFCT_FILTER_DUMP_STATUS)) {
 		mnl_attr_put_u32(nlh, CTA_STATUS, htonl(filter_dump->status.val));
 		mnl_attr_put_u32(nlh, CTA_STATUS_MASK,
 				 htonl(filter_dump->status.mask));
 	}
+	if (filter_dump->set & (1 << NFCT_FILTER_DUMP_TUPLE)) {
+		const struct nf_conntrack *ct = &filter_dump->ct;
+		struct nlattr *nest;
+		int ret;
+
+		ret = nfct_nlmsg_build(nlh, ct);
+		if (ret == -1)
+			return -1;
 
+		nest = mnl_attr_nest_start(nlh, CTA_FILTER);
+		if (nest == NULL)
+			return -1;
+
+		nfg = mnl_nlmsg_get_payload(nlh);
+
+		if (test_bit(ATTR_ORIG_L3PROTO, ct->head.set)) {
+			if (l3num_changed && filter_dump->l3num != ct->head.orig.l3protonum)
+				return -1;
+
+			nfg->nfgen_family = ct->head.orig.l3protonum;
+		}
+
+		mnl_attr_put_u32(nlh, CTA_FILTER_ORIG_FLAGS,
+				 get_flags_from_ct(&filter_dump->ct,
+						   nfg->nfgen_family));
+		mnl_attr_put_u32(nlh, CTA_FILTER_REPLY_FLAGS, 0);
+		mnl_attr_nest_end(nlh, nest);
+	}
 	return 0;
 }
diff --git a/src/conntrack/filter_dump.c b/src/conntrack/filter_dump.c
index 9bf92962441a..5723a44617da 100644
--- a/src/conntrack/filter_dump.c
+++ b/src/conntrack/filter_dump.c
@@ -37,14 +37,22 @@ set_filter_dump_attr_family(struct nfct_filter_dump *filter_dump,
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
 	[NFCT_FILTER_DUMP_STATUS]	= set_filter_dump_attr_status,
+	[NFCT_FILTER_DUMP_TUPLE]	= set_filter_dump_attr_tuple,
 };
 
-void __build_filter_dump(struct nfnlhdr *req, size_t size,
-			 const struct nfct_filter_dump *filter_dump)
+int __build_filter_dump(struct nfnlhdr *req, size_t size,
+			const struct nfct_filter_dump *filter_dump)
 {
-	nfct_nlmsg_build_filter(&req->nlh, filter_dump);
+	return nfct_nlmsg_build_filter(&req->nlh, filter_dump);
 }
-- 
2.41.0

