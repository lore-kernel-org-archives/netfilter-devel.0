From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next v2] netfilter: connlimit: split xt_connlimit into
 front/backend
Date: Wed, 6 Dec 2017 08:34:26 +0100
Message-ID: <20171206073426.GA29475@breakpoint.cc>
References: <20171202094914.11364-1-fw@strlen.de>
 <CAG1aQhJFE3BLkUcOx+Eb2FiCz5xH5Ui8Q5RmnRw5Q6+rePk=Uw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Yi-Hung Wei <yihung.wei@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:34544 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753102AbdLFHfs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Dec 2017 02:35:48 -0500
Content-Disposition: inline
In-Reply-To: <CAG1aQhJFE3BLkUcOx+Eb2FiCz5xH5Ui8Q5RmnRw5Q6+rePk=Uw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Yi-Hung Wei <yihung.wei@gmail.com> wrote:
> Thanks for working on this patch.
> 
> > --- /dev/null
> > +++ b/include/net/netfilter/nf_conntrack_count.h
> > @@ -0,0 +1,13 @@
> Should it have something like the following in the header file?
> 
> #ifdef _NF_CONNTRACK_COUNT_H
> #define _NF_CONNTRACK_COUNT_H

I can add it, sure.

> > --- /dev/null
> > +++ b/net/netfilter/nf_conncount.c
> > +
> > +struct nf_conncount_data *nf_conncount_init(struct net *net, unsigned int family,
> > +                                           unsigned int keylen)
> > +{
> > +       struct nf_conncount_data *data;
> > +       int ret, i;
> > +
> > +       if (keylen % sizeof(u32) ||
> > +           keylen / sizeof(u32) > MAX_KEYLEN ||
> > +           keylen == 0)
> > +               return ERR_PTR(-EINVAL);
> Just wanna to check the case that if users want to count only by zone,
> since zone id is only 2 bytes, the user should claim 4 bytes as the
> keylen right?

Yes, I used jhash2 internally which requires input in u32-sized chunks.

> > +       ret = nf_ct_netns_get(net, family);
> > +       if (ret < 0)
> > +               return ERR_PTR(ret);
> > +
> > +       data = kmalloc(sizeof(*data), GFP_KERNEL);
> > +       if (!data)
> > +               return ERR_PTR(-ENOMEM);
> Should we call nf_ct_netns_put() in the error case?

Indeed, I'll fix this, thanks for the review!
