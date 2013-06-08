From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] nft: fix leak of iterators
Date: Sat, 8 Jun 2013 14:46:12 +0200
Message-ID: <20130608124612.GA4601@localhost>
References: <20130608122435.4354.49219.stgit@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57430 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992Ab3FHMqS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Jun 2013 08:46:18 -0400
Content-Disposition: inline
In-Reply-To: <20130608122435.4354.49219.stgit@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jun 08, 2013 at 02:24:35PM +0200, Giuseppe Longo wrote:
> This patch fix leak of iterators

Applied, thanks Giuseppe.

We are still leaking list objects (track function nft_rule_list_get)
it has to be released as well. Can you send me a patch for that as
well?

Thanks.
