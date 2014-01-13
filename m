From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft PATCH] files: replace interpreter during installation
Date: Mon, 13 Jan 2014 09:52:53 +0000
Message-ID: <20140113095252.GB15457@macbook.localnet>
References: <20140113091623.10582.14579.stgit@nfdev.cica.es>
 <20140113093912.GA14898@macbook.localnet>
 <CAOkSjBgTH=De81npZv_6P6B3rxJxt_0DW6yzK=pzp8uD03TpjA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55571 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaAMJw5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Jan 2014 04:52:57 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBgTH=De81npZv_6P6B3rxJxt_0DW6yzK=pzp8uD03TpjA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 13, 2014 at 10:49:51AM +0100, Arturo Borrero Gonzalez wrote:
> On 13 January 2014 10:39, Patrick McHardy <kaber@trash.net> wrote:
> >
> > I think we should use .in files instead and perform variable substition.
> >
> 
> Could you please elaborate this?
> 
> I have understood:
> 
> Use a variable in files/nftables/*, like:
> <<
> $shebang
> 
> table filter {
> [...]
> 
> >>
> 
> And replace during install. Is this true?

Use f.i. files/nftables/ipv4-filter.in and use

#! ${sbindir}/nft
