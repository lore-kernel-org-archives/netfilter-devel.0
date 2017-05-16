From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Re: [PATCH nf v2] ebtables: arpreply: Add the standard target
 sanity check
Date: Tue, 16 May 2017 11:55:19 +0200
Message-ID: <20170516095519.GA18958@salvia>
References: <1494898218-97426-1-git-send-email-gfree.wind@vip.163.com>
 <20170516082400.GA11114@salvia>
 <20170516094324.GA18427@salvia>
 <3fccf479.15f41.15c10ad983a.Coremail.gfree.wind@vip.163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stephen@networkplumber.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org
To: Gao Feng <gfree.wind@vip.163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:33423 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752246AbdEPJzZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 May 2017 05:55:25 -0400
Content-Disposition: inline
In-Reply-To: <3fccf479.15f41.15c10ad983a.Coremail.gfree.wind@vip.163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 16, 2017 at 05:53:51PM +0800, Gao Feng wrote:
> 
> At 2017-05-16 17:43:24, "Pablo Neira Ayuso" <pablo@netfilter.org> wrote:
> >On Tue, May 16, 2017 at 10:24:00AM +0200, Pablo Neira Ayuso wrote:
> >> On Tue, May 16, 2017 at 09:30:18AM +0800, gfree.wind@vip.163.com wrote:
> >> > From: Gao Feng <gfree.wind@vip.163.com>
> >> > 
> >> > The info->target is from userspace and it would be used directly.
> >> > So we need to add the sanity check to make sure it is a valid standard
> >> > target, although the ebtables tool has already checked it. Kernel need
> >> > to check anything from userspace.
> >> > 
> >> > If the target was set as an evil value, it would break the ebtables
> >> > and cause a panic. Because the non-standard target is treated as one
> >> > offset.
> >> > 
> >> > Now add one helper function ebt_invalid_target, and we would replace
> >> > the macro INVALID_TARGET later.
> >> 
> >> Applied, thanks.
> >> 
> >> There is a few bunch of spots that can use this indeed. Follow up with
> >> a patch for nf-next once merge window opens up.
> 
> I would pay some attention when nf is merged into nf-next.

Thanks.

> >Please, use:
> >
> >netfilter: ...
> >
> >as you initial patch subject next time...
> 
> OK. I thought the ebtables codes should use prefix "ebtables: ", and I checked it with git log.
> There were some commits which uses "ebtables" as prefix.
> 
> Could I assume both of ebtables and arptables uses the netfilter as prefix?

We should converge to netfilter: extension: blah.
