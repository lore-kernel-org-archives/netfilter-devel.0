From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v2] src: add redirect support
Date: Tue, 4 Nov 2014 15:44:55 +0100
Message-ID: <20141104144455.GB10239@salvia>
References: <20141016104056.8678.71075.stgit@nfdev.cica.es>
 <20141030162520.GA2074@salvia>
 <CAOkSjBibjQa7A-WEw0NbhmRnKNsDgWxgGVe7EP9V8S600uKMGg@mail.gmail.com>
 <20141104133712.GA9190@salvia>
 <CAOkSjBhSysvcL_wOwJK=aPaAeGKt02=i0mmX=zQ5xW-PRDxgXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43240 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753923AbaKDOnO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Nov 2014 09:43:14 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBhSysvcL_wOwJK=aPaAeGKt02=i0mmX=zQ5xW-PRDxgXg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 04, 2014 at 02:56:58PM +0100, Arturo Borrero Gonzalez wrote:
> On 4 November 2014 14:37, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > I think this needs to be:
> >
> > % nft add rule nat prerouting redirect [port] [nat_flags]
> >
> 
> The port and nat_flags arguments are mutually exclusives. That's why I
> used the [port|nat_flags] syntax.

iptables allows this:

-j REDIRECT --to-ports 8000-8010 --random
