From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libxt_hashlimit: Do not print default
 timeout and burst
Date: Wed, 27 Dec 2017 12:13:26 +0100
Message-ID: <20171227111326.5aiqx4sf3oqf4zsy@salvia>
References: <20171219122716.19710-1-harshasharmaiitr@gmail.com>
 <20171219140119.xioa2io52yvofdws@salvia>
 <CANMOCy24sTwdjOJS3bM0jRQcN-5_8dFw+tvtaZ3Mzd7PRTm3Bg@mail.gmail.com>
 <20171226233104.GA3368@dimstar.local.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: nmalykh@bilim.com, rv@wallfire.org,
        netfilter-devel@vger.kernel.org,
        Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39894 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750817AbdL0LNc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Dec 2017 06:13:32 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F032EC1083
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Dec 2017 12:13:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C82F4FC5E3
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Dec 2017 12:13:29 +0100 (CET)
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
> Have to say I agree with Harsha on this. You need a logical flag to say whether
> a timeout was encountered.

Yes, but she's assuming you can iptables-translate to pass this global
flag between function, and that is not always the case.

So a simple hardcoded "if timeout equals X then don't print it" is
fair enough.

> Once this goes through, I'll fix the wiki,

Thanks!
