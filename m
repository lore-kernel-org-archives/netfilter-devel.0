From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libxt_mark: Add translation to nft
Date: Sat, 5 Dec 2015 20:14:09 +0100
Message-ID: <20151205191409.GA2830@salvia>
References: <1449321576-20705-1-git-send-email-shivanib134@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51630 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361AbbLETOO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Dec 2015 14:14:14 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 93289FB455
	for <netfilter-devel@vger.kernel.org>; Sat,  5 Dec 2015 20:14:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 84234DA803
	for <netfilter-devel@vger.kernel.org>; Sat,  5 Dec 2015 20:14:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9A8F0DA807
	for <netfilter-devel@vger.kernel.org>; Sat,  5 Dec 2015 20:14:10 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1449321576-20705-1-git-send-email-shivanib134@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Shivani,

On Sat, Dec 05, 2015 at 06:49:36PM +0530, Shivani Bhardwaj wrote:
> Add translation of the metainformation mark to nft.
> 
> Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
> ---
>  extensions/libxt_mark.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 60 insertions(+)
> 
> diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
> index 7f8c995..5105bf9 100644
> --- a/extensions/libxt_mark.c
> +++ b/extensions/libxt_mark.c
> @@ -102,6 +102,64 @@ mark_save(const void *ip, const struct xt_entry_match *match)
>  	print_mark(info->mark, info->mask);
>  }
>  
> +static void
> +print_mark_xlate(struct xt_buf *buf,
> +		 unsigned int mark, unsigned int mask)
> +{
> +        if (mask != 0xffffffffU)
> +                xt_buf_add(buf, " 0x%x/0x%x", mark, mask);

In nftables this should be translated to &.

> +        else
> +                xt_buf_add(buf, " 0x%x", mark);
> +}
> +
> +static void
> +mark_mt_xlate_print(const struct xt_entry_match *match,
> +		    struct xt_buf *buf, int numeric)
> +{
> +	const struct xt_mark_mtinfo1 *info = (const void *)match->data;
> +
> +	if (info->invert)      
                         ^^^^^^
There is a tab that is not needed there. Update your editor
configuration to highlight unnecessary spaces before line break,

> +		xt_buf_add(buf, " !");
> +	print_mark_xlate(buf, info->mark, info->mask);
> +}
> +
> +static int
> +mark_mt_xlate(const struct xt_entry_match *match,
> +	      struct xt_buf *buf, int numeric)
> +{
> +	const struct xt_mark_mtinfo1 *info = (const void *)match->data;
> +
> +        xt_buf_add(buf, "ct mark %s", info->invert ? " !" : "");

Invert in nft is '!='.

Please, make sure that the suggested translation actually works in
nft.

But overall this looks good like a good start.
