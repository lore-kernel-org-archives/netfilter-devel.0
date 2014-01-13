From: Patrick McHardy <kaber@trash.net>
Subject: Re: nftables/libnftables packages for Fedora
Date: Mon, 13 Jan 2014 00:25:33 +0000
Message-ID: <20140113002533.GA3373@macbook.localnet>
References: <20140112134024.2475a4f2@voldemort.scrye.com>
 <CAOkSjBhCTDCDzBLp86d1qA+xH=KMZtz2HrU3QfnZ+8AJ+qcWTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kevin Fenzi <kevin@scrye.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51522 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbaAMAZh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Jan 2014 19:25:37 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBhCTDCDzBLp86d1qA+xH=KMZtz2HrU3QfnZ+8AJ+qcWTg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jan 12, 2014 at 10:16:35PM +0100, Arturo Borrero Gonzalez wrote:
> On 12 January 2014 21:40, Kevin Fenzi <kevin@scrye.com> wrote:
> >
> > 2. There is some question about the /etc/nftables/* scripts. In Fedora
> > land, things in /etc/ should be config files, but these aren't really
> > config files. They call nft without a full path (/usr/sbin/nft, etc).
> > Should these really be in /usr/share ? or is it expected users will
> > modify them? Could you clarify the use case there?
> >
> 
> There is a patch from me to address this:
> http://patchwork.ozlabs.org/patch/304866/
> Feel free to test it and comment.
> 
> I have the same issue in the Debian land. I applied the patch locally
> in the package as a workaround.
> 
> The patch is not applied yet to upstream.

Could you please resubmit? I'm going to apply it to the master branch.

Thanks.
