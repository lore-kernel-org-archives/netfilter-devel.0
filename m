Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2048.outbound.protection.outlook.com [40.107.212.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22BA019259E
	for <netfilter-devel@vger.kernel.org>; Mon, 30 Sep 2024 16:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727713702; cv=fail; b=jfEjYPy7E/h8QJWZIotqyfuMbosK0mag+SkXYqcPZIwEJJ/gyXBYzAj1PuvL9YSnSUcS3VJ7oL5KqpE91MlohC5W9jjLqzaNEzyyxu/eqXChmsCc0rvwCOAhReADui4CeIa7Ye5W1ZLqk2yvcRKkrBLeu5Rv1gbOAtkdM936Ih4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727713702; c=relaxed/simple;
	bh=bp2Cx/fH4K58elYwLKNmirIGzYSqqPHVFT+mFyVFGrM=;
	h=References:From:To:CC:Subject:Date:In-Reply-To:Message-ID:
	 MIME-Version:Content-Type; b=Cs79ziMWM7LzujFswVOip+JZ5Op7BZVTW8UOnnY+QQkL9P2X6r50ZgrORpINA9GFzj9L8ZZUHP654/aGHvasA6V0iEPOzhUTb2AOm2Lo+Y0tdggfj1JG5oL16pVyTetc+6Ef4LoPfhYqNbutkGRFRQzoO60nvQDJuDGjb9Sx0V4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=s1pP0d3N; arc=fail smtp.client-ip=40.107.212.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="s1pP0d3N"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cRrD/s/NZRu9bH6VeKeAtH49ux7lO38J94kL17ND+fifFBf8NyMGrFOFZJ+SgnFoFD3UyiDw+yFu0l4xYDrK5/zeP8A3FCq9Cxxvo59K1GYDEQbGW3K0TOUcV8eKLDQkwzzEv36YwDChVNdzuDEOqjlKuFNPayWHaq76BxNV1AyNivVkgZfULNpr2WVR74BleNuBMlN3PLq/abNBt/MTXDhhdkYs2vylpNpdcvVSecZo6SFQtLi2P/qtV0J/JY/yaXSaOocaK6un25ULh9Yw5Q0bPTBh8VeuwaEZzUUQK2iCX7kz0+aH4l5lI0yfZo1RKxHK60aXMG1dlkXtQ2xjlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bl5teSzE4eR87OcVUaxsz0cVrvZhpW6k0W+HucJTntk=;
 b=sjcHknCP2JZ5tn+E46/cdEfjQptYVjaBo2F0HK22AiyE1kSiqyATXvCt/ZhmlKAXhx18ROqXEwMpXyYfmriqeoWvbTWFAuD0PzHITrlORoVTn80noUTY7X8ZXjFL0OHF5BRCDuWKdLvKzLWkOXXk8/QXxdzZz1uSQhxlx4+soNdOzKMIe1OWZP2LgWwco64U2ibXwAiUh2mqwRSy4kVDR/baIYqFzQaXfxJnxjc5rXlYq/koBHddOE66Yveo3FCxMAdjUYsW8lvGFtW++G/bgNLm1vYjI9y/Ooo4wSQqCsaxHOJIJTKYyeG66yEFhegGSPxLlrWevUyz3Wu3HjXq4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=strlen.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bl5teSzE4eR87OcVUaxsz0cVrvZhpW6k0W+HucJTntk=;
 b=s1pP0d3NYA1CE7gZJPilUVH6zJ+wJn0C33FthD+WZDvWWdL/q1qzVHOpGHdpukR6UgCwFFsfEQnhGtLUb1vaa44IL74RD1OcAayRn1CVnh6x8WGfRMyxspX0IkKOier7M0q3kmeNf99+FhflfN+Biyr3+plqDmr4yCJO8bcRjcQ6iVCdrb8Tn0NM+psVXzkiZnzZQP11rsJGYYDUpk6YK0d61+9h0UO91HYMyYl7f9x1UBqqVWj4QFGJUMWAtwKPEiGej2CJcyVQ+cwx7/SrZWIoeUB3N5kBSVYoWr/0JL2Ffh+MkB1loKqn3VTIFbm85zzHvpDyEAZ/KA7oMxi/vQ==
Received: from CY5PR22CA0046.namprd22.prod.outlook.com (2603:10b6:930:1d::28)
 by CH3PR12MB9342.namprd12.prod.outlook.com (2603:10b6:610:1cb::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.27; Mon, 30 Sep
 2024 16:28:14 +0000
Received: from CY4PEPF0000E9D6.namprd05.prod.outlook.com
 (2603:10b6:930:1d:cafe::cb) by CY5PR22CA0046.outlook.office365.com
 (2603:10b6:930:1d::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.27 via Frontend
 Transport; Mon, 30 Sep 2024 16:28:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000E9D6.mail.protection.outlook.com (10.167.241.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8026.11 via Frontend Transport; Mon, 30 Sep 2024 16:28:13 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 30 Sep
 2024 09:27:58 -0700
Received: from fedora (10.126.231.35) by rnnvmail201.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 30 Sep
 2024 09:27:54 -0700
References: <20240731063551.1577681-1-danieller@nvidia.com>
 <ZqnkZM1rddu3xpS4@orbyte.nwl.cc>
 <DM6PR12MB4516F083558D7AB3466FAF9ED8752@DM6PR12MB4516.namprd12.prod.outlook.com>
 <Zvp9NShxCERRPDdi@calendula> <ZvqD1CmbNg_UAGQY@calendula>
 <20240930134509.489b54df@kernel.org> <ZvqeEa_37KEmL8li@calendula>
User-agent: mu4e 1.8.14; emacs 29.4
From: Petr Machata <petrm@nvidia.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
CC: Jakub Kicinski <kuba@kernel.org>, Danielle Ratson <danieller@nvidia.com>,
	Phil Sutter <phil@nwl.cc>, "netfilter-devel@vger.kernel.org"
	<netfilter-devel@vger.kernel.org>, "fw@strlen.de" <fw@strlen.de>, mlxsw
	<mlxsw@nvidia.com>
Subject: Re: [PATCH libmnl] src: attr: Add mnl_attr_get_uint() function
Date: Mon, 30 Sep 2024 18:25:17 +0200
In-Reply-To: <ZvqeEa_37KEmL8li@calendula>
Message-ID: <87cyklm7i2.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D6:EE_|CH3PR12MB9342:EE_
X-MS-Office365-Filtering-Correlation-Id: 4516a99a-11f9-46c2-3017-08dce16ce190
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3YCvfZ0OWZL8IjrBQbnUpka/mqB4IHutgO3vb1DqCQ3EPrf77jzUGTqoyMkv?=
 =?us-ascii?Q?ThgRZSL1HSIMDt4UbUHXFU3Z7kcjvvT7hcwI6F/c1Yf7sIXZKUp+QZj3Xy8g?=
 =?us-ascii?Q?rTq30hhZdc1a53XqhzQAzg0umegHZFTX3m7HPCwfKB+zXB3DhqoCHP/eEhkQ?=
 =?us-ascii?Q?ryvAP7VWV+UUnFcSdV5r9UnR50JnksvteVALersgj2ZZOgi9bleYzfHbCC76?=
 =?us-ascii?Q?I5RUFz26zWW+sCArD6MY4FLIX0UEaJLp4JMDIBbB8p9+PIuy6We5rAM4RtFl?=
 =?us-ascii?Q?isa0zAVJcFLdkacBxYN2Zx32xYbZDbswbHJso8mntwuf+psMy5zew0l4wI9H?=
 =?us-ascii?Q?ZsGcieGq0fAYie6KMKk7JDjfdZzqISJQkZAXhYN63JJ8w1HU8iRrtco4Honl?=
 =?us-ascii?Q?86WSTFQ89t6LBMxwhcci/B95pTjVvHEZG92Rppb7LIr+LTYvL/F30gVwofC9?=
 =?us-ascii?Q?/9qzx66X8z61ilXxmjk17hUQNgcBWtcF9fBfRH+SWpLeY+CXn/imGIyo28Wu?=
 =?us-ascii?Q?8bV22eJpy05wl2F/l1Vp65+6GhtNRK19MJ+JFwI3LU3RaNMaba785L+uK7M+?=
 =?us-ascii?Q?gBWTDfT9igVFDPHaoUpDxQE3/Y/ka8UXCV5ah8GyPS/Kv25pYUElVromOvEb?=
 =?us-ascii?Q?/9dHvfMs79eDIzUdNmUsx9ujsiOZkETKFF5grZs+kwZnqzWgAXx3388N6KYb?=
 =?us-ascii?Q?l3W6zQhe0ElSls6HSB6wJ+J4gQD5G/M4Lko+kQsyY5FQUgeGHrQAkMRltYoQ?=
 =?us-ascii?Q?vj/HordmSDonOVhsk1BOp8JNjH3JhFz9xlsQIYnVS8JV9QkO7iVWkVf0K2Cw?=
 =?us-ascii?Q?RcdUG2SN9N15hnsAACJAYAB52zbx8WxtFIa0gwbwvYZuyYLkzYBa1ZEnM22y?=
 =?us-ascii?Q?J1hjC1+JBwqKXe7II0+/YeN6HN2OEN9ON5Hcd0ejQ3+0iyER9+2Lc44D20bR?=
 =?us-ascii?Q?FwfRE37ueo/k6g+puIdrnMJGwSowb0XcR4WuB3Rds1lIi7/S/r1ZgWlVFE0Z?=
 =?us-ascii?Q?eBV/f6Y4MAj7/n5Urna/zaljMFchvvNxkYylMff5FJV8KFEVpttG7yUZ15q8?=
 =?us-ascii?Q?h4d5EzRhjIZO6R3mVIlBC6CGjge9lQ1uRCUYwnLC+p1SoXkijZOUFS+/UKsD?=
 =?us-ascii?Q?iontAp7z1YaXxAtwakpQq37X5RoaWNAo6GGpagCJDoBqnpznkaERWfKfY63u?=
 =?us-ascii?Q?nxm99kZzTrzWRsE5HKW+9qtk4ItTmy9Cf/wJFW9RiFz/YZEhKpyH9or3qSMK?=
 =?us-ascii?Q?Uk/dq6koQbeRNxTpll0cwVwFbQ+KFOtUNrPTocB5q955SmJiu8rNM+TSYS5+?=
 =?us-ascii?Q?UmOVHCHDkvseq26Cyv6QFfr630Ni34pJTK9xUKCOKYC68Fjl75NwOYGWvng6?=
 =?us-ascii?Q?GUWxcm0oUxWlxLlp2f607GuVM2muCzUXtftJzyygRfEIYKzec1SG/w2CjElg?=
 =?us-ascii?Q?/EWkoWKYj0CZnuwjGZG4GEpRpMOSyzz4?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2024 16:28:13.5870
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4516a99a-11f9-46c2-3017-08dce16ce190
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9342


Pablo Neira Ayuso <pablo@netfilter.org> writes:

> On Mon, Sep 30, 2024 at 01:45:09PM +0200, Jakub Kicinski wrote:
>> On Mon, 30 Sep 2024 12:56:20 +0200 Pablo Neira Ayuso wrote:
>> > On Mon, Sep 30, 2024 at 12:28:08PM +0200, Pablo Neira Ayuso wrote:
>> > > On Sun, Sep 29, 2024 at 10:42:44AM +0000, Danielle Ratson wrote:  
>> > > > Hi,
>> > > > 
>> > > > Is there a plan to build a new version soon? 
>> > > > I am asking since I am planning to use this function in ethtool.  
>> > > 
>> > > ASAP  
>> > 
>> > but one question before... Is this related to NLA_UINT in the kernel?
>> > 
>> > /**
>> >  * nla_put_uint - Add a variable-size unsigned int to a socket buffer
>> >  * @skb: socket buffer to add attribute to
>> >  * @attrtype: attribute type
>> >  * @value: numeric value
>> >  */
>> > static inline int nla_put_uint(struct sk_buff *skb, int attrtype, u64 value)
>> > {
>> >         u64 tmp64 = value;
>> >         u32 tmp32 = value;
>> > 
>> >         if (tmp64 == tmp32)
>> >                 return nla_put_u32(skb, attrtype, tmp32);
>> >         return nla_put(skb, attrtype, sizeof(u64), &tmp64);
>> > }
>> > 
>> > if I'm correct, it seems kernel always uses either u32 or u64.
>> > 
>> > Userspace assumes u8 and u16 are possible though:
>> > 
>> > +/**
>> > + * mnl_attr_get_uint - returns 64-bit unsigned integer attribute.
>> > + * \param attr pointer to netlink attribute
>> > + *
>> > + * This function returns the 64-bit value of the attribute payload.
>> > + */
>> > +EXPORT_SYMBOL uint64_t mnl_attr_get_uint(const struct nlattr *attr)
>> > +{
>> > +       switch (mnl_attr_get_payload_len(attr)) {
>> > +       case sizeof(uint8_t):
>> > +               return mnl_attr_get_u8(attr);
>> > +       case sizeof(uint16_t):
>> > +               return mnl_attr_get_u16(attr);
>> > +       case sizeof(uint32_t):
>> > +               return mnl_attr_get_u32(attr);
>> > +       case sizeof(uint64_t):
>> > +               return mnl_attr_get_u64(attr);
>> > +       }
>> > +
>> > +       return -1ULL;
>> > +}
>> > 
>> > Or this is an attempt to provide a helper that allows you fetch for
>> > payload value of 2^3..2^6 bytes?
>> 
>> No preference here, FWIW. Looks like this patch does a different thing
>> than the kernel. But maybe a broader "automatic" helper is useful for
>> user space code.
>
> Not sure. @Danielle: could you clarify your intention?

This follows the iproute2 helper, where I was asked to support >32-bit
fields purely as a service to the users, so that one helper can be used
for any integral field.
