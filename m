From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nf_tables PATCH v4 5/5] netfilter: nft_nat: add masquerade
 support
Date: Thu, 4 Sep 2014 15:31:03 +0100
Message-ID: <20140904143103.GA1952@acer.localdomain>
References: <20140904120518.5971.77791.stgit@nfdev.cica.es>
 <20140904120710.5971.32117.stgit@nfdev.cica.es>
 <20140904122150.GF29395@acer.localdomain>
 <20140904124036.GA16426@salvia>
 <CAOkSjBjrTZzHhJkR6XHM7d97AXmoDwUNfqQ5RmqPYs7LZw46Gw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50594 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511AbaIDObL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Sep 2014 10:31:11 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBjrTZzHhJkR6XHM7d97AXmoDwUNfqQ5RmqPYs7LZw46Gw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 04, 2014 at 03:54:49PM +0200, Arturo Borrero Gonzalez wrote:
> On 4 September 2014 14:40, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > I like the idea of the masquerade expression.
> 
> Ok, I also like the idea.
> 
> Suggestions for the name of the new expression?
> 
> I would bet for nft_masq.

Sounds good.
