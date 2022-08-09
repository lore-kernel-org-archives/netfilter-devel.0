Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3591C19F2D
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Aug 2022 13:17:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239161AbiHINRA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Aug 2022 09:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238858AbiHINQ6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Aug 2022 09:16:58 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7247C1209D
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Aug 2022 06:16:57 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oLP6N-0006F7-Lx; Tue, 09 Aug 2022 15:16:55 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     alexanderduyck@fb.com, edumazet@google.com,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 4/4] netfilter: conntrack_irc: cap packet search space to 4k
Date:   Tue,  9 Aug 2022 15:16:35 +0200
Message-Id: <20220809131635.3376-5-fw@strlen.de>
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

In practice, IRC commands are not expected to exceed 512 bytes, plus
this is interactive protocol, so we should not see large packets
in practice.

Given most IRC connections nowadays use TLS so this helper could also be
removed in the near future.

Fixes: 7c4e983c4f3c ("net: allow gso_max_size to exceed 65536")
Fixes: 0fe79f28bfaf ("net: allow gro_max_size to exceed 65536")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_irc.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 08ee4e760a3d..1796c456ac98 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -39,6 +39,7 @@ unsigned int (*nf_nat_irc_hook)(struct sk_buff *skb,
 EXPORT_SYMBOL_GPL(nf_nat_irc_hook);
 
 #define HELPER_NAME "irc"
+#define MAX_SEARCH_SIZE	4095
 
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_DESCRIPTION("IRC (DCC) connection tracking helper");
@@ -121,6 +122,7 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 	int i, ret = NF_ACCEPT;
 	char *addr_beg_p, *addr_end_p;
 	typeof(nf_nat_irc_hook) nf_nat_irc;
+	unsigned int datalen;
 
 	/* If packet is coming from IRC server */
 	if (dir == IP_CT_DIR_REPLY)
@@ -140,8 +142,12 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 	if (dataoff >= skb->len)
 		return NF_ACCEPT;
 
+	datalen = skb->len - dataoff;
+	if (datalen > MAX_SEARCH_SIZE)
+		datalen = MAX_SEARCH_SIZE;
+
 	spin_lock_bh(&irc_buffer_lock);
-	ib_ptr = skb_header_pointer(skb, dataoff, skb->len - dataoff,
+	ib_ptr = skb_header_pointer(skb, dataoff, datalen,
 				    irc_buffer);
 	if (!ib_ptr) {
 		spin_unlock_bh(&irc_buffer_lock);
@@ -149,7 +155,7 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 	}
 
 	data = ib_ptr;
-	data_limit = ib_ptr + skb->len - dataoff;
+	data_limit = ib_ptr + datalen;
 
 	/* strlen("\1DCC SENT t AAAAAAAA P\1\n")=24
 	 * 5+MINMATCHLEN+strlen("t AAAAAAAA P\1\n")=14 */
@@ -251,7 +257,7 @@ static int __init nf_conntrack_irc_init(void)
 	irc_exp_policy.max_expected = max_dcc_channels;
 	irc_exp_policy.timeout = dcc_timeout;
 
-	irc_buffer = kmalloc(65536, GFP_KERNEL);
+	irc_buffer = kmalloc(MAX_SEARCH_SIZE + 1, GFP_KERNEL);
 	if (!irc_buffer)
 		return -ENOMEM;
 
-- 
2.35.1

