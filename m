Return-Path: <SRS0=hXfx=ZH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBEF1C432C3
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Nov 2019 09:47:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A34120740
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Nov 2019 09:47:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbfKOJr3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Nov 2019 04:47:29 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:54728 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725829AbfKOJr3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Nov 2019 04:47:29 -0500
Received: from localhost ([::1]:39586 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iVYCN-0008Dy-Mj; Fri, 15 Nov 2019 10:47:27 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/2] nft: CMD_ZERO needs a rule cache
Date:   Fri, 15 Nov 2019 10:47:24 +0100
Message-Id: <20191115094725.19756-2-phil@nwl.cc>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191115094725.19756-1-phil@nwl.cc>
References: <20191115094725.19756-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In order to zero rule counters, they have to be fetched from kernel. Fix
this for both standalone calls as well as xtables-restore --noflush.

Fixes: b5cb6e631c828 ("nft-cache: Fetch only chains in nft_chain_list_get()")
Fixes: 09cb517949e69 ("xtables-restore: Improve performance of --noflush operation")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c             | 2 ++
 iptables/xtables-restore.c | 1 +
 2 files changed, 3 insertions(+)

diff --git a/iptables/nft.c b/iptables/nft.c
index 3c230c121f8b9..83cf5fb703d3e 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2922,6 +2922,8 @@ static int __nft_chain_zero_counters(struct nftnl_chain *c, void *data)
 			return -1;
 	}
 
+	nft_build_cache(h, c);
+
 	iter = nftnl_rule_iter_create(c);
 	if (iter == NULL)
 		return -1;
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 282aa153b1599..2f0fe7d439d94 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -268,6 +268,7 @@ static bool cmd_needs_full_cache(char *cmd)
 	case 'C':
 	case 'S':
 	case 'L':
+	case 'Z':
 		return true;
 	}
 
-- 
2.24.0

