From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] extensions: libipt_MASQUERADE: Add translation to nft
Date: Wed, 2 Mar 2016 12:50:06 +0100
Message-ID: <20160302115006.GC3493@salvia>
References: <20160302095749.GA6686@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53822 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307AbcCBLuX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Mar 2016 06:50:23 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 4C1A86EF2A
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 12:50:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3BDF5DA8FB
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 12:50:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 883C3DA39E
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 12:50:15 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160302095749.GA6686@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 02, 2016 at 03:27:49PM +0530, Shivani Bhardwaj wrote:
> Add translation for masquerade to nftables.
> 
> Examples:
> 
> $ sudo iptables-translate -t nat -A POSTROUTING -j MASQUERADE
> nft add rule ip nat POSTROUTING counter masquerade
> 
> $ sudo iptables-translate -t nat -A POSTROUTING -p tcp -j MASQUERADE --to-ports 10
> nft add rule ip nat POSTROUTING ip protocol tcp counter masquerade to :10
> 
> $ sudo iptables-translate -t nat -A POSTROUTING -p tcp -j MASQUERADE --to-ports 10-20 --random
> nft add rule ip nat POSTROUTING ip protocol tcp counter masquerade to :10-20 random

Applied, thanks Shivani.
> 
> Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
> ---
> Changes in v2:
> 	Add code for masquerade port range selection
> 
>  extensions/libipt_MASQUERADE.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/extensions/libipt_MASQUERADE.c b/extensions/libipt_MASQUERADE.c
> index ea07445..d1393c1 100644
> --- a/extensions/libipt_MASQUERADE.c
> +++ b/extensions/libipt_MASQUERADE.c
> @@ -134,6 +134,29 @@ MASQUERADE_save(const void *ip, const struct xt_entry_target *target)
>  		printf(" --random");
>  }
>  
> +static int
> +MASQUERADE_xlate(const struct xt_entry_target *target,
> +		 struct xt_xlate *xl, int numeric)
> +{
> +	const struct nf_nat_ipv4_multi_range_compat *mr =
> +					(const void *)target->data;
> +	const struct nf_nat_ipv4_range *r = &mr->range[0];
> +
> +	xt_xlate_add(xl, "masquerade");
> +
> +	if (r->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
> +		xt_xlate_add(xl, " to :%hu", ntohs(r->min.tcp.port));
> +		if (r->max.tcp.port != r->min.tcp.port)
> +			xt_xlate_add(xl, "-%hu", ntohs(r->max.tcp.port));
> +        }
        ^^^

I have fixed this minor glitch here.

