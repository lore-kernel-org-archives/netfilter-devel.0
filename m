From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 0/3] ipset: change 'iface' part in hash:net,iface set
Date: Fri, 6 Jul 2012 21:47:30 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1207062138140.16055@blackhole.kfki.hu>
References: <cover.1341525006.git.mr.dash.four@googlemail.com> <alpine.DEB.2.00.1207060947530.14535@blackhole.kfki.hu> <4FF736FE.8030109@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:48694 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717Ab2GFTrc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jul 2012 15:47:32 -0400
In-Reply-To: <4FF736FE.8030109@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 6 Jul 2012, Mr Dash Four wrote:

> > You have to introduce a new set type version whenever a new feature is
> > added: in your patches there is no protection against mixed cases, when only
> > the kernel or just the userspace is upgraded. Or one side is downgraded for
> > whatever reason.
> >   
> You mean object version (similar to the one you had a debate about on 
> this ML with Mr Engelhardt a while ago)?

No, I meant functionality changes, but...
 
> As for protection against mixed case uses - I don't think there is a need for
> one. There are two possible scenarios worth considering:- using old iptables +
> new kernel and using new iptables + old kernel.
> 
> With the first case, iptables simply won't accept 'in' or 'out' values even if
> the kernel can process them. So, to me that is not an issue.
> 
> With the second case, again, even if iptables accept 'in' and 'out' as values,
> because the patches I submitted yesterday allow for backwards compatibility,
> the kernel would be able to process these matches without any issues.
> 
> If you look at the code, the iptables code is raising both DIM_TWO_SRC as well
> as the new DIM_IFACE bits in the 'flags' variable. The set matching functions
> of the "old" kernel will "know" of and take into account just the DIM_TWO_SRC
> bit to produce a match, which is quite fine and it is how is supposed to work
> in the first place, so again, a match will be produced and I don't see any
> issues here either.
> 
> If you think there would be any issues of mixed case uses, please elaborate
> why do you think that is and give me an example (I am excluding the list:set
> type as this is a bit of a special case - see below)?

...you are right, because "in" is equivalent with "src".
 
> > You must handle the case of the list:set type: how should then the new "in",
> > "out" be interpreted?
> As I already pointed out in the patches yesterday, 'in' and 'out' have 
> only one single purpose - to match against network interfaces. Nothing 
> else!
> 
> 'In' - means incoming interface, 'out' means outgoing. It doesn't make 
> sense at all to be used anywhere else - if they are allowed to be used 
> to specify source/destination ip addresses/subnets, protocols or ports, 
> this would be completely nonsensical. It is also why I am dead against 
> the idea 'in' and 'out' to be considered as simply a "synonym" of 'src' 
> and 'dst' as you suggest below.
> 
> Again, 'in' and 'out' are only meant and should only be used for 
> interfaces, nothing else.
> 
> >  Or should those be rejected? But then it'd mean that if someone used a
> > hash:net,iface type as a member of list:set, then he is forced to use "src",
> > "dst" only.
> >   
> It would help if I use an example for this.
> 
> If I create a list set (lets call it list1) consisting of, say, 2
> hash:net,iface set members (lets call them iface1 and iface2) and 3 other
> hash:ip,port set members (lets call them ipp1, ipp2 and ipp3) and if I then
> execute the following iptables statement:
> 
> iptables -A INPUT -m set --match-set list1 src,in -j ACCEPT
> 
> The above statement will *only* match packets against members of the list1 set
> which have a matching source IP address and incoming interface - iface1 and
> iface2 in this case. ipp1, ipp2 and ipp3 won't be matched.
> 
> This makes perfect sense, given what I have written above (and in the 
> patches I submitted yesterday) about the definition of 'in' and 'out' - 
> it means match *only* against the incoming or outgoing interfaces.
> 
> However, if I execute the following iptables statement:
> 
> iptables -A INPUT -m set --match-set list1 src,src -j ACCEPT

This creates more confusion for the users than the current state: one 
had to keep in mind what kind of sets are stored in a list of sets and 
depending on them, use "src/dst" or "in/out" in the second direction 
parameter. And additionally,

iptables -A INPUT -m set --match-set list1 src,src -j ACCEPT

and

iptables -A INPUT -m set --match-set list1 src,in -j ACCEPT

produced different results for the same member sets with the same elements 
against the same packets. This is unacceptable for me.

> That would match packets against *all* members of the list1 set (iface1,
> iface2, ipp1, ipp2 and ipp3 this time) which have a matching source IP
> address, incoming interface as well as src port values. Again, I see nothing
> wrong with that and the fact that there is additional "filter" for 'in' and
> 'out' values - well, I consider this an added feature, if anything.
> 
> > It'd be much simpler to introduce the keywords as aliases, all over:
> > "in" as "dst" and "out" as "src", and print them with hash:net,iface only.
> >   
> Simpler for whom? It can't be for the end user, because referring to, say,
> destination IP address as "out" IP address is even more ridiculous than using
> 'src' and 'dst' designators for network interfaces. Quite astonishing that!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
