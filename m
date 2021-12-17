Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D719C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Dec 2021 10:30:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235021AbhLQKaM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Dec 2021 05:30:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235089AbhLQKaJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Dec 2021 05:30:09 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C5F1C061746
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Dec 2021 02:30:09 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1myAV5-0005qi-UI; Fri, 17 Dec 2021 11:30:07 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v4 1/2] netfilter: conntrack: tag conntracks picked up in local out hook
Date:   Fri, 17 Dec 2021 11:29:56 +0100
Message-Id: <20211217102957.2999-2-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211217102957.2999-1-fw@strlen.de>
References: <20211217102957.2999-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This allows to identify flows that originate from local machine
in a followup patch.

It would be possible to make this a ->status bit instead.
For now I did not do that yet because I don't have a use-case for
exposing this info to userspace.

If one comes up the toggle can be replaced with a status bit.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v4: no changes

 include/net/netfilter/nf_conntrack.h | 1 +
 net/netfilter/nf_conntrack_core.c    | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index d24b0a34c8f0..871489df63c6 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -95,6 +95,7 @@ struct nf_conn {
 	unsigned long status;
 
 	u16		cpu;
+	u16		local_origin:1;
 	possible_net_t ct_net;
 
 #if IS_ENABLED(CONFIG_NF_NAT)
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index d7e313548066..bed0017cadb0 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1747,6 +1747,9 @@ resolve_normal_ct(struct nf_conn *tmpl,
 			return 0;
 		if (IS_ERR(h))
 			return PTR_ERR(h);
+
+		ct = nf_ct_tuplehash_to_ctrack(h);
+		ct->local_origin = state->hook == NF_INET_LOCAL_OUT;
 	}
 	ct = nf_ct_tuplehash_to_ctrack(h);
 
-- 
2.32.0

