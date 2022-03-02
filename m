Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C791FC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Mar 2022 10:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbiCBK75 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Mar 2022 05:59:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234663AbiCBK74 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Mar 2022 05:59:56 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACAF96E4FF
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2022 02:59:10 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nPMhI-0001xE-2k; Wed, 02 Mar 2022 11:59:08 +0100
Date:   Wed, 2 Mar 2022 11:59:08 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel <netfilter-devel@vger.kernel.org>,
        pablo@netfilter.org, kadlec@netfilter.org, hmmsjan@kpnplanet.nl
Subject: Re: TCP connection fails in a asymmetric routing situation
Message-ID: <20220302105908.GA5852@breakpoint.cc>
References: <20220225123030.GK28705@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220225123030.GK28705@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Florian Westphal <fw@strlen.de> wrote:
> 1. Change ct->local_origin to "ct->no_srcremap" (or a new status bit)
> that indicates that this should not have src remap done, just like we
> do for locally generated connections.
> 
> 2. Add a new "mid-stream" status bit, then bypass the entire -t nat
> logic if its set. nf_nat_core would create a null binding for the
> flow, this also bypasses the "src remap" code.
> 
> 3. Simpler version: from tcp conntrack, set the nat-done status bits
> if its a mid-stream pickup.
> 
> Downside: nat engine (as-is) won't create a null binding, so connection
> will not be known to nat engine for masquerade source port clash
> detection.
> 
> I would go for 2) unless you have a better suggestion/idea.

Something like this:

diff --git a/include/uapi/linux/netfilter/nf_conntrack_common.h b/include/uapi/linux/netfilter/nf_conntrack_common.h
--- a/include/uapi/linux/netfilter/nf_conntrack_common.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_common.h
@@ -118,15 +118,19 @@ enum ip_conntrack_status {
 	IPS_HW_OFFLOAD_BIT = 15,
 	IPS_HW_OFFLOAD = (1 << IPS_HW_OFFLOAD_BIT),
 
+	/* Connection started mid-transfer, origin/reply might be inversed */
+	IPS_MID_STREAM_BIT = 16,
+	IPS_MID_STREAM = (1 << IPS_MID_STREAM_BIT),
+
 	/* Be careful here, modifying these bits can make things messy,
 	 * so don't let users modify them directly.
 	 */
 	IPS_UNCHANGEABLE_MASK = (IPS_NAT_DONE_MASK | IPS_NAT_MASK |
 				 IPS_EXPECTED | IPS_CONFIRMED | IPS_DYING |
 				 IPS_SEQ_ADJUST | IPS_TEMPLATE | IPS_UNTRACKED |
-				 IPS_OFFLOAD | IPS_HW_OFFLOAD),
+				 IPS_OFFLOAD | IPS_HW_OFFLOAD | IPS_MID_STREAM_BIT),
 
-	__IPS_MAX_BIT = 16,
+	__IPS_MAX_BIT = 17,
 };
 
 /* Connection tracking event types */
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -537,6 +537,8 @@ static bool tcp_in_window(struct nf_conn *ct,
 			 * its history is lost for us.
 			 * Let's try to use the data from the packet.
 			 */
+			set_bit(IPS_MID_STREAM_BIT, &ct->status);
+
 			sender->td_end = end;
 			swin = win << sender->td_scale;
 			sender->td_maxwin = (swin == 0 ? 1 : swin);
@@ -816,6 +818,8 @@ static noinline bool tcp_new(struct nf_conn *ct, const struct sk_buff *skb,
 		 * its history is lost for us.
 		 * Let's try to use the data from the packet.
 		 */
+		set_bit(IPS_MID_STREAM_BIT, &ct->status);
+
 		ct->proto.tcp.seen[0].td_end =
 			segment_seq_plus_len(ntohl(th->seq), skb->len,
 					     dataoff, th);
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -545,6 +545,12 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
 
 	zone = nf_ct_zone(ct);
 
+	if (unlikely(test_bit(IPS_MID_STREAM_BIT, &ct->status))) {
+		/* Can't NAT if connection was picked up mid-stream (e.g. tcp) */
+		*tuple = *orig_tuple;
+		return;
+	}
+
 	if (maniptype == NF_NAT_MANIP_SRC &&
 	    !random_port &&
 	    !ct->local_origin)
@@ -781,7 +787,7 @@ nf_nat_inet_fn(void *priv, struct sk_buff *skb,
 			unsigned int ret;
 			int i;
 
-			if (!e)
+			if (!e || unlikely(test_bit(IPS_MID_STREAM_BIT, &ct->status)))
 				goto null_bind;
 
 			for (i = 0; i < e->num_hook_entries; i++) {
