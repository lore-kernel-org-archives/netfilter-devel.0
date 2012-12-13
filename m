From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Formal submission of Xtables2
Date: Thu, 13 Dec 2012 19:19:28 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1212131826040.5486@nerf07.vanv.qr>
References: <alpine.LNX.2.01.1212130601210.9421@nerf07.vanv.qr> <20121213110046.GA22337@1984> <alpine.LNX.2.01.1212131214100.20007@nerf07.vanv.qr> <20121213120509.GA26118@1984> <alpine.LNX.2.01.1212131405170.786@nerf07.vanv.qr> <20121213142820.GA3489@1984>
 <alpine.LNX.2.01.1212131528410.1273@nerf07.vanv.qr> <20121213151615.GA6962@1984> <alpine.LNX.2.01.1212131623480.10856@nerf07.vanv.qr> <20121213172523.GB14333@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Netfilter user mailing list <netfilter@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <20121213172523.GB14333@1984>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Thursday 2012-12-13 18:25, Pablo Neira Ayuso wrote:
>> >> turn out to work these days.
>> >
>> >Nobody is going to throw everything overboard. Nftables is backward
>> >compatible while providing a new framework[,]
>> 
>> That sounds just like xt2. Compatibility exists such that there is a 
>> defined mapping from xt1->xt2 rules (at one point I did write a 
>> setsockopt translator in the past...); the userspace tool mimics 
>> iptables in syntax, though I have allowed myself to not have certain 
>> options in the CLI tool.
>
>We provided that compatibility layer that mimics iptables in Oct 2012
>[1]. However, it seems you prefered to code it your way from almost
>scratch, that's confusing.

That's just not true; I did post before on the xt2 matter as well,
in its various stages.

xtables2_a8: http://marc.info/?l=netfilter-devel&m=132699055220975&w=2
xtables2_a7: https://lwn.net/Articles/426896/
             https://lwn.net/Articles/417619/

There is even older experimenting stuff in my git repo, which you
can look at. (The dates are not forged - you will have to trust me
on that.)



Each of us are (understandably) biased, as each has contributed
to "their" implementation. But, you also have the decisive power
as the Linux kernel Netfilter subsystem maintainer, and I fear
that you might use this to reject xt2 to force nft.
That thought _terrifies_ me, and were it so, it would not be an
environment I want to work in.

Just say so if I am to GTFO.
