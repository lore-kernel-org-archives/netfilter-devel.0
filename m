Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA1C2C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Mar 2022 10:05:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239190AbiCUKGd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Mar 2022 06:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346184AbiCUKGd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Mar 2022 06:06:33 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 618E053A56
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Mar 2022 03:05:08 -0700 (PDT)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8D25660212;
        Mon, 21 Mar 2022 11:02:26 +0100 (CET)
Date:   Mon, 21 Mar 2022 11:05:04 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, sven.auhagen@voleatech.de
Subject: Re: [PATCH nf-next] netfilter: nf_conntrack_tcp: preserve liberal
 flag in tcp options
Message-ID: <YjhN0CgoDaW8RTWi@salvia>
References: <20220321094205.63121-1-pablo@netfilter.org>
 <YjhJBGffCTEtOuB9@salvia>
 <YjhJeQsI5TWTNgI0@salvia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="i4NNPdTsRrFLgOew"
Content-Disposition: inline
In-Reply-To: <YjhJeQsI5TWTNgI0@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--i4NNPdTsRrFLgOew
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Mon, Mar 21, 2022 at 10:46:36AM +0100, Pablo Neira Ayuso wrote:
> On Mon, Mar 21, 2022 at 10:44:39AM +0100, Pablo Neira Ayuso wrote:
> > On Mon, Mar 21, 2022 at 10:42:05AM +0100, Pablo Neira Ayuso wrote:
> > > When tcp_options is called all flags are cleared.
> > > When the IP_CT_TCP_FLAG_BE_LIBERAL is set it should be preserved
> > > otherwise such connections will fail in the window check.
> > 
> > 
> > This patch completes 8437a6209f76 ("netfilter: nft_flow_offload: set liberal tracking mode for tcp")
> > 
> > I'm going to send v2 to add a wrapper function to update these flags,
> > so we do not accidentally reset IP_CT_TCP_FLAG_BE_LIBERAL.
> 
> Hm. Actually I don't see a clear way to add such wrapper function, so
> patch LGTM as is.

Maybe something like this patch that is attached by adding a more
explicit function that resets the window tracking without touch the
liberal flag, it might help to make it more evident to the reader.

--i4NNPdTsRrFLgOew
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0001-netfilter-nf_conntrack_tcp-preserve-liberal-flag-in-.patch"

From 4c42d6ca218a9b3da324224a027b753f6acb72c3 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 21 Mar 2022 10:40:07 +0100
Subject: [PATCH] netfilter: nf_conntrack_tcp: preserve liberal flag in tcp
 options

When tcp_options is called all flags are cleared.
When the IP_CT_TCP_FLAG_BE_LIBERAL is set it should be preserved
otherwise such connections will fail in the window check.

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index d1582b888c0d..8ec55cd72572 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -341,8 +341,8 @@ static void tcp_options(const struct sk_buff *skb,
 	if (!ptr)
 		return;
 
-	state->td_scale =
-	state->flags = 0;
+	state->td_scale = 0;
+	state->flags &= IP_CT_TCP_FLAG_BE_LIBERAL;
 
 	while (length > 0) {
 		int opcode=*ptr++;
@@ -862,6 +862,16 @@ static bool tcp_can_early_drop(const struct nf_conn *ct)
 	return false;
 }
 
+static void nf_ct_tcp_state_reset(struct ip_ct_tcp_state *state)
+{
+	state->td_end		= 0;
+	state->td_maxend	= 0;
+	state->td_maxwin	= 0;
+	state->td_maxack	= 0;
+	state->td_scale		= 0;
+	state->flags		&= IP_CT_TCP_FLAG_BE_LIBERAL;
+}
+
 /* Returns verdict for packet, or -1 for invalid. */
 int nf_conntrack_tcp_packet(struct nf_conn *ct,
 			    struct sk_buff *skb,
@@ -968,8 +978,7 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 			ct->proto.tcp.last_flags &= ~IP_CT_EXP_CHALLENGE_ACK;
 			ct->proto.tcp.seen[ct->proto.tcp.last_dir].flags =
 				ct->proto.tcp.last_flags;
-			memset(&ct->proto.tcp.seen[dir], 0,
-			       sizeof(struct ip_ct_tcp_state));
+			nf_ct_tcp_state_reset(&ct->proto.tcp.seen[dir]);
 			break;
 		}
 		ct->proto.tcp.last_index = index;
-- 
2.30.2


--i4NNPdTsRrFLgOew--
