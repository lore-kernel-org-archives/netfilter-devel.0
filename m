Return-Path: <SRS0=/QgY=EH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AC3DC2D0A3
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Nov 2020 11:57:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1892120665
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Nov 2020 11:57:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbgKAL5I (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 1 Nov 2020 06:57:08 -0500
Received: from correo.us.es ([193.147.175.20]:47734 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726159AbgKAL5I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 1 Nov 2020 06:57:08 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AD637819A5
        for <netfilter-devel@vger.kernel.org>; Sun,  1 Nov 2020 12:57:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9E7CFDA722
        for <netfilter-devel@vger.kernel.org>; Sun,  1 Nov 2020 12:57:06 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 93F5FDA789; Sun,  1 Nov 2020 12:57:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3C085DA722
        for <netfilter-devel@vger.kernel.org>; Sun,  1 Nov 2020 12:57:04 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 01 Nov 2020 12:57:04 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 2838B41FF20E
        for <netfilter-devel@vger.kernel.org>; Sun,  1 Nov 2020 12:57:04 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v2] netfilter: nft_reject_inet: allow to use reject from inet ingress
Date:   Sun,  1 Nov 2020 12:57:00 +0100
Message-Id: <20201101115700.21702-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Enhance validation to support for reject from inet ingress chains.

Note that, reject from inet ingress and netdev ingress differ.

Reject packets from inet ingress are sent through ip_local_out() since
inet reject emulates the IP layer receive path. So the reject packet
follows to classic IP output and postrouting paths.

The reject action from netdev ingress assumes the packet not yet entered
the IP layer, so the reject packet is sent through dev_queue_xmit().
Therefore, reject packets from netdev ingress do not follow the classic
IP output and postrouting paths.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: missing route lookup in nf_reject_ipv4 and nf_reject_ipv6.

 net/ipv4/netfilter/nf_reject_ipv4.c |  6 ++++--
 net/ipv6/netfilter/nf_reject_ipv6.c |  5 +++--
 net/netfilter/nft_reject_inet.c     | 14 +++++++++++++-
 3 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 8ca99342879c..04e5e0bfd86a 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -246,7 +246,8 @@ void nf_send_reset(struct net *net, struct sk_buff *oldskb, int hook)
 	if (!oth)
 		return;
 
-	if (hook == NF_INET_PRE_ROUTING && nf_reject_fill_skb_dst(oldskb))
+	if ((hook == NF_INET_PRE_ROUTING || hook == NF_INET_INGRESS) &&
+	    nf_reject_fill_skb_dst(oldskb) < 0)
 		return;
 
 	if (skb_rtable(oldskb)->rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))
@@ -315,7 +316,8 @@ void nf_send_unreach(struct sk_buff *skb_in, int code, int hook)
 	if (iph->frag_off & htons(IP_OFFSET))
 		return;
 
-	if (hook == NF_INET_PRE_ROUTING && nf_reject_fill_skb_dst(skb_in))
+	if ((hook == NF_INET_PRE_ROUTING || hook == NF_INET_INGRESS) &&
+	    nf_reject_fill_skb_dst(skb_in) < 0)
 		return;
 
 	if (skb_csum_unnecessary(skb_in) || !nf_reject_verify_csum(proto)) {
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index 8dcceda6c32a..aa35e6e37c1f 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -304,7 +304,7 @@ void nf_send_reset6(struct net *net, struct sk_buff *oldskb, int hook)
 	fl6.fl6_sport = otcph->dest;
 	fl6.fl6_dport = otcph->source;
 
-	if (hook == NF_INET_PRE_ROUTING) {
+	if (hook == NF_INET_PRE_ROUTING || hook == NF_INET_INGRESS) {
 		nf_ip6_route(net, &dst, flowi6_to_flowi(&fl6), false);
 		if (!dst)
 			return;
@@ -402,7 +402,8 @@ void nf_send_unreach6(struct net *net, struct sk_buff *skb_in,
 	if (hooknum == NF_INET_LOCAL_OUT && skb_in->dev == NULL)
 		skb_in->dev = net->loopback_dev;
 
-	if (hooknum == NF_INET_PRE_ROUTING && nf_reject6_fill_skb_dst(skb_in))
+	if ((hooknum == NF_INET_PRE_ROUTING || hooknum == NF_INET_INGRESS) &&
+	    nf_reject6_fill_skb_dst(skb_in) < 0)
 		return;
 
 	icmpv6_send(skb_in, ICMPV6_DEST_UNREACH, code, 0);
diff --git a/net/netfilter/nft_reject_inet.c b/net/netfilter/nft_reject_inet.c
index ffd1aa1f9576..32f3ea398ddf 100644
--- a/net/netfilter/nft_reject_inet.c
+++ b/net/netfilter/nft_reject_inet.c
@@ -58,6 +58,18 @@ static void nft_reject_inet_eval(const struct nft_expr *expr,
 	regs->verdict.code = NF_DROP;
 }
 
+static int nft_reject_inet_validate(const struct nft_ctx *ctx,
+				    const struct nft_expr *expr,
+				    const struct nft_data **data)
+{
+	return nft_chain_validate_hooks(ctx->chain,
+					(1 << NF_INET_LOCAL_IN) |
+					(1 << NF_INET_FORWARD) |
+					(1 << NF_INET_LOCAL_OUT) |
+					(1 << NF_INET_PRE_ROUTING) |
+					(1 << NF_INET_INGRESS));
+}
+
 static struct nft_expr_type nft_reject_inet_type;
 static const struct nft_expr_ops nft_reject_inet_ops = {
 	.type		= &nft_reject_inet_type,
@@ -65,7 +77,7 @@ static const struct nft_expr_ops nft_reject_inet_ops = {
 	.eval		= nft_reject_inet_eval,
 	.init		= nft_reject_init,
 	.dump		= nft_reject_dump,
-	.validate	= nft_reject_validate,
+	.validate	= nft_reject_inet_validate,
 };
 
 static struct nft_expr_type nft_reject_inet_type __read_mostly = {
-- 
2.20.1

