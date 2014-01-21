From: Patrick McHardy <kaber@trash.net>
Subject: Re: Can't compile nftables
Date: Tue, 21 Jan 2014 12:36:00 +0000
Message-ID: <20140121123559.GD30955@macbook.localnet>
References: <CAOkSjBiG2dXFKves3yf61Lw2gP=EBC=auAaTJL8HApGmc8O7PA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38958 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477AbaAUMgK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jan 2014 07:36:10 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBiG2dXFKves3yf61Lw2gP=EBC=auAaTJL8HApGmc8O7PA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 21, 2014 at 01:26:41PM +0100, Arturo Borrero Gonzalez wrote:
> Hi there,
> 
> I have this:
> 
> % make clean && make -j8 && make install
> 
> -e   CC src/parser.c
> -e   CC src/scanner.c
> -e   LD src/nft
> src/scanner.o: In function `nft_realloc':
> /home/aborrero/git/nftables/<stdout>:4146: undefined reference to `rpl_realloc'
> src/scanner.o: In function `nft_alloc':
> /home/aborrero/git/nftables/<stdout>:4134: undefined reference to `rpl_malloc'
> /home/aborrero/git/nftables/<stdout>:4134: undefined reference to `rpl_malloc'
> /home/aborrero/git/nftables/<stdout>:4134: undefined reference to `rpl_malloc'
> src/scanner.o: In function `nft_realloc':
> /home/aborrero/git/nftables/<stdout>:4146: undefined reference to `rpl_realloc'
> /home/aborrero/git/nftables/<stdout>:4146: undefined reference to `rpl_realloc'
> src/scanner.o: In function `nft_alloc':
> /home/aborrero/git/nftables/<stdout>:4134: undefined reference to `rpl_malloc'
> /home/aborrero/git/nftables/<stdout>:4134: undefined reference to `rpl_malloc'
> /home/aborrero/git/nftables/<stdout>:4134: undefined reference to `rpl_malloc'
> /home/aborrero/git/nftables/<stdout>:4134: undefined reference to `rpl_malloc'
> /home/aborrero/git/nftables/<stdout>:4134: undefined reference to `rpl_malloc'
> src/scanner.o: In function `nft_realloc':
> /home/aborrero/git/nftables/<stdout>:4146: undefined reference to `rpl_realloc'
> src/utils.o: In function `xmalloc':
> /home/aborrero/git/nftables/src/utils.c:36: undefined reference to `rpl_malloc'
> src/utils.o: In function `xrealloc':
> /home/aborrero/git/nftables/src/utils.c:44: undefined reference to `rpl_realloc'
> src/parser.o: In function `nft_parse':
> /home/aborrero/git/nftables/src/parser.c:3183: undefined reference to
> `rpl_malloc'
> /home/aborrero/git/nftables/src/parser.c:6193: undefined reference to
> `rpl_malloc'
> collect2: error: ld returned 1 exit status
> 
> Do you have any idea of why?
> 
> my git: 11ba325 (HEAD, origin/master, origin/HEAD, master) bump
> release number to 0.100

You need to run ldconfig after installing the libraries, otherwise the
malloc test will fail and autoconf will replace it by rpl_*.
