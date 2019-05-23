Return-Path: <SRS0=SfI0=TX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78348C282DD
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 May 2019 13:43:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5428220881
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 May 2019 13:43:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730549AbfEWNn3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 May 2019 09:43:29 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:48818 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729698AbfEWNn3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 May 2019 09:43:29 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hTo0E-0007ir-4L; Thu, 23 May 2019 15:43:26 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/8] netfilter: bridge: convert skb_make_writable to skb_ensure_writable
Date:   Thu, 23 May 2019 15:44:05 +0200
Message-Id: <20190523134412.3295-2-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523134412.3295-1-fw@strlen.de>
References: <20190523134412.3295-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Back in the day, skb_ensure_writable did not exist.  By now, both functions
have the same precondition:

I. skb_make_writable will test in this order:
  1. wlen > skb->len -> error
  2. if not cloned and wlen <= headlen -> OK
  3. If cloned and wlen bytes of clone writeable -> OK

After those checks, skb is either not cloned but needs to pull from
nonlinear area, or writing to head would also alter data of another clone.

In both cases skb_make_writable will then call __pskb_pull_tail, which will
kmalloc a new memory area to use for skb->head.

IOW, after successful skb_make_writable call, the requested length is in
linear area and can be modified, even if skb was cloned.

II. skb_ensure_writable will do this instead:
   1. call pskb_may_pull.  This handles case 1 above.
      After this, wlen is in linear area, but skb might be cloned.
   2. return if skb is not cloned
   3. return if wlen byte of clone are writeable.
   4. fully copy the skb.

So post-conditions are the same:
*len bytes are writeable in linear area without altering any payload data
of a clone, all header pointers might have been changed.

Only differences are that skb_ensure_writable is in the core, whereas
skb_make_writable lives in netfilter core and the inverted return value.
skb_make_writable returns 0 on error, whereas skb_ensure_writable returns
negative value.

For the normal cases performance is similar:
A. skb is not cloned and in linear area:
   pskb_may_pull is inline helper, so neither function copies.
B. skb is cloned, write is in linear area and clone is writeable:
   both funcions return with step 3.

This series removes skb_make_writable from the kernel.

While at it, pass the needed value instead, its less confusing that way:
There is no special-handling of "0-length" argument in either
skb_make_writable or skb_ensure_writable.

bridge already makes sure ethernet header is in linear area, only purpose
of the make_writable() is is to copy skb->head in case of cloned skbs.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/bridge/netfilter/ebt_dnat.c     | 2 +-
 net/bridge/netfilter/ebt_redirect.c | 2 +-
 net/bridge/netfilter/ebt_snat.c     | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bridge/netfilter/ebt_dnat.c b/net/bridge/netfilter/ebt_dnat.c
index dfc86a0199da..b501384e4f40 100644
--- a/net/bridge/netfilter/ebt_dnat.c
+++ b/net/bridge/netfilter/ebt_dnat.c
@@ -21,7 +21,7 @@ ebt_dnat_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	const struct ebt_nat_info *info = par->targinfo;
 	struct net_device *dev;
 
-	if (!skb_make_writable(skb, 0))
+	if (skb_ensure_writable(skb, ETH_ALEN))
 		return EBT_DROP;
 
 	ether_addr_copy(eth_hdr(skb)->h_dest, info->mac);
diff --git a/net/bridge/netfilter/ebt_redirect.c b/net/bridge/netfilter/ebt_redirect.c
index a7223eaf490b..ea09b83074f7 100644
--- a/net/bridge/netfilter/ebt_redirect.c
+++ b/net/bridge/netfilter/ebt_redirect.c
@@ -20,7 +20,7 @@ ebt_redirect_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct ebt_redirect_info *info = par->targinfo;
 
-	if (!skb_make_writable(skb, 0))
+	if (skb_ensure_writable(skb, ETH_ALEN))
 		return EBT_DROP;
 
 	if (xt_hooknum(par) != NF_BR_BROUTING)
diff --git a/net/bridge/netfilter/ebt_snat.c b/net/bridge/netfilter/ebt_snat.c
index 11cf9e9e9222..70c3c36be18a 100644
--- a/net/bridge/netfilter/ebt_snat.c
+++ b/net/bridge/netfilter/ebt_snat.c
@@ -21,7 +21,7 @@ ebt_snat_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct ebt_nat_info *info = par->targinfo;
 
-	if (!skb_make_writable(skb, 0))
+	if (skb_ensure_writable(skb, ETH_ALEN * 2))
 		return EBT_DROP;
 
 	ether_addr_copy(eth_hdr(skb)->h_source, info->mac);
-- 
2.21.0

