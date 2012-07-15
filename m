From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH v2 3/3] ipset: change 'iface' part in hash:net,iface
 set
Date: Sun, 15 Jul 2012 21:21:08 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1207152041270.4159@blackhole.kfki.hu>
References: <cover.1341871199.git.mr.dash.four@googlemail.com> <1341872622-5015-2-git-send-email-mr.dash.four@googlemail.com> <alpine.DEB.2.00.1207101721510.24998@blackhole.kfki.hu> <4FFCBDB8.9080101@googlemail.com> <alpine.DEB.2.00.1207112154070.26540@blackhole.kfki.hu>
 <4FFF6EF2.6010108@googlemail.com> <alpine.DEB.2.00.1207130857480.31126@blackhole.kfki.hu> <5000293F.4030901@googlemail.com> <alpine.DEB.2.00.1207131608230.32475@blackhole.kfki.hu> <50002F3F.5020408@googlemail.com> <alpine.DEB.2.00.1207141009340.1031@blackhole.kfki.hu>
 <5001678C.6000505@googlemail.com> <alpine.DEB.2.00.1207141816580.1593@blackhole.kfki.hu> <5002AF68.9070204@googlemail.com> <alpine.DEB.2.00.1207151552140.3610@blackhole.kfki.hu> <5002F0AF.4000502@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:40721 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940Ab2GOTVK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 15 Jul 2012 15:21:10 -0400
In-Reply-To: <5002F0AF.4000502@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 15 Jul 2012, Mr Dash Four wrote:

> > > I fail to see how your answer addresses my point above, which I 
> > > raised in response to the restriction imposed by "solution a." of 
> > > not allowing in/out in a list:set where there could be 
> > > hash:net,iface members registered.
> > 
> > My answer stated the conditions which any solution must satisfy.
> >   
> Which wasn't what I asked originally, was it Jozsef? Even if that was 
> the case and I did ask you that, I fail to see how "solution b" isn't 
> enforcing what you have just written above.

What you asked me was "if I send you the patches where in/out is allowed 
in list:set and produces "consistent" (by your own high-standards) result 
would that be OK with you (if not, why not)?" As it was a generic question 
without *any* details on the actual solution, I gave the answer which 
covers the requirements for all possible ones.

You imply a lot in my sentences. What should I imply in your quotation 
marks around "consistent"? In what "consistent" is different from 
consistent? And nothing about how it's accomplised (whatever it means).

> > > > I don't favour b. Ugly like hell, a. were much cleaner.
> > > >         
> > > You couldn't make this up! I mean, really Jozsef?
> > > 
> > > In a couple of hours yesterday, you went from:
> > > 
> > > "Solution b. is also acceptable but it's more controversial", then
> > > "Therefore I'm not really happy with solution b. but I can stomach it",     
> > 
> > I don't have to like a solution. This one is controversial. Originally I
> > came up with it, but I don't like it.
> >   
> No. What you have "come up with" was that initially this same solution was:
> 
> 1. "acceptable, but controversial"; then
> 2. "I am not happy, but I can stomach it"; followed a few hours later by
> 3. "I do not favour it, ugly like hell";
> 
> All this, given your initial reaction of that same restriction being, at 
> best undesirable, at worse unacceptable.

A controversial solution makes me no happy, but if that's the best course 
I can stomach it. Still, I can look at it as an ugly one and not favour 
it if there are other possibilities.
 
> Your last sentence you quoted above: "...but then it'd mean that if someone
> used a hash:net,iface type as a member of list:set, then he is forced to use
> 'src', 'dst' only." clearly indicates, or at least implies to anyone with a
> basic grasp of the English language, that this action (using src/dst only for
> hash:net,iface in a list:set) is, at best undesirable, at worse unacceptable.

You imply a lot. I did not give any such indications. Is it bad if a 
syntax is enforced onto the users? I don't believe so. The enforced syntax 
may have a good purpose, like preventing the users from easy mistakes.
 
> > So better close it down: send your patches according to solution a, that is
> > the "in/out" keywords are allowed only with hash:net,iface type of sets
> > alone and rejected with a proper error message when attempted to use with
> > any other set type.
> >   
> I would like to see why do you think the use of in/out should be restricted in
> list:set types, given the fact that there could be hash:net,iface members
> registered in that type of set?
> 
> Why should I (and I am sure I am not going to be the only one) have to 
> scratch my head and think what is corresponding to 'src' and 'dst' every 
> time I place a hash:net,iface set member in a list:set and why I can't 
> make use of in or out, in addition to src/dst in that list:set?

Because this or that way, someone would scratch his/her head. For example 
if the rule contains "in/out" and the list:set is a mixed one, contains 
both hash:net,iface and other types of sets. They'll ask: "What the heck 
is "in/out" for say hash:ip type of set?" Let me cite again our own words:

You:> Simpler for whom? It can't be for the end user, because referring 
You:> to, say, destination IP address as "out" IP address is even more 
You:> ridiculous than using 'src' and 'dst' designators for network 
You:> interfaces. Quite astonishing that!

So we circled again. Shortcut the next round:

Send your patches according to solution a, that is the "in/out" keywords 
are allowed only with hash:net,iface type of sets alone and rejected with 
a proper error message when attempted to use with any other set type.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
