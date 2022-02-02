Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F4E1C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Feb 2022 11:48:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232637AbiBBLsE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Feb 2022 06:48:04 -0500
Received: from mail.netfilter.org ([217.70.188.207]:44100 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231623AbiBBLsD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Feb 2022 06:48:03 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 0754860184;
        Wed,  2 Feb 2022 12:47:58 +0100 (CET)
Date:   Wed, 2 Feb 2022 12:48:00 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pham Thanh Tuyen <phamtyn@gmail.com>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: PROBLEM: Injected conntrack lost helper
Message-ID: <YfpvcDMUw6MJv8kr@salvia>
References: <f9fb5616-0b37-d76b-74e5-53751d473432@gmail.com>
 <3f416429-b1be-b51a-c4ef-6274def33258@iogearbox.net>
 <0f4edf58-7b4e-05e8-3f13-d34819b8d5db@gmail.com>
 <20220131112050.GQ25922@breakpoint.cc>
 <2ea7f9da-22be-17db-88d7-10738b95faf3@gmail.com>
 <YfkLnyQopoKnRU17@salvia>
 <20220201120454.GB18351@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220201120454.GB18351@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Feb 01, 2022 at 01:04:54PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Tue, Feb 01, 2022 at 10:08:55AM +0700, Pham Thanh Tuyen wrote:
> > > When the conntrack is created, the extension is created before the conntrack
> > > is assigned confirmed and inserted into the hash table. But the function
> > > ctnetlink_setup_nat() causes loss of helper in the mentioned situation. I
> > > mention the template because it's seamless in the
> > > __nf_ct_try_assign_helper() function. Please double check.
> > 
> > Conntrack entries that are created via ctnetlink as IPS_CONFIRMED always
> > set on.
> >
> > The helper code is only exercised from the packet path for conntrack
> > entries that are newly created.
> 
> I suspect this is the most simple fix, might make sense to also
> update the comment of IPS_HELPER to say that it means 'explicitly
> attached via ctnetlink or ruleset'.
> 
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -2313,6 +2313,9 @@ ctnetlink_create_conntrack(struct net *net,
>  
>  			/* not in hash table yet so not strictly necessary */
>  			RCU_INIT_POINTER(help->helper, helper);
> +
> +			/* explicitly attached from userspace */
> +			ct->status |= IPS_HELPER;
>  		}
>  	} else {
>  		/* try an implicit helper assignation */

This also LGTM.

I'd suggest you update the .h file to describe that ctnetlink also
sets on this bit.

Thanks
