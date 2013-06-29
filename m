From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH v2 2/5] ipset: add "inner" flag implementation
Date: Sat, 29 Jun 2013 20:13:25 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1306292010060.26726@blackhole.kfki.hu>
References: <cover.1371423775.git.mr.dash.four@googlemail.com> <51BE49D4.1010901@googlemail.com> <alpine.DEB.2.00.1306262149560.17378@blackhole.kfki.hu> <51CCBE8A.3080305@googlemail.com> <alpine.DEB.2.00.1306291247010.25929@blackhole.kfki.hu>
 <51CEE9A9.4090109@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Core Team <netfilter-devel@vger.kernel.org>
To: Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:52114 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635Ab3F2SN2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Jun 2013 14:13:28 -0400
In-Reply-To: <51CEE9A9.4090109@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 29 Jun 2013, Dash Four wrote:

> > > By including "goto err" instead of multiple "return false" statement, that
> > > makes it instantly obvious what the purpose of that statement is without
> > > having to look elsewhere. 
> > 
> > I see the point, to self-document the code, with the price of more lines.
> > It's a little bit overdoing in my opinion: pretty apparent which is the
> > error path and which is not. But this is highly a personal taste, I won't
> > press it.
> >   
> In other words, you'll be happy for me to leave things as they are - 
> with the "goto"?

I won't be happy but I can stomach it. So you can leave the gotos there as
you are conviced those add a readability value.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
