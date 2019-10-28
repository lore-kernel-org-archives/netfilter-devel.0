Return-Path: <SRS0=tJiL=YV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32637CA9EC0
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Oct 2019 14:05:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F95621734
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Oct 2019 14:05:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730120AbfJ1OFe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Oct 2019 10:05:34 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:39922 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729004AbfJ1OFe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Oct 2019 10:05:34 -0400
Received: from localhost ([::1]:53012 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iP5eH-0000wO-0m; Mon, 28 Oct 2019 15:05:33 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 04/10] Merge CMD_* defines
Date:   Mon, 28 Oct 2019 15:04:25 +0100
Message-Id: <20191028140431.13882-5-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191028140431.13882-1-phil@nwl.cc>
References: <20191028140431.13882-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

They are mostly identical, just xtables-arp ones differ slightly. Though
since they are internal use only and their actual value doesn't matter
(as long as it's a distinct bit), they can be merged anyway.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/ip6tables.c   | 17 -----------------
 iptables/iptables.c    | 17 -----------------
 iptables/nft-shared.h  | 17 -----------------
 iptables/xshared.h     | 20 ++++++++++++++++++++
 iptables/xtables-arp.c | 20 --------------------
 iptables/xtables.c     |  2 --
 6 files changed, 20 insertions(+), 73 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index f4ccfc60de953..e48fdeb1248bd 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -52,23 +52,6 @@
 #define FALSE 0
 #endif
 
-#define CMD_NONE		0x0000U
-#define CMD_INSERT		0x0001U
-#define CMD_DELETE		0x0002U
-#define CMD_DELETE_NUM		0x0004U
-#define CMD_REPLACE		0x0008U
-#define CMD_APPEND		0x0010U
-#define CMD_LIST		0x0020U
-#define CMD_FLUSH		0x0040U
-#define CMD_ZERO		0x0080U
-#define CMD_NEW_CHAIN		0x0100U
-#define CMD_DELETE_CHAIN	0x0200U
-#define CMD_SET_POLICY		0x0400U
-#define CMD_RENAME_CHAIN	0x0800U
-#define CMD_LIST_RULES		0x1000U
-#define CMD_ZERO_NUM		0x2000U
-#define CMD_CHECK		0x4000U
-#define NUMBER_OF_CMD	16
 
 #define NUMBER_OF_OPT	ARRAY_SIZE(optflags)
 static const char optflags[]
diff --git a/iptables/iptables.c b/iptables/iptables.c
index df371f410a9c2..255b61b11ec89 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -48,23 +48,6 @@
 #define FALSE 0
 #endif
 
-#define CMD_NONE		0x0000U
-#define CMD_INSERT		0x0001U
-#define CMD_DELETE		0x0002U
-#define CMD_DELETE_NUM		0x0004U
-#define CMD_REPLACE		0x0008U
-#define CMD_APPEND		0x0010U
-#define CMD_LIST		0x0020U
-#define CMD_FLUSH		0x0040U
-#define CMD_ZERO		0x0080U
-#define CMD_NEW_CHAIN		0x0100U
-#define CMD_DELETE_CHAIN	0x0200U
-#define CMD_SET_POLICY		0x0400U
-#define CMD_RENAME_CHAIN	0x0800U
-#define CMD_LIST_RULES		0x1000U
-#define CMD_ZERO_NUM		0x2000U
-#define CMD_CHECK		0x4000U
-#define NUMBER_OF_CMD	16
 
 #define OPT_FRAGMENT    0x00800U
 #define NUMBER_OF_OPT	ARRAY_SIZE(optflags)
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 8b073b18fb0d9..e236a981119ac 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -199,23 +199,6 @@ struct xtables_args {
 	unsigned long long pcnt_cnt, bcnt_cnt;
 };
 
-#define CMD_NONE		0x0000U
-#define CMD_INSERT		0x0001U
-#define CMD_DELETE		0x0002U
-#define CMD_DELETE_NUM		0x0004U
-#define CMD_REPLACE		0x0008U
-#define CMD_APPEND		0x0010U
-#define CMD_LIST		0x0020U
-#define CMD_FLUSH		0x0040U
-#define CMD_ZERO		0x0080U
-#define CMD_NEW_CHAIN		0x0100U
-#define CMD_DELETE_CHAIN	0x0200U
-#define CMD_SET_POLICY		0x0400U
-#define CMD_RENAME_CHAIN	0x0800U
-#define CMD_LIST_RULES		0x1000U
-#define CMD_ZERO_NUM		0x2000U
-#define CMD_CHECK		0x4000U
-
 struct nft_xt_cmd_parse {
 	unsigned int			command;
 	unsigned int			rulenum;
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 85bbfa1250aa3..b0738b042e95a 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -31,6 +31,26 @@ enum {
 	OPT_COUNTERS    = 1 << 10,
 };
 
+enum {
+	CMD_NONE		= 0,
+	CMD_INSERT		= 1 << 0,
+	CMD_DELETE		= 1 << 1,
+	CMD_DELETE_NUM		= 1 << 2,
+	CMD_REPLACE		= 1 << 3,
+	CMD_APPEND		= 1 << 4,
+	CMD_LIST		= 1 << 5,
+	CMD_FLUSH		= 1 << 6,
+	CMD_ZERO		= 1 << 7,
+	CMD_NEW_CHAIN		= 1 << 8,
+	CMD_DELETE_CHAIN	= 1 << 9,
+	CMD_SET_POLICY		= 1 << 10,
+	CMD_RENAME_CHAIN	= 1 << 11,
+	CMD_LIST_RULES		= 1 << 12,
+	CMD_ZERO_NUM		= 1 << 13,
+	CMD_CHECK		= 1 << 14,
+};
+#define NUMBER_OF_CMD		16
+
 struct xtables_globals;
 struct xtables_rule_match;
 struct xtables_target;
diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index 79cc83d354fc5..88a7d534da4f1 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -62,26 +62,6 @@ typedef char arpt_chainlabel[32];
 #define FALSE 0
 #endif
 
-/* XXX: command defined by nft-shared.h do not overlap with these two */
-#undef CMD_CHECK
-#undef CMD_RENAME_CHAIN
-
-#define CMD_NONE		0x0000U
-#define CMD_INSERT		0x0001U
-#define CMD_DELETE		0x0002U
-#define CMD_DELETE_NUM		0x0004U
-#define CMD_REPLACE		0x0008U
-#define CMD_APPEND		0x0010U
-#define CMD_LIST		0x0020U
-#define CMD_FLUSH		0x0040U
-#define CMD_ZERO		0x0080U
-#define CMD_NEW_CHAIN		0x0100U
-#define CMD_DELETE_CHAIN	0x0200U
-#define CMD_SET_POLICY		0x0400U
-#define CMD_CHECK		0x0800U
-#define CMD_RENAME_CHAIN	0x1000U
-#define NUMBER_OF_CMD	13
-
 #define OPTION_OFFSET 256
 
 #define OPT_NONE	0x00000U
diff --git a/iptables/xtables.c b/iptables/xtables.c
index bb76e6a7a1ce8..805bd801fb060 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -50,8 +50,6 @@
 #define FALSE 0
 #endif
 
-#define NUMBER_OF_CMD	16
-
 #define OPT_FRAGMENT	0x00800U
 #define NUMBER_OF_OPT	ARRAY_SIZE(optflags)
 static const char optflags[]
-- 
2.23.0

