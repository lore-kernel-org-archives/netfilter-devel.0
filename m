From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ebtables-compat-experimental3 PATCH 2/2] nft-bridge: fix
 printing of inverted protocols, addresses
Date: Mon, 10 Nov 2014 18:36:28 +0100
Message-ID: <20141110173628.GC29762@salvia>
References: <20141108213750.28047.14081.stgit@nfdev.cica.es>
 <20141108213938.28047.60010.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, giuseppelng@gmail.com
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45670 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279AbaKJReg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Nov 2014 12:34:36 -0500
Content-Disposition: inline
In-Reply-To: <20141108213938.28047.60010.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Nov 08, 2014 at 10:40:37PM +0100, Arturo Borrero Gonzalez wrote:
> Previous to this patch, no '!' is printed in payload comparisions.
> This patch solves it, so we can print for example inverted protocols:
> 
>  % ebtables-compat -L
> [...]
> -p ! 0x800 -j ACCEPT

Applied, thanks.
