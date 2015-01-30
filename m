From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ebtables-compat PATCH 1/2] libxtables: search first for
 AF-specific extension
Date: Fri, 30 Jan 2015 19:45:24 +0100
Message-ID: <20150130184524.GA23146@salvia>
References: <20150129164433.21224.14657.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44767 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbbA3Smc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Jan 2015 13:42:32 -0500
Content-Disposition: inline
In-Reply-To: <20150129164433.21224.14657.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 29, 2015 at 05:44:33PM +0100, Arturo Borrero Gonzalez wrote:
> There are some extension which may name-clash, for example:
>  * libxt_mark.so
>  * liebt_mark.so
> 
> Let's search first for AF-specific extension and then for the generic libxt_**.

Applied, thanks.
