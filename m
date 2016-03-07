From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libipt_icmp: Add translation to nft
Date: Mon, 7 Mar 2016 15:34:32 +0100
Message-ID: <20160307143432.GA28000@salvia>
References: <20160305200039.GA14269@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, shivanib134@gmail.com,
	outreachy-kernel@googlegroups.com
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41335 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273AbcCGOek (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Mar 2016 09:34:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C0E26C124B
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2016 15:34:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A8098DA38C
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2016 15:34:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AAFB1DA8F7
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2016 15:34:33 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160305200039.GA14269@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Mar 05, 2016 at 09:00:41PM +0100, Laura Garcia Liebana wrote:
> Add translation for icmp to nftables.
> 
> Examples:
> 
> $ sudo iptables-translate -t filter -A INPUT -m icmp --icmp-type any -j LOG
> nft add rule ip filter INPUT icmp type any counter log level warn
> 
> $ sudo iptables-translate -t filter -A INPUT -m icmp --icmp-type 3/1 -j LOG
> nft add rule ip filter INPUT icmp type host-unreachable counter log level warn
> 
> $ sudo iptables-translate -t filter -A INPUT -m icmp ! --icmp-type 3 -j LOG
> nft add rule ip filter INPUT icmp type != destination-unreachable counter log level warn
> 
> Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
> ---
>  extensions/libipt_icmp.c | 33 ++++++++++++++++++++++++++++++++-
>  1 file changed, 32 insertions(+), 1 deletion(-)
> 
> diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
> index 666e7da..795172f 100644
> --- a/extensions/libipt_icmp.c
> +++ b/extensions/libipt_icmp.c
> @@ -218,7 +218,7 @@ static void print_icmptype(uint8_t type,
>  }
>  
>  static void icmp_print(const void *ip, const struct xt_entry_match *match,
> -                       int numeric)
> +		       int numeric)
>  {
>  	const struct ipt_icmp *icmp = (struct ipt_icmp *)match->data;
>  
> @@ -249,6 +249,36 @@ static void icmp_save(const void *ip, const struct xt_entry_match *match)
>  	}
>  }
>  
> +static void type_xlate_print(struct xt_xlate *xl, unsigned int icmptype,
> +			     unsigned int code_min, unsigned int code_max)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; ARRAY_SIZE(icmp_codes); i++)
> +		if (icmp_codes[i].type == icmptype &&
> +		    icmp_codes[i].code_min == code_min &&
> +		    icmp_codes[i].code_max == code_max)
> +			break;
> +
> +	xt_xlate_add(xl, icmp_codes[i].name);
> +}
> +
> +static int icmp_xlate(const struct xt_entry_match *match, struct xt_xlate *xl,
> +		       int numeric)
> +{
> +	const struct ipt_icmp *info = (struct ipt_icmp *)match->data;
> +
> +	xt_xlate_add(xl, "icmp type%s ",
> +		     (info->invflags & IPT_ICMP_INV) ? " !=" : "");
> +
> +	type_xlate_print(xl, info->type, info->code[0], info->code[1]);
> +
> +	xt_xlate_add(xl, " ");
> +
> +	return 1;
> +}

icmpv6 codes matching can be translated to:

        icmpv6 code VALUE

I know this is still broken in nft when listing, but I have initial
a couple of patches to fix this here almost done.

So please provide the translation for this too, this will work soon.
