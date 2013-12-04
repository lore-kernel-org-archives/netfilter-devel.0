From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] mnl: fix name of called build_hdr functions
Date: Wed, 4 Dec 2013 12:16:28 +0100
Message-ID: <20131204111628.GA11920@localhost>
References: <20131202160718.19252.73477.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39111 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755438Ab3LDLQd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Dec 2013 06:16:33 -0500
Content-Disposition: inline
In-Reply-To: <20131202160718.19252.73477.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 02, 2013 at 05:07:18PM +0100, Arturo Borrero Gonzalez wrote:
> I think that using the right keyword improves readability.
> 
> Minor fix, given that all those functions are aliases.

I have also fixed the inconsistency in set_elem, it was using set
instead.

Applied, thanks Arturo.
