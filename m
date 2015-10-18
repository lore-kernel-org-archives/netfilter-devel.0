From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft] src: add interface wildcard matching
Date: Sun, 18 Oct 2015 20:33:13 +0200
Message-ID: <20151018183313.GA4386@breakpoint.cc>
References: <1445191336-2041-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net, fw@strlen.de
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:32857 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752440AbbJRSdP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 18 Oct 2015 14:33:15 -0400
Content-Disposition: inline
In-Reply-To: <1445191336-2041-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Contrary to iptables, we use '*' as wildcard as in udev since the '+' can be
> used as a valid interface name.

'*' can also be part of an interface name, seems only '/', ':', and ' '
(space) are disallowed.

>  # nft --debug=netlink add rule test test iifname eth\*
>  ip test test
>    [ meta load iifname => reg 1 ]
>    [ bitwise reg 1 = (reg=1 & 0x00ffffff 0x00000000 0x00000000 0x00000000 ) ^ 0x00000000 0x00000000 0x00000000 0x00000000 ]
>    [ cmp eq reg 1 0x2a687465 0x00000000 0x00000000 0x00000000 ]

Why do we need a bitwise op for this?

Instead we could just ask for cmp of 3 bytes ('eth' instead of 4 'eth\0')?

You might recall ancient RFC patch for this:
https://patchwork.ozlabs.org/patch/283639/
