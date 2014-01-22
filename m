From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft RFC PATCH v2] src: add export operation
Date: Wed, 22 Jan 2014 18:26:52 +0000
Message-ID: <20140122182651.GC7651@macbook.localnet>
References: <20140121170109.31013.94618.stgit@nfdev.cica.es>
 <20140121172636.GA19175@macbook.localnet>
 <CAOkSjBgyMo6OFEwkYVvkXMCxKH1xKd4k4yqWjz4cNJjoibh5pQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52013 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbaAVS04 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jan 2014 13:26:56 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBgyMo6OFEwkYVvkXMCxKH1xKd4k4yqWjz4cNJjoibh5pQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 21, 2014 at 09:52:44PM +0100, Arturo Borrero Gonzalez wrote:
> On 21 January 2014 18:26, Patrick McHardy <kaber@trash.net> wrote:
> > Looks fine to me. I can apply it if you want, not sure since the import
> > counterpart will have to wait until we have the necessary kernel changes
> > in place.
> >
> > Please let me know.
> 
> Feel free to apply, so users can know about this [future] feature, and
> we begin using that branch of the libnftnl infrastructure.

I get a reject in aprser.y. Could you resend based on the current next-3.14
tree?

Thanks.
