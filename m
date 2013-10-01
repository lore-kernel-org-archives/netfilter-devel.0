From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 2] src: add low-level ruleset API
Date: Tue, 1 Oct 2013 12:08:18 +0200
Message-ID: <20131001100818.GA3589@localhost>
References: <20130930223246.12985.64667.stgit@nfdev.cica.es>
 <20131001093813.GA7452@localhost>
 <CAOkSjBjZ7hKJxGfdhD_y9CUGJZzdKjAEnBVoqPAQUcTevhVahg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([174.127.110.175]:55355 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752629Ab3JAKIY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Oct 2013 06:08:24 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBjZ7hKJxGfdhD_y9CUGJZzdKjAEnBVoqPAQUcTevhVahg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 01, 2013 at 11:46:38AM +0200, Arturo Borrero Gonzalez wrote:
> On 1 October 2013 11:38, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Tue, Oct 01, 2013 at 12:33:18AM +0200, Arturo Borrero Gonzalez wrote:
> >> This patch adds a low level ruleset API for libnftables.
> >
> > Applied, thanks Arturo.
> >
> > BTW, any plan to send me example files?
> 
> It seem I can't dump sets with af NFPROTO_UNSPEC.
> 
> I'm looking nf_tables_api.c wondering how difficult is to implement it.
> 
> In nf_tables_dump_sets_all(), I think we need to iterate afs  like in
> dump_tables(), ie:
> 
> list_for_each_entry(afi, &net->nft.af_info, list) {
>   if (family != NFPROTO_UNSPEC && family != afi->family)
>     continue;
> [...]

That's on the right track. Let me know if you want to send me a kernel
patch for it.
