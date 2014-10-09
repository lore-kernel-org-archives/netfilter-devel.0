From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 1/2] src: add nat persistent and random options
Date: Thu, 9 Oct 2014 14:17:00 +0200
Message-ID: <20141009121700.GA17680@salvia>
References: <20141003124641.9409.9789.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36770 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbaJIMPk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Oct 2014 08:15:40 -0400
Content-Disposition: inline
In-Reply-To: <20141003124641.9409.9789.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 03, 2014 at 02:46:41PM +0200, Arturo Borrero Gonzalez wrote:
> This patch adds more configuration options to the nat expression.
> 
> The syntax is as follow:
>  % nft add rule nat postrouting <snat|dnat> <nat_arguments> [flags]
> 
> Flags are: random, persistent, random-fully.
> Example:
> 
>  % nft add rule nat postrouting dnat 1.1.1.1 random,persistent
> 
> A requirement is to cache some [recent] copies of kernel headers.

Applied, thanks Arturo.

Please, send me a follow-up patch to add test for the new regression
testing infrastructure and document this in our wiki page.
