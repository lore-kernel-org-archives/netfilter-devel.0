From: Patrick McHardy <kaber@trash.net>
Subject: Re: nftables/libnftables packages for Fedora
Date: Mon, 13 Jan 2014 00:18:26 +0000
Message-ID: <20140113001826.GC3251@macbook.localnet>
References: <20140112134024.2475a4f2@voldemort.scrye.com>
 <CAOkSjBhCTDCDzBLp86d1qA+xH=KMZtz2HrU3QfnZ+8AJ+qcWTg@mail.gmail.com>
 <20140112170549.327dd807@voldemort.scrye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Kevin Fenzi <kevin@scrye.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51479 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaAMASa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Jan 2014 19:18:30 -0500
Content-Disposition: inline
In-Reply-To: <20140112170549.327dd807@voldemort.scrye.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jan 12, 2014 at 05:05:49PM -0700, Kevin Fenzi wrote:
> [ re-sending as I forgot to cc the list ] 
> 
> On Sun, 12 Jan 2014 22:16:35 +0100
> Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com> wrote:
> 
> ...snip...
>  
> > There is a patch from me to address this:
> > http://patchwork.ozlabs.org/patch/304866/
> > Feel free to test it and comment.
> > 
> > I have the same issue in the Debian land. I applied the patch locally
> > in the package as a workaround.
> > 
> > The patch is not applied yet to upstream.
> 
> Cool. 
> 
> That addresses the part of the issue where the interpreter isn't fully
> specified, but still the question is if these are config files that
> users are expected to modify or are noarch scripts provided by the
> package that are expected to be read-only (ie, /etc vs /usr/share)?

Yes, they are basically noarch scripts providing defaults for the
table configurations.
