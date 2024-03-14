Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2118.outbound.protection.outlook.com [40.107.6.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924AD6D1CE
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Mar 2024 10:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.6.118
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710410895; cv=fail; b=PjnCBoITDWMP/1CogY537qhw05q0s/TKJQFOcQxXXBIqS0oWWUNiqFk0O6Fe3tiRAaMSr9gdKGdw3RbjTmgsCYzt/dKWNz7X77FWGhG0FtBT+jajmZNpsEpmtyRDXW0ByPr8QybeTdhnOGYleIR91TzdDG697Iz3lu2x1Wy3nGo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710410895; c=relaxed/simple;
	bh=7JCfo2khO3lcilap7sasGKMeaBHSJVMfUb6e/ATUScE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=l7Vi0SOdjTHOeLLWVjp7yznrZwgX8Cf6ThlGIRZmiM1qB9q6R64JSg+hlMnu454Dc+4fDkciW6zGLtshyXwvnsHuDC5EFwsEopN9Dp6MB/J1IR5h7t2nfmnYUS/X90EBSPhFGJh1kRNSBP+1lRD4p5beC/1r5341O85JEZKL++Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de; spf=pass smtp.mailfrom=voleatech.de; dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b=Zt2LD/Lv; arc=fail smtp.client-ip=40.107.6.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=voleatech.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="Zt2LD/Lv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IqyhB1ouALsZs9gG8PezNHGToD52ui6h5qo3oqC8opzK2mA+/owSbMX/nBbsOQTdVy/PszrgTJ1RkDBzyLviq0y1Hk5cpIno9BnXz1krTWzpW0ZIvLCdHpymOlOhB0dUBmLByH5vX1YhNg4TQE4MCO1Xt9ZJkOn9VdlC7caYTb9T7JMHbEnUIuaZrATpeT7x4vo+gayHVjXYfcd9er25aPFpbeHs3pXsw6S1nN8XcBVijHEJ3OD3G74V23B0EEA9Omd0SbIEchUOYIzqTgFEJKo58lX0VAfvI8BsnQ9O5FdJ0Ul6IATvNP0USZpRwrfTeITKxoolAW/O1rPdm+rZqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RBxSYbr57JTdb2k5rHDeT4Ye/b71ux/PSaUg7ez7MsM=;
 b=VCsqSbKqHJhXYJZWFmMZJxcRTNTKab7BVGdWdcpW3vxXp5FMSNx04sYfK74dvIFcIytj5TCOU1s61QC4lRnZg0W9LyP/92Y6zngEnwUGeidVMPtYsTK0bbPppCKlxczyWI7Wz5B8MW/rzvJFQ7R8UPaW/QMQC+RjySlXHOxgXHmTe5wLisNDO281a0dP1wLTtzKzXNnyADf+zsGn4DwBg7n7uC0UcopNfA6RIxRW6cWMLrCsUBajGf0TGqdgYKDJYCgSXQV98KexFxgQBh4EHjrV9nImZyzBbwq0+Y5OOSORpVZqU7jt+RR3ErIiIY6/N151WAgKMVLBpwiB5gSuOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RBxSYbr57JTdb2k5rHDeT4Ye/b71ux/PSaUg7ez7MsM=;
 b=Zt2LD/LvIK+1eQoMfHz6B4kIxik463v9GANIfm9rYW8tmhs9ay9IpJuuXym08o7f6MUqrxu8xoje1vM72PredsDxRcSBi3fsYUBTh557ibWioLjslm0IYvR/NBi4VZ+fbh3qMFixSkSbZwP2la9rkL893yPFHBgrMlbMHaiTniQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from GVXPR05MB11233.eurprd05.prod.outlook.com
 (2603:10a6:150:14e::13) by VE1PR05MB7245.eurprd05.prod.outlook.com
 (2603:10a6:800:1a9::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.21; Thu, 14 Mar
 2024 10:08:08 +0000
Received: from GVXPR05MB11233.eurprd05.prod.outlook.com
 ([fe80::9d0c:55e:de01:2a2b]) by GVXPR05MB11233.eurprd05.prod.outlook.com
 ([fe80::9d0c:55e:de01:2a2b%2]) with mapi id 15.20.7362.019; Thu, 14 Mar 2024
 10:08:08 +0000
Date: Thu, 14 Mar 2024 11:08:04 +0100
From: Sven Auhagen <sven.auhagen@voleatech.de>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: Flowtable race condition error
Message-ID: <3ku3nssbmgc7jn7mlslvag5rdn2mbqcszkm4mccnzd72uhbb3o@uwkhkhxg3msw>
References: <x6s4ukl7gfgkcap6b56o6wv6oqanyjx4u7fj5ldnjqna7yp6lu@2pxdntq2pe5f>
 <20240313145557.GD2899@breakpoint.cc>
 <20240313150203.GE2899@breakpoint.cc>
 <yyi2e7vs4kojiadm7arndmxj5pzyrqqmjlge6j657nfr4hkv4y@einahmfi76rr>
 <20240313152528.GF2899@breakpoint.cc>
 <2rzv5gwtw3mp4hzndzb4sjtnibefs7sjcsychvm7vpoy5wetv2@ssrxj7cmi42b>
 <20240314092541.GB1038@breakpoint.cc>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240314092541.GB1038@breakpoint.cc>
X-ClientProxiedBy: FR5P281CA0046.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f0::9) To GVXPR05MB11233.eurprd05.prod.outlook.com
 (2603:10a6:150:14e::13)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GVXPR05MB11233:EE_|VE1PR05MB7245:EE_
X-MS-Office365-Filtering-Correlation-Id: 07416210-4d7c-4ab6-704a-08dc440ea5b6
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	b1uudiSo2WI4IfLergFHG2KXO6IHxeeEFW1ckeXHpu+IiCC7zNA1irrpYtk0uFJcZA1P/0X58XgMFRUyjYGvq+KhHdN0R/B7yWkcVJZOOljipaoJaYYJRkOCWLjqdzYEof6KNH31d+zYykBZ7yyaPry6Oya2li/To9T+wtUJVz0sMnmJYico5Bwu/EDW3phDO7Yh290L107QqJ9PhJi0BDW+uJjtoMiIDZzOUHdYHUGHe1WEsPSAOKCbZH/0fC2wdpNbHfLnpJgShA7Rw4L7xBp1+gk32mT5E3gq2WCIxM+quwTXG25PUyfKvnqmQfs83tkgNgBnCARSUVcfg3WbrbznoSrijcQlslgBqmMvgIfhmNLW4QHzbm5EfoufMzYLQ4ODYpDT07GaVB0soGEEC+T4PDPKYTdC9WM7ISKGj11lRf6BM2xyUNyu9jF5vHNUbXqjCoxmuJuzzPAXRyl8KbdBw1ZPVjA0kWRerrkt9NuwhD6dVcF/dWtnZD7UNfh3VcWBPL4nCfAEr8TVTRI2gpO2cdcgZ3YztlVsTNnEbfje1IctHFJj8jy+GpPMFwF7gAezKI+WhTRc1v1DQ6vBSsObRH9qBgjju987gkV83pKVzQK7BN0ioF0s796Y1tSTy5JEr0GOVBymUVBoVd9B6fZfDBQuK97hm39iPld3jEc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR05MB11233.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VTeMu2wFmMe6f/HllTjZbIZdR1oGTrS201nunlw8KnIqE887oJQFShDcQgt5?=
 =?us-ascii?Q?ZbJ66ZAPq2T0RU55/ioLWdOAc621+dDDHdSxZMf7Yu1lkdA3PEBwq+x+AsN8?=
 =?us-ascii?Q?zpvZVzZ+OQkGKr4l+d9haPXELwkXOJxolJqAll9Ykae7cNS9e5z1W5/+LGdr?=
 =?us-ascii?Q?rWsYoLiP19jePnsy7mHvw11RSaqZZHrfllDbEQdKFk9H1AJyeBlO2yygu7c4?=
 =?us-ascii?Q?N2xgA3Y0WOGntaPQRJRG1U6nYQ099LtHJoAc780m7V8Y2pvF/fOwvTem0vRZ?=
 =?us-ascii?Q?fti90OIu3YTk0oPmOYXDWxaXlOHXKrt5t2/NNJiR3dmI+NCQ10lVvyIrYWdg?=
 =?us-ascii?Q?ffawUVWaRqRnbk8kjwyj35jtoAwNg+O/RanH0FI5YQmp4ZCWfiEjLcf3u/u2?=
 =?us-ascii?Q?uAMKZAKY92yQPONXEgxrPrF2Kfi7Yf/cdBhD8Ssr8sQ79LepKQKOiuLnTcgV?=
 =?us-ascii?Q?6ugdBZVyFHLHRjYurdAQfu49f5XoD50iYuVlJ9RMOJC6OBhoM63HZr7kVpc3?=
 =?us-ascii?Q?/E14gXjpnlXGG+I+ybigBu2fc0u6TrSKM3OM8RYOePn1bV6vhqgSTMWXgaDI?=
 =?us-ascii?Q?0N71qh+7RS5MkNqjUdmX0GO+VCGPXlhbqsj+gmv26tRlQ6auOJXsI8viXaZg?=
 =?us-ascii?Q?j63NSVtaLO8U7lqvBMf6mERLKOKTtc2ersYzxBwgO6vnk6Id8IEsa14mwT49?=
 =?us-ascii?Q?xxkVsCCHRRfJL4o4RBQHJJhvwaOQFHN/bzEo/RRXsgKckrQ4+TqE+DAN4M9g?=
 =?us-ascii?Q?LfBR29vcY6eOe/kyfjE5HjxnAVFQOVsBgos8S8LDOlwsqKfMYoUELezvDHoc?=
 =?us-ascii?Q?Cu2gfNxxRZr5hyt5XIPjt/uUg7R7ajitW2UsZiBTddBl+R2wgA16rmZYVCGY?=
 =?us-ascii?Q?T7ru6+wXV/IFxfEDvU4nyPhd3LFCmw+03bRA6RzVV/Q32/gxReof9LsghotZ?=
 =?us-ascii?Q?mdKsiqgtmEiv96ftuZ0PJ6cTHkU0E4BQjJjfIvczhItDXfVyniQncQDbEuvh?=
 =?us-ascii?Q?1M9sBFCgYkwrXdUb001TqMSNovaRbsTcK2vaefQ9oIcZ8+VgyZ8wGtUUSrbp?=
 =?us-ascii?Q?Jwwj4nCcaxC6oq6FMJ0oqNGTbn9GqaMbftHzQymQTpIcr554L0cSRD1Bx/Rs?=
 =?us-ascii?Q?wH7Gk4s3knftskLdBdQp91Ut4jcben/gMwfSb0Jcatq8/HuAOLvNHegIeezA?=
 =?us-ascii?Q?hGJaDeFzAeTU/YaRtLAt8sV8HOfuijp2r0jXEpFuN/Tk3IZUfvZ5VX9RcHS1?=
 =?us-ascii?Q?AXVqwrDyYw+uyahwkV4LrIShZEyFcJiZSJeiD+m7FoFY9eeTrnhtSqbG4lUz?=
 =?us-ascii?Q?8lqEf3VaNS9LTIXZ6OUYdx0WCrx18TVW1GQl4RIBnkq3AqVaulWNalvrKjxP?=
 =?us-ascii?Q?HoE3AIgvNVGXAfwsH8moXBzMf9SI0q3zMRyESmmwq2FBfxI1BrLdJnMd6zbR?=
 =?us-ascii?Q?MyltYjcAPN4Zb+9Xxz+fIqUGk1ovxe7ZTT+nesE+2YfMk/3vsTBOVUQDAK79?=
 =?us-ascii?Q?82f/8mgA96py81t1REiUcu+qJGANirXQIBuO2+9U6nOlZyLMQyX0q2M4P28M?=
 =?us-ascii?Q?rbsNGvfIF7VjjMrm1k7dW6BLtz/+D/jO25HdryJMMVhYWEgfhN8He/0l0mns?=
 =?us-ascii?Q?9A=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 07416210-4d7c-4ab6-704a-08dc440ea5b6
X-MS-Exchange-CrossTenant-AuthSource: GVXPR05MB11233.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2024 10:08:08.1640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9g2gkXxQfn1/cSxq9atUI8CTJOskfAZ2kaLgt7Ur/dm2nQpKyJvpFELwDjaR+dHx9Ij6QhyrBHLVJXG9dmmBzEf+YMPqPnQ6mxWeOxVdmqA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR05MB7245

On Thu, Mar 14, 2024 at 10:25:41AM +0100, Florian Westphal wrote:
> Sven Auhagen <sven.auhagen@voleatech.de> wrote:
> > I tested your patch but that leads to other problems.
> 
> How can this work then for UDP, which has no fin/rst bits?
> 
> Maybe this is needed?  But I really do not understand any of this.

So this is a TCP only issue that I see.
Sorry my comment earlier was not correct the refcount is still +1 as long as
the flowtable entry is active so I take that back.

I will think about it for a bit and get back to you with some ideas.
I think you have a valid point with the not calling flow_offload_teardown but maybe
we need to do something else instead like lower the flowtable entry timeout to trigger a
faster gc for both udp and tcp.

> 
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index a0571339239c..aed4994c1b6f 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -423,6 +423,7 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
>  {
>         if (nf_flow_has_expired(flow) ||
>             nf_ct_is_dying(flow->ct) ||
> +           !nf_conntrack_tcp_established(ct) ||
>             nf_flow_custom_gc(flow_table, flow))
>                 flow_offload_teardown(flow);
> 
