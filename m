From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 0/3] ipset: change 'iface' part in hash:net,iface set
Date: Sat, 7 Jul 2012 16:53:31 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1207071646130.17386@blackhole.kfki.hu>
References: <cover.1341525006.git.mr.dash.four@googlemail.com> <alpine.DEB.2.00.1207060947530.14535@blackhole.kfki.hu> <4FF736FE.8030109@googlemail.com> <alpine.DEB.2.00.1207062138140.16055@blackhole.kfki.hu> <4FF74868.3070303@googlemail.com>
 <CAHo-OowHXH9f526QQc4Ln5_P_Osdm1Q_RrBkw83hSGj=oES5ww@mail.gmail.com> <4FF74D5C.6060909@googlemail.com> <alpine.DEB.2.00.1207062243080.16055@blackhole.kfki.hu> <4FF752F0.3010007@googlemail.com> <alpine.DEB.2.00.1207062319130.16055@blackhole.kfki.hu>
 <4FF765E7.6020809@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:50692 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256Ab2GGOxd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 Jul 2012 10:53:33 -0400
In-Reply-To: <4FF765E7.6020809@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 6 Jul 2012, Mr Dash Four wrote:

> > You want a choice to be introduced which lead to confusion - I'm repeating
> > it countless times and you just ignore it.
> How am I ignoring it? I asked you before and I am asking you again to 
> explain what that "confusion" is? It is quite clear to me what the 
> meaning of "in" and "out" is (again, if it is not made clear in the 
> various man pages, I would certainly appreciate any suggestions you - or 
> anyone else following this - might have). Again, if there is something 
> "confusing" in that meaning, then I'd like to know.

So I have to repeat again: your patches do not address the example of the 
two rules with list:set type of sets, which give different results 
depending on "in/out" or "src/dst" in the second direction position. 
 
> To reiterate once again - 'in' is for matches of incoming interfaces 
> only and should only be used for that particular purpose (it is one 
> reason why I am dead against your idea for this to be used "everywhere" 
> - to answer your other query below). Similar with 'out', but for 
> outgoing interfaces.

In the given example, in rule level, there is no hash:net,iface type of 
set. Still, the result depends on the syntax.
 
> >  Then come up with a better solution than the submitted one.
> >   
> I will, if you let me know what is wrong, in your view, with the one I
> submitted yesterday.

I wait for a better solution, which does not produce different results 
depending on the "in/out" or "src/dst" syntax, for all set types, 
including the list of sets.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
