From: Jiri Kosina <jikos@kernel.org>
Subject: Re: [PATCH v2] netfilter: nf_ct_helper: warn when not applying
 default helper assignment
Date: Wed, 1 Feb 2017 20:43:51 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1702012036110.4763@cbobk.fhfr.pm>
References: <alpine.LSU.2.20.1701240038080.25515@cbobk.fhfr.pm> <CA+55aFyDbDxcT+OjcxLxJ87MsFgNi0WWNoBSzZvWgA+yuQSXkg@mail.gmail.com> <20170124012859.GA6375@salvia> <alpine.LSU.2.20.1701240827240.25515@cbobk.fhfr.pm> <alpine.LSU.2.20.1701241115050.25515@cbobk.fhfr.pm>
 <CA+55aFxiM=GscZtvGkWnSfo3L4MTK0J6OFR5VbisZ1feTCBW9g@mail.gmail.com> <alpine.LSU.2.20.1701252136460.25515@cbobk.fhfr.pm> <20170201162704.GA3880@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        info@jablonka.cz, eric@regit.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46339 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750974AbdBATnz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Feb 2017 14:43:55 -0500
In-Reply-To: <20170201162704.GA3880@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 1 Feb 2017, Pablo Neira Ayuso wrote:

> > +{
> > +	struct nf_conntrack_helper *ret;
> > +
> > +	if (!net->ct.sysctl_auto_assign_helper) {
> > +		if (net->ct.auto_assign_helper_warned)
> > +			return NULL;
> > +		if (!find_auto_helper(ct))
> 
> This fits in one line, so I think no need for find_auto_helper(), look:

It does, but OTOH we're calling the lookup more than once, and that for me 
justifies extra function (with a descriptive name), so that we don't have 
to change multiple places in case the data structure changes in the 
future.

But I don't have a strong preference either way, so I'll change it.

> > +	if (!ret || net->ct.auto_assign_helper_warned)
> > +		return ret;
> > +	pr_info("nf_conntrack: automatic helper assignment is deprecated and it will "
> > +		"be removed soon. Use the iptables CT target to attach helpers "
> > +		" instead.\n");
> 
> You can probably remove this older message now if you prefer the new
> one you wrote, actually it's a bit redundant IMO.

Fair enough; we'll be issuing the warning in cases where actual "harm" 
would be caused, and that should be enough.

I'll trim down the CC list a little bit and submit v3 shortly.

Thanks,

-- 
Jiri Kosina
SUSE Labs

