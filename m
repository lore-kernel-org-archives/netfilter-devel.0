From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/3] netfilter: nf_tables: limit maximum number of
 elements
Date: Sun, 5 Jan 2014 23:14:04 +0100
Message-ID: <20140105221404.GA4466@localhost>
References: <1388956728-6754-1-git-send-email-pablo@netfilter.org>
 <1388956728-6754-3-git-send-email-pablo@netfilter.org>
 <20140105215102.GA18661@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53825 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbaAEWOI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Jan 2014 17:14:08 -0500
Content-Disposition: inline
In-Reply-To: <20140105215102.GA18661@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jan 05, 2014 at 09:51:02PM +0000, Patrick McHardy wrote:
> On Sun, Jan 05, 2014 at 10:18:47PM +0100, Pablo Neira Ayuso wrote:
> > This patch adds a limit to the maximum number of elements that
> > belong to a set. It also adds a new field to count the current
> > number of elements, so in case that limit is reached, we hit
> > -ENOSPC.
> > 
> > This patch also adds two new attributes: NFTA_SET_MAXELEMS to
> > set and to indicate the current limit and NFTA_SET_NUMELEMS
> > to export the current number of set elements.
> 
> This affects the API, I'm really opposed to make any temporary
> fixes, but any temporary fix affecting the API is a complete
> no go IMO.

We need to limit elements in a set. I think it's not good that you can
add an unlimited number of sets, right?

This patch is independent of 1/3, which can be discarded. But 3/3
relies on it.
