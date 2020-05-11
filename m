Return-Path: <SRS0=NFxu=6Z=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83CFBC47255
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 May 2020 13:38:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CFC620708
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 May 2020 13:38:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729955AbgEKNi3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 May 2020 09:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729956AbgEKNi1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 May 2020 09:38:27 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BCA3C061A0C
        for <netfilter-devel@vger.kernel.org>; Mon, 11 May 2020 06:38:27 -0700 (PDT)
Received: from localhost ([::1]:42688 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jY8dV-00025i-Vc; Mon, 11 May 2020 15:38:26 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/2] nft: Drop save_counters callback from family_ops
Date:   Mon, 11 May 2020 15:38:17 +0200
Message-Id: <20200511133817.11106-2-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200511133817.11106-1-phil@nwl.cc>
References: <20200511133817.11106-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

All families use the same callback function, just fold it into the sole
place it's called.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-arp.c    | 1 -
 iptables/nft-bridge.c | 1 -
 iptables/nft-ipv4.c   | 1 -
 iptables/nft-ipv6.c   | 1 -
 iptables/nft-shared.c | 8 --------
 iptables/nft-shared.h | 2 --
 iptables/nft.c        | 5 +++--
 7 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 23ab73cba649e..67f4529d93652 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -652,7 +652,6 @@ struct nft_family_ops nft_family_ops_arp = {
 	.print_header		= nft_arp_print_header,
 	.print_rule		= nft_arp_print_rule,
 	.save_rule		= nft_arp_save_rule,
-	.save_counters		= save_counters,
 	.save_chain		= nft_arp_save_chain,
 	.post_parse		= NULL,
 	.rule_to_cs		= nft_rule_to_iptables_command_state,
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 18f5e78f1b3a2..dbf11eb5e1fa8 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -932,7 +932,6 @@ struct nft_family_ops nft_family_ops_bridge = {
 	.print_header		= nft_bridge_print_header,
 	.print_rule		= nft_bridge_print_rule,
 	.save_rule		= nft_bridge_save_rule,
-	.save_counters		= save_counters,
 	.save_chain		= nft_bridge_save_chain,
 	.post_parse		= NULL,
 	.rule_to_cs		= nft_rule_to_ebtables_command_state,
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index ba789da0c5973..afdecf9711e64 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -450,7 +450,6 @@ struct nft_family_ops nft_family_ops_ipv4 = {
 	.print_header		= print_header,
 	.print_rule		= nft_ipv4_print_rule,
 	.save_rule		= nft_ipv4_save_rule,
-	.save_counters		= save_counters,
 	.save_chain		= nft_ipv46_save_chain,
 	.proto_parse		= nft_ipv4_proto_parse,
 	.post_parse		= nft_ipv4_post_parse,
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 84bcf1c53f48c..4008b7eab4f2a 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -402,7 +402,6 @@ struct nft_family_ops nft_family_ops_ipv6 = {
 	.print_header		= print_header,
 	.print_rule		= nft_ipv6_print_rule,
 	.save_rule		= nft_ipv6_save_rule,
-	.save_counters		= save_counters,
 	.save_chain		= nft_ipv46_save_chain,
 	.proto_parse		= nft_ipv6_proto_parse,
 	.post_parse		= nft_ipv6_post_parse,
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 53cd4cae9ef7c..c5a8f3fcc051d 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -831,14 +831,6 @@ void save_rule_details(const struct iptables_command_state *cs,
 	}
 }
 
-void save_counters(const void *data)
-{
-	const struct iptables_command_state *cs = data;
-
-	printf("[%llu:%llu] ", (unsigned long long)cs->counters.pcnt,
-			       (unsigned long long)cs->counters.bcnt);
-}
-
 void nft_ipv46_save_chain(const struct nftnl_chain *c, const char *policy)
 {
 	const char *chain = nftnl_chain_get_str(c, NFTNL_CHAIN_NAME);
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index cb60e685872dd..94437ffe7990c 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -98,7 +98,6 @@ struct nft_family_ops {
 	void (*print_rule)(struct nft_handle *h, struct nftnl_rule *r,
 			   unsigned int num, unsigned int format);
 	void (*save_rule)(const void *data, unsigned int format);
-	void (*save_counters)(const void *data);
 	void (*save_chain)(const struct nftnl_chain *c, const char *policy);
 	void (*proto_parse)(struct iptables_command_state *cs,
 			    struct xtables_args *args);
@@ -160,7 +159,6 @@ void save_rule_details(const struct iptables_command_state *cs,
 		       unsigned const char *iniface_mask,
 		       const char *outiface,
 		       unsigned const char *outiface_mask);
-void save_counters(const void *data);
 void nft_ipv46_save_chain(const struct nftnl_chain *c, const char *policy);
 void save_matches_and_target(const struct iptables_command_state *cs,
 			     bool goto_flag, const void *fw,
diff --git a/iptables/nft.c b/iptables/nft.c
index e65eb91c1c504..0c5a74fc232c6 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1453,8 +1453,9 @@ nft_rule_print_save(struct nft_handle *h, const struct nftnl_rule *r,
 
 	ops->rule_to_cs(h, r, &cs);
 
-	if (!(format & (FMT_NOCOUNTS | FMT_C_COUNTS)) && ops->save_counters)
-		ops->save_counters(&cs);
+	if (!(format & (FMT_NOCOUNTS | FMT_C_COUNTS)))
+		printf("[%llu:%llu] ", (unsigned long long)cs.counters.pcnt,
+				       (unsigned long long)cs.counters.bcnt);
 
 	/* print chain name */
 	switch(type) {
-- 
2.25.1

