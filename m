From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v2] src: add masquerade support
Date: Thu, 9 Oct 2014 18:48:29 +0200
Message-ID: <20141009164829.GA12938@salvia>
References: <20141006195009.17830.37135.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43495 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbaJIQrM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Oct 2014 12:47:12 -0400
Content-Disposition: inline
In-Reply-To: <20141006195009.17830.37135.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 06, 2014 at 09:51:24PM +0200, Arturo Borrero Gonzalez wrote:
> This patch adds masquerade support for nft.
> 
> The syntax is:
> 
>  % nft add rule nat postrouting masquerade [flags]
> 
> Currently, flags are:
>  random, random-fully, persistent
> 
> Example:
>  % nft add rule nat postrouting masquerade random,persistent

Applied, thanks Arturo.

BTW, I mangled the error message for bridge to this:

# nft add rule bridge test test masquerade
<cmdline>:1:27-36: Error: ip and ip6 support only
add rule bridge test test masquerade
                          ^^^^^^^^^^

Please, send me a patch to unit test this and update
wiki.nftables.org. Thanks.
