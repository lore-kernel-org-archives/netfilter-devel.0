From: mathieu.poirier@linaro.org
Subject: [RESEND PATCH 1/2] Extend accounting capabilities to support quotas
Date: Sun, 20 Apr 2014 18:58:15 -0600
Message-ID: <1398041896-8479-1-git-send-email-mathieu.poirier@linaro.org>
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	mathieu.poirier@linaro.org, john.stultz@linaro.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:57565 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaDUA6u (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Apr 2014 20:58:50 -0400
Received: by mail-pb0-f43.google.com with SMTP id um1so3185916pbc.2
        for <netfilter-devel@vger.kernel.org>; Sun, 20 Apr 2014 17:58:50 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Mathieu Poirier <mathieu.poirier@linaro.org>

The accounting framework already supports accounting at the
quota and byte level.  As such it is a natural extention to
add a ceiling limit to those metrics.

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 include/libnetfilter_acct/libnetfilter_acct.h |  2 +
 include/linux/netfilter/nfnetlink.h           |  4 ++
 include/linux/netfilter/nfnetlink_acct.h      |  9 ++++
 src/libnetfilter_acct.c                       | 67 +++++++++++++++++++++++++--
 4 files changed, 78 insertions(+), 4 deletions(-)

diff --git a/include/libnetfilter_acct/libnetfilter_acct.h b/include/libnetfilter_acct/libnetfilter_acct.h
index b00e366..c6ed858 100644
--- a/include/libnetfilter_acct/libnetfilter_acct.h
+++ b/include/libnetfilter_acct/libnetfilter_acct.h
@@ -14,6 +14,8 @@ enum nfacct_attr_type {
 	NFACCT_ATTR_NAME = 0,
 	NFACCT_ATTR_PKTS,
 	NFACCT_ATTR_BYTES,
+	NFACCT_ATTR_FLAGS,
+	NFACCT_ATTR_QUOTA,
 };
 
 struct nfacct *nfacct_alloc(void);
diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index 4a4efaf..d3e0ea8 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -18,6 +18,10 @@ enum nfnetlink_groups {
 #define NFNLGRP_CONNTRACK_EXP_UPDATE	NFNLGRP_CONNTRACK_EXP_UPDATE
 	NFNLGRP_CONNTRACK_EXP_DESTROY,
 #define NFNLGRP_CONNTRACK_EXP_DESTROY	NFNLGRP_CONNTRACK_EXP_DESTROY
+	NFNLGRP_NFTABLES,
+#define NFNLGRP_NFTABLES		NFNLGRP_NFTABLES
+	NFNLGRP_ACCT_QUOTA,
+#define NFNLGRP_ACCT_QUOTA		NFNLGRP_ACCT_QUOTA
 	__NFNLGRP_MAX,
 };
 #define NFNLGRP_MAX	(__NFNLGRP_MAX - 1)
diff --git a/include/linux/netfilter/nfnetlink_acct.h b/include/linux/netfilter/nfnetlink_acct.h
index c7b6269..6b8c935 100644
--- a/include/linux/netfilter/nfnetlink_acct.h
+++ b/include/linux/netfilter/nfnetlink_acct.h
@@ -10,15 +10,24 @@ enum nfnl_acct_msg_types {
 	NFNL_MSG_ACCT_GET,
 	NFNL_MSG_ACCT_GET_CTRZERO,
 	NFNL_MSG_ACCT_DEL,
+	NFNL_MSG_ACCT_OVERQUOTA,
 	NFNL_MSG_ACCT_MAX
 };
 
+enum nfnl_acct_flags {
+	NFACCT_F_QUOTA_PKTS     = (1 << 0),
+	NFACCT_F_QUOTA_BYTES    = (1 << 1),
+	NFACCT_F_OVERQUOTA      = (1 << 2), /* can't be set from userspace */
+};
+
 enum nfnl_acct_type {
 	NFACCT_UNSPEC,
 	NFACCT_NAME,
 	NFACCT_PKTS,
 	NFACCT_BYTES,
 	NFACCT_USE,
+	NFACCT_FLAGS,
+	NFACCT_QUOTA,
 	__NFACCT_MAX
 };
 #define NFACCT_MAX (__NFACCT_MAX - 1)
diff --git a/src/libnetfilter_acct.c b/src/libnetfilter_acct.c
index 77f58ce..0c1a758 100644
--- a/src/libnetfilter_acct.c
+++ b/src/libnetfilter_acct.c
@@ -61,6 +61,8 @@ struct nfacct {
 	uint64_t	pkts;
 	uint64_t	bytes;
 	uint32_t	bitset;
+	uint32_t	flags;
+	uint64_t	quota;
 };
 
 /**
@@ -114,6 +116,14 @@ nfacct_attr_set(struct nfacct *nfacct, enum nfacct_attr_type type,
 		nfacct->bytes = *((uint64_t *) data);
 		nfacct->bitset |= (1 << NFACCT_ATTR_BYTES);
 		break;
+	case NFACCT_ATTR_FLAGS:
+		nfacct->flags = *((uint32_t *) data);
+		nfacct->bitset |= (1 << NFACCT_ATTR_FLAGS);
+		break;
+	case NFACCT_ATTR_QUOTA:
+		nfacct->quota = *((uint64_t *) data);
+		nfacct->bitset |= (1 << NFACCT_ATTR_QUOTA);
+		break;
 	}
 }
 EXPORT_SYMBOL(nfacct_attr_set);
@@ -164,6 +174,12 @@ nfacct_attr_unset(struct nfacct *nfacct, enum nfacct_attr_type type)
 	case NFACCT_ATTR_BYTES:
 		nfacct->bitset &= ~(1 << NFACCT_ATTR_BYTES);
 		break;
+	case NFACCT_ATTR_FLAGS:
+		nfacct->bitset &= ~(1 << NFACCT_ATTR_FLAGS);
+		break;
+	case NFACCT_ATTR_QUOTA:
+		nfacct->bitset &= ~(1 << NFACCT_ATTR_QUOTA);
+		break;
 	}
 }
 EXPORT_SYMBOL(nfacct_attr_unset);
@@ -193,6 +209,14 @@ const void *nfacct_attr_get(struct nfacct *nfacct, enum nfacct_attr_type type)
 		if (nfacct->bitset & (1 << NFACCT_ATTR_BYTES))
 			ret = &nfacct->bytes;
 		break;
+	case NFACCT_ATTR_FLAGS:
+		if (nfacct->bitset & (1 << NFACCT_ATTR_FLAGS))
+			ret = &nfacct->flags;
+		break;
+	case NFACCT_ATTR_QUOTA:
+		if (nfacct->bitset & (1 << NFACCT_ATTR_QUOTA))
+			ret = &nfacct->quota;
+		break;
 	}
 	return ret;
 }
@@ -232,13 +256,35 @@ static int
 nfacct_snprintf_plain(char *buf, size_t rem, struct nfacct *nfacct,
 		      uint16_t flags)
 {
-	int ret;
+	int ret, temp;
+	char *walking_buf;
+
+	temp = rem;
+	walking_buf = buf;
 
 	if (flags & NFACCT_SNPRINTF_F_FULL) {
-		ret = snprintf(buf, rem,
-			"{ pkts = %.20"PRIu64", bytes = %.20"PRIu64" } = %s;",
+		ret = snprintf(walking_buf, temp,
+			"{ pkts = %.20"PRIu64", bytes = %.20"PRIu64"",
 			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_PKTS),
-			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES),
+			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES));
+
+		if (nfacct->flags) {
+			uint32_t mode;
+
+			mode = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_FLAGS);
+
+			walking_buf += ret;
+			temp -= ret;
+			ret = snprintf(walking_buf, temp,
+				", quota = %.20"PRIu64", mode = %s",
+				nfacct_attr_get_u64(nfacct, NFACCT_ATTR_QUOTA),
+				mode == NFACCT_F_QUOTA_BYTES ?
+				"byte" : "packet");
+		}
+
+		walking_buf += ret;
+		temp -= ret;
+		ret = snprintf(walking_buf, temp, " } = %s;",
 			nfacct_attr_get_str(nfacct, NFACCT_ATTR_NAME));
 	} else {
 		ret = snprintf(buf, rem, "%s\n",
@@ -424,6 +470,12 @@ void nfacct_nlmsg_build_payload(struct nlmsghdr *nlh, struct nfacct *nfacct)
 
 	if (nfacct->bitset & (1 << NFACCT_ATTR_BYTES))
 		mnl_attr_put_u64(nlh, NFACCT_BYTES, htobe64(nfacct->bytes));
+
+	if (nfacct->bitset & (1 << NFACCT_ATTR_FLAGS))
+		mnl_attr_put_u32(nlh, NFACCT_FLAGS, htobe32(nfacct->flags));
+
+	if (nfacct->bitset & (1 << NFACCT_ATTR_QUOTA))
+		mnl_attr_put_u64(nlh, NFACCT_QUOTA, htobe64(nfacct->quota));
 }
 EXPORT_SYMBOL(nfacct_nlmsg_build_payload);
 
@@ -479,6 +531,13 @@ nfacct_nlmsg_parse_payload(const struct nlmsghdr *nlh, struct nfacct *nfacct)
 	nfacct_attr_set_u64(nfacct, NFACCT_ATTR_BYTES,
 			    be64toh(mnl_attr_get_u64(tb[NFACCT_BYTES])));
 
+	if (tb[NFACCT_FLAGS] && tb[NFACCT_QUOTA]) {
+		uint32_t flags = be32toh(mnl_attr_get_u32(tb[NFACCT_FLAGS]));
+		nfacct_attr_set(nfacct, NFACCT_ATTR_FLAGS, &flags);
+		nfacct_attr_set_u64(nfacct, NFACCT_ATTR_QUOTA,
+			    be64toh(mnl_attr_get_u64(tb[NFACCT_QUOTA])));
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL(nfacct_nlmsg_parse_payload);
-- 
1.8.3.2

