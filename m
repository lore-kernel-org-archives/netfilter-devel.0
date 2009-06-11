From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] Reserve nfnetlink subsys ids.
Date: Thu, 11 Jun 2009 23:51:48 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0906112349380.30129@blackhole.kfki.hu>
References: <alpine.DEB.2.00.0906111334090.28605@blackhole.kfki.hu> <4A310FF4.2070207@trash.net> <4A31142E.50707@netfilter.org> <4A31198F.7010004@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:57296 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbZFKVvr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Jun 2009 17:51:47 -0400
In-Reply-To: <4A31198F.7010004@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 11 Jun 2009, Patrick McHardy wrote:

> Pablo Neira Ayuso wrote:
> > Patrick McHardy wrote:
> > > Jozsef Kadlecsik wrote:
> > > > Hi Patrick,
> > > > 
> > > > A tiny patch to add nfnetlink subsys ids for nftables and ipset. :-)
> As I said, IDs are usually not reserved until something is merged,
> even if there is agreement to merge it. I guess there has been too
> much bad experience with reserved IDs and code that never got merged.
> I have to justify the patches I merge myself and so far I can't.

You're right, of course. I'm going to find another way for a smooth 
protocol migration.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
