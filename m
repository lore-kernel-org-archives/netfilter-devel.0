From: Duncan Roe <duncan_roe@optusnet.com.au>
Subject: Re: [PATCH] extensions: libxt_hashlimit: Do not print default
 timeout and burst
Date: Thu, 28 Dec 2017 08:38:31 +1100
Message-ID: <20171227213831.GA3301@dimstar.local.net>
References: <20171219122716.19710-1-harshasharmaiitr@gmail.com>
 <20171219140119.xioa2io52yvofdws@salvia>
 <CANMOCy24sTwdjOJS3bM0jRQcN-5_8dFw+tvtaZ3Mzd7PRTm3Bg@mail.gmail.com>
 <20171226233104.GA3368@dimstar.local.net>
 <20171227111326.5aiqx4sf3oqf4zsy@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: nmalykh@bilim.com, rv@wallfire.org,
        netfilter-devel@vger.kernel.org,
        Harsha Sharma <harshasharmaiitr@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:57276 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751871AbdL0Vio (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Dec 2017 16:38:44 -0500
Received: from dimstar.local.net (c220-239-53-24.eburwd6.vic.optusnet.com.au [220.239.53.24])
        by mail109.syd.optusnet.com.au (Postfix) with SMTP id 3F333D6573B
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Dec 2017 08:38:32 +1100 (AEDT)
Content-Disposition: inline
In-Reply-To: <20171227111326.5aiqx4sf3oqf4zsy@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 27, 2017 at 12:13:26PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Dec 27, 2017 at 10:31:04AM +1100, Duncan Roe wrote:
> > On Tue, Dec 19, 2017 at 08:20:31PM +0530, Harsha Sharma wrote:
> > > On Tue, Dec 19, 2017 at 7:31 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > On Tue, Dec 19, 2017 at 05:57:16PM +0530, Harsha Sharma wrote:
> > > >> @@ -1340,7 +1345,9 @@ static int hashlimit_mt_xlate(struct xt_xlate *xl, const char *name,
> > > >>       xt_xlate_add(xl, "flow table %s {", name);
> > > >>       ret = hashlimit_mode_xlate(xl, cfg->mode, family,
> > > >>                                  cfg->srcmask, cfg->dstmask);
> > > >> -     xt_xlate_add(xl, " timeout %us limit rate", cfg->expire / 1000);
> > > >> +     if (!XT_HASHLIMIT_BYTE_EXPIRE_DEFAULT)
> > > >> +             xt_xlate_add(xl, " timeout %us", cfg->expire / 1000);
> > > >
> > > > Better print cfg->expire if only if the default timeout is set.
> > > >
> > > >         if (cfg->expire != XT_HASHLIMIT_XLATE_DEFAULT_TIMEOUT)
> > > >                 ...
> > > >
> > > > Same thing for burst. Thanks.
> > >
> > > This would result into not printing the timeout 1s (default value)
> > > even if user specifies it.
> > > For e.g.
> > > iptables-translate -A INPUT -m tcp -p tcp --dport 80 -m hashlimit
> > > --hashlimit-above 200kb/s --hashlimit-mode srcip,dstport
> > > --hashlimit-name http2 --hashlimit-htable-expire 1000 -j DROP
> > > nft add rule ip filter INPUT tcp dport 80 flow table http2 { tcp dport
> > > . ip saddr limit rate over 200 kbytes/second} counter drop
> > >
> > > and the expected output is
> > > nft add rule ip filter INPUT tcp dport 80 flow table http2 { tcp dport
> > > . ip saddr timeout 1s limit rate over 200 kbytes/second} counter drop
> > > (This patch allows this.)
> > > I hope this makes sense and same for burst.
> > > Thanks a lot for the review.
> > >
> > Have to say I agree with Harsha on this. You need a logical flag to say whether
> > a timeout was encountered.
>
> Yes, but she's assuming you can iptables-translate to pass this global
> flag between function, and that is not always the case.
>
> So a simple hardcoded "if timeout equals X then don't print it" is
> fair enough.
>
Then I would make the default nonsensical, say 0 or -1,

Cheers ... Duncan.
