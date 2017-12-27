From: Duncan Roe <duncan_roe@optusnet.com.au>
Subject: Re: [RFC] Can someone please review my latest wiki update
Date: Wed, 27 Dec 2017 21:38:13 +1100
Message-ID: <20171227103813.GD3299@dimstar.local.net>
References: <20171216092210.GA22043@dimstar.local.net>
 <20171218094816.ejlo4swg67ywyomy@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Netfilter Development <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:50586 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750919AbdL0Mjn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Dec 2017 07:39:43 -0500
Received: from dimstar.local.net (c220-239-53-24.eburwd6.vic.optusnet.com.au [220.239.53.24])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id 7CF8A4245E1
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Dec 2017 21:38:14 +1100 (AEDT)
Content-Disposition: inline
In-Reply-To: <20171218094816.ejlo4swg67ywyomy@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Mon, Dec 18, 2017 at 10:48:16AM +0100, Pablo Neira Ayuso wrote:
> Hi Duncan,
>
> On Sat, Dec 16, 2017 at 08:22:10PM +1100, Duncan Roe wrote:
> > Hi,
> >
> > For those who contribute to the wiki:
> >
> > I updated
> > https://wiki.nftables.org/wiki-nftables/index.php/Flow_tables section
> > "Doing iptables hashlimit with nft" in light of trying the examples.
> >
> > There's more in the associated discussion page,
>
> "Notice also that the translator defaults --hashlimit-htable-expire and
> --hashlimit-burst to 1000 milliseconds and 5 packets respectively so
> ''timeout 1s'' and ''burst 5 packets'' are inserted. You may remove
> either or both of these if you wish."
>
> I think we can just skip printing default values in the translation, I
> mean, we can "fix" the translation instead.
>
> BTW, this reminds me we should also expose the missing options such as
> hashlimit-htable-max and hashlimit-htable-gcinterval, those can be
> exposed too, it just needs some code in nft, I'll add this to my TODO
> list.
>
> Let us know, thanks for reviewing documentation!

Since there's a patch in the works to fix these spurious defaults, would you
mind if I just left it until the fix is committed?

Cheers ... Duncan.
