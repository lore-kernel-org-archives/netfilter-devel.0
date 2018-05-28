From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next v16 5/8] sch_cake: Add NAT awareness to packet
 classifier
Date: Mon, 28 May 2018 21:51:01 +0200
Message-ID: <20180528195101.7mceghxngz5jhawa@salvia>
References: <152751762093.30935.15398977119837536494.stgit@alrua-kau>
 <152751766690.30935.18178441475189968162.stgit@alrua-kau>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netdev@vger.kernel.org, cake@lists.bufferbloat.net,
        netfilter-devel@vger.kernel.org
To: Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <152751766690.30935.18178441475189968162.stgit@alrua-kau>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, May 28, 2018 at 04:27:46PM +0200, Toke Høiland-Jørgensen wrote:
> When CAKE is deployed on a gateway that also performs NAT (which is a
> common deployment mode), the host fairness mechanism cannot distinguish
> internal hosts from each other, and so fails to work correctly.
> 
> To fix this, we add an optional NAT awareness mode, which will query the
> kernel conntrack mechanism to obtain the pre-NAT addresses for each packet
> and use that in the flow and host hashing.
> 
> When the shaper is enabled and the host is already performing NAT, the cost
> of this lookup is negligible. However, in unlimited mode with no NAT being
> performed, there is a significant CPU cost at higher bandwidths. For this
> reason, the feature is turned off by default.
> 
> Cc: netfilter-devel@vger.kernel.org
> Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
> ---
>  net/sched/sch_cake.c |   46 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
> 
> diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
> index 68ac908470f1..fecd9caac0cc 100644
> --- a/net/sched/sch_cake.c
> +++ b/net/sched/sch_cake.c
> @@ -71,6 +71,10 @@
>  #include <net/tcp.h>
>  #include <net/flow_dissector.h>
>  
> +#if IS_ENABLED(CONFIG_NF_CONNTRACK)
> +#include <net/netfilter/nf_conntrack_core.h>
> +#endif
> +
>  #define CAKE_SET_WAYS (8)
>  #define CAKE_MAX_TINS (8)
>  #define CAKE_QUEUES (1024)
> @@ -516,6 +520,29 @@ static bool cobalt_should_drop(struct cobalt_vars *vars,
>  	return drop;
>  }
>  
> +static void cake_update_flowkeys(struct flow_keys *keys,
> +				 const struct sk_buff *skb)
> +{
> +#if IS_ENABLED(CONFIG_NF_CONNTRACK)

I would remove the ifdef, not really needed, it will simplify things.

But I leave it to you to decide, this is not I deal breaker.
