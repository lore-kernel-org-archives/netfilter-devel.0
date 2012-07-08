From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 0/3] ipset: change 'iface' part in hash:net,iface set
Date: Mon, 9 Jul 2012 00:20:07 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1207090014450.20627@blackhole.kfki.hu>
References: <cover.1341525006.git.mr.dash.four@googlemail.com> <alpine.DEB.2.00.1207060947530.14535@blackhole.kfki.hu> <4FF736FE.8030109@googlemail.com> <alpine.DEB.2.00.1207062138140.16055@blackhole.kfki.hu> <4FF74868.3070303@googlemail.com>
 <CAHo-OowHXH9f526QQc4Ln5_P_Osdm1Q_RrBkw83hSGj=oES5ww@mail.gmail.com> <4FF74D5C.6060909@googlemail.com> <alpine.DEB.2.00.1207062243080.16055@blackhole.kfki.hu> <4FF752F0.3010007@googlemail.com> <alpine.DEB.2.00.1207062319130.16055@blackhole.kfki.hu>
 <4FF765E7.6020809@googlemail.com> <alpine.DEB.2.00.1207071646130.17386@blackhole.kfki.hu> <alpine.DEB.2.00.1207071821560.17542@blackhole.kfki.hu> <4FF9852C.7080201@googlemail.com> <alpine.DEB.2.00.1207082051150.19776@blackhole.kfki.hu> <4FF9D97D.7040309@googlemail.com>
 <alpine.DEB.2.00.1207082104290.19776@blackhole.kfki.hu> <4FF9DB46.5000302@googlemail.com> <alpine.DEB.2.00.1207082225250.20080@blackhole.kfki.hu> <4FFA056C.8000709@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:54914 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382Ab2GHWUI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Jul 2012 18:20:08 -0400
In-Reply-To: <4FFA056C.8000709@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 8 Jul 2012, Mr Dash Four wrote:

> > "src,src" != "src,dst", but
> > 
> > with your patches in some cases 
> > "src,in" == "src,src" or "src,in" != "src,src"
> >   
> Could you provide me with an example please? I am intrigued!

This is ridiculous, as if I haven't provided it countless times:

iptables -A INPUT -m set --match-set list1 src,src -j ACCEPT
iptables -A INPUT -m set --match-set list1 src,in -j ACCEPT
 
> > > Avoid what exactly? Using 'in' or 'out' in list:set types?
> > >     
> > 
> > For example. That's a possible solution.
> >   
> So, in other words, what you are actually getting at, is that you wish to
> restrict the use of 'in' and 'out' options only for hash:net,iface types
> because you are not happy with the use of 'in'/'out' in any other set types,
> list:set in particular? Have I understood this correctly then?

That's a possible - probably the simplest - solution. It's OK for me.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
