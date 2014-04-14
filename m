From: Patrick McHardy <kaber@trash.net>
Subject: Re: cannot stat 'doc/nftables.8': No such file or directory
Date: Mon, 14 Apr 2014 12:06:57 +0200
Message-ID: <20140414100656.GA3661@macbook.localnet>
References: <CAD7o0sja_p2BhAuDMBEqR7Y6oprGs+nViDTC66Xr9-RU0H54LQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59775 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbaDNKHA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2014 06:07:00 -0400
Content-Disposition: inline
In-Reply-To: <CAD7o0sja_p2BhAuDMBEqR7Y6oprGs+nViDTC66Xr9-RU0H54LQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 14, 2014 at 11:37:36AM +0200, Ana Rey wrote:
> Hello,
> 
> With the last changes in nftable (last commit 'doc: change
> documentation license to CC BY-SA 4.0')
> 
> $ sudo make install
> -e   SUBDIR src/
> -e   INSTALL nft
> -e   SUBDIR files/
> -e   INSTALL files
> -e   SUBDIR doc/
> -e   MAN doc/nftables.8
> -e   INSTALL doc
> /usr/bin/install: cannot stat 'doc/nftables.8': No such file or directory
> make[1]: *** [install] Error 1
> make: *** [doc] Error 2
> 
> I have docbook in my system, and I try to install it before a 'make
> clean'  and './autogen.sh'

I just pushed out a fix, could you please retry?
