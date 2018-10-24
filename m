From: =?utf-8?B?TcOhdMOp?= Eckl <ecklm94@gmail.com>
Subject: Re: [PATCH] netfilter: bridge: define INT_MIN & INT_MAX in userspace
Date: Wed, 24 Oct 2018 21:17:45 +0200
Message-ID: <20181024191745.jboas22he7ot7utd@sch.bme.hu>
References: <20181024115403.3938-1-jslaby@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
To: Jiri Slaby <jslaby@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181024115403.3938-1-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Oct 24, 2018 at 01:54:03PM +0200, Jiri Slaby wrote:
> With 4.19, programs like ebtables fail to build when they include
> "linux/netfilter_bridge.h". It is caused by commit 94276fa8a2a4 which
> added a use of INT_MIN and INT_MAX to the header:
> : In file included from /usr/include/linux/netfilter_bridge/ebtables.h:18,
> :                  from include/ebtables_u.h:28,
> :                  from communication.c:23:
> : /usr/include/linux/netfilter_bridge.h:30:20: error: 'INT_MIN' undeclared here (not in a function)
> :   NF_BR_PRI_FIRST = INT_MIN,
> :                     ^~~~~~~
> 
> Define these constants by including "limits.h" when !__KERNEL__ (the
> same way as for other netfilter_* headers).

Indeed I didn't think of this solution.

Thanks for the fix Jiri!

> 
> Fixes: 94276fa8a2a4 ("netfilter: bridge: Expose nf_tables bridge hook priorities through uapi")
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Máté Eckl <ecklm94@gmail.com>
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Máté Eckl <ecklm94@gmail.com>

> ---
>  include/uapi/linux/netfilter_bridge.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/include/uapi/linux/netfilter_bridge.h b/include/uapi/linux/netfilter_bridge.h
> index 156ccd089df1..1610fdbab98d 100644
> --- a/include/uapi/linux/netfilter_bridge.h
> +++ b/include/uapi/linux/netfilter_bridge.h
> @@ -11,6 +11,10 @@
>  #include <linux/if_vlan.h>
>  #include <linux/if_pppox.h>
>  
> +#ifndef __KERNEL__
> +#include <limits.h> /* for INT_MIN, INT_MAX */
> +#endif
> +
>  /* Bridge Hooks */
>  /* After promisc drops, checksum checks. */
>  #define NF_BR_PRE_ROUTING	0
> -- 
> 2.19.1
> 
