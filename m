From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset-2.3.2
Date: Sat, 5 Jul 2008 01:09:51 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0807050050510.4142@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0807021449020.32444@blackhole.kfki.hu>
 <200807041553.41535.ludwig.nussel@suse.de> <alpine.LNX.1.10.0807041600150.1890@fbirervta.pbzchgretzou.qr>
 <200807041614.35900.ludwig.nussel@suse.de> <alpine.LNX.1.10.0807041814270.1890@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ludwig Nussel <ludwig.nussel@suse.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:42384 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbYGDXJx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jul 2008 19:09:53 -0400
In-Reply-To: <alpine.LNX.1.10.0807041814270.1890@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 4 Jul 2008, Jan Engelhardt wrote:

> I have completed importing ipset and wiring up the Makefile logic
> in xtables-addons (ipset branch). As such, there is also a SUSE rpm
> in my repo (/suser-jengelh/SUSE-11.0/*/xtables-addons-*-1.5.4.2).
> 
> Jozsef, where do we go from here? ipset in xt-a, ACCEPT or DROP?

As xtables-addons works with kernel 2.6.18.5 or above I cannot depend on 
it. Even supporting 2.4 kernels is still required - and if there's a 
single user who needs it, I do support the 2.4 series in ipset.

If you want to maintain a copy of ipset in xtables-addons, just go ahead.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
