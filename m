From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: netfilter: nf_conntrack: log packets dropped by helpers
Date: Wed, 26 Aug 2009 21:19:16 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0908262028050.14819@blackhole.kfki.hu>
References: <4A93D817.4080706@trash.net> <4A94073B.80106@plouf.fr.eu.org> <4A9530C1.50200@trash.net> <alpine.LSU.2.00.0908261503340.32385@fbirervta.pbzchgretzou.qr> <alpine.DEB.2.00.0908261506460.13716@blackhole.kfki.hu> <4A954A16.6040803@plouf.fr.eu.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:47531 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbZHZTTQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Aug 2009 15:19:16 -0400
In-Reply-To: <4A954A16.6040803@plouf.fr.eu.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 26 Aug 2009, Pascal Hambourg wrote:

> Jozsef Kadlecsik a ?crit :
> > 
> > I usually say that conntrack is not a policy-decision machine and 
> > therefore should not drop packets.
> 
> I strongly agree.
> 
> > However, for the protocol helpers I strongly believe if the helper can't 
> > figure out the protocol elements due to any kind of parser error, then 
> > the packet should be dropped. Otherwise we may open up possible DoS attack 
> > vectors to sloppy server/client implementations.
> 
> As a user, I do not expect packets to be dropped when I just enable
> conntrack without loading any filtering rule. Wouldn't it be better (if
> possible) to flag these packets so they can be dropped - or not - by
> iptables ?

There are a few cases when the conntrack core cannot but drop packets. But 
those are very exceptional indeed.

But here we are discussing the protocol helpers: in order to reliably and 
safely handle the related connection - and prevent to be fooled by 
deliberately broken, mangled, etc patterns - the helpers too may have no 
choice but to drop the unparseable packet. And it's not up to the user to 
decide whether the packet should still be let through, because it could 
defeat the access control rules. For a good example just have a look at 
the article 'Breaking through a Firewall using a forged FTP command' in 
Phrack #63.

Best regards, 
Jozsef 
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
