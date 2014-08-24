From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-compat PATCH 3/5 v2] nft: compare layer 4 protocol in
 first place
Date: Sun, 24 Aug 2014 15:30:30 +0200
Message-ID: <20140824133030.GA31578@salvia>
References: <1408698993-17706-1-git-send-email-giuseppelng@gmail.com>
 <1408698993-17706-3-git-send-email-giuseppelng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33139 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494AbaHXN3t (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Aug 2014 09:29:49 -0400
Content-Disposition: inline
In-Reply-To: <1408698993-17706-3-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 22, 2014 at 11:16:31AM +0200, Giuseppe Longo wrote:
> Currently the protocol is tested after the ip address,
> this fixes the order testing the protocol before the ip address.
> 
> Now the code generated is incorrect:
> 
> ip filter INPUT 16
>   [ payload load 4b @ network header + 12 => reg 1 ]
>   [ cmp eq reg 1 0x0100a8c0 ]
>   [ payload load 1b @ network header + 9 => reg 1 ]
>   [ cmp eq reg 1 0x00000006 ]
>   [ match name tcp rev 0 ]
>   [ match name conntrack rev 3 ]
>   [ counter pkts 0 bytes 0 ]
>   [ immediate reg 0 accept ]
> 
> With this patch, the code generated is:
> ip filter INPUT 16
>   [ payload load 1b @ network header + 9 => reg 1 ]
>   [ cmp eq reg 1 0x00000006 ]
>   [ payload load 4b @ network header + 12 => reg 1 ]
>   [ cmp eq reg 1 0x0100a8c0 ]
>   [ bitwise reg 1 = (reg=1 & 0xffffffff ) ^ 0x00000000 ]
>   [ match name tcp rev 0 ]
>   [ match name conntrack rev 3 ]
>   [ counter pkts 0 bytes 0 ]
>   [ immediate reg 0 accept ]

Applied, thanks.
