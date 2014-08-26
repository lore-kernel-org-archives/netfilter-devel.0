From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: nft option to flush out the existing ruleset [was Re: [libnftnl
 PATCH] examples: add nft-ruleset-replace]
Date: Tue, 26 Aug 2014 13:09:54 +0200
Message-ID: <20140826110954.GA5648@salvia>
References: <20140826095716.3463.89684.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53659 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757843AbaHZLJX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Aug 2014 07:09:23 -0400
Content-Disposition: inline
In-Reply-To: <20140826095716.3463.89684.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Renaming the subject to make it to start a new discussion on something
related. Cc'ing Patrick too, perhaps he can pull some better idea out
of his hat.

On Tue, Aug 26, 2014 at 11:57:16AM +0200, Arturo Borrero Gonzalez wrote:
> This code examples uses the new NFT_MSG_DELTABLE functionality to replace
> an entire ruleset in a single transaction/batch.

Thanks for the example but we already have quite a lot of them, and
this is yet another almost copy and paste that would need to be
maintained.

Please, implement this in nft. I think we can probably have an -x
option, eg.

nft -f -x ruleset-file

The '-x' indicates that you want to flush any previous existing
configuration before loading this 'ruleset-file'.

-xx could also be used to remove any configuration regarding the
existing families in the ruleset-file, ie. if the ruleset-file only
contains a configuration for 'ip', all remaining families are left
untouched.

