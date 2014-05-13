From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH v2] utils: fix buffer reallocation of
 nft_fprinft()
Date: Tue, 13 May 2014 17:23:32 +0200
Message-ID: <20140513152332.GA6857@localhost>
References: <20140513091658.20413.10155.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47529 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbaEMPXi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 May 2014 11:23:38 -0400
Content-Disposition: inline
In-Reply-To: <20140513091658.20413.10155.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 13, 2014 at 11:17:49AM +0200, Arturo Borrero Gonzalez wrote:
> When _snprintf() reports it would print n characters, that n doesn't include
> the trailing \0 that snprintf adds.
> 
> Thus, we need to [re]allocate n+1 characters.
> 
> While at it, change the reallocation trigger. If the length of the buffer we
> used is equals to the expanded string length, the output has been truncated.
> In other words, if ret == bufsiz, then the trailing \0 is missing.
> 
> Also, check if _snprintf() returned < 0, which means an error ocurred.

Applied, thanks Arturo.
