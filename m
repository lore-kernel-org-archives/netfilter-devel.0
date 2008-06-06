From: Patrick McHardy <kaber@trash.net>
Subject: Re: [ULOGD PATCH 3/5] Enable reading of hex or dec integer in config
 file.
Date: Fri, 06 Jun 2008 15:23:42 +0200
Message-ID: <48493A5E.2060109@trash.net>
References: <> <1212758035-19538-1-git-send-email-eric@inl.fr> <1212758035-19538-2-git-send-email-eric@inl.fr> <1212758035-19538-3-git-send-email-eric@inl.fr> <1212758035-19538-4-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44821 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203AbYFFNXq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jun 2008 09:23:46 -0400
In-Reply-To: <1212758035-19538-4-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> The config file parsing was not able to parse integer given in hex notation.
> This patch modify the parsing of configfile to be able to use different
> integers notation.
> 
> Signed-off-by: Eric Leblond <eric@inl.fr>
> ---
>  src/conffile.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/src/conffile.c b/src/conffile.c
> index b74da68..075b867 100644
> --- a/src/conffile.c
> +++ b/src/conffile.c
> @@ -115,6 +115,7 @@ int config_parse_file(const char *section, struct config_keyset *kset)
>  	int i;
>  	char linebuf[LINE_LEN+1];
>  	char *line = linebuf;
> +	char *end;
>  
>  	pr_debug("%s: section='%s' file='%s'\n", __func__, section, fname);
>  
> @@ -192,7 +193,7 @@ int config_parse_file(const char *section, struct config_keyset *kset)
>  					}
>  					break;
>  				case CONFIG_TYPE_INT:
> -					ce->u.value = atoi(args);
> +					ce->u.value = strtoul(args, &end, 0);


Not that it matters much, but you can also pass a NULL
pointer to strtoul in case you're not interested in the
end (no need to resend of course).

