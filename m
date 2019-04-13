Return-Path: <SRS0=eJXe=SP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B3D5C10F11
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Apr 2019 21:29:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E457D2147A
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Apr 2019 21:29:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbfDMV30 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 13 Apr 2019 17:29:26 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46392 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727042AbfDMV30 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 13 Apr 2019 17:29:26 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hFQDE-0000ny-JV; Sat, 13 Apr 2019 23:29:24 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: conntrack: fix build on 32bit arches
Date:   Sat, 13 Apr 2019 23:24:21 +0200
Message-Id: <20190413212421.31478-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

don't use hsiphash, it needs a hsiphash_key_t argument:
error: passing argument 3 of 'hsiphash' from incompatible pointer type

Reported-by: kbuild test robot <lkp@intel.com>
Fixes: 862ae3a4a07e4c22 ("netfilter: ctnetlink: don't use conntrack/expect object addresses as id")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Pablo, feel free to squash this with 862ae3a4a07e4c22.

 net/netfilter/nf_conntrack_core.c    | 8 ++------
 net/netfilter/nf_conntrack_netlink.c | 6 ++----
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index a966e69d68d9..3c48d44d6fff 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -474,17 +474,13 @@ u32 nf_ct_get_id(const struct nf_conn *ct)
 	a = (unsigned long)ct;
 	b = (unsigned long)ct->master ^ net_hash_mix(nf_ct_net(ct));
 	c = (unsigned long)ct->ext;
-
+	d = (unsigned long)siphash(&ct->tuplehash, sizeof(ct->tuplehash),
+				   &ct_id_seed);
 #ifdef CONFIG_64BIT
-	d = siphash(&ct->tuplehash, sizeof(ct->tuplehash), &ct_id_seed);
-
 	return siphash_4u64((u64)a, (u64)b, (u64)c, (u64)d, &ct_id_seed);
 #else
-	d = hsiphash(&ct->tuplehash, sizeof(ct->tuplehash), &ct_id_seed);
-
 	return siphash_4u32((u32)a, (u32)b, (u32)c, (u32)d, &ct_id_seed);
 #endif
-
 }
 EXPORT_SYMBOL_GPL(nf_ct_get_id);
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index f80fce25c673..805a277e456b 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2706,13 +2706,11 @@ static __be32 nf_expect_get_id(const struct nf_conntrack_expect *exp)
 	a = (unsigned long)exp;
 	b = (unsigned long)exp->helper;
 	c = (unsigned long)exp->master;
-#ifdef CONFIG_64BIT
-	d = siphash(&exp->tuple, sizeof(exp->tuple), &exp_id_seed);
+	d = (unsigned long)siphash(&exp->tuple, sizeof(exp->tuple), &exp_id_seed);
 
+#ifdef CONFIG_64BIT
 	return (__force __be32)siphash_4u64((u64)a, (u64)b, (u64)c, (u64)d, &exp_id_seed);
 #else
-	d = hsiphash(&exp->tuple, sizeof(exp->tuple), &exp_id_seed);
-
 	return (__force __be32)siphash_4u32((u32)a, (u32)b, (u32)c, (u32)d, &exp_id_seed);
 #endif
 }
-- 
2.21.0

