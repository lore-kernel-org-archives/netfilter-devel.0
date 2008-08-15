From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [IPTABLES] the same options for different kinds of matches don't
 work
Date: Fri, 15 Aug 2008 22:48:47 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0808152243280.20098@blackhole.kfki.hu>
References: <412e6f7f0808150951u2f2d58afn8340c64fed9de2a2@mail.gmail.com>
 <48A5CEFE.5090407@netfilter.org> <alpine.LNX.1.10.0808151633500.10478@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Changli Gao <xiaosuo@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:46496 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670AbYHOUss (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Aug 2008 16:48:48 -0400
In-Reply-To: <alpine.LNX.1.10.0808151633500.10478@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 15 Aug 2008, Jan Engelhardt wrote:

> On Friday 2008-08-15 14:46, Pablo Neira Ayuso wrote:
> >I see, it's worth to know this issue. However, my main objection with
> >this patch is: is there any match in iptables mainline that actually
> >uses two options with clashing names?
> 
> - mark, connmark, realm

mark and connmark do clash, so I was wrong in my previous reply about 
non-clashing in mainline. There might be cases when one would want to 
check the mark value of a packet and a conntrack entry, which is currently 
not possible in a single rule due to the clashing option name.

Reading the manpage, realm does not clash with either mark or connmark.

> - ecn and ECN

The options of the ecn match and the ECN target are not clashing.

> - multiport and tcp/udp/sctp/dccp.

They are ortogonal.
 
> (There was a reason to my post after all ;-)

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
