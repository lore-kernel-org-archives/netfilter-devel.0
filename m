From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] src: xml: refactor XML parsing code
Date: Mon, 16 Sep 2013 22:44:00 +0200
Message-ID: <20130916204400.GA11246@localhost>
References: <20130916182451.17068.80471.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41670 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab3IPUoH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Sep 2013 16:44:07 -0400
Content-Disposition: inline
In-Reply-To: <20130916182451.17068.80471.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 16, 2013 at 08:24:51PM +0200, Arturo Borrero Gonzalez wrote:
> This patch refactors nft_*_xml_parse to provide a new intermediate function
> nft_mxml_parse_* which will allow us to navigate an entire XML tree
> containing a ruleset without xml2text2xml conversions.
> 
> While at it, I added a helper to build the XML tree and validate the top node
> name.

Applied, thanks.
