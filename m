From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] chain: xml: delete <use> node
Date: Mon, 12 Aug 2013 11:36:16 +0200
Message-ID: <20130812093616.GC6546@localhost>
References: <20130812073534.20663.87896.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58731 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755341Ab3HLJgU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Aug 2013 05:36:20 -0400
Content-Disposition: inline
In-Reply-To: <20130812073534.20663.87896.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 12, 2013 at 09:35:34AM +0200, Arturo Borrero Gonzalez wrote:
> Since the 'use' attribute in a chain can't be set, ignore it in the
> XML printing.

Makes sense. Applied, thanks.
