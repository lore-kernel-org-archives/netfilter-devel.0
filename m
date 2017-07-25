From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 4/6] monitor: Print space after semicolon
Date: Tue, 25 Jul 2017 18:03:08 +0200
Message-ID: <20170725160308.GE591@salvia>
References: <20170725145629.20974-1-phil@nwl.cc>
 <20170725145629.20974-5-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40194 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752506AbdGYQDY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jul 2017 12:03:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3BF2617D421
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jul 2017 18:03:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2EFADD1CAF
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jul 2017 18:03:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 20CE8D2AE6
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jul 2017 18:03:09 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170725145629.20974-5-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 25, 2017 at 04:56:27PM +0200, Phil Sutter wrote:
> This makes output a bit more readable.

Could you print an example in the patch description of what is being
more readable after this? Thanks!

[...]
> diff --git a/src/rule.c b/src/rule.c
> index 5ea4fce546e30..12714ed3ccc70 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -381,7 +381,7 @@ void set_print_plain(const struct set *s, struct output_ctx *octx)
>  		.nl		= " ",
>  		.table		= s->handle.table,
>  		.family		= family2str(s->handle.family),
> -		.stmt_separator	= ";",
> +		.stmt_separator	= "; ",
>  	};
>  
>  	do_set_print(s, &opts, octx);
> -- 
> 2.13.1
> 
