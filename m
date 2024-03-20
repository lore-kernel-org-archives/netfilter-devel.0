Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2107.outbound.protection.outlook.com [40.107.14.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A4F282F7
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2024 08:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.14.107
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710923968; cv=fail; b=IR/O3FQnNa6I1MKaIk0wWGX/w0eR/ug30kDaZN89wF0KMg0CQYpXqsjgwlnUP1ymGRQqkpW0MGWQ4C7kqw0lUqYoWTWJNLENvOE7cZJ1eVR4A0JCzfl+m5xp39jTmpOLAM0bZWqLVHYoy4te/JDzkodup7K5Hp/ag7ps0pek2xQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710923968; c=relaxed/simple;
	bh=qm8ZCiin0DSa52PemSDvsZiu8PphYCUZUTmi43gY1lk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=P8qZ63ywQLoc6d43o1j/Nd+Z4l5Vu43crDg1qGvYhAIMFtkj+fHAMekZAHzENvCytBtMfYrHbAfgfod1/0cTNm6jvDeqpH6t+pRJrDIq84v8EcYinSF6g0t1KoQxxxC4lTEnxxiIZBpprChoacWigQ87xfTbqdQ48Hq29O7PaNw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de; spf=pass smtp.mailfrom=voleatech.de; dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b=fFkPvMeR; arc=fail smtp.client-ip=40.107.14.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=voleatech.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="fFkPvMeR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cip3oIQ1TUCpvHyUg3hQ8T1HqydOu/0TCZOAe37mYD3x5YTISeraUznrErzKb/fXnVxFLUVN8IzPousFo5mm4srU0WwJ1asIkPbaG+LyjkBWjv59AYivfLsMlOAAenWM7xAZDuOWZCRKuPPfydD5hw1idFkWYPyfPbme/2sqqDDayzMJdgsiWc4Nw1UaeyqcPPv/JPa4BtoYe3WgIv0AlKsrPyZnfeGzymeIiSSufRo/h39LJRsHNXAsinDVwPz9E3VQZm7LNlIcMuidwrgwHrkFfn8mZ5B82/fT/0jP7RHAbS/HbEIZ+ASHP9rRpBnSqnI43i5TnJnMWkwldOiOog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QZ/R5az3m9YgHx1d0zJ2LCV5u5NsQ9zkuziCiBLkoBI=;
 b=k6TPhgO+phn5Wdm0blbVlMDHgKbEkAzfBtVR/7c17CmR+hQcs2xi5evew76xMGXIsU5uvbJw5wjQ19tYDjYzEgM0HMadK2P7H2SIm/PwvWW9PnWoUHygIgmrB/JKMV3f4MN09j8OGEx2dL+XyQaTDyD7qRGdCO+17wWJsEDIC5wS0UjqJtub+7myUfxKX5K5pqyOAcaJ3NtCedSi0P9O4RZ2LpZF+5e79oOAXHgB+NrWBNpXgZ2bj23ylPQC1RPDDtGzThsMp71rY8s6fVOJNuQThJX+7oRzbgHwKNRqNqYMq1spl6q2xTF6ePwwwSsO0GmT5U2leI5bGKhFjf9rVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QZ/R5az3m9YgHx1d0zJ2LCV5u5NsQ9zkuziCiBLkoBI=;
 b=fFkPvMeRuASB6up+FwutRDGmVsSG42Is8vjDbxmj36gPtPwqe8dInpCOhBWqByjqd0KuTvrKDGsCXjv+tkhP695FJiH4iKVItvlJqzGVkY7BVHksRKqfUtNQNAgSgLQvK1WkY+f5IHo/0u4PwMoUm9qvddr+CwgbC/3+9fNI5a4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from GVXPR05MB11233.eurprd05.prod.outlook.com
 (2603:10a6:150:14e::13) by PAXPR05MB8512.eurprd05.prod.outlook.com
 (2603:10a6:102:1ab::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.31; Wed, 20 Mar
 2024 08:39:21 +0000
Received: from GVXPR05MB11233.eurprd05.prod.outlook.com
 ([fe80::9d0c:55e:de01:2a2b]) by GVXPR05MB11233.eurprd05.prod.outlook.com
 ([fe80::9d0c:55e:de01:2a2b%2]) with mapi id 15.20.7362.019; Wed, 20 Mar 2024
 08:39:21 +0000
Date: Wed, 20 Mar 2024 09:39:16 +0100
From: Sven Auhagen <sven.auhagen@voleatech.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, cratiu@nvidia.com, ozsh@nvidia.com, 
	vladbu@nvidia.com, gal@nvidia.com, fw@strlen.de
Subject: Re: [PATCH nf] netfilter: flowtable: infer TCP state and timeout
 before flow teardown
Message-ID: <zxdruu67c2xs6zrhagjilitxu5ysik5x7zvk3kthzcclype22c@nevv7c7adz7z>
References: <20240318093915.10358-1-pablo@netfilter.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240318093915.10358-1-pablo@netfilter.org>
X-ClientProxiedBy: FR4P281CA0414.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d0::7) To GVXPR05MB11233.eurprd05.prod.outlook.com
 (2603:10a6:150:14e::13)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GVXPR05MB11233:EE_|PAXPR05MB8512:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b8468cc-1503-4e39-1ec4-08dc48b93d07
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	BdggXXG4GeCDETIWrD9FmaD0h22rOKSBT/Z98C55CA7XF49JS87zud9KCAqpIfr14D5e5SzdaEJxoWJaFtrYfZVh5C9+dxJd2ze32xNJYjCYi4lv4rY0DaXhBIXXPr2ZnbFWrnZ/nGyOeebSNwDUnQxpGELu/J5tSwc6BXhyfSj8muQi8O70d3Ub9Qvw/Nnw40Go+RDi8z+ALpedAufaffF+w6GIFNHKNqW5+DPqZ0kngpuJEgv37LbxTbsXY4WxCKskxuOH78SaU5NIhOS6AK3l3sMBxoNOENvfNs1m6AhF8qKk47DHS6eWJUoYWMS0ipuinuZTv+PQuro0wLcYHW7N7muaqVCJxq+vTAnWtogxxB/sjHW3T8k9Ck0ywCcJnz4kiSECp8RSPyHB2/QRh60PnSPuvFUsclEQg8NseLyn671rHBZzKloBYyztO+tyZGzQfeUeaPNpMNcjrHS80YMUWRupMby2Y7+k8s36x0vfIqtxKcrNm1A7ZV3beuTuBr8NYpMKEKxjZRpj1K6owtJc/z93CI4vCisO50Rjdg3ZsrCtuTFJM2sgoQ+ted27oaeSR4xzfbVH8RgEFd4VZdpjc7cxhAHNSDbZNmKMzUJnAlJXgCuSFPoitNRcJSdCe4CaesWOKVCGQRxbw583RkZ0TzgEkLLHhQtsTwTv/pg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR05MB11233.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KBkydGl7ConnwXMcNBkEWlLC7jcQTc35uT4Qj5l4BuaQyEAvWl7OeBI76PQY?=
 =?us-ascii?Q?f+zVKfRacSjP+2Y2uDN0FRRo2roDyebFC1j8E5p6HtnjKcr4giuwRIIqwCT4?=
 =?us-ascii?Q?ri/zNabnZdd4w/7QDMJVDcW5VJA2eWSD2ANgpUnHQqVtuB2y3ouxRm5uzT6l?=
 =?us-ascii?Q?GWw0Ccg5RbRqyk6fqlopXBrLJwRmPOBwZNNdjtg7qkhh6PsN8RSiz8HoRdaj?=
 =?us-ascii?Q?GGPvEJeO26+FValY1wpqpz1BKPrZe76jm2BBLblezR6Re79LWW6BK09g6Ck/?=
 =?us-ascii?Q?MTvqwK9WTuLny5Ks0yzTNa/MCG1OcUOzwkdx/UG877fVLSql7NgPar2bp7PX?=
 =?us-ascii?Q?z0S+TvHiJcrExOa2C0UKK8BqP1wKfhaHV3xJz6iBc0svE6cgumrmWMt68plu?=
 =?us-ascii?Q?pb34C7y0JAtAil55REcL1/zWo5r47u+eYiXELiMSoOwYxn28dyO3ZUKXbCAc?=
 =?us-ascii?Q?H6lJiXD6w2WX649T1S8ePJRWuX4XeGGsiP2qaNopdABb//KdHBqWbzy5HrSV?=
 =?us-ascii?Q?afGVJzttXVkt/Nen4XyR7A3Ywe2xoYn/wbMrgftnf0GdVkmvOz5b9UzKSrhN?=
 =?us-ascii?Q?5BH1IktiSKs6XfbYPwNZ8qReLIUod9NIQxsLK1g2Vr5cNpb6ek3ekfnJ5C4g?=
 =?us-ascii?Q?HYsn70OIcX9XZrhfNT9zX4DzV67JJTcTtHpADalmoMf9NPYgBJg0KUPDQ3+h?=
 =?us-ascii?Q?87I5IR1H4UUzPg3vpxe4vhMkjlu6EqRaBILLuGHFIEsulg8mGhE10Cs+myi4?=
 =?us-ascii?Q?vTcbsvbF0p4ZMRRDunTpyrgaHjtjASlEV5yqoWksHzWcqiiL157NBVBjMwyO?=
 =?us-ascii?Q?WALaMXeTGGiohQVDXxcaq0/ZFu1B2ZGL876Xzmidnva0ORJ8+Y+TO1AvacYk?=
 =?us-ascii?Q?sKO5qy5yztCPAEeyLAS1AgtWFu+ENLN1no++SpXJwzA/F7LchY3sW554rl3i?=
 =?us-ascii?Q?TGuqN5Xq2vzfJYcRfNopiuiR9Abv2xV0Tx/ZOvuwaW0l9jO9agGtR5qYqKau?=
 =?us-ascii?Q?EtcGoFWneRUNiyZdwZliBxfrCVlUVYnt5aLqL+9JSxE4zs/jlsKh+vKsVRHb?=
 =?us-ascii?Q?cxSmShHu5R4jLbX4mvdUOGnkXsFipgo5CZInR7MxBseS1sIPw7yS6+s5mpi5?=
 =?us-ascii?Q?3JBoTtlFVkt/QrWfeVVyQReRnQueHZ3EHzjpS1iSVCqNRDZ/HtRjF4cOy+mm?=
 =?us-ascii?Q?QTDdkR6FTNmXh31Ioxnea2R09WCUKMu/lcLuA8urgzmSvTNeqU2qoPkaLaru?=
 =?us-ascii?Q?ewZgRgK33kWzroScgYmcUtEglxYA8rf52ZIQ/c0WhlRfy99ggmDH8s0jyLJy?=
 =?us-ascii?Q?oIxipv6aFPDAEpPnML+b4hckztXYPPxn2lj+RYYk2jPIp/HNpo0RfF//cV30?=
 =?us-ascii?Q?FpKHzNXSK1x6i1fVe7RM8z6yFCZJYrxVFm2j+U1NCjvac0AGh3niOVC5z25z?=
 =?us-ascii?Q?AE4gAkD1QfbMIGszI9vpbhpbySd3NuZrNV/hkpilOyiVQHkRR74mI2wkyBQT?=
 =?us-ascii?Q?qpcMnFaEXXit7po897wYy2l/vIDbMDGA1H0nx2G9MiOlFO32geyweorUDQb6?=
 =?us-ascii?Q?MGYRWfN+e/zkHC1zB38aHvw46K7+YBZEt2+B9RYBygkKM70J2HEo9ttyMYP/?=
 =?us-ascii?Q?qg=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b8468cc-1503-4e39-1ec4-08dc48b93d07
X-MS-Exchange-CrossTenant-AuthSource: GVXPR05MB11233.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:39:21.1569
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2qEsH43SiFcjH3oZaceKFi5XAnfUufik7oP2lu2ivgReNZXZqO7dwc0Q5SaJXcd6BB6LNnWuUVGBE3To1mLuB7KjTNaXbMSPVFB1Pf3EcUY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR05MB8512

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

Hi Pablo,

I tested the patch but the part that sets the timout to UNACK is not
very practical.
For example my long running SSH connections get killed off by the firewall
regularly now while beeing ESTABLISHED:

[NEW] tcp      6 120 SYN_SENT src=192.168.6.55 dst=192.168.10.22 sport=55582 dport=22 [UNREPLIED] src=192.168.10.22 dst=192.168.6.55 sport=22 dport=55582 mark=16777216
[UPDATE] tcp      6 60 SYN_RECV src=192.168.6.55 dst=192.168.10.22 sport=55582 dport=22 src=192.168.10.22 dst=192.168.6.55 sport=22 dport=55582 mark=16777216
[UPDATE] tcp      6 86400 ESTABLISHED src=192.168.6.55 dst=192.168.10.22 sport=55582 dport=22 src=192.168.10.22 dst=192.168.6.55 sport=22 dport=55582 [OFFLOAD] mark=16777216

[DESTROY] tcp      6 ESTABLISHED src=192.168.6.55 dst=192.168.10.22 sport=54941 dport=22 packets=133 bytes=13033 src=192.168.10.22 dst=192.168.6.55 sport=22 dport=54941 packets=95 bytes=15004 [ASSURED] mark=16777216 delta-time=1036

I would remove the if case here.

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
