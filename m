Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 224E6C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Mar 2022 10:13:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234531AbiCaKOp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 31 Mar 2022 06:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234528AbiCaKOo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 31 Mar 2022 06:14:44 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF79A1EECC
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Mar 2022 03:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=cJDGn2snYgUOpWsDNq3tnBI9nef1oW2j7PBMlaU6Svo=; b=CXNmeJPXD/3EXHQn59aYvevuFB
        Q4IwMzlnRhtiHmeiHu0++klwpdqsnrrQjMv2GUp9e5zvwImlGMc5KAwDhNHz0zyb4RpxT07JOwRwm
        Ltyn//PROI+rRcioihV4vCg+TbKBQ3UamGTl9dBhjz6x5TK3EZN5VKapAW4UXfXgc8cYqoQpQYT/T
        hu/S+e/fLCMhVkmd+7uzCUFQmjsRF3vs0USPpPtKKos4x40QpaB5FSJrKawHrxxwyTczwk6ro7V5+
        VxY3NNgPzyHUyrWAM69QyD3tpZIVR1bpJR6Za9N5TEp+Aphrhca1lp5MeAqV1e1wrxU4AN2+ujrCW
        gVwcNoFg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nZrnU-00068m-9M; Thu, 31 Mar 2022 12:12:56 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Jan Engelhardt <jengelh@inai.de>
Subject: [iptables PATCH v2 4/9] extensions: ipt_DNAT: Merge v1/v2 print/save code
Date:   Thu, 31 Mar 2022 12:12:06 +0200
Message-Id: <20220331101211.10099-5-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220331101211.10099-1-phil@nwl.cc>
References: <20220331101211.10099-1-phil@nwl.cc>
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

