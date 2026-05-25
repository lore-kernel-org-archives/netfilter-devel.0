Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7D9202C48;
	Mon, 25 May 2026 17:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779729942; cv=none; b=S80bVol9hTNCFSk7uA1XOmLTdWlVcn1MUB/RmI1kNKCV8/QXdu7szsu90f3/5mbaC39ZMbAWge4IJHRXR1TIEXD6iGKquCTVL5Lk+Kj4CBPBP3tKDejSpGkKE6VFrTT2kSWcjXd3xq3ySX7cVb+1Aae2OF4bvlCOmmUHwm1ERpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779729942; c=relaxed/simple;
	bh=lLD2IFbucYzM/WsSLEpYfIqay3733kjfgM/tq43N9cw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V9ZeONhZXR1z9TfWD9pikbmfJm8AC3e/GMQ+yvWEW2KKTwQf2d9eGThcp/jkMS5c3WUDCldfHftQqUt5Rlrq3YLH/FHqXFO1nOVpVkC0E1N/TMiEalCouLiFAPf/XjDmNO80hCrFXBa/Dx87s1wAw7DMkCxn9nFYIj/8dZ1LpqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=fqW06GjZ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="fqW06GjZ"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id AAA7D600B9;
	Mon, 25 May 2026 19:25:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1779729930;
	bh=roTkpiDhpQW9904jIhgyXdGeQdMMhP72YBT4hIaOoOo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fqW06GjZKWo01uW7115e2yQiQcU+KWQX3GBFOQynpA74z4W90IHHDCzgjgIrGg/9G
	 pj0QtqOOE568tI4DsO8Y/m+H502+ULZAigAeCArkSDiPiHKA6N1UWjHJCg3ZGihIVO
	 LgbX4IyPV/a4v1sfz6pDr0nHDn5X85Q0X/XGG7wm6uJBYSTOS1/bN5Exl4/QPvK8jg
	 TEG+iqFAq10WmPn5i1CbvkRK6xjtD7cQxVzPEmg3/eCbKt4aPSBDIVNkshwXeGmKST
	 fnqRYpCV+aEm17maOJklU5mCZe5QvQ9yUS1Ui1NHKFrBirnrTeTcBzr65Gker53JEn
	 Q84PKRi1HVg/A==
Date: Mon, 25 May 2026 19:25:28 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jihong Min <hurryman2212@gmail.com>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: flowtable: resolve LAG slave for direct HW
 offload
Message-ID: <ahSGCBw-fRq_oF-Q@chamomile>
References: <20260525162417.366556-1-hurryman2212@gmail.com>
 <da748e80-450f-42bd-a3bd-fde52c1c7d90@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <da748e80-450f-42bd-a3bd-fde52c1c7d90@gmail.com>

On Tue, May 26, 2026 at 01:33:09AM +0900, Jihong Min wrote:
> Sorry for the noise.
> 
> While preparing the git-send-email command, I noticed that the subject
> prefix was not set correctly. This should have been sent with the
> nf-next prefix.
> 
> I also noticed that the Assisted-by trailer was missing. Most of the
> patch was written by me, but I did get help from GPT-5.5 for some of
> the RCU and lifetime details, so the patch should have included:
> 
> Assisted-by: Codex:gpt-5.5
> 
> Also, this change was tested on a Lumen W1700K2 with a Linux 6.18
> OpenWrt-based image, where it enabled flow offload in a bonding setup.
> I have also applied the same diff on top of nf-next and completed a
> compile test there. I checked that the relevant infrastructure for
> bonding flow offload support is identical between the tested tree and
> nf-next.

Can you make this work with fill_forward_path in the bonding device?

> I will be more careful in the next submission and will correct this
> there.
> 
> Best regards,
> Jihong
> 
> On 5/26/26 01:24, Jihong Min wrote:
> > FLOW_OFFLOAD_XMIT_DIRECT path discovery can stop at a LAG master because
> > the real egress port is selected later through ndo_get_xmit_slave().
> > Hardware flow offload drivers that program per-port redirects need the
> > selected lower device, while software forwarding must still transmit
> > through the LAG master.
> > 
> > Keep the route tuple software egress ifindex on the LAG master and carry
> > a separate hardware redirect ifindex. When the direct egress device is a
> > LAG master, resolve the selected slave with netdev_get_xmit_slave(),
> > verify that it belongs to the flowtable, and store it as the hardware
> > redirect device.
> > 
> > Signed-off-by: Jihong Min <hurryman2212@gmail.com>
> > ---
> >  include/net/netfilter/nf_flow_table.h |  1 +
> >  net/netfilter/nf_flow_table_core.c    |  1 +
> >  net/netfilter/nf_flow_table_offload.c |  2 +-
> >  net/netfilter/nf_flow_table_path.c    | 34 ++++++++++++++++++++++++++-
> >  4 files changed, 36 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
> > index 7b23b245a5a8..ada9db7e5c38 100644
> > --- a/include/net/netfilter/nf_flow_table.h
> > +++ b/include/net/netfilter/nf_flow_table.h
> > @@ -163,6 +163,7 @@ struct flow_offload_tuple {
> >  		};
> >  		struct {
> >  			u32		ifidx;
> > +			u32		hw_ifidx;
> >  			u8		h_source[ETH_ALEN];
> >  			u8		h_dest[ETH_ALEN];
> >  		} out;
> > diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> > index 785d8c244a77..bc329420f882 100644
> > --- a/net/netfilter/nf_flow_table_core.c
> > +++ b/net/netfilter/nf_flow_table_core.c
> > @@ -132,6 +132,7 @@ static int flow_offload_fill_route(struct flow_offload *flow,
> >  		memcpy(flow_tuple->out.h_source, route->tuple[dir].out.h_source,
> >  		       ETH_ALEN);
> >  		flow_tuple->out.ifidx = route->tuple[dir].out.ifindex;
> > +		flow_tuple->out.hw_ifidx = route->tuple[dir].out.hw_ifindex;
> >  		dst_release(dst);
> >  		break;
> >  	case FLOW_OFFLOAD_XMIT_XFRM:
> > diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> > index 002ec15d988b..7c46baa1546d 100644
> > --- a/net/netfilter/nf_flow_table_offload.c
> > +++ b/net/netfilter/nf_flow_table_offload.c
> > @@ -596,7 +596,7 @@ static int flow_offload_redirect(struct net *net,
> >  	switch (this_tuple->xmit_type) {
> >  	case FLOW_OFFLOAD_XMIT_DIRECT:
> >  		this_tuple = &flow->tuplehash[dir].tuple;
> > -		ifindex = this_tuple->out.ifidx;
> > +		ifindex = this_tuple->out.hw_ifidx;
> >  		break;
> >  	case FLOW_OFFLOAD_XMIT_NEIGH:
> >  		other_tuple = &flow->tuplehash[!dir].tuple;
> > diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
> > index 9e88ea6a2eef..10f38ca27a6f 100644
> > --- a/net/netfilter/nf_flow_table_path.c
> > +++ b/net/netfilter/nf_flow_table_path.c
> > @@ -5,6 +5,7 @@
> >  #include <linux/etherdevice.h>
> >  #include <linux/netlink.h>
> >  #include <linux/netfilter.h>
> > +#include <linux/netdevice.h>
> >  #include <linux/spinlock.h>
> >  #include <linux/netfilter/nf_conntrack_common.h>
> >  #include <linux/netfilter/nf_tables.h>
> > @@ -76,6 +77,7 @@ static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
> >  struct nft_forward_info {
> >  	const struct net_device *indev;
> >  	const struct net_device *outdev;
> > +	const struct net_device *hw_outdev;
> >  	struct id {
> >  		__u16	id;
> >  		__be16	proto;
> > @@ -179,6 +181,7 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
> >  		}
> >  	}
> >  	info->outdev = info->indev;
> > +	info->hw_outdev = info->indev;
> >  
> >  	if (nf_flowtable_hw_offload(flowtable) &&
> >  	    nft_is_valid_ether_device(info->indev))
> > @@ -250,6 +253,7 @@ static void nft_dev_forward_path(const struct nft_pktinfo *pkt,
> >  	struct net_device_path_stack stack;
> >  	struct nft_forward_info info = {};
> >  	unsigned char ha[ETH_ALEN];
> > +	struct net_device *lag_slave = NULL;
> >  	int i;
> >  
> >  	if (nft_dev_fill_forward_path(route, dst, ct, dir, ha, &stack) >= 0)
> > @@ -258,9 +262,34 @@ static void nft_dev_forward_path(const struct nft_pktinfo *pkt,
> >  	if (info.outdev)
> >  		route->tuple[dir].out.ifindex = info.outdev->ifindex;
> >  
> > -	if (!info.indev || !nft_flowtable_find_dev(info.indev, ft))
> > +	if (!info.indev)
> >  		return;
> >  
> > +	if (info.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT &&
> > +	    netif_is_lag_master(info.hw_outdev)) {
> > +		rcu_read_lock();
> > +		lag_slave = netdev_get_xmit_slave((struct net_device *)info.hw_outdev,
> > +						  pkt->skb, false);
> > +		if (lag_slave)
> > +			dev_hold(lag_slave);
> > +		rcu_read_unlock();
> > +
> > +		if (!lag_slave)
> > +			return;
> > +
> > +		if (!nft_is_valid_ether_device(lag_slave)) {
> > +			dev_put(lag_slave);
> > +			return;
> > +		}
> > +
> > +		info.hw_outdev = lag_slave;
> > +	}
> > +
> > +	if (!nft_flowtable_find_dev(info.hw_outdev, ft)) {
> > +		dev_put(lag_slave);
> > +		return;
> > +	}
> > +
> >  	route->tuple[!dir].in.ifindex = info.indev->ifindex;
> >  	for (i = 0; i < info.num_encaps; i++) {
> >  		route->tuple[!dir].in.encap[i].id = info.encap[i].id;
> > @@ -281,9 +310,12 @@ static void nft_dev_forward_path(const struct nft_pktinfo *pkt,
> >  	if (info.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT) {
> >  		memcpy(route->tuple[dir].out.h_source, info.h_source, ETH_ALEN);
> >  		memcpy(route->tuple[dir].out.h_dest, info.h_dest, ETH_ALEN);
> > +		route->tuple[dir].out.hw_ifindex = info.hw_outdev->ifindex;
> >  		route->tuple[dir].xmit_type = info.xmit_type;
> >  	}
> >  	route->tuple[dir].out.needs_gso_segment = info.needs_gso_segment;
> > +
> > +	dev_put(lag_slave);
> >  }
> >  
> >  int nft_flow_route(const struct nft_pktinfo *pkt, const struct nf_conn *ct,
> 
