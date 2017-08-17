From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 1/2] evaluate: shift immediate value when adjusting
 size for csum fixup
Date: Thu, 17 Aug 2017 12:00:56 +0200
Message-ID: <20170817100056.GA6928@salvia>
References: <20170816170156.11594-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:47231 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750988AbdHQKBY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Aug 2017 06:01:24 -0400
Content-Disposition: inline
In-Reply-To: <20170816170156.11594-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 16, 2017 at 07:01:55PM +0200, Florian Westphal wrote:
> nft add rule .. ip ttl set 64
> 
> erronously mangles ip protocol instead of ttl.
> 
> Because the kernel can't deal with odd-sized data (ttl is one byte) when
> doing checksum fixups, so the write to 'ttl' is turned into
> 
> [ payload load 2b @ network header + 8 => reg 1 ]
> [ bitwise reg 1 = (reg=1 & 0x000000ff ) ^ $new_value ]
> [ payload write reg 1 => 2b @ network header + 8 csum_type 1 csum_off 10 csum_flags 0x0 ]
> 
> While doing so, we did fail to shift the imm value, i.e.
> we clear the wrong half of the u16 (protocol) instead of csum.
> 
> The correct mask is 0xff00, and $new_value needs to be shifted
> so we leave the protocol value (which is next to ttl) alone.
> 
> Fixes: f9069cefdf ("netlink: make checksum fixup work with odd-sized header fields")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
