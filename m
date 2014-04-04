From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nftables] testing at sparc
Date: Fri, 4 Apr 2014 14:05:04 +0200
Message-ID: <20140404120504.GB27267@macbook.localnet>
References: <CAOkSjBjhsQ7wS4_0YMrcV0Mm5yKOSVh8rn+sg3JK5zTH2qhYDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64012 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbaDDMFI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Apr 2014 08:05:08 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBjhsQ7wS4_0YMrcV0Mm5yKOSVh8rn+sg3JK5zTH2qhYDw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 02, 2014 at 06:23:03PM +0200, Arturo Borrero Gonzalez wrote:
> Hi there!
> 
> I've been testing nftables at sparc, looking for endianess issues.

Great, I meant to do this for a long time.

> Unfortunately, weird things happened.
> 
> Adding some rule:
> 
> % nft add table filter
> % nft add chain filter input
> % nft add rule filter input tcp dport 22 counter
> % nft list table filter
> table ip filter {
>   chain input {
>     payload @th,16,16 0x0 [invalid type] counter packets 0 bytes 0
>   }
> }
> 
> However, matching happened when I generated some traffic.

So it appears we only have a problem in userspace? That's at least partially
good news. Could you provide access to that machine for debugging?

> Also, compiling the nft cli tool:
> 
> % make
> -e   CC src/main.c
> src/main.c: In function 'nft_netlink':
> src/main.c:176:2: warning: cast increases required alignment of target
> type [-Wcast-align]

It appears all of these originate from the list iterator macros.
I guess its container_of() and the cast to (type *)(char *)ptr ...
