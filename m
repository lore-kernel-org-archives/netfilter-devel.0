From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 0/3] ipset: change 'iface' part in hash:net,iface set
Date: Fri, 6 Jul 2012 23:39:27 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1207062319130.16055@blackhole.kfki.hu>
References: <cover.1341525006.git.mr.dash.four@googlemail.com> <alpine.DEB.2.00.1207060947530.14535@blackhole.kfki.hu> <4FF736FE.8030109@googlemail.com> <alpine.DEB.2.00.1207062138140.16055@blackhole.kfki.hu> <4FF74868.3070303@googlemail.com>
 <CAHo-OowHXH9f526QQc4Ln5_P_Osdm1Q_RrBkw83hSGj=oES5ww@mail.gmail.com> <4FF74D5C.6060909@googlemail.com> <alpine.DEB.2.00.1207062243080.16055@blackhole.kfki.hu> <4FF752F0.3010007@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:56486 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758313Ab2GFVj2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jul 2012 17:39:28 -0400
In-Reply-To: <4FF752F0.3010007@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 6 Jul 2012, Mr Dash Four wrote:

> > Do you deliberately close your eyes? In the two rules
> >   
> Explain the above comment please?

Are you deliberately deaf to the arguments?
 
> > iptables -A INPUT -m set --match-set list1 src,src -j ACCEPT
> > iptables -A INPUT -m set --match-set list1 src,in -j ACCEPT
> > 
> > the underlying set types "decide" how to act to "src/in", when actually
> > "src" == "in". I hear you shouting: FOR HASH:NET,IFACE ONLY. Right. But
> > "list1" is a list type of set, not hash:net,iface. Still, the result is
> > different.
> >   
> Whoever produces the above statements is making a concious decision on 
> what to use/deploy! I am repeating this for, I don't know, a third time 
> maybe - what my patch series are offering is a choice. If you, or 
> anybody else wishes to continue to use 'src' or 'dst' (including for 
> interface matching), then so be it, you are completely free to do that - 
> I am not forcing you, or anyone to do otherwise.

You want a choice to be introduced which lead to confusion - I'm repeating 
it countless times and you just ignore it. In order to prevent such 
confusions, I offered that let "in/out" be alias to "src/dst": accepted as 
input everywhere but printed/saved with hash:net,iface only. You point 
blank refused it. Then come up with a better solution than the submitted 
one.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
