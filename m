From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH conntrack-tools] conntrack: add zone direction support
Date: Tue, 29 Sep 2015 20:40:10 +0200
Message-ID: <20150929184010.GA10092@salvia>
References: <9d0d25c2351442d8564063a51a7dc13fd1439e23.1440509200.git.daniel@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40051 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965377AbbI2SdV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Sep 2015 14:33:21 -0400
Content-Disposition: inline
In-Reply-To: <9d0d25c2351442d8564063a51a7dc13fd1439e23.1440509200.git.daniel@iogearbox.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 25, 2015 at 03:33:51PM +0200, Daniel Borkmann wrote:
> This patch adds support for zone directions.
> 
> Since all options have the orig/reply as a prefix, I named it --orig-zone
> and --reply-zone to stay consistent with the rest of the cmdline options.
> 
> As for the option chars, there was no unallocated reasonable combination,
> thus only long options are officially exposed in the help, similarly as in
> other cases.
> 
> Test suite results, after patch: OK: 79 BAD: 0

Applied, thanks.

