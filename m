From: Florian Westphal <fw@strlen.de>
Subject: [PATCH libnftables 2/3] expr: log: use real length when fetching attributes
Date: Fri, 13 Sep 2013 16:44:47 +0200
Message-ID: <1379083488-20752-2-git-send-email-fw@strlen.de>
References: <1379083488-20752-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58017 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757224Ab3IMOpG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Sep 2013 10:45:06 -0400
In-Reply-To: <1379083488-20752-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

NFTA_LOG_SNAPLEN is u32 and NFTA_LOG_QTHRESHOLD is u16.
Without this, netlink messages from kernel fail mnl_validate step when
QTHRESH or SNAPLEN was set.

Also, nft_rule_expr_log_get must update data_length, else 'nft list' doesn't
show log arguments (prefix, group ..) because the netlink message
decoding uses nft_rule_expr_get_u16/32 etc. which validate the length, too.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/expr/log.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/src/expr/log.c b/src/expr/log.c
index bbbd5b9..90fb32e 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -64,12 +64,16 @@ nft_rule_expr_log_get(const struct nft_rule_expr *e, uint16_t type,
 
 	switch(type) {
 	case NFT_EXPR_LOG_PREFIX:
+		*data_len = strlen(log->prefix)+1;
 		return log->prefix;
 	case NFT_EXPR_LOG_GROUP:
+		*data_len = sizeof(log->group);
 		return &log->group;
 	case NFT_EXPR_LOG_SNAPLEN:
+		*data_len = sizeof(log->snaplen);
 		return &log->snaplen;
 	case NFT_EXPR_LOG_QTHRESHOLD:
+		*data_len = sizeof(log->qthreshold);
 		return &log->qthreshold;
 	}
 	return NULL;
@@ -91,13 +95,13 @@ static int nft_rule_expr_log_cb(const struct nlattr *attr, void *data)
 		}
 		break;
 	case NFTA_LOG_GROUP:
-	case NFTA_LOG_SNAPLEN:
+	case NFTA_LOG_QTHRESHOLD:
 		if (mnl_attr_validate(attr, MNL_TYPE_U16) < 0) {
 			perror("mnl_attr_validate");
 			return MNL_CB_ERROR;
 		}
 		break;
-	case NFTA_LOG_QTHRESHOLD:
+	case NFTA_LOG_SNAPLEN:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
 			perror("mnl_attr_validate");
 			return MNL_CB_ERROR;
-- 
1.7.8.6

