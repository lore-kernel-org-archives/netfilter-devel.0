From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables PATCH 1/2] fix IPv6 prefix computation.
Date: Mon, 30 Sep 2013 12:57:15 +0200
Message-ID: <20130930105715.GA6448@localhost>
References: <1380448409-19583-1-git-send-email-eric@regit.org>
 <1380448409-19583-2-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56368 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854Ab3I3K52 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:57:28 -0400
Content-Disposition: inline
In-Reply-To: <1380448409-19583-2-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Sep 29, 2013 at 11:53:28AM +0200, Eric Leblond wrote:
> The prefix building algorithm in netlink phase was incorrect in
> IPv6.
> 
> For example, when adding the following rule
>  nft add rule ip6 nat postrouting ip6 saddr 2::/64 --debug=all
> 
> we had:
> 
>  ip6 nat postrouting 0 0
>   [ payload load 16b @ network header + 8 => reg 1 ]
>   [ bitwise reg 1 = (reg=1 & 0x00000000 0x99361540 0x00007f8d 0x2e33a1eb ) ^ 0x00000000 0x00000000 0x00000000 0x00000000 ]
>   [ cmp eq reg 1 0x00000200 0x00000000 0x00000000 0x00000000 ]
> 
> With the patch the result is as expected:
> 
>  ip6 nat postrouting 0 0
>   [ payload load 16b @ network header + 8 => reg 1 ]
>   [ bitwise reg 1 = (reg=1 & 0xffffffff 0xffffffff 0x00000000 0x00000000 ) ^ 0x00000000 0x00000000 0x00000000 0x00000000 ]
>   [ cmp eq reg 1 0x00000200 0x00000000 0x00000000 0x00000000 ]

Applied, thanks Eric!
