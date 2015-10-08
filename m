From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [nft] regarding sets names length
Date: Thu, 8 Oct 2015 15:05:24 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1510081455410.369@blackhole.kfki.hu>
References: <CAOkSjBiv1M9QE2bjTBTh9Yr1n_5w2c69Rg1ZpoxUroga7oncgA@mail.gmail.com> <20151008115524.GA20598@macbook.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:35813 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536AbbJHNEM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Oct 2015 09:04:12 -0400
In-Reply-To: <20151008115524.GA20598@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Thu, 8 Oct 2015, Patrick McHardy wrote:

> On 08.10, Arturo Borrero Gonzalez wrote:
> >  * enlarge set names sizes
> 
> Agreed, I think its a good idea to use 32 as for the other object types.

I'd suggest 128 or even 256 chars. In ipset the set name is limited to 32 
too but I had received a few complains and plan to increase it.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
