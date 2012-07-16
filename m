From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH v2 3/3] ipset: change 'iface' part in hash:net,iface
 set
Date: Mon, 16 Jul 2012 15:58:19 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1207161549410.5297@blackhole.kfki.hu>
References: <cover.1341871199.git.mr.dash.four@googlemail.com> <1341872622-5015-2-git-send-email-mr.dash.four@googlemail.com> <alpine.DEB.2.00.1207101721510.24998@blackhole.kfki.hu> <4FFCBDB8.9080101@googlemail.com> <alpine.DEB.2.00.1207112154070.26540@blackhole.kfki.hu>
 <4FFF6EF2.6010108@googlemail.com> <alpine.DEB.2.00.1207130857480.31126@blackhole.kfki.hu> <5000293F.4030901@googlemail.com> <alpine.DEB.2.00.1207131608230.32475@blackhole.kfki.hu> <50002F3F.5020408@googlemail.com> <alpine.DEB.2.00.1207141009340.1031@blackhole.kfki.hu>
 <5001678C.6000505@googlemail.com> <alpine.DEB.2.00.1207141816580.1593@blackhole.kfki.hu> <5002AF68.9070204@googlemail.com> <alpine.DEB.2.00.1207151552140.3610@blackhole.kfki.hu> <5002F0AF.4000502@googlemail.com> <alpine.DEB.2.00.1207152041270.4159@blackhole.kfki.hu>
 <500340DF.6070207@googlemail.com> <alpine.DEB.2.00.1207160924370.5297@blackhole.kfki.hu> <50040B6A.608@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:54878 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199Ab2GPN6W (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jul 2012 09:58:22 -0400
In-Reply-To: <50040B6A.608@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 16 Jul 2012, Mr Dash Four wrote:

> > hash:net,iface is the only type where "in/out" is natural and makes sense.
> > There are nine other types, not counting list:set, where "in/out" simply
> > doesn't fit in.
> >   
> I disagree. The use of in/out "makes sense" where the 'iface' part is used (by
> being used I mean where it produces matches, obviously). There are currently
> only 2 sets which are capable of that: hash:net,iface and list:set. That is
> where it "makes sense" to allow in/out. In all other sets, the chances of
> matching against 'iface' are nil and that is why it "makes sense" to not even
> consider introducing in/out there.

What you wrote was:

You:> What I have suggested to you was that you allow in/out to be 
You:> *entered*, as input, in a list:set (i.e. in the iptables statement), 
You:> but treated internally in the same way as src/dst ('in' to be 
You:> treated internally as 'src', 'out' as 'dst' obviously). In that way, 
You:> there won't be any discrepancies and the results from both 
You:> "solutions" will be the same. In other words (using the example you 
You:> gave earlier), typing:
You:> 
You:> -bash-~# iptables -A INPUT -m set --match-set list1 src,in -j ACCEPT
You:> 
You:> and
You:> 
You:> -bash-~# iptables -A INPUT -m set --match-set list1 src,src -j ACCEPT
You:> 
You:> to be both accepted  and 'in', as *entered* above, to be interpreted 
You:> in the same way as 'src'. That way there won't be any "different" 
You:> results.

So if list1 contains a hash:ip,port type alone, the rule

iptables -A INPUT -m set --match-set list1 src,in -j ACCEPT

is perfectly fine and logical. We circled again and I'm fed up.
 
> > No. Send your patches according to solution a, that is the "in/out" keywords
> > are allowed only with hash:net,iface type of sets alone and rejected with a
> > proper error message when attempted to use with any other set type.
> >   
> You keep banging on about "send me the patches according to solution a", but
> you are unwilling or unable to address the consequences of this and the issues
> I raised in this regard. Once this is done and I am convinced that this is the
> way to go, I'll send you the new patches.
> 
> This isn't some sort of Stalin-like republic where you can just order me to
> "send you the patches" and I do as I am told, OK? This is a free forum where
> we, as peers, are allowed to discuss these issues. If you are unable to hold
> to your arguments after I shot them to pieces, do you think that by ordering
> me to "send you the patches" I am going to concede and do as I am told?
> 
> Or do you think that just because you've written parts of the ipset code you
> could just order me to "send you the patches" I'll bow my head and say "yes,
> sir, I'll do it sir, right away sir"? Really? Get a grip of yourself Jozsef!

Stop this, now. I don't tolerate your style anymore.

I don't care what you do. I accept patches which I believe fit fine into 
the current system.

Bye,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
