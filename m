Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C439AC433ED
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Apr 2021 17:37:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DFF861168
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Apr 2021 17:37:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242212AbhD1RiH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 13:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242080AbhD1Rhz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 13:37:55 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6E9C0613ED
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Apr 2021 10:37:09 -0700 (PDT)
Received: from localhost ([::1]:34724 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1lbo7Y-0007AG-At; Wed, 28 Apr 2021 19:37:08 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 5/5] Use proto_to_name() from xshared in more places
Date:   Wed, 28 Apr 2021 19:36:56 +0200
Message-Id: <20210428173656.16851-6-phil@nwl.cc>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210428173656.16851-1-phil@nwl.cc>
References: <20210428173656.16851-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Share the common proto name lookup code. While being at it, make proto
number variable 16bit, values may exceed 256.

This aligns iptables-nft '-p' argument printing with legacy iptables. In
practice, this should make a difference only in corner cases.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/xtables.h     |  2 +-
 iptables/ip6tables.c  | 22 +++++-----------------
 iptables/iptables.c   | 20 +++++---------------
 iptables/nft-shared.c |  6 +++---
 iptables/xshared.c    |  2 +-
 iptables/xshared.h    |  2 +-
 6 files changed, 16 insertions(+), 38 deletions(-)

diff --git a/include/xtables.h b/include/xtables.h
index df1eaee326643..1fd5f63ac4b69 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -395,7 +395,7 @@ struct xtables_rule_match {
  */
 struct xtables_pprot {
 	const char *name;
-	uint8_t num;
+	uint16_t num;
 };
 
 enum xtables_tryload {
diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 044d9a33a0266..e967c040fd3c9 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -759,28 +759,16 @@ print_iface(char letter, const char *iface, const unsigned char *mask,
 	}
 }
 
-/* The ip6tables looks up the /etc/protocols. */
 static void print_proto(uint16_t proto, int invert)
 {
 	if (proto) {
-		unsigned int i;
+		const char *pname = proto_to_name(proto, 0);
 		const char *invertstr = invert ? " !" : "";
 
-		const struct protoent *pent = getprotobynumber(proto);
-		if (pent) {
-			printf("%s -p %s",
-			       invertstr, pent->p_name);
-			return;
-		}
-
-		for (i = 0; xtables_chain_protos[i].name != NULL; ++i)
-			if (xtables_chain_protos[i].num == proto) {
-				printf("%s -p %s",
-				       invertstr, xtables_chain_protos[i].name);
-				return;
-			}
-
-		printf("%s -p %u", invertstr, proto);
+		if (pname)
+			printf("%s -p %s", invertstr, pname);
+		else
+			printf("%s -p %u", invertstr, proto);
 	}
 }
 
diff --git a/iptables/iptables.c b/iptables/iptables.c
index da67dd2e1e997..b925f0892e0d5 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -727,23 +727,13 @@ list_entries(const xt_chainlabel chain, int rulenum, int verbose, int numeric,
 static void print_proto(uint16_t proto, int invert)
 {
 	if (proto) {
-		unsigned int i;
+		const char *pname = proto_to_name(proto, 0);
 		const char *invertstr = invert ? " !" : "";
 
-		const struct protoent *pent = getprotobynumber(proto);
-		if (pent) {
-			printf("%s -p %s", invertstr, pent->p_name);
-			return;
-		}
-
-		for (i = 0; xtables_chain_protos[i].name != NULL; ++i)
-			if (xtables_chain_protos[i].num == proto) {
-				printf("%s -p %s",
-				       invertstr, xtables_chain_protos[i].name);
-				return;
-			}
-
-		printf("%s -p %u", invertstr, proto);
+		if (pname)
+			printf("%s -p %s", invertstr, pname);
+		else
+			printf("%s -p %u", invertstr, proto);
 	}
 }
 
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index c1664b50f9383..4253b08196d29 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -826,13 +826,13 @@ void save_rule_details(const struct iptables_command_state *cs,
 	}
 
 	if (proto > 0) {
-		const struct protoent *pent = getprotobynumber(proto);
+		const char *pname = proto_to_name(proto, 0);
 
 		if (invflags & XT_INV_PROTO)
 			printf("! ");
 
-		if (pent)
-			printf("-p %s ", pent->p_name);
+		if (pname)
+			printf("-p %s ", pname);
 		else
 			printf("-p %u ", proto);
 	}
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 5e3a6aeb343a6..eff4898db3f9a 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -48,7 +48,7 @@ void print_extension_helps(const struct xtables_target *t,
 }
 
 const char *
-proto_to_name(uint8_t proto, int nolookup)
+proto_to_name(uint16_t proto, int nolookup)
 {
 	unsigned int i;
 
diff --git a/iptables/xshared.h b/iptables/xshared.h
index c4de0292f4d8e..0a029d5b20036 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -162,7 +162,7 @@ enum {
 
 extern void print_extension_helps(const struct xtables_target *,
 	const struct xtables_rule_match *);
-extern const char *proto_to_name(uint8_t, int);
+extern const char *proto_to_name(uint16_t, int);
 extern int command_default(struct iptables_command_state *,
 	struct xtables_globals *, bool invert);
 extern struct xtables_match *load_proto(struct iptables_command_state *);
-- 
2.31.0

