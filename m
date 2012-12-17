From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Formal submission of Xtables2
Date: Tue, 18 Dec 2012 00:49:26 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1212172356530.16469@blackhole.kfki.hu>
References: <20121213142820.GA3489@1984> <alpine.LNX.2.01.1212131528410.1273@nerf07.vanv.qr> <20121213151615.GA6962@1984> <alpine.LNX.2.01.1212131623480.10856@nerf07.vanv.qr> <20121213172523.GB14333@1984> <alpine.LNX.2.01.1212131826040.5486@nerf07.vanv.qr>
 <20121217000841.GA9331@1984> <alpine.LNX.2.01.1212170214350.29351@nerf07.vanv.qr> <20121217095330.GA17148@1984> <alpine.LNX.2.01.1212171155090.25980@nerf07.vanv.qr> <20121217143018.GB1106@1984> <alpine.LNX.2.01.1212171936410.18910@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Netfilter user mailing list <netfilter@vger.kernel.org>,
	=?ISO-8859-2?Q?Maciej_=AFenczykowski?= <zenczykowski@gmail.com>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:41679 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650Ab2LQXt2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2012 18:49:28 -0500
In-Reply-To: <alpine.LNX.2.01.1212171936410.18910@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 17 Dec 2012, Jan Engelhardt wrote:

> On Monday 2012-12-17 15:30, Pablo Neira Ayuso wrote:
> 
> >On Mon, Dec 17, 2012 at 02:01:07PM +0100, Jan Engelhardt wrote:
> >[...]
> >> >So far, I haven't see any *strong reason* to drop nftables code
> >> 
> >> In all fairness, I have never said anything about dropping nft.
> >> I am focused on xt2, its inclusion and subsequent maintenance, because 
> >> it resolves the ipt shortcomings in a way that I think appeals most to 
> >> the userspace crowd.
> >
> >I'm still not convinced but I want find a short-term compromise
> >solution for this which does not involve tons of email. We'll announce
> >the netfilter workshop soon, likely to happen at Q1 2013 depending on
> >availability of the organizer, but maybe Q2 2013 (but not later), I
> >think it's the place to debate your proposal and nftables, of course.
> >
> >I will not get anything into mainline until then.
> 
> Delaying this for more months is not a good idea, I think.
> 
> The amount of patches will grow as more features are implemented. If
> there is an objection to a patch, then this can have implications for
> all those that follow (not rebase conflicts, but actual
> invalidating), which gets more painful the larger the patchset is.

A few months won't really hurt - TPROXY had been discussed for a couple of 
years at every workshop (and it was much simpler, smaller code). Both 
nftables and xtables2 have got nice features, so it's not a simple 
question.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
