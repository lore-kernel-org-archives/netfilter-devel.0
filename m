From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 1/2] netlink: monitor: add a helper function to
 handle sets referenced by a rule
Date: Mon, 21 Jul 2014 14:21:33 +0200
Message-ID: <20140721122133.GA4908@salvia>
References: <20140714115646.10384.69637.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55658 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754613AbaGUMV1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jul 2014 08:21:27 -0400
Content-Disposition: inline
In-Reply-To: <20140714115646.10384.69637.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 14, 2014 at 01:56:46PM +0200, Arturo Borrero Gonzalez wrote:
> This patch adds a helper function to handle lookup expressions with a callback,
> so we can make an action for each set referenced by the rule.
> 
> Basically is a refactorization, useful for follow-up patches.

Applied, thanks.
