From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] nft: loop optimization
Date: Thu, 20 Jun 2013 14:37:47 +0200
Message-ID: <20130620123747.GA7494@localhost>
References: <20130619111423.7135.60976.stgit@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34159 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754724Ab3FTMhx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jun 2013 08:37:53 -0400
Content-Disposition: inline
In-Reply-To: <20130619111423.7135.60976.stgit@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 19, 2013 at 01:14:23PM +0200, Giuseppe Longo wrote:
> This patch prevent in some functions to continue looping after the chain is found.

Applied, thanks Giuseppe!
