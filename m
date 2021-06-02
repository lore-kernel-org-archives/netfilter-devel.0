Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81872C4708F
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Jun 2021 15:24:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 639CD613B1
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Jun 2021 15:24:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbhFBP0S (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Jun 2021 11:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231848AbhFBP0S (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Jun 2021 11:26:18 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D743C061574
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Jun 2021 08:24:35 -0700 (PDT)
Received: from localhost ([::1]:43112 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1loSjR-0007PW-HT; Wed, 02 Jun 2021 17:24:33 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 5/9] nft: Avoid buffer size warnings copying iface names
Date:   Wed,  2 Jun 2021 17:23:59 +0200
Message-Id: <20210602152403.5689-6-phil@nwl.cc>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210602152403.5689-1-phil@nwl.cc>
References: <20210602152403.5689-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The call to strncpy() is actually not needed: source buffer is only
IFNAMSIZ bytes large and guaranteed to be null-terminated. Use this to
avoid compiler warnings due to size parameter matching the destination
buffer size by performing the copy using (dumb) memcpy() instead.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-ipv4.c | 4 ++--
 iptables/nft-ipv6.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index a5b835b1f681d..34f94bd8cc24a 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -348,11 +348,11 @@ static void nft_ipv4_post_parse(int command,
 	 */
 	cs->fw.ip.invflags = args->invflags;
 
-	strncpy(cs->fw.ip.iniface, args->iniface, IFNAMSIZ);
+	memcpy(cs->fw.ip.iniface, args->iniface, IFNAMSIZ);
 	memcpy(cs->fw.ip.iniface_mask,
 	       args->iniface_mask, IFNAMSIZ*sizeof(unsigned char));
 
-	strncpy(cs->fw.ip.outiface, args->outiface, IFNAMSIZ);
+	memcpy(cs->fw.ip.outiface, args->outiface, IFNAMSIZ);
 	memcpy(cs->fw.ip.outiface_mask,
 	       args->outiface_mask, IFNAMSIZ*sizeof(unsigned char));
 
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 46008fc5e762a..d9c9400ad7dc3 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -293,11 +293,11 @@ static void nft_ipv6_post_parse(int command, struct iptables_command_state *cs,
 	 */
 	cs->fw6.ipv6.invflags = args->invflags;
 
-	strncpy(cs->fw6.ipv6.iniface, args->iniface, IFNAMSIZ);
+	memcpy(cs->fw6.ipv6.iniface, args->iniface, IFNAMSIZ);
 	memcpy(cs->fw6.ipv6.iniface_mask,
 	       args->iniface_mask, IFNAMSIZ*sizeof(unsigned char));
 
-	strncpy(cs->fw6.ipv6.outiface, args->outiface, IFNAMSIZ);
+	memcpy(cs->fw6.ipv6.outiface, args->outiface, IFNAMSIZ);
 	memcpy(cs->fw6.ipv6.outiface_mask,
 	       args->outiface_mask, IFNAMSIZ*sizeof(unsigned char));
 
-- 
2.31.1

