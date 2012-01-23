From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: xtables2 a8, netlink interface
Date: Mon, 23 Jan 2012 20:48:13 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1201232045450.17651@blackhole.kfki.hu>
References: <1326990381-14534-1-git-send-email-jengelh@medozas.de> <alpine.DEB.2.00.1201201422230.11124@blackhole.kfki.hu> <alpine.LNX.2.01.1201211645300.28799@frira.zrqbmnf.qr> <alpine.DEB.2.00.1201212110100.13689@blackhole.kfki.hu>
 <alpine.LNX.2.01.1201231634330.9129@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:43142 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075Ab2AWTsQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jan 2012 14:48:16 -0500
In-Reply-To: <alpine.LNX.2.01.1201231634330.9129@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 23 Jan 2012, Jan Engelhardt wrote:

> On Saturday 2012-01-21 21:21, Jozsef Kadlecsik wrote:
> >
> >Netlink makes too easy to add new attributes - and ignores unknown ones. 
> >However, in our case both communicating parties must know the exact 
> >capabilities of the other one: it's unacceptable that say a new flag is 
> >introduced and sent from userspace and got silently discarded by the 
> >(older) kernel.
> 
> I thought about exposing the revision window here, much like
> libtool's CURRENT and (CURRENT-AGE), rather than just a single rev
> like ipset currently does. Does that make sense to you?
> 
> 1. kern: 600--611, prog:    , 599 => prog too old
> 2. kern: 600--611, prog: 600, 610 => can use some/all features
> 3. kern: 600--611, prog: 611      => can use all features
> 4. kern: 600--611, prog: 612,     => kernel too old

That's perfect (ipset does the same, just it doesn't send a version range 
when the window size is zero).

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
