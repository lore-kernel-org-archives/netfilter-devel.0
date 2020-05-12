Return-Path: <SRS0=em6Q=62=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EABCECA90AF
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 May 2020 17:10:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB38C206B8
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 May 2020 17:10:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgELRK3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 May 2020 13:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbgELRK3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 May 2020 13:10:29 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE3DC061A0C
        for <netfilter-devel@vger.kernel.org>; Tue, 12 May 2020 10:10:29 -0700 (PDT)
Received: from localhost ([::1]:45474 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jYYQF-00025y-GI; Tue, 12 May 2020 19:10:27 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/3] xshared: Share make_delete_mask() between ip{,6}tables
Date:   Tue, 12 May 2020 19:10:16 +0200
Message-Id: <20200512171018.16871-2-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200512171018.16871-1-phil@nwl.cc>
References: <20200512171018.16871-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
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
index 576c2cf8b0d9f..1a59d6f7a1542 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -622,40 +622,6 @@ insert_entry(const xt_chainlabel chain,
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
@@ -674,7 +640,7 @@ delete_entry(const xt_chainlabel chain,
 	int ret = 1;
 	unsigned char *mask;
 
-	mask = make_delete_mask(matches, target);
+	mask = make_delete_mask(matches, target, sizeof(*fw));
 	for (i = 0; i < nsaddrs; i++) {
 		fw->ipv6.src = saddrs[i];
 		fw->ipv6.smsk = smasks[i];
@@ -704,7 +670,7 @@ check_entry(const xt_chainlabel chain, struct ip6t_entry *fw,
 	int ret = 1;
 	unsigned char *mask;
 
-	mask = make_delete_mask(matches, target);
+	mask = make_delete_mask(matches, target, sizeof(fw));
 	for (i = 0; i < nsaddrs; i++) {
 		fw->ipv6.src = saddrs[i];
 		fw->ipv6.smsk = smasks[i];
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 88ef6cf666d4b..ead9c482a3ad1 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -614,40 +614,6 @@ insert_entry(const xt_chainlabel chain,
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
@@ -666,7 +632,7 @@ delete_entry(const xt_chainlabel chain,
 	int ret = 1;
 	unsigned char *mask;
 
-	mask = make_delete_mask(matches, target);
+	mask = make_delete_mask(matches, target, sizeof(*fw));
 	for (i = 0; i < nsaddrs; i++) {
 		fw->ip.src.s_addr = saddrs[i].s_addr;
 		fw->ip.smsk.s_addr = smasks[i].s_addr;
@@ -696,7 +662,7 @@ check_entry(const xt_chainlabel chain, struct ipt_entry *fw,
 	int ret = 1;
 	unsigned char *mask;
 
-	mask = make_delete_mask(matches, target);
+	mask = make_delete_mask(matches, target, sizeof(*fw));
 	for (i = 0; i < nsaddrs; i++) {
 		fw->ip.src.s_addr = saddrs[i].s_addr;
 		fw->ip.smsk.s_addr = smasks[i].s_addr;
diff --git a/iptables/xshared.c b/iptables/xshared.c
index c1d1371a6d54a..2438c4eeb5ff7 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -774,3 +774,37 @@ int parse_rulenumber(const char *rule)
 
 	return rulenum;
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
index c41bd054bf36f..eb908e484616e 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -216,4 +216,8 @@ void add_command(unsigned int *cmd, const int newcmd,
 		 const int othercmds, int invert);
 int parse_rulenumber(const char *rule);
 
+unsigned char *make_delete_mask(const struct xtables_rule_match *matches,
+				const struct xtables_target *target,
+				size_t entry_size);
+
 #endif /* IPTABLES_XSHARED_H */
-- 
2.25.1

