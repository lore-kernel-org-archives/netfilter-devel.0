From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: Re: [PATCH nf-next v2 1/4] netfilter: nf_conntrack_tuple_common.h:
 fix #include
Date: Tue, 15 Nov 2016 21:46:49 +0200
Message-ID: <20161115194649.GJ8342@lakka.kapsi.fi>
References: <cover.1479217169.git.dcaratti@redhat.com>
 <c2ac27f064bb641d331abdacdff4ac5e6df83915.1479217169.git.dcaratti@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Davide Caratti <dcaratti@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44565 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751496AbcKOTrT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Nov 2016 14:47:19 -0500
Content-Disposition: inline
In-Reply-To: <c2ac27f064bb641d331abdacdff4ac5e6df83915.1479217169.git.dcaratti@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 15, 2016 at 03:08:24PM +0100, Davide Caratti wrote:
> To allow usage of enum ip_conntrack_dir in include/net/netns/conntrack.h,
> this patch encloses #include <linux/netfilter.h> in a #ifndef __KERNEL__
> directive, so that compiler errors caused by unwanted inclusion of
> include/linux/netfilter.h are avoided.
> In addition, #include <linux/netfilter/nf_conntrack_common.h> line has
> been added to resolve correctly CTINFO2DIR macro.
> 
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Acked-by: Mikko Rapeli <mikko.rapeli@iki.fi>

-Mikko

> ---
>  include/uapi/linux/netfilter/nf_conntrack_tuple_common.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/include/uapi/linux/netfilter/nf_conntrack_tuple_common.h b/include/uapi/linux/netfilter/nf_conntrack_tuple_common.h
> index a9c3834..526b424 100644
> --- a/include/uapi/linux/netfilter/nf_conntrack_tuple_common.h
> +++ b/include/uapi/linux/netfilter/nf_conntrack_tuple_common.h
> @@ -2,7 +2,10 @@
>  #define _NF_CONNTRACK_TUPLE_COMMON_H
>  
>  #include <linux/types.h>
> +#ifndef __KERNEL__
>  #include <linux/netfilter.h>
> +#endif
> +#include <linux/netfilter/nf_conntrack_common.h> /* IP_CT_IS_REPLY */
>  
>  enum ip_conntrack_dir {
>  	IP_CT_DIR_ORIGINAL,
> -- 
> 2.7.4
> 
