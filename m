From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] extensions: libxt_mark: Add translation to nft
Date: Wed, 9 Dec 2015 14:26:00 +0100
Message-ID: <20151209132600.GA29450@salvia>
References: <20151206033214.GA5939@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33682 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754205AbbLIN0J (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Dec 2015 08:26:09 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 679921324D0
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2015 14:26:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5413EDA803
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2015 14:26:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 55322DA803
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2015 14:26:01 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151206033214.GA5939@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Dec 06, 2015 at 09:02:14AM +0530, Shivani Bhardwaj wrote:
> Add translation of the metainformation mark to nft.

Much better, but I still need some changes.

Could you include in the description the commands and the result of
testing this, eg.

$ iptables-xlate -I INPUT -m mark --mark 20
nft add rule filter INPUT mark 20

Several examples like that would be good covering all possible cases,
just to make sure you're testing all possible branches in the code
(even if this kind of manual way, there are better ways to cover-test
this in an automated way but this simple testing is fine by now).

More comments below.

> Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
> ---
> Changes in v2:
> 	Fix syntax according to nft and remove trailing whitespaces
> 
>  extensions/libxt_mark.c | 64 +++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 62 insertions(+), 2 deletions(-)
> 
> diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
> index 7f8c995..b0c06c2 100644
> --- a/extensions/libxt_mark.c
> +++ b/extensions/libxt_mark.c
> @@ -75,7 +75,7 @@ mark_print(const void *ip, const struct xt_entry_match *match, int numeric)
>  
>  	if (info->invert)
>  		printf(" !");
> -	
> +
>  	print_mark(info->mark, info->mask);
>  }
>  
> @@ -97,11 +97,69 @@ mark_save(const void *ip, const struct xt_entry_match *match)
>  
>  	if (info->invert)
>  		printf(" !");
> -	
> +
>  	printf(" --mark");
>  	print_mark(info->mark, info->mask);
>  }
>  
> +static void
> +print_mark_xlate(struct xt_buf *buf,
> +		 unsigned int mark, unsigned int mask)
> +{
> +        if (mask != 0xffffffffU)
> +                xt_buf_add(buf, " & x%x == x%x", mark, mask);
> +        else
> +                xt_buf_add(buf, " & x%x", mark);
> +}
> +
> +static void
> +mark_mt_xlate_print(const struct xt_entry_match *match,
> +		    struct xt_buf *buf, int numeric)
> +{
> +	const struct xt_mark_mtinfo1 *info = (const void *)match->data;
> +
> +	if (info->invert)
> +		xt_buf_add(buf, " !=");
> +	print_mark_xlate(buf, info->mark, info->mask);
> +}
> +
> +static int
> +mark_mt_xlate(const struct xt_entry_match *match,
> +	      struct xt_buf *buf, int numeric)
> +{
> +	const struct xt_mark_mtinfo1 *info = (const void *)match->data;
> +
> +	xt_buf_add(buf, "ct mark %s", info->invert ? " !=" : "");
> +        print_mark_xlate(buf, info->mark, info->mask);
> +        xt_buf_add(buf, " ");
   ^^^^^^^^

This indentation is not correct.

> +
> +        return 1;
> +}
> +
> +static void
> +mark_xlate_print(const struct xt_entry_match *match,
> +		 struct xt_buf *buf, int numeric)
> +{
> +	const struct xt_mark_info *info = (const void *)match->data;
> +
> +        if (info->invert)
> +                xt_buf_add(buf, " !=");
> +        print_mark_xlate(buf, info->mark, info->mask);
        ^^^

Same here.

Thanks.
