From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [{ip,ip6}tables-compat PATCH] nft: fix network prefixes
Date: Tue, 26 Aug 2014 10:55:13 +0200
Message-ID: <20140826085513.GA3800@salvia>
References: <1409000096-4335-1-git-send-email-giuseppelng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55178 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932421AbaHZIyi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Aug 2014 04:54:38 -0400
Content-Disposition: inline
In-Reply-To: <1409000096-4335-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 25, 2014 at 10:54:56PM +0200, Giuseppe Longo wrote:
> This is fixing the network prefixes (eg. /24) in the {ip,ip6} compat utility
> 
> The following below

Please, include the command line that generates this code as well.

> generate respectively the following netlink code:
> ip filter INPUT 20
>   [ payload load 1b @ network header + 9 => reg 1 ]
>   [ cmp eq reg 1 0x00000006 ]
>   [ payload load 4b @ network header + 12 => reg 1 ]
>   [ cmp eq reg 1 0x0000a8c0 ]
>   [ match name tcp rev 0 ]
>   [ match name conntrack rev 3 ]
>   [ counter pkts 0 bytes 0 ]
>   [ immediate reg 0 accept ]
> 
> ip6 filter INPUT 36
>   [ payload load 16b @ network header + 8 => reg 1 ]
>   [ cmp eq reg 1 0x00004023 0x00000000 0x00000000 0x00000000 ]
>   [ counter pkts 0 bytes 0 ]
>   [ immediate reg 0 accept ]
> 
> With this patch the netlink code becomes:
> 
> ip filter INPUT 20
>   [ payload load 1b @ network header + 9 => reg 1 ]
>   [ cmp eq reg 1 0x00000006 ]
>   [ payload load 4b @ network header + 12 => reg 1 ]
>   [ cmp eq reg 1 0x0000a8c0 ]
>   [ bitwise reg 1 = (reg=1 & 0x00ffffff ) ^ 0x00000000 ]

# nft --debug=netlink add rule filter test ip saddr 192.168.0.0/24
ip filter test 
  [ payload load 4b @ network header + 12 => reg 1 ]
  [ bitwise reg 1 = (reg=1 & 0x00ffffff ) ^ 0x00000000 ]
  [ cmp eq reg 1 0x0000a8c0 ]

The bitwise has to come before the cmp.

Fix this a send a v2. Thanks.
