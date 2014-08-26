From: Patrick McHardy <kaber@trash.net>
Subject: Re: nft option to flush out the existing ruleset [was Re: [libnftnl
 PATCH] examples: add nft-ruleset-replace]
Date: Tue, 26 Aug 2014 13:14:20 +0100
Message-ID: <20140826121420.GA22955@acer.localdomain>
References: <20140826095716.3463.89684.stgit@nfdev.cica.es>
 <20140826110954.GA5648@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62122 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934323AbaHZMO0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Aug 2014 08:14:26 -0400
Content-Disposition: inline
In-Reply-To: <20140826110954.GA5648@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 26, 2014 at 01:09:54PM +0200, Pablo Neira Ayuso wrote:
> Renaming the subject to make it to start a new discussion on something
> related. Cc'ing Patrick too, perhaps he can pull some better idea out
> of his hat.
> 
> On Tue, Aug 26, 2014 at 11:57:16AM +0200, Arturo Borrero Gonzalez wrote:
> > This code examples uses the new NFT_MSG_DELTABLE functionality to replace
> > an entire ruleset in a single transaction/batch.
> 
> Thanks for the example but we already have quite a lot of them, and
> this is yet another almost copy and paste that would need to be
> maintained.
> 
> Please, implement this in nft. I think we can probably have an -x
> option, eg.

Agreed. The naive aproach seems to be something like this:

- add a generation ID to the ruleset
- dump the entire ruleset
- generate delete commands for each existing rule/chain/set...
- generate add commands for each new rule/chain/set...
- send the entire thing to the kernel, including the generation ID
- if the generation ID doesn't match, meaning the ruleset has changed
  since the last dump, return an error to userspace, retry
