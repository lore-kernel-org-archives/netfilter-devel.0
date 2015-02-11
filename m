From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3] Add revision field for xt_entry_target
Date: Wed, 11 Feb 2015 16:52:27 +0100
Message-ID: <20150211155227.GA7790@salvia>
References: <1423207590-13423-1-git-send-email-gaofeng@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44176 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848AbbBKPtS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2015 10:49:18 -0500
Content-Disposition: inline
In-Reply-To: <1423207590-13423-1-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Feb 06, 2015 at 03:26:28PM +0800, Gao feng wrote:
> This filed is useful if we want to add TARGET which
> has revision for arptables rules.
> 
> Also make sure xt_entry_target is consistent with
> the definition in kernel.
> 
> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
> ---
>  include/linux/netfilter_arp/arp_tables.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
> index 0acda66..ccf8cd0 100644
> --- a/include/linux/netfilter_arp/arp_tables.h
> +++ b/include/linux/netfilter_arp/arp_tables.h
> @@ -19,7 +19,7 @@
>  
>  #include <linux/netfilter_arp.h>
>  
> -#define ARPT_FUNCTION_MAXNAMELEN 30
> +#define ARPT_FUNCTION_MAXNAMELEN 29
>  #define ARPT_TABLE_MAXNAMELEN 32
>  
>  #define ARPT_DEV_ADDR_LEN_MAX 16
> @@ -69,6 +69,8 @@ struct arpt_entry_target
>  
>  			/* Used by userspace */
>  			char name[ARPT_FUNCTION_MAXNAMELEN];
> +
> +			u_int8_t revision;

This structure is not exposed to userspace and I don't find any client
of it in this code:

include/uapi/linux/netfilter_arp/arp_tables.h:#define arpt_entry_target xt_entry_target

and arp_tables uses xt_entry_target all the time.

I guess you can get rid of this dead code. Then, update the cached
copy and also include x_tables.h definition in the arptables tree.

>  		} user;
>  		struct {
>  			u_int16_t target_size;
> -- 
> 2.1.0
> 
