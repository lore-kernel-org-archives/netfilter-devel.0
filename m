From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] utils: fix error path for nft_strtoi
Date: Tue, 20 Aug 2013 13:09:52 +0200
Message-ID: <20130820110952.GA4228@localhost>
References: <20130819123729.21346.17925.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35317 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878Ab3HTLJ5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Aug 2013 07:09:57 -0400
Content-Disposition: inline
In-Reply-To: <20130819123729.21346.17925.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 19, 2013 at 02:37:30PM +0200, Arturo Borrero Gonzalez wrote:
> If the return of nft_get_value() is not evaluated, we don't know if
> the parsed value is between the limits of his type.

Applied, thanks Arturo.
