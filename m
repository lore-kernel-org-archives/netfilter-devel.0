Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2100.outbound.protection.outlook.com [40.107.247.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3AB43AC8
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Mar 2024 15:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.247.100
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710342424; cv=fail; b=QJhUUhjziB41S6z8Hxvu2ck0uZgJNWA94A4FjTKmUbnPs53jYddhuedhzGhib9qQxKlbXbNN6EkTXRodjHt9wIDWm13ty12ToeM7MWJEMlGIHguq5RHtyJNbsErAUQiXQjXSf3MNlj518vw/l7PaANnsTyKf2HF40dydiQg4n8s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710342424; c=relaxed/simple;
	bh=gdXJCkQcCMNZFyVHGCqbmcJpHTEV8hrWtMZkB4cvQdE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ss7SbGvSnpBRjTxzDAIRa7oLemy3dkyOYUMFF3CByR5o/NWI0KDX7I8lgAzwlaI6YGcXIfK4yPqDz2ANZk1XYzglLNBtIEniLgwj/ZweFUzPUCc/72wts2iVIxGhCyTkRXL2hQpl2NjYQQABhrEOmEZ6la2g52CC4klJP3TcpQk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de; spf=pass smtp.mailfrom=voleatech.de; dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b=VVeOQ9xc; arc=fail smtp.client-ip=40.107.247.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=voleatech.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="VVeOQ9xc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AhR3eNB5/+yNKE05FsNsC7mGwE6M60XkWunHRIcOdq2tMqYHXYFEyqPyWDigJ6P3AAhHmEyN2eIiJ1O00LpaARPshg/rUT+zPn1caJ8CQ34aQyclGLurXK1BYL9duGrpwNoLf4kkPmo5qBjCG8ljwTSdm+Ae+n8CTHdlp4ghp3CBie+67ZDAuHvJpmJO15Zxt1IjEj1kJXa6sKqfEHLrasN5vsWoy/pHnGFOqGxl3NMcfyGkmBXiPFGSDAvhpHjiWnSE4AdYsvQNW19OkA4vU8u5K5skLxefGYy9CBDv9Ovaex3B7ZTa80EQI39KWVh1V1ryxsCa9TWnVp1I0C5tRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3a/X4Qj+hyNOA8Tu6kiERdWLwFMIk8iL/CoLRIwoSeA=;
 b=UZRYkIhaCTxt88An9O3sE+urrr/yhhoLaDpWCM9icEur2VoQ+RlwnZCV5xkt3h4sqQVm3KelrmPX7rm2MzjBc24/hw22RcP+MY75uHwW6gjvglJWoUu5zTj0ooJF3UYACbxF/cM+5jUT2CKtuAjYqUaOXqsCyH6pvBapyhPLEg258g2MTO6COGl2J9ewsuHLnIFpL07vbesjC/1OfWFd+zUoXQwkOMGeqzch2W+5SF0QQtXLfiUL4AOZ+IoFii8swIkxtS5/cbp4zDJcXc7N0W08GwRXDF7WfBnPu4RmpJyPVLjYsiZi1f4RfG+tbdMUslte0Qhu/soOMZtIW9+ZCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3a/X4Qj+hyNOA8Tu6kiERdWLwFMIk8iL/CoLRIwoSeA=;
 b=VVeOQ9xcCnJLbZgD8Bu7wGKsS01lWqA4FNWf/E9Ih1NPifyyWf45NxPaLQhjowu+a9Q2C1ZnLtoxQblyu5N7D09efyzphJGshTdx2xnaItvUzWHHRVcoY7WndcDO301H56b0ywIpJ/kpK2dFCUvW9A4K5ZVeFAt7zsOb19T4f+o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from GVXPR05MB11233.eurprd05.prod.outlook.com
 (2603:10a6:150:14e::13) by DBBPR05MB11275.eurprd05.prod.outlook.com
 (2603:10a6:10:52b::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.36; Wed, 13 Mar
 2024 15:06:57 +0000
Received: from GVXPR05MB11233.eurprd05.prod.outlook.com
 ([fe80::9d0c:55e:de01:2a2b]) by GVXPR05MB11233.eurprd05.prod.outlook.com
 ([fe80::9d0c:55e:de01:2a2b%2]) with mapi id 15.20.7362.019; Wed, 13 Mar 2024
 15:06:57 +0000
Date: Wed, 13 Mar 2024 16:06:53 +0100
From: Sven Auhagen <sven.auhagen@voleatech.de>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: Flowtable race condition error
Message-ID: <yyi2e7vs4kojiadm7arndmxj5pzyrqqmjlge6j657nfr4hkv4y@einahmfi76rr>
References: <x6s4ukl7gfgkcap6b56o6wv6oqanyjx4u7fj5ldnjqna7yp6lu@2pxdntq2pe5f>
 <20240313145557.GD2899@breakpoint.cc>
 <20240313150203.GE2899@breakpoint.cc>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240313150203.GE2899@breakpoint.cc>
X-ClientProxiedBy: FR0P281CA0223.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ac::16) To GVXPR05MB11233.eurprd05.prod.outlook.com
 (2603:10a6:150:14e::13)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GVXPR05MB11233:EE_|DBBPR05MB11275:EE_
X-MS-Office365-Filtering-Correlation-Id: 046abb32-40a3-4dc1-92dd-08dc436f39f7
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zYfVw8XoJ9n+A2QQ+4mNVrkxG7xBr9SR3PqgTDWnzHHBQztu7QryYVBIMmb69f5WDzO+B7C3yO+nhnUnOaIlywKxBkTcgwSXph9qpxGkBLLbxRn4Zqou8CejvlPkK5MJK+O0wcSgjdAIufJv+0x8Zv9ieb7OZqeAmShrdGgiwnWHOTnZZNVUp/qGHs/tgqQLkdyVrZg31mFZaoLTbKRok97SC2G4bVmJqHjmZnImpNwFvPumku+vt1DBXuFCyx+SxqJrjoQZJorDfXmE+qgCgtWk8HoVPrBeDvLz9FT31UgktbQBYHSQZS708O/AuHIcDF8WhapIs9RtJj9QAnAaVJH6EhlV9vQuIbqEhMAqD+6OwdAMUWxsVVHIx9IvRcCGMAuL04dvNB/q+cUxfv1lsY6i3fUhFWIlUepdGo3z0PGjuXCE6QfkkZFNNO85Cob3O7qO55rLaJujglcfBa7drXKQoGd68ioVIrDUpxJqjLW7cPpYyjsvaIx4vC5aluPuqDI/8jZdga6kD7Xi8105dDYF/AzlJEFKbsP40gUKqrITN5eTs80aUXFQvJQaOOJ8RC4shFlvUpIuYW4PBgUQPjV2iHGaoyFN7P/FHUWQfx2igGdniKzTFfs1zVwe4vJ1/UByckHBlF/bWwnMsK0aZ94aFLjftPvuCIPBgMbfkzk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR05MB11233.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2sQO7oYT1f/8BvhGXj3PjGTf73pBxqKjV2HMXnIs/8EBwJ1HK6dzav1eclXa?=
 =?us-ascii?Q?4IvUVD/Bqbs9qRsNL1Ivk+3jZzCGomDLLOFJ/Pn8zx4yfe/+4/1Elgv88mjh?=
 =?us-ascii?Q?1GyztF41oXgf1yJ7g/uOIWDLGasTj9/U35lxDWfgfQHEH9fWKA90DnVRM6aK?=
 =?us-ascii?Q?uMcRRf7uqOUAjOaeA36Eh3S6uZ8MisUQo9LqgyRm+6uAskeBYKl07C2M9WDF?=
 =?us-ascii?Q?avpCsyDLaX93n2aWB+qjGGP45LuuCv+MxwRlwnkDvnUJ+fAxB1S1CyBU8GB3?=
 =?us-ascii?Q?6zKhne4EmCFU4hfH3ulfylKFMv7sTg0AqbJ9Pfa0Qv95bY4DE4p8a6v/JAgW?=
 =?us-ascii?Q?VLooO8Ths9F58Oh1PnY6haFZNvWoKeHNPKvuNjWScorBdhnQIcS1rblJfy1p?=
 =?us-ascii?Q?vK26YirnA8LHoMUSvnoxXiLT6oYzJJSnpU2nwSQaghLr4rPh/Hy6043XVJD0?=
 =?us-ascii?Q?bit/dhvTP1u5VTgPTVLB/g6Q+MfAg9O5VI8/YZDOULHt5ENMGxJDQt7XGqHd?=
 =?us-ascii?Q?H7wmc2mlWdDtuLPSmgeSGzBWHULjMIPInPWFWoJAuSgQAjrTGX523MQV2ipx?=
 =?us-ascii?Q?iOoH6wdsf4+kln8Iew0WxLhj7fc7y+7QbO7HOPGwK6i00ynB+ogUns64Wdrh?=
 =?us-ascii?Q?T8+Z8BpL9KcbWiAhsvaq8aXpts8xnxIfyiVQR6G4OobCzAiBG+a6QLBvtaSB?=
 =?us-ascii?Q?p/1Y3ljQe5ISMoasqljgEyZxEEnsQTwEfvSOAg7h2QPMAURKpououaCNF3tW?=
 =?us-ascii?Q?ur/LiW+E1XxgOT9iCfEs0vnBqYjZX0fU4sBiOu3upl4l3yq92dMuTX4DiqB5?=
 =?us-ascii?Q?MCrsc8XkNdQFjj2U5BGwJrd6WvRvpGV8rCZKJVgWEv2dP7Ga2eC0kk1TjgRH?=
 =?us-ascii?Q?itFdwwxvmeW2tzZSQgQYW64+fRRPtOoS06JTZR9hJxZbXbUfQO+Dn2EOFXIb?=
 =?us-ascii?Q?6uA/bcognt6V/ZrsYzxdk4fJ8HX+kQEp4XYe2ERWiwUJs8l9cQPBVScqdwmm?=
 =?us-ascii?Q?uuRMQ8d8fhuTjvqwzb+GdEyapCbvzp3Nm2KhaPIYGHkAGlrEpjgeTNk+y+zd?=
 =?us-ascii?Q?NrFae+Yf+cH4bThUnPVjd4Ys695Cr/SKGJDQbv6AV/Cu0zjY7Ca0HpBZ8j/A?=
 =?us-ascii?Q?v9V3yQMtdMqP4UDwkq3pw1VnJvOcGy1sGd+yxNgblZXwpK8PZV6xxq51hs6w?=
 =?us-ascii?Q?XISyY1RM55difSzp3GAzaqbbEkXH0DNQ7P2zucZMzuIUKu4NOOQJ3OB09Dt0?=
 =?us-ascii?Q?Po/ZdSQTizPLKqXI3vpe18mrnpkxJ8+o2VJGsKEOMpINnal+kWpgJuDkkZNd?=
 =?us-ascii?Q?ZKZ4I4AXsRN6b6zI5bwq+11Qa3djpZxSpzRB4sUkm4NsH5nijh0V4bCPDLcN?=
 =?us-ascii?Q?24N30f7j314E6hLRNB7GKrq0JZVtQjPtKMZFNZp5IVeeCzjA6JTEb+JhkB5t?=
 =?us-ascii?Q?33jbd1zBW4DE4pqI4B/qfCDwELWrTGIC5nEUgkPTdvcbYXfgY6mSPdEWejAw?=
 =?us-ascii?Q?8tgDlfv8qG3uXST3tPftkUmnlfrPsHOajgQwSBwmkUOe1wQFZ8Ma47hOCYu1?=
 =?us-ascii?Q?vkmJUCG0GyCF1UVnCdvIicnsuUbowsTWt+jHTQxLPPdLhpF0euh/ZYrCveJd?=
 =?us-ascii?Q?Vg=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 046abb32-40a3-4dc1-92dd-08dc436f39f7
X-MS-Exchange-CrossTenant-AuthSource: GVXPR05MB11233.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2024 15:06:57.4539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WuAM8UH0uvJGLeIbuV7k5uzx57LoUzSDxMnKPa19H2c3BlakQ6VxYyqCiu6aKuJ14eko97XPZZMYTwuIeJQDHKxHeNc0ulAyunRjSAQLoT0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR05MB11275

On Wed, Mar 13, 2024 at 04:02:03PM +0100, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > No idea, but it was intentional, see
> > b6f27d322a0a ("netfilter: nf_flow_table: tear down TCP flows if RST or FIN was seen")
> 
> Maybe:
> 
> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c
> @@ -28,10 +28,8 @@ static int nf_flow_state_check(struct flow_offload *flow, int proto,
>  		return 0;
>  
>  	tcph = (void *)(skb_network_header(skb) + thoff);
> -	if (unlikely(tcph->fin || tcph->rst)) {
> -		flow_offload_teardown(flow);
> +	if (unlikely(tcph->fin || tcph->rst))
>  		return -1;
> -	}
>  
>  	return 0;
>  }
> 
> ?
> 
> This will let gc step clean the entry from the flowtable.
Thanks for your answer.

I double checked and the problem is that the timeout in flow_offload_fixup_ct is set to a very small value
and the state is deleted immediately afterwards.

I will try out this patch tomorrow:

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index a7a216fc3207..29c6b9eef50d 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -195,8 +195,9 @@ static void flow_offload_fixup_ct(struct nf_conn *ct)
 		return;
 	}

-	if (timeout < 0)
-		timeout = 0;
+	// Have at least some time left on the state
+	if (timeout < NF_FLOW_TIMEOUT)
+		timeout = NF_FLOW_TIMEOUT;

 	if (nf_flow_timeout_delta(READ_ONCE(ct->timeout)) > (__s32)timeout)
 		WRITE_ONCE(ct->timeout, nfct_time_stamp + timeout);
--
2.42.0

I was able to mitigate it by setting my TCP_FIN_WAIT timeout to 240 and now the state is not deleted immediately.

I think in general this happens because either the packets come in out of order or there is a double FIN packet.
I am not 100% sure about the cause and it only happens with a small amount of connections when they close.

Best
Sven



