From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: AW: ulogd syslogemu output garbage after kernel update (32 to
 64bit)
Date: Thu, 13 Sep 2012 10:32:30 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1209131026210.10939@blackhole.kfki.hu>
References: <9F69795E29C890408AC2DAF646C89BB379DA5476A8@MAILBOX.arc.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Fiedler Roman <Roman.Fiedler@ait.ac.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:57773 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754827Ab2IMIcd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Sep 2012 04:32:33 -0400
In-Reply-To: <9F69795E29C890408AC2DAF646C89BB379DA5476A8@MAILBOX.arc.local>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 13 Sep 2012, Fiedler Roman wrote:

> > In short: Could 32-bit ulogd run on 64-bit kernel without failing?
> 
> Has any one an educated guess, if that could work? Are netlink 
> data-structures machine-arch dependent and hence a 32-bit ulogd cannot 
> process a 64-bit netlink message?
>  
> > Longer story: One of our machines runs on 32bit linux because 32bit code is
> > smaller. Also the kernel was a 32-bit one. Over the time during operation, the
> > larger amount of data processed increased RAM requirements. All processes
> > stay below 4G but the system itself could use more than 4G RAM, which is not
> > possible with the 32-bit kernel used. So the kernel was upgraded  to 64 bit
> > (kernel 3.3.2) WITHOUT upgrading the system to 64 bit.
> > 
> > Afterwards everything worked fine except that the ulogd (1.24-3ubuntu1)
> > messages written to syslogemu were complete garbage, e.g.

As far as I know, the development is concentrated on ulogd2. You are much 
better off by installing it manually.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
