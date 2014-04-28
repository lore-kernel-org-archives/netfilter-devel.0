From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] mnl: split talk() and recv() functions
Date: Mon, 28 Apr 2014 16:52:53 +0200
Message-ID: <20140428145253.GA29116@localhost>
References: <20140428144709.20021.74777.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36965 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756338AbaD1OxD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Apr 2014 10:53:03 -0400
Content-Disposition: inline
In-Reply-To: <20140428144709.20021.74777.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 28, 2014 at 04:48:09PM +0200, Arturo Borrero Gonzalez wrote:
> Let's split talk() and recv() functions, so they can be used independently.
> 
> While at it, lets rename mnl_talk() to nft_mnl_talk() so we avoid potential
> clashes with other functions in external libs.

Applied, thanks.
