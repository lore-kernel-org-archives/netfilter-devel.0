From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: UDP packets sent with wrong source address after routing change
 [AV#3431]
Date: Tue, 13 Nov 2012 17:04:48 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1211131658340.21144@blackhole.kfki.hu>
References: <alpine.DEB.2.02.1211081627150.6644@lap-x201> <alpine.LNX.2.01.1211081829150.28568@nerf07.vanv.qr> <alpine.DEB.2.00.1211081823030.5637@chris-desktop.fen.aptivate.org> <20121110140720.GA9610@1984> <alpine.LNX.2.01.1211101957320.1938@nerf07.vanv.qr>
 <alpine.DEB.2.00.1211102216540.14307@blackhole.kfki.hu> <alpine.DEB.2.02.1211121019280.23195@lap-x201> <alpine.DEB.2.00.1211121556480.18137@blackhole.kfki.hu> <alpine.DEB.2.02.1211121523190.23195@lap-x201> <alpine.DEB.2.00.1211122020280.18729@blackhole.kfki.hu>
 <alpine.DEB.2.00.1211122227540.4432@chris-desktop.fen.aptivate.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Chris Wilson <chris-netfilter-110904@aptivate.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:51163 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576Ab2KMQEt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Nov 2012 11:04:49 -0500
In-Reply-To: <alpine.DEB.2.00.1211122227540.4432@chris-desktop.fen.aptivate.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 12 Nov 2012, Chris Wilson wrote:

> On Mon, 12 Nov 2012, Jozsef Kadlecsik wrote:
> 
> > What do you think about this?
> > 
> > - add route change notification event to the net core
> > - add --update-source-address flag to the MASQUERADE target
> > - add a call for such events to the MASQUERADE target, when
> >  the flag is enabled
> > 
> > The called function then can scan the conntrack table and for every entry
> > which has got the update-source-address flag, can check whether the source
> > IP address should be changed. Those entries are then deleted.
> 
> That sounds like a relatively easy implementation that would solve the main
> problem for us.
> 
> I think there might be one element missing from the above process: the 
> actual conntrack entries created by the MASQUERADE 
> --update-source-address rule should be marked with an 
> UPDATE_SOURCE_ADDRESS flag, so that they can be found and deleted when 
> the routing changes.

Yes, I thought that is implied by the the MASQUERADE flag.
 
> Perhaps the flag/option should be called "--remove-if-routing-changes" or
> "--routing-dependent" or something like that, since the source address is not
> really being (directly) changed as I proposed at the beginning?

I dunno, I'm not very good at naming. The "--routing-dependent" is 
shorter.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
