From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libxt_dscp: Add translation to nft
Date: Mon, 6 Jun 2016 13:00:54 +0200
Message-ID: <20160606110054.GA2843@salvia>
References: <20160605175721.GA8239@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45593 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbcFFLBJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jun 2016 07:01:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id D7C44F04064
	for <netfilter-devel@vger.kernel.org>; Mon,  6 Jun 2016 13:01:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C60221B52D6
	for <netfilter-devel@vger.kernel.org>; Mon,  6 Jun 2016 13:01:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A04531B52CA
	for <netfilter-devel@vger.kernel.org>; Mon,  6 Jun 2016 13:01:04 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160605175721.GA8239@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jun 05, 2016 at 07:57:23PM +0200, Laura Garcia Liebana wrote:
> Add translation for dscp to nftables, for both ipv4 and ipv6.
> 
> Examples:
> 
> $ sudo iptables-translate -t filter -A INPUT -m dscp --dscp 0x32 -j ACCEPT
> nft add rule ip filter INPUT ip dscp 0x32 counter accept
> 
> $ sudo ip6tables-translate -t filter -A INPUT -m dscp --dscp 0x32 -j ACCEPT
> nft add rule ip6 filter INPUT ip6 dscp != 0x32 counter accept
> 
> Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
> ---
>  extensions/libxt_dscp.c | 92 ++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 79 insertions(+), 13 deletions(-)
> 
> diff --git a/extensions/libxt_dscp.c b/extensions/libxt_dscp.c
> index 02b22a4..4b88c5a 100644
> --- a/extensions/libxt_dscp.c
> +++ b/extensions/libxt_dscp.c
> @@ -91,21 +91,87 @@ static void dscp_save(const void *ip, const struct xt_entry_match *match)
>  	printf("%s --dscp 0x%02x", dinfo->invert ? " !" : "", dinfo->dscp);
>  }
>  
> -static struct xtables_match dscp_match = {
> -	.family		= NFPROTO_UNSPEC,
> -	.name 		= "dscp",
> -	.version 	= XTABLES_VERSION,
> -	.size 		= XT_ALIGN(sizeof(struct xt_dscp_info)),
> -	.userspacesize	= XT_ALIGN(sizeof(struct xt_dscp_info)),
> -	.help		= dscp_help,
> -	.print		= dscp_print,
> -	.save		= dscp_save,
> -	.x6_parse	= dscp_parse,
> -	.x6_fcheck	= dscp_check,
> -	.x6_options	= dscp_opts,
> +static int __dscp_xlate(const void *ip, const struct xt_entry_match *match,
> +		      struct xt_xlate *xl, int numeric)
> +{
> +	const struct xt_dscp_info *dinfo =
> +		(const struct xt_dscp_info *)match->data;
> +
> +	xt_xlate_add(xl, "dscp %s0x%02x ",
> +		     dinfo->invert ? "!= " : "",
> +		     dinfo->dscp);
> +
> +	return 1;
> +}
> +
> +static int dscp_xlate(const void *ip, const struct xt_entry_match *match,
> +		      struct xt_xlate *xl, int numeric)
> +{
> +	xt_xlate_add(xl, "ip ");
> +
> +	return __dscp_xlate(ip, match, xl, numeric);
> +}
> +
> +static int dscp_xlate6(const void *ip, const struct xt_entry_match *match,
> +		      struct xt_xlate *xl, int numeric)
> +{
> +	xt_xlate_add(xl, "ip6 ");
> +
> +	return __dscp_xlate(ip, match, xl, numeric);
> +}
> +
> +static int dscp_xlate_uns(const void *ip, const struct xt_entry_match *match,
> +		      struct xt_xlate *xl, int numeric)
> +{
> +	return 0;
> +}
> +
> +static struct xtables_match dscp_mt_reg[] = {
> +	{
> +		.family		= NFPROTO_IPV4,
> +		.name           = "dscp",
> +		.version        = XTABLES_VERSION,
> +		.size           = XT_ALIGN(sizeof(struct xt_dscp_info)),
> +		.userspacesize	= XT_ALIGN(sizeof(struct xt_dscp_info)),
> +		.help		= dscp_help,
> +		.print		= dscp_print,
> +		.save		= dscp_save,
> +		.x6_parse	= dscp_parse,
> +		.x6_fcheck	= dscp_check,
> +		.x6_options	= dscp_opts,
> +		.xlate		= dscp_xlate,
> +	},
> +	{
> +		.family		= NFPROTO_IPV6,
> +		.name           = "dscp",
> +		.version        = XTABLES_VERSION,
> +		.size           = XT_ALIGN(sizeof(struct xt_dscp_info)),
> +		.userspacesize	= XT_ALIGN(sizeof(struct xt_dscp_info)),
> +		.help		= dscp_help,
> +		.print		= dscp_print,
> +		.save		= dscp_save,
> +		.x6_parse	= dscp_parse,
> +		.x6_fcheck	= dscp_check,
> +		.x6_options	= dscp_opts,
> +		.xlate		= dscp_xlate6,
> +	},
> +	{
> +		.family		= NFPROTO_UNSPEC,
> +		.name           = "dscp",
> +		.version        = XTABLES_VERSION,
> +		.size           = XT_ALIGN(sizeof(struct xt_dscp_info)),
> +		.userspacesize	= XT_ALIGN(sizeof(struct xt_dscp_info)),
> +		.help		= dscp_help,
> +		.print		= dscp_print,
> +		.save		= dscp_save,
> +		.x6_parse	= dscp_parse,
> +		.x6_fcheck	= dscp_check,
> +		.x6_options	= dscp_opts,
> +		.xlate		= dscp_xlate_uns,
> +	},

I think you can remove the NFPROTO_UNSPEC now that you registered one
specifically for ipv4 and another for ipv6.

iptables only support ipv4 and ipv6 indeed.
