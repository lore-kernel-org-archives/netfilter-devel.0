From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] parsing: add interface to parse from file
Date: Thu, 2 Jan 2014 20:21:02 +0100
Message-ID: <20140102192102.GA3954@localhost>
References: <20140102132103.23299.58753.stgit@nfdev.cica.es>
 <20140102135242.GA5101@localhost>
 <CAOkSjBg9tS38QWAhR+pZsV5639gYneEjApcqBM9t-rW6W9DQsA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35236 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbaABTVH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jan 2014 14:21:07 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBg9tS38QWAhR+pZsV5639gYneEjApcqBM9t-rW6W9DQsA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 02, 2014 at 07:47:38PM +0100, Arturo Borrero Gonzalez wrote:
> On 2 January 2014 14:52, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > Please, rework this to pass a file descriptor instead so it's
> > consistent with _fprintf API and we can use it with pipes as well.
> 
> Should I do a fread() based input?:
> 
> size_t fread(void *ptr, size_t size, size_t nmemb, FILE *stream);
> 
> If so, the API func may look like:
> 
> int nft_chain_fparse(struct nft_chain *c, type, size_t size, FILE *stream);

That interface is fine.

> And then I will need to malloc(size).

Please, explain why you need this.
