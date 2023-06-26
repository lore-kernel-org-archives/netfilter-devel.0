Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02BB7EB64DA
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Jun 2023 15:16:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbjFZPQ5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Jun 2023 11:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbjFZPQ5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Jun 2023 11:16:57 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 21143109
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Jun 2023 08:16:56 -0700 (PDT)
Date:   Mon, 26 Jun 2023 17:16:53 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH nf v2] netfilter: conntrack: dccp: copy entire header to
 stack buffer, not just basic one
Message-ID: <ZJmr5T+mdi9WUsyp@calendula>
References: <20230621155653.11078-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230621155653.11078-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 21, 2023 at 05:56:53PM +0200, Florian Westphal wrote:
> Eric Dumazet says:
>   nf_conntrack_dccp_packet() has an unique:
> 
>   dh = skb_header_pointer(skb, dataoff, sizeof(_dh), &_dh);
> 
>   And nothing more is 'pulled' from the packet, depending on the content.
>   dh->dccph_doff, and/or dh->dccph_x ...)
>   So dccp_ack_seq() is happily reading stuff past the _dh buffer.
> 
> BUG: KASAN: stack-out-of-bounds in nf_conntrack_dccp_packet+0x1134/0x11c0
> Read of size 4 at addr ffff000128f66e0c by task syz-executor.2/29371
> [..]
> 
> Fix this by increasing the stack buffer to also include room for
> the extra sequence numbers and all the known dccp packet type headers,
> then pull again after the initial validation of the basic header.
> 
> While at it, mark packets invalid that lack 48bit sequence bit but
> where RFC says the type MUST use them.
> 
> Compile tested only.

Applied to nf.git, thanks
