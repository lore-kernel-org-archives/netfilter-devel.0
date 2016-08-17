From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables 2/2] xtables-translate-restore: do not escape
 quotes
Date: Wed, 17 Aug 2016 16:28:54 +0200
Message-ID: <20160817142854.GB9755@salvia>
References: <20160816174433.28272-1-pablombg@gmail.com>
 <20160816174433.28272-2-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55324 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907AbcHQO3D (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Aug 2016 10:29:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 92EF2D1634
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 16:29:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8357A96600
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 16:29:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7B6F6DA7FE
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 16:28:59 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160816174433.28272-2-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 16, 2016 at 07:44:33PM +0200, Pablo M. Bermudo Garay wrote:
> If quotes are escaped, nft -f is unable to parse and load the translated
> ruleset.
> 
> Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
> ---
>  iptables/xtables-translate.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
> index 3c577ed..914d3b1 100644
> --- a/iptables/xtables-translate.c
> +++ b/iptables/xtables-translate.c
> @@ -72,6 +72,11 @@ int xlate_action(const struct iptables_command_state *cs, bool goto_set,
>  				.numeric	= numeric,
>  				.escape_quotes	= true,
>  			};
> +			if (!strcmp(xtables_globals.program_name,
> +				   "iptables-translate-restore") ||
> +			    !strcmp(xtables_globals.program_name,
> +				   "ip6tables-translate-restore"))
> +				params.escape_quotes = false;
>  			ret = cs->target->xlate(xl, &params);
>  		}
>  		else

I can see a 'bool restore' in do_command_xlate() provides this
context, you can probably propagate this.

This strcmp() is ugly using the global.
