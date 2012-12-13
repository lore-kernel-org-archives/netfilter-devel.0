From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Formal submission of Xtables2
Date: Thu, 13 Dec 2012 17:41:28 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1212131623480.10856@nerf07.vanv.qr>
References: <alpine.LNX.2.01.1212130601210.9421@nerf07.vanv.qr> <20121213110046.GA22337@1984> <alpine.LNX.2.01.1212131214100.20007@nerf07.vanv.qr> <20121213120509.GA26118@1984> <alpine.LNX.2.01.1212131405170.786@nerf07.vanv.qr> <20121213142820.GA3489@1984>
 <alpine.LNX.2.01.1212131528410.1273@nerf07.vanv.qr> <20121213151615.GA6962@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Netfilter user mailing list <netfilter@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:56638 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756525Ab2LMQlc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Dec 2012 11:41:32 -0500
In-Reply-To: <20121213151615.GA6962@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2012-12-13 16:16, Pablo Neira Ayuso wrote:

>On Thu, Dec 13, 2012 at 03:53:45PM +0100, Jan Engelhardt wrote:
>[...]
>> In my opinion, there is nothing wrong with keeping some concepts. A
>> developer is not required to reevaluate and reinnovate every concept
>> there has been just for the heck of it. (The old "evolution, not
>> revolution" credo.) Throwing everything overboard generally does not
>> turn out to work these days.
>
>Nobody is going to throw everything overboard. Nftables is backward
>compatible while providing a new framework[,]

That sounds just like xt2. Compatibility exists such that there is a 
defined mapping from xt1->xt2 rules (at one point I did write a 
setsockopt translator in the past...); the userspace tool mimics 
iptables in syntax, though I have allowed myself to not have certain 
options in the CLI tool. New framework, same thing, I guess. xt_core is 
independent of xt_nfnetlink and I do not see any hurdle in introducing 
new concepts if so desired.
