Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89680C43460
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Apr 2021 09:05:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BA016044F
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Apr 2021 09:05:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbhDHJFM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Apr 2021 05:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbhDHJFM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Apr 2021 05:05:12 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB00C061761
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Apr 2021 02:05:01 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lUQax-0005sY-EH; Thu, 08 Apr 2021 11:04:59 +0200
Date:   Thu, 8 Apr 2021 11:04:59 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Ali Abdallah <ali.abdallah@suse.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] conntrack_tcp: Reset the max ACK flag on SYN in ignore
 state
Message-ID: <20210408090459.GQ13699@breakpoint.cc>
References: <20210408061203.35kbl44elgz4resh@Fryzen495>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210408061203.35kbl44elgz4resh@Fryzen495>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ali Abdallah <ali.abdallah@suse.com> wrote:
> In ignore state, we let SYN goes in original, the server might respond
> with RST/ACK, and that RST packet is erroneously dropped because of the
> flag IP_CT_TCP_FLAG_MAXACK_SET being already set.
> ---
>  net/netfilter/nf_conntrack_proto_tcp.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
> index ec23330687a5..891a66e35afd 100644
> --- a/net/netfilter/nf_conntrack_proto_tcp.c
> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> @@ -963,6 +963,9 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
>  
>  			ct->proto.tcp.last_flags =
>  			ct->proto.tcp.last_wscale = 0;
> +			/* Reset the max ack flag so in case the server replies
> +			 * with RST/ACK it will be marked as an invalid rst */

"not be marked"?

> +			ct->proto.tcp.seen[dir].flags &= ~IP_CT_TCP_FLAG_MAXACK_SET;
>  			tcp_options(skb, dataoff, th, &seen);
>  			if (seen.flags & IP_CT_TCP_FLAG_WINDOW_SCALE) {
