Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2129.outbound.protection.outlook.com [40.107.6.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B81916EBE5
	for <netfilter-devel@vger.kernel.org>; Fri, 10 May 2024 11:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.6.129
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715342021; cv=fail; b=UMRC5BNW8d1IXLnKMxg70KRuOxikIRS3LmHxmjvkvKIClkH/RdGVDRLJDlh7S1pr2+yyfr2cx9dia6nAQ1hIJLhqI2PGEpBPQul6fc7brK4Um+laa4ABHSV4FKKQtZwMSIMr/AgUY2pkxcCfLGKRFr7mjgCmU39c6dToOa3WDlw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715342021; c=relaxed/simple;
	bh=lvnm6woJ5fB9pOvXGJfFU11/32h8GJcS8xEc6LicHi0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZNnEvVJocoIVzcJpF5LSnGObAWkeZUdj0/wTyajSAmrnMXsmA8ZcnpMqAt7bHDjsIXeCdCrOJVRCml7fc6kC/PLLpNO21PqXqkYOPe2py+xSGHg3KM5ruXvuEbCNTz7n+nJ0u5xJUbujww8z4VWOTI88uYDCSB2wqyKKX5ty5GM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de; spf=pass smtp.mailfrom=voleatech.de; dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b=isgtku7i; arc=fail smtp.client-ip=40.107.6.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=voleatech.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="isgtku7i"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cLFUoKX+3M4G7de1W1MwHMPLfNFW8TgilUAc8l03zsREjC7S4yiYCLfMy32jitLtzRze3cFVFSsvot5MaBLmo6L76+sXfBv3Ibv22mtk0u2s60+ssPWmIITi5O0Lk66EsMVwvtmxL4AoQ6N7dhxlsyc3ZwiNlkrKllLU62Ttjmt4zi35Sqedyy+SxLFvQ5WsuNANAp4muvRjzqiUaSCFPzv4xeqh/6QMZwHTeBaqSuKcO6ML+abtI2G39NWnnnAqQ/Ky5UnYrQF7PoE+KEOn/6HgqkEQzd6syDh8nDqCP3Fje0F9jqQzk77owfKHbj7OQUFdlUcAXQPY8aikW6upnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JBYE+YxMx+t4w3//cgnbbomGKaIeqv2AQJI1ldHPoxY=;
 b=FUhduybozXw1ZvkJkUMTZVAQ5SMgWGtiUPgiwKZGO1ffNI5ii6qDkTauRcmIS0NVrEs/jKDPTOY8ie8nsS+cdAZm72bNybHOF5qwD+lmFkuqGF6mbhd2XdS1nh8uyp44mcDZnEFKV6pRtpTrq1xanEb7ok/k9LDYRgHVGVUAYIEDmwNr3ZEyf2TsMw9yZOM8zCO369Ymd9SEhBjH4HXNByJ0lmhTN7QYdCVvIAs1zhxvYzCCQkVJcgiDNlhwckAUhfSTYxnmTbTXZe2Gg8509em0LuQ9VMA03WbrwpIpzATX76xG5v6b67kvX/nGwSWMGjeEnx6LIrENad9jK/nxSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JBYE+YxMx+t4w3//cgnbbomGKaIeqv2AQJI1ldHPoxY=;
 b=isgtku7igc222KiI8QKARQ3p+tzoCU5C0AjD9058lIMSGEbd4J5zM9Qh9RWMzN91MAXtaBoeEH0jSlpoySXLnz8NrT1Isc129M9DT+E9iWP7xKq346EOKm8S8sXD9HZRkwRmDYmO3hne+apsjmpofSOk72YVbt7ljhgvrdrygg0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from DBBPR05MB11225.eurprd05.prod.outlook.com (2603:10a6:10:538::14)
 by AS8PR05MB8294.eurprd05.prod.outlook.com (2603:10a6:20b:336::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.49; Fri, 10 May
 2024 11:53:37 +0000
Received: from DBBPR05MB11225.eurprd05.prod.outlook.com
 ([fe80::eb7:22e6:e723:9086]) by DBBPR05MB11225.eurprd05.prod.outlook.com
 ([fe80::eb7:22e6:e723:9086%6]) with mapi id 15.20.7544.048; Fri, 10 May 2024
 11:53:37 +0000
Date: Fri, 10 May 2024 13:53:33 +0200
From: Sven Auhagen <sven.auhagen@voleatech.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: Could not process rule: Cannot allocate memory
Message-ID: <epsitoo6q5lizrit7bj3klvddgt6pp3g4ukbc7yeqw4exeuo2x@223e3wlwohdw>
References: <qfqcb3jgkeovcelauadxyxyg65ps32nndcdutwcjg55wpzywkr@vzgi3sh2izrw>
 <20240508140820.GB28190@breakpoint.cc>
 <20240510090629.GD16079@breakpoint.cc>
 <qhjlvlrbtoxmlmowgkku3gqqgczzdyvvm4urz3322qbzxwqbc3@ns35urbmwknj>
 <Zj38SZbf2EfzmTpC@calendula>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zj38SZbf2EfzmTpC@calendula>
X-ClientProxiedBy: FR0P281CA0149.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::16) To DBBPR05MB11225.eurprd05.prod.outlook.com
 (2603:10a6:10:538::14)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBPR05MB11225:EE_|AS8PR05MB8294:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ae5db79-53a2-4cb9-4139-08dc70e7d398
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CxGG+lfHfVFqe1ce1y0AuWCDdIu8TtL1iffP0e+xg2AwLKwNulXLBiLMetP+?=
 =?us-ascii?Q?LHvkMC08B4PnS9G84JUOpwHLoM8H7172F8efbn+WKoQLOYeRPFrrPcV9TIta?=
 =?us-ascii?Q?vgMjq0p4rQHlTO0DPRMJOUOpD3GsKiCk2DJszAfbFEi78fjWw6K9rr6INIQg?=
 =?us-ascii?Q?/ZaEj6eiY9N0hLGnE0h/ncJ9nKD3lZhZNrQOn/hdX6W0MhZr+kB4VuA4/7Yr?=
 =?us-ascii?Q?PQZ6QkE5aC/Sy6t4+vWlhNjuCkc2wfdqLzuavTDHc85SlIMHl3WcUnB70VbN?=
 =?us-ascii?Q?GFstizR9XNQpi8Uqp2nDy4U23/KoX2lzpA4O5JNkX8R9cScvGxgTG5Qdt12c?=
 =?us-ascii?Q?F5nBIMhuLPj42vFikecprFVbyRRCq11NvCL7kpR67jaMswPT32lCmDh02b/N?=
 =?us-ascii?Q?TF8N95cfqEtJ0nHtGNL+H501G3kvVD0gWvdOfnSU9A+Sm4V5YQYo664LxvYw?=
 =?us-ascii?Q?pGy+Tv4ie4BofWWpIWxIXqlRlbYfbjWigbepSdgOL/hJUn363hT64GNC0SAW?=
 =?us-ascii?Q?JDlIfMrRdPijnl67sfSBVmZPW+xhaweQ8KeBnkuc8MlxmiDm9twctDbRZmSq?=
 =?us-ascii?Q?jS6XuHSShfqqBWthvAV66pTQ8eCWoci9u/wtYMa15yVIelOQw5iJJkODGnko?=
 =?us-ascii?Q?IftY7yKn6ZEvmFcn2SbVzSLSk6AWlimtTdD/cF6MGkx3YXSJ3Ptdu77BJatN?=
 =?us-ascii?Q?tb+XBZYynv3UYwQso2431JWvyhnERq1dPLwKbUSrv83oodaQAmp6z8b9SUJD?=
 =?us-ascii?Q?+vaGpfTBHQzi7iCKzHdN7PWty4ma634xmju81yTUV0efserIq3Ki6bHra8n1?=
 =?us-ascii?Q?l/rg2+ZFCrf8xLBzLiyESAzOuFGQDSe94YgPh9JUSR6CbFwsN90+nkBihshk?=
 =?us-ascii?Q?9l0c7FxalCHwwUXTxRQPIAooIOykxW4mPKq0fKUlkkQqBfhhTELCQVuce3gB?=
 =?us-ascii?Q?9ikB7u6rEoQUY2eq9j5Q3YTjKQzOhTp0eh2fwulqf6Yvw5ENeRbXO5F7TmF3?=
 =?us-ascii?Q?J1t/v3FSXgHfiJTFki1NLuxUtH+l2PcOkyc53kW20Jq2IHeYV226XZ7C1iTF?=
 =?us-ascii?Q?hOiGKtXmp40v8LsYK6iClrUG168ygO6wOdKdQMUo1g32StaN9WfSdqXBohhc?=
 =?us-ascii?Q?wfhU8fxUC/0VRgo6vODBNEabQopcvJqigAvZkDqAi9mM3JFAHEHUN6e8mDU2?=
 =?us-ascii?Q?KDVIMMRxlnnSRnUJ989BjTSlq1l8ZzahBVTFL5Up8zejtCaPgFPvwvhckZlY?=
 =?us-ascii?Q?i3IdPh4IqUXnapvhyIFMwyCv0MQrngizaXRI1eCuAQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBPR05MB11225.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?01URUqKFnFm2iGTOARxFP03hzM9UinBYr9qVpH0M+52c16xvPFZL/WV8qMkQ?=
 =?us-ascii?Q?Zj1Jk1qmr0gCAs+5vOv0FVnV1mJFfJ4leWeqdYz0UPSduFJIX3VvZNrRFO14?=
 =?us-ascii?Q?GvACSpveIG6AKpM3Gqq09cBTQsQqcrzQR+mEZJgXb27pSgTFcoNHObPbHNS6?=
 =?us-ascii?Q?1sBxKqJZWxPlB+gD/VfT5oN/QlouKYU7cYf9LlEtIwQJIiT/UXtUxUmymcq8?=
 =?us-ascii?Q?30QBgyrUIQ9p4mCXb0OV3XyyH/QINyPeyfJhrAHo8v+EL16hhpfeyaRFQ7Wq?=
 =?us-ascii?Q?gb606cvvsgmLad9vzHvDELQmYplzBrSXVbllJLf6A54ylcPhDRwD6ybKzju5?=
 =?us-ascii?Q?h/JMUIIntBFHq6zbr1NVEmIHuKBqylQCb2i5WaSzkY0SqmyiHiWaFf7d5uOg?=
 =?us-ascii?Q?TUWPpSVA4PhyqYJeKTFLbP/w/r1GK4pO0lOGf4yxrgQ3ledTP1sFUlGxm+yY?=
 =?us-ascii?Q?e0c8SZbVeTY4AvwDMdTw4rtYcY+uIiqDCIlr0VoN0euWI4dw9cN3wLpg/hqS?=
 =?us-ascii?Q?Z4fuZ1LbpWe8/0NpG8tf6Xv5dJkVIvoAAC2jj2CKIzrBCvpu04QuAY+CxvJU?=
 =?us-ascii?Q?o7dKJR51guKCZhFdpIr4JFdHz9Q0dcVBEnDQFA6QA//KgvR4ozmK7aVDg70v?=
 =?us-ascii?Q?Fy20KD7L6m+ijC299gOZ2h6ExqDfh7L9GePDLAuhOYDNSmAEB7t40zCcaVGV?=
 =?us-ascii?Q?ZPFA4IlI7YY2/ZN4oWNpAcHCr65fKlM6fzkv8wxWCmXH32PgoXbO6traDaZa?=
 =?us-ascii?Q?t4q8t+cHauTWgyucxVmZdumCKoLuOlUR/X4AkzY+0C/64sriw/oXFqtSge6e?=
 =?us-ascii?Q?1fhouobZh6+kg6AiwbT0HRqq86qXztm6V7NL5W/pa4lYKL0+geyZ/1YsRhFF?=
 =?us-ascii?Q?rStCfkdO08vXU3wshZV2P1kJfwrepVQ5Mp3Hxe/hXIjWLGHgAZBWW59U35NC?=
 =?us-ascii?Q?Op2EmtrcaUFJiHeX5km/t/yn8tzG34A70SuRBYTrRoIDRJ1yLqjLTpJ6I6hx?=
 =?us-ascii?Q?Ebyyl/FUTTFt4xOWOcHzLRZAwt+MRPli4SbiauzXx+QLDqC1ccF2W5uAtDxv?=
 =?us-ascii?Q?Co0ryduZq9I/03hc9Rmjf46VOQL/HQkm3iWnUpGqHJtXtxiZxIGAijzhsR7E?=
 =?us-ascii?Q?mewywkdb1XDbB9sD+qmViHRh7OQdpZEif7GqMCqw0ZIE3jW7RuYg/w8KYkBO?=
 =?us-ascii?Q?EsFaaalbymxCIPynycTwTsdyoYfJUEusYAY6l+M3vm0Nups0iG/PDIaL71g0?=
 =?us-ascii?Q?hmwaASPYZTq9jTgoQy0VmGe/dsUa4JWjjxeRyblF3J33qSrglYlGdrSAjACz?=
 =?us-ascii?Q?kXcOkJqMdk2X6DtcYI5tY/zY7MNCrV9Zs6t3JWFTvlH5t+B3r3zSARYTHcHt?=
 =?us-ascii?Q?VtluPM7llXqNHgBHIht0VtU/pWtmDaGfyj22ADKEIzC+p1eGpLHN8DBX3VWC?=
 =?us-ascii?Q?ZrYzmiMrvy6Lg0KIVXVc9IU+2H5BBlajFlSjja7/pZ8pzOHTW2AMf0JdN/nu?=
 =?us-ascii?Q?LaVbgFVzVqXmybXQgg5lw/r956cEnDfYie05yOGu33LdVy4hXYhuY0+Ub/7O?=
 =?us-ascii?Q?tMMjAg3ulZc4URBvgSwbK9S95XyQensicHSeaQUEaL7h81w7+hHumSsPc6w8?=
 =?us-ascii?Q?1Q=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ae5db79-53a2-4cb9-4139-08dc70e7d398
X-MS-Exchange-CrossTenant-AuthSource: DBBPR05MB11225.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2024 11:53:37.0454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KtsIPce0XkBiq2YFU2It14ZToTzhGUoc7+MPfQzYvR5+cBBNWFlt0f9VEUNGywBSfNfDOSssIWvoLa/G8TxfY4tFFRndrnSTGW0CwyeRyko=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR05MB8294

On Fri, May 10, 2024 at 12:51:53PM +0200, Pablo Neira Ayuso wrote:
> On Fri, May 10, 2024 at 12:45:15PM +0200, Sven Auhagen wrote:
> > On Fri, May 10, 2024 at 11:06:29AM +0200, Florian Westphal wrote:
> > > Florian Westphal <fw@strlen.de> wrote:
> > > > Sven Auhagen <sven.auhagen@voleatech.de> wrote:
> > > > > When the sets are larger I now always get an error:
> > > > > ./main.nft:13:1-26: Error: Could not process rule: Cannot allocate memory
> > > > > destroy table inet filter
> > > > > ^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > > > along with the kernel message
> > > > > percpu: allocation failed, size=16 align=8 atomic=1, atomic alloc failed, no space left
> > > > 
> > > > This specific pcpu allocation failure aside, I think we need to reduce
> > > > memory waste with flush op.
> 
> Agreed.
> 
> One more question below.
> 
> > > Plan is:
> > > 
> > > 1. Get rid of ->data[] in struct nft_trans.
> > >    All nft_trans_xxx will add struct nft_trans as first
> > >    member instead.
> > > 
> > > 2. Add nft_trans_binding.  Move binding_list head from
> > >    nft_trans to nft_trans_binding.
> > >    nft_trans_set and nft_trans_chain use nft_trans_binding
> > >    as first member.
> > >    This gets rid of struct list_head for all other types.
> > > 
> > > 3. Get rid of struct nft_ctx from nft_trans.
> > >    As far as I can see a lot of data here is redundant,
> > >    We can likely stash only struct net, u16 flags,
> > >    bool report.
> > >    nft_chain can be moved to the appropriate sub-trans type
> > >    struct.
> > 
> > Here is also a minimal example to trigger the problem.
> 
> Can you still see this after Florian's patch?

I double checked and it works fine now with Florian's Patch.
Also removing the counter is mitigating the issue as well.

> 
> > I left out the ip addresses:
> > 
> > destroy table inet filter
> > 
> > table inet filter {
> > 
> >     set SET1_FW_V4 {
> >         type ipv4_addr;
> >         flags interval;
> >         counter;
> >         elements = { }
> >     }
> > 
> >     set SET2_FW_V4 {
> >         type ipv4_addr;
> >         flags interval;
> >         counter;
> >         elements = { }
> >     }
> > 
> >     set SET3_FW_V4 {
> >         type ipv4_addr;
> >         flags interval;
> >         counter;
> >         elements = { }
> >     }
> > 
> >     set SET4_FW_V4 {
> >         type ipv4_addr;
> >         flags interval;
> >         counter;
> >         elements = { }
> >     }
> > 
> >     chain input {
> >         type filter hook input priority 0;
> >         policy accept;
> > 
> >         ip saddr @SET1_FW_V4 drop
> >         ip saddr @SET2_FW_V4 drop
> >         ip saddr @SET3_FW_V4 drop
> >         ip saddr @SET4_FW_V4 drop
> >     }
> > }
> > 
