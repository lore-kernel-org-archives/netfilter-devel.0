From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH v2] examples: add nft-ruleset-get
Date: Sat, 4 Jan 2014 01:53:03 +0100
Message-ID: <20140104005303.GA5037@localhost>
References: <20131223141507.6481.39666.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43173 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754115AbaADAxH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Jan 2014 19:53:07 -0500
Content-Disposition: inline
In-Reply-To: <20131223141507.6481.39666.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 23, 2013 at 03:18:22PM +0100, Arturo Borrero Gonzalez wrote:
> This example prints the ruleset, using the ruleset API of nftables.
> 
> The kernel patch [b63108a] (netfilter: nf_tables: allow to dump sets with
> NFPROTO_UNSPEC) is required.

Updated this to point to c9c8e48 ("netfilter: nf_tables: dump sets in
all existing families").

Applied to -next, thanks Arturo.
