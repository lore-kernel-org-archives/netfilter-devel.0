From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: RE: [PATCH v2 2/5] ipset: add "inner" flag implementation
Date: Sat, 29 Jun 2013 13:10:10 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1306291307270.25929@blackhole.kfki.hu>
References: <cover.1371423775.git.mr.dash.four@googlemail.com> <51BE49D4.1010901@googlemail.com> <alpine.DEB.2.00.1306262149560.17378@blackhole.kfki.hu> <51CCBE8A.3080305@googlemail.com> <4E5779AD88B2F040B8A7E83ECF544D1A01AD5B@SJCPEX01CL02.citrite.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Dash Four <mr.dash.four@googlemail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Core Team <netfilter-devel@vger.kernel.org>
To: Jeff Haran <Jeff.Haran@citrix.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:59863 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518Ab3F2LKL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Jun 2013 07:10:11 -0400
In-Reply-To: <4E5779AD88B2F040B8A7E83ECF544D1A01AD5B@SJCPEX01CL02.citrite.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 27 Jun 2013, Jeff Haran wrote:

> ...
> > I disagree. By having "return false" (or "return 0", "return -1" and so
> > on) instead of "goto err" it is not immediately apparent to someone who
> > studies/reviews/uses the code that this is an error condition/path. I
> > have been in that situation many times when I have to go back and look
> > at a particular function call to see what "return false" or "return 0"
> > actually means.
> > 
> > By including "goto err" instead of multiple "return false" statement,
> > that makes it instantly obvious what the purpose of that statement is
> > without having to look elsewhere.
> 
> I suppose as an alternative you could go way against the usual practice 
> and put some text in a function header comment block indicating what the 
> return code means. I know it doesn't get used much but C has had this /* 
> comment */ thing for a long time. I've never understood why more people 
> don't use it.

In general I'd agree with you, but this is a boolean function. So why 
should the the meaning of the return value "true" and "false" be 
explained? (This is also why I regard the goto unnecessary.)

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
