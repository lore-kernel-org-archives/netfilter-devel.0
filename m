From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset-5.0 released
Date: Tue, 28 Dec 2010 20:26:46 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1012281945380.12537@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1012172259100.10231@blackhole.kfki.hu> <4D0E0E2A.3090604@googlemail.com> <4D0E22A5.8090808@conversis.de> <4D0E3B34.7090105@googlemail.com> <alpine.DEB.2.00.1012221146060.3482@blackhole.kfki.hu> <4D11F384.3070908@googlemail.com>
 <alpine.DEB.2.00.1012231558390.6044@blackhole.kfki.hu> <4D138C02.3050905@googlemail.com> <alpine.DEB.2.00.1012232008520.6582@blackhole.kfki.hu> <4D13CBD8.3090007@googlemail.com> <alpine.DEB.2.00.1012232337070.7027@blackhole.kfki.hu>
 <alpine.DEB.2.00.1012232354510.7109@blackhole.kfki.hu> <4D13D60C.3020304@googlemail.com> <alpine.DEB.2.00.1012261125100.9618@blackhole.kfki.hu> <4D17475B.9000909@googlemail.com> <alpine.DEB.2.00.1012262034390.10148@blackhole.kfki.hu> <4D17B730.8040505@googlemail.com>
 <alpine.DEB.2.00.1012271517330.11100@blackhole.kfki. hu> <4D18BD80.2030807@googlemail.com> <alpine.DEB.2.00.1012271854400.11291@blackhole.kfki .hu> <4D18E070.6010107@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Dennis Jacobfeuerborn <dennisml@conversis.de>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:43537 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867Ab0L1T0u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Dec 2010 14:26:50 -0500
In-Reply-To: <4D18E070.6010107@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 27 Dec 2010, Mr Dash Four wrote:

> > > Fair enough. Any idea when ipset 5.2 will be incorporated into 
> > > xtables so that I could download it and start testing it? *nudges 
> > > Jan*
> > 
> > You constantly ignore the difference between xtables and xtables-addons...
> >   
> You know exactly what I meant.

I hope, but still one cannot be sure.

We call the unified part of iptables and ip6tables to xtables and it's in 
the "iptables" package which has never included ipset (except the 
userspace match/target interfaces).

The "xtables-addons" package is the successor of patch-o-matic-ng for 
extensions which are not (yet) accepted in netfilter and Jan included 
ipset into it.

So please take the trouble and use the correct term.
 
> > > If I understand you correctly, you keep a separate structure which 
> > > stores all prefixes used in the target set, walk through that 
> > > structure and for each element you build start-end range based on 
> > > the IP address captured and the current prefix. You then create a 
> > > hash on the calculated start-end range, protocol and port triple and 
> > > then test that hash against the hash value of the target set triple 
> > > (IP range, protocol, port). Is that how you do it?
> > 
> > No, there's no point to store start-end ranges: the network address and the
> > prefix is stored, which thus require less memory compared to the range.
> >   
> OK, so you store IP address and then the range.

The IP address and the prefix is stored. Which can easily be converted 
into a range anytime.

> Do you then perform the process as I described above in order to find a 
> match?

Leaving out the range stuff, more-or-less yes. In order to test an 
element:

1. The IP address is masked with the first prefix from the list of
   prefixes in the set.
2. The resulted address and prefix are hashed; or if it's a hash:net,port 
   type, then the resulted address, prefix, protocol number and port 
   number are hashed
3. The hash slot is looked up and searched for a matching entry
4. If there's no match, then (virtually) shift off the first prefix from 
   the list of the prefixes and goto 1.
5. If there's a match then report success. If the list of prefixes is
   empty, report failure.
 
> On a separate note, once I've installed ipset 5.2 I am very keen on testing
> both type of sets (iptreemap and the new hash set) to see what is the
> performance penalty with the new sets (there will probably be one as your
> search algorithm is more complex in 5.x and would require more iterations
> compared with the 4.x type sets).

Different methods give different results depending on what you measure: 
insert element, delete, lookup, lookup non-matching entry, memory usage. 
Have a look at Rusty Russell's hash comparisons:
http://rusty.ozlabs.org/?p=94. The measuring of the previous hashing 
method in ipset 5.x can be found here: 
http://www.kfki.hu/~kadlec/sw/netfilter/hash/. The current one was also 
compared to other algorithms but I haven't had time yet to write the 
summary.

I'm looking forward to see your results.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
