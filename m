From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv3] extensions: libipt_icmp: Add translation to nft
Date: Tue, 8 Mar 2016 11:53:46 +0100
Message-ID: <20160308105346.GB4008@salvia>
References: <20160307212141.GA10594@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, shivanib134@gmail.com,
	outreachy-kernel@googlegroups.com
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32853 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932567AbcCHKxz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Mar 2016 05:53:55 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B6669810C
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Mar 2016 11:53:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8C3DDDA39D
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Mar 2016 11:53:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B492ADA3AF
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Mar 2016 11:53:46 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160307212141.GA10594@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 07, 2016 at 10:21:44PM +0100, Laura Garcia Liebana wrote:
> Add translation for icmp to nftables. Not supported types in nftables

These are actually icmp codes that we don't support yet, right?

> are: any, network-unreachable, host-unreachable, protocol-unreachable,
> port-unreachable, fragmentation-needed, source-route-failed,
> network-unknown, host-unknown, network-prohibited, host-prohibited,
> TOS-network-unreachable, TOS-host-unreachable, communication-prohibited,
> host-precedence-violation, precedence-cutoff, network-redirect,
> host-redirect, TOS-network-redirect, TOS-host-redirect,
> router-advertisement, router-solicitation, ttl-zero-during-transit,
> ttl-zero-during-reassembly, ip-header-bad and required-option-missing.
> 
> Examples:
> 
> $ sudo iptables-translate -t filter -A INPUT -m icmp --icmp-type echo-reply -j LOG
> nft add rule ip filter INPUT icmp type echo-reply counter log level warn
> 
> $ sudo iptables-translate -t filter -A INPUT -m icmp --icmp-type 3 -j LOG
> nft add rule ip filter INPUT icmp type destination-unreachable counter log level warn
> 
> $ sudo iptables-translate -t filter -A INPUT -m icmp ! --icmp-type 3 -j LOG
> nft add rule ip filter INPUT icmp type != destination-unreachable counter log level warn
> 
> Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
> ---
> v2:
> 	- Detection of not supported types in nftables, as Shivani suggested.
> v3:
> 	- Fix array iteration protection.
> 
>  extensions/libipt_icmp.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 48 insertions(+), 1 deletion(-)
> 
> diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
> index 666e7da..2c8be87 100644
> --- a/extensions/libipt_icmp.c
> +++ b/extensions/libipt_icmp.c
> @@ -218,7 +218,7 @@ static void print_icmptype(uint8_t type,
>  }
>  
>  static void icmp_print(const void *ip, const struct xt_entry_match *match,
> -                       int numeric)
> +		       int numeric)

I think this change doesn't below this patch.

>  {
>  	const struct ipt_icmp *icmp = (struct ipt_icmp *)match->data;
>  
> @@ -249,6 +249,52 @@ static void icmp_save(const void *ip, const struct xt_entry_match *match)
>  	}
>  }
>  
> +static unsigned int type_xlate_print(struct xt_xlate *xl, unsigned int icmptype,
> +			     unsigned int code_min, unsigned int code_max)
                       ^^^^^^

This should be aligned with the line above:

static unsigned int type_xlate_print(struct xt_xlate *xl, unsigned int icmptype,
                                     unsigned int code_min,
                                     unsigned int code_max)

> +{
> +	unsigned int i;
> +
> +	if (code_min == code_max)
> +		return 0;
> +
> +	switch (icmptype) {
> +	case 0xFF:

You can skip the 0xff case by adding nothing.

> +	case 9:
> +	case 10:

You can send me a two-liner for this for nft, so we don't need this I
think.

> +		return 0;
> +	default:
> +		for (i = 0; i < ARRAY_SIZE(icmp_codes); ++i)
> +			if (icmp_codes[i].type == icmptype &&
> +			    icmp_codes[i].code_min == code_min &&
> +			    icmp_codes[i].code_max == code_max)
> +				break;
> +
> +		if (i != ARRAY_SIZE(icmp_codes))
> +			xt_xlate_add(xl, icmp_codes[i].name);
> +		else
> +			return 0;
> +	}
> +
> +	return 1;
> +}
