From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [nft PATCH] evaluate: better error reporting in too long sets
 names
Date: Wed, 27 Apr 2016 19:36:38 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1604271929480.24314@blackhole.kfki.hu>
References: <146115978018.25287.16460508385150502285.stgit@nfdev2.cica.es> <20160427171419.GA7625@salvia>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:46983 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192AbcD0Rfb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Apr 2016 13:35:31 -0400
In-Reply-To: <20160427171419.GA7625@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 27 Apr 2016, Pablo Neira Ayuso wrote:

> On Wed, Apr 20, 2016 at 03:43:00PM +0200, Arturo Borrero Gonzalez wrote:
> > Currently, if we choose a set name larger than allowed, the error message is:
> >  Error: Could not process rule: Numerical result out of range
> > 
> > Let's inform the user with a better error message.
> > 
> > We can discuss later if length of set names should be increased, but I think
> > this better error reporting is necessary right now to avoid headaches to users.
> 
> /* The max length of strings including NUL: set and type identifiers */
> #define IPSET_MAXNAMELEN        32
> 
> I would like that we get the same length as ipset, this should make it
> easier for people to migrate.

I think it's all right if set names are longer in nftables. That won't 
cause incompatibilites, unless someone wants to move from nftables to 
ipset.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
