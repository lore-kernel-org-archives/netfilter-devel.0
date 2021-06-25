Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EF4EC2B9F4
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Jun 2021 21:08:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 852F361428
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Jun 2021 21:08:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbhFYVK5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Jun 2021 17:10:57 -0400
Received: from mail.netfilter.org ([217.70.188.207]:53144 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbhFYVK5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Jun 2021 17:10:57 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id D9F0B60693
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Jun 2021 23:08:33 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH iptables] extensions: libxt_multiport: add translation for -m multiport --ports
Date:   Fri, 25 Jun 2021 23:08:32 +0200
Message-Id: <20210625210832.20907-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a translation for -m multiport --ports. Extend the existing testcase.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 extensions/libxt_multiport.c      | 38 ++++++++++++++++++++++++-------
 extensions/libxt_multiport.txlate |  3 +++
 2 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multiport.c
index 4a42fa38238b..6b0c8190a102 100644
--- a/extensions/libxt_multiport.c
+++ b/extensions/libxt_multiport.c
@@ -465,7 +465,8 @@ static void multiport_save6_v1(const void *ip_void,
 }
 
 static int __multiport_xlate(struct xt_xlate *xl,
-			     const struct xt_xlate_mt_params *params)
+			     const struct xt_xlate_mt_params *params,
+			     uint8_t proto)
 {
 	const struct xt_multiport *multiinfo
 		= (const struct xt_multiport *)params->match->data;
@@ -479,7 +480,17 @@ static int __multiport_xlate(struct xt_xlate *xl,
 		xt_xlate_add(xl, " dport ");
 		break;
 	case XT_MULTIPORT_EITHER:
-		return 0;
+		xt_xlate_add(xl, " sport . %s dport { ", proto_to_name(proto));
+		for (i = 0; i < multiinfo->count; i++) {
+			if (i != 0)
+				xt_xlate_add(xl, ", ");
+
+			xt_xlate_add(xl, "0-65535 . %u, %u . 0-65535",
+				     multiinfo->ports[i], multiinfo->ports[i]);
+		}
+		xt_xlate_add(xl, " }");
+
+		return 1;
 	}
 
 	if (multiinfo->count > 1)
@@ -500,7 +511,7 @@ static int multiport_xlate(struct xt_xlate *xl,
 	uint8_t proto = ((const struct ipt_ip *)params->ip)->proto;
 
 	xt_xlate_add(xl, "%s", proto_to_name(proto));
-	return __multiport_xlate(xl, params);
+	return __multiport_xlate(xl, params, proto);
 }
 
 static int multiport_xlate6(struct xt_xlate *xl,
@@ -509,11 +520,12 @@ static int multiport_xlate6(struct xt_xlate *xl,
 	uint8_t proto = ((const struct ip6t_ip6 *)params->ip)->proto;
 
 	xt_xlate_add(xl, "%s", proto_to_name(proto));
-	return __multiport_xlate(xl, params);
+	return __multiport_xlate(xl, params, proto);
 }
 
 static int __multiport_xlate_v1(struct xt_xlate *xl,
-				const struct xt_xlate_mt_params *params)
+				const struct xt_xlate_mt_params *params,
+				uint8_t proto)
 {
 	const struct xt_multiport_v1 *multiinfo =
 		(const struct xt_multiport_v1 *)params->match->data;
@@ -527,7 +539,17 @@ static int __multiport_xlate_v1(struct xt_xlate *xl,
 		xt_xlate_add(xl, " dport ");
 		break;
 	case XT_MULTIPORT_EITHER:
-		return 0;
+		xt_xlate_add(xl, " sport . %s dport { ", proto_to_name(proto));
+		for (i = 0; i < multiinfo->count; i++) {
+			if (i != 0)
+				xt_xlate_add(xl, ", ");
+
+			xt_xlate_add(xl, "0-65535 . %u, %u . 0-65535",
+				     multiinfo->ports[i], multiinfo->ports[i]);
+		}
+		xt_xlate_add(xl, " }");
+
+		return 1;
 	}
 
 	if (multiinfo->invert)
@@ -556,7 +578,7 @@ static int multiport_xlate_v1(struct xt_xlate *xl,
 	uint8_t proto = ((const struct ipt_ip *)params->ip)->proto;
 
 	xt_xlate_add(xl, "%s", proto_to_name(proto));
-	return __multiport_xlate_v1(xl, params);
+	return __multiport_xlate_v1(xl, params, proto);
 }
 
 static int multiport_xlate6_v1(struct xt_xlate *xl,
@@ -565,7 +587,7 @@ static int multiport_xlate6_v1(struct xt_xlate *xl,
 	uint8_t proto = ((const struct ip6t_ip6 *)params->ip)->proto;
 
 	xt_xlate_add(xl, "%s", proto_to_name(proto));
-	return __multiport_xlate_v1(xl, params);
+	return __multiport_xlate_v1(xl, params, proto);
 }
 
 static struct xtables_match multiport_mt_reg[] = {
diff --git a/extensions/libxt_multiport.txlate b/extensions/libxt_multiport.txlate
index 752e7148f2be..bced1b84c447 100644
--- a/extensions/libxt_multiport.txlate
+++ b/extensions/libxt_multiport.txlate
@@ -9,3 +9,6 @@ nft add rule ip filter INPUT ip protocol tcp tcp dport != 80-88 counter accept
 
 iptables-translate -t filter -A INPUT -p tcp -m multiport --sports 50 -j ACCEPT
 nft add rule ip filter INPUT ip protocol tcp tcp sport 50 counter accept
+
+iptables-translate -t filter -I INPUT -p tcp -m multiport --ports 10
+nft insert rule ip filter INPUT ip protocol tcp tcp sport . tcp dport { 0-65535 . 10, 10 . 0-65535 } counter
-- 
2.20.1

