From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft PATCH 0/8] nft event monitor
Date: Mon, 14 Apr 2014 14:35:44 +0200
Message-ID: <20140414123543.GA21327@macbook.localnet>
References: <20140414101634.5018.86819.stgit@nfdev.cica.es>
 <20140414123252.GB21947@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60753 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbaDNMfr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2014 08:35:47 -0400
Content-Disposition: inline
In-Reply-To: <20140414123252.GB21947@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 14, 2014 at 02:32:52PM +0200, Pablo Neira Ayuso wrote:
> On Mon, Apr 14, 2014 at 12:17:03PM +0200, Arturo Borrero Gonzalez wrote:
> > The following series implements a basic nftables monitor via Netlink messages.
> 
> Nice series.
> 
> > Most of the work in first patches is related to refactorization/generalization
> > of code.
> > 
> > The final patch is the big one.
> 
> This time is OK with me, but next time you can probably split it in
> smaller chunks, so you add table events in one patch, then chain event
> in another, and so on. So 8/8 gets distributed is several patches. But
> I think it's also reasonable to have it in one patch for this time.
> 
> Please wait to see if Patrick and others have comments on it and then
> go revisit 8/8, thanks Arturo.

I'm fine with these patches. If you resend just 8/8 I can apply them.
