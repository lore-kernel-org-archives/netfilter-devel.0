Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D833DC433FE
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Nov 2022 00:21:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234163AbiKLAVr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Nov 2022 19:21:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234004AbiKLAVq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Nov 2022 19:21:46 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B2783F074
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Nov 2022 16:21:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=OgYkTBRmCIgtUTHEwzgViOtBvjtRPGuls3RDvhus+v8=; b=YN2ZA7iRW1gXmo3WT6xjh5y+ci
        Ib3YxNhRYV3Olmieu94DSr/9gzHTTqdF2L1yzhm0baiYafCqWXlz1e5T3/txj2DUeJHvNYCdoPnTI
        IAR2QSygSckSGqivvsP0UdMLT7tWXeB0tSyMzwmmeIRoNIUqJretAzJyRZZMvvXocdQVG/osxVq43
        aMv6nZuLhO+dqnYjg1rS7Ycubj3G9zU+egL3CcCvnsHHJ+6vSHZeudyaQfS3ql3C8kQbBIfC0e47K
        HtXvXGbgOAAKkyTD0s7i8FD1M9AAvSOYcQKz3292yRoowMlmnVd0/nn3IYbrSAPmeuzs++TvtWJDI
        HgbrYTPw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oteHH-000247-Tv
        for netfilter-devel@vger.kernel.org; Sat, 12 Nov 2022 01:21:44 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/7] xshared: Share make_delete_mask() between ip{,6}tables
Date:   Sat, 12 Nov 2022 01:20:50 +0100
Message-Id: <20221112002056.31917-2-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221112002056.31917-1-phil@nwl.cc>
References: <20221112002056.31917-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Function bodies were mostly identical, the only difference being the use
of struct ipt_entry or ip6t_entry for size calculation. Pass this value
via parameter to make them fully identical.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/ip6tables.c | 38 ++------------------------------------
 iptables/iptables.c  | 38 ++------------------------------------
 iptables/xshared.c   | 34 ++++++++++++++++++++++++++++++++++
 iptables/xshared.h   |  4 ++++
 4 files changed, 42 insertions(+), 72 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 75984cc1bcdd8..ae2670357264b 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -277,40 +277,6 @@ insert_entry(const xt_chainlabel chain,
 	return ret;
 }
 
-static unsigned char *
-make_delete_mask(const struct xtables_rule_match *matches,
-		 const struct xtables_target *target)
-{
-	/* Establish mask for comparison */
-	unsigned int size;
-	const struct xtables_rule_match *matchp;
-	unsigned char *mask, *mptr;
-
-	size = sizeof(struct ip6t_entry);
-	for (matchp = matches; matchp; matchp = matchp->next)
-		size += XT_ALIGN(sizeof(struct xt_entry_match)) + matchp->match->size;
-
-	mask = xtables_calloc(1, size
-			 + XT_ALIGN(sizeof(struct xt_entry_target))
-			 + target->size);
-
-	memset(mask, 0xFF, sizeof(struct ip6t_entry));
-	mptr = mask + sizeof(struct ip6t_entry);
-
-	for (matchp = matches; matchp; matchp = matchp->next) {
-		memset(mptr, 0xFF,
-		       XT_ALIGN(sizeof(struct xt_entry_match))
-		       + matchp->match->userspacesize);
-		mptr += XT_ALIGN(sizeof(struct xt_entry_match)) + matchp->match->size;
-	}
-
-	memset(mptr, 0xFF,
-	       XT_ALIGN(sizeof(struct xt_entry_target))
-	       + target->userspacesize);
-
-	return mask;
-}
-
 static int
 delete_entry(const xt_chainlabel chain,
 	     struct ip6t_entry *fw,
@@ -329,7 +295,7 @@ delete_entry(const xt_chainlabel chain,
 	int ret = 1;
 	unsigned char *mask;
 
-	mask = make_delete_mask(matches, target);
+	mask = make_delete_mask(matches, target, sizeof(*fw));
 	for (i = 0; i < nsaddrs; i++) {
 		fw->ipv6.src = saddrs[i];
 		fw->ipv6.smsk = smasks[i];
@@ -359,7 +325,7 @@ check_entry(const xt_chainlabel chain, struct ip6t_entry *fw,
 	int ret = 1;
 	unsigned char *mask;
 
-	mask = make_delete_mask(matches, target);
+	mask = make_delete_mask(matches, target, sizeof(fw));
 	for (i = 0; i < nsaddrs; i++) {
 		fw->ipv6.src = saddrs[i];
 		fw->ipv6.smsk = smasks[i];
diff --git a/iptables/iptables.c b/iptables/iptables.c
index e5207ba106057..591ec17886562 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -276,40 +276,6 @@ insert_entry(const xt_chainlabel chain,
 	return ret;
 }
 
-static unsigned char *
-make_delete_mask(const struct xtables_rule_match *matches,
-		 const struct xtables_target *target)
-{
-	/* Establish mask for comparison */
-	unsigned int size;
-	const struct xtables_rule_match *matchp;
-	unsigned char *mask, *mptr;
-
-	size = sizeof(struct ipt_entry);
-	for (matchp = matches; matchp; matchp = matchp->next)
-		size += XT_ALIGN(sizeof(struct xt_entry_match)) + matchp->match->size;
-
-	mask = xtables_calloc(1, size
-			 + XT_ALIGN(sizeof(struct xt_entry_target))
-			 + target->size);
-
-	memset(mask, 0xFF, sizeof(struct ipt_entry));
-	mptr = mask + sizeof(struct ipt_entry);
-
-	for (matchp = matches; matchp; matchp = matchp->next) {
-		memset(mptr, 0xFF,
-		       XT_ALIGN(sizeof(struct xt_entry_match))
-		       + matchp->match->userspacesize);
-		mptr += XT_ALIGN(sizeof(struct xt_entry_match)) + matchp->match->size;
-	}
-
-	memset(mptr, 0xFF,
-	       XT_ALIGN(sizeof(struct xt_entry_target))
-	       + target->userspacesize);
-
-	return mask;
-}
-
 static int
 delete_entry(const xt_chainlabel chain,
 	     struct ipt_entry *fw,
@@ -328,7 +294,7 @@ delete_entry(const xt_chainlabel chain,
 	int ret = 1;
 	unsigned char *mask;
 
-	mask = make_delete_mask(matches, target);
+	mask = make_delete_mask(matches, target, sizeof(*fw));
 	for (i = 0; i < nsaddrs; i++) {
 		fw->ip.src.s_addr = saddrs[i].s_addr;
 		fw->ip.smsk.s_addr = smasks[i].s_addr;
@@ -358,7 +324,7 @@ check_entry(const xt_chainlabel chain, struct ipt_entry *fw,
 	int ret = 1;
 	unsigned char *mask;
 
-	mask = make_delete_mask(matches, target);
+	mask = make_delete_mask(matches, target, sizeof(*fw));
 	for (i = 0; i < nsaddrs; i++) {
 		fw->ip.src.s_addr = saddrs[i].s_addr;
 		fw->ip.smsk.s_addr = smasks[i].s_addr;
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 695157896d521..0beacee61d487 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -2000,3 +2000,37 @@ void ipv6_post_parse(int command, struct iptables_command_state *cs,
 			      "! not allowed with multiple"
 			      " source or destination IP addresses");
 }
+
+unsigned char *
+make_delete_mask(const struct xtables_rule_match *matches,
+		 const struct xtables_target *target,
+		 size_t entry_size)
+{
+	/* Establish mask for comparison */
+	unsigned int size = entry_size;
+	const struct xtables_rule_match *matchp;
+	unsigned char *mask, *mptr;
+
+	for (matchp = matches; matchp; matchp = matchp->next)
+		size += XT_ALIGN(sizeof(struct xt_entry_match)) + matchp->match->size;
+
+	mask = xtables_calloc(1, size
+			 + XT_ALIGN(sizeof(struct xt_entry_target))
+			 + target->size);
+
+	memset(mask, 0xFF, entry_size);
+	mptr = mask + entry_size;
+
+	for (matchp = matches; matchp; matchp = matchp->next) {
+		memset(mptr, 0xFF,
+		       XT_ALIGN(sizeof(struct xt_entry_match))
+		       + matchp->match->userspacesize);
+		mptr += XT_ALIGN(sizeof(struct xt_entry_match)) + matchp->match->size;
+	}
+
+	memset(mptr, 0xFF,
+	       XT_ALIGN(sizeof(struct xt_entry_target))
+	       + target->userspacesize);
+
+	return mask;
+}
diff --git a/iptables/xshared.h b/iptables/xshared.h
index f43c28f519a9c..bfae4b4e1b5d3 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -293,4 +293,8 @@ void ipv6_post_parse(int command, struct iptables_command_state *cs,
 extern char *arp_opcodes[];
 #define ARP_NUMOPCODES 9
 
+unsigned char *make_delete_mask(const struct xtables_rule_match *matches,
+				const struct xtables_target *target,
+				size_t entry_size);
+
 #endif /* IPTABLES_XSHARED_H */
-- 
2.38.0

