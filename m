Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78880C54EE9
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Sep 2022 16:36:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbiITQgB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Sep 2022 12:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbiITQf7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Sep 2022 12:35:59 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9176C65816
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Sep 2022 09:35:58 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oagE0-00013m-MX; Tue, 20 Sep 2022 18:35:56 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Bruno de Paula Larini <bruno.larini@riosoft.com.br>
Subject: [PATCH nf] netfilter: nf_ct_ftp: fix deadlock when nat rewrite is needed
Date:   Tue, 20 Sep 2022 18:35:50 +0200
Message-Id: <20220920163550.5394-1-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <b2f301f6-d335-04bd-43b2-001e5dcacc09@riosoft.com.br>
References: <b2f301f6-d335-04bd-43b2-001e5dcacc09@riosoft.com.br>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We can't use ct->lock, this is already used by the seqadj internals.
When using ftp helper + nat, seqadj will attempt to acquire ct->lock
again.

Revert back to a global lock for now.

Fixes: c783a29c7e59 ("netfilter: nf_ct_ftp: prefer skb_linearize")
Reported-by: Bruno de Paula Larini <bruno.larini@riosoft.com.br>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_ftp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 0d9332e9cf71..617f744a2e3a 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -33,6 +33,7 @@ MODULE_AUTHOR("Rusty Russell <rusty@rustcorp.com.au>");
 MODULE_DESCRIPTION("ftp connection tracking helper");
 MODULE_ALIAS("ip_conntrack_ftp");
 MODULE_ALIAS_NFCT_HELPER(HELPER_NAME);
+static DEFINE_SPINLOCK(nf_ftp_lock);
 
 #define MAX_PORTS 8
 static u_int16_t ports[MAX_PORTS];
@@ -409,7 +410,8 @@ static int help(struct sk_buff *skb,
 	}
 	datalen = skb->len - dataoff;
 
-	spin_lock_bh(&ct->lock);
+	/* seqadj (nat) uses ct->lock internally, nf_nat_ftp would cause deadlock */
+	spin_lock_bh(&nf_ftp_lock);
 	fb_ptr = skb->data + dataoff;
 
 	ends_in_nl = (fb_ptr[datalen - 1] == '\n');
@@ -538,7 +540,7 @@ static int help(struct sk_buff *skb,
 	if (ends_in_nl)
 		update_nl_seq(ct, seq, ct_ftp_info, dir, skb);
  out:
-	spin_unlock_bh(&ct->lock);
+	spin_unlock_bh(&nf_ftp_lock);
 	return ret;
 }
 
-- 
2.35.1

