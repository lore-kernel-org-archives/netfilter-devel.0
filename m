From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] xml: expr: fix public interface for parsing
 XML
Date: Fri, 26 Jul 2013 16:55:12 +0200
Message-ID: <20130726145512.GA28808@localhost>
References: <20130726120031.4081.51723.stgit@nfdev.cica.es>
 <20130726141934.GA13991@localhost>
 <CAOkSjBjD9b=X3MNu7NPpVDFrLTCf9AtS2hQtYcp19e=sEkzZOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46704 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759239Ab3GZOzR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jul 2013 10:55:17 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBjD9b=X3MNu7NPpVDFrLTCf9AtS2hQtYcp19e=sEkzZOQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jul 26, 2013 at 04:31:47PM +0200, Arturo Borrero Gonzalez wrote:
> On 26 July 2013 16:19, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Hi Arturo,
> >
> > On Fri, Jul 26, 2013 at 02:00:31PM +0200, Arturo Borrero Gonzalez wrote:
> >> This patch adds a public interface for parsing expr XML.
> >> Before this patch, that operation was not possible.
> >
> > rule parse already parses expressions.
> >
> > Do you need this? If so, please specify the usage. Thanks.
> 
> I don't need this.
> 
> The only motivation was all object having a way of going from str to
> nft_* but expr.
> As you stated, currently the only way of parsing a XML expr is if the
> expr itself is nested inside a rule.
> 
> but i'm fine without it ATM.

Let keep this back. I prefer not to add yet another interface for
something we don't need at this moment.
