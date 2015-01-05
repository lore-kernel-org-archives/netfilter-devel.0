From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ebtables-compat PATCH] ebtables-compat: fix segfault in rules
 w/o target
Date: Mon, 5 Jan 2015 14:05:45 +0100
Message-ID: <20150105130545.GA5502@salvia>
References: <20141230154444.25515.55322.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, giuseppelng@gmail.com
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44927 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330AbbAENDE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Jan 2015 08:03:04 -0500
Content-Disposition: inline
In-Reply-To: <20141230154444.25515.55322.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 30, 2014 at 04:44:44PM +0100, Arturo Borrero Gonzalez wrote:
> This patch fixes a segfault in rules without target.
> 
> Now, these two rules are allowed:
> 
> % ebtables-compat -A FORWARD -p 0x0600 -j CONTINUE
> % ebtables-compat -A FORWARD -p 0x0600
> 
> And both are printed:
> 
> Bridge chain: FORWARD, entries: 1, policy: ACCEPT
> -p 0x600 -j CONTINUE
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  iptables/nft-bridge.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
> index 90bcd63..79abf73 100644
> --- a/iptables/nft-bridge.c
> +++ b/iptables/nft-bridge.c
> @@ -114,6 +114,12 @@ static int _add_action(struct nft_rule *r, struct ebtables_command_state *cs)
>  {
>  	int ret = 0;
>  
> +	if (cs->jumpto == NULL)
> +		return 0;
> +
> +	if (strcmp(cs->jumpto, "CONTINUE") == 0)
> +		return 0;

Could you consolidate this code?

        if (cs->jumpto == NULL || strcmp(...) == 0)
                return 0;

> +
>  	/* If no target at all, add nothing (default to continue) */
>  	if (cs->target != NULL) {
>  		/* Standard target? */
> @@ -462,6 +468,10 @@ static void nft_bridge_print_firewall(struct nft_rule *r, unsigned int num,
>  		}
>  	}
>  
> +	if (strcmp(cs.jumpto, "") == 0) {
> +		printf("CONTINUE");
> +	}

You can remove the brackets, and...

        printf("-j ");
        if (!(format & FMT_NOTARGET))
                printf("%s", cs.jumpto); <----- is this handling this case?

        if (cs.target != NULL) {
                if (cs.target->print != NULL) {
                        cs.target->print(&cs.fw, cs.target->t,
                                            format & FMT_NUMERIC);
                }
        }

        if (strcmp(cs.jumpto, "") == 0)
                printf("CONTINUE");

