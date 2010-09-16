From: Stig Thormodsrud <stig@vyatta.com>
Subject: Re: [PATCH 2/4] iptables: limit chain name length to be consistent
 with targets
Date: Wed, 15 Sep 2010 17:29:12 -0700
Message-ID: <4C9164D8.2060307@vyatta.com>
References: <1284576828-32412-1-git-send-email-jengelh@medozas.de> <1284576828-32412-3-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org, kaber@trash.net,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:56487 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085Ab0IPA3N (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Sep 2010 20:29:13 -0400
In-Reply-To: <1284576828-32412-3-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 09/15/2010 11:53 AM, Jan Engelhardt wrote:
> Creationg of chain names longer than the ones being able to jump to
> should be inhibited for consistency.
> 
> References: http://marc.info/?l=netfilter-devel&m=128397022618316&w=2
> Cc: Stig Thormodsrud <stig@vyatta.com>
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---
>  ip6tables.c |    6 +++---
>  iptables.c  |    6 +++---
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/ip6tables.c b/ip6tables.c
> index 6c5d124..15067da 100644
> --- a/ip6tables.c
> +++ b/ip6tables.c
> @@ -1838,10 +1838,10 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
>  
>  	generic_opt_check(command, options);
>  
> -	if (chain && strlen(chain) > IP6T_FUNCTION_MAXNAMELEN)
> +	if (chain != NULL && strlen(chain) >= XT_EXTENSION_MAXNAMELEN)
>  		xtables_error(PARAMETER_PROBLEM,
> -			   "chain name `%s' too long (must be under %i chars)",
> -			   chain, IP6T_FUNCTION_MAXNAMELEN);
> +			   "chain name `%s' too long (must be under %u chars)",
> +			   chain, XT_EXTENSION_MAXNAMELEN);
>  
>  	/* only allocate handle if we weren't called with a handle */
>  	if (!*handle)
> diff --git a/iptables.c b/iptables.c
> index 19f6d4f..840dd3e 100644
> --- a/iptables.c
> +++ b/iptables.c
> @@ -1876,10 +1876,10 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
>  
>  	generic_opt_check(command, options);
>  
> -	if (chain && strlen(chain) > IPT_FUNCTION_MAXNAMELEN)
> +	if (chain != NULL && strlen(chain) >= XT_EXTENSION_MAXNAMELEN)
>  		xtables_error(PARAMETER_PROBLEM,
> -			   "chain name `%s' too long (must be under %i chars)",
> -			   chain, IPT_FUNCTION_MAXNAMELEN);
> +			   "chain name `%s' too long (must be under %u chars)",
> +			   chain, XT_EXTENSION_MAXNAMELEN);
>  
>  	/* only allocate handle if we weren't called with a handle */
>  	if (!*handle)

Thanks for the fix.  I guess my original question was if the change in
max name length from 29 to 28 characters was intentional or required by
some other data structure change?

iptables -t filter --new-chain A234567890123456789012345678901
iptables v1.4.4: chain name `A234567890123456789012345678901' too long
(must be under 30 chars)


iptables -t filter --new-chain A234567890123456789012345678901
iptables v1.4.9: chain name `A234567890123456789012345678901' too long
(must be under 29 chars)


I know you're probably thinking it's just 1 character who cares, but we
have checks for that max in a lot of places and our log tag is based on
the chain name and the log tag has a max size and blah blah...


