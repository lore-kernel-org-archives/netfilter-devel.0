Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2118.outbound.protection.outlook.com [40.107.21.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F9A3FB84
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2024 11:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.21.118
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710933362; cv=fail; b=kf3nxEX8AP7XcKtHXF1RpkgzxKzsmIWGYY+o1SJxMKE0e/eYKB6U6m/OPKYKqT3fndyegOt6d/o1kOoTetHC3ea0GdcogMJaxXt3DRhPU8aBNBImR1H37bwTYL9qDT44QGSCKGIdawxI0gzDkOEki5wvvB7b3vFyh2idA5YabWY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710933362; c=relaxed/simple;
	bh=zqB3p9g518fV1fuqk3liX/TSyre2ZtZEygw0NdyKmJo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=MMjnlGDoXJHdWfo9HefbxK2yA46R9IXixmT5/boWajNzPzCvYRDuB6kJq1ggQgOu248RXlrFWk7TrnCQ8rbJWaZabquZpiV5/80jPQMgov7RZgHi8ULaRmbjcm0Kww5voitvSN+YD+4l1dh78FlW6QKDGS2arS3TRbF1mnfhujU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de; spf=pass smtp.mailfrom=voleatech.de; dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b=QpG5b8QA; arc=fail smtp.client-ip=40.107.21.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=voleatech.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="QpG5b8QA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ea9hoy/G8dm/7uc4UUTKt5WQ6p5iksWhfnbR2CQ5BFVeBDIA3XrkvYXNSEVDapDLmPffBLVXfVGGUnQOk8EKJFG8Vp7EyLmE5623pzRbabMzWfXJkeLImuNVtaz3srD9peVsOx8WSSya1UVt6ECNTF9UIc4DXbQrGa2tGik4Y/wLnFJkNz33frOihP5UeMQPLY/wAF+61fQllG2hFD4N2/3LVB+ZyZhosjSSFZdGhEpMRG4TxOH5QvuSw2LJAQ5XyRMq0IQU2NiX83PZN4yEunDF5h10EjSD1w+WayrIY7cfQOR0reYwbFdfUwmM3WUbiu2cc8LvPNHCt/akNc7thA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QXNxHc3APKNThlEDvI7/y0NglMlOmJDbaDbsvyDAinE=;
 b=foUed18HfTuYTWAbsqPeUDm/glZeZHu+yEgUADZkLeafNGgsAwkePDGd+oA1S4ji5JlPMy0aeBAcJR+O2J5MnlKmY8m7fSDFgzrZPsBgg9IaEpTPxwek4i9xvJslX6nRoPrxFWB+30SolNNIQwCXpW80SbDlrnI59WFtuuOSp6MaL95a6BkKE+jdeugFfUXFqHR/nskGaZ6w9zjZB/xNKAav/HI7q0SfLjpCBegTQtpkeWxvgr++aW9Wu7samuKM45C0dA5TEh9U86yOgWgY0aFU5NfX3gpFrOLO16mEkRMKuj2QQpkjGZsikKeN5sr5qzP675GngthHpb9Y70MzRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QXNxHc3APKNThlEDvI7/y0NglMlOmJDbaDbsvyDAinE=;
 b=QpG5b8QALeHipH/iGtJRs2Q/Yh0YS/CnYGC1nN+e+SkPywIY2iDTOBrsxPDqGBYAz4qY/P3ddZgeFsnHzNWEduNkQvbp+NOzCJuZzE7G2FsDYPp6z/R7jQRWrfKdQ/U32AHZpMFkeB2n3TAhO0rLRhcbnm3A9EIE0gUMv1+C/ls=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from GVXPR05MB11233.eurprd05.prod.outlook.com
 (2603:10a6:150:14e::13) by PAXPR05MB8447.eurprd05.prod.outlook.com
 (2603:10a6:102:1a4::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.29; Wed, 20 Mar
 2024 11:15:56 +0000
Received: from GVXPR05MB11233.eurprd05.prod.outlook.com
 ([fe80::9d0c:55e:de01:2a2b]) by GVXPR05MB11233.eurprd05.prod.outlook.com
 ([fe80::9d0c:55e:de01:2a2b%2]) with mapi id 15.20.7362.019; Wed, 20 Mar 2024
 11:15:55 +0000
Date: Wed, 20 Mar 2024 12:15:51 +0100
From: Sven Auhagen <sven.auhagen@voleatech.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, cratiu@nvidia.com, ozsh@nvidia.com, 
	vladbu@nvidia.com, gal@nvidia.com, fw@strlen.de
Subject: Re: [PATCH nf] netfilter: flowtable: infer TCP state and timeout
 before flow teardown
Message-ID: <o7kxkadlzt2ux5bbdcsgxlfxnfedzxv4jlfd3xnhri6qpr5w3n@2vmkj5o3yrek>
References: <zxdruu67c2xs6zrhagjilitxu5ysik5x7zvk3kthzcclype22c@nevv7c7adz7z>
 <ZfqiHPpUfFwHI5-h@calendula>
 <lajzqkqbqptfa6m6ntyseutpmbnrrc4yb26x6lwjaxm3aldzvc@u33db2j37rtb>
 <ZfqnTJKyW1VSIOgY@calendula>
 <lderg42fd4jbcwsztkidn3lhnjhufj5yv3zsdu4dpsenzikkta@cya5vq3prnzf>
 <ZfqsAoSNA4DRsVga@calendula>
 <nvslglowbvxntlpftefkumbwn2gz72evwnfvv4q2qencte7wyn@3jejk23urzeg>
 <Zfqxq3HK_nsGRLhx@calendula>
 <xvnywodpmc3eui6k5kt6fnooq35533jsavkeha7af6c2fntxwm@u3bzj57ntong>
 <Zfq-1gES4VJg2zHe@calendula>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zfq-1gES4VJg2zHe@calendula>
X-ClientProxiedBy: FR0P281CA0055.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::15) To GVXPR05MB11233.eurprd05.prod.outlook.com
 (2603:10a6:150:14e::13)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GVXPR05MB11233:EE_|PAXPR05MB8447:EE_
X-MS-Office365-Filtering-Correlation-Id: e4e0967a-7483-4e73-648c-08dc48cf1c8d
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	3Z7VqjRYxrGMFUCtDXeUd2322c/BoS83mj6RcMvErqZCyo5yLyWokcp/mY4U6011pAuZH6AFLNVcarG+iqZKi2GRJXXD7UhYSjNESVc2uw1DwPg4Ud/aAHTAAcfj/Fhj+7O3c/tzXsdjOgB6cgRqr5eSVpXVqgsh9e5Sp1yi6lDzJQkg6dlkh3wi7grB3wIppKWGcp2CXDKDAmppHA4ibIj1BzRPqnuK5ntUwwgNGmvJK5vIcyh6W7GvwceRIkB2IfmxcUWt4OVqHDYrgQC2NrCoQjipURO9qslZq3R30uNF5wbbuwxNjwn+QazS8eIUHhQbilmDj7n7p6QtwoMaW0w+moKS2Fjm0XaP8HIaq/BdvUYrFB3NdB15SrrqGjTi5rN47B9T2iBIgZoUoaB9CEVCTUowgBkYJbyRKWW/BEtfq0fSKajIj0QWxHDLqAeGyXhHFt/espLwPT5rNsL+U0KMUmpQYTMdBH4PlK8zgqP1cxH7xO2wlzTO+Zqbto/xs0ctQhDhDJkV3NRCZBl5nijiEtRDUKVV3Xh51E+B2kv+RfiTfSgvvBQm0UDuLsE+hoECj+WHkhNermZ9rBA8Ofhx2yWW/QTMYin/f6tAMlRBJgE3zsCDlWc+QTLNz2ARb43hlyJDtBlijY6ic8Zf+xKkOn9GVyWl/NtfQSpMMRY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR05MB11233.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gGqFvr9R8Oc+8QTH/iTBXYA4Vbh7wFCTFMCZTpE0Ed0d2b7T0g/KWr3DqL/M?=
 =?us-ascii?Q?g2EH46Sm3wfoouksCr4nzJYmLmcO4DOqVuA5erikn/YghQK2Tbd+knTJoicU?=
 =?us-ascii?Q?TfC43mzTVw09zeMGsZSbdAyEP6dMKZPinn1h1HHXF5b/IdcgbVXcBaqNZWJe?=
 =?us-ascii?Q?BkJn/iOfdnx0syAIfubVqtzpW5k4bt562RUDqlPUdjaG2LrIZ6lA8zkVc9e+?=
 =?us-ascii?Q?/1ur3Gh3WNabjtNY9gbHpwn7Wt1w7YMHfgoKW3opXw2Pa758m06yavPeM3Hn?=
 =?us-ascii?Q?SpT0ejMPpLSI/IaW6GdkPBSEChoi3DY7bjGPAchBgTLIAkuXXVpyAF7ANm9l?=
 =?us-ascii?Q?cukXmmoF+TRUv1FtHXAFUz3A0ATkHyXtN+hpp2Nk6HRVwfSisalx1fvCJb/Q?=
 =?us-ascii?Q?Vs2a2ijkKmEZIUE6NLn29oqkT3Y9Vt2yBS2PBcGqL2WqeE3/0cxBQ2KWjoh5?=
 =?us-ascii?Q?I+p9XDpu+kK7YbdzJA9Y6S0oEtZ5Yh4foCskM5wx2FwXcp3Htdf/gO0pAyn7?=
 =?us-ascii?Q?9jWsk/sBEjH6cZpYvkWd3igF3AAsLZbQzGWM2b3m/tXIVYa1pm+d8isLw2HG?=
 =?us-ascii?Q?VAWBGTU1/r/fUZwWkMN0A+W23ZVr3mFZt7jjELN81gcQhNnjODRQglgTAbIO?=
 =?us-ascii?Q?tNZiH73cpsaP9jRMJqUgUlJiLRau/L1A4k6q97ZenKVGMtYlC7qDdk3IjFm4?=
 =?us-ascii?Q?TZfDJ+eDHvQWEY9ANrMFt1Cd8bDIHPi9Dp2mGhWOQYWIGNk6hCnbm24wZtFJ?=
 =?us-ascii?Q?y2szRv4qsEtfNEm8N2e1Z7eD/VEzY0STg7iEjtqa1wptAVeh9e9zj2BSMBw+?=
 =?us-ascii?Q?FLLVOp21KswBq0eADi5OVy9hraaRuv/RK4+hyfFvGELed9y/oJJchI3yIVEL?=
 =?us-ascii?Q?LkvIZ2WKlH7b9L/cXT2JoX40cRChJl8OvdWcUlhvlUu9GICZ3K3Pp9RR4sWX?=
 =?us-ascii?Q?KY5OyYwDKSd40hwNPbeIaLmQQ6n8EA+L30/ypRf8K0OW5yqJ42eQ4wSM9iQW?=
 =?us-ascii?Q?Bwn2Pk5i11riEXOE61u+ZlnPXKxWp3wVJ1KJiXqJa4DrrQL4xiVqIta5Gx+Z?=
 =?us-ascii?Q?LbLaM6WCDmBq9mdjdcmcfr1xINAhr7+9TYWdUCVLrQgMduV7Drk/Fx8V8xn9?=
 =?us-ascii?Q?y2STZSBT5z6bL0F70oaNPJd580t9xbxu+BgEmTyTDQzYrmUSDaTwOpoxA58a?=
 =?us-ascii?Q?BOLi+LIbIFejrHTc1DV9J/sF+cHwGi7gwXK20S5K4eYalJLo5xdkUhCmLf5y?=
 =?us-ascii?Q?z8Lhuo1eAyyXN9nXACwfkeDtgDiCJxhnHHRY/OiH8480cBMOrsULRwuDb0/P?=
 =?us-ascii?Q?kkAM9pBQzkd68vIKx7RqKnMZEJPlGmLpVi7blEGlluUaVvM0j0B8JNsqJyl6?=
 =?us-ascii?Q?Z7RnQsJEjINsS9inlMQt7LOKMrBTSPmgCI5PjQJie+0QSyu0NpiJeY3AuV/M?=
 =?us-ascii?Q?E+h+0cSmWZdSNFHFXOCzr2j5lmcF6pO1pbTsc9/MJ4fz8wCXoIo8rZ0B0aQ6?=
 =?us-ascii?Q?xu0QJGkfyG2Il7kNkOfm5zsyxsjVwxk9hHsqtwFpGnyEpPjYZI9XPqzbCGuw?=
 =?us-ascii?Q?g0VuxH4qQYgTCX2hpPRYuIZZqtEtvhkOPuiqLELZhDSZJalXpXXb0s5Gt49d?=
 =?us-ascii?Q?PA=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: e4e0967a-7483-4e73-648c-08dc48cf1c8d
X-MS-Exchange-CrossTenant-AuthSource: GVXPR05MB11233.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 11:15:55.5565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 26Sk09LMuSHcYAjhfOa7wKHzhkPCZDBAfB6tmgILU3IwNHTHLxh0/y3b3Y3n5hZf9TmBAyEcstwguWX7JFyN0bpKcZege1ihxEGL0OOTzDQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR05MB8447

On Wed, Mar 20, 2024 at 11:47:50AM +0100, Pablo Neira Ayuso wrote:
> On Wed, Mar 20, 2024 at 11:29:05AM +0100, Sven Auhagen wrote:
> > On Wed, Mar 20, 2024 at 10:51:39AM +0100, Pablo Neira Ayuso wrote:
> > > On Wed, Mar 20, 2024 at 10:31:00AM +0100, Sven Auhagen wrote:
> > > > On Wed, Mar 20, 2024 at 10:27:30AM +0100, Pablo Neira Ayuso wrote:
> > > > > On Wed, Mar 20, 2024 at 10:20:29AM +0100, Sven Auhagen wrote:
> > > > > > On Wed, Mar 20, 2024 at 10:07:24AM +0100, Pablo Neira Ayuso wrote:
> > > > > > > On Wed, Mar 20, 2024 at 09:49:49AM +0100, Sven Auhagen wrote:
> > > > > > > > On Wed, Mar 20, 2024 at 09:45:16AM +0100, Pablo Neira Ayuso wrote:
> > > > > > > > > Hi Sven,
> > > > > > > > > 
> > > > > > > > > On Wed, Mar 20, 2024 at 09:39:16AM +0100, Sven Auhagen wrote:
> > > > > > > > > > On Mon, Mar 18, 2024 at 10:39:15AM +0100, Pablo Neira Ayuso wrote:
> > > > > > > > > [...]
> > > > > > > > > > > diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> > > > > > > > > > > index a0571339239c..481fe3d96bbc 100644
> > > > > > > > > > > --- a/net/netfilter/nf_flow_table_core.c
> > > > > > > > > > > +++ b/net/netfilter/nf_flow_table_core.c
> > > > > > > > > > > @@ -165,10 +165,22 @@ void flow_offload_route_init(struct flow_offload *flow,
> > > > > > > > > > >  }
> > > > > > > > > > >  EXPORT_SYMBOL_GPL(flow_offload_route_init);
> > > > > > > > > > >  
> > > > > > > > > > > -static void flow_offload_fixup_tcp(struct ip_ct_tcp *tcp)
> > > > > > > > > > > +static s32 flow_offload_fixup_tcp(struct net *net, struct nf_conn *ct,
> > > > > > > > > > > +				  enum tcp_conntrack tcp_state)
> > > > > > > > > > >  {
> > > > > > > > > > > -	tcp->seen[0].td_maxwin = 0;
> > > > > > > > > > > -	tcp->seen[1].td_maxwin = 0;
> > > > > > > > > > > +	struct nf_tcp_net *tn = nf_tcp_pernet(net);
> > > > > > > > > > > +
> > > > > > > > > > > +	ct->proto.tcp.state = tcp_state;
> > > > > > > > > > > +	ct->proto.tcp.seen[0].td_maxwin = 0;
> > > > > > > > > > > +	ct->proto.tcp.seen[1].td_maxwin = 0;
> > > > > > > > > > > +
> > > > > > > > > > > +	/* Similar to mid-connection pickup with loose=1.
> > > > > > > > > > > +	 * Avoid large ESTABLISHED timeout.
> > > > > > > > > > > +	 */
> > > > > > > > > > > +	if (tcp_state == TCP_CONNTRACK_ESTABLISHED)
> > > > > > > > > > > +		return tn->timeouts[TCP_CONNTRACK_UNACK];
> > > > > > > > > > 
> > > > > > > > > > Hi Pablo,
> > > > > > > > > > 
> > > > > > > > > > I tested the patch but the part that sets the timout to UNACK is not
> > > > > > > > > > very practical.
> > > > > > > > > > For example my long running SSH connections get killed off by the firewall
> > > > > > > > > > regularly now while beeing ESTABLISHED:
> > > > > > > > > > 
> > > > > > > > > > [NEW] tcp      6 120 SYN_SENT src=192.168.6.55 dst=192.168.10.22 sport=55582 dport=22 [UNREPLIED] src=192.168.10.22 dst=192.168.6.55 sport=22 dport=55582 mark=16777216
> > > > > > > > > > [UPDATE] tcp      6 60 SYN_RECV src=192.168.6.55 dst=192.168.10.22 sport=55582 dport=22 src=192.168.10.22 dst=192.168.6.55 sport=22 dport=55582 mark=16777216
> > > > > > > > > > [UPDATE] tcp      6 86400 ESTABLISHED src=192.168.6.55 dst=192.168.10.22 sport=55582 dport=22 src=192.168.10.22 dst=192.168.6.55 sport=22 dport=55582 [OFFLOAD] mark=16777216
> > > > > > > > > > 
> > > > > > > > > > [DESTROY] tcp      6 ESTABLISHED src=192.168.6.55 dst=192.168.10.22 sport=54941 dport=22 packets=133 bytes=13033 src=192.168.10.22 dst=192.168.6.55 sport=22 dport=54941 packets=95 bytes=15004 [ASSURED] mark=16777216 delta-time=1036
> > > > > > > > > > 
> > > > > > > > > > I would remove the if case here.
> > > > > > > > > 
> > > > > > > > > OK, I remove it and post a v2. Thanks!
> > > > > > > > 
> > > > > > > > Thanks and also the hardcoded TCP_CONNTRACK_ESTABLISHED in flow_offload_fixup_ct
> > > > > > > > should be reverted to the real tcp state ct->proto.tcp.state.
> > > > > > > 
> > > > > > > ct->proto.tcp.state contains the state that was observed before
> > > > > > > handling over this flow to the flowtable, in most cases, this should
> > > > > > > be TCP_CONNTRACK_ESTABLISHED.
> > > > > > > 
> > > > > > > > This way we always set the current TCP timeout.
> > > > > > > 
> > > > > > > I can keep it to ct->proto.tcp.state but I wonder if it is better to
> > > > > > > use a well known state such as TCP_CONNTRACK_ESTABLISHED to pick up from.
> > > > > > 
> > > > > > In case of a race condition or if something is off like my TCP_FIN
> > > > > > that is beeing offloaded again setting to to ESTABLISHED hard coded
> > > > > > will make the e.g. FIN or CLOSE a very long state.
> > > > > > It is not guaranteed that we are still in ESTABLISHED when this code
> > > > > > runs. Also for example we could have seen both FIN already before the
> > > > > > flowtable gc runs.
> > > > > 
> > > > > OK, I just posted a v2, leave things as is. I agree it is better to
> > > > > only address the issue you are observing at this time, it is possible
> > > > > to revisit later.
> > > > > 
> > > > > Thanks!
> > > > 
> > > > Thanks, I will give it another try.
> > > > I think for it to be foolproof we need
> > > > to migrate the TCP state as well in flow_offload_teardown_tcp to FIN or CLOSE.
> > > 
> > > My patch already does it:
> > > 
> > > +void flow_offload_teardown_tcp(struct flow_offload *flow, bool fin)
> > > +{
> > > +       enum tcp_conntrack tcp_state;
> > > +
> > > +       if (fin)
> > > +               tcp_state = TCP_CONNTRACK_FIN_WAIT;
> > > +       else /* rst */
> > > +               tcp_state = TCP_CONNTRACK_CLOSE;
> > > +
> > > +       flow_offload_fixup_tcp(nf_ct_net(flow->ct), flow->ct, tcp_state);
> > > 
> > > flow_offload_fixup_tcp() updates the TCP state to FIN / CLOSE state.
> > > 
> > > > They way thinks are right now we are open to a race condition from the reverse side of the
> > > > connection to reoffload the connection while a FIN or RST is not processed by the netfilter code
> > > > running after the flowtable code.
> > > > The conenction is still in TCP established during that window and another packet can just
> > > > push it back to the flowtable while the FIN or RST is not processed yet.
> > > 
> > > I don't see how:
> > > 
> > > static void nft_flow_offload_eval(const struct nft_expr *expr,
> > >                                   ...
> > > 
> > >         switch (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum) {
> > >         case IPPROTO_TCP:
> > >                 tcph = skb_header_pointer(pkt->skb, nft_thoff(pkt),
> > >                                           sizeof(_tcph), &_tcph);
> > >                 if (unlikely(!tcph || tcph->fin || tcph->rst ||
> > >                              !nf_conntrack_tcp_established(ct)))
> > >                         goto out;
> > > 
> > > this would now be either in FIN/CLOSE state.
> > > 
> > > FIN, RST packet does not trigger re-offload. And ACK packet would find
> > > the entry in !nf_conntrack_tcp_established(ct).
> > > 
> > > What path could trigger re-offload after my latest patch?
> > 
> > From looking through the nf conntrack tcp code you need to spin_lock
> > the TCP state change to avoid a race with another packet.
> 
> The flowtable owns the flow, packets belonging the flow cannot update
> the TCP state while the flow is offloaded to the flowtable.
> 
> Once _TEARDOWN flag is set on, then packets get back to classic
> conntrack path.

Hmm alright, something is going wrong somewhere and it looks a lot like
a race condition :)

I mean just in theory it is not guaranteed that both directions send all
packets through the flowtable just because it is offloaded.
A variety of error checks might send a packet back to the slow path.

> 
> I don't see how such race can happen.
