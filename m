From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ebtables-compat-experimental5 PATCH] iptables: xtables-eb:
 user-defined chains default policy is always RETURN
Date: Thu, 20 Nov 2014 13:07:18 +0100
Message-ID: <20141120120718.GA9745@salvia>
References: <20141119131147.15524.18916.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, giuseppelng@gmail.com
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57434 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755854AbaKTMFg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Nov 2014 07:05:36 -0500
Content-Disposition: inline
In-Reply-To: <20141119131147.15524.18916.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 19, 2014 at 02:11:47PM +0100, Arturo Borrero Gonzalez wrote:
> The RETURN default policy is mandatory in user-defined chains.
> Builtin chains must have one of ACCEPT or DROP.
> 
> So, with this patch, ebtables-compat ends with:
> 
> Command:			Result:
> 
> -L				Always RETURN for user-defined chains
> -P builtin RETURN		Policy RETURN only allowed for user defined chains
> -P builtin ACCEPT|DROP		ok
> -P userdefined RETURN		Default policy in user-defined chains is RETURN
> -P userdefined ACCEPT|DROP	Default policy in user-defined chains is RETURN
> -N userdefined			ok
> -N userdefined -P RETURN	Default policy in user-defined chains is RETURN
> -N userdefined -P ACCEPT|DROP	Default policy in user-defined chains is RETURN
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  iptables/nft-bridge.c |    3 ++-
>  iptables/xtables-eb.c |   13 +++++++++++--
>  2 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
> index b5aec00..a1bd906 100644
> --- a/iptables/nft-bridge.c
> +++ b/iptables/nft-bridge.c
> @@ -356,7 +356,8 @@ static void nft_bridge_print_header(unsigned int format, const char *chain,
>  				    const struct xt_counters *counters,
>  				    bool basechain, uint32_t refs)
>  {
> -	printf("Bridge chain: %s, entries: %u, policy: %s\n", chain, refs, pol);
> +	printf("Bridge chain: %s, entries: %u, policy: %s\n",
> +	       chain, refs, basechain ? pol : "RETURN");
>  }
>  
>  static void nft_bridge_print_firewall(struct nft_rule *r, unsigned int num,
> diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
> index 917bca2..0775ee7 100644
> --- a/iptables/xtables-eb.c
> +++ b/iptables/xtables-eb.c
> @@ -616,6 +616,7 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table)
>  		case 'E': /* Rename chain */
>  		case 'X': /* Delete chain */
>  			/* We allow -N chainname -P policy */
> +			/* XXX: Not in ebtables-compat */
>  			if (command == 'N' && c == 'P') {
>  				command = c;
>  				optind--; /* No table specified */
> @@ -1146,9 +1147,17 @@ check_extension: */
>  	cs.fw.ethproto = htons(cs.fw.ethproto);
>  
>  	if (command == 'P') {
> -		if (selected_chain < NF_BR_NUMHOOKS && strcmp(policy, "RETURN")==0)
> +		if (selected_chain < 0) {
>  			xtables_error(PARAMETER_PROBLEM,
> -				      "Policy RETURN only allowed for user defined chains");
> +				      "Default policy in user-defined"
> +				      " chains is mandatory RETURN");

Wait.

This changes the existing behaviour. I mean, this check rejects rules
using RETURN from base chains, that should still be there to mimic
ebtables behaviour. Why change this?

> +		}
> +		if (strcmp(policy, "ACCEPT") != 0 &&
> +		    strcmp(policy, "DROP") != 0) {
> +			xtables_error(PARAMETER_PROBLEM,
> +				      "Default policy in default chains"
> +				      " is either ACCEPT or DROP");

Please use the same error message the ebtables uses:

"Policy RETURN only allowed for user defined chains");

And explicitly check for RETURN instead. This is a compat tool, we
should spot the same errors than the original.

> +		}
>  		ret = nft_chain_set(h, *table, chain, policy, NULL);
>  		if (ret < 0)
>  			xtables_error(PARAMETER_PROBLEM, "Wrong policy");
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
