Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E409DC433B4
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Apr 2021 10:43:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A88CE61164
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Apr 2021 10:43:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235590AbhD0Kn7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Apr 2021 06:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235562AbhD0Kn7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Apr 2021 06:43:59 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6487C061574
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Apr 2021 03:43:16 -0700 (PDT)
Received: from localhost ([::1]:59182 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1lbLBT-0001Yy-7c; Tue, 27 Apr 2021 12:43:15 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/2] Eliminate inet_aton() and inet_ntoa()
Date:   Tue, 27 Apr 2021 12:42:58 +0200
Message-Id: <20210427104259.22042-2-phil@nwl.cc>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210427104259.22042-1-phil@nwl.cc>
References: <20210427104259.22042-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Both functions are obsolete, replace them by equivalent calls to
inet_pton() and inet_ntop().

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libebt_among.c |  6 ++++--
 iptables/nft-ipv4.c       | 23 ++++++++++++++---------
 2 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/extensions/libebt_among.c b/extensions/libebt_among.c
index 2b9a1b6566684..7eb898f984bba 100644
--- a/extensions/libebt_among.c
+++ b/extensions/libebt_among.c
@@ -66,7 +66,7 @@ parse_nft_among_pair(char *buf, struct nft_among_pair *pair, bool have_ip)
 	if (sep) {
 		*sep = '\0';
 
-		if (!inet_aton(sep + 1, &pair->in))
+		if (!inet_pton(AF_INET, sep + 1, &pair->in))
 			xtables_error(PARAMETER_PROBLEM,
 				      "Invalid IP address '%s'\n", sep + 1);
 	}
@@ -194,6 +194,7 @@ static void __bramong_print(struct nft_among_pair *pairs,
 			    int cnt, bool inv, bool have_ip)
 {
 	const char *isep = inv ? "! " : "";
+	char abuf[INET_ADDRSTRLEN];
 	int i;
 
 	for (i = 0; i < cnt; i++) {
@@ -202,7 +203,8 @@ static void __bramong_print(struct nft_among_pair *pairs,
 
 		printf("%s", ether_ntoa(&pairs[i].ether));
 		if (pairs[i].in.s_addr != INADDR_ANY)
-			printf("=%s", inet_ntoa(pairs[i].in));
+			printf("=%s", inet_ntop(AF_INET, &pairs[i].in,
+						abuf, sizeof(abuf)));
 	}
 	printf(" ");
 }
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 0d32a30010519..a5b835b1f681d 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -136,7 +136,7 @@ static void get_frag(struct nft_xt_ctx *ctx, struct nftnl_expr *e, bool *inv)
 
 static const char *mask_to_str(uint32_t mask)
 {
-	static char mask_str[sizeof("255.255.255.255")];
+	static char mask_str[INET_ADDRSTRLEN];
 	uint32_t bits, hmask = ntohl(mask);
 	struct in_addr mask_addr = {
 		.s_addr = mask,
@@ -155,7 +155,7 @@ static const char *mask_to_str(uint32_t mask)
 	if (i >= 0)
 		sprintf(mask_str, "%u", i);
 	else
-		sprintf(mask_str, "%s", inet_ntoa(mask_addr));
+		inet_ntop(AF_INET, &mask_addr, mask_str, sizeof(mask_str));
 
 	return mask_str;
 }
@@ -298,10 +298,13 @@ static void nft_ipv4_print_rule(struct nft_handle *h, struct nftnl_rule *r,
 static void save_ipv4_addr(char letter, const struct in_addr *addr,
 			   uint32_t mask, int invert)
 {
+	char addrbuf[INET_ADDRSTRLEN];
+
 	if (!mask && !invert && !addr->s_addr)
 		return;
 
-	printf("%s-%c %s/%s ", invert ? "! " : "", letter, inet_ntoa(*addr),
+	printf("%s-%c %s/%s ", invert ? "! " : "", letter,
+	       inet_ntop(AF_INET, addr, addrbuf, sizeof(addrbuf)),
 	       mask_to_str(mask));
 }
 
@@ -387,25 +390,27 @@ static void xlate_ipv4_addr(const char *selector, const struct in_addr *addr,
 			    const struct in_addr *mask,
 			    bool inv, struct xt_xlate *xl)
 {
+	char mbuf[INET_ADDRSTRLEN], abuf[INET_ADDRSTRLEN];
 	const char *op = inv ? "!= " : "";
 	int cidr;
 
 	if (!inv && !addr->s_addr && !mask->s_addr)
 		return;
 
+	inet_ntop(AF_INET, addr, abuf, sizeof(abuf));
+
 	cidr = xtables_ipmask_to_cidr(mask);
 	switch (cidr) {
 	case -1:
-		/* inet_ntoa() is not reentrant */
-		xt_xlate_add(xl, "%s & %s ", selector, inet_ntoa(*mask));
-		xt_xlate_add(xl, "%s %s ", inv ? "!=" : "==", inet_ntoa(*addr));
+		xt_xlate_add(xl, "%s & %s %s %s ", selector,
+			     inet_ntop(AF_INET, mask, mbuf, sizeof(mbuf)),
+			     inv ? "!=" : "==", abuf);
 		break;
 	case 32:
-		xt_xlate_add(xl, "%s %s%s ", selector, op, inet_ntoa(*addr));
+		xt_xlate_add(xl, "%s %s%s ", selector, op, abuf);
 		break;
 	default:
-		xt_xlate_add(xl, "%s %s%s/%d ", selector, op, inet_ntoa(*addr),
-			     cidr);
+		xt_xlate_add(xl, "%s %s%s/%d ", selector, op, abuf, cidr);
 	}
 }
 
-- 
2.31.0

