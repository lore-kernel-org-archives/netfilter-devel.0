Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A3DDC6FA91
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Sep 2022 07:39:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbiIUHjB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Sep 2022 03:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbiIUHi7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Sep 2022 03:38:59 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B70AC83F29;
        Wed, 21 Sep 2022 00:38:58 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oauJs-0005SB-Ry; Wed, 21 Sep 2022 09:38:56 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     netfilter-devel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>,
        Bruno de Paula Larini <bruno.larini@riosoft.com.br>
Subject: [PATCH net 5/5] netfilter: nf_ct_ftp: fix deadlock when nat rewrite is needed
Date:   Wed, 21 Sep 2022 09:38:25 +0200
Message-Id: <20220921073825.4658-6-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220921073825.4658-1-fw@strlen.de>
References: <20220921073825.4658-1-fw@strlen.de>
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

