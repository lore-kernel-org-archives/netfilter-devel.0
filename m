From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] utils: fix nft_str2verdict return value
Date: Sat, 18 Jan 2014 21:52:02 +0100
Message-ID: <20140118205202.GA4840@localhost>
References: <20140118160144.20804.20179.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40815 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393AbaARUwJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Jan 2014 15:52:09 -0500
Content-Disposition: inline
In-Reply-To: <20140118160144.20804.20179.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jan 18, 2014 at 05:01:44PM +0100, Arturo Borrero Gonzalez wrote:
> Some verdicts have a negative value.
> 
> The caller of nft_str2verdict() checking if return was < 0 clash with
> enum nft_verdict.
> 
> While at it, add error reporting of invalid verdicts.

Good catch, applied, thanks.
