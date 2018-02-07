From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 7/7] netfilter: x_tables: use pr ratelimiting in all
 remaining spots
Date: Wed, 7 Feb 2018 20:30:26 +0100
Message-ID: <20180207193026.y3jefe7c232so57i@salvia>
References: <20180207134828.18691-1-fw@strlen.de>
 <20180207134828.18691-8-fw@strlen.de>
 <20180207170052.x6n6kod2zld7wuqd@salvia>
 <20180207192323.GG14261@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54090 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753995AbeBGTab (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Feb 2018 14:30:31 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F1EC53066AE
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2018 20:30:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E2A4BDA727
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2018 20:30:29 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180207192323.GG14261@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 07, 2018 at 08:23:23PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > --- a/net/bridge/netfilter/ebt_among.c
> > > +++ b/net/bridge/netfilter/ebt_among.c
> > > @@ -187,17 +187,17 @@ static int ebt_among_mt_check(const struct xt_mtchk_param *par)
> > >  	expected_length += ebt_mac_wormhash_size(wh_src);
> > >  
> > >  	if (em->match_size != EBT_ALIGN(expected_length)) {
> > > -		pr_info("wrong size: %d against expected %d, rounded to %zd\n",
> > > -			em->match_size, expected_length,
> > > -			EBT_ALIGN(expected_length));
> > > +		pr_info_ratelimited("wrong size: %d against expected %d, rounded to %zd\n",
> > 
> > Shouldn't all these be pr_err_ratelimited instead?
> 
> Don't know.
> 
> This could even be pr_debug actually since this message is
> useless unless you're doing ebtables development work.

I see, I'm telling this because iptables says 'look at dmesg' when we
hit EINVAL, but there will be nothing.

[...]
> > >  	if (index == IPSET_INVALID_ID) {
> > > -		pr_warn("Cannot find set identified by id %u to match\n",
> > > -			info->match_set.index);
> > > +		pr_warn_ratelimited("Cannot find set identified by id %u to match\n",
> > > +				    info->match_set.index);
> > 
> > Use pr_err_ratelimited instead?
> 
> I think we should settle on a single pr_foo, i suggest
> pr_info(_ratelimited).

OK.

> This is not an error condition, we only have these
> printks because we can't return a proper error to userspace.
> 
> If this was netlink, it would be converted to extack instead...

Indeed, we have this primitive error reporting in iptables, we can do
better in nftables.

Thanks!
