From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft RFC PATCH] src: add export operation
Date: Tue, 21 Jan 2014 16:16:02 +0000
Message-ID: <20140121161602.GA7944@macbook.localnet>
References: <20140121140545.27264.82385.stgit@nfdev.cica.es>
 <20140121145131.GA6302@macbook.localnet>
 <CAOkSjBj4oXHhMjkCqcz-GhM74cekuH2TgkW+GUsM4KsgFAdk7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40778 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084AbaAUQQH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jan 2014 11:16:07 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBj4oXHhMjkCqcz-GhM74cekuH2TgkW+GUsM4KsgFAdk7Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 21, 2014 at 05:07:39PM +0100, Arturo Borrero Gonzalez wrote:
> Thanks for your comments Patrick. I'm addressing all of them. Just one
> thing below.
> 
> On 21 January 2014 15:51, Patrick McHardy <kaber@trash.net> wrote:
> >>  struct cmd {
> >>       struct list_head        list;
> >> @@ -264,6 +267,7 @@ struct cmd {
> >>               struct table    *table;
> >>       };
> >>       const void              *arg;
> >> +     uint32_t                format;
> >
> > No enum defined for this?
> >
> 
> In libnftables, there are two: `enum nft_parse_type' and `enum nft_output_type'.
> 
> I preferred just using uint32_t so we can reuse between export/import.

I see. Sure, I was just wondering.
