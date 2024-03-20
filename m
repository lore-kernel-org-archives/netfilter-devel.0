Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2108.outbound.protection.outlook.com [40.107.14.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FEC3D566
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2024 10:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.14.108
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710930555; cv=fail; b=VbLK0/gpwWofzHiv4DMRZ0/ZIqvwprI3ilAJq/Q3LEHCJ6QRRejdAw5bhqQt3eQzM/XRuClcYZ7jBh0RmaP2XuexyaS3N6T6qaGdMEsvj0gxu8KvyDWJW0haCOuoUGqZvjSodbaQSxTH/c4/FqZVylE2br2+6va0BhikZNGqmxo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710930555; c=relaxed/simple;
	bh=8F/9Wbj/tEPgz9g/sgb2zQmH28WKnJvz4Ocjqf6Bkec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=I0O0Ez2+O7ww0aBIq4iMCz0YhhgOvm8XaTiV6zDkfIQjTwYbsXcuS6PW4/jPQ1kOU0BN51Y3TArdMzB8GVOfMPs7YSBBmlxoBgU+KA2GsbKp70u7VFIirY3whrn3zJWzU72tyN0HA9hnKTHrc7IRYnX8cMtQxj2d23wEq7hjaAU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de; spf=pass smtp.mailfrom=voleatech.de; dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b=AFsEGh7j; arc=fail smtp.client-ip=40.107.14.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=voleatech.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="AFsEGh7j"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hSXipQmpV6mszmuoegvPBWav5obOyYWNh+IxKfiX8ZuLfgAGxiGmCbkSNVUYa4IRAH9JkAsvoim6dFDAFVxUirF2b6hK4KbXZ0y1P0Jppo8UX6QWEAqotfNaB0l//YbeHMFKNmHdhRScKhhisfNnJHpjgpvgSZ9u88vPUVvpxONX1qb8BYRsOfvMvBy5CSJ6cttLZ+rS6q7o3K1nlzkhO4KwIv8h9Q67F0of7Wsw11fgeZWtY/5xMc+RIY6CfYvUGclnyYfGBqe9n0WbhMeHRRKFCba5FRwDb7KALsit6yspyRnbNGSPiNXCGqXX9zv6+zn/Fe3fgPXntH5COzye+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UsSDjFf+zgGKogyvr8U6Lb2B9ZJzB/xzIR0p+rEX6V0=;
 b=UM43Pk9FOam4I9fkQF8Nq3a+UtAJRJxb1b3ieb/MHyYMuUtyBjLlVbegcczqs1GXI4UgVNHvpJvTovVgxRN95zpiiCQoV9tNze+1J1XOKcMLUuWkWdYaIMCohszR8O1bBfbnQhgvzJA5KRTMzbsyBzCWpxq5A4UApZEZYYh3A6uHJ2Z6OXCqt+2u0Y00rIdHYUIbNtV8abIT/5EJo0cIydi+wwsgi9VH1tM7PNSAii8nef2h2h2UkW25wcbpbJcIgvYlhJJZIhDE0sb5R1hDBfC14HSjPKqVHLRJZpg9tkPX/71kTy+0urxIv4aHg3ErtrK32w2U8f+myS4wa4QOMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UsSDjFf+zgGKogyvr8U6Lb2B9ZJzB/xzIR0p+rEX6V0=;
 b=AFsEGh7jIkNi87fRJij1SxycAOq+ZwJSJI+HVu7OZ/kTatF5YMj+efmXe1f8wi/DJHj+RnlX/WtGmCWVkN8kE9GTedRdbvJs9GOdbarYjoAn6rGycnpFjhtFKMYmMT4RGUiK47nY7L89z726XbhNbH15NTGWGhWAWLARf2UZ1dE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from GVXPR05MB11233.eurprd05.prod.outlook.com
 (2603:10a6:150:14e::13) by AS1PR05MB9177.eurprd05.prod.outlook.com
 (2603:10a6:20b:4d7::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.28; Wed, 20 Mar
 2024 10:29:09 +0000
Received: from GVXPR05MB11233.eurprd05.prod.outlook.com
 ([fe80::9d0c:55e:de01:2a2b]) by GVXPR05MB11233.eurprd05.prod.outlook.com
 ([fe80::9d0c:55e:de01:2a2b%2]) with mapi id 15.20.7362.019; Wed, 20 Mar 2024
 10:29:09 +0000
Date: Wed, 20 Mar 2024 11:29:05 +0100
From: Sven Auhagen <sven.auhagen@voleatech.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, cratiu@nvidia.com, ozsh@nvidia.com, 
	vladbu@nvidia.com, gal@nvidia.com, fw@strlen.de
Subject: Re: [PATCH nf] netfilter: flowtable: infer TCP state and timeout
 before flow teardown
Message-ID: <xvnywodpmc3eui6k5kt6fnooq35533jsavkeha7af6c2fntxwm@u3bzj57ntong>
References: <20240318093915.10358-1-pablo@netfilter.org>
 <zxdruu67c2xs6zrhagjilitxu5ysik5x7zvk3kthzcclype22c@nevv7c7adz7z>
 <ZfqiHPpUfFwHI5-h@calendula>
 <lajzqkqbqptfa6m6ntyseutpmbnrrc4yb26x6lwjaxm3aldzvc@u33db2j37rtb>
 <ZfqnTJKyW1VSIOgY@calendula>
 <lderg42fd4jbcwsztkidn3lhnjhufj5yv3zsdu4dpsenzikkta@cya5vq3prnzf>
 <ZfqsAoSNA4DRsVga@calendula>
 <nvslglowbvxntlpftefkumbwn2gz72evwnfvv4q2qencte7wyn@3jejk23urzeg>
 <Zfqxq3HK_nsGRLhx@calendula>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zfqxq3HK_nsGRLhx@calendula>
X-ClientProxiedBy: FR3P281CA0149.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:95::20) To GVXPR05MB11233.eurprd05.prod.outlook.com
 (2603:10a6:150:14e::13)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GVXPR05MB11233:EE_|AS1PR05MB9177:EE_
X-MS-Office365-Filtering-Correlation-Id: 7232b5d1-0ce5-4e29-b146-08dc48c893d4
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	AAKpkdrxzEvX2ZQSSv19V6NbZZJqv81AdbTYl3zLExG7beIIsSLdYic7XYmNJlJCjKEf/HpciS2/HTqFjP+zPf+MVRX1rp6aooltwlyqd++MCTZPSn8ip+267oFP1d8zi06CoGcvGmPFlcKDbBtmkAMhU7v8j9rlS9rX99+U1En2yvITjXpoDnukcW6V/hkkLkhw0253tkf26gvllfgq7tGdup4/RuyPZYsED1Q1nWUuqMMU85KB1mofbmb+/xqNncvSu6Wz2KeHdJyqAuSBGDRMqpkeDfv+iot3+oh5YZkUNXIIvza83xeOkAe9fcVDmA1qpozxr8EMj61eOPytLIxczhVNfb5ReZFj0FAWhBT/IH/Z0HsL1Z7KwcJeVTfbXiCL99gw/iVKCCIrLl9rgzlJk5hoz1/8IInEXSmc/tbeU3WZZ3W5bCAa/WqNw2bqZuNLt9j0vbj7JcD5Ba68XGk+9Ldsc3XNfO9QVgEvgrlYiC/m+nPlCjr0G76klhPW9yc4Dmw68BuzkoMia9m5bR1tuITDb0z7k43uMlfj4wehpLhIEUAQz68dmzP+tSjE3XUG3fCR2nPwF1AA71cEQP7gH+aNp8vXekJxczkDQxV7kudvgFLOKNdFgtVwuYwXGMhma6q7O/RptrSpa7OEWg3ZU+AysiPaVz1t4Yck0go=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR05MB11233.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UfWdqO63cmlA96+CYuYYYf3VpPYdslFWJ7sSS1bfW2OkMaX01XE5dRlQlH9s?=
 =?us-ascii?Q?wTbFgOOTOsQb7mj/We4AKZ7bwa63MQdZYnbLnDB2W3krX9ThCT7O1plz6ULB?=
 =?us-ascii?Q?vYui9ivRFYatgZ1hdjJrzAO+12I85DszB8XZGMU1YJdf2mio72qtlyIM568b?=
 =?us-ascii?Q?vZ5Akxa2cR/qDpJ0iLsC3s1ZiXELuEa4QqumpkAMb5X4+gYfQvpdvV8VQRGm?=
 =?us-ascii?Q?26ywg4QDUV20995e5bOLbyJcP2x6NXfGRiqxiYUGVXSOnvD4G42lRoaNgGhS?=
 =?us-ascii?Q?aVEs07EC/c2V5MkYd4bteAf1f9yx0Le9m7byv0WfPglCAG7yYeBQ97bdUpom?=
 =?us-ascii?Q?RMqBhhyln7zGkbBN+wlinb+2ULmn1ngGGSdR6Q4dD3rVhGsxjHGhwsBdafPY?=
 =?us-ascii?Q?A5xbBEjulTd+1ReMV0sOPepXHQPLizA3dP/BsPSZ3P1IIPm5wgm73d3Akbc/?=
 =?us-ascii?Q?z+Usse59wF3f6GBUo/5UPpBuzcoyev4kU9sEPgTdhAiRwbj6qsuZnpyB9oGT?=
 =?us-ascii?Q?UpYTEsqWDmT+UD0CmelKqxD3EdfkHXXo+e0c0MZainyaDLnJuS3VvNC24kAN?=
 =?us-ascii?Q?Qe+RDMkhLfdRjx7dx/9NnT7T4wPEE065ybqKHC4/ZrkdasrxcMck0AvbTA+h?=
 =?us-ascii?Q?L5QxUDXv+xkhcAKcwujszQDuUEXZv7iK8SiwmcxmOXe2C9rZ00syhdtLiFZ7?=
 =?us-ascii?Q?E5hJBYQgVabYbYcJQNsVaq6f9IXlzMdmdffmCz31gF50JXcRG0tCL9UZI3TW?=
 =?us-ascii?Q?2GPZ2TYbgVOmvdgRdjHvMUfrWZJDs6hnK5spefGVqulW1XnLEYn4bk4lo2Ip?=
 =?us-ascii?Q?ypQnqC3pqFhfsJOAi2CQWgqxy8OmsCwW51INVBUfe1t/hxQwsf90cwy3e9XU?=
 =?us-ascii?Q?FV2nGlH0kpnrwY+bq5uGTwiPFzbWgDkwQke+SNqywrbEw9srA8opDvWhvFu5?=
 =?us-ascii?Q?h8Ir63Wds/GcMx6h5puQFIALPqf95rCUn7QLk3MuENUQZvsP4/6/bWpDfqjU?=
 =?us-ascii?Q?x2XnhbP5n7KVABWBgEB/6wMS1DAeMVMjXG9Wf2Fa0/1t+JoHDRplyY/L1hx9?=
 =?us-ascii?Q?x+trg4LuRwpL8VY9aSCUsSCgtZLPZ2jxi9I+FMo54VI9Jp9YiuqvkHiW0x2a?=
 =?us-ascii?Q?9kM2AZNtmxhCk4YQprDRfPoJ2Sjy1cpTD/zgenf85Xg0AiNFe+r3dFMUWyEw?=
 =?us-ascii?Q?mRwesprvdk3CK+tSMZjoxsolUMBE0l5zcwj4EvzGi7G92amS5NCsX5It+PPL?=
 =?us-ascii?Q?MZ1Yj/Aj+jHYFSAb4F7MLVpPf8Pk6WBjn+elnn0AoDY9b5Wdg2Vk1FJt8BLM?=
 =?us-ascii?Q?5rWPJ7tInwD00WCnUhxPKwte1XIChtomqgmpdJwm9oj3AHukMmxlYzL0VFTG?=
 =?us-ascii?Q?wN3pAB8Yv8bW9CKrdCv8E1ZsNeaEZSbccxe7CMFhgSl2nelkvuO4VN1+0MFn?=
 =?us-ascii?Q?R9LvJb0UQlahTGZCeCJKplogCGPub9z3M6jgiSMGPpT6xtVc06iDVb2FX1ci?=
 =?us-ascii?Q?mGAa7VLUmGmMX8fVQ5rueko5znXInPdWmXuN8MLbxb6hEJXpymAqsffChTGo?=
 =?us-ascii?Q?QOO/hw5BBRH72aPggn3ueRtpu4o8566tLCuaXOJSBv/8j6PazmraHREVSK9c?=
 =?us-ascii?Q?cg=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 7232b5d1-0ce5-4e29-b146-08dc48c893d4
X-MS-Exchange-CrossTenant-AuthSource: GVXPR05MB11233.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 10:29:09.2489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GswgwG9bEjUrvtHjlfIEXbh7mYpkuk4pMPb7NfGNiGAiiV4X+s/isOvgbZ7zSWuAn8/t8Otmc0iwgzjlg7jaOjatkjF5Peh45kBaQ9/8H1A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR05MB9177

On Wed, Mar 20, 2024 at 10:51:39AM +0100, Pablo Neira Ayuso wrote:
> On Wed, Mar 20, 2024 at 10:31:00AM +0100, Sven Auhagen wrote:
> > On Wed, Mar 20, 2024 at 10:27:30AM +0100, Pablo Neira Ayuso wrote:
> > > On Wed, Mar 20, 2024 at 10:20:29AM +0100, Sven Auhagen wrote:
> > > > On Wed, Mar 20, 2024 at 10:07:24AM +0100, Pablo Neira Ayuso wrote:
> > > > > On Wed, Mar 20, 2024 at 09:49:49AM +0100, Sven Auhagen wrote:
> > > > > > On Wed, Mar 20, 2024 at 09:45:16AM +0100, Pablo Neira Ayuso wrote:
> > > > > > > Hi Sven,
> > > > > > > 
> > > > > > > On Wed, Mar 20, 2024 at 09:39:16AM +0100, Sven Auhagen wrote:
> > > > > > > > On Mon, Mar 18, 2024 at 10:39:15AM +0100, Pablo Neira Ayuso wrote:
> > > > > > > [...]
> > > > > > > > > diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> > > > > > > > > index a0571339239c..481fe3d96bbc 100644
> > > > > > > > > --- a/net/netfilter/nf_flow_table_core.c
> > > > > > > > > +++ b/net/netfilter/nf_flow_table_core.c
> > > > > > > > > @@ -165,10 +165,22 @@ void flow_offload_route_init(struct flow_offload *flow,
> > > > > > > > >  }
> > > > > > > > >  EXPORT_SYMBOL_GPL(flow_offload_route_init);
> > > > > > > > >  
> > > > > > > > > -static void flow_offload_fixup_tcp(struct ip_ct_tcp *tcp)
> > > > > > > > > +static s32 flow_offload_fixup_tcp(struct net *net, struct nf_conn *ct,
> > > > > > > > > +				  enum tcp_conntrack tcp_state)
> > > > > > > > >  {
> > > > > > > > > -	tcp->seen[0].td_maxwin = 0;
> > > > > > > > > -	tcp->seen[1].td_maxwin = 0;
> > > > > > > > > +	struct nf_tcp_net *tn = nf_tcp_pernet(net);
> > > > > > > > > +
> > > > > > > > > +	ct->proto.tcp.state = tcp_state;
> > > > > > > > > +	ct->proto.tcp.seen[0].td_maxwin = 0;
> > > > > > > > > +	ct->proto.tcp.seen[1].td_maxwin = 0;
> > > > > > > > > +
> > > > > > > > > +	/* Similar to mid-connection pickup with loose=1.
> > > > > > > > > +	 * Avoid large ESTABLISHED timeout.
> > > > > > > > > +	 */
> > > > > > > > > +	if (tcp_state == TCP_CONNTRACK_ESTABLISHED)
> > > > > > > > > +		return tn->timeouts[TCP_CONNTRACK_UNACK];
> > > > > > > > 
> > > > > > > > Hi Pablo,
> > > > > > > > 
> > > > > > > > I tested the patch but the part that sets the timout to UNACK is not
> > > > > > > > very practical.
> > > > > > > > For example my long running SSH connections get killed off by the firewall
> > > > > > > > regularly now while beeing ESTABLISHED:
> > > > > > > > 
> > > > > > > > [NEW] tcp      6 120 SYN_SENT src=192.168.6.55 dst=192.168.10.22 sport=55582 dport=22 [UNREPLIED] src=192.168.10.22 dst=192.168.6.55 sport=22 dport=55582 mark=16777216
> > > > > > > > [UPDATE] tcp      6 60 SYN_RECV src=192.168.6.55 dst=192.168.10.22 sport=55582 dport=22 src=192.168.10.22 dst=192.168.6.55 sport=22 dport=55582 mark=16777216
> > > > > > > > [UPDATE] tcp      6 86400 ESTABLISHED src=192.168.6.55 dst=192.168.10.22 sport=55582 dport=22 src=192.168.10.22 dst=192.168.6.55 sport=22 dport=55582 [OFFLOAD] mark=16777216
> > > > > > > > 
> > > > > > > > [DESTROY] tcp      6 ESTABLISHED src=192.168.6.55 dst=192.168.10.22 sport=54941 dport=22 packets=133 bytes=13033 src=192.168.10.22 dst=192.168.6.55 sport=22 dport=54941 packets=95 bytes=15004 [ASSURED] mark=16777216 delta-time=1036
> > > > > > > > 
> > > > > > > > I would remove the if case here.
> > > > > > > 
> > > > > > > OK, I remove it and post a v2. Thanks!
> > > > > > 
> > > > > > Thanks and also the hardcoded TCP_CONNTRACK_ESTABLISHED in flow_offload_fixup_ct
> > > > > > should be reverted to the real tcp state ct->proto.tcp.state.
> > > > > 
> > > > > ct->proto.tcp.state contains the state that was observed before
> > > > > handling over this flow to the flowtable, in most cases, this should
> > > > > be TCP_CONNTRACK_ESTABLISHED.
> > > > > 
> > > > > > This way we always set the current TCP timeout.
> > > > > 
> > > > > I can keep it to ct->proto.tcp.state but I wonder if it is better to
> > > > > use a well known state such as TCP_CONNTRACK_ESTABLISHED to pick up from.
> > > > 
> > > > In case of a race condition or if something is off like my TCP_FIN
> > > > that is beeing offloaded again setting to to ESTABLISHED hard coded
> > > > will make the e.g. FIN or CLOSE a very long state.
> > > > It is not guaranteed that we are still in ESTABLISHED when this code
> > > > runs. Also for example we could have seen both FIN already before the
> > > > flowtable gc runs.
> > > 
> > > OK, I just posted a v2, leave things as is. I agree it is better to
> > > only address the issue you are observing at this time, it is possible
> > > to revisit later.
> > > 
> > > Thanks!
> > 
> > Thanks, I will give it another try.
> > I think for it to be foolproof we need
> > to migrate the TCP state as well in flow_offload_teardown_tcp to FIN or CLOSE.
> 
> My patch already does it:
> 
> +void flow_offload_teardown_tcp(struct flow_offload *flow, bool fin)
> +{
> +       enum tcp_conntrack tcp_state;
> +
> +       if (fin)
> +               tcp_state = TCP_CONNTRACK_FIN_WAIT;
> +       else /* rst */
> +               tcp_state = TCP_CONNTRACK_CLOSE;
> +
> +       flow_offload_fixup_tcp(nf_ct_net(flow->ct), flow->ct, tcp_state);
> 
> flow_offload_fixup_tcp() updates the TCP state to FIN / CLOSE state.
> 
> > They way thinks are right now we are open to a race condition from the reverse side of the
> > connection to reoffload the connection while a FIN or RST is not processed by the netfilter code
> > running after the flowtable code.
> > The conenction is still in TCP established during that window and another packet can just
> > push it back to the flowtable while the FIN or RST is not processed yet.
> 
> I don't see how:
> 
> static void nft_flow_offload_eval(const struct nft_expr *expr,
>                                   ...
> 
>         switch (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum) {
>         case IPPROTO_TCP:
>                 tcph = skb_header_pointer(pkt->skb, nft_thoff(pkt),
>                                           sizeof(_tcph), &_tcph);
>                 if (unlikely(!tcph || tcph->fin || tcph->rst ||
>                              !nf_conntrack_tcp_established(ct)))
>                         goto out;
> 
> this would now be either in FIN/CLOSE state.
> 
> FIN, RST packet does not trigger re-offload. And ACK packet would find
> the entry in !nf_conntrack_tcp_established(ct).
> 
> What path could trigger re-offload after my latest patch?

From looking through the nf conntrack tcp code you need to spin_lock
the TCP state change to avoid a race with another packet.

> 
> For the flow timeout case (where flow entry is released and packets
> goes back to classic conntrack path) re-offload is possible, but that
> is a feature.
