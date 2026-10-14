Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB05E2D6E5A
	for <netfilter-devel@vger.kernel.org>; Wed, 14 Oct 2026 22:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792015288; cv=pass; b=h5HW0/3zjmR4ozxtmEve2YxQAMit3/NGbTP3gUbcpVDAd9p+arj5CMlq8ic1DxJYyMY5vDqvw5ta8zYt2YKvYoIpn/vVnddt/lgX8Y5Osi8jzO2pvmWjKPfP9bKEtMK70mXaZk3+2jFg3aZKkDN3tnYYg99JFBYuOwNOhqBWL/U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792015288; c=relaxed/simple;
	bh=mx+3ys5niIWvL5NGPyojhYaCANK+2gf9ETUnvg3LgJA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FdttmSaVEYnnStPZnrRCCT7wmISk4k0YeyXzdi5izquoyFD5RtwPakbrwIq4uGsaefyTda22HDwPak0hqC86KvcwEonCISJhfg5+tCN6W+FcfwG8ylvYalWo50ZbcNvGqx/JtZwOPl8hFoEbDa2i9JD+d2HXlbzZHQSnzzUvAWQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=bPzaK/cQ; arc=pass smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="bPzaK/cQ"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-8ab43af5e97so46186167b3.1
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Oct 2026 15:01:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792015286; cv=none;
        d=google.com; s=arc-20260327;
        b=ZnUPxZ4ZFzg8anVeuxvYie+bDcrgAjQqUX8++88a7IeLOq/zHndVozWGtIAyfHqgAG
         +4r9wg1PpbF3nghzY0qRAPWPgZQZyRfj6kKPNC0ltb+W+5rViRncQKcv2dKqKvNPiBaf
         p5awUP3Km/ccCmRGqU2Zunb/qEFUglaTuewiKJU8vVb+B5iqCTlriZK4HzsyYk8tWEOC
         SiiqWQflyEGUPHycrt7WDGFV9bFvVxvz9WGe6C7l6zppqwchiOE7nrSHom2MXA+0AM0H
         f5MZKJp1pGSP2Y2PApskzdhyQoWCb+DOkIuDOxVYq3+TcjlQNUzomkRmFdc5I+GOUgiJ
         gpow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=SpDhQbB08eAcmwBRkYLQEZSYWuBZ/TSuxqdWq7xmoVY=;
        fh=bt3K3yphR/jVMprO1+FDkGu990hDTewT/Q8eJcmvC8Q=;
        b=NLode1QjG63QBqbfjheUiXSyRsjTfS+U7OV4gcaQls/XdBqibzj2lGDtiJFNH4r3O6
         ekwi/Z6hS3QycpC38pdYa9+xyOR30Ih4LDACTDKWdv5vSTOa5zQZhKTzaSlZw94dOnaf
         E6NQNAOLdxTN0X1ulnGwRDaYATJ+EEsbbQ5q/aatu2kT5auxcXhL9Kwk+awQY64AS7Ga
         lodUCFZ4FzeTEktf+2VIgWA+x0xj/wIsMqQt5QVoo7NBh0NS5Qu8tAodogT6PQKmuiZx
         HxNAYCHu7bpAy6Rq74YZF9YpXoSBa6XQGEBIdR3zWndE5kaMHE9KcijTK57NKZ72INrZ
         oWNA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792015286; x=1792620086; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SpDhQbB08eAcmwBRkYLQEZSYWuBZ/TSuxqdWq7xmoVY=;
        b=bPzaK/cQmSlbhltfR+S7otAz9MdUAxMn3GExk3Z2eqseMEeGILgtUeS0J4HpFWWxFy
         eIhy/RMm+aw1/MhzEtviza+/KHRzy04WxGy1BC+t2zLiGI6OjZQVolVU2Quy7fOS6p0U
         sc/QEadCCf6KEhiNrpfK6FURIsqGRCVbigtBHXoY5oUp7e2kmuptwLxKCX0ylMpFh971
         ttLMla5Wy4qzUUGq5D6nIiUDlpvWywkIS7wApZKGz/KYUOctEcztO1eveqcrdx065rOy
         SBlFCaPVVfYtvxFrI0XmTt4J6dzyjmilUH+5ATRJm7SuDEtQXFBADIj02aNul8BDiv5g
         ph5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792015286; x=1792620086;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=SpDhQbB08eAcmwBRkYLQEZSYWuBZ/TSuxqdWq7xmoVY=;
        b=i1rQL0FRrU9REoEggfyS/UgT0mlI5moqfYU3aLyokG7+C7gqsavuXkAExmpuEIe8g8
         LPfQ6JUxsEWHJZTFG4X1JNpBO6DsjSEnmiP1nzYZpSHsVLhPmcF1rWGnCM8pTkCN6MQ0
         HNJ2xCCP0pAnktGFom9g22B8m5gZHlyRH8cn1n59/Xiuu+6LjjZamfW3EwIDT8Yr161+
         ppJLjEUWhWo7mw3zinII16mtF7RYMVLge5uxnk195GfBC1r6PBGHpe2HtcOY6SAiGg2p
         rsDoGTIdpzlAJKm6CA+/ZQTYxBpAKUncQGbuN6wGlUINrrlevnu0JzN9EsmTNCd2iQv7
         C0Vg==
X-Gm-Message-State: AFq9FYLIPYZ0VLIZUrmY4cdsaq1KArH2Q0rM9rh7y3KC1H7t0hKuDglv
	+UdlS/xdpoA4xTtCcxCjHsmj2uyGx+6ufbFrQgywGLImghLJ1KqINMv8IfRTyH81Kj1VEu8krXx
	dnIPTsMNm5aFK9azZJaGfg5UGTvEHETA+TWxp3/0h
X-Gm-Gg: AYBFou372axLCy6xhXq46/kl+GCie7kgNvyGempypdyZDl6oEXrbo11HeJ4PzrKmgX/
	Z7gw9BlRPlUlu8GgQn2FBahwMcZrQtrbQ5IvC2ctXpU1Gx9LjNnnJC6DiF01wKwr21Fl2AI0apN
	bMg1cy+X0hhrd3rTnmanOmQFb/l+L8HSuhIZ0Xba+3S84RrvMru9BJsbamn4sch6vI9Ikhg6uCl
	0X7xqBlgfzLdKyh1PE4+PvDPD4ED69TqqBkj9z//aKRPs1IXIpNR8hpv8TGJHk41jqSGAMP9zbc
	VCNZvCNImNKfE/dikTRt2gKBAwXrp0N7t3E7sBOl+osFYQVHk/MuAhSw1YrCPvY8LxGgZ5Judy3
	tXu75/zAvOXkpt5ro07Q87dv7G8VSu+Vsbb8ttunELWJURFGe3D6IuVAn47WoUGxW00oxZOV48w
	lpqXdVJ5dgvozcl30E4b7BdMRKg08gnQV0MpQY2SYVGMTKnWzprU+MnQlyouBUJCF4ZOUJYiXgy
	rt4lkLjKMNrPzFS0L5xP2P0IVXwNRl6UlveI32Ol2Urj32oZxbkxoY4STv+DEiPOqzir37rRG1o
	WyzDjWqsf5LCQA==
X-Received: by 2002:a05:690c:7107:b0:8aa:e4e7:c5a with SMTP id
 00721157ae682-8b07d21d2e4mr60218397b3.5.1792015284142; Wed, 14 Oct 2026
 15:01:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261014210256.1573072-1-pablo@netfilter.org>
In-Reply-To: <20261014210256.1573072-1-pablo@netfilter.org>
From: Julius Bairaktaris <julius@bairaktaris.de>
Date: Wed, 14 Oct 2026 22:00:47 +0000
X-Gm-Features: AclHuK_gQpSpPk9biIM9Zh4MNWvVaf5VgAZooKtUtH9HMLw3yveygOUhJkjxa3s
Message-ID: <CAC1t37+TzhPP1Q1HZVQUw=vLUxsHwpmyFWHyQWyGyOJnvSUKBQ@mail.gmail.com>
Subject: Re: [PATCH nf-next] netfilter: flowtable: teardown flow reaching
 bridge port on fdb updates
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, ericwouds@gmail.com, razor@blackwall.org
Content-Type: text/plain; charset="UTF-8"

Hi Pablo,

First of all, thank you so much for taking on this issue.

On Wed, Oct 14, 2026 at 11:02:56PM +0200, Pablo Neira Ayuso wrote:
> This is an alternative to:
> [PATCH nf-next v5 2/3] netfilter: flowtable: teardown direct xmit flows when the fdb entry moves

There is a v6 of that series. It dropped the switchdev notifier and,
like your patch, checks the fdb from the gc:

https://lore.kernel.org/netfilter-devel/20261004171605.3544792-1-julius@bairaktaris.de/

I ran its selftest on your patch, a few issues:

> + f = br_fdb_find_rcu(br, addr, vid);
> + if (!f)
> + goto out;

Offloaded packets do not refresh the fdb entry, so the flow is torn
down every time the entry ages out. The "age" case in the v6 selftest
fails with this.

> + valid = br_utils->fdb_valid_dst(net, this_tuple->out.ifidx,

out.ifidx is the lower device when the bridge port is a vlan device,
so this is never valid. And the vid from encap[0] is 0 on a
vlan_filtering bridge with untagged ports. Both cases tear the flow
down on every gc run, 9 times in 10 seconds here.

> + dst = READ_ONCE(f->dst);

This does not build on nf-next after a39c339fd6c5, f->dst is a struct
net_bridge_dst now. br_nf_utils.o also fails to link with
CONFIG_NETFILTER=n.

Your version is smaller in the tuple and cheaper in the gc, though.
I can send a v7 that takes the fdb lookup from yours and keeps the
fixes above, if that works for you.

Julius


Am Mi., 14. Okt. 2026 um 21:03 Uhr schrieb Pablo Neira Ayuso
<pablo@netfilter.org>:
>
> The flowtable GC already checks if dst_entries are still valid, but such
> check is lacking for fdb entries when the bypass reaches a bridge port.
> This is an issue in roaming scenarios when the bridge is used.
>
> Eric Woudstra describes the problem:
>
> "When the host moves to another port of the same bridge, for example a
> station roaming to another access point, the bridge updates its fdb
> entry and the flow keeps sending to the old port. Packets from the other
> end keep hitting the flow and refresh it, so it does not expire while
> the sender retransmits. A hardware offloaded flow behaves the same, and
> none of its packets reaches the software path."
>
> One possibility to address this issue is to subscribe to
> SWITCHDEV_FDB_DEL_TO_DEVICE event notifications, however, this requires
> iterating over the whole flowtable whenever a fdb entry is removed.
>
> This patch adds the infrastructure to check if the fdb entry is stale,
> so the flowtable GC can collect tear it down to set up the flowtable
> bypass again with a fresh fdb entry.
>
> Reported-by: Eric Woudstra <ericwouds@gmail.com>
> Reported-by: Julius Bairaktaris <julius@bairaktaris.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> +Cc'ing bridge maintainer, since this adds a new file to net/bridge.
>
> This is an alternative to:
> [PATCH nf-next v5 2/3] netfilter: flowtable: teardown direct xmit flows when the fdb entry moves
>
>  include/linux/netfilter.h             |  9 +++++
>  include/net/netfilter/nf_flow_table.h |  4 +-
>  net/bridge/Makefile                   |  2 +-
>  net/bridge/br.c                       |  4 ++
>  net/bridge/br_nf_utils.c              | 55 +++++++++++++++++++++++++++
>  net/bridge/br_private.h               |  3 ++
>  net/netfilter/core.c                  |  3 ++
>  net/netfilter/nf_flow_table_core.c    | 51 ++++++++++++++++++++++++-
>  net/netfilter/nf_flow_table_path.c    |  5 ++-
>  9 files changed, 131 insertions(+), 5 deletions(-)
>  create mode 100644 net/bridge/br_nf_utils.c
>
> diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
> index e99afc1414cd..18636a918a67 100644
> --- a/include/linux/netfilter.h
> +++ b/include/linux/netfilter.h
> @@ -67,6 +67,15 @@ static inline void nf_inet_addr_mask(const union nf_inet_addr *a1,
>  #endif
>  }
>
> +struct net_bridge;
> +
> +struct nf_br_utils {
> +       bool    (*fdb_valid_dst)(struct net *net, int ifindex,
> +                                const unsigned char *addr, __u16 vid);
> +};
> +
> +extern struct nf_br_utils __rcu *nf_br_utils_hook;
> +
>  int netfilter_init(void);
>
>  struct sk_buff;
> diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
> index 5b611efaa3cd..8d4a97f9f9ec 100644
> --- a/include/net/netfilter/nf_flow_table.h
> +++ b/include/net/netfilter/nf_flow_table.h
> @@ -152,6 +152,7 @@ struct flow_offload_tuple {
>                                         xmit_type:3,
>                                         encap_num:2,
>                                         needs_gso_segment:1,
> +                                       bridge_path:1,
>                                         tun_num:2,
>                                         in_vlan_ingress:2;
>         u16                             mtu;
> @@ -234,7 +235,8 @@ struct nf_flow_route {
>                         u32                     hw_ifindex;
>                         u8                      h_source[ETH_ALEN];
>                         u8                      h_dest[ETH_ALEN];
> -                       u8                      needs_gso_segment:1;
> +                       u8                      needs_gso_segment:1,
> +                                               bridge_path:1;
>                 } out;
>                 enum flow_offload_xmit_type     xmit_type;
>         } tuple[FLOW_OFFLOAD_DIR_MAX];
> diff --git a/net/bridge/Makefile b/net/bridge/Makefile
> index 1203dc19e15c..ccae18d075bb 100644
> --- a/net/bridge/Makefile
> +++ b/net/bridge/Makefile
> @@ -8,7 +8,7 @@ obj-$(CONFIG_BRIDGE) += bridge.o
>  bridge-y       := br.o br_device.o br_fdb.o br_forward.o br_if.o br_input.o \
>                         br_ioctl.o br_stp.o br_stp_bpdu.o \
>                         br_stp_if.o br_stp_timer.o br_netlink.o \
> -                       br_netlink_tunnel.o br_arp_nd_proxy.o
> +                       br_netlink_tunnel.o br_arp_nd_proxy.o br_nf_utils.o
>
>  bridge-$(CONFIG_SYSFS) += br_sysfs_if.o br_sysfs_br.o
>
> diff --git a/net/bridge/br.c b/net/bridge/br.c
> index a5e5b2db110e..5c1d340f9bd9 100644
> --- a/net/bridge/br.c
> +++ b/net/bridge/br.c
> @@ -446,6 +446,8 @@ static int __init br_init(void)
>         if (err)
>                 goto err_out2;
>
> +       br_nf_utils_init();
> +
>         err = register_netdevice_notifier(&br_device_notifier);
>         if (err)
>                 goto err_out3;
> @@ -479,6 +481,7 @@ static int __init br_init(void)
>  err_out4:
>         unregister_netdevice_notifier(&br_device_notifier);
>  err_out3:
> +       br_nf_utils_fini();
>         br_nf_core_fini();
>  err_out2:
>         unregister_pernet_subsys(&br_net_ops);
> @@ -501,6 +504,7 @@ static void __exit br_deinit(void)
>
>         rcu_barrier(); /* Wait for completion of call_rcu()'s */
>
> +       br_nf_utils_fini();
>         br_nf_core_fini();
>         br_fdb_fini();
>  }
> diff --git a/net/bridge/br_nf_utils.c b/net/bridge/br_nf_utils.c
> new file mode 100644
> index 000000000000..5cb7ca4cdaa8
> --- /dev/null
> +++ b/net/bridge/br_nf_utils.c
> @@ -0,0 +1,55 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/netdevice.h>
> +#include <linux/netfilter.h>
> +
> +#include "br_private.h"
> +
> +static bool nf_br_fdb_valid_dst(struct net *net, int ifindex,
> +                               const unsigned char *addr, __u16 vid)
> +{
> +       const struct net_bridge_port *dst;
> +       struct net_device *dev, *upper;
> +       struct net_bridge_fdb_entry *f;
> +       struct net_bridge *br;
> +
> +       rcu_read_lock();
> +       dev = dev_get_by_index_rcu(net, ifindex);
> +       if (!dev || !netif_is_bridge_port(dev))
> +               goto out;
> +
> +       upper = netdev_master_upper_dev_get_rcu(dev);
> +       if (!upper)
> +               goto out;
> +
> +       br = netdev_priv(upper);
> +
> +       f = br_fdb_find_rcu(br, addr, vid);
> +       if (!f)
> +               goto out;
> +
> +       dst = READ_ONCE(f->dst);
> +       if (dst && dst->dev->ifindex == ifindex) {
> +               rcu_read_unlock();
> +               return true;
> +       }
> +out:
> +       rcu_read_unlock();
> +
> +       return false;
> +}
> +
> +static struct nf_br_utils nf_br_utils = {
> +       .fdb_valid_dst  = nf_br_fdb_valid_dst,
> +};
> +
> +void __init br_nf_utils_init(void)
> +{
> +       RCU_INIT_POINTER(nf_br_utils_hook, &nf_br_utils);
> +}
> +
> +void br_nf_utils_fini(void)
> +{
> +       rcu_assign_pointer(nf_br_utils_hook, NULL);
> +}
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index b01997ea9508..73d201c75f72 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -2013,6 +2013,9 @@ struct nf_br_ops {
>  };
>  extern const struct nf_br_ops __rcu *nf_br_ops;
>
> +void br_nf_utils_init(void);
> +void br_nf_utils_fini(void);
> +
>  /* br_netfilter.c */
>  #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
>  int br_nf_core_init(void);
> diff --git a/net/netfilter/core.c b/net/netfilter/core.c
> index 675a1034b340..91b0b3f77472 100644
> --- a/net/netfilter/core.c
> +++ b/net/netfilter/core.c
> @@ -798,6 +798,9 @@ static struct pernet_operations netfilter_net_ops = {
>         .exit = netfilter_net_exit,
>  };
>
> +struct nf_br_utils __rcu *nf_br_utils_hook;
> +EXPORT_SYMBOL_GPL(nf_br_utils_hook);
> +
>  int __init netfilter_init(void)
>  {
>         int ret;
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index 36bbc7be2f74..04612fc4d490 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -127,6 +127,8 @@ static int flow_offload_fill_route(struct flow_offload *flow,
>
>         switch (route->tuple[dir].xmit_type) {
>         case FLOW_OFFLOAD_XMIT_DIRECT:
> +               flow_tuple->bridge_path = route->tuple[dir].out.bridge_path;
> +
>                 if (route->tuple[!dir].in.num_tuns) {
>                         flow_tuple->dst_cache = dst;
>                         flow_tuple->dst_cookie =
> @@ -572,6 +574,51 @@ static void nf_flow_table_extend_ct_timeout(struct nf_conn *ct)
>         nf_ct_put(ct);
>  }
>
> +static bool nf_flow_dst_valid(struct nf_flowtable *flow_table,
> +                             struct flow_offload *flow, int dir)
> +{
> +       struct flow_offload_tuple *this_tuple = &flow->tuplehash[dir].tuple;
> +       struct net *net = read_pnet(&flow_table->net);
> +       struct flow_offload_tuple *other_tuple;
> +       struct nf_br_utils *br_utils;
> +       __u16 vid = 0;
> +       bool valid;
> +
> +       switch (this_tuple->xmit_type) {
> +       case FLOW_OFFLOAD_XMIT_NEIGH:
> +               valid = nf_flow_dst_check(this_tuple);
> +               break;
> +       case FLOW_OFFLOAD_XMIT_DIRECT:
> +               if (!this_tuple->bridge_path) {
> +                       valid = true;
> +                       break;
> +               }
> +               other_tuple = &flow->tuplehash[!dir].tuple;
> +
> +               rcu_read_lock();
> +               br_utils = rcu_dereference(nf_br_utils_hook);
> +               if (!br_utils) {
> +                       rcu_read_unlock();
> +                       valid = true;
> +                       break;
> +               }
> +
> +               if (other_tuple->encap[0].proto == htons(ETH_P_8021Q) ||
> +                   other_tuple->encap[0].proto == htons(ETH_P_8021AD))
> +                       vid = other_tuple->encap[0].id;
> +
> +               valid = br_utils->fdb_valid_dst(net, this_tuple->out.ifidx,
> +                                               this_tuple->out.h_dest, vid);
> +               rcu_read_unlock();
> +               break;
> +       default:
> +               valid = true;
> +               break;
> +       }
> +
> +       return valid;
> +}
> +
>  static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
>                                     struct flow_offload *flow, void *data)
>  {
> @@ -584,8 +631,8 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
>
>         if (nf_flow_has_expired(flow) ||
>             nf_ct_is_dying(flow->ct) ||
> -           !nf_flow_dst_check(&flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple) ||
> -           !nf_flow_dst_check(&flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple) ||
> +           !nf_flow_dst_valid(flow_table, flow, FLOW_OFFLOAD_DIR_ORIGINAL) ||
> +           !nf_flow_dst_valid(flow_table, flow, FLOW_OFFLOAD_DIR_REPLY) ||
>             nf_flow_custom_gc(flow_table, flow)) {
>                 flow_offload_teardown(flow);
>                 teardown = true;
> diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
> index d90013685bf1..06b3be7b8f6a 100644
> --- a/net/netfilter/nf_flow_table_path.c
> +++ b/net/netfilter/nf_flow_table_path.c
> @@ -95,7 +95,8 @@ struct nft_forward_info {
>         u8 ingress_vlans;
>         u8 h_source[ETH_ALEN];
>         u8 h_dest[ETH_ALEN];
> -       bool needs_gso_segment;
> +       u8 needs_gso_segment:1,
> +          bridge_path:1;
>         enum flow_offload_xmit_type xmit_type;
>  };
>
> @@ -183,6 +184,7 @@ static int nft_dev_path_info(struct net_device_path_stack *stack,
>                         case DEV_PATH_BR_VLAN_KEEP:
>                                 break;
>                         }
> +                       info->bridge_path = 1;
>                         info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
>                         break;
>                 default:
> @@ -260,6 +262,7 @@ static int nft_dev_forward_path(const struct nft_pktinfo *pkt,
>         if (info.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT) {
>                 memcpy(route->tuple[dir].out.h_source, info.h_source, ETH_ALEN);
>                 memcpy(route->tuple[dir].out.h_dest, info.h_dest, ETH_ALEN);
> +               route->tuple[dir].out.bridge_path = info.bridge_path;
>                 route->tuple[dir].xmit_type = info.xmit_type;
>         }
>         route->tuple[dir].out.needs_gso_segment = info.needs_gso_segment;
> --
> 2.47.3
>
