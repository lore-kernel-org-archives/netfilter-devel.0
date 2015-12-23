From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libxt_mark: Fix inversion code
Date: Wed, 23 Dec 2015 11:09:26 +0100
Message-ID: <20151223100926.GB1952@salvia>
References: <20151222212137.GA15975@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42706 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755293AbbLWKJi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Dec 2015 05:09:38 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 3A4D810214B
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Dec 2015 11:09:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 27C77EBAE7
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Dec 2015 11:09:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AA594DA843
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Dec 2015 11:09:31 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151222212137.GA15975@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 23, 2015 at 02:51:37AM +0530, Shivani Bhardwaj wrote:
> Fix the code associated with invert flag.
> 
> Examples:
> 
> $ sudo iptables-translate -I INPUT -p tcp -m mark ! --mark 0xa/0xa
> nft insert rule ip filter INPUT ip protocol tcp mark and 0xa != 0xa counter
> 
> $ sudo iptables-translate -I INPUT -p tcp -m mark ! --mark 0x1
> nft insert rule ip filter INPUT ip protocol tcp mark != 0x1 counter
> 
> Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
> ---
>  extensions/libxt_mark.c | 26 ++++++++++++++++++--------
>  1 file changed, 18 insertions(+), 8 deletions(-)
> 
> diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
> index 3b96a34..3beccc8 100644
> --- a/extensions/libxt_mark.c
> +++ b/extensions/libxt_mark.c
> @@ -1,5 +1,6 @@
>  #include <stdbool.h>
>  #include <stdio.h>
> +#include <string.h>
>  #include <xtables.h>
>  #include <linux/netfilter/xt_mark.h>
>  
> @@ -103,13 +104,14 @@ mark_save(const void *ip, const struct xt_entry_match *match)
>  }

I suggest you add this to xtables.h:

enum {
        XT_OP_EQ,
        XT_OP_NEQ,
        XT_OP_MAX
};

>  static void
> -print_mark_xlate(struct xt_buf *buf,
> -		 unsigned int mark, unsigned int mask)
> +print_mark_xlate(struct xt_buf *buf, unsigned int mark,
> +		 unsigned int mask, const char *str)
>  {
>  	if (mask != 0xffffffffU)
> -		xt_buf_add(buf, " and 0x%x == 0x%x ", mark, mask);
> +		xt_buf_add(buf, " and 0x%x %s 0x%x ", mark, str, mask);
>  	else
> -		xt_buf_add(buf, " 0x%x ", mark);
> +		xt_buf_add(buf, " %s0x%x ",
> +			   !strcmp(str, "==") ? "" : "!= ", mark);

So instead of passing 'str' as parameter, you can pass a uint32_t op
(enums are always guaranteed to be uint32_t).

Then

		xt_buf_add(buf, " %s0x%x ", op == XT_OP_EQ ? "" : "!=", mark);

>  static int
> @@ -117,9 +119,13 @@ mark_mt_xlate(const struct xt_entry_match *match,
>  	      struct xt_buf *buf, int numeric)
>  {
>  	const struct xt_mark_mtinfo1 *info = (const void *)match->data;
> +	const char *str = "==";

This code will be nicer using the approach I'm suggesting above.

Please, apply this suggestion to all your pending patches and resubmit.

Thanks Shivani.
