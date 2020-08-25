Return-Path: <SRS0=A2+c=CD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA18EC433DF
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Aug 2020 22:07:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8733B20706
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Aug 2020 22:07:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgHYWHj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Aug 2020 18:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgHYWHi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Aug 2020 18:07:38 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94360C061574
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Aug 2020 15:07:38 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1kAh6G-0005u7-Hr; Wed, 26 Aug 2020 00:07:28 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: conntrack: do not auto-delete clash entries on reply
Date:   Wed, 26 Aug 2020 00:07:18 +0200
Message-Id: <20200825220718.12866-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Its possible that we have more than one packet with the same ct tuple
simultaneously, e.g. when an application emits n packets on same UDP
socket from multiple threads.

NAT rules might be applied to those packets. With the right set of rules,
n packets will be mapped to m destinations, where at least two packets end
up with the same destination.

When this happens, the existing clash resolution may merge the skb that
is processed after the first has been received with the identical tuple
already in hash table.

However, its possible that this identical tuple is a NAT_CLASH tuple.
In that case the second skb will be sent, but no reply can be received
since the reply that is processed first removes the NAT_CLASH tuple.

Do not auto-delete, this gives a 1 second window for replies to be passed
back to originator.

Packets that are coming later (udp stream case) will not be affected:
they match the original ct entry, not a NAT_CLASH one.

Also prevent NAT_CLASH entries from getting offloaded.

Fixes: 6a757c07e51f ("netfilter: conntrack: allow insertion of clashing entries")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_proto_udp.c | 26 ++++++++++----------------
 net/netfilter/nft_flow_offload.c       |  2 +-
 2 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 760ca2422816..af402f458ee0 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -81,18 +81,6 @@ static bool udp_error(struct sk_buff *skb,
 	return false;
 }
 
-static void nf_conntrack_udp_refresh_unreplied(struct nf_conn *ct,
-					       struct sk_buff *skb,
-					       enum ip_conntrack_info ctinfo,
-					       u32 extra_jiffies)
-{
-	if (unlikely(ctinfo == IP_CT_ESTABLISHED_REPLY &&
-		     ct->status & IPS_NAT_CLASH))
-		nf_ct_kill(ct);
-	else
-		nf_ct_refresh_acct(ct, ctinfo, skb, extra_jiffies);
-}
-
 /* Returns verdict for packet, and may modify conntracktype */
 int nf_conntrack_udp_packet(struct nf_conn *ct,
 			    struct sk_buff *skb,
@@ -124,12 +112,15 @@ int nf_conntrack_udp_packet(struct nf_conn *ct,
 
 		nf_ct_refresh_acct(ct, ctinfo, skb, extra);
 
+		/* never set ASSURED for IPS_NAT_CLASH, they time out soon */
+		if (unlikely((ct->status & IPS_NAT_CLASH)))
+			return NF_ACCEPT;
+
 		/* Also, more likely to be important, and not a probe */
 		if (!test_and_set_bit(IPS_ASSURED_BIT, &ct->status))
 			nf_conntrack_event_cache(IPCT_ASSURED, ct);
 	} else {
-		nf_conntrack_udp_refresh_unreplied(ct, skb, ctinfo,
-						   timeouts[UDP_CT_UNREPLIED]);
+		nf_ct_refresh_acct(ct, ctinfo, skb, timeouts[UDP_CT_UNREPLIED]);
 	}
 	return NF_ACCEPT;
 }
@@ -206,12 +197,15 @@ int nf_conntrack_udplite_packet(struct nf_conn *ct,
 	if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
 		nf_ct_refresh_acct(ct, ctinfo, skb,
 				   timeouts[UDP_CT_REPLIED]);
+
+		if (unlikely((ct->status & IPS_NAT_CLASH)))
+			return NF_ACCEPT;
+
 		/* Also, more likely to be important, and not a probe */
 		if (!test_and_set_bit(IPS_ASSURED_BIT, &ct->status))
 			nf_conntrack_event_cache(IPCT_ASSURED, ct);
 	} else {
-		nf_conntrack_udp_refresh_unreplied(ct, skb, ctinfo,
-						   timeouts[UDP_CT_UNREPLIED]);
+		nf_ct_refresh_acct(ct, ctinfo, skb, timeouts[UDP_CT_UNREPLIED]);
 	}
 	return NF_ACCEPT;
 }
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 3b9b97aa4b32..3a6c84fb2c90 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -102,7 +102,7 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	}
 
 	if (nf_ct_ext_exist(ct, NF_CT_EXT_HELPER) ||
-	    ct->status & IPS_SEQ_ADJUST)
+	    ct->status & (IPS_SEQ_ADJUST | IPS_NAT_CLASH))
 		goto out;
 
 	if (!nf_ct_is_confirmed(ct))
-- 
2.26.2

