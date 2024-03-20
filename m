Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2120.outbound.protection.outlook.com [40.107.8.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDDB405CE
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2024 08:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.8.120
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710924599; cv=fail; b=iVW+HLIKtWdtzJKIgBn6FTtNZkqBY2CmLB5K4/OImBSvNLPghcFb5wgYpLBa+TfXf4qdvLIXjx85WWc3EcymiYkJoJpV8m1iyugcmT3dpOakiwlF+pHZ7KOya78rEbrwSLbUtREl+sVz+tH4Ju+/6SIIFuwpYlFNt1aIX2YwnRU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710924599; c=relaxed/simple;
	bh=Cf3KD1LdDVU5iYw8XqJrhZ6c7zXiV1PoCIDFMoV5dH8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ry6DyjSADyZzl28lSgvmLY7C4nwmx0IOw2OJWDuthX2hQiRpl2d7AHjScr1wOtmotnU+x4b4hFP7CukvnBPBxA2IVBwHC496i4xjGud4zN1tfrHHBnXUGQb5DcJWic+jj6ZxpIvsBD4gZdsUG3fJyzsf+qeTdqaXs8bnhSnQkUo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de; spf=pass smtp.mailfrom=voleatech.de; dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b=HShh9bVE; arc=fail smtp.client-ip=40.107.8.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=voleatech.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="HShh9bVE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GRAdj8o4BXbMBRN4175c0gyB55IwI625EOB7tLGu/UVjJR8bI3pSVYpyiDFjHgYqB3v+c32CAM+RAItv/xIFEi64wcOL88t3UNFYwYShDfybjJTcDeJ4fwgBAv1tMVchcQegcj5iOU0tu5ijrC4nPMvXonG4s6dnqRIA2rmbhYnzjmdJcXQs3EjSeL9GVJsBWm3Xwy2qFFW4KCLNprpY940O39/6sXvUPJzxUeUMYzHYtxBYFRErnq6Ehbk0o5kfFkLeX6tFe5Cwb7RKUBKaNIcrHu60OnKXDqymbg7VPNWmiX7rxGBVDYlZCRjXNwPa6qU/eJuaYPltp7V8FoUZ1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ss3+x+8YyEIhea4ogOu8r+o89y1hqHe1OKf0yD9mEiE=;
 b=lD1o8eD8Urvt48AQ1bK0POSf1Mf5kuSTwebtMCKigt28HPGQmgw4KZMM+SixcTvwkYLdwfxvYAzHE15Tdhwl1zGucEZP952TgrXOhOIFkgmlzQgrh6Zdm9JPhb2uJY8MgLy0b6vfHtH4xy5cCN2ZgSHMyGI5whzAgVeFVSUupdyfVHATxYD29UYHn2Cnd5EhrR8olfLZaE45ijwJAXeISCepJqE3VJU1y4zQKRuf2TkbetA58+BzghCVAgQ1fqTQRBMrFECHGHqbkRFs/ibedQw6jTgUKIa/oIkcZ38QOycldTxtoUrAEBgW9QjLj86uocw5FtglM9Scu2TccgNhMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ss3+x+8YyEIhea4ogOu8r+o89y1hqHe1OKf0yD9mEiE=;
 b=HShh9bVEPN42p5hgnmzsrkVQsU7e5h0ivpvytQrmcBWIhs5DIQBeWsE059/fu4znwL0KYZZ/7Im625l4c5ckr7JeON2jS+7wamEGs0WhTFxVhvqobBjzgDSn56Yk/cW0VJafQKsW5JMro6ayoOTUo4guB47hJX5CIcHcgTTM65o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from GVXPR05MB11233.eurprd05.prod.outlook.com
 (2603:10a6:150:14e::13) by AS8PR05MB10396.eurprd05.prod.outlook.com
 (2603:10a6:20b:5ac::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.30; Wed, 20 Mar
 2024 08:49:53 +0000
Received: from GVXPR05MB11233.eurprd05.prod.outlook.com
 ([fe80::9d0c:55e:de01:2a2b]) by GVXPR05MB11233.eurprd05.prod.outlook.com
 ([fe80::9d0c:55e:de01:2a2b%2]) with mapi id 15.20.7362.019; Wed, 20 Mar 2024
 08:49:53 +0000
Date: Wed, 20 Mar 2024 09:49:49 +0100
From: Sven Auhagen <sven.auhagen@voleatech.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, cratiu@nvidia.com, ozsh@nvidia.com, 
	vladbu@nvidia.com, gal@nvidia.com, fw@strlen.de
Subject: Re: [PATCH nf] netfilter: flowtable: infer TCP state and timeout
 before flow teardown
Message-ID: <lajzqkqbqptfa6m6ntyseutpmbnrrc4yb26x6lwjaxm3aldzvc@u33db2j37rtb>
References: <20240318093915.10358-1-pablo@netfilter.org>
 <zxdruu67c2xs6zrhagjilitxu5ysik5x7zvk3kthzcclype22c@nevv7c7adz7z>
 <ZfqiHPpUfFwHI5-h@calendula>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfqiHPpUfFwHI5-h@calendula>
X-ClientProxiedBy: FR4P281CA0335.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ea::15) To GVXPR05MB11233.eurprd05.prod.outlook.com
 (2603:10a6:150:14e::13)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GVXPR05MB11233:EE_|AS8PR05MB10396:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f3efc3e-a3b9-4269-2530-08dc48bab60e
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	26rrbK4AwbAnAu8Cj3Lh7KRRtX3KCHbHWnpDMFcAFLVGgWJneiZAS9Ogyu5D8lNj+rzytTDr/MQ1LQ0O86oRjF7NKPmAvuSlPwgSowutJYXlAYvbXLGiFah/xsFzauonnvm5C0ge7tBKzSqHJD3zTfb0QAGDpgQoHGq2Qb2ujvDEj54c+BRQpbeFDU1K9sQd9gAfD8NkpvEK7iwvYA0wL2Cd7FYq9bCIysaMwdnrrCNCUI1CTkQCL0ezKEBcCFKMztt1vti0+wAo7yNRsidPEh9rYx9P+kHPZiUkPU8BQ3cHhMbf+HFbxKmQlSwyZYB+2pxnMbW7489Xl2G817PHn3RX8VgQyy0LabpVib0YQJAGA1uGQYPd/4aULOztgHnLBC3DC+hbH8hGJ2pTh+fSJjLcWDbj43LDcZ3WvgTFDTk34nNGrFyVcUDQFFR7dnwl28xZa1lND3YdzaDT07Ar+kG0b7PeON95uZJA+26Zef96t8UVrGgzSQr/rw1uaQBFS8ypuX/qwLCWNOiErgkbRMTNKZPsdTsGg5iaBUPGL9KJTaKbkAq3en3Q+KmSz8taXPgqX84kHz6h/wIMyFHeThcjjYyZqeTRRH2iHoEiMMoPNS0O1fIhg1nUEvpaYaWccntyzTlnt73XPrhhyz4m6plkbvYxJtI/bXVrTMXAi88=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR05MB11233.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pPvCwPANvug0YjM9ORAHX9CigwuxaAPU4PfCa9gciAUvwMAB/FxVGlHGlEND?=
 =?us-ascii?Q?jzp5PLHpqRe9Gvj9RQKg7Sdb04uv7F6R8kBVzp2avadEE7spLnLtfNxkCdgH?=
 =?us-ascii?Q?NUg6t9Pg2SvXXU64neTYXUZ9UOt/IAUxvL1jw6rfPFA1qY1gjVlgtE1VHHu0?=
 =?us-ascii?Q?7+Vc4+v9TM0NVyDPgEHMDns6qjwIlVA2U3xaNCvpipKyOGqrgM7+PVuP0PWq?=
 =?us-ascii?Q?7OBqI5MXCjDVpxJMWghfno4LN3xn86/y7y3IgTrvwt2w1Y4INvWc5FJwcGEi?=
 =?us-ascii?Q?5KDwptPbbWrEM24K7Qk3x597T27JuWSY7kG3WzkPRMF2vvXpqck21kONPNMG?=
 =?us-ascii?Q?gL56SppPtJ+r7TRdHJy7HkR95Tv1pZyHeRgNqHjsNql6sNwy0avJE/I/4D1t?=
 =?us-ascii?Q?HIAsm3b5r9AlgzaPXTdMWsbl99qEBXtO6OuXQUMPlF0yLd57bgW1J7O+zuBZ?=
 =?us-ascii?Q?rs5yZjOmbcOoDZ5uhezEBifyVfCUJm29KkZWSk2gwbCiMuiX6+3W8MiOY+aQ?=
 =?us-ascii?Q?4QU7g+unYk7wvXZ1O95pxiy8jryM3L9wyYAh515R3E2/4BKOzB15sCNXdzbR?=
 =?us-ascii?Q?5QuvGPcTZi9tbZBaxRIsq/QhoD32TQAkm9ne0uW8EhzSmNrA7ohxhDx99btY?=
 =?us-ascii?Q?nuaLMKZ8zNkeclUiQSVEoEyJVRkT81iKdoryI+CtVXGRNx0+0LwYrlboi+vE?=
 =?us-ascii?Q?wla2HaVHUE0L2YQ2RXAFhoI5rRG0OWJPaV2Pu23bZvo6vHU+mcW+2xfTnkgA?=
 =?us-ascii?Q?U3M2HGJDmFd1gz3tYTpovOFLRzi8wYMzSywuH+R6qIsWbClC7QF+GKrjcq8i?=
 =?us-ascii?Q?htjfW4nG3s60dAAYRGlYDLPPri5Eu9AqhKYfmcOkLPb2NzNOJussKu/CXDWd?=
 =?us-ascii?Q?VMJcqLX4pXIt9qA34zIRuF8WlEpe/m4s2qSs4b8f8KMZoRUdGJWICHCv+YHD?=
 =?us-ascii?Q?Y9qho+SzLUjt5g4sWsRtvq8kbxfewNifWepipdD+3MAsuNOKCg/UC29dLJ/f?=
 =?us-ascii?Q?OG3KR5PQspa2LF+0Yy7M4dMZcK+PGqqN/sbqXJldiUaR96Cgrz8sZVrCnZ53?=
 =?us-ascii?Q?ueOmIoQF7W8N7nwlHS2av3AR39DW8xjwK3igS+RsV9eqIDyubhx7Np7Q7LYQ?=
 =?us-ascii?Q?VAy/1vQh/N0ZeyXXsj6yaWuj37VK4o2ZCAj7MIGiD/+zURXcxTrBkStw4pyF?=
 =?us-ascii?Q?5YokHFGmWeJXud/MSspVRsXITwtdyKd2V0wecaFjBHwmKurymSk29zV9tSgE?=
 =?us-ascii?Q?EpkOWXr7xbp3n2OkdduXGkVHibTi4Si4bszZDqiKo5KxBJd1CP3f+QlWmi4a?=
 =?us-ascii?Q?3r+4XEAn7oqnNZeEIYeGvO+bi8FV6KVbOuFxG9B5OI41NrMJjVihOgLsqn8w?=
 =?us-ascii?Q?UQ+OkD1yunAYVX9D36Aw2pQ8VnOUbuSfi0pYW+Q3yduS6yHjLI8H9CpnYWqs?=
 =?us-ascii?Q?qP4YWUIhf/LLbaPNvUnSVgo394o1HHozZwOq8Baz3KeDYMs2NWG29K0OCaVu?=
 =?us-ascii?Q?KTo82WgJr/BfCh/Kk2Cs1d3PmSa5BNlwvhsCJniSAWeH6MBL3JVTtLIrkcIm?=
 =?us-ascii?Q?YZfu4P/FjNsjh5nISWZafmojhExl11FyZJIdr7ZWMJ4tEn5wPZ1h1tU9P05O?=
 =?us-ascii?Q?BQ=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f3efc3e-a3b9-4269-2530-08dc48bab60e
X-MS-Exchange-CrossTenant-AuthSource: GVXPR05MB11233.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:49:53.7286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UTHWYawXD9QD4FxfrH0qnTDWRy6WTb6iXsbBhpGbTdEfb0c54CCIbUFAqBztiWg33afa0au4MFVyp4luuDW/y2a/xF54bvyWl0opvg0Md2M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR05MB10396

On Wed, Mar 20, 2024 at 09:45:16AM +0100, Pablo Neira Ayuso wrote:
> Hi Sven,
> 
> On Wed, Mar 20, 2024 at 09:39:16AM +0100, Sven Auhagen wrote:
> > On Mon, Mar 18, 2024 at 10:39:15AM +0100, Pablo Neira Ayuso wrote:
> [...]
> > > diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> > > index a0571339239c..481fe3d96bbc 100644
> > > --- a/net/netfilter/nf_flow_table_core.c
> > > +++ b/net/netfilter/nf_flow_table_core.c
> > > @@ -165,10 +165,22 @@ void flow_offload_route_init(struct flow_offload *flow,
> > >  }
> > >  EXPORT_SYMBOL_GPL(flow_offload_route_init);
> > >  
> > > -static void flow_offload_fixup_tcp(struct ip_ct_tcp *tcp)
> > > +static s32 flow_offload_fixup_tcp(struct net *net, struct nf_conn *ct,
> > > +				  enum tcp_conntrack tcp_state)
> > >  {
> > > -	tcp->seen[0].td_maxwin = 0;
> > > -	tcp->seen[1].td_maxwin = 0;
> > > +	struct nf_tcp_net *tn = nf_tcp_pernet(net);
> > > +
> > > +	ct->proto.tcp.state = tcp_state;
> > > +	ct->proto.tcp.seen[0].td_maxwin = 0;
> > > +	ct->proto.tcp.seen[1].td_maxwin = 0;
> > > +
> > > +	/* Similar to mid-connection pickup with loose=1.
> > > +	 * Avoid large ESTABLISHED timeout.
> > > +	 */
> > > +	if (tcp_state == TCP_CONNTRACK_ESTABLISHED)
> > > +		return tn->timeouts[TCP_CONNTRACK_UNACK];
> > 
> > Hi Pablo,
> > 
> > I tested the patch but the part that sets the timout to UNACK is not
> > very practical.
> > For example my long running SSH connections get killed off by the firewall
> > regularly now while beeing ESTABLISHED:
> > 
> > [NEW] tcp      6 120 SYN_SENT src=192.168.6.55 dst=192.168.10.22 sport=55582 dport=22 [UNREPLIED] src=192.168.10.22 dst=192.168.6.55 sport=22 dport=55582 mark=16777216
> > [UPDATE] tcp      6 60 SYN_RECV src=192.168.6.55 dst=192.168.10.22 sport=55582 dport=22 src=192.168.10.22 dst=192.168.6.55 sport=22 dport=55582 mark=16777216
> > [UPDATE] tcp      6 86400 ESTABLISHED src=192.168.6.55 dst=192.168.10.22 sport=55582 dport=22 src=192.168.10.22 dst=192.168.6.55 sport=22 dport=55582 [OFFLOAD] mark=16777216
> > 
> > [DESTROY] tcp      6 ESTABLISHED src=192.168.6.55 dst=192.168.10.22 sport=54941 dport=22 packets=133 bytes=13033 src=192.168.10.22 dst=192.168.6.55 sport=22 dport=54941 packets=95 bytes=15004 [ASSURED] mark=16777216 delta-time=1036
> > 
> > I would remove the if case here.
> 
> OK, I remove it and post a v2. Thanks!

Thanks and also the hardcoded TCP_CONNTRACK_ESTABLISHED in flow_offload_fixup_ct
should be reverted to the real tcp state ct->proto.tcp.state.
This way we always set the current TCP timeout.
I am doing more tests with that now.

> 
> > > +
> > > +	return tn->timeouts[tcp_state];
> > >  }
> > >  
> > >  static void flow_offload_fixup_ct(struct nf_conn *ct)
