From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ebtables-compat PATCH v2] ebtables-compat: fix segfault in
 rules w/o target
Date: Tue, 6 Jan 2015 22:18:50 +0100
Message-ID: <20150106211850.GA5942@salvia>
References: <20150105142519.26315.13246.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, giuseppelng@gmail.com
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57818 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbbAFVQF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Jan 2015 16:16:05 -0500
Content-Disposition: inline
In-Reply-To: <20150105142519.26315.13246.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 05, 2015 at 03:28:46PM +0100, Arturo Borrero Gonzalez wrote:
> This patch fixes a segfault in rules without target.
> 
> Now, these two rules are allowed:
> 
> % ebtables-compat -A FORWARD -p 0x0600 -j CONTINUE
> % ebtables-compat -A FORWARD -p 0x0600
> 
> And both are printed:
> 
> Bridge chain: FORWARD, entries: 1, policy: ACCEPT
> -p 0x600 -j CONTINUE

> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
> v2: address comments by Pablo.
> 
> The printing path doesn't require special handling. There are 3 cases:
>  * a target extension (unsupported yet)
>  * an user-defined chain (in this case, cs->jumpto contains the chain name)
>  * nothing (in this case, cs->jumpto contains "", and we should print CONTINUE)

OK, applied, thanks.
