From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 1/2] src: add _unset functions
Date: Thu, 6 Jun 2013 13:45:45 +0200
Message-ID: <20130606114545.GB9922@localhost>
References: <20130605213713.11415.64106.stgit@nfdev.cica.es>
 <20130606101508.GA5947@localhost>
 <CAOkSjBi5B8pHLF2+Kt3eqL71+jqNXWJOJHPq6FZ+O4Wti+TBzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Giuseppe Longo <giuseppelng@gmail.com>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39677 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754047Ab3FFLpt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Jun 2013 07:45:49 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBi5B8pHLF2+Kt3eqL71+jqNXWJOJHPq6FZ+O4Wti+TBzQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 06, 2013 at 12:35:01PM +0200, Arturo Borrero Gonzalez wrote:
> 2013/6/6 Pablo Neira Ayuso <pablo@netfilter.org>:
> >
> > To unset, use:
> >
> > x->flags &= ~(1 << attr)
> 
> Nice. I'm with v2.
> 
> What about the data being freed? Is that desirable?

If the attribute is unset and the memory area is dynamically
allocated, you have to release it, yes. I think it's also a good idea
if you set that pointer to NULL as a bugtrap as well.
