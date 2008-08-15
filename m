From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [IPTABLES] the same options for different kinds of matches don't
 work
Date: Sat, 16 Aug 2008 00:44:57 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0808160037390.20328@blackhole.kfki.hu>
References: <412e6f7f0808150951u2f2d58afn8340c64fed9de2a2@mail.gmail.com>
 <48A5CEFE.5090407@netfilter.org> <alpine.LNX.1.10.0808151633500.10478@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0808152243280.20098@blackhole.kfki.hu>
 <alpine.LNX.1.10.0808151743310.10478@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Changli Gao <xiaosuo@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:42483 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723AbYHOWo7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Aug 2008 18:44:59 -0400
In-Reply-To: <alpine.LNX.1.10.0808151743310.10478@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 15 Aug 2008, Jan Engelhardt wrote:

> 
> On Friday 2008-08-15 16:48, Jozsef Kadlecsik wrote:
> >> - ecn and ECN
> >
> >The options of the ecn match and the ECN target are not clashing.
> 
> They do. Both libipt_ecn.c and libipt_ECN.c have --ecn-ip-ect,
> --ecn-tcp-cwr and --ecn-tcp-ece even if they are not documented
> (what, more of these? Patch follows).

Non-documented options do not exist ;-) - so updates are highly welcomed.

But as the ECN options has not been documented so far, I think it'd be 
better to rename them at the same time to something like

--ecn-tcp-cwr-remove
--ecn-tcp-ece-remove
--ecn-ip-ect-set

and clashing with the ecn options were resolved.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
