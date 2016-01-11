From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libip6t_hl: Add translation to nft
Date: Mon, 11 Jan 2016 19:59:12 +0100
Message-ID: <20160111185912.GB15830@salvia>
References: <20160107093924.GA6686@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52235 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933424AbcAKS71 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Jan 2016 13:59:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 79FFDE3A1A
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jan 2016 19:59:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 68E25DA861
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jan 2016 19:59:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5C74FDA552
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jan 2016 19:59:17 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160107093924.GA6686@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 07, 2016 at 03:09:24PM +0530, Shivani Bhardwaj wrote:
> Add translation for hop limit to nftables.
> 
> Examples:
> 
> $ sudo ip6tables-translate -t nat -A postrouting -m hl --hl-gt 3
> nft add rule ip6 nat postrouting ip6 hoplimit gt 3 counter
> 
> $ sudo ip6tables-translate -t nat -A postrouting -m hl ! --hl-eq 3
> nft add rule ip6 nat postrouting ip6 hoplimit != 3 counter
> 
> Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
> ---
>  extensions/libip6t_hl.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/extensions/libip6t_hl.c b/extensions/libip6t_hl.c
> index 3559db4..0e13df1 100644
> --- a/extensions/libip6t_hl.c
> +++ b/extensions/libip6t_hl.c
> @@ -97,6 +97,23 @@ static const struct xt_option_entry hl_opts[] = {
>  };
>  #undef s
>  
> +static int hl_xlate(const struct xt_entry_match *match,
> +		    struct xt_buf *buf, int numeric)
> +{
> +	static const char *const op[] = {
> +		[IP6T_HL_EQ] = "ip6 hoplimit",
> +		[IP6T_HL_NE] = "ip6 hoplimit !=",
> +		[IP6T_HL_LT] = "ip6 hoplimit lt",
> +		[IP6T_HL_GT] = "ip6 hoplimit gt" };

I'd suggest you use something like:

	static const char *const op[] = {
                [IP6T_HL_EQ] = "",
                [IP6T_HL_NE] = "!=",
                [IP6T_HL_LT] = "lt",
                [IP6T_HL_GT] = "gt"
        };

We can later on consolidate this code by providing a common function
from libxtables for everyone.

Thanks.
