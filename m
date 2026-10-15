Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E184DE72E;
	Thu, 15 Oct 2026 10:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792060451; cv=none; b=SYeosQgACvJ9H/Ds8EVjjvZWB4Drn5mVuOwKR7MyNWek8dFLxguDnC2NO8yx54vS4+cRDuxNsqSGy9G7l37/cLcXe4Fvx8i0ewl7kSR7L41M6Xjwa89M9Soqv5HpOSsHEaN7s+CgAbtp3scTehRqigBKIiL0YxXWJ3gIp1Ptip8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792060451; c=relaxed/simple;
	bh=FgnsOMEOpLggt2OAxaYpewug1WeX/1bfGz5YWdPS6lc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p5mrHr55i9PqM6RadgnyF4DjQkhDtJ8vL2EPsFIckOaeZsUsOW4en/oah3FBvxNi+5pusaQu0ljkFNW2eSI2eaRIjvtOHw3IVMshZxOFFjGxRrffplZuh+uDIZbmMc/2+YunlkezOMYMgc3k5pfSmjR+Zliuhxn+s3xmxBd2LQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=AlQUfA8d; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="AlQUfA8d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792060446;
	bh=sFsWX3/9CkrsineyJcm2hm88Q82IvS8jvib4/IvRAL0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AlQUfA8dLmT4IDkhK7MuY5/TPTeip+nxz/2NIkyuntPFfKq9RvyJVGQbhe5VtqHYu
	 kjCNwoxziCleDF4Pqw+0CjWu/YWZeU6ic3fR/EaO3/dnmlIrf/AMraUgzIGu9BxEOB
	 Qgfhl9T8TSPzwWSJVVDb68kYrMpbnTxC11DHFLZCljt4cKORR1f69vcosWKsmTn9N0
	 mUICdyeH9c3jlyE2X1qx6ot+JIpGrGwE20eEumHOyTJ+/dl9QbY/rMOWLI58VqOEqP
	 RxXxxi43/7SNuXWsovq7YMNl7hPKNC4iaw8BtnJD06Mh55mqesFpmgGixDvS571SZS
	 2RCMqI7P+EZmA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 0B76F60074;
	Thu, 15 Oct 2026 12:34:06 +0200 (CEST)
Date: Thu, 15 Oct 2026 12:34:03 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Julius Bairaktaris <julius@bairaktaris.de>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, kadlec@netfilter.org,
	phil@nwl.cc, horms@kernel.org, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	shuah@kernel.org, razor@blackwall.org, idosch@nvidia.com,
	ericwouds@gmail.com, dqfext@gmail.com, netdev@vger.kernel.org,
	coreteam@netfilter.org, linux-kselftest@vger.kernel.org,
	bridge@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH nf-next v7 1/2] netfilter: flowtable: tear down direct
 xmit flows when the fdb entry moves
Message-ID: <atCsGx2IRecQNK3r@chamomile>
References: <20261014235628.197976-1-julius@bairaktaris.de>
 <20261014235628.197976-2-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261014235628.197976-2-julius@bairaktaris.de>

Hi,

On Thu, Oct 15, 2026 at 01:56:26AM +0200, Julius Bairaktaris wrote:
> A direct xmit flow stores the bridge port the fdb resolved when the flow
> was created. When the host moves to another port of the bridge, the flow
> keeps sending to the old port, and packets from the other side keep it
> from timing out. A hardware offloaded flow behaves the same.
> 
> The gc now asks the bridge, through nf_br_utils_hook, which port the fdb
> entry points to, and tears the flow down when it is another port. The
> hook keeps the flowtable independent of the bridge module. An entry that
> aged out leaves the flow alone, because offloaded packets do not refresh
> it.
> 
> The bridge port and the vid of the fdb lookup are saved when the flow is
> created. The port is not out.ifidx when it is a vlan device, and the vid
> is not in the encap stack for an untagged port of a vlan_filtering
> bridge.
> 
> Co-developed-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Assisted-by: Claude:claude-opus-5-5

I did not use this LLM assistance for my patch and I show as
co-developer here ;-)

> Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
> ---
>  include/linux/netfilter.h             |  8 ++++++
>  include/net/netfilter/nf_flow_table.h |  4 +++
>  net/bridge/Makefile                   |  2 ++
>  net/bridge/br.c                       |  2 ++
>  net/bridge/br_nf_utils.c              | 40 +++++++++++++++++++++++++++
>  net/bridge/br_private.h               | 13 +++++++++
>  net/netfilter/core.c                  |  3 ++
>  net/netfilter/nf_flow_table_core.c    | 27 ++++++++++++++++++
>  net/netfilter/nf_flow_table_path.c    |  9 ++++++
>  9 files changed, 108 insertions(+)
>  create mode 100644 net/bridge/br_nf_utils.c
> 
> diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
> index e99afc1414cd3..b79626137579f 100644
> --- a/include/linux/netfilter.h
> +++ b/include/linux/netfilter.h
> @@ -67,6 +67,14 @@ static inline void nf_inet_addr_mask(const union nf_inet_addr *a1,
>  #endif
>  }
>  
> +/* The bridge fills this in for the flowtable, which must not depend on it. */

This comment is not needed? LLM likes to bloat code with unnecessary comments.

Comments are last resort for something you cannot get via git
annotate, to highlight something is not really obvious in the code.

> +struct nf_br_utils {
> +	bool (*fdb_moved)(struct net *net, int ifindex,
> +			  const unsigned char *addr, u16 vid);

Why LLM decided to rename this function? :-)

> +};
> +
> +extern const struct nf_br_utils __rcu *nf_br_utils_hook;
> +
>  int netfilter_init(void);
>  
>  struct sk_buff;
> diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
> index 5b611efaa3cd1..fb3786220a652 100644
> --- a/include/net/netfilter/nf_flow_table.h
> +++ b/include/net/netfilter/nf_flow_table.h
> @@ -164,6 +164,8 @@ struct flow_offload_tuple {
>  		};
>  		struct {
>  			u32		ifidx;
> +			u32		bridge_ifidx;

I think bridge_ifidx is not needed here and I am not sure we can cache
this value? We might not track of this br device on events, we could
end up with a stale index here? I think my approach searching for
upper is safer?

Plus, we don't need the extra memory in bridge_ifidx.

> +			u16		bridge_vid;

Why do we need bridge_vid? See below to explain an alternative.

>  			u8		h_source[ETH_ALEN];
>  			u8		h_dest[ETH_ALEN];
>  		} out;
> @@ -232,6 +234,8 @@ struct nf_flow_route {
>  		struct {
>  			u32			ifindex;
>  			u32			hw_ifindex;
> +			u32			bridge_ifindex;
> +			u16			bridge_vid;
>  			u8			h_source[ETH_ALEN];
>  			u8			h_dest[ETH_ALEN];
>  			u8			needs_gso_segment:1;
> diff --git a/net/bridge/Makefile b/net/bridge/Makefile
> index 1203dc19e15c9..fc53c332246de 100644
> --- a/net/bridge/Makefile
> +++ b/net/bridge/Makefile
> @@ -14,6 +14,8 @@ bridge-$(CONFIG_SYSFS) += br_sysfs_if.o br_sysfs_br.o
>  
>  bridge-$(subst m,y,$(CONFIG_BRIDGE_NETFILTER)) += br_nf_core.o
>  
> +bridge-$(subst m,y,$(CONFIG_NF_FLOW_TABLE)) += br_nf_utils.o

Yes, this can be compiled conditionally.

> +
>  br_netfilter-y := br_netfilter_hooks.o
>  br_netfilter-$(subst m,y,$(CONFIG_IPV6)) += br_netfilter_ipv6.o
>  obj-$(CONFIG_BRIDGE_NETFILTER) += br_netfilter.o
> diff --git a/net/bridge/br.c b/net/bridge/br.c
> index d9a39ff98868d..c0618ef6dac5c 100644
> --- a/net/bridge/br.c
> +++ b/net/bridge/br.c
> @@ -458,6 +458,7 @@ static int __init br_init(void)
>  		goto err_out6;
>  
>  	brioctl_set(br_ioctl_stub);
> +	br_nf_utils_init();
>  
>  #if IS_MODULE(CONFIG_BRIDGE_NETFILTER)
>  	pr_info("bridge: filtering via arp/ip/ip6tables is no longer available "
> @@ -486,6 +487,7 @@ static int __init br_init(void)
>  
>  static void __exit br_deinit(void)
>  {
> +	br_nf_utils_fini();
>  	stp_proto_unregister(&br_stp_proto);
>  	br_netlink_fini();
>  	unregister_switchdev_blocking_notifier(&br_switchdev_blocking_notifier);
> diff --git a/net/bridge/br_nf_utils.c b/net/bridge/br_nf_utils.c
> new file mode 100644
> index 0000000000000..dac08ff6346d6
> --- /dev/null
> +++ b/net/bridge/br_nf_utils.c
> @@ -0,0 +1,40 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#include <linux/netdevice.h>
> +#include <linux/netfilter.h>
> +
> +#include "br_private.h"
> +
> +/* True if the bridge now sends to @addr through another port than @ifindex.
> + * An entry that aged out is not a move: packets the flowtable forwards do
> + * not pass the bridge, so they do not refresh it. Called under RCU.
> + */
> +static bool nf_br_fdb_moved(struct net *net, int ifindex,
> +			    const unsigned char *addr, u16 vid)
> +{
> +	const struct net_bridge_fdb_entry *f;
> +	const struct net_bridge_port *p;
> +	struct net_device *dev;
> +
> +	dev = dev_get_by_index_rcu(net, ifindex);
> +	p = dev ? br_port_get_check_rcu(dev) : NULL;
> +	if (!p)
> +		return true;
> +
> +	f = br_fdb_find_rcu(p->br, addr, vid);
> +
> +	return f && br_fdb_dst_port(f) != p;
> +}
> +
> +static const struct nf_br_utils nf_br_utils = {
> +	.fdb_moved	= nf_br_fdb_moved,
> +};
> +
> +void br_nf_utils_init(void)
> +{
> +	rcu_assign_pointer(nf_br_utils_hook, &nf_br_utils);
> +}
> +
> +void br_nf_utils_fini(void)
> +{
> +	RCU_INIT_POINTER(nf_br_utils_hook, NULL);
> +}
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index 05921192ebda1..22c9e17d76175 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -2164,6 +2164,19 @@ struct nf_br_ops {
>  };
>  extern const struct nf_br_ops __rcu *nf_br_ops;
>  
> +#if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
> +void br_nf_utils_init(void);
> +void br_nf_utils_fini(void);
> +#else
> +static inline void br_nf_utils_init(void)
> +{
> +}
> +
> +static inline void br_nf_utils_fini(void)
> +{
> +}
> +#endif
> +
>  /* br_netfilter.c */
>  #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
>  int br_nf_core_init(void);
> diff --git a/net/netfilter/core.c b/net/netfilter/core.c
> index 940dea2663e95..914f0934f6da3 100644
> --- a/net/netfilter/core.c
> +++ b/net/netfilter/core.c
> @@ -814,6 +814,9 @@ static struct pernet_operations netfilter_net_ops = {
>  	.exit = netfilter_net_exit,
>  };
>  
> +const struct nf_br_utils __rcu *nf_br_utils_hook;
> +EXPORT_SYMBOL_GPL(nf_br_utils_hook);
> +
>  int __init netfilter_init(void)
>  {
>  	int ret;
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index 0d72dc8ae47a1..5f49e1f8e7c80 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -139,6 +139,9 @@ static int flow_offload_fill_route(struct flow_offload *flow,
>  		memcpy(flow_tuple->out.h_source, route->tuple[dir].out.h_source,
>  		       ETH_ALEN);
>  		flow_tuple->out.ifidx = route->tuple[dir].out.ifindex;
> +		flow_tuple->out.bridge_ifidx =
> +			route->tuple[dir].out.bridge_ifindex;
> +		flow_tuple->out.bridge_vid = route->tuple[dir].out.bridge_vid;
>  		break;
>  	case FLOW_OFFLOAD_XMIT_XFRM:
>  	case FLOW_OFFLOAD_XMIT_NEIGH:
> @@ -572,9 +575,31 @@ static void nf_flow_table_extend_ct_timeout(struct nf_conn *ct)
>  	nf_ct_put(ct);
>  }
>  
> +static bool nf_flow_bridge_port_moved(struct net *net,
> +				      const struct flow_offload_tuple *tuple)
> +{
> +	const struct nf_br_utils *br_utils;
> +	bool moved = false;
> +
> +	if (tuple->xmit_type != FLOW_OFFLOAD_XMIT_DIRECT ||
> +	    !tuple->out.bridge_ifidx)
> +		return false;
> +
> +	rcu_read_lock();

Yes, my rcu_read_lock() was in the wrong spot indeed, this is fine.

> +	br_utils = rcu_dereference(nf_br_utils_hook);
> +	if (br_utils)
> +		moved = br_utils->fdb_moved(net, tuple->out.bridge_ifidx,
> +					    tuple->out.h_dest,
> +					    tuple->out.bridge_vid);
> +	rcu_read_unlock();
> +
> +	return moved;
> +}
> +
>  static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
>  				    struct flow_offload *flow, void *data)
>  {
> +	struct net *net = read_pnet(&flow_table->net);
>  	bool teardown;
>  
>  	if (test_bit(NF_FLOW_PENDING, &flow->flags))
> @@ -586,6 +611,8 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
>  	    nf_ct_is_dying(flow->ct) ||
>  	    !nf_flow_dst_check(&flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple) ||
>  	    !nf_flow_dst_check(&flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple) ||
> +	    nf_flow_bridge_port_moved(net, &flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple) ||
> +	    nf_flow_bridge_port_moved(net, &flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple) ||

Why LLM moved this away from nf_flow_dst_check()?

My intention was to consolidate this in a single dst_check function,
because this is similar to what we do with dst_check(). While fdb does
not provide similar API, from a semantic POV is doing the same:
Validate that this destination is still valid.

>  	    nf_flow_custom_gc(flow_table, flow)) {
>  		flow_offload_teardown(flow);
>  		teardown = true;
> diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
> index d90013685bf12..f1efe5095f07b 100644
> --- a/net/netfilter/nf_flow_table_path.c
> +++ b/net/netfilter/nf_flow_table_path.c
> @@ -89,6 +89,8 @@ struct nft_forward_info {
>  		__be16	proto;
>  	} encap[NF_FLOW_TABLE_ENCAP_MAX];
>  	u8 num_encaps;
> +	u32 bridge_ifidx;
> +	u16 bridge_vid;
>  	struct flow_offload_tunnel tun;
>  	struct dst_entry *tun_dst;
>  	u8 num_tuns;
> @@ -183,6 +185,11 @@ static int nft_dev_path_info(struct net_device_path_stack *stack,
>  			case DEV_PATH_BR_VLAN_KEEP:
>  				break;
>  			}
> +			/* dev_fill_forward_path() adds the bridge port after
> +			 * the bridge.
> +			 */
> +			info->bridge_ifidx = stack->path[i + 1].dev->ifindex;
> +			info->bridge_vid = path->bridge.vlan_id;

Why do we need this new bridge_vid field? This is stored in info->encaps.

                case DEV_PATH_BR_VLAN_TAG:
                                if (info->num_encaps >= NF_FLOW_TABLE_ENCAP_MAX)
                                        goto err_out;
 
                                info->encap[info->num_encaps].id = path->bridge.vlan_id;

My understanding is that this is need to know if this vlan coming from
bridge vlan filtering (not vlan device), but it is possible to track
this in a local variable while walking over the path stack?

>  			info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
>  			break;
>  		default:
> @@ -260,6 +267,8 @@ static int nft_dev_forward_path(const struct nft_pktinfo *pkt,
>  	if (info.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT) {
>  		memcpy(route->tuple[dir].out.h_source, info.h_source, ETH_ALEN);
>  		memcpy(route->tuple[dir].out.h_dest, info.h_dest, ETH_ALEN);
> +		route->tuple[dir].out.bridge_ifindex = info.bridge_ifidx;
> +		route->tuple[dir].out.bridge_vid = info.bridge_vid;
>  		route->tuple[dir].xmit_type = info.xmit_type;
>  	}
>  	route->tuple[dir].out.needs_gso_segment = info.needs_gso_segment;
> -- 
> 2.53.0
> 
