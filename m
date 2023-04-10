Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A15AC77B61
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Apr 2023 10:00:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbjDJKAB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Apr 2023 06:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjDJJ77 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Apr 2023 05:59:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A68DD
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Apr 2023 02:59:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFA46612FB
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Apr 2023 09:59:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3AC2C433D2;
        Mon, 10 Apr 2023 09:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681120798;
        bh=znur2yGCtJYQzBIRa0aW8PR+oKTkcnxljVrGS5sYXuI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jV1ZyQl99D6XRyIGNWYdQ/wfkBX/Arxkt9Zajys+KuX92m0sv9gQSg3OlgeVQSnAZ
         XaRGfYSLKpdGQmvWEDsSrtNqEALg6hbTfQZ8sxETsF6+A0kgDP9CGPZ7bnYzRvdpOF
         Qm69MC9NHqlwkZsoeL3brvSuZQB3N3gdu+lFlAevGbr3wDLlP477kOydarO8tH9IJ/
         qoiGN7LTjfpHjc4hFLCxDyxI2QvPlHTIDdi423IdHWhvrgRFa8xoMcseNkdHHNwCVu
         bclkn7SKlw85PXN+NnXc/uoObN4mnRtdtm9aUIRqUEOSBAErpHt4uzBF4bbuurK6sX
         wLcyH17bbu06A==
Date:   Mon, 10 Apr 2023 17:59:54 +0800
From:   Tzung-Bi Shih <tzungbi@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     kadlec@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        jiejiang@chromium.org, jasongustaman@chromium.org,
        garrick@chromium.org
Subject: Re: [PATCH] netfilter: conntrack: fix wrong ct->timeout value
Message-ID: <ZDPeGu4eznqw34VJ@google.com>
References: <20230410060935.253503-1-tzungbi@kernel.org>
 <ZDPJ2rHi5fOqu4ga@calendula>
 <ZDPXad/8beRw78yX@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDPXad/8beRw78yX@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Apr 10, 2023 at 11:31:21AM +0200, Pablo Neira Ayuso wrote:
> On Mon, Apr 10, 2023 at 10:33:32AM +0200, Pablo Neira Ayuso wrote:
> > On Mon, Apr 10, 2023 at 02:09:35PM +0800, Tzung-Bi Shih wrote:
> > > (struct nf_conn)->timeout is an interval before the conntrack
> > > confirmed.  After confirmed, it becomes a timestamp[1].
> > > 
> > > It is observed that timeout of an unconfirmed conntrack have been
> > > altered by calling ctnetlink_change_timeout().  As a result,
> > > `nfct_time_stamp` was wrongly added to `ct->timeout` twice[2].
> > > 
> > > Differentiate the 2 cases in all `ct->timeout` accesses.
> > 
> > You can just skip refreshing the timeout for unconfirmed conntrack
> > entries in ctnetlink_change_timeout().
> 
> Something like this patch probably?

Pardon me, I sent a v2[3] before seeing the message.

[3]: https://lore.kernel.org/netfilter-devel/20230410093454.853575-1-tzungbi@kernel.org/T/#u

> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index bfc3aaa2c872..6556f5f30844 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -2466,7 +2466,8 @@ static int ctnetlink_new_conntrack(struct sk_buff *skb,
>  
>  	err = -EEXIST;
>  	ct = nf_ct_tuplehash_to_ctrack(h);
> -	if (!(info->nlh->nlmsg_flags & NLM_F_EXCL)) {
> +	if (!(info->nlh->nlmsg_flags & NLM_F_EXCL) &&
> +	    nf_ct_is_confirmed(ct)) {
>  		err = ctnetlink_change_conntrack(ct, cda);
>  		if (err == 0) {
>  			nf_conntrack_eventmask_report((1 << IPCT_REPLY) |

The patch can't fix the issue we observed.

Here is the calling stack:
  ctnetlink_glue_parse
  [...]
  __sys_sendto
  __x64_sys_sendto
  [...]

It was on another path:
ctnetlink_glue_parse_ct() -> ctnetlink_change_timeout().

I guess we should skip it in ctnetlink_change_timeout().  Something like v2.
