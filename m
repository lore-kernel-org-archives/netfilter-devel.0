From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf-next PATCH v5] netfilter: nf_tables: add support for
 inverted logic in nft_lookup
Date: Thu, 23 Jun 2016 19:40:29 +0200
Message-ID: <20160623174029.GA3607@salvia>
References: <146667735220.10551.13573034041353542334.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56847 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbcFWRki (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jun 2016 13:40:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id D3DFD8D051C
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 19:40:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BF9F39EBA8
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 19:40:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A48FC9EBA0
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 19:40:34 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <146667735220.10551.13573034041353542334.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 23, 2016 at 12:24:08PM +0200, Arturo Borrero Gonzalez wrote:
> Introduce a new configuration option for this expression, which allows users
> to invert the logic of set lookups.
> 
> In _init() we will now return EINVAL if NFT_LOOKUP_F_INV is in anyway
> related to a map lookup.
> 
> The code in the _eval() function has been untangled and updated to sopport the
> XOR of options, as we should consider 4 cases:
>  * lookup false, invert false -> NFT_BREAK
>  * lookup false, invert true -> return w/o NFT_BREAK
>  * lookup true, invert false -> return w/o NFT_BREAK
>  * lookup true, invert true -> NFT_BREAK

Applied, thanks.
