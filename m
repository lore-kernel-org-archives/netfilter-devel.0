From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH v2 3/3] ipset: change 'iface' part in hash:net,iface
 set
Date: Sat, 14 Jul 2012 18:37:12 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1207141816580.1593@blackhole.kfki.hu>
References: <cover.1341871199.git.mr.dash.four@googlemail.com> <1341872622-5015-2-git-send-email-mr.dash.four@googlemail.com> <alpine.DEB.2.00.1207101721510.24998@blackhole.kfki.hu> <4FFCBDB8.9080101@googlemail.com> <alpine.DEB.2.00.1207112154070.26540@blackhole.kfki.hu>
 <4FFF6EF2.6010108@googlemail.com> <alpine.DEB.2.00.1207130857480.31126@blackhole.kfki.hu> <5000293F.4030901@googlemail.com> <alpine.DEB.2.00.1207131608230.32475@blackhole.kfki.hu> <50002F3F.5020408@googlemail.com> <alpine.DEB.2.00.1207141009340.1031@blackhole.kfki.hu>
 <5001678C.6000505@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:46182 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478Ab2GNQhO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Jul 2012 12:37:14 -0400
In-Reply-To: <5001678C.6000505@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 14 Jul 2012, Mr Dash Four wrote:

> > a. The keywords are not permitted at all.
> > b. "in/out" is permitted but "converted" to "src/dst" wherever needed for
> >    the member sets, that is all types but hash:net,iface.
> >   
> Solution "b.", as you put it above, is what I have implied with my question
> yesterday.
> 
> > Solution a. is completely acceptable for me. It can nicely be documented,
> > there's no chance for misunderstanding.
> > 
> > Solution b. is also acceptable but it's more controversial: if "in/out" is
> > accepted with list:set type, then it's very hard to explain why it's *not*
> > allowed with every type, when actually "in/out" is allowed then for every
> > type of member sets of list:set type of sets. So solution b. implies that
> > "in/out" is then a general synonym of "src/dst" and should be allowed
> > everywhere. Therefore I'm not really happy with solution b. but I can
> > stomach it.
> >   
> There is a flip side to that particular coin - I could argue that since 
> in/out *is* allowed to be used in hash:net,iface, why can't it be used 
> in list:set where I could have hash:net,iface type sets accepted as 
> members? You are imposing an unnecessary restriction where none is 
> needed.

Both a. and b. must satisfy that the result must not depend on the syntax. 
If "in/out" is allowed in a rule then replacing by "src/dst" the result of 
the iptables rule must remain the same. Whatever sets are in a list:set.
 
> Also, don't forget that this may be OK with someone, like yourself, who 
> is comfortable interchanging in/out with src/dst quite easily, but for 
> people like myself, where I have to scratch my head and think "god, what 
> the hell was the substitution for 'in' now?" before specifying src/dst, 
> this is not as straight-forward as you might think.

I don't favour b. Ugly like hell, a. were much cleaner.
 
> So, to conclude: "solution b." is a good compromise - one I will be 
> quite happy with. If src/dst is used together with in/out (in 
> list:sets!), you leave the end user to decide what is more appropriate 
> for each case as list:set could have hash:net,iface as well as other 
> type of sets as members and in this case that is OK to be allowed (one 
> cannot guess what will be entered in advance as members of that 
> list:set, so it makes perfect sense to leave that decision to the end 
> user).

Again, b. is acceptable only if "in/out" and "src/dst" are freely 
interchangeable, with any type of member sets in a list:set type of sets, 
and the syntax itself does not affect the result.
 
> > Do you see other possibilities, which produce result independent of the
> > allowed syntax?
> >   
> No, not without you being on my case. For list:set types, as it is kind of a
> "unique" set (as it could have different types of sets as members) I think
> "solution b." is quite acceptable.

If "in/out" is allowed with list:set type of sets, then the syntax should 
be allowed everywhere. So practically "in/out" were aliases to "src/dst".

You rejected the idea some mails ago:

[Fri, 06 Jul 2012 20:05:34 +0100]
Me:> It'd be much simpler to introduce the keywords as aliases, all over:
Me:> "in" as "dst" and "out" as "src", and print them with 
Me:> hash:net,iface only.
 
You:> Simpler for whom? It can't be for the end user, because referring 
You:> to, say, destination IP address as "out" IP address is even more 
You:> ridiculous than using 'src' and 'dst' designators for network 
You:> interfaces. Quite astonishing that!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
