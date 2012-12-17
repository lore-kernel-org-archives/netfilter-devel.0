From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Formal submission of Xtables2
Date: Mon, 17 Dec 2012 10:53:30 +0100
Message-ID: <20121217095330.GA17148@1984>
References: <20121213120509.GA26118@1984>
 <alpine.LNX.2.01.1212131405170.786@nerf07.vanv.qr>
 <20121213142820.GA3489@1984>
 <alpine.LNX.2.01.1212131528410.1273@nerf07.vanv.qr>
 <20121213151615.GA6962@1984>
 <alpine.LNX.2.01.1212131623480.10856@nerf07.vanv.qr>
 <20121213172523.GB14333@1984>
 <alpine.LNX.2.01.1212131826040.5486@nerf07.vanv.qr>
 <20121217000841.GA9331@1984>
 <alpine.LNX.2.01.1212170214350.29351@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Netfilter user mailing list <netfilter@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59900 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab2LQJxx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2012 04:53:53 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1212170214350.29351@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 17, 2012 at 02:39:07AM +0100, Jan Engelhardt wrote:
> On Monday 2012-12-17 01:08, Pablo Neira Ayuso wrote:
> 
> >On Thu, Dec 13, 2012 at 07:19:28PM +0100, Jan Engelhardt wrote:
> >[...]
> >> Each of us are (understandably) biased, as each has contributed
> >> to "their" implementation. But, you also have the decisive power as
> >> the Linux kernel Netfilter subsystem maintainer, and I fear that you
> >> might use this to reject xt2 to force nft.
> >
> >I have to ask you to stick to technical arguments.
> 
> Ok, let me try again then. We should merge xtables2, because
> (some selected arguments follow):
> 
>  - It brings a NL-type (<- long-sought) interface
> 
>  - It uses a single table because there simply is no need
>    to have multiple ones. This has benefits for replacement atomicity 
>    guarantees, and gives some memory previously spent for modules
>    back to the user, for example.

You can implement this with nftables. Actually, nftables allows you to
have as many tables as you want. No matter what configuration you
select, it's extremely flexible.

>  - This table is NFPROTO_UNSPEC which means that the duplication of
>    rules between ip(4)tables and ip6tables users had to make is
>    gone, meaning less maintenance/complexity/etc. for the administrator, 
>    and of course, less rules lead to less memory usage.

Once single table means no table at all to me. We have also planned
adding agnostic tables to avoid the IPv4/IPv6 cases.

>  - and because it retains some characteristics, for example
>    atomic replaces and netns.
> 
> >You wrote on Thu, 13 Dec 2012 13:05:09 +0100:
> >>I don't think that feature-set provides compelling reasons to push [xt2]
> 
>    Not everybody cares about these things, that would be unrealistic.
>    However, some users, and me included, _do have_ an interest in having
>    what is presented, because they do e.g. run containers. Otherwise,
>    we would not be having netns in iptables today, right?

Again, those are completely possible with nftables.

> Now, don't dismiss these arguments.

So far, I haven't see any *strong reason* to drop nftables code and
write something from scratch as flexible as it is, my impression is
that you don't know how nftables is designed and it works, so you'll
have to tell me why I'm wrong.

As said, please provide convincing arguments, no more rants.
