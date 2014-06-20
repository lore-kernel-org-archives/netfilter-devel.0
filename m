From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] src: revert broken reject icmp code support
Date: Fri, 20 Jun 2014 20:06:26 +0200
Message-ID: <20140620180626.GB3479@localhost>
References: <1403281015-9774-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, alvaroneay@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34259 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028AbaFTSGk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Jun 2014 14:06:40 -0400
Content-Disposition: inline
In-Reply-To: <1403281015-9774-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 20, 2014 at 06:16:55PM +0200, Pablo Neira Ayuso wrote:
> This patch reverts Alvaro's 34040b1 ("reject: add ICMP code parameter
> for indicating the type of error") and 11b2bb2 ("reject: Use protocol
> context for indicating the reject type").
> 
> These patches are flawed by several things:
> 
> 1) IPv6 support is broken, only ICMP codes are considered.
> 2) If you don't specify any transport context, the utility exits without
>    adding the rule, eg. nft add rule ip filter input reject.
> 3) If you mistype the ICMP code name, the tool doesn't bail out.
> 
> Let's revert this until we can provide appropriate reject reason support.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> On top of this, there's another problem we have to solve. If reject
> is used from the inet table, it uses the same ICMP code but that is
> not good since IPv4 and IPv6 destination unreachable codes are different
> and they don't overlap.
> 
> I'm considering different alternatives to fix this, such as renaming
> NFTA_REJECT_ICMP_CODE to NFTA_REJECT_REASON which provides an abstract
> representation. But the abstraction doesn't seem straight forward to me.

Thinking it well, I think we can resolve this from userspace, eg.

    nft add rule inet filter input reject with icmp-net-unreach

The rule for IPv6 in the inet table would look like:

    nft add rule inet filter input reject with icmpv6-port-unreach

based on the icmp-* / icmpv6-* the protocol context is set so the
rule is restricted to IPv4 / IPv6.
