From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libxt_helper: Add translation to nft
Date: Wed, 23 Dec 2015 11:01:58 +0100
Message-ID: <20151223100158.GA1952@salvia>
References: <20151223095347.GA5866@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39455 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117AbbLWKCD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Dec 2015 05:02:03 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 4F26310214E
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Dec 2015 11:02:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3C6E0DA86C
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Dec 2015 11:02:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 52717DA86C
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Dec 2015 11:01:59 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151223095347.GA5866@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 23, 2015 at 03:23:47PM +0530, Shivani Bhardwaj wrote:
> Add translation for helper module to nftables.
> 
> Examples:
> 
> $ sudo iptables-translate -A FORWARD -m helper --helper sip
> nft add rule ip filter FORWARD ct helper \"sip\" counter
> 
> $ sudo iptables-translate -A FORWARD -m helper ! --helper ftp
> nft add rule ip filter FORWARD ct helper != \"ftp\" counter
> 
> Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
> ---
>  extensions/libxt_helper.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/extensions/libxt_helper.c b/extensions/libxt_helper.c
> index c9f9435..5f1d8b1 100644
> --- a/extensions/libxt_helper.c
> +++ b/extensions/libxt_helper.c
> @@ -45,6 +45,19 @@ static void helper_save(const void *ip, const struct xt_entry_match *match)
>  	xtables_save_string(info->name);
>  }
>  
> +static int helper_xlate(const struct xt_entry_match *match,
> +			struct xt_buf *buf, int numeric)
> +{
> +	const struct xt_helper_info *info = (const void *)match->data;
> +
> +	xt_buf_add(buf, "ct helper");
> +
> +	xt_buf_add(buf, "%s \\\"%s\\\" ",
> +		   info->invert ? " !=" : "", info->name);

You can place this in one single call of xt_buf_add(), right?
