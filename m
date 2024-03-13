Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2103.outbound.protection.outlook.com [40.107.15.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F183F8C7
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Mar 2024 15:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.15.103
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710343831; cv=fail; b=BVVaW6adzi/9MSNcHqV5eUJ/zydKXrzW9HoaVM1UZQZd0l66fjgMlBJEfQoc8LO0MT+VOVCGiTPDWO8MRmm+oZjR/fh6uqCnOWOLnt/r1gn/jOMH9pH5ctWwIQAN0F9AavMacBYL+zj+aeSqvF7JZpVIgaQYwqCvvKNovclKGpA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710343831; c=relaxed/simple;
	bh=LC773GbHGJhartYyv2DeiFiwgN9s8Zj+nybAFR2yzAQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Xi4HU1IKvDF0tSTOkHnyI5BbhlAuC16FYY+PFeX3lvYzwC2wR4mYjGZn9RUp4OahZS05+LyZ/FIijEQs6U2Uz22ESlBrm3kyNgGRYJkwDrpB+y8pr0OwsHOB5XVYccZGQ7rlcV61pqlbpwmTxYjlsCtqSBlrOWdnTwHtOmDwjmI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de; spf=pass smtp.mailfrom=voleatech.de; dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b=LDiiGHgk; arc=fail smtp.client-ip=40.107.15.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=voleatech.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="LDiiGHgk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jD3ZoZWlOANNSfcQgVR6zc/97Y0ctWSPqOjMssvUQ6AgVoXGtyyp5kpm8sy9wcxJt+iiV+u3G1uwsSlQ9z+JDHDiRQswefPpLPoqmZXQbZL7RRQJRx7thieCTx9dQjwm9dzo+5+jVKdwlzy/lMjlX0Kq3asRww6YRH3+lpDYgEDsJSLap8ZD2LI2Mhb/4LYdJq59cjKpz6QqA5kHbKxRBc1viPtO9pEF2Ajku9IlrUh5zkwsss+FbsnytoiYRq3AlzrDGFvrvY8eVsLKnpITw1v4srtwsDeAjbaDtRC706iYp4ybx86G++y0/S8L8/VBdpAWL2vByE7ATQ7NnmQUoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hL5LUGIrKqI2UkJ1iV4VmQwgYy3w0TC/UoWm4yqPKk8=;
 b=DEiLqiJ9EJGAi0DLO41zoZylkcoTZwuWeNrj6XGVKz+H/YpKBIDRmPZOIfFxrUWTDUs1oTdRLSlqfDJLyV1QhPkqoCK9M53uPBCjszSyg8EVvInVj7ypc9S4VYZNu050IPeFXaNaOl76U/9IvKni/Q8jJ2IgopVRJtFYtNr0hCLLexLFolOK/74SXzOC1x+ko6ncIwWPNd5Pyp6zNSo4wUp5zw035N7L95Ws8/hJ+sYWRnP1a90q0vrXi1B+BNWQsyWC9Io6TVsp3fMGlj6zCj0KiUKFXppG421EJuTuIS04G3cGlT0uI/RB4ehhBkpIV/+xUn0w36Dp6fNWwXSTVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hL5LUGIrKqI2UkJ1iV4VmQwgYy3w0TC/UoWm4yqPKk8=;
 b=LDiiGHgk/EHaUZowRRQ2tIbHpQP8inm5w2u+QZ+6+Ol5mdQjV2zU8ybAbGCPE5YIdIQ2GuecRUpSU8vBMJoIonBWpU/NR/lyFd0zncqB+Y0vRjLFmZA0CUwK1KBaYyGxrWoqLt8HOPhYbE339w+lG0gzFkkq65nmuqrNfb0zSk0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from GVXPR05MB11233.eurprd05.prod.outlook.com
 (2603:10a6:150:14e::13) by DB9PR05MB8058.eurprd05.prod.outlook.com
 (2603:10a6:10:262::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.36; Wed, 13 Mar
 2024 15:30:25 +0000
Received: from GVXPR05MB11233.eurprd05.prod.outlook.com
 ([fe80::9d0c:55e:de01:2a2b]) by GVXPR05MB11233.eurprd05.prod.outlook.com
 ([fe80::9d0c:55e:de01:2a2b%2]) with mapi id 15.20.7362.019; Wed, 13 Mar 2024
 15:30:25 +0000
Date: Wed, 13 Mar 2024 16:30:20 +0100
From: Sven Auhagen <sven.auhagen@voleatech.de>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: Flowtable race condition error
Message-ID: <54i2vxxo22wtvwfbmu22yjpxfhgove3ijfnv3rlhclogpz2t6j@6pxywe6ixzyx>
References: <x6s4ukl7gfgkcap6b56o6wv6oqanyjx4u7fj5ldnjqna7yp6lu@2pxdntq2pe5f>
 <20240313145557.GD2899@breakpoint.cc>
 <20240313150203.GE2899@breakpoint.cc>
 <yyi2e7vs4kojiadm7arndmxj5pzyrqqmjlge6j657nfr4hkv4y@einahmfi76rr>
 <20240313152528.GF2899@breakpoint.cc>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240313152528.GF2899@breakpoint.cc>
X-ClientProxiedBy: FR3P281CA0037.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4a::21) To GVXPR05MB11233.eurprd05.prod.outlook.com
 (2603:10a6:150:14e::13)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GVXPR05MB11233:EE_|DB9PR05MB8058:EE_
X-MS-Office365-Filtering-Correlation-Id: 3dccb613-6735-4970-6cfc-08dc43728103
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	f5b1yViJOrzf48ufKJFU2gxsdw5x056X6fB5ny5NnVGmigfEwsuBaVBnteej1Sia7OKHqjZp3ba2lwpAjZam9HcJ4NgsJA8rGwHr9nA1mIykANj8jxR0FMNeyVf2DUMV/J020KVfal8xiXbg9deAHHtMtAxPz1CbDYJP1S49idyUWrIItLETFHBxHatJNQr0iX6L9kILj5Uw6SSiM93JNvL87csYKl819UrROJRmzYSBvseALUUBMAfRD+IrC1x4OSQPI9iPne3s9fBikbItVjzoznV122fFGd2am4JTRnvudwNt2tqySr6X1Y7KIDsVKIhCtxqBXG5OMYWKjzM5I3u0L2Piu2YGCKJFLCw0HjlBqnfU8pap2yEK1+d0Q5yL2w2S5d4Ut9UQh2OuK1aMkXnAo3G5BBhtd5K8PLFmVIQDEA3Ot8i7nNFATmDHqCWTX6beMV7p878w8cvaRBIpTEEZaREUa6VntojiNA+BW/joKnUtYbsDFwzBcVJ+tVNbr4RJT9t2oyi4Q4fc0C5PJj3+WHhJ8qzX/eFPO3+0qzXyLTTdkaEy3LE1c56kIuQAyM8YtYMyRHdL6g7SO+eCH55JmHUp2+CNUhm8A7Klls0KmAGGi2DSHX2r+AuedodOAHPhBdUsoNIcFPtZmQSVE0PfnHLfqE7YBxt5gGOgE8k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR05MB11233.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UIIzdUMHszes7fF3SSt9FOQOybWh8l8RO54V5785G8dCvemDTZybtqGhBria?=
 =?us-ascii?Q?UsHOyUaIslIdMpRM3qf5s3Dl1fFAN3+flJeILbt0XePzfOBLxCI/lt1Ibuac?=
 =?us-ascii?Q?j/RbbXKYrcP/x11rmeD38j6DS+sNV/1FAN0NoDuHm4DYoTQMLH5On3nXWRoW?=
 =?us-ascii?Q?LoMOYbbO0atAaMT6kC1ru01HkmDfsrYzEuJ98cAtXjDLrAaB4HgxeQh7RSWl?=
 =?us-ascii?Q?8K4R4qfpYO1yOQiqckS2PDGptcNb0TtBetv1CJsUMMmAjI3RnxjrEFOW0ZO9?=
 =?us-ascii?Q?ngARbn9POo8xiZ29vjlBb5ii5Y1QUnid+NOOepRM0jcoJ21bVE0H5BEcFTIn?=
 =?us-ascii?Q?O33O9HrzzLnMcLAD8JfpKYRXnt6dJMiIbBfc47BzxTFvwTjmR8MHjsz/RkR9?=
 =?us-ascii?Q?+XjZYar54PunHQ6S+nkI/FhRCnZqFYr5xVF2gnAuAp6RlNlkAdWDfQx6NgID?=
 =?us-ascii?Q?p8TY530HuzUc3yjAsOKIwqSBU7I1RYKFHy9yyprKzYNheAWuIFMIkakLbp+d?=
 =?us-ascii?Q?R7Z1hv48bjEY9ns/+4BtO/28cH1RaGBH/TV1UwHEGOxeWRanWnyBELU57/Q/?=
 =?us-ascii?Q?m8NqSrhlisGmKfrAE9b6Ct0q9AxzUMSj8of457ktd56reJtWiEL9oHN2FZhj?=
 =?us-ascii?Q?3nzKQy+u6zZ898dma2Gxha4lZDRuw0go9z0m6xFmm5t4HDmg15R+RQZy0TF2?=
 =?us-ascii?Q?whLbCqmrT3P2BDHmVc8g8294gsGgnA3gTf+qYf2iC43vF2p9KTb4x7L9ghi1?=
 =?us-ascii?Q?R1OPobY8PRiYoABV/RXYXSi4FwJ+WLkuj9l5qB3XKxxz5AAiBXEu/sLEOjkR?=
 =?us-ascii?Q?kpC9eZerRO3xFwaq3eV9ZXnkMwYYG8zXYeuOyNgHsG/+JcyG3GRYt/8V6XNI?=
 =?us-ascii?Q?mz4YXvkfkmk+n8Txuer0LgFneN33MHktnBIcGocaUklD92Zv6bhAiPfVyYbD?=
 =?us-ascii?Q?s5LG5LRiZx0WYgxNvp3WTGUSta0IPjVAwxgRe5dKlDEZr+IzSQnv9vfuF2vX?=
 =?us-ascii?Q?sXPb6XAW3Uca5kq/JjQipEkniI68kdmVMvCCfdzWAeNM3FoIgQDjl7aYVTxv?=
 =?us-ascii?Q?7mk42AqgURe2m3qh1w2q7+50pxT2Mg+tuNEjAQ+S0LcYaftuR547/embvG/4?=
 =?us-ascii?Q?DAhnSsvs53M1TDxobDJtt/OK5BedzEnbedBOWY+VFoxmHY0MhxzoYZwBMO8k?=
 =?us-ascii?Q?Mokibz97C8oV1SYivLkn897oa3aGpTbSjx+oSqY+MNt5JQfxf6GrVXAWHGQS?=
 =?us-ascii?Q?f+/0xVaBOKkJFYfkH7xnsCqJOfnU09cX/99sJABh1buPIg8VGQyuaKFKyEZ8?=
 =?us-ascii?Q?BKmgk2mXKLb9upxsHN3aMwBfTclUZ5nbYZAx5gNJBXtjD8hb2U7lbdEiL2Cx?=
 =?us-ascii?Q?n9YhEA83hVPvrUnXCYg3WbXJfNQjvhwPeapFA04fVAGj154vlPeEKaxGZmWQ?=
 =?us-ascii?Q?7bluERIMdQG6S3Le1eWOtjn4yOekq01WyGhTkv3co3Mx4536+T2VU/QYm38+?=
 =?us-ascii?Q?0adQYXxVP2fDdhPEMOXMF82Yas3WxKAnwUoOOd8t8F+zAwYPmTLpVDVCwa1x?=
 =?us-ascii?Q?tCOjgAvouLRPsP1CCjlbIkFVHkhBi5VBFYnF7k2vhnCF9SCIqEJtiI1d7lsX?=
 =?us-ascii?Q?Eg=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dccb613-6735-4970-6cfc-08dc43728103
X-MS-Exchange-CrossTenant-AuthSource: GVXPR05MB11233.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2024 15:30:25.0869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: flZkVeSlkdsfvrUimZzyf5O+VTWZVvCNB9RGi6c9iZR3SDFoLIu8nB9D2IxBKU8kNyqPAfF63UhGdxHDv4MZ+NXCcEAlNT4zYleQ+rPuX+4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR05MB8058

On Wed, Mar 13, 2024 at 04:25:28PM +0100, Florian Westphal wrote:
> Sven Auhagen <sven.auhagen@voleatech.de> wrote:
> > On Wed, Mar 13, 2024 at 04:02:03PM +0100, Florian Westphal wrote:
> > > Florian Westphal <fw@strlen.de> wrote:
> > > > No idea, but it was intentional, see
> > > > b6f27d322a0a ("netfilter: nf_flow_table: tear down TCP flows if RST or FIN was seen")
> > > 
> > > Maybe:
> > > 
> > > diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> > > --- a/net/netfilter/nf_flow_table_ip.c
> > > +++ b/net/netfilter/nf_flow_table_ip.c
> > > @@ -28,10 +28,8 @@ static int nf_flow_state_check(struct flow_offload *flow, int proto,
> > >  		return 0;
> > >  
> > >  	tcph = (void *)(skb_network_header(skb) + thoff);
> > > -	if (unlikely(tcph->fin || tcph->rst)) {
> > > -		flow_offload_teardown(flow);
> > > +	if (unlikely(tcph->fin || tcph->rst))
> > >  		return -1;
> > > -	}
> > >  
> > >  	return 0;
> > >  }
> > > 
> > > ?
> > > 
> > > This will let gc step clean the entry from the flowtable.
> > Thanks for your answer.
> > 
> > I double checked and the problem is that the timeout in flow_offload_fixup_ct is set to a very small value
> > and the state is deleted immediately afterwards.
> 
> but from where is the call to flow_offload_fixup_ct() made?

It is coming from nf_flow_state_check so your patch is correct in that sense.
It might still lead to the timeout beeing set to 0 during flowtable gc though if the
state is transitioned to e.g. LAST_ACK before the gc is running even with
your patch applied.

I will also try out your patch and it makes sense that it is a race by design.
I think it should be applied as well.
I guess the question is is it save to send more packets throug the flowtable
even after we have seen a fin or rst?

> 
> I don't think tearing down the flowtable entry on first fin or rst makes
> any sense, its racy by design.
