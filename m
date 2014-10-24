From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH] ruleset: deconstify _get interface
Date: Fri, 24 Oct 2014 11:54:05 +0200
Message-ID: <20141024095405.GA3840@salvia>
References: <20141020194515.3402.28281.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39351 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755390AbaJXJwb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Oct 2014 05:52:31 -0400
Content-Disposition: inline
In-Reply-To: <20141020194515.3402.28281.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 20, 2014 at 09:46:09PM +0200, Arturo Borrero Gonzalez wrote:
> Having this interface returning a const pointer makes very hard to
> modificate the content of a chain contained in a nft_ruleset.

Applied, thanks.
