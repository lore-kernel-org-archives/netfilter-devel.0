From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv5] extensions: libipt_icmp: Add translation to nft
Date: Thu, 10 Mar 2016 19:43:44 +0100
Message-ID: <20160310184344.GA10448@salvia>
References: <20160310161743.GA9997@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, shivanib134@gmail.com,
	outreachy-kernel@googlegroups.com
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48838 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbcCJSnz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Mar 2016 13:43:55 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 6651BC9EDB
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 19:43:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 414A5DA38C
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 19:43:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4A030DA8F8
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 19:43:52 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160310161743.GA9997@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 10, 2016 at 05:17:46PM +0100, Laura Garcia Liebana wrote:
> Add translation for icmp to nftables. Not supported types in nftables

Please, this should be "Not supported icmp codes in nftables" instead.

> are: any, network-unreachable, host-unreachable, protocol-unreachable,

'any' is equivalent to void translation.

>From what I can see in iptables, this built-in match comes with this
wildcard 'any' icmp type just to check that the icmp header is
actually in place.

In nft, we can rely on the connection tracking for such a check.

> port-unreachable, fragmentation-needed, source-route-failed,
> network-unknown, host-unknown, network-prohibited, host-prohibited,
> TOS-network-unreachable, TOS-host-unreachable, communication-prohibited,
> host-precedence-violation, precedence-cutoff, network-redirect,
> host-redirect, TOS-network-redirect, TOS-host-redirect,
> ttl-zero-during-transit, ttl-zero-during-reassembly, ip-header-bad and required-option-missing.
> 
> Examples:
> 
> $ sudo iptables-translate -t filter -A INPUT -m icmp --icmp-type echo-reply -j ACCEPT
> nft add rule ip filter INPUT icmp type echo-reply counter accept
> 
> $ sudo iptables-translate -t filter -A INPUT -m icmp --icmp-type 3 -j ACCEPT
> nft add rule ip filter INPUT icmp type destination-unreachable counter accept
> 
> $ sudo iptables-translate -t filter -A INPUT -m icmp ! --icmp-type 3 -j ACCEPT
> nft add rule ip filter INPUT icmp type != destination-unreachable counter accept
> 
> Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
> ---
> v2:
> 	- Detection of not supported types in nftables, as Shivani suggested.
> v3:
> 	- Fix array iteration protection.
> v4:
> 	- icmp types router-advertisement and router-solicitation already supported in nft.
> v5:
> 	- Update commit message with the correct not supported codes.
> 
>  extensions/libipt_icmp.c | 36 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
> 
> diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
> index 666e7da..cc8e732 100644
> --- a/extensions/libipt_icmp.c
> +++ b/extensions/libipt_icmp.c
> @@ -249,6 +249,41 @@ static void icmp_save(const void *ip, const struct xt_entry_match *match)
>  	}
>  }
>  
> +static unsigned int type_xlate_print(struct xt_xlate *xl, unsigned int icmptype,
> +				     unsigned int code_min,
> +				     unsigned int code_max)
> +{
> +	unsigned int i;
> +
> +	if (code_min != code_max && icmptype != 0xFF) {

So, if icmptype == 0xff, just return 1 with no printing I'd suggest.

> +		for (i = 0; i < ARRAY_SIZE(icmp_codes); ++i)
> +			if (icmp_codes[i].type == icmptype &&
> +			    icmp_codes[i].code_min == code_min &&
> +			    icmp_codes[i].code_max == code_max) {
> +				xt_xlate_add(xl, icmp_codes[i].name);
> +				return 1;
> +			}
> +	}
> +
> +	return 0;
> +}
