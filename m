From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH V3 1/2] Add revision field for xt_entry_target
Date: Thu, 26 Mar 2015 13:45:02 +0100
Message-ID: <20150326124502.GA5372@salvia>
References: <1427362410-9255-1-git-send-email-zhangcy@cn.fujitsu.com>
 <1427362410-9255-2-git-send-email-zhangcy@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Gao feng <gaofeng@cn.fujitsu.com>
To: Zhang Chunyu <zhangcy@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54015 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471AbbCZMlG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Mar 2015 08:41:06 -0400
Content-Disposition: inline
In-Reply-To: <1427362410-9255-2-git-send-email-zhangcy@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 26, 2015 at 05:33:29AM -0400, Zhang Chunyu wrote:
> ---
>  arptables.c                              | 2 ++
>  extensions/arpt_CLASSIFY.c               | 1 +
>  extensions/arpt_mangle.c                 | 1 +
>  extensions/arpt_standard.c               | 1 +
>  include/arptables.h                      | 6 ++++++
>  include/linux/netfilter_arp/arp_tables.h | 3 ++-
>  6 files changed, 13 insertions(+), 1 deletion(-)
>
[...] 
> diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
> index 0acda66..0bf2457 100644
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
> @@ -69,6 +69,7 @@ struct arpt_entry_target
>  
>  			/* Used by userspace */
>  			char name[ARPT_FUNCTION_MAXNAMELEN];
> +			u_int8_t revision;
>  		} user;
>  		struct {
>  			u_int16_t target_size;

Could you also resubmit the kernel patch to adds this? Please, no need
to resend the full userspace series, just send the kernel patch as a
follow up.
