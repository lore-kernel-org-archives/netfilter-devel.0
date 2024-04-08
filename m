Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2096.outbound.protection.outlook.com [40.107.21.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940268473
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Apr 2024 05:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.21.96
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712553894; cv=fail; b=D9HBWf6XWAoKasF/SqB8cN7w9gpCBf+EddIB54KVdqYp65zFRfffiOxh7lKSLLwOIvC9lElTWpMUgwzmZMt+epuQPIB2hxJFWjIZyC891r4oGy9xiKiheRZZe9RWHWT+Oo6aWXCTrbZXRFmstptocvIgGTQNVvGlEjBzfAQcbZM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712553894; c=relaxed/simple;
	bh=L9NI07jRZVrsJAtpnF0UIGF9N3HYwpNsCi5PQeitNM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IBo8n80TkfcgD/k9FRK4y3jhYDXkkbx1ayzq+8IeaY+vHV3cefe9u5HnFMjofVjE7VpSsvTuI+AtaGNsimpnb7sTZpzKKGeaWQhxGXeSbbIBqncGPXuN8RIC+qEr9ioNz4CJ+mtYiVLdbWJj//qOz4GUSHIDD0NuM0b97XWlDUU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de; spf=pass smtp.mailfrom=voleatech.de; dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b=HoZsbeWz; arc=fail smtp.client-ip=40.107.21.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=voleatech.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="HoZsbeWz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CI623/tg4F+RN1ZguyXFg7mMQ3jP7rVzUKCWSrSjjeQ65vkyP8jhlQUsMLnmChgooghxze/PcuH1572/NfaSxwtBDOW07psi67CuHsD8U/ueIWC8EbPu0deztaSpunqdv/XOPILtDiT5zEXElBV0q2brW6fjbCVtmMfZ3r5KHpzHpgynxZnBxKhFLcG6/MOK9sGfzhhYPp6lSKkeCFIQH5yeBEk6Vm0PB5akaSVkLKxgdgXe4oswSWXOc/+UBI4tG0hd+NQCEHJmufVNJ9mi1TVE7yaLiCok7MPhesvANtMWT3grzQg8+njR0WKmpXCT64eGcUHGmn1o8Nhk45mhRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=By8i65COgyWaI0mfKYHgiBDerP9MvnuJiRgtEZLWc78=;
 b=MTyp10dNY5v3l3rv624D121KZ/O2B0X2XKU7p7FBiOAH3qMpuc2dq2kr3yPjqj0lc/E3XcnBk5aB2sj4QWiZTi7iomB0+FDfUHTGNLxC+r7qkExSRWzmTmuQHut8+DPnATAPBfoJpMj6FM/LybWodXRqElieucAvpCqDFKGKaLPkbSm0Ebsp6n8bFmUSX/Cu500wWH947110nzORe6+2SW61CXkoRC8Ud+YfjCdUPokePCF4NmtaJoZ8PHjxriiYTk+n39NYl3l2RPElUF4l9ewOjj4OYZtu31DLr+1+hS31c2Sid6Sc2V2/L9DiEZXc7ricSCI8KVVgyjes5alaGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=By8i65COgyWaI0mfKYHgiBDerP9MvnuJiRgtEZLWc78=;
 b=HoZsbeWzb4oQlTuD+QpeLRfkvHNxuP5uMortGIzJFKJLN99Gk7JOGcRSSofVpI+JjQf1vpkSFS/P/JWhWMKlJXZmbIoLU4boWUd6r9cgc2dop1dha+F/foVw0m2PFls/7OOVzjvy9dp/2l8nmgiSGkCwVkvw6hqioV7FIxdV+y0=
Received: from DBBPR05MB11225.eurprd05.prod.outlook.com (2603:10a6:10:538::14)
 by DB8PR05MB6731.eurprd05.prod.outlook.com (2603:10a6:10:13c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.55; Mon, 8 Apr
 2024 05:24:47 +0000
Received: from DBBPR05MB11225.eurprd05.prod.outlook.com
 ([fe80::eb7:22e6:e723:9086]) by DBBPR05MB11225.eurprd05.prod.outlook.com
 ([fe80::eb7:22e6:e723:9086%6]) with mapi id 15.20.7409.039; Mon, 8 Apr 2024
 05:24:47 +0000
Date: Mon, 8 Apr 2024 07:24:43 +0200
From: Sven Auhagen <sven.auhagen@voleatech.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, cratiu@nvidia.com, ozsh@nvidia.com, 
	vladbu@nvidia.com, gal@nvidia.com, fw@strlen.de
Subject: Re: [PATCH nf] netfilter: flowtable: infer TCP state and timeout
 before flow teardown
Message-ID: <x3qvcfxgdmurfnydhrs7ao6fmxxubmhxs2mjk24yn5zjfbo3h5@esbr3eff7bir>
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
X-ClientProxiedBy: FR0P281CA0037.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::19) To DBBPR05MB11225.eurprd05.prod.outlook.com
 (2603:10a6:10:538::14)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBPR05MB11225:EE_|DB8PR05MB6731:EE_
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	cadtR7pM3BTf4U4xxHwNQW75P1BeNUVgFcWfVyc8Gub55kwHqL2sFSdrIPMgXhjhyLhgSpmOesktA/HBlhMPR3T+iQtpMgJulwcrZT7WGSDQuEnzXWkU9MmYQphS4tAN8h1Pp6zN+aX/KGg9jcvSHJTeohxUFFtF5oiMMxJhMhodFh80Q+0Bkjjv3TKFAt/IvzW8mRu4hPPlIGbEcHtLp5B3xUQR2Sr6xijOLRl+HkwfQ3VYd340KoY4d1Y5oLxQMqD570QGJ4P7j/NfGHVh3J9ZvCMeR/vtvL1cbFE3f9r2drz7Qvm3JeEpuTVPmRi51ZJZM37ulNx4s/dIXzulPC740IrF3m6ZAWpRucUkqtrFiCIN6ardQDLwQH7H0eKLWLuSbtnEMayPpzSJzd3EEBsEs1KNVxgS4Qg1g1sqPfYtOOL29HRh1Bs2bfN52Z82Y2D93uVkFRfYqgL/5dxVLY8SKStyVC+NDgb8dx8m4YJZWIaJhqMu480lWCZr9gmpxk48oJeKISRwfVhtDFPm4n0FWDF8IEYOoVea8zyoFtGHTq81p0sDGn0qUUPcfdZmaVj0porPe7ywa95DRh1GiragWnYdR9eLrGnFmUqKCMdAlXjIli9JKjIuA/ZP4n06QyERfwY+gLYT4vCYW99ukK9KPcGCpi9t00S5VGkFcfE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBPR05MB11225.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GO0oIFwJScLkJT/nvI26h7GlUvw0x6PGEHJzguFRN6acCJ4TXkoaKOSbsmsy?=
 =?us-ascii?Q?BKp2vhh7XUX6oLTyTzmT8pN41B77PhZ1gLjIjTIUJm4NlwYnvHFN28oxZuK2?=
 =?us-ascii?Q?rdqRkxuyn6gXrY9z1FC1QYN0iPWXcv9Ohy/ky5/PDbUvoXl7A//VRqHC1zOa?=
 =?us-ascii?Q?5My5urJFQi3M1/32SlB0JsPBv8cI/WSfAUwNu2XFQs76wX4QlCBBuP3LA5Gj?=
 =?us-ascii?Q?1CNfNDfhLeR1kGV43TW/+cohwNzqw8MVcAQxRmHwDiAF9txxleH9T1tD7En4?=
 =?us-ascii?Q?ZgzIQGyeg0s7jMWe6clIybFDOPN/wuUvl691C40KwhTOlAO+JI9K6baO7kN4?=
 =?us-ascii?Q?/c1qfT6sETrIJj/UaD8+0D66pqdO4bZFyiF2c/HMWhZ5A4pOvRd9pc2g2SKl?=
 =?us-ascii?Q?lwci4nbqTxkHu58cOP/ER+pzHtlS8egQpkxX7FYyigZDhX9+Z7TnRhzuShlT?=
 =?us-ascii?Q?TewlIxYh19y6Lb6CzREAT/8lGEIN17ye0PTe6+GJ+mnx93oKjVU3vUKTg8Gl?=
 =?us-ascii?Q?m+RjYv1VLF0Bmxc9CsdsaCG7nBi7DDl6IKaDlDbiohLitr8losIQrxX5R3ol?=
 =?us-ascii?Q?KgUIsdmN1SmfhNZ7ovRo7j5vs5RroycwoCHGIeXJhR135UmmFB9G9DU17nJw?=
 =?us-ascii?Q?TpTk1lP8TaBS9Q6wih7aVBUG7/5wquaaPA6OFsLPq8BuDxO9p79FpUdXyK8k?=
 =?us-ascii?Q?bWD32Ki6qzDlZDXrM/Lky39iGz+KbUpXGdZpITue6NHD/BzEz4agyza2OFIJ?=
 =?us-ascii?Q?yCaJ8GfdrLMRmat4KyjuVi/MIhmiPp+sN1WjW35o5jlnsJRXX5Qeb0NaT8CA?=
 =?us-ascii?Q?tqEyOUi5EWNs/5ecrBQPHQeZJIGfza5k917UmtwkKyCNFkxVR0e9aw+819aZ?=
 =?us-ascii?Q?5fNCvLY8bAmdY0CRYgbjh9JHfasrmlOPf1Uxu2TiTLe29LUeMnzrABJsIyP1?=
 =?us-ascii?Q?qHZlUWnoKDUkiUpNDeh3c0WlsWMdW4a3joe3O4dEOMZkKTJ7sGC1fsqkfXIR?=
 =?us-ascii?Q?JnAAtlMYT3BOyBsCA6g891aEltz99oRZ4/sKP85Au4EoVRoS5CVt3GdRS5to?=
 =?us-ascii?Q?Z9urH6ThuYgexzqw+VhLPFDyG8VJ7/Z8U39KDLjxIMfMds8y4bJK49CuJ+hh?=
 =?us-ascii?Q?z6guq7ifwhlTZordtlNMAamKCpPNel3UPx6Z6UObPpFVctPNW56TtCTiUWl6?=
 =?us-ascii?Q?cNYlfFZMPGbeRByYaM6hIkZmFrLUucrDg6mmzhFCRY3CHg2e68nkA/nQEfke?=
 =?us-ascii?Q?FEcWVHwn8lHg2WutfeJFdGs4+a2sFPyFqsS7REs4PhNOiTgLgdfzb9hfAmXN?=
 =?us-ascii?Q?YDWeOMeGsoBOWjjXnbJopVjPPrt8065uKlzpp8AoeGmvMTpr/wfu1ao2k5z+?=
 =?us-ascii?Q?qIX5tLy3X50ua8jqX0zj1Jcer/h4EOZnlO9kSRo/l7HMumKxD/+N9Lbf9qdC?=
 =?us-ascii?Q?vnNxoQgUCrc6Fvse+Z5Z6Sd2RRABvmEsJz8bAV85aOiBJianOmjZsyh75iqm?=
 =?us-ascii?Q?Wrn1NIapIhyaipe1Krs+aM2dsr5ahgtl2dEgI5Ztl+7qEYY6ZomjQHiLxM3j?=
 =?us-ascii?Q?rZ6hAUUYjJd5VX/h02wX6fjhzBlSgnXgrAC2UIOe0WyVoLVOdXkSBaVmy8Iq?=
 =?us-ascii?Q?Og=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 012883c4-79cf-4587-e10e-08dc578c34c7
X-MS-Exchange-CrossTenant-AuthSource: DBBPR05MB11225.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2024 05:24:47.4126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7tAvMUJqk0MZjZOTHsmjV2uOj5dPt33rboMy0Ro3uXeZdVAfQNGdNUCGo9gBCr7yPhOKx5R3u+aSNXs004GKQ7RhkHLyknY4ZFPvzVFmpTI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6731

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

Hi Pablo,

after some testing the problem only happens very rarely now.
I suspect it happens only on connections that are at some point
one way only or in some other way not in a correct state anymore.
Never the less your latest patches are very good and reduce the problem
to an absolute minimum that FIN WAIT is offlodaded and the timeout
is correct now.

Here is one example if a flow that still is in FIN WAIT:

[NEW] tcp      6 120 SYN_SENT src=fd00::192:168:5:32 dst=2a05:d014:687:ed01::21 sport=58790 dport=443 [UNREPLIED] src=2a05:d014:687:ed01::21 dst=2003:a:c7f:e5e8:a3ae:63f7:7f92:e286 sport=443 dport=60848 mark=16777216
[UPDATE] tcp      6 60 SYN_RECV src=fd00::192:168:5:32 dst=2a05:d014:687:ed01::21 sport=58790 dport=443 src=2a05:d014:687:ed01::21 dst=2003:a:c7f:e5e8:a3ae:63f7:7f92:e286 sport=443 dport=60848 mark=16777216
[UPDATE] tcp      6 86400 ESTABLISHED src=fd00::192:168:5:32 dst=2a05:d014:687:ed01::21 sport=58790 dport=443 src=2a05:d014:687:ed01::21 dst=2003:a:c7f:e5e8:a3ae:63f7:7f92:e286 sport=443 dport=60848 [OFFLOAD] mark=16777216
[UPDATE] tcp      6 120 FIN_WAIT src=fd00::192:168:5:32 dst=2a05:d014:687:ed01::21 sport=58790 dport=443 src=2a05:d014:687:ed01::21 dst=2003:a:c7f:e5e8:a3ae:63f7:7f92:e286 sport=443 dport=60848 [OFFLOAD] mark=16777216
[UPDATE] tcp      6 30 LAST_ACK src=fd00::192:168:5:32 dst=2a05:d014:687:ed01::21 sport=58790 dport=443 src=2a05:d014:687:ed01::21 dst=2003:a:c7f:e5e8:a3ae:63f7:7f92:e286 sport=443 dport=60848 [ASSURED] mark=16777216
 [UPDATE] tcp      6 120 TIME_WAIT src=fd00::192:168:5:32 dst=2a05:d014:687:ed01::21 sport=58790 dport=443 src=2a05:d014:687:ed01::21 dst=2003:a:c7f:e5e8:a3ae:63f7:7f92:e286 sport=443 dport=60848 [ASSURED] mark=16777216
 [DESTROY] tcp      6 TIME_WAIT src=fd00::192:168:5:32 dst=2a05:d014:687:ed01::21 sport=58790 dport=443 packets=15 bytes=1750 src=2a05:d014:687:ed01::21 dst=2003:a:c7f:e5e8:a3ae:63f7:7f92:e286 sport=443 dport=60848 packets=13 bytes=6905 [ASSURED] mark=16777216 delta-time=120

Best
Sven

