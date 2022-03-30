Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C73F0C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Mar 2022 15:59:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348483AbiC3QBS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Mar 2022 12:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343762AbiC3QBR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Mar 2022 12:01:17 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50BF923154
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Mar 2022 08:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=cJDGn2snYgUOpWsDNq3tnBI9nef1oW2j7PBMlaU6Svo=; b=qVDqwPzhzB+1pw7X/FCf4RnUE0
        FRlWpUOgdPZCjxCnjcVJwZDoIHsU7urCiDBKf61LVPPsJHy7elPTnGQXfCFtQ1D3I/0UI+TKj7Y+3
        AojKglWe3QRYIpvvCOcV9ouOydm5riMpeFjfKp4OcsD37SHjo8ywq46/hnCdFi3x/P5CmVP7pj07V
        n3PO9M59mBGSK9FRdmX6eKLDbi9TZdmq0OsKd1FYX1G+Ts1rFgCl8A+Lu+lsoXtgYSbS70XrX1dhk
        /JMUpnw4Ewyj6Bn+X8E3EB78rtdlNPmE5V8pVHWW3HVOgndJMtTt3fXHmgBab/gToTdLTsmzO+JKz
        Fi/5KVLw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nZajK-0004Yn-OT; Wed, 30 Mar 2022 17:59:30 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 4/9] extensions: ipt_DNAT: Merge v1/v2 print/save code
Date:   Wed, 30 Mar 2022 17:58:46 +0200
Message-Id: <20220330155851.13249-5-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330155851.13249-1-phil@nwl.cc>
References: <20220330155851.13249-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Turn print_range() function into sprint_range() so it becomes more
versatile. Make it accept the new nf_nat_range2 data structure and
make v1 callers convert their nf_nat_ipv4_multi_range_compat structs
to that.
This allows to introduce an inner __DNAT_print() which acts for v1 and
v2 and prints either 'print' or 'save' syntax.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libipt_DNAT.c | 111 ++++++++++++++++-----------------------
 1 file changed, 46 insertions(+), 65 deletions(-)

diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index 2a7b1bc4ec0a6..b72437d5e92f2 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -9,6 +9,15 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter/nf_nat.h>
 
+#define TO_IPV4_MRC(ptr) ((const struct nf_nat_ipv4_multi_range_compat *)(ptr))
+#define RANGE2_INIT_FROM_IPV4_MRC(ptr) {			\
+	.flags		= TO_IPV4_MRC(ptr)->range[0].flags,	\
+	.min_addr.ip	= TO_IPV4_MRC(ptr)->range[0].min_ip,	\
+	.max_addr.ip	= TO_IPV4_MRC(ptr)->range[0].max_ip,	\
+	.min_proto	= TO_IPV4_MRC(ptr)->range[0].min,	\
+	.max_proto	= TO_IPV4_MRC(ptr)->range[0].max,	\
+};
+
 enum {
 	O_TO_DEST = 0,
 	O_RANDOM,
@@ -206,51 +215,55 @@ static void DNAT_fcheck(struct xt_fcheck_call *cb)
 			      "Shifted portmap ranges not supported with this kernel");
 }
 
-static void print_range(const struct nf_nat_ipv4_range *r)
+static char *sprint_range(const struct nf_nat_range2 *r)
 {
-	if (r->flags & NF_NAT_RANGE_MAP_IPS) {
-		struct in_addr a;
+	static char buf[INET_ADDRSTRLEN * 2 + 1 + 6 * 3];
 
-		a.s_addr = r->min_ip;
-		printf("%s", xtables_ipaddr_to_numeric(&a));
-		if (r->max_ip != r->min_ip) {
-			a.s_addr = r->max_ip;
-			printf("-%s", xtables_ipaddr_to_numeric(&a));
-		}
+	if (r->flags & NF_NAT_RANGE_MAP_IPS) {
+		sprintf(buf, "%s", xtables_ipaddr_to_numeric(&r->min_addr.in));
+		if (memcmp(&r->min_addr, &r->max_addr, sizeof(r->min_addr)))
+			sprintf(buf + strlen(buf), "-%s",
+				xtables_ipaddr_to_numeric(&r->max_addr.in));
+	} else {
+		buf[0] = '\0';
 	}
 	if (r->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
-		printf(":");
-		printf("%hu", ntohs(r->min.tcp.port));
-		if (r->max.tcp.port != r->min.tcp.port)
-			printf("-%hu", ntohs(r->max.tcp.port));
+		sprintf(buf + strlen(buf), ":%hu",
+			ntohs(r->min_proto.tcp.port));
+		if (r->max_proto.tcp.port != r->min_proto.tcp.port)
+			sprintf(buf + strlen(buf), "-%hu",
+				ntohs(r->max_proto.tcp.port));
+		if (r->flags & NF_NAT_RANGE_PROTO_OFFSET)
+			sprintf(buf + strlen(buf), "/%hu",
+				ntohs(r->base_proto.tcp.port));
 	}
+	return buf;
+}
+
+static void __DNAT_print(const struct nf_nat_range2 *r, bool save)
+{
+	const char *dashdash = save ? "--" : "";
+
+	printf(" %s%s", save ? "--to-destination " : "to:", sprint_range(r));
+	if (r->flags & NF_NAT_RANGE_PROTO_RANDOM)
+		printf(" %srandom", dashdash);
+	if (r->flags & NF_NAT_RANGE_PERSISTENT)
+		printf(" %spersistent", dashdash);
 }
 
 static void DNAT_print(const void *ip, const struct xt_entry_target *target,
                        int numeric)
 {
-	const struct nf_nat_ipv4_multi_range_compat *mr =
-				(const void *)target->data;
-
-	printf(" to:");
-	print_range(mr->range);
-	if (mr->range->flags & NF_NAT_RANGE_PROTO_RANDOM)
-		printf(" random");
-	if (mr->range->flags & NF_NAT_RANGE_PERSISTENT)
-		printf(" persistent");
+	struct nf_nat_range2 range = RANGE2_INIT_FROM_IPV4_MRC(target->data);
+
+	__DNAT_print(&range, false);
 }
 
 static void DNAT_save(const void *ip, const struct xt_entry_target *target)
 {
-	const struct nf_nat_ipv4_multi_range_compat *mr =
-				(const void *)target->data;
-
-	printf(" --to-destination ");
-	print_range(mr->range);
-	if (mr->range->flags & NF_NAT_RANGE_PROTO_RANDOM)
-		printf(" --random");
-	if (mr->range->flags & NF_NAT_RANGE_PERSISTENT)
-		printf(" --persistent");
+	struct nf_nat_range2 range = RANGE2_INIT_FROM_IPV4_MRC(target->data);
+
+	__DNAT_print(&range, true);
 }
 
 static void print_range_xlate(const struct nf_nat_ipv4_range *r,
@@ -312,47 +325,15 @@ static void DNAT_fcheck_v2(struct xt_fcheck_call *cb)
 		range->flags |= NF_NAT_RANGE_PROTO_RANDOM;
 }
 
-static void print_range_v2(const struct nf_nat_range2 *range)
-{
-	if (range->flags & NF_NAT_RANGE_MAP_IPS) {
-		printf("%s", xtables_ipaddr_to_numeric(&range->min_addr.in));
-		if (memcmp(&range->min_addr, &range->max_addr,
-			   sizeof(range->min_addr)))
-			printf("-%s", xtables_ipaddr_to_numeric(&range->max_addr.in));
-	}
-	if (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
-		printf(":");
-		printf("%hu", ntohs(range->min_proto.tcp.port));
-		if (range->max_proto.tcp.port != range->min_proto.tcp.port)
-			printf("-%hu", ntohs(range->max_proto.tcp.port));
-		if (range->flags & NF_NAT_RANGE_PROTO_OFFSET)
-			printf("/%hu", ntohs(range->base_proto.tcp.port));
-	}
-}
-
 static void DNAT_print_v2(const void *ip, const struct xt_entry_target *target,
                        int numeric)
 {
-	const struct nf_nat_range2 *range = (const void *)target->data;
-
-	printf(" to:");
-	print_range_v2(range);
-	if (range->flags & NF_NAT_RANGE_PROTO_RANDOM)
-		printf(" random");
-	if (range->flags & NF_NAT_RANGE_PERSISTENT)
-		printf(" persistent");
+	__DNAT_print((const void *)target->data, false);
 }
 
 static void DNAT_save_v2(const void *ip, const struct xt_entry_target *target)
 {
-	const struct nf_nat_range2 *range = (const void *)target->data;
-
-	printf(" --to-destination ");
-	print_range_v2(range);
-	if (range->flags & NF_NAT_RANGE_PROTO_RANDOM)
-		printf(" --random");
-	if (range->flags & NF_NAT_RANGE_PERSISTENT)
-		printf(" --persistent");
+	__DNAT_print((const void *)target->data, true);
 }
 
 static void print_range_xlate_v2(const struct nf_nat_range2 *range,
-- 
2.34.1

