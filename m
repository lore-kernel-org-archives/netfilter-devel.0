From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables PATCH] netfilter: nft_ct: fix unconditional dump of
 'dir' attr
Date: Wed, 29 Jan 2014 20:22:34 +0100
Message-ID: <20140129192234.GA11531@localhost>
References: <20140117012845.2934.34608.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44575 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079AbaA2TWt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Jan 2014 14:22:49 -0500
Content-Disposition: inline
In-Reply-To: <20140117012845.2934.34608.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 17, 2014 at 02:28:45AM +0100, Arturo Borrero Gonzalez wrote:
> We want to make sure that the information that we get from the kernel can be
> reinjected without troubles.
> 
> The kernel shouldn't return an attribute that is not required, or even
> prohibited.
> 
> Dump unconditionally NFTA_CT_DIRECTION could lead an application in
> userspace to interpret that the attribute was originally set, while it was not.

Applied, thanks Arturo.
