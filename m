Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C61B0C433B4
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 May 2021 19:54:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87839613C9
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 May 2021 19:54:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234050AbhEETy5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 May 2021 15:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbhEETy5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 May 2021 15:54:57 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D0C9C061574
        for <netfilter-devel@vger.kernel.org>; Wed,  5 May 2021 12:53:59 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1leNal-000668-18; Wed, 05 May 2021 21:53:55 +0200
Date:   Wed, 5 May 2021 21:53:54 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Ali Abdallah <ali.abdallah@suse.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] Avoid potentially erroneos RST drop.
Message-ID: <YJL30q7mCUezag48@strlen.de>
References: <20210430093601.zibczc4cjnwx3qwn@Fryzen495>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210430093601.zibczc4cjnwx3qwn@Fryzen495>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ali Abdallah <ali.abdallah@suse.com> wrote:
> In ignore state, we let SYN goes in original, the server might respond
> with RST/ACK, and that RST packet is erroneously dropped because of the
> flag IP_CT_TCP_FLAG_MAXACK_SET being already set. So we reset the flag
> in this case.
> 
> Unfortunately that might not be enough, an out of order ACK in origin
> might reset it back, and we might end up again dropping a valid RST when
> the server responds with RST SEQ=0.
> 
> The patch disables also the RST check when we are not in established
> state and we receive an RST with SEQ=0 that is most likely a response to
> a SYN we had let it go through.

Ali, sorry for coming back to this again and again.

What do you think of this change?

Its an incremental change on top of your patch.

The only real change is that this will skip window check if
conntrack thinks connection is closing already.

In addition, tcp window check is skipped in that case.

This is supposed to expedite conntrack eviction in case of tuple reuse
by some nat/pat middlebox, or a peer that has lower timeouts than
conntrack before a port is re-used.

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -834,6 +834,22 @@ static noinline bool tcp_new(struct nf_conn *ct, const struct sk_buff *skb,
 	return true;
 }
 
+static bool tcp_can_early_drop(const struct nf_conn *ct)
+{
+	switch (ct->proto.tcp.state) {
+	case TCP_CONNTRACK_FIN_WAIT:
+	case TCP_CONNTRACK_LAST_ACK:
+	case TCP_CONNTRACK_TIME_WAIT:
+	case TCP_CONNTRACK_CLOSE:
+	case TCP_CONNTRACK_CLOSE_WAIT:
+		return true;
+	default:
+		break;
+	}
+
+	return false;
+}
+
 /* Returns verdict for packet, or -1 for invalid. */
 int nf_conntrack_tcp_packet(struct nf_conn *ct,
 			    struct sk_buff *skb,
@@ -1053,8 +1069,16 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 			/* If we are not in established state, and an RST is
 			 * observed with SEQ=0, this is most likely an answer
 			 * to a SYN we had let go through above.
+			 *
+			 * Also expedite conntrack destruction: If we were already
+			 * closing, peer or NAT/PAT might already have reused tuple.
 			 */
-			if (seq == 0 && !nf_conntrack_tcp_established(ct))
+			if (!nf_conntrack_tcp_established(ct)) {
+				if (seq == 0 || tcp_can_early_drop(ct))
+					goto in_window;
+			}
+
+			if (seq == ct->proto.tcp.seen[!dir].td_maxack)
 				break;
 
 			if (before(seq, ct->proto.tcp.seen[!dir].td_maxack)) {
@@ -1066,10 +1090,6 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 				return -NF_ACCEPT;
 			}
 
-			if (!nf_conntrack_tcp_established(ct) ||
-			    seq == ct->proto.tcp.seen[!dir].td_maxack)
-				break;
-
 			/* Check if rst is part of train, such as
 			 *   foo:80 > bar:4379: P, 235946583:235946602(19) ack 42
 			 *   foo:80 > bar:4379: R, 235946602:235946602(0)  ack 42
@@ -1181,22 +1201,6 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 	return NF_ACCEPT;
 }
 
-static bool tcp_can_early_drop(const struct nf_conn *ct)
-{
-	switch (ct->proto.tcp.state) {
-	case TCP_CONNTRACK_FIN_WAIT:
-	case TCP_CONNTRACK_LAST_ACK:
-	case TCP_CONNTRACK_TIME_WAIT:
-	case TCP_CONNTRACK_CLOSE:
-	case TCP_CONNTRACK_CLOSE_WAIT:
-		return true;
-	default:
-		break;
-	}
-
-	return false;
-}
-
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 
 #include <linux/netfilter/nfnetlink.h>
