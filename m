From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [nft] regarding sets names length
Date: Fri, 9 Oct 2015 13:12:05 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1510091308500.4639@blackhole.kfki.hu>
References: <CAOkSjBiv1M9QE2bjTBTh9Yr1n_5w2c69Rg1ZpoxUroga7oncgA@mail.gmail.com> <20151008115524.GA20598@macbook.localdomain> <alpine.DEB.2.10.1510081455410.369@blackhole.kfki.hu> <20151008193506.GB26121@macbook.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:47060 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756754AbbJILKt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Oct 2015 07:10:49 -0400
In-Reply-To: <20151008193506.GB26121@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 8 Oct 2015, Patrick McHardy wrote:

> > > Agreed, I think its a good idea to use 32 as for the other object types.
> > 
> > I'd suggest 128 or even 256 chars. In ipset the set name is limited to 32 
> > too but I had received a few complains and plan to increase it.
> 
> I guess we will follow suit then since we should be compatible to ipset
> anyways. Did you already decide for a value?

I thought 32 chars should be enough for everybody ;-) so I'm unsure about 
the good enough value. 128 seems just pretty long, but the name length is 
actually not critical, it could be 256. What do you think?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
