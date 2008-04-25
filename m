From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Invalid SACK numbers in NAT'ed packets
Date: Fri, 25 Apr 2008 13:12:58 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0804251311450.5340@blackhole.kfki.hu>
References: <funk78$srq$1@ger.gmane.org> <Pine.LNX.4.64.0804232126040.28881@blackhole.kfki.hu>
 <00c101c8a5ea$d83213f0$5101a8c0@csltd.intranet>
 <Pine.LNX.4.64.0804241130040.30382@blackhole.kfki.hu>
 <006b01c8a6b1$884da030$5101a8c0@csltd.intranet> <Pine.LNX.4.64.0804251059510.5340@blackhole.kfki.hu>
 <alpine.LNX.1.10.0804251256530.11644@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Leonid Zeitlin <lz@csltd.com.ua>, netfilter@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:43506 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923AbYDYLNA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Apr 2008 07:13:00 -0400
In-Reply-To: <alpine.LNX.1.10.0804251256530.11644@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 25 Apr 2008, Jan Engelhardt wrote:

> On Friday 2008-04-25 11:02, Jozsef Kadlecsik wrote:
> 
> >On Fri, 25 Apr 2008, Leonid Zeitlin wrote:
> >
> >> It appears that short of writing a custom netfilter extension, there's no way
> >> to turn off SACKs on a particular connection. Is this right?
> >
> >Yes, exactly. Actually, writing a new extension to erase any TCP option 
> >isn't that hard: just replace the option with noop and recalculate the 
> >checksum.
> 
> There is already a TCPOPTSTRIP target.

True, it was added to 2.6.25. I should have checked the facts before 
posting.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
