From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v2] src: add redirect support
Date: Tue, 4 Nov 2014 14:37:12 +0100
Message-ID: <20141104133712.GA9190@salvia>
References: <20141016104056.8678.71075.stgit@nfdev.cica.es>
 <20141030162520.GA2074@salvia>
 <CAOkSjBibjQa7A-WEw0NbhmRnKNsDgWxgGVe7EP9V8S600uKMGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55070 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617AbaKDNf2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:35:28 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBibjQa7A-WEw0NbhmRnKNsDgWxgGVe7EP9V8S600uKMGg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 03, 2014 at 08:42:13PM +0100, Arturo Borrero Gonzalez wrote:
> On 30 October 2014 17:25, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Thu, Oct 16, 2014 at 12:41:19PM +0200, Arturo Borrero Gonzalez wrote:
> >> This patch adds redirect support for nft.
> >>
> >> The syntax is:
> >>
> >>  % nft add rule nat prerouting redirect [port|nat_flags]
> >
> > I prefer if you add a couple of valid examples to the patch
> > description. This won't work as the protocol is not specified.
> >
> > There's also some minor issues with this patch:
> >
> > % nft add rule nat prerouting redirect
> > Memory allocation failure
> >
> > Please, address and resubmit, thanks Arturo.
> 
> Hi Pablo,
> 
> I've take further look at this patch. I don't see any issue.
>
> As masquerade, I think redirect without protocol should work. I just
> tested again the patch with ICMP packets and the redirection simply
> works. I used tcpdump for the checks. The rule I used is the same as
> in the patch description.

I think this needs to be:

% nft add rule nat prerouting redirect [port] [nat_flags]

And, I think it doesn't make any bad if you extend the description
with some examples as I requested.

Or update the documentation in the same patch including the new
redirect expression.

I'm going to apply this now, but next time please address my requests.

> Regarding the memory allocation failure, I'm unable to find the issue.

My fault, the "memory allocation failure" happens when you use an old
libnftnl with no redirect support, which was the case in my testbed. I
just fixed it here.
