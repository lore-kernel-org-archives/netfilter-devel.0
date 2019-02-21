Return-Path: <SRS0=37uZ=Q4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E780C43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Feb 2019 15:08:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 362372083B
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Feb 2019 15:08:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725920AbfBUPIx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Feb 2019 10:08:53 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:59918 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725858AbfBUPIw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Feb 2019 10:08:52 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1gwpxy-0004Kr-Qf; Thu, 21 Feb 2019 16:08:50 +0100
Date:   Thu, 21 Feb 2019 16:08:50 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: conntrack: avoid same-timeout update
Message-ID: <20190221150850.GS23745@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20190221143829.7252-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190221143829.7252-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Feb 21, 2019 at 03:38:29PM +0100, Florian Westphal wrote:
> No need to dirty a cache line if timeout is unchanged.
> Also, WARN() is useless here: we crash on 'skb->len' access
> if skb is NULL.
> 
> Last, ct->timeout is u32, not 'unsigned long' so adapt the
> function prototype accordingly.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/net/netfilter/nf_conntrack.h | 10 +++++-----
>  net/netfilter/nf_conntrack_core.c    |  9 ++++-----
>  2 files changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
> index b5aac5ae5129..2270ee5202e3 100644
> --- a/include/net/netfilter/nf_conntrack.h
> +++ b/include/net/netfilter/nf_conntrack.h
> @@ -190,23 +190,23 @@ bool nf_ct_get_tuplepr(const struct sk_buff *skb, unsigned int nhoff,
>  
>  void __nf_ct_refresh_acct(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
>  			  const struct sk_buff *skb,
> -			  unsigned long extra_jiffies, int do_acct);
> +			  u32, bool do_acct);

Maybe not worth a respin, but this mix of named and unnamed parameters
in function prototype is probably not intentional.

Cheers, Phil
