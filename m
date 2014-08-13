From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 1/3] examples: fix nft-chain-add by adding
 batching support
Date: Wed, 13 Aug 2014 18:57:49 +0200
Message-ID: <20140813165749.GA8535@salvia>
References: <20140811101938.10640.47989.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55530 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965AbaHMQ53 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Aug 2014 12:57:29 -0400
Content-Disposition: inline
In-Reply-To: <20140811101938.10640.47989.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Arturo,

On Mon, Aug 11, 2014 at 12:19:38PM +0200, Arturo Borrero Gonzalez wrote:
> This code example doesn't work, as the kernel API is only listening to messages
> in batches.
> 
> This patch updates the example to add the needed batching support.

I just sent three patches to the mailing list. Could you rework these
patches to use the batching interface? I have included the rework of
the chain-add as example.

Thanks.
