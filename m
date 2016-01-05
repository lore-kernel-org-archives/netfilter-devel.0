From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 3/4] rule: delete extra space in sets printing
Date: Tue, 5 Jan 2016 12:28:15 +0100
Message-ID: <20160105112815.GC8791@salvia>
References: <145190990642.22285.2420592085262978551.stgit@r2d2.cica.es>
 <145190991706.22285.17585254866421222372.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40195 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032AbcAEL2U (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jan 2016 06:28:20 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 437BE1324D7
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Jan 2016 12:28:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 35344DA85D
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Jan 2016 12:28:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3C674DA804
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Jan 2016 12:28:17 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <145190991706.22285.17585254866421222372.stgit@r2d2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 04, 2016 at 01:18:37PM +0100, Arturo Borrero Gonzalez wrote:
> The extra space is printed when sets are printed in tabulated format.
> However, the space is still required in printing in plain format (ie, monitor).
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  0 files changed
> 
> diff --git a/src/rule.c b/src/rule.c
> index c0e45aa..ab39513 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -267,7 +267,10 @@ static void set_print_declaration(const struct set *set,
>  	if (opts->table != NULL)
>  		printf(" %s", opts->table);
>  
> -	printf(" %s { %s", set->handle.set, opts->nl);
> +	printf(" %s {%s", set->handle.set, opts->nl);
> +
> +	if (!strcmp(opts->nl, ""))

This could be replaced by:

        if (!opts->nl[0])

But could you post what output you're trying to fix?

Thanks.

> +		printf(" ");
>  
>  	printf("%s%stype %s", opts->tab, opts->tab, set->keytype->name);
>  	if (set->flags & SET_F_MAP)
> 
