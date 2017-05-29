From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v5 1/1] iptables: Fix crash on malformed iptables-restore
Date: Mon, 29 May 2017 14:05:18 +0200
Message-ID: <20170529120518.GA11232@salvia>
References: <1495195346-6340-1-git-send-email-ojford@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Oliver Ford <ojford@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41862 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750966AbdE2MFX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 May 2017 08:05:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 69E39303D09
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 14:05:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5646D18520
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 14:05:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5A27E102188
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 14:05:12 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1495195346-6340-1-git-send-email-ojford@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 19, 2017 at 12:02:26PM +0000, Oliver Ford wrote:
> Fixes the crash reported in Bugzilla #1131 where a malformed parameter that
> specifies the table option during a restore can create an invalid pointer.
> It was discovered during fuzz testing that options like '-ftf'
> can cause a segfault. A parameter that includes a 't' is not currently
> filtered correctly.
> 
> Improves the filtering to:
> Filter a beginning '-' followed by a character other than '-' and then a 't'
> anywhere in the parameter. This filters parameters like '-ftf'.
> Filter '--t'.
> Filter '--table', stopping when the parameter length is reached. Because the
> getopt_long function allows abbreviations, any unique abbreviation of '--table'
> will be treated as '--table'. This filters parameters like '--t', '--ta', but not
> '--ttl' or '--target'.

Applied with minor glitches.

> Signed-off-by: Oliver Ford <ojford@gmail.com>
> ---
>  iptables/ip6tables-restore.c | 6 ++++--
>  iptables/iptables-restore.c  | 6 ++++--
>  iptables/iptables-xml.c      | 7 ++++---
>  iptables/xtables-restore.c   | 6 ++++--
>  4 files changed, 16 insertions(+), 9 deletions(-)
> 
> diff --git a/iptables/ip6tables-restore.c b/iptables/ip6tables-restore.c
> index 39a881d..966f189 100644
> --- a/iptables/ip6tables-restore.c
> +++ b/iptables/ip6tables-restore.c
> @@ -165,8 +165,10 @@ static void add_param_to_argv(char *parsestart)
>  			param_buffer[param_len] = '\0';
>  
>  			/* check if table name specified */
> -			if (!strncmp(param_buffer, "-t", 2)
> -                            || !strncmp(param_buffer, "--table", 8)) {
> +			if ((param_buffer[0] == '-' && param_buffer[1] != '-' &&
> +				strchr(param_buffer, 't')) ||
> +				(!strncmp(param_buffer, "--t", 3)
> +				&& !strncmp(param_buffer, "--table", strlen(param_buffer)))) {

No blame. iptables coding style is a bit messy, but we try to make it
converge to kernel coding style with this updates so I mangled this to:

			if ((param_buffer[0] == '-' &&
                             param_buffer[1] != '-' &&
                             strchr(param_buffer, 't')) ||
                            (!strncmp(param_buffer, "--t", 3) &&
                             !strncmp(param_buffer, "--table", strlen(param_buffer)))) {
