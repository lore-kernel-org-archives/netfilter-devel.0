From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH v2 3/3] ipset: change 'iface' part in hash:net,iface set
Date: Mon, 16 Jul 2012 13:39:06 +0100
Message-ID: <50040B6A.608@googlemail.com>
References: <cover.1341871199.git.mr.dash.four@googlemail.com> <1341872622-5015-2-git-send-email-mr.dash.four@googlemail.com> <alpine.DEB.2.00.1207101721510.24998@blackhole.kfki.hu> <4FFCBDB8.9080101@googlemail.com> <alpine.DEB.2.00.1207112154070.26540@blackhole.kfki.hu> <4FFF6EF2.6010108@googlemail.com> <alpine.DEB.2.00.1207130857480.31126@blackhole.kfki.hu> <5000293F.4030901@googlemail.com> <alpine.DEB.2.00.1207131608230.32475@blackhole.kfki.hu> <50002F3F.5020408@googlemail.com> <alpine.DEB.2.00.1207141009340.1031@blackhole.kfki.hu> <5001678C.6000505@googlemail.com> <alpine.DEB.2.00.1207141816580.1593@blackhole.kfki.hu> <5002AF68.9070204@googlemail.com> <alpine.DEB.2.00.1207151552140.3610@blackhole.kfki.hu> <5002F0AF.4000502@googlemail.com> <alpine.DEB.2.00.1207152041270.4159@blackhole.k
 fki.hu> <500340DF.6070207@googlemail.com> <alpine.DEB.2.00.1207160924370.5297@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33360 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363Ab2GPMjS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jul 2012 08:39:18 -0400
Received: by eekc13 with SMTP id c13so158786eek.19
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jul 2012 05:39:17 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1207160924370.5297@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> hash:net,iface is the only type where "in/out" is natural and makes sense. 
> There are nine other types, not counting list:set, where "in/out" simply 
> doesn't fit in.
>   
I disagree. The use of in/out "makes sense" where the 'iface' part is 
used (by being used I mean where it produces matches, obviously). There 
are currently only 2 sets which are capable of that: hash:net,iface and 
list:set. That is where it "makes sense" to allow in/out. In all other 
sets, the chances of matching against 'iface' are nil and that is why it 
"makes sense" to not even consider introducing in/out there.

> And we are at list:set level, where all the members are hidden:
>
> iptables -A INPUT -m set --match-set list1 src,in -j ACCEPT
>
> You are actually telling me: "it's the user decision, he/she knows how to
> interpret "in" for all other types." But why should *one* type be favoured 
> in syntax against *nine* by list:set?
>   
Allowing in/out alongside src/dst isn't in any way "favouring" one over 
the other. If anything, I'd argue that by restricting list:set to only 
accept src/dst you are favouring that over in/out despite the fact that 
hash:net,iface could be used there as well.

As for the other "nine" types - see above. In/out only "makes sense" to 
be used where 'iface' is used. The last time I checked, the possibility 
of matching 'iface' in, say, bitmap:ip type set is the grant total of 
one big fat zero.

> And what would be the output when the rule above is listed/saved? This 
> one?:
>
> -A INPUT -m set --match-set list1 src,src -j ACCEPT
>
> Then we are enforcing the syntax and someone has to scratch the head.
>   
The output (i.e. what the user sees after the actual rule is entered) is 
a different issue altogether from the input, which is what we are 
currently discussing.

If in/out is allowed, then the output can take many forms acceptable to 
the user and there are many different ways in which that output could be 
produced in such a way so that there are no ambiguities as to what will 
be matched against, particularly with the new enhancements to the print 
functions in the set match/target I introduced.

Provided in/out is accepted as input in list:set types, I am confident I 
could produce output which will be consistent with what was entered and 
what ipset will match against and there will be no ambiguities.

> Moreover, if "in/out" is allowed with list:set types, which means that 
> actually all set types "support" them when they are members of list:set, 
>   
How did you manage to conclude that exactly? Look at the first paragraph 
I have written above - hash:net,iface (and the 'iface' part in 
particular) can only be registered/seen/used/deployed in two type of 
sets: hash:net,iface and list:set.

Let me ask you this then - what do you think 'in' and 'out' is?

> why isn't it supported openly for every type?
Because the 'iface' part isn't supported in any other types, that's why.

> No. Send your patches according to solution a, that is the "in/out" 
> keywords are allowed only with hash:net,iface type of sets alone and 
> rejected with a proper error message when attempted to use with any other 
> set type.
>   
You keep banging on about "send me the patches according to solution a", 
but you are unwilling or unable to address the consequences of this and 
the issues I raised in this regard. Once this is done and I am convinced 
that this is the way to go, I'll send you the new patches.

This isn't some sort of Stalin-like republic where you can just order me 
to "send you the patches" and I do as I am told, OK? This is a free 
forum where we, as peers, are allowed to discuss these issues. If you 
are unable to hold to your arguments after I shot them to pieces, do you 
think that by ordering me to "send you the patches" I am going to 
concede and do as I am told?

Or do you think that just because you've written parts of the ipset code 
you could just order me to "send you the patches" I'll bow my head and 
say "yes, sir, I'll do it sir, right away sir"? Really? Get a grip of 
yourself Jozsef!
