From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 1/2] mxml: add optional/mandatory flag to
 nft_mxml_reg_parse
Date: Wed, 15 Jan 2014 14:10:37 +0100
Message-ID: <20140115131037.GA22113@localhost>
References: <20140115104217.14095.79271.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@nefilter.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53849 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbaAONKm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jan 2014 08:10:42 -0500
Content-Disposition: inline
In-Reply-To: <20140115104217.14095.79271.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 15, 2014 at 11:42:17AM +0100, Arturo Borrero Gonzalez wrote:
> There are some cases where a reg is not mandatory, for example:
>  * dreg in lookup
>  * dreg/sreg in meta (last version)
> 
> So, lets change the function nft_mxml_reg_parse() to add
> an optional/mandatory flag.
> 
> dreg in lookup is optional as stated at:
>  net/netfilter/nft_lookup.c:nft_lookup_init()

Applied, thanks.
