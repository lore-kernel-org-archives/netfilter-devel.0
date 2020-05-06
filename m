Return-Path: <SRS0=4pKc=6U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A25C9C47256
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 17:33:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79FFF206B8
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 17:33:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729317AbgEFRdr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 May 2020 13:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728047AbgEFRdr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 May 2020 13:33:47 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9A4C061A0F
        for <netfilter-devel@vger.kernel.org>; Wed,  6 May 2020 10:33:46 -0700 (PDT)
Received: from localhost ([::1]:58696 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jWNvV-0002it-Pw; Wed, 06 May 2020 19:33:45 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 12/15] nft: Use clear_cs() instead of open coding
Date:   Wed,  6 May 2020 19:33:28 +0200
Message-Id: <20200506173331.9347-13-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200506173331.9347-1-phil@nwl.cc>
References: <20200506173331.9347-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In a few places, initialized struct iptables_command_state was not fully
deinitialized. Change them to call nft_clear_iptables_command_state()
which does it properly.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-ipv4.c    | 2 +-
 iptables/nft-ipv6.c    | 2 +-
 iptables/xtables-arp.c | 4 +---
 iptables/xtables.c     | 6 +-----
 4 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 70634f8fad84d..69691fe28cf80 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -288,7 +288,7 @@ static void nft_ipv4_print_rule(struct nft_handle *h, struct nftnl_rule *r,
 	if (!(format & FMT_NONEWLINE))
 		fputc('\n', stdout);
 
-	xtables_rule_matches_free(&cs.matches);
+	nft_clear_iptables_command_state(&cs);
 }
 
 static void save_ipv4_addr(char letter, const struct in_addr *addr,
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index d01491bfdb689..76f2613d95c6a 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -217,7 +217,7 @@ static void nft_ipv6_print_rule(struct nft_handle *h, struct nftnl_rule *r,
 	if (!(format & FMT_NONEWLINE))
 		fputc('\n', stdout);
 
-	xtables_rule_matches_free(&cs.matches);
+	nft_clear_iptables_command_state(&cs);
 }
 
 static void save_ipv6_addr(char letter, const struct in6_addr *addr,
diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index a0136059bb710..e64938fbf5d36 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -1019,9 +1019,7 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 	free(daddrs);
 	free(dmasks);
 
-	if (cs.target)
-		free(cs.target->t);
-
+	nft_clear_iptables_command_state(&cs);
 	xtables_free_opts(1);
 
 /*	if (verbose > 1)
diff --git a/iptables/xtables.c b/iptables/xtables.c
index c180af13975f8..63a37ae867069 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -1138,11 +1138,7 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 
 	*table = p.table;
 
-	xtables_rule_matches_free(&cs.matches);
-	if (cs.target) {
-		free(cs.target->t);
-		cs.target->t = NULL;
-	}
+	nft_clear_iptables_command_state(&cs);
 
 	if (h->family == AF_INET) {
 		free(args.s.addr.v4);
-- 
2.25.1

