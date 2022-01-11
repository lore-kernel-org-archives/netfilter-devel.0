Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47065C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Jan 2022 15:05:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243891AbiAKPFW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Jan 2022 10:05:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244013AbiAKPFT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Jan 2022 10:05:19 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA79C06173F
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Jan 2022 07:05:18 -0800 (PST)
Received: from localhost ([::1]:59134 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1n7Ii5-0007Xi-Ai; Tue, 11 Jan 2022 16:05:17 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 01/11] xtables: Drop xtables' family on demand feature
Date:   Tue, 11 Jan 2022 16:04:19 +0100
Message-Id: <20220111150429.29110-2-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220111150429.29110-1-phil@nwl.cc>
References: <20220111150429.29110-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This conditional h->family assignment was added by commit 3f7877e6be987
("xtables-restore: add -4 and -6 support") with the intention to support
something like 'xtables-restore -6 <ip6tables.dump', i.e. having
family-agnostic commands which accept flags to set the family. Yet
commit be70918eab26e ("xtables: rename xt-multi binaries to -nft,
-legacy") removed support for such command names back in 2018 and nobody
has complained so far. Therefore drop this leftover as it makes
do_parse() more generic.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/iptables/xtables.c b/iptables/xtables.c
index 57bec76c31fb3..5c48bd94644f3 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -657,10 +657,6 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 		xtables_error(PARAMETER_PROBLEM,
 			   "nothing appropriate following !");
 
-	/* Set only if required, needed by xtables-restore */
-	if (h->family == AF_UNSPEC)
-		h->family = args->family;
-
 	h->ops->post_parse(p->command, cs, args);
 
 	if (p->command == CMD_REPLACE &&
-- 
2.34.1

