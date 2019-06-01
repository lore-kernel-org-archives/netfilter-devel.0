Return-Path: <SRS0=MWc4=UA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A48B2C28CC3
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Jun 2019 18:24:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E9C627780
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Jun 2019 18:24:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbfFASYi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 1 Jun 2019 14:24:38 -0400
Received: from mail.us.es ([193.147.175.20]:40052 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726744AbfFASYH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Jun 2019 14:24:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D4107B60F8
        for <netfilter-devel@vger.kernel.org>; Sat,  1 Jun 2019 20:24:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C112FDA702
        for <netfilter-devel@vger.kernel.org>; Sat,  1 Jun 2019 20:24:00 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C8E21DA737; Sat,  1 Jun 2019 20:23:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0893DDA716;
        Sat,  1 Jun 2019 20:23:53 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 01 Jun 2019 20:23:52 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.178.197])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 9EF464265A32;
        Sat,  1 Jun 2019 20:23:52 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 07/15] netfilter: bridge: convert skb_make_writable to skb_ensure_writable
Date:   Sat,  1 Jun 2019 20:23:32 +0200
Message-Id: <20190601182340.2662-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190601182340.2662-1-pablo@netfilter.org>
References: <20190601182340.2662-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/ebt_dnat.c     | 2 +-
 net/bridge/netfilter/ebt_redirect.c | 2 +-
 net/bridge/netfilter/ebt_snat.c     | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bridge/netfilter/ebt_dnat.c b/net/bridge/netfilter/ebt_dnat.c
index eeae23a73c6a..ed91ea31978a 100644
--- a/net/bridge/netfilter/ebt_dnat.c
+++ b/net/bridge/netfilter/ebt_dnat.c
@@ -22,7 +22,7 @@ ebt_dnat_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	const struct ebt_nat_info *info = par->targinfo;
 	struct net_device *dev;
 
-	if (!skb_make_writable(skb, 0))
+	if (skb_ensure_writable(skb, ETH_ALEN))
 		return EBT_DROP;
 
 	ether_addr_copy(eth_hdr(skb)->h_dest, info->mac);
diff --git a/net/bridge/netfilter/ebt_redirect.c b/net/bridge/netfilter/ebt_redirect.c
index 53ef08e6765f..0cad62a4052b 100644
--- a/net/bridge/netfilter/ebt_redirect.c
+++ b/net/bridge/netfilter/ebt_redirect.c
@@ -21,7 +21,7 @@ ebt_redirect_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct ebt_redirect_info *info = par->targinfo;
 
-	if (!skb_make_writable(skb, 0))
+	if (skb_ensure_writable(skb, ETH_ALEN))
 		return EBT_DROP;
 
 	if (xt_hooknum(par) != NF_BR_BROUTING)
diff --git a/net/bridge/netfilter/ebt_snat.c b/net/bridge/netfilter/ebt_snat.c
index 700d338d5ddb..27443bf229a3 100644
--- a/net/bridge/netfilter/ebt_snat.c
+++ b/net/bridge/netfilter/ebt_snat.c
@@ -22,7 +22,7 @@ ebt_snat_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct ebt_nat_info *info = par->targinfo;
 
-	if (!skb_make_writable(skb, 0))
+	if (skb_ensure_writable(skb, ETH_ALEN * 2))
 		return EBT_DROP;
 
 	ether_addr_copy(eth_hdr(skb)->h_source, info->mac);
-- 
2.11.0

