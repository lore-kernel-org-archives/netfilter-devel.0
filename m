Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2135.outbound.protection.outlook.com [40.107.22.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8900383A1
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2024 09:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.22.135
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710927071; cv=fail; b=CXK5yfRKjENxa5V9i9hJokjL3JEUPAmm7ZZs8zhF+cKB/58WcirQRBnMAROtVhFTRZlGB4qwSkudodY35swhDUqkASgdt99oHSmDYi3Neh89U6kmEBYv/h9yaQqXqL+g4w9g7w9kH42YMNgz6iOImuFW183yHWyoto00cItPv94=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710927071; c=relaxed/simple;
	bh=BBe3lVbAWKoHeEwMSHqh7PU4JnLsRV+zIoaWkhWQEis=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BPc+TKqq0E1UlBhz0Xr9B/B4UXT1vGs8AN9Cpv9rX47KuofKhkVox8NrS11hQF0V7OmLB6TA5rI9kbrgsHWbUCerSFDxLbglkyX6xsAENZbK12xHYAvXUEQ/iXrUHZRihR1hOMFBC5mUU6tJuY/kaNxFkauu3bjXH24n/Buhh/g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de; spf=pass smtp.mailfrom=voleatech.de; dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b=ZP2VTj9f; arc=fail smtp.client-ip=40.107.22.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=voleatech.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="ZP2VTj9f"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hbq5+cDxnZ5GUhxlMMbwZ026TpXl9ouDGIKsDLJtNO0jkeJCRkwueuxK5NRhlE6K83HOty7GnoniO+CWAeGPH1sdXxbipQ2KbNfxOaOyT3lfOgEUY35Mg+x8JydD4kVIFwKCxbk71sDN6uyjrTYpOpM9uWRELNXaCtKbutCAe15bmZh7oYSWj8mR669Ix10MPY3DnA0qzG7C9KqPu762myrMmCRd/5iXsXKgTkyPMrKU3Xfj1re0STT846aK4wAJkxBqrT42eOu+o0TQ2ikR8v4cTZbUhu3XUQwgO0A0U7gJutBxK8Wm7yFnvRksodCE02X+zVUpOGqqyLw1MQalng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wb2TpkUVsGxQXcu3R2qUUy6uhjYZwReScfuUqD3Lu9Y=;
 b=KO/Nd1f1vJ73GMKkEj6Nx3UzHZBiU1Y3433umGpQdE92dsw7WuZ3T9P6iJk+eeS8+Ys9ZNX12YDh5+M3j4PcMT3TT5B/FJjtrEDAvnJ17GzEIB7lpTtqLXImP4jazgoyXHas+DKrvSpZcEqNel9JeTtgoRRIvDaGj28Izc7arVnKo11TDC1YomEK2JoWiW2zFPUQUnkVJBFr2e1Gq6p3ZhUskaBa7hJjpSC221/wqnYpYbnxlexFLm7MLlmbv2iUBMWVc4B3LyQYrXem1ZeIm47WF3NHcfc6MV9TFVaBtB5N6+6PMfzuoRBsPsqQJ8G3iwgoz/6Q78HXWIln6E5+Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wb2TpkUVsGxQXcu3R2qUUy6uhjYZwReScfuUqD3Lu9Y=;
 b=ZP2VTj9fi5/vfrBSSbQjlxAPdGfYkr5CatdGDUWqyR+eEkQAtXKEHBreEOOek1H7f1uKO83Wv5vfsD0QVpmMQVnJA24Qu5qaMU6NCdgnUFcp/ijBQyRPiwyNvA1HxcYDSIrjh1x9uGsC3NxxnhAVOGU7iMW7kDhzu3ggnbzxcqM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from GVXPR05MB11233.eurprd05.prod.outlook.com
 (2603:10a6:150:14e::13) by AM7PR05MB6916.eurprd05.prod.outlook.com
 (2603:10a6:20b:1a7::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.31; Wed, 20 Mar
 2024 09:31:05 +0000
Received: from GVXPR05MB11233.eurprd05.prod.outlook.com
 ([fe80::9d0c:55e:de01:2a2b]) by GVXPR05MB11233.eurprd05.prod.outlook.com
 ([fe80::9d0c:55e:de01:2a2b%2]) with mapi id 15.20.7362.019; Wed, 20 Mar 2024
 09:31:05 +0000
Date: Wed, 20 Mar 2024 10:31:00 +0100
From: Sven Auhagen <sven.auhagen@voleatech.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, cratiu@nvidia.com, ozsh@nvidia.com, 
	vladbu@nvidia.com, gal@nvidia.com, fw@strlen.de
Subject: Re: [PATCH nf] netfilter: flowtable: infer TCP state and timeout
 before flow teardown
Message-ID: <nvslglowbvxntlpftefkumbwn2gz72evwnfvv4q2qencte7wyn@3jejk23urzeg>
References: <20240318093915.10358-1-pablo@netfilter.org>
 <zxdruu67c2xs6zrhagjilitxu5ysik5x7zvk3kthzcclype22c@nevv7c7adz7z>
 <ZfqiHPpUfFwHI5-h@calendula>
 <lajzqkqbqptfa6m6ntyseutpmbnrrc4yb26x6lwjaxm3aldzvc@u33db2j37rtb>
 <ZfqnTJKyW1VSIOgY@calendula>
 <lderg42fd4jbcwsztkidn3lhnjhufj5yv3zsdu4dpsenzikkta@cya5vq3prnzf>
 <ZfqsAoSNA4DRsVga@calendula>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfqsAoSNA4DRsVga@calendula>
X-ClientProxiedBy: FR0P281CA0190.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ab::15) To GVXPR05MB11233.eurprd05.prod.outlook.com
 (2603:10a6:150:14e::13)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GVXPR05MB11233:EE_|AM7PR05MB6916:EE_
X-MS-Office365-Filtering-Correlation-Id: f9057df9-d4ba-4655-7401-08dc48c076fc
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	sq4Xx1wdkykhWK1zH99axAYUe6GqN5aV8T0iwmXonIMpUCTbnarmqO9B5eVNP4KBmNKx4qschGuasvO8Sn2RUFdJamcYh5zXx2ohaxJu9p9FsWdibOfhLJri6ES4IDTsgWkoNBvAdOEK0sjaN/LyKTGxL3Yi4ofR/x6Iy9yZZHfnbKAxQDxbOIdT3BzzsTnVxqRKmZr0sFccD46ThCE8W6ewNjScptnLa3KFs+Dn/mZoZRSQhOvjcVYbei5dFDEJvqh3g1NB/qEWZAuq/Hj2a0Y4lYOG6MrB1YBl0TmEZe0JeWrOJTgy2lzIpBBiRiMfbR8bjT+Ml49+W76cb1cxKA3haeVEmYcDcoWASeSWcpoVInSEgSFOzqLz/J6KB7T+ZBRZGlQV7DroBA1wnyWhIvS4fvMeLrAMtG9h5leaBLAIzqal1Lsrr+ZNwFqQW300kvkDB4rt3TO10DBzdIJ3l2MQ3/axFaDmcoCENsJFTx4pb3vHCrDwPlBEuO6Y/rW1Q41U0EJT5sy/yRJKDcagXC90LAMcxDQLmzB7TsWVEYtkVLPX3+rDtWhO3g7UxPZrCY0Y2RbQCQKHOK0r1uFU8/xe35Tnb7XHh+mcHanADcfKpLcalhdeW/K5ttBp1ZJKrxkUxtP0EbwiDVGzBA6ptC6VS0eVaGdkd6n77Sp8RwU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR05MB11233.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?46/um+dhygQIn3a/Ya1293rgcqlV4RDrACuJ6tygo3nEJch2J9cdwHi+Bb/S?=
 =?us-ascii?Q?wXm4Ji7cBInvckzBckBqbJAVkNTd4xmL2QwNIoV8cJ6vWYPVx5WrRvBdEz7k?=
 =?us-ascii?Q?SqXkuVOstoacuyBYe7rsfNvAm7h6dE1GnoCal59XCXdnYvevTFrc9WkAJIRS?=
 =?us-ascii?Q?IJUsGQWY7En69qntFhxYrKAQMYxPfRMwiHQno6d6N9IvVvzl40NiQGOomxXz?=
 =?us-ascii?Q?00Tswda9QCA7EUfgfkqxXPUdEVWUUmNrm3Ia9pNwGzNnKa/S+4XuHgpRLdR/?=
 =?us-ascii?Q?2Af5ngjA3EaVqjK6if3S0g6vCbi2LVDbPQSLPQCEr5KttFG1tHwkMT+Io8cG?=
 =?us-ascii?Q?xUEq75y8PXXyTJhw8/JvyxM51ItpIVb1BAIdGkMhqu/sySwnwrIJLF/hJB+J?=
 =?us-ascii?Q?UORyMvofcsIGfIWbaTisRS48keWrZkX7yeVXHk2P5cc3kWrM7pu4M3/AKW2s?=
 =?us-ascii?Q?+IGjcA/eJOojbAZNvalnveeBgcP4vozfYCVCHClz+0FXl93iZrfew+oIjZkV?=
 =?us-ascii?Q?TrDmC4IN76UEmd5JaMRdrYwEA8VUHLeM5fhJwc4rWYpYpHqpKxw9z5Ye89SG?=
 =?us-ascii?Q?4s8PKno0f93ol/I5qeblqJ59cxdi2rCUy2cj7m6jA2nbyGrqG3idWiEqaE0j?=
 =?us-ascii?Q?9RUQt4yw+S5N6PtQfUUV1Gu7dYGUlUnyXcnYWZ8XGKcwSV4fGcI/w9aP/TNt?=
 =?us-ascii?Q?wqZP6DqN1H7hHn3D7kVNzAhCVug4BplRKHKO01/yDfrl7rwMmbdIwN0adw+U?=
 =?us-ascii?Q?cOrg6AUhd13sw/ljuvhT1Tl2TeA9d5+7IzYXtmMYEq68Drfg+/dVdg5E9nRL?=
 =?us-ascii?Q?vqK56NNhJwV7u0QoC9w6K3xhTWIoq2JZnZYoWZ4+f8XPXIFpFY1gGia7rL0x?=
 =?us-ascii?Q?dANMA9aVkDqJJ/ZMQjHfA67OcHa6ctzLPWqmjErp9H1nqcbp8bFelYKs2G/C?=
 =?us-ascii?Q?bAlfkiZOFXrs3TACFRjYH/jvY71iNFaU1ESVI8U9WTS/Vk///lYOR8wJOzWl?=
 =?us-ascii?Q?rxt6lSJRQmzNvq8Xbai6HlvVSuoP7zCgNM4U/p6XlU2Ufuy/isR8pphQVMQt?=
 =?us-ascii?Q?msU+FGNxMnd5q5DGdCm/A1V76froMYOsdXw0HHftLkNPSyW9dgelADODt+/h?=
 =?us-ascii?Q?n6jMIE7svZCvrth5dHiyfuX4sW5aJeFJ24UEDVX3intShffdjHUr8s82YOWe?=
 =?us-ascii?Q?T6EUDKFXJ6Ea/q0zFY51Mu2faLQg8UudspU4nRVqhJ+RIkO8IRvUiGuanai1?=
 =?us-ascii?Q?qQS8Zehhx6IiVducU4G8c15s/9WAz6oaZk4OuGpskYL2miTj6qYl4pHtPExT?=
 =?us-ascii?Q?gN6yyNPnXfDAyW1z59tExyGvO+dsK6dbOABQegp7Ek/vSxmvIapDXvsoxrIC?=
 =?us-ascii?Q?xrK2i/GhQSoxSxhufvzGKccAJKjoF/VGrll/V4GF3lkI5mDavgjD+eew59Bp?=
 =?us-ascii?Q?XWyPCaNZAJmIFbV1ZImft+d8et3QjZej5yjVdwlRUuP6Y0L8DiLFWCJss8Wk?=
 =?us-ascii?Q?R/9P2Uq/zAOgfPWBrt1wUN0ICbDwi70rRg9cJh9+8mn81NSlEC4UCKFTHrMT?=
 =?us-ascii?Q?fw1icoSGDUJ7bW7zx7WzzrEFPNaPx81rpUB4M89v9pHMj++AWMBNzuD0DGiO?=
 =?us-ascii?Q?jw=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: f9057df9-d4ba-4655-7401-08dc48c076fc
X-MS-Exchange-CrossTenant-AuthSource: GVXPR05MB11233.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 09:31:04.9069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LCt57IpyjT9gKu6hWA8ZocMj5MNFjaw0/wv2MOd/MxFmQwZIPSo7Qw8O4dBoS9JxZLw4CvDPEJisHrP0mgbtoEgFx4vLEQnHAMIyGbWaVLU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR05MB6916

On Wed, Mar 20, 2024 at 10:27:30AM +0100, Pablo Neira Ayuso wrote:
> On Wed, Mar 20, 2024 at 10:20:29AM +0100, Sven Auhagen wrote:
> > On Wed, Mar 20, 2024 at 10:07:24AM +0100, Pablo Neira Ayuso wrote:
> > > On Wed, Mar 20, 2024 at 09:49:49AM +0100, Sven Auhagen wrote:
> > > > On Wed, Mar 20, 2024 at 09:45:16AM +0100, Pablo Neira Ayuso wrote:
> > > > > Hi Sven,
> > > > > 
> > > > > On Wed, Mar 20, 2024 at 09:39:16AM +0100, Sven Auhagen wrote:
> > > > > > On Mon, Mar 18, 2024 at 10:39:15AM +0100, Pablo Neira Ayuso wrote:
> > > > > [...]
> > > > > > > diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> > > > > > > index a0571339239c..481fe3d96bbc 100644
> > > > > > > --- a/net/netfilter/nf_flow_table_core.c
> > > > > > > +++ b/net/netfilter/nf_flow_table_core.c
> > > > > > > @@ -165,10 +165,22 @@ void flow_offload_route_init(struct flow_offload *flow,
> > > > > > >  }
> > > > > > >  EXPORT_SYMBOL_GPL(flow_offload_route_init);
> > > > > > >  
> > > > > > > -static void flow_offload_fixup_tcp(struct ip_ct_tcp *tcp)
> > > > > > > +static s32 flow_offload_fixup_tcp(struct net *net, struct nf_conn *ct,
> > > > > > > +				  enum tcp_conntrack tcp_state)
> > > > > > >  {
> > > > > > > -	tcp->seen[0].td_maxwin = 0;
> > > > > > > -	tcp->seen[1].td_maxwin = 0;
> > > > > > > +	struct nf_tcp_net *tn = nf_tcp_pernet(net);
> > > > > > > +
> > > > > > > +	ct->proto.tcp.state = tcp_state;
> > > > > > > +	ct->proto.tcp.seen[0].td_maxwin = 0;
> > > > > > > +	ct->proto.tcp.seen[1].td_maxwin = 0;
> > > > > > > +
> > > > > > > +	/* Similar to mid-connection pickup with loose=1.
> > > > > > > +	 * Avoid large ESTABLISHED timeout.
> > > > > > > +	 */
> > > > > > > +	if (tcp_state == TCP_CONNTRACK_ESTABLISHED)
> > > > > > > +		return tn->timeouts[TCP_CONNTRACK_UNACK];
> > > > > > 
> > > > > > Hi Pablo,
> > > > > > 
> > > > > > I tested the patch but the part that sets the timout to UNACK is not
> > > > > > very practical.
> > > > > > For example my long running SSH connections get killed off by the firewall
> > > > > > regularly now while beeing ESTABLISHED:
> > > > > > 
> > > > > > [NEW] tcp      6 120 SYN_SENT src=192.168.6.55 dst=192.168.10.22 sport=55582 dport=22 [UNREPLIED] src=192.168.10.22 dst=192.168.6.55 sport=22 dport=55582 mark=16777216
> > > > > > [UPDATE] tcp      6 60 SYN_RECV src=192.168.6.55 dst=192.168.10.22 sport=55582 dport=22 src=192.168.10.22 dst=192.168.6.55 sport=22 dport=55582 mark=16777216
> > > > > > [UPDATE] tcp      6 86400 ESTABLISHED src=192.168.6.55 dst=192.168.10.22 sport=55582 dport=22 src=192.168.10.22 dst=192.168.6.55 sport=22 dport=55582 [OFFLOAD] mark=16777216
> > > > > > 
> > > > > > [DESTROY] tcp      6 ESTABLISHED src=192.168.6.55 dst=192.168.10.22 sport=54941 dport=22 packets=133 bytes=13033 src=192.168.10.22 dst=192.168.6.55 sport=22 dport=54941 packets=95 bytes=15004 [ASSURED] mark=16777216 delta-time=1036
> > > > > > 
> > > > > > I would remove the if case here.
> > > > > 
> > > > > OK, I remove it and post a v2. Thanks!
> > > > 
> > > > Thanks and also the hardcoded TCP_CONNTRACK_ESTABLISHED in flow_offload_fixup_ct
> > > > should be reverted to the real tcp state ct->proto.tcp.state.
> > > 
> > > ct->proto.tcp.state contains the state that was observed before
> > > handling over this flow to the flowtable, in most cases, this should
> > > be TCP_CONNTRACK_ESTABLISHED.
> > > 
> > > > This way we always set the current TCP timeout.
> > > 
> > > I can keep it to ct->proto.tcp.state but I wonder if it is better to
> > > use a well known state such as TCP_CONNTRACK_ESTABLISHED to pick up from.
> > 
> > In case of a race condition or if something is off like my TCP_FIN
> > that is beeing offloaded again setting to to ESTABLISHED hard coded
> > will make the e.g. FIN or CLOSE a very long state.
> > It is not guaranteed that we are still in ESTABLISHED when this code
> > runs. Also for example we could have seen both FIN already before the
> > flowtable gc runs.
> 
> OK, I just posted a v2, leave things as is. I agree it is better to
> only address the issue you are observing at this time, it is possible
> to revisit later.
> 
> Thanks!

Thanks, I will give it another try.
I think for it to be foolproof we need
to migrate the TCP state as well in flow_offload_teardown_tcp to FIN or CLOSE.
They way thinks are right now we are open to a race condition from the reverse side of the
connection to reoffload the connection while a FIN or RST is not processed by the netfilter code
running after the flowtable code.
The conenction is still in TCP established during that window and another packet can just
push it back to the flowtable while the FIN or RST is not processed yet.

