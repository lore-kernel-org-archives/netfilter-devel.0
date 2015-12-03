From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft 2/2] src: fix sub-bytes protocol header definition
Date: Thu, 3 Dec 2015 01:21:35 +0100
Message-ID: <20151203002135.GA31167@breakpoint.cc>
References: <1448991867-21247-1-git-send-email-pablo@netfilter.org>
 <1448991867-21247-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net, fw@strlen.de
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52047 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754717AbbLCAVi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Dec 2015 19:21:38 -0500
Content-Disposition: inline
In-Reply-To: <1448991867-21247-2-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Update bitfield definitions to match according to the way they are
> expressed in RFC and IEEE specifications.

[..]

> 	len = round_up(expr->len, BITS_PER_BYTE);
> 
> Then, we substract the offset bits and the bitfield length.
> 
>         shift = len - (offset + expr->len);
> 
> From the delinearize, payload_expr_trim() needs to obtain the real
> offset through:
> 
> 	off = round_up(mask->len, BITS_PER_BYTE) -
> 		       mpz_fls(mask->value, mask->len);
> 
> For vlan id (offset 12), this gets the position of the last bit set in
> the mask (ie. 12), then we substract the length we fetch in bytes (16),
> so we obtain the real bitfield offset (4).
> 
> Then, we add that to the original payload offset that was expressed in
> bytes:
> 
> 	payload_offset += off;
> 
> Note that payload_expr_trim() now also adjusts the payload expression to
> its real length and offset.
> 
> Reported-by: Patrick McHardy <kaber@trash.net>>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> This aims to fix what we have, I'm willing to give another pass to this.

vlan type ip vlan id 4094 ip version 4 counter packets 567 bytes 37720
vlan type ip vlan id 4094 vlan pcp 0 vlan cfi 0 counter packets 567 bytes 37720
vlan type ip vlan id 4094 vlan pcp 1 vlan cfi 1 counter packets 0 bytes 0
vlan type ip vlan id 4094 vlan pcp 1 vlan cfi 0 counter packets 0 bytes 0
vlan type ip vlan id 4094 vlan pcp 0 vlan cfi 1 counter packets 0 bytes 0

tpcdump says:
'length 194: vlan 4094, p 0, ethertype IPv4', i.e. this looks correct.

Thanks Pablo!
