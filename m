Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA390C77B73
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 May 2023 07:53:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbjEBHx1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 May 2023 03:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjEBHx1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 May 2023 03:53:27 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 76B9230F9
        for <netfilter-devel@vger.kernel.org>; Tue,  2 May 2023 00:53:25 -0700 (PDT)
Date:   Tue, 2 May 2023 09:53:17 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft] doc: add nat examples
Message-ID: <ZFDBbQ+u85XkfWMx@calendula>
References: <20230501101009.386454-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230501101009.386454-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, May 01, 2023 at 12:10:09PM +0200, Florian Westphal wrote:
> nftables nat is much more capable than what the existing
> documentation describes.
> 
> In particular, nftables can fully emulate iptables
> NETMAP target and can perform n:m address mapping.
> 
> Add a new example section extracted from commit log
> messages when those features got added.

LGTM, thanks for documenting this, I should have done this myself.

> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  doc/statements.txt | 53 ++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 51 insertions(+), 2 deletions(-)
> 
> diff --git a/doc/statements.txt b/doc/statements.txt
> index 3fc70f863f4a..72a31d151a50 100644
> --- a/doc/statements.txt
> +++ b/doc/statements.txt
> @@ -359,8 +359,8 @@ NAT STATEMENTS
>  ~~~~~~~~~~~~~~
>  [verse]
>  ____
> -*snat* [[*ip* | *ip6*] *to*] 'ADDR_SPEC' [*:*'PORT_SPEC'] ['FLAGS']
> -*dnat* [[*ip* | *ip6*] *to*] 'ADDR_SPEC' [*:*'PORT_SPEC'] ['FLAGS']
> +*snat* [[*ip* | *ip6*] [ *prefix* ] *to*] 'ADDR_SPEC' [*:*'PORT_SPEC'] ['FLAGS']
> +*dnat* [[*ip* | *ip6*] [ *prefix* ] *to*] 'ADDR_SPEC' [*:*'PORT_SPEC'] ['FLAGS']
>  *masquerade* [*to :*'PORT_SPEC'] ['FLAGS']
>  *redirect* [*to :*'PORT_SPEC'] ['FLAGS']
>  
> @@ -398,6 +398,9 @@ Before kernel 4.18 nat statements require both prerouting and postrouting base c
>  to be present since otherwise packets on the return path won't be seen by
>  netfilter and therefore no reverse translation will take place.
>  
> +The optional *prefix* keyword allows to map to map n source addresses to n

probably highlight 'n' ? or use upper case? to map N source addresses to N

The optional *prefix* keyword allows to map to map *n* source addresses to *n*

> +destination addresses.  See 'Advanced NAT examples' below.
> +
>  .NAT statement values
>  [options="header"]
>  |==================
> @@ -457,6 +460,52 @@ add rule inet nat postrouting meta oif ppp0 masquerade
>  
>  ------------------------
>  
> +.Advanced NAT examples
> +----------------------
> +
> +# map prefixes in one network to that of another, e.g. 10.141.11.4 is mangled to 192.168.2.4,
> +# 10.141.11.5 is mangled to 192.168.2.5 and so on.
> +add rule nat postrouting snat ip prefix to ip saddr map { 10.141.11.0/24 : 192.168.2.0/24 }
> +
> +# map a source address, source port combination to a pool of destination addresses and ports:
> +add rule nat postrouting dnat to ip saddr . tcp dport map { 192.168.1.2 . 80 : 10.141.10.2-10.141.10.5 . 8888-8999 }
> +
> +# The above example generates the following NAT expression:
> +#
> +# [ nat dnat ip addr_min reg 1 addr_max reg 10 proto_min reg 9 proto_max reg 11 ]
> +#
> +# which expects to obtain the following tuple:
> +# IP address (min), source port (min), IP address (max), source port (max)
> +# to be obtained from the map. The given addresses and ports are inclusive.
> +
> +# This also works with named maps and in combination with both concatenations and ranges:
> +table ip nat {
> +	map ipportmap {
> +		typeof ip saddr : interval ip daddr . tcp dport
> +		flags interval
> +		elements = { 192.168.1.2 : 10.141.10.1-10.141.10.3 . 8888-8999, 192.168.2.0/24 : 10.141.11.5-10.141.11.20 . 8888-8999 }
> +	}
> +
> +	chain prerouting {
> +		type nat hook prerouting priority dstnat; policy accept;
> +		ip protocol tcp dnat ip to ip saddr map @ipportmap
> +	}
> +}
> +
> +@ipportmap maps network prefixes to a range of hosts and ports.
> +The new destination is taken from the range provided by the map element.
> +Same for the destination port.
> +
> +Note the use of the "interval" keyword in the typeof description.
> +This is required so nftables knows that it has to ask for twice the
> +amount of storage for each key-value pair in the map.
> +
> +": ipv4_addr . inet_service" would allow associating one address and one port
> +with each key.  But for this case, for each key, two addresses and two ports
> +(The minimum and maximum values for both) have to be stored.
> +
> +------------------------
> +
>  TPROXY STATEMENT
>  ~~~~~~~~~~~~~~~~
>  Tproxy redirects the packet to a local socket without changing the packet header
> -- 
> 2.40.1
> 
