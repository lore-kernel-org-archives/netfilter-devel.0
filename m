From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/3] xtables-events: prints arp rules
Date: Fri, 7 Feb 2014 19:28:30 +0100
Message-ID: <20140207182830.GB4853@localhost>
References: <1391693471-7591-1-git-send-email-giuseppelng@gmail.com>
 <1391693471-7591-4-git-send-email-giuseppelng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47777 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbaBGS2l (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Feb 2014 13:28:41 -0500
Content-Disposition: inline
In-Reply-To: <1391693471-7591-4-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 06, 2014 at 02:31:11PM +0100, Giuseppe Longo wrote:
> This patch permits to print arp rules,
> avoiding the segfault that you got currently.
> 
> Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
> ---
>  iptables/xtables-events.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/iptables/xtables-events.c b/iptables/xtables-events.c
> index 408e091..7ce1d4f 100644
> --- a/iptables/xtables-events.c
> +++ b/iptables/xtables-events.c
> @@ -59,7 +59,11 @@ static bool counters;
>  static int rule_cb(const struct nlmsghdr *nlh, int type)
>  {
>  	struct iptables_command_state cs = {};
> +	struct arpt_entry fw_arp = {};
> +	struct xtables_ebt_entry fw_eb = {};

There is no ebt compat yet, please, remove this line above.

>  	struct nft_rule *r;
> +	void *fw = NULL;
> +	uint8_t family;
>  
>  	r = nft_rule_alloc();
>  	if (r == NULL) {
> @@ -72,21 +76,23 @@ static int rule_cb(const struct nlmsghdr *nlh, int type)
>  		goto err_free;
>  	}
>  
> -	nft_rule_to_iptables_command_state(r, &cs);
> -
> -	switch(nft_rule_attr_get_u8(r, NFT_RULE_ATTR_FAMILY)) {
> +	family = nft_rule_attr_get_u8(r, NFT_RULE_ATTR_FAMILY);
> +	switch(family) {
>  	case AF_INET:
> -		printf("-4 ");
> -		break;
>  	case AF_INET6:
> -		printf("-6 ");
> +		printf("-%c ", family == AF_INET ? '4' : '6');
> +		nft_rule_to_iptables_command_state(r, &cs);
> +		fw = &cs;
>  		break;
> +	case NFPROTO_ARP:
> +		nft_rule_to_arpt_entry(r, &fw_arp);
> +		fw = &fw_arp;
>  	default:
>  		break;
>  	}
>  
>  
> -	nft_rule_print_save(&cs, r,
> +	nft_rule_print_save(fw, r,
>  			    type == NFT_MSG_NEWRULE ? NFT_RULE_APPEND :
>  						      NFT_RULE_DEL,
>  			    counters ? 0 : FMT_NOCOUNTS);
> -- 
> 1.8.1.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
