Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2124.outbound.protection.outlook.com [40.107.14.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46923C060
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2024 10:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.14.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710929614; cv=fail; b=A83bXhiuPGZHAp2+ZJARYMnv4J4BCirUnqa3WRtck2MYmLJhmaFP8IUDFE7avmOXlK/YS7Bl/rtrYKQRMuMOUwFTsMhP6+35CuetxuHBPtAOC4kr6fZ4EJt7ijwMNYETb7wEXQ/M7/mMAyHIzMQjpks8Kq0U9FAMfK7/iQ16rGQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710929614; c=relaxed/simple;
	bh=a89SVmrC3bDJixpLECTJnzy8Jq3K9+o2wdCw4qsaCcw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=MEAcaaumTpcBwenKU7gnbhs84fy6Jn8zjRjReMzPiZeyLomMk4nX4T5+uhPETXobi+tQ7V5RmlOd2LPZ6z+JUKSq8aYO1hiW4LbMsjN8TXneix1p2lNFvQVl0kXx4wGui/f87rf6BUb0UORgI/J26JBRSwrtBgOmMrr4imapTTY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de; spf=pass smtp.mailfrom=voleatech.de; dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b=HEWOJb2D; arc=fail smtp.client-ip=40.107.14.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=voleatech.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="HEWOJb2D"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nBFGM4eLkc0woGGeeC1BdvYahUwWNo4CR85ETCypCF6en6njOsMupB3FjHMgCh+kqiQj3BlXJ6zJhtYyooYQPvi9b59pUi3FzZpBjJLCTO09KcOPFZXdnDBLMou4TXD5iw/RvOtROntn48q6ZE9uxAXxC0I1mVGGQcAO0GVu2deirqRyVOpPxCoMVGIb1KfWAAqdvYQjdpj9FTlcrDWVytsdG6q5kV1WIJoy5wA+eoIa0B1Cy8Wf96Ebe4Z84qNs36nd6LKUOlFDBVCGHJmHhV5q5lJMHKmaKDzV+BhAArv8vFZlXXdo2GL20lW2XlerUzn0A3LPObi7L2YlsikKHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=73McZbhWl1mcsXYzhzqIj7TRhbHDzFo63JDvSySzCw4=;
 b=OwZsU6rH/945DjAvrBY5rqI3oM/FrxNSHxios0ylXeINeDjZo+xOBJDbX4q/NtQmwN2vjWAZJdDqzOsjL6m/ZtSd99W9Td8udi4HLa0/dOtT5rBkLh7ieEm3GY258Xmm9gQhgMhOLpkNikznkarS/z+84G7edOpyyjUxyGJ2PpVI+TE8OXA7BE3bjSXMzyU4HtNP0loNmMBH2RW2AskkXNGkxE/VHotwnUUHobEYRVw4Xnt2obo8cFXgGzrwrfojBSs1AQJisfLXqiETn5CCd7ln2iPFPFBSPvW+wM3ODCow1Et490LE4PkTVPOgIAeE4WJtFgFU1UXPFzZnW35RYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=73McZbhWl1mcsXYzhzqIj7TRhbHDzFo63JDvSySzCw4=;
 b=HEWOJb2D0OkGsbLMYaXdhO+k+EfhliZJj/7jqyHmFSwzhr8XkEiwVtUxrUoNHu/Kh27aKsZxaH5VjcVS5bcDj8oJ7Z21rNfSMg3qgkuIFfUDQYGi0c772kHjIHsFHFKcJDMVJzo6Lyyc53xiFSOvZFDMLNPEgBqwEpGBGsdjmvo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from GVXPR05MB11233.eurprd05.prod.outlook.com
 (2603:10a6:150:14e::13) by DBAPR05MB7413.eurprd05.prod.outlook.com
 (2603:10a6:10:1b1::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.29; Wed, 20 Mar
 2024 10:13:28 +0000
Received: from GVXPR05MB11233.eurprd05.prod.outlook.com
 ([fe80::9d0c:55e:de01:2a2b]) by GVXPR05MB11233.eurprd05.prod.outlook.com
 ([fe80::9d0c:55e:de01:2a2b%2]) with mapi id 15.20.7362.019; Wed, 20 Mar 2024
 10:13:27 +0000
Date: Wed, 20 Mar 2024 11:13:23 +0100
From: Sven Auhagen <sven.auhagen@voleatech.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, cratiu@nvidia.com, ozsh@nvidia.com, 
	vladbu@nvidia.com, gal@nvidia.com, fw@strlen.de
Subject: Re: [PATCH nf] netfilter: flowtable: infer TCP state and timeout
 before flow teardown
Message-ID: <fcas4qeo45hbbjmu6h2ipryoi4cmhmhtzhudabqdj6egzxidg6@o5kaoqak26io>
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
X-ClientProxiedBy: FR0P281CA0188.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ab::9) To GVXPR05MB11233.eurprd05.prod.outlook.com
 (2603:10a6:150:14e::13)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GVXPR05MB11233:EE_|DBAPR05MB7413:EE_
X-MS-Office365-Filtering-Correlation-Id: f011421b-a13c-4ec2-ce14-08dc48c6627c
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Y8fOGMO3EtuxrTJHEtA2vm/nIz4uAKHrvA9hZeqziKh4jABJIHVDR/DMJ9SWmoeFcZz3cPfiiZzctgT4McqwcUkx04XwbQy+8rO5at1435c4Xqox59NWPcqAbo+A3qjGxCUb9NcZ/BzEbXv5EFr9tbGlrBRXcqplrQKgH1XbFAPQ5HJz+QRusg0CUjbRU8JgPLK4/9w7SGtZPjZKNvGh5iynWeAz7b34EpjHKIm62dLZ2lHv0D3fXOYnXmf9s7svZPzulOqqGxQTrBVsz9uzMKL783tZLEdyceXM+RXnYIJ0jpO4XrAoEJvtO+QAxv4JEsbidf6Ug1huktlvlrxcsqmYHtyASASeP5fESeeBAGhYeolrXhDXjlMwQX/6/SpX3UAD3q8gRY0jbeU16ZycPou4tSQs2lShB+N2nZuZ9KzE7tSlCt5LI9/h5tcWBLuns+UVILZm0F0K+7gIt2L9nwB4EOo0OcCqoxO5ZCkunykF0PPYVqWNv3li43obwHyCj5s2MRHZORFCwhwZDZziE2DblhblxIM+U+Ox4o/KfR/m/TjKUg7+S/8TDJQrYw6+I/bexKydtCzG1up+BPw8VTakITGmMxJ6kJZaZzeqgs6jmAIPiubVzG9aN+5zbTwkdnZJ8vk7ti6y+gs/vykUV11D7cLtcKc/uewuL2O+hZ4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR05MB11233.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+GrUax6xLAI27M7+9XJKDYp7C+aqecRNRbNaz9A+vweu8IztZTD5iIG1QMrs?=
 =?us-ascii?Q?44E4SoYPMauHn4hmCrlJlqIDGpnCPS9wVCIirl4MovlLwzyoCdihVnnCyoc4?=
 =?us-ascii?Q?blR+xbtn3ohVy8U8PWc3pfk3omUQbXHfm2we1YdOvgkGlQv9OMNlSiyCapQp?=
 =?us-ascii?Q?14sbYEYNK5VMHsb/NHN2nPFsG18AnX+4jSo6bGYDzDcJvtxsmIECFbuCio/L?=
 =?us-ascii?Q?SN6VuA1JNzaKGT848fuZRRqbeYVG4/N7rG6+23sUjKw4uOsHZj+1fCBJKwpt?=
 =?us-ascii?Q?NptlrRhm6GgyZmUnz8H/FPqIks0fMUVv5OX/fJr0NCiAqOjFtMBe0Z4mfP4S?=
 =?us-ascii?Q?dMo8k0CHI2SPr3n3BJD/8H6idTmJ4tWuJANC5Wsl6JDeN+ayutVXHpYsSrPO?=
 =?us-ascii?Q?4ucB9Dq0rI7NqGHrK9Cl7Wx1OzEHE/FYhxVmTnl/XIvgDIfqTdOWNaBu6NAM?=
 =?us-ascii?Q?FFNVgYCFoURfJYC+dh4wn1vql79clSWVs55V8l33wWYlqkYcf9oJby/PbNS9?=
 =?us-ascii?Q?RG4rWLimhmCpzAC7AYTSYjvpu8Ekc7OifGBep4KFH372sXsiqAdB1Rmr96t5?=
 =?us-ascii?Q?Fi3azY34WBLDwnFpcy0udRSUhef9loLR+sbTm7nKWoPU3Nx3GXaU3R8dhcoh?=
 =?us-ascii?Q?NgnI6c46kakU6M63dyptmqvNKbaQtVAow50P6PvVYFMCNlPPVLrV6+WSXPFg?=
 =?us-ascii?Q?LGwF/296phHyMX9HgaNGGU5mZFV7tOfHUzrqoqmZl3CRyvDJyk/9odeFJhzp?=
 =?us-ascii?Q?e8Spid0gPYmyZQjRVmVKssPcz5vO2g6fslnCNATIBpWfHmqqn+dl2VS9AS5z?=
 =?us-ascii?Q?tFvCvO3lhrt2ff5/0x3rM1zqKxDd8HJTqnmMCt+CKJeo4EeWE0s0fJ/zT4Tl?=
 =?us-ascii?Q?y9Sqn/zUVHXGecmdT8xgRnvdt2DAQDFwAehsOhC16iGo/RY3gCWZ2J97YK+u?=
 =?us-ascii?Q?TkJk3zkfIBe9vwnEmPVr4Fj2pFWIMSw9ZDT3LCvPlYbNyDQ9ZGIAnPEhELrY?=
 =?us-ascii?Q?3O2+NWEjASiPlcPFlGkb5IML9nh+xTxWknNb8o3rHlWa6zxpn86XbvdQ+vrb?=
 =?us-ascii?Q?tJk77v0LLTD71eN94b6iFhKnHwCHYbaOdlI4MBoi4NC0Z4XOnymdddNgPcog?=
 =?us-ascii?Q?KWqZbYyKW/SekKxwEM4qR4xwUhmmst07knAoTsWhPEikCCgRs3MoVVaangEn?=
 =?us-ascii?Q?Hx/7Khn1ZQ5iEUK097AjZHoYUWWzv2USt2O+YHwjwirlziZ+pRwFEwR9ZnpT?=
 =?us-ascii?Q?V8IuErjcNvJql39goGClBiOmTYPdPfVKRTSiMbNA3m+To8UGJytCmmUyJ0hZ?=
 =?us-ascii?Q?c1pKyWZHqqSkEDdnZILltSVHImqWucjzNBSSyK5Ti56mSjgr79/4fQs7c8PM?=
 =?us-ascii?Q?msriW6WRAp+HN8Wd1uYhM/d7W3K6d1wGTdZiBU5HorQsRXhsRpB7AEUwW/Yi?=
 =?us-ascii?Q?n3VpyAwUO+p3KnU8t6xUfT9BTdqd8MVGi6IYxaTYb+IOY52CTAkGdoyTOqfP?=
 =?us-ascii?Q?cI1xfnWgfnhScqYuvW9gaPakbDGobo25WrcmR7Ixg0i51EwwLwMqKaSZSdMw?=
 =?us-ascii?Q?qMZye9kYQDV5FaYpfLwa5rgfH8Qy+NkTMf/6sgUOI99EruKHeoH/48r8AbPo?=
 =?us-ascii?Q?cg=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: f011421b-a13c-4ec2-ce14-08dc48c6627c
X-MS-Exchange-CrossTenant-AuthSource: GVXPR05MB11233.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 10:13:27.4832
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4NLw46KKoP8YWQIS7aJhzKNjxzfVjS2nQLtkzuO2J8QyeCFb2pznXrYw66/sIwFlk42iWYkV7rLdGZV2qaY2zFXZoOLRd3/NEaZCeh8kVe8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR05MB7413

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

Ah you are correct.
Never the less I can tell you that I still see this problem with the patch attached:

 [UPDATE] tcp      6 120 FIN_WAIT src=192.168.7.105 dst=17.253.57.219 sport=49574 dport=443 src=17.253.57.219 dst=87.138.198.79 sport=443 dport=5078 [OFFLOAD] mark=25165825
  [UPDATE] tcp      6 30 LAST_ACK src=192.168.7.105 dst=17.253.57.219 sport=49574 dport=443 src=17.253.57.219 dst=87.138.198.79 sport=443 dport=5078 [ASSURED] mark=25165825
   [UPDATE] tcp      6 10 CLOSE src=192.168.7.105 dst=17.253.57.219 sport=49574 dport=443 src=17.253.57.219 dst=87.138.198.79 sport=443 dport=5078 [ASSURED] mark=25165825
   [DESTROY] tcp      6 CLOSE src=192.168.7.105 dst=17.253.57.219 sport=49574 dport=443 packets=15 bytes=2688 src=17.253.57.219 dst=87.138.198.79 sport=443 dport=5078 packets=18 bytes=7172 [ASSURED] mark=25165825 delta-time=126

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
> 
> For the flow timeout case (where flow entry is released and packets
> goes back to classic conntrack path) re-offload is possible, but that
> is a feature.
