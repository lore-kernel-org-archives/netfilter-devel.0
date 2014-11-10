From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 3/3] parser: allow both nat_flags and port
 specification in redirect
Date: Mon, 10 Nov 2014 18:22:49 +0100
Message-ID: <20141110172249.GC28853@salvia>
References: <20141107113924.8480.80701.stgit@nfdev.cica.es>
 <20141107113935.8480.16834.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42869 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785AbaKJRVE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Nov 2014 12:21:04 -0500
Content-Disposition: inline
In-Reply-To: <20141107113935.8480.16834.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 07, 2014 at 12:39:35PM +0100, Arturo Borrero Gonzalez wrote:
> This patch changes the parser to permit both nat_flags and port specification
> in the redirect expression.
> 
> The resulting syntax is:
>  % nft add rule nat prerouting redirect [port] [nat_flags]
> 
> The port specification requires a bit of context regardin the transport
> protocol. Some examples:
>  % nft add rule nat prerouting tcp dport 22 redirect :23
>  % nft add rule add prerouting udp dport 53 redirect :5353
> 
> The nat_flags argument is the last argument:
>  % nft add rule nat prerouting tdp dport 80 redirect :8080 random
> 
> The port specification can be a range:
>  % nft add rule nat prerouting tcp dport 80 redirect :8080-8090 random
> 
> While at it, the regression tests files are updated.

Applied, thanks.
