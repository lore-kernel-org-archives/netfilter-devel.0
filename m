From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft next-3.14 PATCH] netlink: delete unused function calls
Date: Tue, 18 Feb 2014 00:20:47 +0100
Message-ID: <20140217232046.GA21053@localhost>
References: <20140217101057.5762.64983.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43220 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752885AbaBQXUw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Feb 2014 18:20:52 -0500
Content-Disposition: inline
In-Reply-To: <20140217101057.5762.64983.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 17, 2014 at 11:10:57AM +0100, Arturo Borrero Gonzalez wrote:
> These functions calls, and the related `struct nft_table *nlt' are unused.

Applied, thanks Arturo.

Changed the title and description to insist on the unused variable.
