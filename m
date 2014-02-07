From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/3] nft-arp: adds nft_arp_save_firewall
Date: Fri, 7 Feb 2014 19:27:18 +0100
Message-ID: <20140207182718.GA4853@localhost>
References: <1391693471-7591-1-git-send-email-giuseppelng@gmail.com>
 <1391693471-7591-3-git-send-email-giuseppelng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47657 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbaBGS1Y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Feb 2014 13:27:24 -0500
Content-Disposition: inline
In-Reply-To: <1391693471-7591-3-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Giuseppe,

On Thu, Feb 06, 2014 at 02:31:10PM +0100, Giuseppe Longo wrote:
> Adds nft_arp_save_firewall to arp family.
> (Avoids the segfault in xtables-events)
> 
> Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
> ---
>  iptables/nft-arp.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
> index 1710136..bbb168d 100644
> --- a/iptables/nft-arp.c
> +++ b/iptables/nft-arp.c
> @@ -570,6 +570,14 @@ after_devdst:
>  		fputc('\n', stdout);
>  }
>  
> +static void nft_arp_save_firewall(const void *data,
> +				   unsigned int format)
> +{
> +	const struct arpt_entry *fw = data;
> +
> +	return;
> +}

Please, rework patch 1/3 to make save_firewall option, ie. something
like:

        ...
        if (ops->save_firewall)
                ops->save_firewall(data, format);

Thus, you don't need this dummy function which is almost noop.
