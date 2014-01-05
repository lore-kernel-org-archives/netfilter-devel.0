From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3] netfilter: nf_tables: fix suboptimal set selection
Date: Sun, 5 Jan 2014 22:34:03 +0100
Message-ID: <20140105213403.GA4158@localhost>
References: <1388956728-6754-1-git-send-email-pablo@netfilter.org>
 <1388956728-6754-2-git-send-email-pablo@netfilter.org>
 <20140105212406.GA13624@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52497 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335AbaAEVeJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Jan 2014 16:34:09 -0500
Content-Disposition: inline
In-Reply-To: <20140105212406.GA13624@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jan 05, 2014 at 09:28:35PM +0000, Patrick McHardy wrote:
> On Sun, Jan 05, 2014 at 10:18:46PM +0100, Pablo Neira Ayuso wrote:
> > The rb-tree is currently used for simple sets and maps with no
> > intervals which is suboptimal. Fix it by adding the weight field
> > to each existing set implementation, this value allows to select
> > the best candidate in case that several set types can be used.
> 
> Ohh, lets do this properly. This is one point why I was opposed to a
> merge at this stage, lets not paper over this but fix this how it
> was intended. I'll work on that after finishing the inet family.
> Until then no harm is done, just some memory waste.

Please, elaborate your plans on this.
