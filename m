From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset: use NFPROTO_ (v2)
Date: Thu, 1 Sep 2011 11:22:31 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1109011116480.3875@blackhole.kfki.hu>
References: <1314794637-30141-1-git-send-email-jengelh@medozas.de> <alpine.DEB.2.00.1108312109380.1611@blackhole.kfki.hu> <alpine.LNX.2.01.1108312229530.13025@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:54037 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931Ab1IAJWc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Sep 2011 05:22:32 -0400
In-Reply-To: <alpine.LNX.2.01.1108312229530.13025@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 31 Aug 2011, Jan Engelhardt wrote:

> On Wednesday 2011-08-31 21:13, Jozsef Kadlecsik wrote:
> 
> >On Wed, 31 Aug 2011, Jan Engelhardt wrote:
> >
> >> The following changes since commit cdb6bb6cf01909e84bae99af0d83946884f24611:
> >> 
> >>   ipset 6.8 released (2011-07-11 11:10:47 +0200)
> >> 
> >> are available in the git repository at:
> >>   git://dev.medozas.de/ipset master
> >> 
> >> Jan Engelhardt (3):
> >>       ipset: use NFPROTO_ constants
> >>       build: abort autogen on subcommand failure
> >>       build: move ipset_errcode into library
> >
> >Please rebase these patches against commit
> >20a52295775126d1bd5740b6543d1ea8ea239b1b and send them again: the 
> >compatibility patch I had to wrote on top of your previous batch broke 
> >them. Thanks!
> 
> Rebased. Same URL.

Pulled and pushed out, thanks, Jan.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
