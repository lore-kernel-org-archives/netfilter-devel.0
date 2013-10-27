From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [BUG] libnftables: NULL pointer dereference in
 nft_expr_ops_lookup
Date: Sun, 27 Oct 2013 21:21:57 +0100
Message-ID: <20131027202157.GA6894@localhost>
References: <20131025152735.65d354bd@griffin>
 <20131025150436.GA7536@localhost>
 <20131025174651.49d97445@griffin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jiri Benc <jbenc@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59500 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754058Ab3J0UWG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Oct 2013 16:22:06 -0400
Content-Disposition: inline
In-Reply-To: <20131025174651.49d97445@griffin>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 25, 2013 at 05:46:51PM +0200, Jiri Benc wrote:
> On Fri, 25 Oct 2013 17:04:36 +0200, Pablo Neira Ayuso wrote:
> > reject support was never finished. Please, find enclosed patches for
> > libnftables and nft.
> 
> That was fast, thanks! Seems to work.
> 
> Tested-by: Jiri Benc <jbenc@redhat.com>

Applied, thanks.
