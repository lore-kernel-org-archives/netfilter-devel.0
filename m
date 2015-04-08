From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [kernel PATCH] uapi: ebtables: don't include linux/if.h
Date: Wed, 8 Apr 2015 19:59:40 +0200
Message-ID: <20150408175940.GA5358@salvia>
References: <20150408174140.25208.67942.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57815 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050AbbDHRza (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Apr 2015 13:55:30 -0400
Content-Disposition: inline
In-Reply-To: <20150408174140.25208.67942.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 08, 2015 at 07:41:40PM +0200, Arturo Borrero Gonzalez wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> linux/if.h creates conflicts in userspace with net/if.h
> 
> By using it here we force userspace to use linux/if.h while
> net/if.h may be needed.

I'm going to add here that:

include/linux/netfilter_ipv4/ip_tables.h and
include/linux/netfilter_ipv6/ip6_tables.h

don't include linux/if.h and they also refer to IFNAMSIZ, so they are
expecting userspace to include use net/if.h from the client program.

This has been causing us problems in the xt over nft layer.

If nobody objects, I'll push this to nf-next.

> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  include/linux/netfilter_bridge/ebtables.h      |    3 ++-
>  include/uapi/linux/netfilter_bridge/ebtables.h |    2 --
>  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
> index 34e7a2b..f1bd396 100644
> --- a/include/linux/netfilter_bridge/ebtables.h
> +++ b/include/linux/netfilter_bridge/ebtables.h
> @@ -12,9 +12,10 @@
>  #ifndef __LINUX_BRIDGE_EFF_H
>  #define __LINUX_BRIDGE_EFF_H
>  
> +#include <linux/if.h>
> +#include <linux/if_ether.h>
>  #include <uapi/linux/netfilter_bridge/ebtables.h>
>  
> -
>  /* return values for match() functions */
>  #define EBT_MATCH 0
>  #define EBT_NOMATCH 1
> diff --git a/include/uapi/linux/netfilter_bridge/ebtables.h b/include/uapi/linux/netfilter_bridge/ebtables.h
> index ba99336..773dfe8 100644
> --- a/include/uapi/linux/netfilter_bridge/ebtables.h
> +++ b/include/uapi/linux/netfilter_bridge/ebtables.h
> @@ -12,9 +12,7 @@
>  
>  #ifndef _UAPI__LINUX_BRIDGE_EFF_H
>  #define _UAPI__LINUX_BRIDGE_EFF_H
> -#include <linux/if.h>
>  #include <linux/netfilter_bridge.h>
> -#include <linux/if_ether.h>
>  
>  #define EBT_TABLE_MAXNAMELEN 32
>  #define EBT_CHAIN_MAXNAMELEN EBT_TABLE_MAXNAMELEN
> 
