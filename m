From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] test: xml: fix malformed ruleset testfile
Date: Sun, 27 Oct 2013 21:01:07 +0100
Message-ID: <20131027200107.GA6569@localhost>
References: <20131024150058.21634.49651.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57722 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397Ab3J0UBL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Oct 2013 16:01:11 -0400
Content-Disposition: inline
In-Reply-To: <20131024150058.21634.49651.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 24, 2013 at 05:00:58PM +0200, Arturo Borrero Gonzalez wrote:
> Give a new XML ruleset testfile. For some reason, the previous was truncated.
> This passed silently as nft-parsing-test is not reporting some errors properly.
> 
> This new file provides:
>  * 2 tables
>  * 3 chains
>  * 2 sets, with and without maps
>  * 3 rules with mixed exprs

Applied, thanks Arturo.
