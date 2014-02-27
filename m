From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] netlink: fix chain attribute parsing
Date: Thu, 27 Feb 2014 10:18:54 +0100
Message-ID: <20140227091854.GA4457@localhost>
References: <20140226174659.19715.82142.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53872 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbaB0JTD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Feb 2014 04:19:03 -0500
Content-Disposition: inline
In-Reply-To: <20140226174659.19715.82142.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 26, 2014 at 06:46:59PM +0100, Arturo Borrero Gonzalez wrote:
> The handle's table was being set to the chain name instead of the
> chain table attribute.

Applied, thanks Arturo.
