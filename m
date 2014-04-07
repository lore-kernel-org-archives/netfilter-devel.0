From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH] examples: complete nft-events example
Date: Mon, 7 Apr 2014 10:54:31 +0200
Message-ID: <20140407085431.GA9807@localhost>
References: <20140401120643.4333.51861.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35557 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbaDGIyh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Apr 2014 04:54:37 -0400
Content-Disposition: inline
In-Reply-To: <20140401120643.4333.51861.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 01, 2014 at 02:06:44PM +0200, Arturo Borrero Gonzalez wrote:
> Complete nft-events example by adding a basic set & set_elem event
> notification.

Applied, thanks Arturo.

The set element event support will show up in kernels >= 3.16, but
this example code doesn't harm, we won't just get any set element
event line in the output meanwhile.
