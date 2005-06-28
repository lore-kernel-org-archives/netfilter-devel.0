From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 2.6] ipt_CLUSTERIP: fix ARP mangling
Date: Tue, 28 Jun 2005 12:46:40 -0700 (PDT)
Message-ID: <20050628.124640.57169557.davem@davemloft.net>
References: <20050622122902.GI4551@obroa-skai.de.gnumonks.org>
	<20050622.124341.95064256.davem@davemloft.net>
	<20050628114330.GA16681@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20050628114330.GA16681@sunbeam.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

From: Harald Welte <laforge@netfilter.org>
Date: Tue, 28 Jun 2005 13:43:31 +0200

> please aplly the following fix, now merged with current net-2.6:

This one rejects too, and I'm going to fix up by hand for you,
but just so you know why:

> @@ -31,7 +31,7 @@
>  #include <linux/netfilter_ipv4/ip_conntrack.h>
>  #include <linux/netfilter_ipv4/lockhelp.h>
>  
> -#define CLUSTERIP_VERSION "0.6"
> +#define CLUSTERIP_VERSION "0.7"
>  
>  #define DEBUG_CLUSTERIP
>  

As I stated last time, all the lockhelp stuff has been totally
removed from the current 2.6.x tree by a set of patches
Patrick McHardy sent me last week right after 2.6.12 was
released.  Therefore, no netfilter files reference the
lockhelp.h header any longer, yet it appears in your patch.

Like I said, I'll fix this up by hand for you, but please try
to avoid this in the future.  Thanks.

While we're here, should this patch get submitted to stable@kernel.org
for 2.6.12.x submission?  If so, I'll take care of that for you.
