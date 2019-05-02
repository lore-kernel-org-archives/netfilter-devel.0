Return-Path: <SRS0=YpbV=TC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 129A0C43219
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 May 2019 12:13:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC9BB20645
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 May 2019 12:13:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbfEBMNq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 May 2019 08:13:46 -0400
Received: from mail.us.es ([193.147.175.20]:60250 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726285AbfEBMNq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 May 2019 08:13:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 46CF32EFEAB
        for <netfilter-devel@vger.kernel.org>; Thu,  2 May 2019 14:13:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 34CFBDA702
        for <netfilter-devel@vger.kernel.org>; Thu,  2 May 2019 14:13:43 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 28FA7DA704; Thu,  2 May 2019 14:13:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EA9CCDA704
        for <netfilter-devel@vger.kernel.org>; Thu,  2 May 2019 14:13:40 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 02 May 2019 14:13:40 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D22D54265A5B
        for <netfilter-devel@vger.kernel.org>; Thu,  2 May 2019 14:13:40 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_conntrack 1/3] src: introduce abi_breakage()
Date:   Thu,  2 May 2019 14:13:35 +0200
Message-Id: <20190502121337.4880-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Changes in the netlink attributes layout is considered to be a kernel
ABI breakage, so report this immediately and stop execution, instead of
lazy error back to the client application, which cannot do anything with
this.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/internal/internal.h |  7 +++++++
 src/conntrack/parse_mnl.c   | 49 ++++++++++++++++++++++-----------------------
 src/expect/parse_mnl.c      |  8 ++++----
 src/main.c                  |  7 +++++++
 4 files changed, 42 insertions(+), 29 deletions(-)

diff --git a/include/internal/internal.h b/include/internal/internal.h
index 45b4aa7cc111..bb44e124082e 100644
--- a/include/internal/internal.h
+++ b/include/internal/internal.h
@@ -85,4 +85,11 @@ struct nf_ct_tcp_flags {
 #define NFCT_BITMASK_AND	0
 #define NFCT_BITMASK_OR		1
 
+#define __noreturn	__attribute__((__noreturn__))
+
+void __noreturn __abi_breakage(const char *file, int line, const char *reason);
+
+#define abi_breakage()	\
+	__abi_breakage(__FILE__, __LINE__, strerror(errno));
+
 #endif
diff --git a/src/conntrack/parse_mnl.c b/src/conntrack/parse_mnl.c
index 94a0de7caf31..515deffb1ca1 100644
--- a/src/conntrack/parse_mnl.c
+++ b/src/conntrack/parse_mnl.c
@@ -28,13 +28,13 @@ nfct_parse_ip_attr_cb(const struct nlattr *attr, void *data)
 	case CTA_IP_V4_SRC:
 	case CTA_IP_V4_DST:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
-			return MNL_CB_ERROR;
+			abi_breakage();
 		break;
 	case CTA_IP_V6_SRC:
 	case CTA_IP_V6_DST:
 		if (mnl_attr_validate2(attr, MNL_TYPE_UNSPEC,
 				       sizeof(struct in6_addr)) < 0) {
-			return MNL_CB_ERROR;
+			abi_breakage();
 		}
 		break;
 	}
@@ -130,7 +130,7 @@ nfct_parse_proto_attr_cb(const struct nlattr *attr, void *data)
 	case CTA_PROTO_ICMP_ID:
 	case CTA_PROTO_ICMPV6_ID:
 		if (mnl_attr_validate(attr, MNL_TYPE_U16) < 0)
-			return MNL_CB_ERROR;
+			abi_breakage();
 		break;
 	case CTA_PROTO_NUM:
 	case CTA_PROTO_ICMP_TYPE:
@@ -138,7 +138,7 @@ nfct_parse_proto_attr_cb(const struct nlattr *attr, void *data)
 	case CTA_PROTO_ICMPV6_TYPE:
 	case CTA_PROTO_ICMPV6_CODE:
 		if (mnl_attr_validate(attr, MNL_TYPE_U8) < 0)
-			return MNL_CB_ERROR;
+			abi_breakage();
 		break;
 	}
 	tb[type] = attr;
@@ -252,11 +252,11 @@ static int nfct_parse_tuple_attr_cb(const struct nlattr *attr, void *data)
 	case CTA_TUPLE_IP:
 	case CTA_TUPLE_PROTO:
 		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
-			return MNL_CB_ERROR;
+			abi_breakage();
 		break;
 	case CTA_TUPLE_ZONE:
 		if (mnl_attr_validate(attr, MNL_TYPE_U16) < 0)
-			return MNL_CB_ERROR;
+			abi_breakage();
 		break;
 	}
 
@@ -312,14 +312,13 @@ nfct_parse_pinfo_tcp_attr_cb(const struct nlattr *attr, void *data)
 	case CTA_PROTOINFO_TCP_WSCALE_ORIGINAL:
 	case CTA_PROTOINFO_TCP_WSCALE_REPLY:
 		if (mnl_attr_validate(attr, MNL_TYPE_U8) < 0)
-			return MNL_CB_ERROR;
+			abi_breakage();
 		break;
 	case CTA_PROTOINFO_TCP_FLAGS_ORIGINAL:
 	case CTA_PROTOINFO_TCP_FLAGS_REPLY:
 		if (mnl_attr_validate2(attr, MNL_TYPE_UNSPEC,
-					sizeof(struct nf_ct_tcp_flags)) < 0) {
-			return MNL_CB_ERROR;
-		}
+					sizeof(struct nf_ct_tcp_flags)) < 0)
+			abi_breakage();
 		break;
 	}
 	tb[type] = attr;
@@ -385,12 +384,12 @@ nfct_parse_pinfo_sctp_attr_cb(const struct nlattr *attr, void *data)
 	switch(type) {
 	case CTA_PROTOINFO_SCTP_STATE:
 		if (mnl_attr_validate(attr, MNL_TYPE_U8) < 0)
-			return MNL_CB_ERROR;
+			abi_breakage();
 		break;
 	case CTA_PROTOINFO_SCTP_VTAG_ORIGINAL:
 	case CTA_PROTOINFO_SCTP_VTAG_REPLY:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
-			return MNL_CB_ERROR;
+			abi_breakage();
 		break;
 	}
 	tb[type] = attr;
@@ -439,11 +438,11 @@ nfct_parse_pinfo_dccp_attr_cb(const struct nlattr *attr, void *data)
 	case CTA_PROTOINFO_DCCP_STATE:
 	case CTA_PROTOINFO_DCCP_ROLE:
 		if (mnl_attr_validate(attr, MNL_TYPE_U8) < 0)
-			return MNL_CB_ERROR;
+			abi_breakage();
 		break;
 	case CTA_PROTOINFO_DCCP_HANDSHAKE_SEQ:
 		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0)
-			return MNL_CB_ERROR;
+			abi_breakage();
 		break;
 	}
 	tb[type] = attr;
@@ -489,7 +488,7 @@ nfct_parse_protoinfo_attr_cb(const struct nlattr *attr, void *data)
 	case CTA_PROTOINFO_SCTP:
 	case CTA_PROTOINFO_DCCP:
 		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
-			return MNL_CB_ERROR;
+			abi_breakage();
 		break;
 	}
 	tb[type] = attr;
@@ -528,12 +527,12 @@ static int nfct_parse_counters_attr_cb(const struct nlattr *attr, void *data)
 	case CTA_COUNTERS_PACKETS:
 	case CTA_COUNTERS_BYTES:
 		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0)
-			return MNL_CB_ERROR;
+			abi_breakage();
 		break;
 	case CTA_COUNTERS32_PACKETS:
 	case CTA_COUNTERS32_BYTES:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
-			return MNL_CB_ERROR;
+			abi_breakage();
 		break;
 	}
 	tb[type] = attr;
@@ -604,7 +603,7 @@ nfct_parse_nat_seq_attr_cb(const struct nlattr *attr, void *data)
 	case CTA_NAT_SEQ_OFFSET_BEFORE:
 	case CTA_NAT_SEQ_OFFSET_AFTER:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
-			return MNL_CB_ERROR;
+			abi_breakage();
 		break;
 	}
 	tb[type] = attr;
@@ -673,7 +672,7 @@ nfct_parse_helper_attr_cb(const struct nlattr *attr, void *data)
 	switch(type) {
 	case CTA_HELP_NAME:
 		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
-			return MNL_CB_ERROR;
+			abi_breakage();
 		break;
 	}
 	tb[type] = attr;
@@ -723,7 +722,7 @@ nfct_parse_secctx_attr_cb(const struct nlattr *attr, void *data)
 	switch(type) {
 	case CTA_SECCTX_NAME:
 		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
-			return MNL_CB_ERROR;
+			abi_breakage();
 		break;
 	}
 	tb[type] = attr;
@@ -761,7 +760,7 @@ nfct_parse_timestamp_attr_cb(const struct nlattr *attr, void *data)
 	case CTA_TIMESTAMP_START:
 	case CTA_TIMESTAMP_STOP:
 		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0)
-			return MNL_CB_ERROR;
+			abi_breakage();
 		break;
 	}
 	tb[type] = attr;
@@ -822,7 +821,7 @@ static int nfct_parse_synproxy_attr_cb(const struct nlattr *attr, void *data)
 	case CTA_SYNPROXY_ITS:
 	case CTA_SYNPROXY_TSOFF:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
-			return MNL_CB_ERROR;
+			abi_breakage();
 		break;
 	}
 	tb[type] = attr;
@@ -880,7 +879,7 @@ nfct_parse_conntrack_attr_cb(const struct nlattr *attr, void *data)
 	case CTA_SECCTX:
 	case CTA_TIMESTAMP:
 		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
-			return MNL_CB_ERROR;
+			abi_breakage();
 		break;
 	case CTA_STATUS:
 	case CTA_TIMEOUT:
@@ -889,11 +888,11 @@ nfct_parse_conntrack_attr_cb(const struct nlattr *attr, void *data)
 	case CTA_USE:
 	case CTA_ID:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
-			return MNL_CB_ERROR;
+			abi_breakage();
 		break;
 	case CTA_ZONE:
 		if (mnl_attr_validate(attr, MNL_TYPE_U16) < 0)
-			return MNL_CB_ERROR;
+			abi_breakage();
 		break;
 	case CTA_NAT_SRC:
 	case CTA_NAT_DST:
diff --git a/src/expect/parse_mnl.c b/src/expect/parse_mnl.c
index 741b46ef690e..69feef5379b0 100644
--- a/src/expect/parse_mnl.c
+++ b/src/expect/parse_mnl.c
@@ -26,21 +26,21 @@ static int nlmsg_parse_expection_attr_cb(const struct nlattr *attr, void *data)
 	case CTA_EXPECT_TUPLE:
 	case CTA_EXPECT_MASK:
 		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
-			return MNL_CB_ERROR;
+			abi_breakage();
 		break;
 	case CTA_EXPECT_TIMEOUT:
 	case CTA_EXPECT_FLAGS:
 	case CTA_EXPECT_ID:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
-			return MNL_CB_ERROR;
+			abi_breakage();
 		break;
 	case CTA_EXPECT_HELP_NAME:
 		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
-			return MNL_CB_ERROR;
+			abi_breakage();
 		break;
 	case CTA_EXPECT_ZONE:
 		if (mnl_attr_validate(attr, MNL_TYPE_U16) < 0)
-			return MNL_CB_ERROR;
+			abi_breakage();
 		break;
 	}
 	tb[type] = attr;
diff --git a/src/main.c b/src/main.c
index 2cbf79ee1e74..4011ad6fc7fc 100644
--- a/src/main.c
+++ b/src/main.c
@@ -154,3 +154,10 @@ const struct nfnl_handle *nfct_nfnlh(struct nfct_handle *cth)
 /**
  * @}
  */
+
+void __noreturn __abi_breakage(const char *file, int line, const char *reason)
+{
+	fprintf(stderr, "ctnetlink kernel ABI is broken, contact your vendor.\n"
+			"%s:%d reason: %s\n", file, line, reason);
+	exit(EXIT_FAILURE);
+}
-- 
2.11.0

