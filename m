From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: netfilter: nf_conntrack: log packets dropped by helpers
Date: Wed, 26 Aug 2009 15:15:19 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0908261506460.13716@blackhole.kfki.hu>
References: <4A93D817.4080706@trash.net> <4A94073B.80106@plouf.fr.eu.org> <4A9530C1.50200@trash.net> <alpine.LSU.2.00.0908261503340.32385@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Pascal Hambourg <pascal.mail@plouf.fr.eu.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:57929 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932927AbZHZNPT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Aug 2009 09:15:19 -0400
In-Reply-To: <alpine.LSU.2.00.0908261503340.32385@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 26 Aug 2009, Jan Engelhardt wrote:

> On Wednesday 2009-08-26 14:55, Patrick McHardy wrote:
> 
> >Pascal Hambourg wrote:
> >> Hello,
> >> 
> >> May I ask what are the reasons for a helper to drop packets ?
> >
> >Mainly parsing errors, memory allocation errors and bugs.
> 
> I am not so quite sure whether parsing errors (like, a port > 65535 for 
> FTP) should cause them to be dropped; after all, it might be, for 
> example, a vendor-specific form of a protocol that just does not fit the 
> nf_conntrack_ftp parsing exactly. That is to say, packets should be let 
> through, though without setting up expectations.

I usually say that conntrack is not a policy-decision machine and 
therefore should not drop packets.

However, for the protocol helpers I strongly believe if the helper can't 
figure out the protocol elements due to any kind of parser error, then 
the packet should be dropped. Otherwise we may open up possible DoS attack 
vectors to sloppy server/client implementations.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
