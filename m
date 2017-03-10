From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH 4/5] fib: Support existence check
Date: Fri, 10 Mar 2017 22:41:50 +0100
Message-ID: <20170310214150.GA19768@orbyte.nwl.cc>
References: <20170310171353.28868-1-phil@nwl.cc>
 <20170310171353.28868-5-phil@nwl.cc>
 <20170310180725.GB25458@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:55813 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755050AbdCJVlx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Mar 2017 16:41:53 -0500
Content-Disposition: inline
In-Reply-To: <20170310180725.GB25458@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Fri, Mar 10, 2017 at 07:07:25PM +0100, Pablo Neira Ayuso wrote:
> On Fri, Mar 10, 2017 at 06:13:52PM +0100, Phil Sutter wrote:
> [...]
> > diff --git a/tests/py/inet/fib.t.payload b/tests/py/inet/fib.t.payload
> > index f5258165384dc..e928a19649133 100644
> > --- a/tests/py/inet/fib.t.payload
> > +++ b/tests/py/inet/fib.t.payload
> > @@ -20,3 +20,13 @@ __map%d test-ip 0
> >  ip test-ip prerouting
> >    [ fib daddr . iif type => reg 1 ]
> >    [ lookup reg 1 set __map%d dreg 0 ]
> > +
> > +# fib daddr oif exists
> > +ip test-ip prerouting
> > +  [ fib daddr oif => reg 1 ]
> 
> Instead of casting out the flag like this:
> 
> @@ -173,7 +173,7 @@  nftnl_expr_fib_snprintf_default(char *buf, size_t size,
>  {
>         struct nftnl_expr_fib *fib = nftnl_expr_data(e);
>         int len = size, offset = 0, ret, i;
> -       uint32_t flags = fib->flags;
> +       uint32_t flags = fib->flags & ~NFTA_FIB_F_PRESENT;
>         static const struct {
>                 int bit;
>                 const char *name;
> 
> I think it would be better if we have a different fib output for the
> present case, eg.
> 
>         [ fib daddr oif present => reg 1 ]

Yes, this is a good point! Thanks for suggesting the output format - I
was tempted to adjust it but had no good idea and so left it as-is. And
indeed, exthdr netlink debug output hiding the existence check detail is
ugly as well.

I'll implement the missing bits and then respin, including the man page
patch - so no need to apply it now.

Thanks, Phil
