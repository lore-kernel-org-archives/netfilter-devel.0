From: Duncan Roe <duncan_roe@optusnet.com.au>
Subject: Re: [PATCH] extensions: libxt_hashlimit: Do not print default
 timeout and burst
Date: Wed, 27 Dec 2017 21:07:12 +1100
Message-ID: <20171227100712.GB3299@dimstar.local.net>
References: <20171219122716.19710-1-harshasharmaiitr@gmail.com>
 <20171219140119.xioa2io52yvofdws@salvia>
 <CANMOCy24sTwdjOJS3bM0jRQcN-5_8dFw+tvtaZ3Mzd7PRTm3Bg@mail.gmail.com>
 <20171226233104.GA3368@dimstar.local.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Pablo Neira Ayuso <pablo@netfilter.org>, nmalykh@bilim.com,
        rv@wallfire.org, netfilter-devel@vger.kernel.org,
        Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:60875 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750947AbdL0KH0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Dec 2017 05:07:26 -0500
Received: from dimstar.local.net (c220-239-53-24.eburwd6.vic.optusnet.com.au [220.239.53.24])
        by mail108.syd.optusnet.com.au (Postfix) with SMTP id 2FB541A1A04
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Dec 2017 21:07:13 +1100 (AEDT)
Content-Disposition: inline
In-Reply-To: <20171226233104.GA3368@dimstar.local.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 27, 2017 at 10:31:04AM +1100, Duncan Roe wrote:
> On Tue, Dec 19, 2017 at 08:20:31PM +0530, Harsha Sharma wrote:
> > On Tue, Dec 19, 2017 at 7:31 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > On Tue, Dec 19, 2017 at 05:57:16PM +0530, Harsha Sharma wrote:
> > >> @@ -1340,7 +1345,9 @@ static int hashlimit_mt_xlate(struct xt_xlate *xl, const char *name,
> > >>       xt_xlate_add(xl, "flow table %s {", name);
> > >>       ret = hashlimit_mode_xlate(xl, cfg->mode, family,
> > >>                                  cfg->srcmask, cfg->dstmask);
> > >> -     xt_xlate_add(xl, " timeout %us limit rate", cfg->expire / 1000);
> > >> +     if (!XT_HASHLIMIT_BYTE_EXPIRE_DEFAULT)
> > >> +             xt_xlate_add(xl, " timeout %us", cfg->expire / 1000);
> > >
> > > Better print cfg->expire if only if the default timeout is set.
> > >
> > >         if (cfg->expire != XT_HASHLIMIT_XLATE_DEFAULT_TIMEOUT)
> > >                 ...
> > >
> > > Same thing for burst. Thanks.
> >
> > This would result into not printing the timeout 1s (default value)
> > even if user specifies it.
> > For e.g.
> > iptables-translate -A INPUT -m tcp -p tcp --dport 80 -m hashlimit
> > --hashlimit-above 200kb/s --hashlimit-mode srcip,dstport
> > --hashlimit-name http2 --hashlimit-htable-expire 1000 -j DROP
> > nft add rule ip filter INPUT tcp dport 80 flow table http2 { tcp dport
> > . ip saddr limit rate over 200 kbytes/second} counter drop
> >
> > and the expected output is
> > nft add rule ip filter INPUT tcp dport 80 flow table http2 { tcp dport
> > . ip saddr timeout 1s limit rate over 200 kbytes/second} counter drop
> > (This patch allows this.)
> > I hope this makes sense and same for burst.
> > Thanks a lot for the review.
> >
> Have to say I agree with Harsha on this. You need a logical flag to say
> whether a timeout was encountered.
>
> Once this goes through, I'll fix the wiki,
>

In the original patch, I would prefer

 int XT_HASHLIMIT_BYTE_EXPIRE_DEFAULT = 0;
                                     ^^^^
although rather to my surprise there was no compiler warning without the
initialiser, and the 3 iptables-translate examples from the wiki all worked
either way.

Can we maybe fix the int decl and go with it?

Cheers ... Duncan.
