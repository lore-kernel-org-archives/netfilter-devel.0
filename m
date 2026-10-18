Received: from mail-24422.protonmail.ch (mail-24422.protonmail.ch [109.224.244.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CAD37F30C
	for <netfilter-devel@vger.kernel.org>; Sun, 18 Oct 2026 09:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792316859; cv=none; b=X7tHVl1evyXGOINfm8XhKglH/szNN9OfwTEtgtNXvjolWNmLh38pmah1383zNl5vz15PwyNk9z9whSbi1y3Yj6B9U1M7vOmxgecw/ncIKh5fYc6aCyo96kHACvrLmdT7Hs59FuKYq34jNtFHB0Xpf885/KL7tsb2sL2lcYqnOaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792316859; c=relaxed/simple;
	bh=64p0GQlp2UzIc5MP/8s6kyYSTiPA0W6VAtw1iaEUteQ=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=arlim+qHAjX7kMmaazZNBQLuJurSvsKXnmBAA/Z6bYl7Smm+yFejCiz9TuiemxbGQ5Z+nv8FJgAiUc6b02wrItTIUHt7pc8QL7h1Ic1TT3/kdDIE4EVLU2/STMY1k8XJQs7yaCO25TLFXGMHFFrrrUkb4d+1sW0SzuPN6Xp3Cm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=trip-g.com; spf=pass smtp.mailfrom=trip-g.com; dkim=pass (2048-bit key) header.d=trip-g.com header.i=@trip-g.com header.b=yshEf+8C; arc=none smtp.client-ip=109.224.244.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=trip-g.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trip-g.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trip-g.com header.i=@trip-g.com header.b="yshEf+8C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=trip-g.com;
	s=protonmail2; t=1792316853; x=1792576053;
	bh=iQUYJDeJ40AsL1tjv+d5HDPPrhtN0RTwYL3LxMizVyw=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=yshEf+8CDpz7/e0DdtfUNn00X5/YFdfABoTCKh4M/0iOajnkfnLfDzOwT5IfBvY9X
	 isCJU9sE8Y9Etlefb2spuuWulm8aU5DUUL9CLlmeB7Pfgyt6tLbRIFvOp9zqJW7JUx
	 U7GvNFySvLAmn5BS2zXMEg/9cgiH9wq0Wn6lBNIGsRvT6ThZiQ89ulTRPD2nq8fnlS
	 hmv5afkO+865phkgh2wh4fJ2PH2ZwEU3tQc+xUh7xaCrtkclECPz7wGrB6AdBmeexd
	 MRLA1bi37YH+dJcz8woUAuZhi5a2Qt5FBYGm/WvEVD7QpdYjydcqZTdzX7M2jKv5jb
	 fr9LQRiVTsgCg==
Date: Sun, 18 Oct 2026 09:47:28 +0000
To: Ahmed Zaki <anzaki@gmail.com>, netfilter-devel@vger.kernel.org, andrew@lunn.ch, olteanv@gmail.com, pablo@netfilter.org, fw@strlen.de, kuba@kernel.org, pabeni@redhat.com, edumazet@google.com
From: Gregg <gregg@trip-g.com>
Cc: coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next v2 1/2] netfilter: flowtable: update netdev stats with HW_OFFLOAD flows
Message-ID: <dfca2078-e5ad-415e-89c6-eea1d1427dcf@trip-g.com>
Feedback-ID: 34488774:user:proton
X-Pm-Message-ID: 45c296a46c487f6d558e4ee84053fdc0eade6c71
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Ahmed,

One thing about the final read in flow_offload_work_del(), from
testing the same idea on an MT7622 router (mtk_eth_soc PPE behind a DSA
switch, OpenWrt 25.12.5, 6.12):

> +static void flow_offload_work_del(struct flow_offload_work *offload)
> +{
> +=09struct flow_stats stats[FLOW_OFFLOAD_DIR_MAX] =3D {};
> +
> +=09flow_offload_tuple_stats(offload, FLOW_OFFLOAD_DIR_ORIGINAL, &stats[0=
]);
> +=09if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
> +=09=09flow_offload_tuple_stats(offload, FLOW_OFFLOAD_DIR_REPLY,
> +=09=09=09=09=09 &stats[1]);
> +=09flow_offload_netdev_update(offload, stats);

FLOW_CLS_STATS returns what the hardware counted since the previous
query. This read takes the last chunk, but it only goes to the netdev
counters. Conntrack never sees it, and once it's read the driver won't
report it again. Today that tail is lost because nobody reads it; with
this hunk it would still be lost for conntrack.

The tail isn't small. nf_flow_offload_stats() only queues a query once
less than 90% of the offload timeout remains, so a busy flow is polled
about every 3 s. A flow that ends with a FIN is torn down without the
traffic since the last poll. Measured on the MT7622, one TCP download
of exactly 100 MiB (110.27 MB at L3), server closing right after the
data, conntrack -L read every 2 s:

  last stats poll before the close:   98,735,760
  with a final read into conntrack:   110,270,254

Without the final read, conntrack stops at the last poll's value, about
11 MB short here. The exact final value also needed a separate mtk_ppe
fix in OpenWrt's out-of-tree accounting patch; netfilter isn't involved
in that part. On a home router with a stock kernel, a fast single
download ended 41% short in conntrack/ulogd.

The final read could feed both. For example, pull the
NF_FLOWTABLE_COUNTER / nf_ct_acct_add() block out of
flow_offload_work_stats() into a helper and call it here next to
flow_offload_netdev_update(). Or have flow_offload_work_del() simply
call flow_offload_work_stats(), which is what we did locally:

 static void flow_offload_work_del(struct flow_offload_work *offload)
 {
 =09clear_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
+=09flow_offload_work_stats(offload);
 =09flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL);

(It also pushes flow->timeout forward, which doesn't matter at that
point.)

The netdev counters themselves would help us too. The DSA user port
(wan) misses all offloaded traffic today, which is why we read the
switch MIB with ethtool instead. I'm happy to test a v3 on MT7622 if
that's useful.

Thanks,
gregg


On 2026-03-24 16:40, Ahmed Zaki wrote:
> Some drivers (notably DSA) delegate the nft flowtable HW_OFFLOAD flows
> to a parent driver. While the parent driver is able to report the
> offloaded traffic stats directly from the HW, the delegating driver
> does not report the stats. This fails SNMP-based monitoring tools that
> rely on netdev stats to report the network traffic.
>=20
> Add a new struct pcpu_sw_netstats "fstats" to net_device that gets
> allocated only if the new flag "flow_offload_via_parent" is set by the
> driver. The new stats are lazily allocated by the nft flow offloading
> code when the first flow is offloaded. The stats are updated periodically
> in flow_offload_work_stats() and also once in flow_offload_work_del()
> before the flow is deleted. For this, flow_offload_work_del() had to
> be moved below flow_offload_tuple_stats().
>=20
> Signed-off-by: Ahmed Zaki <anzaki@gmail.com>
> ---
>  include/linux/netdevice.h             | 45 ++++++++++++
>  net/core/dev.c                        |  8 +++
>  net/netfilter/nf_flow_table_offload.c | 98 +++++++++++++++++++++++++--
>  3 files changed, 145 insertions(+), 6 deletions(-)
>=20
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 67e25f6d15a4..647758f78213 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1840,6 +1840,11 @@ enum netdev_reg_state {
>   *=09@stats:=09=09Statistics struct, which was left as a legacy, use
>   *=09=09=09rtnl_link_stats64 instead
>   *
> + *=09@fstats:=09HW offloaded flow statistics: RX/TX packets,
> + *=09=09=09RX/TX bytes. Lazily allocated by the flow offload
> + *=09=09=09path on the first offloaded flow for devices that
> + *=09=09=09set @flow_offload_via_parent. Freed by free_netdev().
> + *
>   *=09@core_stats:=09core networking counters,
>   *=09=09=09do not use this in drivers
>   *=09@carrier_up_count:=09Number of times the carrier has been up
> @@ -2048,6 +2053,12 @@ enum netdev_reg_state {
>   *=09@change_proto_down: device supports setting carrier via IFLA_PROTO_=
DOWN
>   *=09@netns_immutable: interface can't change network namespaces
>   *=09@fcoe_mtu:=09device supports maximum FCoE MTU, 2158 bytes
> + *=09@flow_offload_via_parent: device delegates nft flowtable hardware
> + *=09=09=09=09  offload to a parent/conduit device (e.g. DSA
> + *=09=09=09=09  user ports delegate to their conduit MAC).
> + *=09=09=09=09  The parent's HW count the offloaded traffic
> + *=09=09=09=09  but this device's sw netstats path does not.
> + *=09=09=09=09  @fstats is allocated to fill that gap.
>   *
>   *=09@net_notifier_list:=09List of per-net netdev notifier block
>   *=09=09=09=09that follow this device when it is moved
> @@ -2233,6 +2244,7 @@ struct net_device {
> =20
>  =09struct net_device_stats=09stats; /* not used by modern drivers */
> =20
> +=09struct pcpu_sw_netstats __percpu *fstats;
>  =09struct net_device_core_stats __percpu *core_stats;
> =20
>  =09/* Stats to monitor link on/off, flapping */
> @@ -2463,6 +2475,7 @@ struct net_device {
>  =09unsigned long=09=09change_proto_down:1;
>  =09unsigned long=09=09netns_immutable:1;
>  =09unsigned long=09=09fcoe_mtu:1;
> +=09unsigned long=09=09flow_offload_via_parent:1;
> =20
>  =09struct list_head=09net_notifier_list;
> =20
> @@ -2992,6 +3005,38 @@ struct pcpu_lstats {
> =20
>  void dev_lstats_read(struct net_device *dev, u64 *packets, u64 *bytes);
> =20
> +static inline void dev_fstats_rx_add(struct net_device *dev,
> +=09=09=09=09     unsigned int packets,
> +=09=09=09=09     unsigned int len)
> +{
> +=09struct pcpu_sw_netstats *fstats;
> +
> +=09if (!dev->fstats)
> +=09=09return;
> +
> +=09fstats =3D this_cpu_ptr(dev->fstats);
> +=09u64_stats_update_begin(&fstats->syncp);
> +=09u64_stats_add(&fstats->rx_bytes, len);
> +=09u64_stats_add(&fstats->rx_packets, packets);
> +=09u64_stats_update_end(&fstats->syncp);
> +}
> +
> +static inline void dev_fstats_tx_add(struct net_device *dev,
> +=09=09=09=09     unsigned int packets,
> +=09=09=09=09     unsigned int len)
> +{
> +=09struct pcpu_sw_netstats *fstats;
> +
> +=09if (!dev->fstats)
> +=09=09return;
> +
> +=09fstats =3D this_cpu_ptr(dev->fstats);
> +=09u64_stats_update_begin(&fstats->syncp);
> +=09u64_stats_add(&fstats->tx_bytes, len);
> +=09u64_stats_add(&fstats->tx_packets, packets);
> +=09u64_stats_update_end(&fstats->syncp);
> +}
> +
>  static inline void dev_sw_netstats_rx_add(struct net_device *dev, unsign=
ed int len)
>  {
>  =09struct pcpu_sw_netstats *tstats =3D this_cpu_ptr(dev->tstats);
> diff --git a/net/core/dev.c b/net/core/dev.c
> index f48dc299e4b2..07fb315ad42c 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -11865,6 +11865,7 @@ struct rtnl_link_stats64 *dev_get_stats(struct ne=
t_device *dev,
>  {
>  =09const struct net_device_ops *ops =3D dev->netdev_ops;
>  =09const struct net_device_core_stats __percpu *p;
> +=09const struct pcpu_sw_netstats __percpu *fstats;
> =20
>  =09/*
>  =09 * IPv{4,6} and udp tunnels share common stat helpers and use
> @@ -11893,6 +11894,11 @@ struct rtnl_link_stats64 *dev_get_stats(struct n=
et_device *dev,
>  =09=09netdev_stats_to_stats64(storage, &dev->stats);
>  =09}
> =20
> +=09/* This READ_ONCE() pairs with cmpxchg in flow_offload_fstats_ensure(=
) */
> +=09fstats =3D READ_ONCE(dev->fstats);
> +=09if (fstats)
> +=09=09dev_fetch_sw_netstats(storage, fstats);
> +
>  =09/* This READ_ONCE() pairs with the write in netdev_core_stats_alloc()=
 */
>  =09p =3D READ_ONCE(dev->core_stats);
>  =09if (p) {
> @@ -12212,6 +12218,8 @@ void free_netdev(struct net_device *dev)
>  =09free_percpu(dev->pcpu_refcnt);
>  =09dev->pcpu_refcnt =3D NULL;
>  #endif
> +=09free_percpu(dev->fstats);
> +=09dev->fstats =3D NULL;
>  =09free_percpu(dev->core_stats);
>  =09dev->core_stats =3D NULL;
>  =09free_percpu(dev->xdp_bulkq);
> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flo=
w_table_offload.c
> index b2e4fb6fa011..fc1e67a79904 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -925,13 +925,80 @@ static void flow_offload_work_add(struct flow_offlo=
ad_work *offload)
>  =09nf_flow_offload_destroy(flow_rule);
>  }
> =20
> -static void flow_offload_work_del(struct flow_offload_work *offload)
> +static bool flow_offload_fstats_ensure(struct net_device *dev)
>  {
> -=09clear_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
> -=09flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL);
> -=09if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
> -=09=09flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
> -=09set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
> +=09struct pcpu_sw_netstats __percpu *p;
> +
> +=09if (!dev->flow_offload_via_parent)
> +=09=09return false;
> +
> +=09/* Pairs with cmpxchg() below. */
> +=09if (likely(READ_ONCE(dev->fstats)))
> +=09=09return true;
> +
> +=09p =3D __netdev_alloc_pcpu_stats(struct pcpu_sw_netstats, GFP_ATOMIC);
> +=09if (!p)
> +=09=09return false;
> +
> +=09if (cmpxchg(&dev->fstats, NULL, p))
> +=09=09free_percpu(p);=09/* lost the race, discard and use winner's */
> +
> +=09return true;
> +}
> +
> +static u32 flow_offload_egress_ifidx(const struct flow_offload_tuple *tu=
ple)
> +{
> +=09switch (tuple->xmit_type) {
> +=09case FLOW_OFFLOAD_XMIT_NEIGH:
> +=09=09return tuple->ifidx;
> +=09case FLOW_OFFLOAD_XMIT_DIRECT:
> +=09=09return tuple->out.ifidx;
> +=09default:
> +=09=09return 0;
> +=09}
> +}
> +
> +static void flow_offload_netdev_update(struct flow_offload_work *offload=
,
> +=09=09=09=09       struct flow_stats *stats)
> +{
> +=09const struct flow_offload_tuple *tuple;
> +=09struct net_device *indev, *outdev;
> +=09struct net *net;
> +
> +=09rcu_read_lock();
> +=09net =3D read_pnet(&offload->flowtable->net);
> +=09if (stats[FLOW_OFFLOAD_DIR_ORIGINAL].pkts) {
> +=09=09tuple =3D &offload->flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tup=
le;
> +=09=09indev =3D dev_get_by_index_rcu(net, tuple->iifidx);
> +=09=09if (indev && flow_offload_fstats_ensure(indev))
> +=09=09=09dev_fstats_rx_add(indev,
> +=09=09=09=09=09  stats[FLOW_OFFLOAD_DIR_ORIGINAL].pkts,
> +=09=09=09=09=09  stats[FLOW_OFFLOAD_DIR_ORIGINAL].bytes);
> +
> +=09=09outdev =3D dev_get_by_index_rcu(net,
> +=09=09=09=09=09      flow_offload_egress_ifidx(tuple));
> +=09=09if (outdev && flow_offload_fstats_ensure(outdev))
> +=09=09=09dev_fstats_tx_add(outdev,
> +=09=09=09=09=09  stats[FLOW_OFFLOAD_DIR_ORIGINAL].pkts,
> +=09=09=09=09=09  stats[FLOW_OFFLOAD_DIR_ORIGINAL].bytes);
> +=09}
> +
> +=09if (stats[FLOW_OFFLOAD_DIR_REPLY].pkts) {
> +=09=09tuple =3D &offload->flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple;
> +=09=09indev =3D dev_get_by_index_rcu(net, tuple->iifidx);
> +=09=09if (indev && flow_offload_fstats_ensure(indev))
> +=09=09=09dev_fstats_rx_add(indev,
> +=09=09=09=09=09  stats[FLOW_OFFLOAD_DIR_REPLY].pkts,
> +=09=09=09=09=09  stats[FLOW_OFFLOAD_DIR_REPLY].bytes);
> +
> +=09=09outdev =3D dev_get_by_index_rcu(net,
> +=09=09=09=09=09      flow_offload_egress_ifidx(tuple));
> +=09=09if (outdev && flow_offload_fstats_ensure(outdev))
> +=09=09=09dev_fstats_tx_add(outdev,
> +=09=09=09=09=09  stats[FLOW_OFFLOAD_DIR_REPLY].pkts,
> +=09=09=09=09=09  stats[FLOW_OFFLOAD_DIR_REPLY].bytes);
> +=09}
> +=09rcu_read_unlock();
>  }
> =20
>  static void flow_offload_tuple_stats(struct flow_offload_work *offload,
> @@ -968,6 +1035,25 @@ static void flow_offload_work_stats(struct flow_off=
load_work *offload)
>  =09=09=09=09       FLOW_OFFLOAD_DIR_REPLY,
>  =09=09=09=09       stats[1].pkts, stats[1].bytes);
>  =09}
> +
> +=09flow_offload_netdev_update(offload, stats);
> +}
> +
> +static void flow_offload_work_del(struct flow_offload_work *offload)
> +{
> +=09struct flow_stats stats[FLOW_OFFLOAD_DIR_MAX] =3D {};
> +
> +=09flow_offload_tuple_stats(offload, FLOW_OFFLOAD_DIR_ORIGINAL, &stats[0=
]);
> +=09if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
> +=09=09flow_offload_tuple_stats(offload, FLOW_OFFLOAD_DIR_REPLY,
> +=09=09=09=09=09 &stats[1]);
> +=09flow_offload_netdev_update(offload, stats);
> +
> +=09clear_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
> +=09flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL);
> +=09if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
> +=09=09flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
> +=09set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
>  }
> =20
>  static void flow_offload_work_handler(struct work_struct *work)


