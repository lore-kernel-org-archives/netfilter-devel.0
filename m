From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Accounting objects support in nft
Date: Mon, 12 Jan 2015 13:19:36 +0100
Message-ID: <20150112121936.GA4405@salvia>
References: <cover.1421059192.git.ana@soleta.eu>
 <20150112113926.GA3491@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ana@soleta.eu, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60253 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbbALMQv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2015 07:16:51 -0500
Content-Disposition: inline
In-Reply-To: <20150112113926.GA3491@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 12, 2015 at 11:39:27AM +0000, Patrick McHardy wrote:
> On 12.01, ana@soleta.eu wrote:
> > From: Ana Rey Botello <ana@soleta.eu>
> > 
> > Hi,
> > 
> > With this patchset, we add accounting objects support to let us
> > manipulate extended accounting objects.
> > 
> > Example of use in nft:
> > 
> >  # nft add acct ip filter http-traffic
> >  # nft add acct ip filter https-traffic
> > 
> >  # nft add rule ip filter output tcp dport 80 acct http-traffic
> >  # nft add rule ip filter output tcp dport 443 acct https-traffic
> 
> I'm wondering whether we really should use a new keyword for this
> or do something similar to sets where we have named and anonymous
> variants.
> 
> An alternative would be:
> 
> nft add counter ip filter http-traffic
> nft filter output tcp dport 80 counter http-traffic
> 
> It is after all just a named counter, so it seems clearer to me to
> reuse the keyword.

I like this named counters idea.

So Ana, respin to include the changes in nft_counter instead.

Also rename all _acct to _counter instead.

Thanks.
