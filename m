From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH v2 3/3] ipset: change 'iface' part in hash:net,iface
 set
Date: Sun, 15 Jul 2012 17:02:28 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1207151552140.3610@blackhole.kfki.hu>
References: <cover.1341871199.git.mr.dash.four@googlemail.com> <1341872622-5015-2-git-send-email-mr.dash.four@googlemail.com> <alpine.DEB.2.00.1207101721510.24998@blackhole.kfki.hu> <4FFCBDB8.9080101@googlemail.com> <alpine.DEB.2.00.1207112154070.26540@blackhole.kfki.hu>
 <4FFF6EF2.6010108@googlemail.com> <alpine.DEB.2.00.1207130857480.31126@blackhole.kfki.hu> <5000293F.4030901@googlemail.com> <alpine.DEB.2.00.1207131608230.32475@blackhole.kfki.hu> <50002F3F.5020408@googlemail.com> <alpine.DEB.2.00.1207141009340.1031@blackhole.kfki.hu>
 <5001678C.6000505@googlemail.com> <alpine.DEB.2.00.1207141816580.1593@blackhole.kfki.hu> <5002AF68.9070204@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:52876 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535Ab2GOPCb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 15 Jul 2012 11:02:31 -0400
In-Reply-To: <5002AF68.9070204@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 15 Jul 2012, Mr Dash Four wrote:

> > > There is a flip side to that particular coin - I could argue that since
> > > in/out *is* allowed to be used in hash:net,iface, why can't it be used in
> > > list:set where I could have hash:net,iface type sets accepted as members?
> > > You are imposing an unnecessary restriction where none is needed.
> > 
> > Both a. and b. must satisfy that the result must not depend on the syntax.
> > If "in/out" is allowed in a rule then replacing by "src/dst" the result of
> > the iptables rule must remain the same. Whatever sets are in a list:set.
> >   
> I fail to see how your answer addresses my point above, which I raised 
> in response to the restriction imposed by "solution a." of not allowing 
> in/out in a list:set where there could be hash:net,iface members 
> registered.

My answer stated the conditions which any solution must satisfy.
 
> You know very well that by allowing in/out alongside src/dst in a 
> list:set this *will* produce the same members match - that was your 
> previous objection for not allowing in/out to be used alongside src/dst 
> in list:set, until I found you this solution and then you swiftly moved 
> the goalposts, again!

The goal - for me - is the same from the very beginning: an alternate 
syntax must be what it is: just an alternative. The result cannot depend 
on which syntax is used.
 
> > I don't favour b. Ugly like hell, a. were much cleaner.
> >   
> You couldn't make this up! I mean, really Jozsef?
> 
> In a couple of hours yesterday, you went from:
> 
> "Solution b. is also acceptable but it's more controversial", then
> "Therefore I'm not really happy with solution b. but I can stomach it", 

I don't have to like a solution. This one is controversial. Originally I 
came up with it, but I don't like it.

> and finally, the above answer, not to mention that you started all of 
> this with you being "unhappy" with users being "forced" to use src/dst 
> only on list:set types.

Here is my paragraph you might think of:

"You must handle the case of the list:set type: how should then the new 
"in", "out" be interpreted? Or should those be rejected? But then it'd 
mean that if someone used a hash:net,iface type as a member of list:set, 
then he is forced to use "src", "dst" only."

I asked questions. Did I write I was unhappy if only src/dst were allowed? 
No. The only thing I stated was that the case of list:set types must be 
handled. Something really doesn't work in the communication between us if 
my sentences above misled you.

> In other words - you have gone full circle - twice - in a space of just a
> couple of days. I see that "debating" with you is becoming a bit of a
> pointless exercise.

It's a mutual feeling then. I repeat again and again, that where two 
syntaxes are allowed (the subject is an iptables rule) then the result 
must not depend on which one is used.

So better close it down: send your patches according to solution a, that 
is the "in/out" keywords are allowed only with hash:net,iface type of sets 
alone and rejected with a proper error message when attempted to use with 
any other set type.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
