From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Formal submission of Xtables2
Date: Thu, 13 Dec 2012 18:25:23 +0100
Message-ID: <20121213172523.GB14333@1984>
References: <alpine.LNX.2.01.1212130601210.9421@nerf07.vanv.qr>
 <20121213110046.GA22337@1984>
 <alpine.LNX.2.01.1212131214100.20007@nerf07.vanv.qr>
 <20121213120509.GA26118@1984>
 <alpine.LNX.2.01.1212131405170.786@nerf07.vanv.qr>
 <20121213142820.GA3489@1984>
 <alpine.LNX.2.01.1212131528410.1273@nerf07.vanv.qr>
 <20121213151615.GA6962@1984>
 <alpine.LNX.2.01.1212131623480.10856@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Netfilter user mailing list <netfilter@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1212131623480.10856@nerf07.vanv.qr>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Dec 13, 2012 at 05:41:28PM +0100, Jan Engelhardt wrote:
> On Thursday 2012-12-13 16:16, Pablo Neira Ayuso wrote:
> 
> >On Thu, Dec 13, 2012 at 03:53:45PM +0100, Jan Engelhardt wrote:
> >[...]
> >> In my opinion, there is nothing wrong with keeping some concepts. A
> >> developer is not required to reevaluate and reinnovate every concept
> >> there has been just for the heck of it. (The old "evolution, not
> >> revolution" credo.) Throwing everything overboard generally does not
> >> turn out to work these days.
> >
> >Nobody is going to throw everything overboard. Nftables is backward
> >compatible while providing a new framework[,]
> 
> That sounds just like xt2. Compatibility exists such that there is a 
> defined mapping from xt1->xt2 rules (at one point I did write a 
> setsockopt translator in the past...); the userspace tool mimics 
> iptables in syntax, though I have allowed myself to not have certain 
> options in the CLI tool.

We provided that compatibility layer that mimics iptables in Oct 2012
[1]. However, it seems you prefered to code it your way from almost
scratch, that's confusing.

> New framework, same thing, I guess. xt_core is independent of
> xt_nfnetlink and I do not see any hurdle in introducing new concepts
> if so desired.

We have already new concepts in nftables, have a look at it.

Please, I think this conversation just started spinning and the same
arguments are showing up over and over again, it's time to stop this.

[1] http://www.spinics.net/lists/netfilter-devel/msg23831.html
