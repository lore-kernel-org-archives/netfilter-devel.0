From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH] examples: nft-rule-parse-add: fix wrong buffer
 usage when building rule header
Date: Mon, 17 Nov 2014 11:52:03 +0100
Message-ID: <20141117105203.GA4379@salvia>
References: <20141117092641.671.15727.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49540 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbaKQKuD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Nov 2014 05:50:03 -0500
Content-Disposition: inline
In-Reply-To: <20141117092641.671.15727.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 17, 2014 at 10:26:41AM +0100, Arturo Borrero Gonzalez wrote:
> The libmnl helper returns a pointer where to start putting the rule data.

Thanks Arturo.

I think it would be good to get rid of the -parse-* examples and
replace them by one using the ruleset API.
