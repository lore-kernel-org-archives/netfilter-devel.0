Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2096.outbound.protection.outlook.com [40.107.249.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1872DF73
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Mar 2024 10:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.249.96
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710756336; cv=fail; b=ta3M8FED3i+aXAOnhY9cBRC5yZ1xR1lWVai7gm3YmXI1w319UeqL+UVlvcV8/4w5d/GgVtMvf6V5GE4qFsjW0jng2N38IEgXnN6osC3Zr8eEfy1Mon+eTZb8eFWTfg/QuOK3X1GuhPjLMH9QWruHQX1GwXg/G0q6ecoPCzqDWGg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710756336; c=relaxed/simple;
	bh=TXJN+9ds8joQA3KZkluTrCsh5uOiLNp+jvIIt07qcMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VC5tOx5pUV3tm1sf9O3mrPIVd2GsPvhTfx/EIp8uJWJnkn7mdifdAJjXyENlHRtlC7o07Ht3cbEN+57fCT1oeDP2ANnio+xBEYYb69w1jagi/y8+bTpUKWkahDBc74hrabcaRwnRm+IV2MFCVF4pxNnqcS9jqMokHiOCs6njVeA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de; spf=pass smtp.mailfrom=voleatech.de; dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b=OhYx+/Mb; arc=fail smtp.client-ip=40.107.249.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=voleatech.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="OhYx+/Mb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nOswTNI1+pf0oF9x8IYz+rBerwbUyEkgsnp8hQ/GvSztk5e+bheSWLiZAsvj0K43N0xyTfQoie6t67HQOIrr1JfK19ZqRAnzEFNE7JJJU2p5VnTjHTt37yANyOWqKo2VFmFzqKUp9EW5xOf8nE0yyGN0y/KdwylqKokcLkTxbv0qG0/ztD6YEOpE0ij3lhnWAiGUcD1cLMXyOQEX/b9SsRUE+bKcfZzqM2CxzUKAjgCHgG18SOQB1lpH9K4zRzJEm95ZgpKzM9EBP++EtGcXze9XCEDWURZ4jNGrzqa3+7BlwHzm6HAJSCZH/quijd5z3Q3QE3kIBfO1Lrbifts8Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UNY9ze51NzIya5sOH0F8ckAiUJw9Hc42810f5H+yumE=;
 b=aG7y6FcdqzWg1wcQaAh0i4YAM6Ql1VPhEy8SYc2fJHDxF4FUAVLZ/0LBY6q05517K/2kP1UK7/zT8JmzFuk5gYQkoi7nbDEcla0q/DrQfz/EXOLKp4+YvEcOnUOb3b06/SxyrqYvJMQalDjfin0IFJ+VR8PNARyFZW5km56tyuSS5nPo/oQxM9zAEOHBJsjfdWsT/HxksoU/HHH+3mQN/S0+emTNkow7Anlda1+lWdepaQvi5TVejUGd47JLqPplfxH7XgiI2oZ4Wks7BsDnm8fjBAl8fRlF+89uvr8mzBhU2RjC7mvajcUuk6sp9+PXkNs/xTK06xTCZX8oVaKvww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UNY9ze51NzIya5sOH0F8ckAiUJw9Hc42810f5H+yumE=;
 b=OhYx+/MbCrpeC93J9rBtUyzN6E6PZvn1XYR+xZPS5pr+gLz4aQDITDXkj9HbZHUqXzYvpDV0SXf8D2g+3bLVx4znRonwsx//g4+Npo/jUFLJcZteuRkfC8DU5tRpzkkaSUGCPiK0RaMgUqOPGMYnOQij4+7qO/vyqOaF3xbsR+A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from GVXPR05MB11233.eurprd05.prod.outlook.com
 (2603:10a6:150:14e::13) by GV1PR05MB11441.eurprd05.prod.outlook.com
 (2603:10a6:150:1a5::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.23; Mon, 18 Mar
 2024 10:05:29 +0000
Received: from GVXPR05MB11233.eurprd05.prod.outlook.com
 ([fe80::9d0c:55e:de01:2a2b]) by GVXPR05MB11233.eurprd05.prod.outlook.com
 ([fe80::9d0c:55e:de01:2a2b%2]) with mapi id 15.20.7362.019; Mon, 18 Mar 2024
 10:05:29 +0000
Date: Mon, 18 Mar 2024 11:05:24 +0100
From: Sven Auhagen <sven.auhagen@voleatech.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, cratiu@nvidia.com, ozsh@nvidia.com, 
	vladbu@nvidia.com, gal@nvidia.com, fw@strlen.de
Subject: Re: [PATCH nf] netfilter: flowtable: infer TCP state and timeout
 before flow teardown
Message-ID: <sankmmupgyxvdoa7pwnwm7f6y22piop3eaqanei37dqe4kobbl@wrrusx6wojw4>
References: <20240318093915.10358-1-pablo@netfilter.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240318093915.10358-1-pablo@netfilter.org>
X-ClientProxiedBy: FR4P281CA0318.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:eb::18) To GVXPR05MB11233.eurprd05.prod.outlook.com
 (2603:10a6:150:14e::13)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GVXPR05MB11233:EE_|GV1PR05MB11441:EE_
X-MS-Office365-Filtering-Correlation-Id: 50cba089-65ae-4297-526e-08dc4732f076
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	XTM38M0tOQJ0F++VJZvSJIWubpXWiBZHP/BfB4l7fCSBEUaq524tNH/9Fsw1BBk3HgtllV/P8NlVTt9xyljSIwRvW01dklbXiTDgm0snWgzEJwkxnyeHFnx1/blBTiVSL2a8E63wonBV+BJ6afZIXrSqOl2VomUnu+pUSHdfJwhsUrcSt+DYTWeJGzhzAMGk87gKrfQXIUoOPH4Tw90+b116XNZNSTlLeoaeTtZh6i8xGKPO/WadIrxKS+qsD4bwVSK1vSaljVzpAk06CSR3AxVlf6h2Xr0RKg6MaMG+5GdJF9mY6j1cGSfnN6DH6PZFmzkJ1cEv+cwrF3Wo78/uautNWlj8xuPz8px5L5iIasld0Aecxa04TofjT3D5iHMch17r+GJ6Apy6YKe7RlzsicWwuyyV98nMXjHXOu3Dt5bl081NyfE8nNCV/hbJvKe9SWqVjG8GRxbiYVIKR14UOltFLt6X0f9mdSbjp3oOP6s6mqxDhB3cL/KHJagvts/pGi6btcnt/hKv8Iph+tjmyobPkF7ahqq76ldRicxLscXZaw2/RZQi8bl14qkwFa6atvTjWb5H8pt17f66J/sfDhnxa0bqv5GX6Lb/6PAg4gd4rWEQcSFSFZNsKLT6xiRdsRtdyP/a+Z0F/vL4OOT+BjMqurNpvNb8ZbY5khqVlXc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR05MB11233.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3fRgNY4AZcrv55KIblw6kFtrkpqDTk4KRX2R9tPRjd0GiHQegGN4GnNy4Cdh?=
 =?us-ascii?Q?RsuPk8z0DLwGV1dBJKc9J6cl5X364KsvYIv8Bhb1q696lzuZf5lCX2iokk+o?=
 =?us-ascii?Q?NGobAkZ0PUCPqV6NearZhpzKciCwGDv/mtxIMkZLKZUaRt26ySIU+ZzjYtc3?=
 =?us-ascii?Q?dS1OysktEwpowHEGhhDnTaBpAQY6QvWIOpPe225l8Pwg2z6IaCFtNvu/vST2?=
 =?us-ascii?Q?AhQ7fByQNSP01AOw7onyW/bAZ2XSTCo/L38Ldpre6qKlExFXJ8oREtBgIrW0?=
 =?us-ascii?Q?r2yQdMQs6nnGC20wRVaArHbrbRAgZOu7hkZyXIkT+lMYdv4Chl5iFbfAsw6U?=
 =?us-ascii?Q?pZI5DpB4bKq6lzjVYIxzwFdyyPU4xZ+VnB7bkapcy5G/cxVhpNzJzYM9SXcS?=
 =?us-ascii?Q?jQ3Or6Jm2Khdi8FMY2W40EA3WkfJMIR1TMlr2t0K7u11G8xIldauVRzbd9+D?=
 =?us-ascii?Q?DwqvbRK9pJ7UK5cdnZOVzmzQaxE9IbGqZKIahmw1K/ntYRMhVpTsUNDq/6wy?=
 =?us-ascii?Q?I8hhavC+T2RHWPlm41+gbzVIz3k3+6bho4iioAvZ4daU7KhSohbzqXQGbLSv?=
 =?us-ascii?Q?g3LVPdHBxDI56VZ72pNNbX67fmD4F5y1O9jWbOXwFSi5/MV8R860W0HnllrQ?=
 =?us-ascii?Q?I3FDPsykPPR2Nt1f3rOdXGTW/vIQXxbBdH91tmft9Vdxib/UELE2okeYY5jB?=
 =?us-ascii?Q?hjzmoPt93UuSVjpLb6dQ6CbxohQ7X/WsNEd+GUv8Ww2a+Cmf1VfflPx3tLXV?=
 =?us-ascii?Q?nCEzZ8W0hJlDWvTVCJmURnflhMqe7sNWKG8zNrQgeUIbaiaQvYQodnw6ADn2?=
 =?us-ascii?Q?zVdbGjGblOr01aLJotb+w01sceQO3gy6g2aHhaY70wxprF3ml8OyHQVa60Nn?=
 =?us-ascii?Q?7nt/kUxwOpPjkD2GeAWdx+iIEjOQ2IQ9wEbSoQL0tN5NhGk/UQRVL0HaxVoZ?=
 =?us-ascii?Q?Subd5TAfenxzfory8peXsDs3Z86O1XikqOXWpqNmck7Uh1852Q8XOmutZHmY?=
 =?us-ascii?Q?UZG5Sz58OCVzR6ZaDyihll/ofcQNaqxigqlh3Oz+Nm1zOtmIQuN33TRJODqZ?=
 =?us-ascii?Q?ctPYBDetAyOE4h/oHRi261G4Nqhx24Y/LYjp3akssi+klBJFN8NIeB9XvpIb?=
 =?us-ascii?Q?uFO2pLKMmaveuYWmfcumr/EnCV049+3uG2rqc5D3XqeEHx9+IFlNEQoBeqCf?=
 =?us-ascii?Q?UK0LNK/ZyZ4Y9r/vXQHBf//nrsM1opM32YZYTsZitnqXFXoJjYl+dRscxAFO?=
 =?us-ascii?Q?wYLaprqPBn+ohGa0EJ54ajL8KuRcq+LxHVnjkn4hoSilTiMhKsZWh5ngfSHe?=
 =?us-ascii?Q?94n4lM3drpSlS0GMKfntAXZVIgO0A17dQX4ppEcjBFaBJ40XAAc+3QEij2Pv?=
 =?us-ascii?Q?8t8MZkAtNqVfWl7Odgot2H9QkR21ICBMCvgIGQglCevLjeWNgQCrYMKllqVN?=
 =?us-ascii?Q?hDf/HWwF3eRks31ainSuXClHzUkub3FadJdcQriIHWGe+XXGoErdpxwuJJdC?=
 =?us-ascii?Q?/V3KLPvJbZoWsBaPqbbU/Rsu8XaX4ECr7uOQKdmt6DN8jPK+lpUZE0Kd7uHT?=
 =?us-ascii?Q?VlX3qCktxLNHCSLNJd9QrYkatxbRW7vd/4sbpcy9zmpHwF00+6aeFaVaa6rj?=
 =?us-ascii?Q?iQ=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 50cba089-65ae-4297-526e-08dc4732f076
X-MS-Exchange-CrossTenant-AuthSource: GVXPR05MB11233.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2024 10:05:28.9983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XrnQNtum8lbnEy7/1nzd+xQ+N+C5KNq3+cIeCraHfxIM/ZrAY7wetJdYd3QlrLiwqH+ily0ePO9AOtj+c2JKvGTTRrAxCa824RPIzCN0qUc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR05MB11441

On Mon, Mar 18, 2024 at 10:39:15AM +0100, Pablo Neira Ayuso wrote:
> In case that either FIN or RST packet is seen, infer current TCP state
> based on the TCP packet flags before setting the _TEARDOWN flag:
> 
> - FIN packets result in TCP_CONNTRACK_FIN_WAIT which uses a default
>   timeout of 2 minutes.
> - RST packets lead to tcp_state TCP_CONNTRACK_CLOSE of 10 seconds.
> 
> Therefore, TCP established state with a low timeout is not used anymore
> when handing over the flow to the classic conntrack path, otherwise a
> FIN packet coming in the reply direction could re-offload this flow
> again.
> 
> If flow teardown is required for other reasons, eg. no traffic seen
> after NF_FLOW_TIMEOUT, then use TCP established state but set timeout to
> TCP_CONNTRACK_UNACK state which is used in conntrack to pick up
> connections from the middle (default is 5 minutes).
> 
> Fixes: e5eaac2beb54 ("netfilter: flowtable: fix TCP flow teardown")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> Compile-tested only.

Thanks Pablo, I will test both patches on a production system this week
and give you feedback.

Both patches look good to me though and should fix the timout problem.

> 
>  include/net/netfilter/nf_flow_table.h |  1 +
>  net/netfilter/nf_flow_table_core.c    | 45 +++++++++++++++++++++------
>  net/netfilter/nf_flow_table_ip.c      |  2 +-
>  3 files changed, 37 insertions(+), 11 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
> index a763dd327c6e..924f3720143f 100644
> --- a/include/net/netfilter/nf_flow_table.h
> +++ b/include/net/netfilter/nf_flow_table.h
> @@ -293,6 +293,7 @@ int nf_flow_table_init(struct nf_flowtable *flow_table);
>  void nf_flow_table_free(struct nf_flowtable *flow_table);
>  
>  void flow_offload_teardown(struct flow_offload *flow);
> +void flow_offload_teardown_tcp(struct flow_offload *flow, bool fin);
>  
>  void nf_flow_snat_port(const struct flow_offload *flow,
>  		       struct sk_buff *skb, unsigned int thoff,
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index a0571339239c..481fe3d96bbc 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -165,10 +165,22 @@ void flow_offload_route_init(struct flow_offload *flow,
>  }
>  EXPORT_SYMBOL_GPL(flow_offload_route_init);
>  
> -static void flow_offload_fixup_tcp(struct ip_ct_tcp *tcp)
> +static s32 flow_offload_fixup_tcp(struct net *net, struct nf_conn *ct,
> +				  enum tcp_conntrack tcp_state)
>  {
> -	tcp->seen[0].td_maxwin = 0;
> -	tcp->seen[1].td_maxwin = 0;
> +	struct nf_tcp_net *tn = nf_tcp_pernet(net);
> +
> +	ct->proto.tcp.state = tcp_state;
> +	ct->proto.tcp.seen[0].td_maxwin = 0;
> +	ct->proto.tcp.seen[1].td_maxwin = 0;
> +
> +	/* Similar to mid-connection pickup with loose=1.
> +	 * Avoid large ESTABLISHED timeout.
> +	 */
> +	if (tcp_state == TCP_CONNTRACK_ESTABLISHED)
> +		return tn->timeouts[TCP_CONNTRACK_UNACK];
> +
> +	return tn->timeouts[tcp_state];
>  }
>  
>  static void flow_offload_fixup_ct(struct nf_conn *ct)
> @@ -178,12 +190,8 @@ static void flow_offload_fixup_ct(struct nf_conn *ct)
>  	s32 timeout;
>  
>  	if (l4num == IPPROTO_TCP) {
> -		struct nf_tcp_net *tn = nf_tcp_pernet(net);
> -
> -		flow_offload_fixup_tcp(&ct->proto.tcp);
> -
> -		timeout = tn->timeouts[ct->proto.tcp.state];
> -		timeout -= tn->offload_timeout;
> +		timeout = flow_offload_fixup_tcp(net, ct,
> +						 TCP_CONNTRACK_ESTABLISHED);
>  	} else if (l4num == IPPROTO_UDP) {
>  		struct nf_udp_net *tn = nf_udp_pernet(net);
>  		enum udp_conntrack state =
> @@ -346,12 +354,29 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
>  
>  void flow_offload_teardown(struct flow_offload *flow)
>  {
> +	flow_offload_fixup_ct(flow->ct);
> +	smp_mb__before_atomic();
>  	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
>  	set_bit(NF_FLOW_TEARDOWN, &flow->flags);
> -	flow_offload_fixup_ct(flow->ct);
>  }
>  EXPORT_SYMBOL_GPL(flow_offload_teardown);
>  
> +void flow_offload_teardown_tcp(struct flow_offload *flow, bool fin)
> +{
> +	enum tcp_conntrack tcp_state;
> +
> +	if (fin)
> +		tcp_state = TCP_CONNTRACK_FIN_WAIT;
> +	else /* rst */
> +		tcp_state = TCP_CONNTRACK_CLOSE;
> +
> +	flow_offload_fixup_tcp(nf_ct_net(flow->ct), flow->ct, tcp_state);
> +	smp_mb__before_atomic();
> +	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
> +	set_bit(NF_FLOW_TEARDOWN, &flow->flags);
> +}
> +EXPORT_SYMBOL_GPL(flow_offload_teardown_tcp);
> +
>  struct flow_offload_tuple_rhash *
>  flow_offload_lookup(struct nf_flowtable *flow_table,
>  		    struct flow_offload_tuple *tuple)
> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> index e45fade76409..13b6c453d8bc 100644
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c
> @@ -29,7 +29,7 @@ static int nf_flow_state_check(struct flow_offload *flow, int proto,
>  
>  	tcph = (void *)(skb_network_header(skb) + thoff);
>  	if (unlikely(tcph->fin || tcph->rst)) {
> -		flow_offload_teardown(flow);
> +		flow_offload_teardown_tcp(flow, tcph->fin);
>  		return -1;
>  	}
>  
> -- 
> 2.30.2
> 
