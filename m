From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [IPTABLES] the same options for different kinds of matches don't
 work
Date: Fri, 15 Aug 2008 22:10:29 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0808152149500.20098@blackhole.kfki.hu>
References: <412e6f7f0808150951u2f2d58afn8340c64fed9de2a2@mail.gmail.com>
 <Pine.LNX.4.64.0808152127180.20054@blackhole.kfki.hu>
 <alpine.LNX.1.10.0808151535100.10478@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Changli Gao <xiaosuo@gmail.com>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:51555 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbYHOUKb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Aug 2008 16:10:31 -0400
In-Reply-To: <alpine.LNX.1.10.0808151535100.10478@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 15 Aug 2008, Jan Engelhardt wrote:

> On Friday 2008-08-15 15:31, Jozsef Kadlecsik wrote:
> >> For example:
> >> 
> >> iptables -t mangle -A PREROUTING -m a --mac-source 00:11:22:33:44:55
> >> -m b --mac-source 00:11:22:33:44:55 -j ACCEPT
> >> 
> >> the above command will fail due to the later match.
> >
> >Yes: you should use match-specific options, like
> >
> >iptables -t mangle -A PREROUTING -m a --a-mac-source 00:11:22:33:44:55
> >-m b --b-mac-source 00:11:22:33:44:55 -j ACCEPT
> 
> I disagree. If you chain multiple matches, e.g.
> 
> -m condition --name FOO -m conidtion --name BAR
> 
> you can't choose a different option name naturally.

And you don't choose - why should you? The (not-mistyped) example above 
*is* supported by iptables. With the suggested patch we'd loose it. And 
currently we do not enforce that match options let be strictly packed 
together, i.e. you can type

-m foo -m bar --foo-option --bar-option

> Hence I am of the opinion that different matches should also support 
> this syntax.

Why should different matches use the same syntax? Would it make the rules 
more readable and less error prone if the same option names could be used 
at different kind of matches? Of course not. So in my opinion the feature 
would not buy us anything but could lead to confusion, not to mention 
loosing a valuable feature and breaking backward compatibility. Therefore 
I'm against it.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
