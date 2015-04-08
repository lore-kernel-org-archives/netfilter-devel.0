From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Use stdlib uint* instead of u_int*
Date: Wed, 8 Apr 2015 19:54:04 +0200
Message-ID: <20150408175404.GA5146@salvia>
References: <1428098686-17843-1-git-send-email-nwmcsween@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Nathan McSween <nwmcsween@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57077 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753652AbbDHRty (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Apr 2015 13:49:54 -0400
Content-Disposition: inline
In-Reply-To: <1428098686-17843-1-git-send-email-nwmcsween@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 03, 2015 at 10:04:46PM +0000, Nathan McSween wrote:
[...]
> diff --git a/include/libnfnetlink/linux_nfnetlink.h b/include/libnfnetlink/linux_nfnetlink.h
> index 76a8550..7b843c6 100644
> --- a/include/libnfnetlink/linux_nfnetlink.h
> +++ b/include/libnfnetlink/linux_nfnetlink.h
> @@ -1,5 +1,6 @@
>  #ifndef _NFNETLINK_H
>  #define _NFNETLINK_H
> +#include <stdint.h>
>  #include <linux/types.h>
>  #include <libnfnetlink/linux_nfnetlink_compat.h>
>  
> @@ -25,9 +26,9 @@ enum nfnetlink_groups {
>  /* General form of address family dependent message.
>   */
>  struct nfgenmsg {
> -	u_int8_t  nfgen_family;		/* AF_xxx */
> -	u_int8_t  version;		/* nfnetlink version */
> -	u_int16_t    res_id;		/* resource id */
> +	uint8_t  nfgen_family;		/* AF_xxx */
> +	uint8_t  version;		/* nfnetlink version */
> +	uint16_t    res_id;		/* resource id */

This header file is a copy of what you can get from the Linux kernel
source tree. We shouldn't change this, instead you can refresh it.

>  };
>  
>  #define NFNETLINK_V0	0
> @@ -59,7 +60,7 @@ struct nfnl_callback
>  	int (*call)(struct sock *nl, struct sk_buff *skb, 
>  		struct nlmsghdr *nlh, struct nlattr *cda[]);
>  	const struct nla_policy *policy;	/* netlink attribute policy */
> -	const u_int16_t attr_count;		/* number of nlattr's */
> +	const uint16_t attr_count;		/* number of nlattr's */
>  };
>  
>  struct nfnetlink_subsystem
> @@ -76,7 +77,7 @@ extern int nfnetlink_subsys_unregister(const struct nfnetlink_subsystem *n);
>  extern int nfnetlink_has_listeners(unsigned int group);
>  extern int nfnetlink_send(struct sk_buff *skb, u32 pid, unsigned group, 
>  			  int echo);
> -extern int nfnetlink_unicast(struct sk_buff *skb, u_int32_t pid, int flags);
> +extern int nfnetlink_unicast(struct sk_buff *skb, uint32_t pid, int flags);
>  
>  #define MODULE_ALIAS_NFNL_SUBSYS(subsys) \
>  	MODULE_ALIAS("nfnetlink-subsys-" __stringify(subsys))
> diff --git a/include/libnfnetlink/linux_nfnetlink_compat.h b/include/libnfnetlink/linux_nfnetlink_compat.h
> index e145176..cd094fc 100644
> --- a/include/libnfnetlink/linux_nfnetlink_compat.h
> +++ b/include/libnfnetlink/linux_nfnetlink_compat.h

Same thing with this file.
