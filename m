From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft PATCH] files: replace interpreter during installation
Date: Wed, 22 Jan 2014 16:51:06 +0000
Message-ID: <20140122165105.GA18994@macbook.localnet>
References: <20140113091623.10582.14579.stgit@nfdev.cica.es>
 <CAOj-5WAXqwd3eHD0bFNxa031pLcLWwXtHsOxeYbnJxFeUVMYUA@mail.gmail.com>
 <20140114151605.GA26466@macbook.localnet>
 <CAOkSjBidi2YdLuQaqDBOTDuMVHRPCVnhJFa2zRzpyfEgbQyA8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sam Liddicott <sam@liddicott.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51320 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282AbaAVQvK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jan 2014 11:51:10 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBidi2YdLuQaqDBOTDuMVHRPCVnhJFa2zRzpyfEgbQyA8w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 22, 2014 at 05:45:39PM +0100, Arturo Borrero Gonzalez wrote:
> On 14 January 2014 16:16, Patrick McHardy <kaber@trash.net> wrote:
> > On Tue, Jan 14, 2014 at 03:00:14PM +0000, Sam Liddicott wrote:
> >> I realise a solution is reached, but an alternative in common use is
> >> mentioned here for completeness;
> >>
> >> #! /usr/bin/env nft -f
> >>
> >> it is commonly used to invoke interpreters whose path is unknown but
> >> which can be expected to be on the PATH
> >
> > I'm find either way. Unless there are arguments for not using env,
> > this seems like the simpler fix.
> 
> 
> Using env with an additional argument (the '-f') seems to fail in my system.
> 
> ===8<===
> #!/usr/bin/env nft -f
> list table filter
> ===8<===
> 
> % ./test
> /usr/bin/env: nft -f: No such file or directory

I guess lets just keep it this way. Thanks.
