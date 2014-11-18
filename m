From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ebtables-compat-experimental5 PATCH] iptables: xtables-eb:
 adjust policy in user-defined chains
Date: Tue, 18 Nov 2014 19:43:43 +0100
Message-ID: <20141118184343.GA5179@salvia>
References: <20141117123622.11349.43033.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, giuseppelng@gmail.com
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57601 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829AbaKRSlo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Nov 2014 13:41:44 -0500
Content-Disposition: inline
In-Reply-To: <20141117123622.11349.43033.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 17, 2014 at 01:36:23PM +0100, Arturo Borrero Gonzalez wrote:
> The ebtables-compat tool doesn't support default policy in custom chains.
> RETURN is the default policy in this case, and is mandatory (this is the
> behaviour of nf_tables).
> 
> While at it, fix the error message when trying to change the default policy to
> RETURN in builtin chains to match the original ebtables message.
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  iptables/nft-bridge.c |    7 ++++++-
>  iptables/xtables-eb.c |   19 ++++++++++++-------
>  2 files changed, 18 insertions(+), 8 deletions(-)
> 
> diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
> index b5aec00..dc26bfd 100644
> --- a/iptables/nft-bridge.c
> +++ b/iptables/nft-bridge.c
> @@ -356,7 +356,12 @@ static void nft_bridge_print_header(unsigned int format, const char *chain,
>  				    const struct xt_counters *counters,
>  				    bool basechain, uint32_t refs)
>  {
> -	printf("Bridge chain: %s, entries: %u, policy: %s\n", chain, refs, pol);
> +	if (basechain)
> +		printf("Bridge chain: %s, entries: %u, policy: %s\n",
> +		       chain, refs, pol);
> +	else
> +		printf("Bridge chain: %s, entries: %u, policy: RETURN\n",
> +		       chain, refs);
>  }

I'd suggest:

        printf("Bridge chain: %s, entries: %u, policy: %s\n",
               chain, refs, basechain ? pol : "RETURN");

>  static void nft_bridge_print_firewall(struct nft_rule *r, unsigned int num,
> diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
> index 917bca2..bf9f264 100644
> --- a/iptables/xtables-eb.c
> +++ b/iptables/xtables-eb.c
> @@ -615,11 +615,10 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table)
>  		case 'N': /* Make a user defined chain */
>  		case 'E': /* Rename chain */
>  		case 'X': /* Delete chain */
> -			/* We allow -N chainname -P policy */

Better extend this comment:

                        /* We allow -N chainname -P policy */
                        /* XXX: Not in ebtables-compat */

>  			if (command == 'N' && c == 'P') {
> -				command = c;
> -				optind--; /* No table specified */
> -				goto handle_P;
> +				xtables_error(PARAMETER_PROBLEM,
> +					      "The default policy in user-defined"
> +					      " chains is RETURN (mandatory)");
>  			}

I'd really prefer to avoid changes in the ebtables parser. Could you
perform this checking from later on, when validating the
configuration.

        if (strcmp(chain, "INPUT") != 0 &&
            strcmp(chain, "FORWARD") != 0 &&
            ...                           &&
            strcmp(policy, "RETURN") != 0)
                xtables_error("...);

>  			if (OPT_COMMANDS)
>  				xtables_error(PARAMETER_PROBLEM,
> @@ -663,7 +662,6 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table)
>  					optind++;
>  				}
>  			} else if (c == 'P') {
> -handle_P:
>  				if (optind >= argc)
>  					xtables_error(PARAMETER_PROBLEM,
>  						      "No policy specified");
> @@ -1146,9 +1144,16 @@ check_extension: */
>  	cs.fw.ethproto = htons(cs.fw.ethproto);
>  
>  	if (command == 'P') {
> -		if (selected_chain < NF_BR_NUMHOOKS && strcmp(policy, "RETURN")==0)
> +		if (selected_chain < 0) {
>  			xtables_error(PARAMETER_PROBLEM,
> -				      "Policy RETURN only allowed for user defined chains");
> +				      "Default policy in user-defined chains "
> +				      "is mandatory RETURN");
> +		}
> +		if (strcmp(policy, "RETURN") == 0) {
> +			xtables_error(PARAMETER_PROBLEM,
> +				      "Policy RETURN only allowed for user "
> +				      "defined chains");
> +		}

Not sure why you need this change.
