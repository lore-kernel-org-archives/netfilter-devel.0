From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft] netlink_linearize: fix wrong comparison in
 netlink_gen_flagcmp()
Date: Sun, 16 Feb 2014 22:43:32 +0000
Message-ID: <20140216224331.GA23262@macbook.localnet>
References: <1392590522-4170-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43465 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaBPWng (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Feb 2014 17:43:36 -0500
Content-Disposition: inline
In-Reply-To: <1392590522-4170-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Feb 16, 2014 at 11:42:02PM +0100, Pablo Neira Ayuso wrote:
>  nft add rule filter input ct state established,related counter drop
> 
> is not matching here due to a wrong comparison in the rule:
> 
>  ip filter input 20 19
>    [ ct load state => reg 1 ]
>    [ bitwise reg 1 = (reg=1 & 0x00000006 ) ^ 0x00000000 ]
>    [ cmp neq reg 1 0x00000006 ] <----- this has to be zero
>    [ counter pkts 0 bytes 0 ]
>    [ immediate reg 0 drop ]
> 
> There's a line that generates the value from the right-hand
> expression which was not in the original code. This bug was
> introduced in aae836a ("src: use libnftables").

I already pushed that patch two or three hours ago.
