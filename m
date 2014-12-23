From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ebtables-compat PATCH] ebtables-compat: fix counter listing
Date: Tue, 23 Dec 2014 14:28:02 +0100
Message-ID: <20141223132802.GA15431@salvia>
References: <20141223122426.22985.47607.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, giuseppelng@gmail.com
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33490 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755829AbaLWNZe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Dec 2014 08:25:34 -0500
Content-Disposition: inline
In-Reply-To: <20141223122426.22985.47607.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 23, 2014 at 01:24:26PM +0100, Arturo Borrero Gonzalez wrote:
> With this patch:
> 
> % sudo ebtables-compat -L --Lc
> Bridge table: filter
> 
> Bridge chain: INPUT, entries: 0, policy: ACCEPT
> -j ACCEPT , pcnt = 123 -- bcnt = 123

Applied to the ebtables-compat-experimental branch, thanks.
