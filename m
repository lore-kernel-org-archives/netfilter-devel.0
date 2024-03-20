Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2103.outbound.protection.outlook.com [40.107.241.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69DF2D79D
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2024 13:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.241.103
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710941883; cv=fail; b=r64UB+4L2AX/BkkM3ptLrNGxVD24YbK3FL1ftXhdh0tikAv4kZ5+rPpYOnd94IQc3fE7EMt/3vGonnrd3RfKbJt8tcNSf3ayzqUN/wcMZhzjwW+du4z9wpf+MwwWw66gnnQn1ar+3FenOmekevEajsKmgVpQnMMNnNYzpA3MiIU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710941883; c=relaxed/simple;
	bh=lxcZLHvKALPpiNVDvZJcyY1JOT84u3aJgI9EP17FXLY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=YzhFT33xRiVffi4HnZSsL/WuCeW/KYAQoH1L/rLrFdWxTcSInGz08/KfQFvf8YEFiUdozXxZRSzDbUV3oq2qoE43AGeLJB5msWFd4jfZo5JNYQiAi8cgYu4lh1P8ETckxF8t2JpTmzyP4GHV8Rl/VdYoDdME8VaBqpD1rivEZR0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de; spf=pass smtp.mailfrom=voleatech.de; dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b=BhlRM42f; arc=fail smtp.client-ip=40.107.241.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=voleatech.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="BhlRM42f"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iVXqqlyGECcSbYGv9K+9Q1c0pbHOONFU+d5C0H28IRnOQrioOiu7szKP9xhNZdO29oq4CrRE7NdwAZw/Jf+C2187NFVsWr8hn0FR8+utg+0pTQBWghPW2LFLyOCJx0ILj2ltb4sA20AfK+Z2F+yXgQOBtAsjS7OEPbPrWlGAGeXNLwgYxSwDbvTNkQ18uvwf7yv4OHgDm1Cw9lcR9AMY/RwZ2iIcgWjCdnRv/QxNzfYKy5Bzx5ITAAZhuiPN4P1eOOWHDqlyqDPUhpiw7IxvTibHCuVCV6uFVkrRVjeRuusx9+ts92ozm0OF2FyUBtRw7MVv9UkfH+XiiM7fHYSzOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yfEN8idPRxZwozgCGQA1jvWbsWEg+G4zgs+1f2W4eac=;
 b=GtuDdy1ibkKPahDuIvXoSIhghu678DgLY/XddtVUZ+dOldKxBQODCN+JRe0cHqBeDduqsf4ENjGzq9dg4OIobj2CZA+PR9ST4JKpa86dUkTSYfr27+S29H1gIFnnAY6nS7R34/SsC0zhBVQDdeeRIqH3flgqowegGvqthM1qmeR8N3iZuVHRkmPD8IoOMnMuWRpmnfshPL/eA3S35Lhr6hoW4yocjWKQF2stm/JH79Rw0Tn3X4EIUCSCrmBT99N6l1pa1N9erHsJW8VQ2kecoRlv9YgKLOfatfRSjodxzSbYpD88gqY4miXWrwHPhv/o4H2a4fOHm04V/gmu1bJpDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yfEN8idPRxZwozgCGQA1jvWbsWEg+G4zgs+1f2W4eac=;
 b=BhlRM42fUAZ6gP+aOD7pALS3TafJGUChzWfCvZdu+esMjxGm98swnAHO6fqZcUWRmCMoFijRR7/emojtujQMpNuM1zyF0BRs7d4TZ+FYtWDiEC2njyqxT90teej6jaFEgzQiNrND5iO3WtjEBXo4DwkGXj7IIE3vFBv70DzDFkE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from GVXPR05MB11233.eurprd05.prod.outlook.com
 (2603:10a6:150:14e::13) by AM8PR05MB7220.eurprd05.prod.outlook.com
 (2603:10a6:20b:1df::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.30; Wed, 20 Mar
 2024 13:37:55 +0000
Received: from GVXPR05MB11233.eurprd05.prod.outlook.com
 ([fe80::9d0c:55e:de01:2a2b]) by GVXPR05MB11233.eurprd05.prod.outlook.com
 ([fe80::9d0c:55e:de01:2a2b%2]) with mapi id 15.20.7362.019; Wed, 20 Mar 2024
 13:37:55 +0000
Date: Wed, 20 Mar 2024 14:37:50 +0100
From: Sven Auhagen <sven.auhagen@voleatech.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, cratiu@nvidia.com, ozsh@nvidia.com, 
	vladbu@nvidia.com, gal@nvidia.com, fw@strlen.de
Subject: Re: [PATCH nf] netfilter: flowtable: infer TCP state and timeout
 before flow teardown
Message-ID: <x6c7snfkq4yy2k5ih3igtov4g6yh6e7d24hpijtgesdyiykqwo@vaqyzp2uma3v>
References: <lajzqkqbqptfa6m6ntyseutpmbnrrc4yb26x6lwjaxm3aldzvc@u33db2j37rtb>
 <ZfqnTJKyW1VSIOgY@calendula>
 <lderg42fd4jbcwsztkidn3lhnjhufj5yv3zsdu4dpsenzikkta@cya5vq3prnzf>
 <ZfqsAoSNA4DRsVga@calendula>
 <nvslglowbvxntlpftefkumbwn2gz72evwnfvv4q2qencte7wyn@3jejk23urzeg>
 <Zfqxq3HK_nsGRLhx@calendula>
 <xvnywodpmc3eui6k5kt6fnooq35533jsavkeha7af6c2fntxwm@u3bzj57ntong>
 <Zfq-1gES4VJg2zHe@calendula>
 <o7kxkadlzt2ux5bbdcsgxlfxnfedzxv4jlfd3xnhri6qpr5w3n@2vmkj5o3yrek>
 <ZfrYpvJFrrajPbHM@calendula>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfrYpvJFrrajPbHM@calendula>
X-ClientProxiedBy: FR2P281CA0121.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9d::12) To GVXPR05MB11233.eurprd05.prod.outlook.com
 (2603:10a6:150:14e::13)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GVXPR05MB11233:EE_|AM8PR05MB7220:EE_
X-MS-Office365-Filtering-Correlation-Id: 467a458b-813e-4335-f87d-08dc48e2f293
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	dQ0JulK+yItcYwQVRg4npc+w/9g0VrlqgXXOfOEIlQoiqjBDhDeDV3WGzvBwJR+EANWsGMY9dRZdRibGi0TvHIeCUPfh2wYPlOKVTFVE9FzvY0hle/BpzPXQSeGlhxvdRWyJ9aRd8NpM/WILKpBMMcq2VDGc5gpk2KDo7ZyJA/rTTrn1Zho4bpRX0zS4/rWfS/O/YIPrDi6lWpZ0u5+lBGsfww97BAu+I2zwFcMiM08jy9BtAaHy1EazvkaZ/PlFXMj2LW9a+Hhz3mVo/Mizg6oV51xAKt3nQ0SDC0xru+c5eA4h0iKqIHqyBGGbxyBdDGojnmrX2Ldms/jisT2+Hx68+KDg7AeZDf5j9fyhh5zIkxYs/jWqTkS+NogvHKHvjdau7q3lD8x/YV2OXCB0vTbBP1YkYOgLZb1OHuGWcOKSOB8JTzrK7pW2SVd5yHXsVuNV+qRb2zzvsINvJm1RUqZST193Nt7woXybWnFw4jE3sRKRdPMGUUjT1u5hyyhkF5y997XPFjxpEh1y2AQrjnr6rLUUIYoVz8jZ/NxzAveHCIZI9ikq2URRFg511AU4Z2SRgdWOIMK5Fnps8JJujUtULBc5HoYC+0o+q1lwhRzre/Lw8etTibgt+ENvlY5Fl9ppvVQZF64Vul4QVAWxbZmVa10+FnSvkq47v/Z5/1A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR05MB11233.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gqhBTVgQwSsn4NtcC+uPjpwMRC0bvlb+DIBMO9PQtBQ/5VEpSOicfgpqyE8h?=
 =?us-ascii?Q?j3L6KYst94xstIv/1hx5WuYKsMsUneuBZMpibilq95TxRl+CSgNpBecgkxGI?=
 =?us-ascii?Q?mr7uqOxkkGDqru5mRdtCDgvGH+fjYJAMjlQZloQuNXWKUn0IdDfHxCBklqMC?=
 =?us-ascii?Q?CsIKznV15pvH0viV882rFKmUHgn/cyj8mY6xPXxTWD+k45AP7h+6T3nPoXdu?=
 =?us-ascii?Q?7dzzxq2gLmbz46I/ojY7oaoUDWozqAE+RQM/G5xxzeLI5UP+H+q0eqVL4YQY?=
 =?us-ascii?Q?r0lNwVwcRZNZRhDl8cV8YEglwAuELSe1EXjjPwF+XsCFcUXPanvhpCbsR1Yi?=
 =?us-ascii?Q?uhRPhOWIu12eWO8wlDkP5hFBMI+NiEZFGx45xCOvKio7CXj0XkLFp9w1PLpW?=
 =?us-ascii?Q?mN6pCdo2PQ+Eh3GYwAl7miAGmmMucARYN1rzTTJbFsmne8ytusXvuERPuOH5?=
 =?us-ascii?Q?3Uh4YiWCsr3pJV26JhJmWfhE5I1K73o1oxJ4u4Vz8+ob7CNQr0lJiOVJP8QA?=
 =?us-ascii?Q?573ZNmF5RE4Iq0hn4iwLoIbmS/FXzEsXivmCxODOcjbrzi2hwkHBm2HW3nCV?=
 =?us-ascii?Q?hsGKsavmR8el61T7N4BZoj9kP1+xnSAuixhvGKW6Xu0Nr2cVoPuNhpOYcT3X?=
 =?us-ascii?Q?5SfI2mxFgmRcnvTIPKUl7raRCCP7bM4fasf5kRKx8LmO+bGJ/N2InymHc30+?=
 =?us-ascii?Q?i2y1gKThM4frYUsTizWJo5CHOQ9WoaQ/VjslmPe1kCwZ1ol52dK53KPvc3AN?=
 =?us-ascii?Q?x35r3i7IlWImoxVwOPJSiVT9xMbbBpMd/tK/GZb4y+pFvZJ03opV7q67+zpy?=
 =?us-ascii?Q?AC2obBB8u0+0+FCD89dADGZG45fnWXcur0QYJPbNOV/EycmX54MsonveObR9?=
 =?us-ascii?Q?QaJuHSqez7dSMt+tU9KFPM6CqLntwpzIrZWmaOgPqWUI9704K8crypAtlDYG?=
 =?us-ascii?Q?5tBgKmrKbw/UGWE6fK9X1AitMUtwbMC8YWA49MgdHKkvUhD9tZGbMXWlelAX?=
 =?us-ascii?Q?wRPzkrytj92hxL8CYK1wO656NFCt8Tw74BZYcn1B4+X4MW+Iq20UnVVCHrDd?=
 =?us-ascii?Q?Y/PXLZmQ3a6Z0RoOb8ZAg0+R/HVHSUDbf23B5y6hE04IMuTyoy06RFJ4wemz?=
 =?us-ascii?Q?xImXiCP0oreXqwmUAdbOXgCR9b5aodHfAbE8wAYT90l8rbcppi/q9H5rHQ8d?=
 =?us-ascii?Q?qJp/ufjUDLDnD3JFx60BfRwCVgbfNSGH905fKgBr0maghu4uw+wFSkfJStJJ?=
 =?us-ascii?Q?gcCcW1vStxrfp2nthxFBzx/ETR0SLkmJA6wG8j+hmmEsiUiniJc167HVq9Bz?=
 =?us-ascii?Q?2iiRpdT/Kun3rac+Fi6jCgDwoRCKQaQhGyHapsdrOvDhQyIInTZfvXyJD3ax?=
 =?us-ascii?Q?8NCiVn44I9JSLus4LL6cRxaOcMVoOetMqdVS7xRDeToeYb1b66Mqpp5oH8JM?=
 =?us-ascii?Q?CDbxYNi9zl5JNEhrZV7SJl7j4MiLRAJYkvlwIiljw9es1YtXEuvWIUZCtqA+?=
 =?us-ascii?Q?VOAlDqW+c6Qn3/it1I6RHjsaDAdqt+4PRvonS5zC8RfNMvEOegWK39wVq62D?=
 =?us-ascii?Q?3h0P3qCugnbaiOuA9/JwLWJ/S7kcbt6mrY3XU2wA91k6VbmTV4RVJue3g844?=
 =?us-ascii?Q?qA=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 467a458b-813e-4335-f87d-08dc48e2f293
X-MS-Exchange-CrossTenant-AuthSource: GVXPR05MB11233.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 13:37:55.0990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hN5Rs8CrMi5EonX1K+RMXlW63LCw5BgfZjNHIJHiLgfakJ/EZAvUOcB45yUc1NOU7w+6FMNi1D/wuJXkrPIMH89f0fBCZ+C3aAHz4y/07R0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR05MB7220

On Wed, Mar 20, 2024 at 01:37:58PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Mar 20, 2024 at 12:15:51PM +0100, Sven Auhagen wrote:
> > On Wed, Mar 20, 2024 at 11:47:50AM +0100, Pablo Neira Ayuso wrote:
> > > On Wed, Mar 20, 2024 at 11:29:05AM +0100, Sven Auhagen wrote:
> > > > On Wed, Mar 20, 2024 at 10:51:39AM +0100, Pablo Neira Ayuso wrote:
> > > > > On Wed, Mar 20, 2024 at 10:31:00AM +0100, Sven Auhagen wrote:
> > > > > > On Wed, Mar 20, 2024 at 10:27:30AM +0100, Pablo Neira Ayuso wrote:
> > > > > > > On Wed, Mar 20, 2024 at 10:20:29AM +0100, Sven Auhagen wrote:
> > > > > > > > On Wed, Mar 20, 2024 at 10:07:24AM +0100, Pablo Neira Ayuso wrote:
> > > > > > > > > On Wed, Mar 20, 2024 at 09:49:49AM +0100, Sven Auhagen wrote:
> > > > > > > > > > On Wed, Mar 20, 2024 at 09:45:16AM +0100, Pablo Neira Ayuso wrote:
> > > > > > > > > > > Hi Sven,
> > > > > > > > > > > 
> > > > > > > > > > > On Wed, Mar 20, 2024 at 09:39:16AM +0100, Sven Auhagen wrote:
> > > > > > > > > > > > On Mon, Mar 18, 2024 at 10:39:15AM +0100, Pablo Neira Ayuso wrote:
> > > > > > > > > > > [...]
> > > > > > > > > > > > > diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> > > > > > > > > > > > > index a0571339239c..481fe3d96bbc 100644
> > > > > > > > > > > > > --- a/net/netfilter/nf_flow_table_core.c
> > > > > > > > > > > > > +++ b/net/netfilter/nf_flow_table_core.c
> > > > > > > > > > > > > @@ -165,10 +165,22 @@ void flow_offload_route_init(struct flow_offload *flow,
> > > > > > > > > > > > >  }
> > > > > > > > > > > > >  EXPORT_SYMBOL_GPL(flow_offload_route_init);
> > > > > > > > > > > > >  
> > > > > > > > > > > > > -static void flow_offload_fixup_tcp(struct ip_ct_tcp *tcp)
> > > > > > > > > > > > > +static s32 flow_offload_fixup_tcp(struct net *net, struct nf_conn *ct,
> > > > > > > > > > > > > +				  enum tcp_conntrack tcp_state)
> > > > > > > > > > > > >  {
> > > > > > > > > > > > > -	tcp->seen[0].td_maxwin = 0;
> > > > > > > > > > > > > -	tcp->seen[1].td_maxwin = 0;
> > > > > > > > > > > > > +	struct nf_tcp_net *tn = nf_tcp_pernet(net);
> > > > > > > > > > > > > +
> > > > > > > > > > > > > +	ct->proto.tcp.state = tcp_state;
> > > > > > > > > > > > > +	ct->proto.tcp.seen[0].td_maxwin = 0;
> > > > > > > > > > > > > +	ct->proto.tcp.seen[1].td_maxwin = 0;
> > > > > > > > > > > > > +
> > > > > > > > > > > > > +	/* Similar to mid-connection pickup with loose=1.
> > > > > > > > > > > > > +	 * Avoid large ESTABLISHED timeout.
> > > > > > > > > > > > > +	 */
> > > > > > > > > > > > > +	if (tcp_state == TCP_CONNTRACK_ESTABLISHED)
> > > > > > > > > > > > > +		return tn->timeouts[TCP_CONNTRACK_UNACK];
> > > > > > > > > > > > 
> > > > > > > > > > > > Hi Pablo,
> > > > > > > > > > > > 
> > > > > > > > > > > > I tested the patch but the part that sets the timout to UNACK is not
> > > > > > > > > > > > very practical.
> > > > > > > > > > > > For example my long running SSH connections get killed off by the firewall
> > > > > > > > > > > > regularly now while beeing ESTABLISHED:
> > > > > > > > > > > > 
> > > > > > > > > > > > [NEW] tcp      6 120 SYN_SENT src=192.168.6.55 dst=192.168.10.22 sport=55582 dport=22 [UNREPLIED] src=192.168.10.22 dst=192.168.6.55 sport=22 dport=55582 mark=16777216
> > > > > > > > > > > > [UPDATE] tcp      6 60 SYN_RECV src=192.168.6.55 dst=192.168.10.22 sport=55582 dport=22 src=192.168.10.22 dst=192.168.6.55 sport=22 dport=55582 mark=16777216
> > > > > > > > > > > > [UPDATE] tcp      6 86400 ESTABLISHED src=192.168.6.55 dst=192.168.10.22 sport=55582 dport=22 src=192.168.10.22 dst=192.168.6.55 sport=22 dport=55582 [OFFLOAD] mark=16777216
> > > > > > > > > > > > 
> > > > > > > > > > > > [DESTROY] tcp      6 ESTABLISHED src=192.168.6.55 dst=192.168.10.22 sport=54941 dport=22 packets=133 bytes=13033 src=192.168.10.22 dst=192.168.6.55 sport=22 dport=54941 packets=95 bytes=15004 [ASSURED] mark=16777216 delta-time=1036
> > > > > > > > > > > > 
> > > > > > > > > > > > I would remove the if case here.
> > > > > > > > > > > 
> > > > > > > > > > > OK, I remove it and post a v2. Thanks!
> > > > > > > > > > 
> > > > > > > > > > Thanks and also the hardcoded TCP_CONNTRACK_ESTABLISHED in flow_offload_fixup_ct
> > > > > > > > > > should be reverted to the real tcp state ct->proto.tcp.state.
> > > > > > > > > 
> > > > > > > > > ct->proto.tcp.state contains the state that was observed before
> > > > > > > > > handling over this flow to the flowtable, in most cases, this should
> > > > > > > > > be TCP_CONNTRACK_ESTABLISHED.
> > > > > > > > > 
> > > > > > > > > > This way we always set the current TCP timeout.
> > > > > > > > > 
> > > > > > > > > I can keep it to ct->proto.tcp.state but I wonder if it is better to
> > > > > > > > > use a well known state such as TCP_CONNTRACK_ESTABLISHED to pick up from.
> > > > > > > > 
> > > > > > > > In case of a race condition or if something is off like my TCP_FIN
> > > > > > > > that is beeing offloaded again setting to to ESTABLISHED hard coded
> > > > > > > > will make the e.g. FIN or CLOSE a very long state.
> > > > > > > > It is not guaranteed that we are still in ESTABLISHED when this code
> > > > > > > > runs. Also for example we could have seen both FIN already before the
> > > > > > > > flowtable gc runs.
> > > > > > > 
> > > > > > > OK, I just posted a v2, leave things as is. I agree it is better to
> > > > > > > only address the issue you are observing at this time, it is possible
> > > > > > > to revisit later.
> > > > > > > 
> > > > > > > Thanks!
> > > > > > 
> > > > > > Thanks, I will give it another try.
> > > > > > I think for it to be foolproof we need
> > > > > > to migrate the TCP state as well in flow_offload_teardown_tcp to FIN or CLOSE.
> > > > > 
> > > > > My patch already does it:
> > > > > 
> > > > > +void flow_offload_teardown_tcp(struct flow_offload *flow, bool fin)
> > > > > +{
> > > > > +       enum tcp_conntrack tcp_state;
> > > > > +
> > > > > +       if (fin)
> > > > > +               tcp_state = TCP_CONNTRACK_FIN_WAIT;
> > > > > +       else /* rst */
> > > > > +               tcp_state = TCP_CONNTRACK_CLOSE;
> > > > > +
> > > > > +       flow_offload_fixup_tcp(nf_ct_net(flow->ct), flow->ct, tcp_state);
> > > > > 
> > > > > flow_offload_fixup_tcp() updates the TCP state to FIN / CLOSE state.
> > > > > 
> > > > > > They way thinks are right now we are open to a race condition from the reverse side of the
> > > > > > connection to reoffload the connection while a FIN or RST is not processed by the netfilter code
> > > > > > running after the flowtable code.
> > > > > > The conenction is still in TCP established during that window and another packet can just
> > > > > > push it back to the flowtable while the FIN or RST is not processed yet.
> > > > > 
> > > > > I don't see how:
> > > > > 
> > > > > static void nft_flow_offload_eval(const struct nft_expr *expr,
> > > > >                                   ...
> > > > > 
> > > > >         switch (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum) {
> > > > >         case IPPROTO_TCP:
> > > > >                 tcph = skb_header_pointer(pkt->skb, nft_thoff(pkt),
> > > > >                                           sizeof(_tcph), &_tcph);
> > > > >                 if (unlikely(!tcph || tcph->fin || tcph->rst ||
> > > > >                              !nf_conntrack_tcp_established(ct)))
> > > > >                         goto out;
> > > > > 
> > > > > this would now be either in FIN/CLOSE state.
> > > > > 
> > > > > FIN, RST packet does not trigger re-offload. And ACK packet would find
> > > > > the entry in !nf_conntrack_tcp_established(ct).
> > > > > 
> > > > > What path could trigger re-offload after my latest patch?
> > > > 
> > > > From looking through the nf conntrack tcp code you need to spin_lock
> > > > the TCP state change to avoid a race with another packet.
> > > 
> > > The flowtable owns the flow, packets belonging the flow cannot update
> > > the TCP state while the flow is offloaded to the flowtable.
> > > 
> > > Once _TEARDOWN flag is set on, then packets get back to classic
> > > conntrack path.
> > 
> > Hmm alright, something is going wrong somewhere and it looks a lot like
> > a race condition :)
> 
> This check is racy, another packet could alter the ct state right
> after it evaluates true.
> 
>          switch (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum) {
>          case IPPROTO_TCP:
>                  tcph = skb_header_pointer(pkt->skb, nft_thoff(pkt),
>                                            sizeof(_tcph), &_tcph);
>                  if (unlikely(!tcph || tcph->fin || tcph->rst ||
>                               !nf_conntrack_tcp_established(ct))) <-------
>                          goto out;
> 
> Sequence would be:
> 
> 1) flow expires (after 30 seconds), goes back to conntrack in established state
> 2) packet re-offloads the flow and nf_conntrack_tcp_established(ct) evaluates true.
> 3) FIN packet races to update conntrack getting to FIN_WAIT while re-offloading
>    the flow.
> 
> then you see FIN_WAIT and offload, it could happen with an expired
> flow that goes back to conntrack.
> 
> But I am not sure yet if this is the case you're observing there.
> 
> > I mean just in theory it is not guaranteed that both directions send all
> > packets through the flowtable just because it is offloaded.
> > A variety of error checks might send a packet back to the slow path.
> 
> There is the mtu check that is lacking the teardown, but that should
> only affect UDP traffic. A patch from Felix decided has cached the mtu
> in the flow entry. That is also probably convenient to have, but it
> looks like a different issue, I will also post a patch for this issue.

I would be suprised if the MTU is an issue.
I will also add a counter/printk to the two checks from your patch just to make sure.
I will report back with my testing of v2 of the patches.

