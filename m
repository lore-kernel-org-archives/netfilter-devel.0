Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 401A1C25B0E
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Aug 2022 13:16:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbiHINQ5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Aug 2022 09:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239452AbiHINQ4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Aug 2022 09:16:56 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19FA712ADE
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Aug 2022 06:16:56 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oLP6M-0006Ey-GZ; Tue, 09 Aug 2022 15:16:54 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     alexanderduyck@fb.com, edumazet@google.com,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 3/4] netfilter: conntrack_ftp: prefer skb_linearize
Date:   Tue,  9 Aug 2022 15:16:34 +0200
Message-Id: <20220809131635.3376-4-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220809131635.3376-1-fw@strlen.de>
References: <20220809131635.3376-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This uses a pseudo-linearization scheme with a 64k global buffer,
but BIG TCP arrival means IPv6 TCP stack can generate skbs
that exceed this size.

Use skb_linearize.  It should be possible to rewrite this to properly
deal with segmented skbs (i.e., only do small chunk-wise accesses),
but this is going to be a lot more intrusive than this because every
helper function needs to get the sk_buff instead of a pointer to a raw
data buffer.

In practice, provided we're really looking at FTP control channel packets,
there should never be a case where we deal with huge packets.

Fixes: 7c4e983c4f3c ("net: allow gso_max_size to exceed 65536")
Fixes: 0fe79f28bfaf ("net: allow gro_max_size to exceed 65536")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_ftp.c | 24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index a414274338cf..0d9332e9cf71 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -34,11 +34,6 @@ MODULE_DESCRIPTION("ftp connection tracking helper");
 MODULE_ALIAS("ip_conntrack_ftp");
 MODULE_ALIAS_NFCT_HELPER(HELPER_NAME);
 
-/* This is slow, but it's simple. --RR */
-static char *ftp_buffer;
-
-static DEFINE_SPINLOCK(nf_ftp_lock);
-
 #define MAX_PORTS 8
 static u_int16_t ports[MAX_PORTS];
 static unsigned int ports_c;
@@ -398,6 +393,9 @@ static int help(struct sk_buff *skb,
 		return NF_ACCEPT;
 	}
 
+	if (unlikely(skb_linearize(skb)))
+		return NF_DROP;
+
 	th = skb_header_pointer(skb, protoff, sizeof(_tcph), &_tcph);
 	if (th == NULL)
 		return NF_ACCEPT;
@@ -411,12 +409,8 @@ static int help(struct sk_buff *skb,
 	}
 	datalen = skb->len - dataoff;
 
-	spin_lock_bh(&nf_ftp_lock);
-	fb_ptr = skb_header_pointer(skb, dataoff, datalen, ftp_buffer);
-	if (!fb_ptr) {
-		spin_unlock_bh(&nf_ftp_lock);
-		return NF_ACCEPT;
-	}
+	spin_lock_bh(&ct->lock);
+	fb_ptr = skb->data + dataoff;
 
 	ends_in_nl = (fb_ptr[datalen - 1] == '\n');
 	seq = ntohl(th->seq) + datalen;
@@ -544,7 +538,7 @@ static int help(struct sk_buff *skb,
 	if (ends_in_nl)
 		update_nl_seq(ct, seq, ct_ftp_info, dir, skb);
  out:
-	spin_unlock_bh(&nf_ftp_lock);
+	spin_unlock_bh(&ct->lock);
 	return ret;
 }
 
@@ -571,7 +565,6 @@ static const struct nf_conntrack_expect_policy ftp_exp_policy = {
 static void __exit nf_conntrack_ftp_fini(void)
 {
 	nf_conntrack_helpers_unregister(ftp, ports_c * 2);
-	kfree(ftp_buffer);
 }
 
 static int __init nf_conntrack_ftp_init(void)
@@ -580,10 +573,6 @@ static int __init nf_conntrack_ftp_init(void)
 
 	NF_CT_HELPER_BUILD_BUG_ON(sizeof(struct nf_ct_ftp_master));
 
-	ftp_buffer = kmalloc(65536, GFP_KERNEL);
-	if (!ftp_buffer)
-		return -ENOMEM;
-
 	if (ports_c == 0)
 		ports[ports_c++] = FTP_PORT;
 
@@ -603,7 +592,6 @@ static int __init nf_conntrack_ftp_init(void)
 	ret = nf_conntrack_helpers_register(ftp, ports_c * 2);
 	if (ret < 0) {
 		pr_err("failed to register helpers\n");
-		kfree(ftp_buffer);
 		return ret;
 	}
 
-- 
2.35.1

