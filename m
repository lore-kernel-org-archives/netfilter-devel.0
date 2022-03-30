Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12ACCC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Mar 2022 15:59:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347877AbiC3QBO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Mar 2022 12:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343762AbiC3QBM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Mar 2022 12:01:12 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B7C423154
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Mar 2022 08:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=oq1B4RnFimMmZV6xVCfj4y8xYnJPAlVEBP/CGkTFH2o=; b=hjGmUF6Kpn9I7Gwu6EuoD1azFc
        HaVGe37x1TCDfVXHrf5nGujDLs8rouSdxDO1Q/jjcGKWkMkbS2nmOQBuhm+2Uz6vZzsS/C0gUpswY
        KMdR8MwqW8RkAL+f3fZOSSG+gzlX8hNq7o/ZgRs7tyRVuAdGNJORnUK4rKN8aL7EpqH9V7AyrFOnu
        J7iA9l/NX8hP7zRKmsOZaKHhSQ5OfMhy+taPJrrsbtc2k/WxqmFqNKbruV5gX3vKUcw4rTC36omXh
        iMs2OrDW2JjA6Sv1AG0ltbbLTrPQ2dOywdXeP9Sd+FTQNxqXqiuuqu387ypwrq9NO32MhAMnt6gmX
        vBVDEU8g==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nZajF-0004XX-Eq; Wed, 30 Mar 2022 17:59:25 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 5/9] extensions: ipt_DNAT: Combine xlate functions also
Date:   Wed, 30 Mar 2022 17:58:47 +0200
Message-Id: <20220330155851.13249-6-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330155851.13249-1-phil@nwl.cc>
References: <20220330155851.13249-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Make use of the new sprint_range() to introduce a common inner function
for both v1 and v2 xlate functions.

Also abort translation with shifted port ranges to not hide the missing
feature in nftables.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libipt_DNAT.c | 88 ++++++++++------------------------------
 1 file changed, 21 insertions(+), 67 deletions(-)

diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index b72437d5e92f2..9a179919f522d 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -266,47 +266,36 @@ static void DNAT_save(const void *ip, const struct xt_entry_target *target)
 	__DNAT_print(&range, true);
 }
 
-static void print_range_xlate(const struct nf_nat_ipv4_range *r,
-			struct xt_xlate *xl)
+static int __DNAT_xlate(struct xt_xlate *xl, const struct nf_nat_range2 *r)
 {
-	if (r->flags & NF_NAT_RANGE_MAP_IPS) {
-		struct in_addr a;
+	char *range_str = sprint_range(r);
+	const char *sep = " ";
 
-		a.s_addr = r->min_ip;
-		xt_xlate_add(xl, "%s", xtables_ipaddr_to_numeric(&a));
-		if (r->max_ip != r->min_ip) {
-			a.s_addr = r->max_ip;
-			xt_xlate_add(xl, "-%s", xtables_ipaddr_to_numeric(&a));
-		}
+	/* shifted portmap ranges are not supported by nftables */
+	if (r->flags & NF_NAT_RANGE_PROTO_OFFSET)
+		return 0;
+
+	xt_xlate_add(xl, "dnat");
+	if (strlen(range_str))
+		xt_xlate_add(xl, " to %s", range_str);
+	if (r->flags & NF_NAT_RANGE_PROTO_RANDOM) {
+		xt_xlate_add(xl, "%srandom", sep);
+		sep = ",";
 	}
-	if (r->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
-		xt_xlate_add(xl, ":%hu", ntohs(r->min.tcp.port));
-		if (r->max.tcp.port != r->min.tcp.port)
-			xt_xlate_add(xl, "-%hu", ntohs(r->max.tcp.port));
+	if (r->flags & NF_NAT_RANGE_PERSISTENT) {
+		xt_xlate_add(xl, "%spersistent", sep);
+		sep = ",";
 	}
+	return 1;
 }
 
 static int DNAT_xlate(struct xt_xlate *xl,
 		      const struct xt_xlate_tg_params *params)
 {
-	const struct nf_nat_ipv4_multi_range_compat *mr =
-			(const void *)params->target->data;
-	bool sep_need = false;
-	const char *sep = " ";
-
-	xt_xlate_add(xl, "dnat to ");
-	print_range_xlate(mr->range, xl);
-	if (mr->range->flags & NF_NAT_RANGE_PROTO_RANDOM) {
-		xt_xlate_add(xl, " random");
-		sep_need = true;
-	}
-	if (mr->range->flags & NF_NAT_RANGE_PERSISTENT) {
-		if (sep_need)
-			sep = ",";
-		xt_xlate_add(xl, "%spersistent", sep);
-	}
+	struct nf_nat_range2 range =
+		RANGE2_INIT_FROM_IPV4_MRC(params->target->data);
 
-	return 1;
+	return __DNAT_xlate(xl, &range);
 }
 
 static void DNAT_parse_v2(struct xt_option_call *cb)
@@ -336,45 +325,10 @@ static void DNAT_save_v2(const void *ip, const struct xt_entry_target *target)
 	__DNAT_print((const void *)target->data, true);
 }
 
-static void print_range_xlate_v2(const struct nf_nat_range2 *range,
-			      struct xt_xlate *xl)
-{
-	if (range->flags & NF_NAT_RANGE_MAP_IPS) {
-		xt_xlate_add(xl, "%s", xtables_ipaddr_to_numeric(&range->min_addr.in));
-		if (memcmp(&range->min_addr, &range->max_addr,
-			   sizeof(range->min_addr))) {
-			xt_xlate_add(xl, "-%s", xtables_ipaddr_to_numeric(&range->max_addr.in));
-		}
-	}
-	if (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
-		xt_xlate_add(xl, ":%hu", ntohs(range->min_proto.tcp.port));
-		if (range->max_proto.tcp.port != range->min_proto.tcp.port)
-			xt_xlate_add(xl, "-%hu", ntohs(range->max_proto.tcp.port));
-		if (range->flags & NF_NAT_RANGE_PROTO_OFFSET)
-			xt_xlate_add(xl, ";%hu", ntohs(range->base_proto.tcp.port));
-	}
-}
-
 static int DNAT_xlate_v2(struct xt_xlate *xl,
 		      const struct xt_xlate_tg_params *params)
 {
-	const struct nf_nat_range2 *range = (const void *)params->target->data;
-	bool sep_need = false;
-	const char *sep = " ";
-
-	xt_xlate_add(xl, "dnat to ");
-	print_range_xlate_v2(range, xl);
-	if (range->flags & NF_NAT_RANGE_PROTO_RANDOM) {
-		xt_xlate_add(xl, " random");
-		sep_need = true;
-	}
-	if (range->flags & NF_NAT_RANGE_PERSISTENT) {
-		if (sep_need)
-			sep = ",";
-		xt_xlate_add(xl, "%spersistent", sep);
-	}
-
-	return 1;
+	return __DNAT_xlate(xl, (const void *)params->target->data);
 }
 
 static struct xtables_target dnat_tg_reg[] = {
-- 
2.34.1

