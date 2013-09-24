From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nftables] meta: iif/oifname should be host byte order
Date: Tue, 24 Sep 2013 12:44:26 +0200
Message-ID: <20130924104426.GA8151@localhost>
References: <1379685693-2854-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35557 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771Ab3IXKv0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Sep 2013 06:51:26 -0400
Content-Disposition: inline
In-Reply-To: <1379685693-2854-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 20, 2013 at 04:01:33PM +0200, Florian Westphal wrote:
> src/nft add rule filter output meta oifname eth0
> 
> doesn't work on x86.  Problem is that nft declares these as
> BYTEORDER_INVALID, but when converting the string mpz_import_data
> treats INVALID like BIG_ENDIAN.
> 
> [ cmp eq reg 1 0x00000000 0x00000000 0x65000000 0x00306874 ]
> 
> as kernel nft_cmp_eval basically boils down to
> 
> memcmp(reg, skb->dev->name, sizeof(reg) comparision fails.
> 
> with patch:
> [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]

Applied with small change:

Error: Byteorder mismatch: expected invalid, got host endian
add rule filter output ct helper "ftp" counter
                                 ^^^^^

I was hitting that error here. I have mangled your patch to change
endianess of the helper name, I couldn't find any other string type in
the current tree that needs to be adjusted.

> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  On a related note:
>  Instead of
>  memcmp(register, devicename, strlen(register)+1) [i.e., strcmp]
>  The comparision in kernel is always
>  memcmp(register, dev->name, IFNAMSIZ).
> 
>  IOW, why does expr_evaluate_value() replace the interface names
>  string length with the template length (IFNAMSIZ)?

I see, it's adjusting the expression to use the type length. I cannot
currently find a reason any reason for not changing that.

>  It doesn't seem to be needed, and without it supporting
>  iptables-style wildcard name match (oifname "eth+") should be quite simple.

We support this in iptables-nftables, to interpret the data from the
kernel the assumption is that if_nametoindex fails to resolve the
interface name, then it handles the interface name as an interface
wildcard. But that's a problem, if the interface is removed, all
existing rules for it will be interpreted as wildcard.

Regards.
