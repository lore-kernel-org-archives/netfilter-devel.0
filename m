From: valentina.giusti@bmw-carit.de
Subject: [PATCH 2/4] libnetfilter-acct: Introduce support for notifications
Date: Wed,  4 Sep 2013 14:05:31 +0200
Message-ID: <1378296333-19208-3-git-send-email-valentina.giusti@bmw-carit.de>
References: <1378296333-19208-1-git-send-email-valentina.giusti@bmw-carit.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	"David S. Miller" <davem@davemloft.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.bmw-carit.de ([62.245.222.98]:49598 "EHLO
	linuxmail.bmw-carit.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762496Ab3IDMFg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Sep 2013 08:05:36 -0400
In-Reply-To: <1378296333-19208-1-git-send-email-valentina.giusti@bmw-carit.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Valentina Giusti <valentina.giusti@bmw-carit.de>

Introduce support for notifications. Intervals can be configured as bytes
and packets or as time periods. When the intervals are configured in both
ways, it's also possible to specify a limit for the amount of
notifications based on accounted packets or bytes during a single period.

Signed-off-by: Valentina Giusti <valentina.giusti@bmw-carit.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Patrick McHardy <kaber@trash.net>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: "David S. Miller" <davem@davemloft.net>
---
 include/libnetfilter_acct/libnetfilter_acct.h |    5 +++
 include/linux/netfilter/nfnetlink_acct.h      |    6 ++++
 src/libnetfilter_acct.c                       |   45 +++++++++++++++++++++++++
 3 files changed, 56 insertions(+)

diff --git a/include/libnetfilter_acct/libnetfilter_acct.h b/include/libnetfilter_acct/libnetfilter_acct.h
index b00e366..b0a5bf6 100644
--- a/include/libnetfilter_acct/libnetfilter_acct.h
+++ b/include/libnetfilter_acct/libnetfilter_acct.h
@@ -14,6 +14,11 @@ enum nfacct_attr_type {
 	NFACCT_ATTR_NAME = 0,
 	NFACCT_ATTR_PKTS,
 	NFACCT_ATTR_BYTES,
+	NFACCT_ATTR_NOTIFY_PKTS,
+	NFACCT_ATTR_NOTIFY_P_RL, /* packets notification rate limit */
+	NFACCT_ATTR_NOTIFY_BYTES,
+	NFACCT_ATTR_NOTIFY_B_RL, /* bytes notification rate limit */
+	NFACCT_ATTR_NOTIFY_PERIOD,
 };
 
 struct nfacct *nfacct_alloc(void);
diff --git a/include/linux/netfilter/nfnetlink_acct.h b/include/linux/netfilter/nfnetlink_acct.h
index c7b6269..8125e57 100644
--- a/include/linux/netfilter/nfnetlink_acct.h
+++ b/include/linux/netfilter/nfnetlink_acct.h
@@ -10,6 +10,7 @@ enum nfnl_acct_msg_types {
 	NFNL_MSG_ACCT_GET,
 	NFNL_MSG_ACCT_GET_CTRZERO,
 	NFNL_MSG_ACCT_DEL,
+	NFNL_MSG_ACCT_NOTIFY,
 	NFNL_MSG_ACCT_MAX
 };
 
@@ -19,6 +20,11 @@ enum nfnl_acct_type {
 	NFACCT_PKTS,
 	NFACCT_BYTES,
 	NFACCT_USE,
+	NFACCT_NOTIFY_PKTS,
+	NFACCT_NOTIFY_P_RL,	/* packets notification rate limit */
+	NFACCT_NOTIFY_BYTES,
+	NFACCT_NOTIFY_B_RL,	/* bytes notification rate limit */
+	NFACCT_NOTIFY_PERIOD,
 	__NFACCT_MAX
 };
 #define NFACCT_MAX (__NFACCT_MAX - 1)
diff --git a/src/libnetfilter_acct.c b/src/libnetfilter_acct.c
index ba89e2d..4fb0d26 100644
--- a/src/libnetfilter_acct.c
+++ b/src/libnetfilter_acct.c
@@ -60,6 +60,11 @@ struct nfacct {
 	char		name[NFACCT_NAME_MAX];
 	uint64_t	pkts;
 	uint64_t	bytes;
+	uint32_t	notify_pkts;
+	uint32_t	notify_pkts_rl;
+	uint32_t	notify_bytes;
+	uint32_t	notify_bytes_rl;
+	uint32_t	notify_period;
 	uint32_t	bitset;
 };
 
@@ -114,6 +119,26 @@ nfacct_attr_set(struct nfacct *nfacct, enum nfacct_attr_type type,
 		nfacct->bytes = *((uint64_t *) data);
 		nfacct->bitset |= (1 << NFACCT_ATTR_BYTES);
 		break;
+	case NFACCT_ATTR_NOTIFY_PKTS:
+		nfacct->notify_pkts = *((uint32_t *) data);
+		nfacct->bitset |= (1 << NFACCT_ATTR_NOTIFY_PKTS);
+		break;
+	case NFACCT_ATTR_NOTIFY_P_RL:
+		nfacct->notify_pkts_rl = *((uint32_t *) data);
+		nfacct->bitset |= (1 << NFACCT_ATTR_NOTIFY_P_RL);
+		break;
+	case NFACCT_ATTR_NOTIFY_BYTES:
+		nfacct->notify_bytes = *((uint32_t *) data);
+		nfacct->bitset |= (1 << NFACCT_ATTR_NOTIFY_BYTES);
+		break;
+	case NFACCT_ATTR_NOTIFY_B_RL:
+		nfacct->notify_bytes_rl = *((uint32_t *) data);
+		nfacct->bitset |= (1 << NFACCT_ATTR_NOTIFY_B_RL);
+		break;
+	case NFACCT_ATTR_NOTIFY_PERIOD:
+		nfacct->notify_period = *((uint32_t *) data);
+		nfacct->bitset |= (1 << NFACCT_ATTR_NOTIFY_PERIOD);
+		break;
 	}
 }
 EXPORT_SYMBOL(nfacct_attr_set);
@@ -424,6 +449,26 @@ void nfacct_nlmsg_build_payload(struct nlmsghdr *nlh, struct nfacct *nfacct)
 
 	if (nfacct->bitset & (1 << NFACCT_ATTR_BYTES))
 		mnl_attr_put_u64(nlh, NFACCT_BYTES, htobe64(nfacct->bytes));
+
+	if (nfacct->bitset & (1 << NFACCT_ATTR_NOTIFY_PKTS))
+		mnl_attr_put_u32(nlh, NFACCT_NOTIFY_PKTS,
+				 htobe32(nfacct->notify_pkts));
+
+	if (nfacct->bitset & (1 << NFACCT_ATTR_NOTIFY_P_RL))
+		mnl_attr_put_u32(nlh, NFACCT_NOTIFY_P_RL,
+				 htobe32(nfacct->notify_pkts_rl));
+
+	if (nfacct->bitset & (1 << NFACCT_ATTR_NOTIFY_BYTES))
+		mnl_attr_put_u32(nlh, NFACCT_NOTIFY_BYTES,
+				 htobe32(nfacct->notify_bytes));
+
+	if (nfacct->bitset & (1 << NFACCT_ATTR_NOTIFY_B_RL))
+		mnl_attr_put_u32(nlh, NFACCT_NOTIFY_B_RL,
+				 htobe32(nfacct->notify_bytes_rl));
+
+	if (nfacct->bitset & (1 << NFACCT_ATTR_NOTIFY_PERIOD))
+		mnl_attr_put_u32(nlh, NFACCT_NOTIFY_PERIOD,
+				 htobe32(nfacct->notify_period));
 }
 EXPORT_SYMBOL(nfacct_nlmsg_build_payload);
 
-- 
1.7.10.4

