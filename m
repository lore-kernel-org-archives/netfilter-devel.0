From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] netfilter: meta: secpath support
Date: Fri, 1 Dec 2017 14:07:47 +0100
Message-ID: <20171201130747.GD27820@breakpoint.cc>
References: <20171201124021.20973-1-fw@strlen.de>
 <20171201124021.20973-2-fw@strlen.de>
 <CAOkSjBjtc2EUCK5e-50uy6dvwPjhFdc91PyAe1_=cvDMRwMj9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:40948 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751874AbdLANJB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Dec 2017 08:09:01 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBjtc2EUCK5e-50uy6dvwPjhFdc91PyAe1_=cvDMRwMj9A@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Arturo Borrero Gonzalez <arturo@netfilter.org> wrote:
> > +       if (priv->key != NFT_META_SECPATH)
> > +               return 0;
> > +
> 
> Would it worth adding here something like this?
> 
> #ifnfdef CONFIG_XFRM
>             return -EOPNOTSUPP;
> #endif
> 
> I mean, if CONFIG_XFRM is not defined, then _get_eval() is doing nothing, right?

Right, I'll add it.
