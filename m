Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D555C4708F
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Jun 2021 23:16:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82D44613EC
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Jun 2021 23:16:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbhFBXSG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Jun 2021 19:18:06 -0400
Received: from mail.netfilter.org ([217.70.188.207]:43126 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbhFBXSF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Jun 2021 19:18:05 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 0F2A764200
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Jun 2021 01:15:13 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH iptables 2/2] extensions: libxt_connlimit: add translation
Date:   Thu,  3 Jun 2021 01:16:13 +0200
Message-Id: <20210602231613.14702-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210602231613.14702-1-pablo@netfilter.org>
References: <20210602231613.14702-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds a translation for connlimit matches which requires
the definition of a set and the family context (either IPv4 or IPv6)
which is required to display the netmask accordingly.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 extensions/libxt_connlimit.c | 49 ++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/extensions/libxt_connlimit.c b/extensions/libxt_connlimit.c
index a569f86aa6b2..118faea560f7 100644
--- a/extensions/libxt_connlimit.c
+++ b/extensions/libxt_connlimit.c
@@ -2,6 +2,8 @@
 #include <netdb.h>
 #include <string.h>
 #include <xtables.h>
+#include <arpa/inet.h>
+
 #include <linux/netfilter/xt_connlimit.h>
 
 enum {
@@ -183,6 +185,51 @@ static void connlimit_save6(const void *ip, const struct xt_entry_match *match)
 	}
 }
 
+static int connlimit_xlate(struct xt_xlate *xl,
+			   const struct xt_xlate_mt_params *params)
+{
+	const struct xt_connlimit_info *info = (const void *)params->match->data;
+	static uint32_t connlimit_id;
+	char netmask[128] = {};
+	char addr[64] = {};
+	uint32_t mask;
+
+	switch (xt_xlate_get_family(xl)) {
+	case AF_INET:
+		mask = count_bits4(info->v4_mask);
+		if (mask != 32) {
+			struct in_addr *in = (struct in_addr *)&info->v4_mask;
+
+			inet_ntop(AF_INET, in, addr, sizeof(addr));
+			snprintf(netmask, sizeof(netmask), "and %s ", addr);
+		}
+		break;
+	case AF_INET6:
+		mask = count_bits6(info->v6_mask);
+		if (mask != 128) {
+			struct in6_addr *in6 = (struct in6_addr *)&info->v6_mask;
+
+			inet_ntop(AF_INET6, in6, addr, sizeof(addr));
+			snprintf(netmask, sizeof(netmask), "and %s ", addr);
+		}
+		break;
+	default:
+		return 0;
+	}
+
+	xt_xlate_set_add(xl, "connlimit%u { type ipv4_addr; flags dynamic; }",
+			 connlimit_id);
+	xt_xlate_rule_add(xl, "add @connlimit%u { %s %s %sct count %s%u }",
+			  connlimit_id++,
+			  xt_xlate_get_family(xl) == AF_INET ? "ip" : "ip6",
+			  info->flags & XT_CONNLIMIT_DADDR ? "daddr" : "saddr",
+			  netmask,
+			  info->flags & XT_CONNLIMIT_INVERT ? "" : "over ",
+			  info->limit);
+
+	return 1;
+}
+
 static struct xtables_match connlimit_mt_reg[] = {
 	{
 		.name          = "connlimit",
@@ -228,6 +275,7 @@ static struct xtables_match connlimit_mt_reg[] = {
 		.print         = connlimit_print4,
 		.save          = connlimit_save4,
 		.x6_options    = connlimit_opts,
+		.xlate         = connlimit_xlate,
 	},
 	{
 		.name          = "connlimit",
@@ -243,6 +291,7 @@ static struct xtables_match connlimit_mt_reg[] = {
 		.print         = connlimit_print6,
 		.save          = connlimit_save6,
 		.x6_options    = connlimit_opts,
+		.xlate         = connlimit_xlate,
 	},
 };
 
-- 
2.20.1

