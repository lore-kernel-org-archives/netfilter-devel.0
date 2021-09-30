Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1B6FC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Sep 2021 14:05:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADD8E619FA
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Sep 2021 14:05:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351745AbhI3OHP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Sep 2021 10:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351734AbhI3OHP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Sep 2021 10:07:15 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71045C06176A
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Sep 2021 07:05:32 -0700 (PDT)
Received: from localhost ([::1]:51726 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mVwgk-0007Ro-Je; Thu, 30 Sep 2021 16:05:30 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 17/17] nft: Store maximum allowed chain name length in family ops
Date:   Thu, 30 Sep 2021 16:04:19 +0200
Message-Id: <20210930140419.6170-18-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210930140419.6170-1-phil@nwl.cc>
References: <20210930140419.6170-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

arptables accepts chain names of at max 30chars while ip(6)tables only
accepts up to 29chars. To retain the old behaviour, store the value in
nft_family_ops.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-arp.c    | 1 +
 iptables/nft-ipv4.c   | 1 +
 iptables/nft-ipv6.c   | 1 +
 iptables/nft-shared.h | 1 +
 iptables/xtables.c    | 6 +++---
 5 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 32eb91add4f1e..de3c7028818ab 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -811,4 +811,5 @@ struct nft_family_ops nft_family_ops_arp = {
 	.delete_entry		= nft_arp_delete_entry,
 	.check_entry		= nft_arp_check_entry,
 	.replace_entry		= nft_arp_replace_entry,
+	.chain_maxnamelen	= ARPT_FUNCTION_MAXNAMELEN,
 };
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index febd7673af4f8..85ab0fe559dfd 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -577,4 +577,5 @@ struct nft_family_ops nft_family_ops_ipv4 = {
 	.delete_entry		= nft_ipv4_delete_entry,
 	.check_entry		= nft_ipv4_check_entry,
 	.replace_entry		= nft_ipv4_replace_entry,
+	.chain_maxnamelen	= XT_EXTENSION_MAXNAMELEN,
 };
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index f0e64bbd4ab23..48bcef6a1823a 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -530,4 +530,5 @@ struct nft_family_ops nft_family_ops_ipv6 = {
 	.delete_entry		= nft_ipv6_delete_entry,
 	.check_entry		= nft_ipv6_check_entry,
 	.replace_entry		= nft_ipv6_replace_entry,
+	.chain_maxnamelen	= XT_EXTENSION_MAXNAMELEN,
 };
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 339c46e7f5b06..75597a0f609e8 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -129,6 +129,7 @@ struct nft_family_ops {
 			     struct iptables_command_state *cs,
 			     struct xtables_args *args, bool verbose,
 			     int rulenum);
+	size_t chain_maxnamelen;
 };
 
 void add_meta(struct nftnl_rule *r, uint32_t key);
diff --git a/iptables/xtables.c b/iptables/xtables.c
index dba497b85064a..c6c7cbddbd3a3 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -788,10 +788,10 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 
 	generic_opt_check(p->command, cs->options);
 
-	if (p->chain != NULL && strlen(p->chain) >= XT_EXTENSION_MAXNAMELEN)
+	if (p->chain != NULL && strlen(p->chain) >= h->ops->chain_maxnamelen)
 		xtables_error(PARAMETER_PROBLEM,
-			   "chain name `%s' too long (must be under %u chars)",
-			   p->chain, XT_EXTENSION_MAXNAMELEN);
+			   "chain name `%s' too long (must be under %zu chars)",
+			   p->chain, h->ops->chain_maxnamelen);
 
 	if (p->command == CMD_APPEND ||
 	    p->command == CMD_DELETE ||
-- 
2.33.0

