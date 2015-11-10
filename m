From: Patrick McHardy <kaber@trash.net>
Subject: Re: nft synproxy integration
Date: Tue, 10 Nov 2015 02:05:20 +0000
Message-ID: <20151110020519.GA5514@macbook.localdomain>
References: <20151109163015.GM8098@macbook.localdomain>
 <alpine.DEB.2.10.1511092030480.30088@blackhole.kfki.hu>
 <8670E62A-489B-41B4-A89B-AAF740264ACA@trash.net>
 <20151109222953.GC7759@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>, pablo@netfilter.org,
	netfilter-devel@vger.kernel.org, bjornar.ness@gmail.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:53945 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751616AbbKJCFa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Nov 2015 21:05:30 -0500
Content-Disposition: inline
In-Reply-To: <20151109222953.GC7759@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 09.11, Florian Westphal wrote:
> Patrick McHardy <kaber@trash.net> wrote:
> > Am 9. November 2015 19:36:06 GMT+00:00, schrieb Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>:
> > >On Mon, 9 Nov 2015, Patrick McHardy wrote:
> > >> The method of using notrack would of course still be possible.
> > >
> > >I like the idea: the notrack method would still be supported and the
> > >"do 
> > >conntrack but with safety-net" way would be possible too. Looks cool!
> > 
> > Thanks Jozsef. I'm thinking it's the best of both worlds myself. Implementation should be quite easy, I'll give it a try.
> 
> I'm fine with the suggestion, but, pardon the heretic question:
> 
> Why do we need synproxy after the recent listen lock removal from Eric?

Simple answer is - its for the network, not for the host :)
