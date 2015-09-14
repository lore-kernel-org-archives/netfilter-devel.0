From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] added missing icmpv6 dest-unreach codes
Date: Mon, 14 Sep 2015 18:26:33 +0200
Message-ID: <20150914162633.GA11905@salvia>
References: <1440066991-10979-1-git-send-email-andi@geekosphere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Andreas Herz <andi@geekosphere.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48291 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbbINQTy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Sep 2015 12:19:54 -0400
Content-Disposition: inline
In-Reply-To: <1440066991-10979-1-git-send-email-andi@geekosphere.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I'm going to apply this. Thanks.

Unlike other pending changes that are targeted to 4.3-rc, this doesn't
require any kernel update.

On Thu, Aug 20, 2015 at 12:36:31PM +0200, Andreas Herz wrote:
> Signed-off-by: Andreas Herz <andi@geekosphere.org>
> ---
>  extensions/libip6t_icmp6.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/extensions/libip6t_icmp6.c b/extensions/libip6t_icmp6.c
> index 68b940b..e183ce6 100644
> --- a/extensions/libip6t_icmp6.c
> +++ b/extensions/libip6t_icmp6.c
> @@ -19,8 +19,11 @@ static const struct icmpv6_names icmpv6_codes[] = {
>  	{ "destination-unreachable", 1, 0, 0xFF },
>  	{   "no-route", 1, 0, 0 },
>  	{   "communication-prohibited", 1, 1, 1 },
> +	{   "beyond-scope", 1, 2, 2 },
>  	{   "address-unreachable", 1, 3, 3 },
>  	{   "port-unreachable", 1, 4, 4 },
> +	{   "failed-policy", 1, 5, 5 },
> +	{   "reject-route", 1, 6, 6 },
>  
>  	{ "packet-too-big", 2, 0, 0xFF },
>  
> -- 
> 2.4.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
