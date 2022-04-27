Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB72DC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Apr 2022 13:49:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236304AbiD0NwW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Apr 2022 09:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236554AbiD0NwT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Apr 2022 09:52:19 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 09061532FE
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2022 06:49:07 -0700 (PDT)
Date:   Wed, 27 Apr 2022 15:49:02 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, edumazet@google.com,
        ncardwell@google.com, Jaco Kroon <jaco@uls.co.za>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nf_conntrack_tcp: re-init for syn packets
 only
Message-ID: <YmlJzj82mBl77rCR@salvia>
References: <20220425094711.6255-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220425094711.6255-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Apr 25, 2022 at 11:47:11AM +0200, Florian Westphal wrote:
> Jaco Kroon reported tcp problems that Eric Dumazet and Neal Cardwell
> pinpointed to nf_conntrack tcp_in_window() bug.
> 
> tcp trace shows following sequence:
> 
> I > R Flags [S], seq 3451342529, win 62580, options [.. tfo [|tcp]>
> R > I Flags [S.], seq 2699962254, ack 3451342530, win 65535, options [..]
> R > I Flags [P.], seq 1:89, ack 1, [..]
> 
> Note 3rd ACK is from responder to initiator so following branch is taken:
>     } else if (((state->state == TCP_CONNTRACK_SYN_SENT
>                && dir == IP_CT_DIR_ORIGINAL)
>                || (state->state == TCP_CONNTRACK_SYN_RECV
>                && dir == IP_CT_DIR_REPLY))
>                && after(end, sender->td_end)) {
> 
> ... because state == TCP_CONNTRACK_SYN_RECV and dir is REPLY.
> This causes the scaling factor to be reset to 0: window scale option
> is only present in syn(ack) packets.  This in turn makes nf_conntrack
> mark valid packets as out-of-window.
> 
> This was always broken, it exists even in original commit where
> window tracking was added to ip_conntrack (nf_conntrack predecessor)
> in 2.6.9-rc1 kernel.
> 
> Restrict to 'tcph->syn', just like the 3rd condtional added in
> commit 82b72cb94666 ("netfilter: conntrack: re-init state for retransmitted syn-ack").
> 
> Upon closer look, those conditionals/branches can be merged:
> 
> Because earlier checks prevent syn-ack from showing up in
> original direction, the 'dir' checks in the conditional quoted above are
> redundant, remove them. Return early for pure syn retransmitted in reply
> direction (simultaneous open).

Applied, thanks
