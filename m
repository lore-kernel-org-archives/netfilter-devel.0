From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/7] iptables-restore: warn about -t in rule lines
Date: Tue, 31 Jul 2012 13:39:20 +0200
Message-ID: <20120731113920.GA4511@1984>
References: <1343496069-5442-1-git-send-email-jengelh@inai.de>
 <1343496069-5442-2-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45876 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755715Ab2GaLjZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 Jul 2012 07:39:25 -0400
Content-Disposition: inline
In-Reply-To: <1343496069-5442-2-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jul 28, 2012 at 07:21:03PM +0200, Jan Engelhardt wrote:
> save-restore syntax uses *table, not -t table.
> 
> Signed-off-by: Jan Engelhardt <jengelh@inai.de>
> ---
>  iptables/ip6tables-restore.c |    3 +--
>  iptables/iptables-restore.c  |    3 +--
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/iptables/ip6tables-restore.c b/iptables/ip6tables-restore.c
> index 3894d68..614ff0f 100644
> --- a/iptables/ip6tables-restore.c
> +++ b/iptables/ip6tables-restore.c
> @@ -417,8 +417,7 @@ int ip6tables_restore_main(int argc, char *argv[])
>  					if (!strncmp(param_buffer, "-t", 2)
>                                              || !strncmp(param_buffer, "--table", 8)) {
>  						xtables_error(PARAMETER_PROBLEM,
> -						   "Line %u seems to have a "
> -						   "-t table option.\n", line);
> +						   "The -t option (seen in line %u) cannot be used in ip6tables-restore.\n", line);

Lines should break at 80 chars.

I know we sometimes slightly violate this limit, but I don't want to
have wrapping code in my 80-chars terminals.

No need to resend, I did it myself.
