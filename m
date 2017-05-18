From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2 1/1] iptables: Fix crash on malformed iptables-restore
Date: Thu, 18 May 2017 16:42:18 +0200
Message-ID: <20170518144218.GC1272@breakpoint.cc>
References: <1495117105-32762-1-git-send-email-ojford@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Oliver Ford <ojford@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:54624 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932663AbdEROnK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 May 2017 10:43:10 -0400
Content-Disposition: inline
In-Reply-To: <1495117105-32762-1-git-send-email-ojford@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Oliver Ford <ojford@gmail.com> wrote:
> --- a/iptables/ip6tables-restore.c
> +++ b/iptables/ip6tables-restore.c
> @@ -165,14 +165,33 @@ static void add_param_to_argv(char *parsestart)
>  			param_buffer[param_len] = '\0';
>  
>  			/* check if table name specified */
> -			if (!strncmp(param_buffer, "-t", 2)
> -                            || !strncmp(param_buffer, "--table", 8)) {
> +			if (param_buffer[0] == '-' && param_buffer[1] != '-'
> +				&& strchr(param_buffer, 't')) {
>  				xtables_error(PARAMETER_PROBLEM,
> -				"The -t option (seen in line %u) cannot be "
> -				"used in ip6tables-restore.\n", line);
> +					"The -t option (seen in line %u) cannot be "
> +					"used in ip6tables-restore.\n", line);
> +				exit(1);
> +			} else if (!strncmp(param_buffer, "--", 2)
> +				&& strchr(param_buffer, 't')) {

Why this strchr() ?

if (!strncmp(param_buffer, "--t", 3) &&
    !strncmp(param_buffer, "--table", strlen(param_buffer))
       err();

should work.

> +				/* If we begin with a '--' and have a 't', check
> +				 * that the parameter is in the list of valid options */
> +				const char* t_options[] = {

If this is needed, I'd suggest

static const char * const t_options[] = {

> +					"delete", "insert", "list", "list-rules", "delete-chain",
> +					"destination", "dst", "protocol", "in-interface", "match",
> +					"out-interface", "wait", "wait-interval", "exact",
> +					"fragments", "set-counters", "goto"};
> +				int i, opt_len = ARRAY_SIZE(t_options);
> +				for (i = 0; i < opt_len; i++) {
> +					if (!strcmp(param_buffer + 2, t_options[i])) {
> +						goto t_passed;
> +					}
> +				}

If this t_options[] thing is really needed i'd try to stick this into
a helper function so we don't have to duplicate this in all 3
incarnations.

Thanks for working on this.
