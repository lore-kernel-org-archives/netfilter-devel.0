Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2044.outbound.protection.outlook.com [40.107.244.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E6B38396
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Oct 2024 08:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727770757; cv=fail; b=eXscoKzDrvAEejLudZ6dmhsamBubneHv6ivKwd+rCWKBRDgMAiG5hzY/S+WWAQTFd3aIi61BjZs4KeoaXDMdqjazdpJX4puUACp6mtHG88UFvvXe0Iey5jBFDKrlV3hR/zjCPhVl1M/w1IqWaQBXwEhzrobK5wOTsKMolcGxBfg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727770757; c=relaxed/simple;
	bh=alDJYFHnTDXq0ZQblipNRUquYU3vORYRwBH4vXfqj6s=;
	h=References:From:To:CC:Subject:Date:In-Reply-To:Message-ID:
	 MIME-Version:Content-Type; b=AxDW/VWoIl8+Qi1ktVo5OcRC50pbAPFhd/eD72zWhO/BweVW41rrqDC4sa72zBnEpYNLsyOj4gZlyYk+SnVSlLz0sWzLf+vw8IOdDXV/UlHiB3p/tRMGCS4fWS2yLpqq9muD+BCxf0diG7Sohy3Hgp4eUCBLgWdeAq+wl4IdZ3M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iGPpE9aF; arc=fail smtp.client-ip=40.107.244.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iGPpE9aF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lnet8KvK8RQoVZVBnU+vRdzL4aD5ipD7lAMTP9PPZGEximv9kZV/a/J41Grl6cuHD2ZXxPHUBf37ou7YMsGbRD8YhXARRDHXbh2HkHur3K/sK/elS/LXO//YoaoOfYLXjoflH2t6rawrVkuY8wh2OzDZzyWdKSnBzi33415QxRoy5hqEyy4OV3En+yyd+1A4jmB2SJNXqvIqohwy90f5RZVb4kmM2mPKpBZWixReaOe5gxllDA7S1/PtwLCZ24/OmOIqN/KgeiUWD8j6fJT41apo98TpVjGCnx1ZrOV0twQNC5BDdjKZeIk69rAofDmNxyXBDPgWXxYfbWm3rDqIVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fH68rVQkn0+p3scuoep7iRMFS1P+VcI42DtW/nwrX6Y=;
 b=YoyJzeaKBwZyar89r/5Rhqu55Z1PHRDNQU9wufnojjSjbNVoRxXSM9ytYSRp4CCI2o35fCvTbsI7FL3FICwk7zMbGWDJUabmgmY9T+DjUVMWqpOWBwwS+o0yF0EI1vo9EdhCLm+f3zpNUYb9kI3hWVQQW0tyN4n3oHG/S5CE4jDU7e+SCJzHYgOnN7GuI8Jgzp3JqEzLcKXtIPK43BDwR3BRfX89FJ00JLE+SG0ADGzVBHiSQOE3PPmlTiHjlxBcXTK9KiLJ0UX0Sulhm/+ilk/HVsxN70tfZqfDDXoPF9qluF+J+VgfqfDNzsk4IcWJ6sukBwxuX+YgbANoTCbH5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=strlen.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fH68rVQkn0+p3scuoep7iRMFS1P+VcI42DtW/nwrX6Y=;
 b=iGPpE9aF6wiZru62dslAM4rbE6Ip+FSOehUkI+VNllA/deGCfazhUsxlgsfDW6/v8nsy92KU/EFFpBuwSYSXWYKm03mjocWXofaN58aVBtXNSzbRP/kLxOtGxOQyQSNhEfwxM3xEQxETzHB97pxWo/ZihzbULXWwKAXpXAO2Rbi1jih/Bhkd+SBpEJx5PF1tRjYWXWF1QY/Dog1Q661pNlnrjcE8zLcWIHIZacQTXXHr/QMXpGpwDsAKU5zh6r0PyObMxa+zE2Gxf0ILPApE8i0keyM8WuZZSdxBs2vzheqTx39W/Tgnxe4BZMJMhA5Ddt/CNS2oshvfztClun/71w==
Received: from MW4P220CA0022.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::27)
 by DM4PR12MB6181.namprd12.prod.outlook.com (2603:10b6:8:a9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.25; Tue, 1 Oct
 2024 08:19:10 +0000
Received: from SJ1PEPF000023D7.namprd21.prod.outlook.com
 (2603:10b6:303:115:cafe::a8) by MW4P220CA0022.outlook.office365.com
 (2603:10b6:303:115::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.27 via Frontend
 Transport; Tue, 1 Oct 2024 08:19:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF000023D7.mail.protection.outlook.com (10.167.244.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8048.2 via Frontend Transport; Tue, 1 Oct 2024 08:19:09 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 1 Oct 2024
 01:18:59 -0700
Received: from fedora (10.126.231.35) by rnnvmail201.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 1 Oct 2024
 01:18:53 -0700
References: <20240731063551.1577681-1-danieller@nvidia.com>
 <ZqnkZM1rddu3xpS4@orbyte.nwl.cc>
 <DM6PR12MB4516F083558D7AB3466FAF9ED8752@DM6PR12MB4516.namprd12.prod.outlook.com>
 <Zvp9NShxCERRPDdi@calendula> <ZvqD1CmbNg_UAGQY@calendula>
 <20240930134509.489b54df@kernel.org> <ZvqeEa_37KEmL8li@calendula>
 <87cyklm7i2.fsf@nvidia.com> <ZvrZciPsfppMf9dl@calendula>
 <ZvrbgAHBWknkk2fe@calendula> <ZvrlQjuqS0XY2CW6@calendula>
User-agent: mu4e 1.8.14; emacs 29.4
From: Petr Machata <petrm@nvidia.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
CC: Petr Machata <petrm@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
	Danielle Ratson <danieller@nvidia.com>, Phil Sutter <phil@nwl.cc>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"fw@strlen.de" <fw@strlen.de>, mlxsw <mlxsw@nvidia.com>
Subject: Re: [PATCH libmnl] src: attr: Add mnl_attr_get_uint() function
Date: Tue, 1 Oct 2024 10:16:03 +0200
In-Reply-To: <ZvrlQjuqS0XY2CW6@calendula>
Message-ID: <87zfnokzh5.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D7:EE_|DM4PR12MB6181:EE_
X-MS-Office365-Filtering-Correlation-Id: ad450257-1a9c-4779-14df-08dce1f1b964
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DcrUP9Gta0s+f4oFPOMMR0o29LwnjHqRIzRcmo09vZV6pguksqfqsR084eAx?=
 =?us-ascii?Q?M0fBy5xi4Wiw/DFCXa+W/nq8stvjyGrAeGUiQPyli5yPvxv1hslpWBXXhOmb?=
 =?us-ascii?Q?Gga1ChDATGE9L/8L0JUJpjPfaJ1gNnv8kAbkoCnjnk+vCed+epPpBZxV6yyt?=
 =?us-ascii?Q?ZzyAo4o4rZmgwK7g3qhNxNzI7crKtQWn5pkq0oFXs7fibd/NFPUMjlwS2AVi?=
 =?us-ascii?Q?WOsYr3I7Yz+yTqLsNkRVcw970k6H1Ivc5Mo5t+Yu6MawxmPQTmn9T4HYCkDT?=
 =?us-ascii?Q?1q2NWWw9W+gKtkwg9KgY9bvDnMWP1QD2ce7w5t2yhtHgavpqPvTfM+NDlglH?=
 =?us-ascii?Q?C4mpjtkiefdYid/p4CH+ywB9iGStslfKNY0Nv+AgYGziHcUflamvPWejW1Ke?=
 =?us-ascii?Q?9bTYkIEDYDDpP+EptExMAbTrcrchJa/1IBZAE7UiNtZPGz3K3vWAfBFWHyQJ?=
 =?us-ascii?Q?JqnQCu0SseSEdSuCiXjzn2PjoweFWOmEB3aZ58Q8QQlqAdkVlZVbR2oRnCDl?=
 =?us-ascii?Q?klTQZRc3Ux5qSB/cx5bz1ZbH8rFQJ7P0ilyTqRCYsS3mbFpNBLtVUpuYoXFt?=
 =?us-ascii?Q?jioefqH1KJBkitDAqzINHS0tCsZVa5/zMuby9+S7ZLxM6jyM0EYJcyyL8aIF?=
 =?us-ascii?Q?nt08403WA9KOierdh33QQ3I/AJAyYQIKb1vUvpt0hUpnW9NVZyiraBKSvc7a?=
 =?us-ascii?Q?IuhfCj7JPNJ6BR9otmfzXNdGh/Mh6nS5o+WyoaxGu+2pB8VFkLqq3C88+LNl?=
 =?us-ascii?Q?8QI4Eb0AG/NdqClx6HrzRNomOKTzdCcCNoxQFSERCCljd+FFI46w/GPEtirz?=
 =?us-ascii?Q?0Z4WsMoiCuRHCd9/LK7IJM3f6ONWvcEQ8Z9uMd0jznbkhGmVlNXSyv6ktcIj?=
 =?us-ascii?Q?LokhYu09yEsrvDw1/y02mbYJt6gYE0psN/otAcm6WQDiIqIxl4RzpzfGoP5i?=
 =?us-ascii?Q?WtSwmZol37p9vfbqKPoKbYg114G/Rmy3w8BlqUa8P+0ZH/FL9LbSz45ZMf+P?=
 =?us-ascii?Q?UCf8UmnaXvznnA1Mww6NNGdHp6pTMRF7vBJhVBZ0umfjVB4HG6Svc+lA5Xvw?=
 =?us-ascii?Q?PvSUIwfm1BLo/aOmNOUlu+rvBXx6TsRBR6kwo+sNugvgyrnbl+iHnzM6PY5T?=
 =?us-ascii?Q?6BsleB2YdCpmxYooMkSTsdKOQuhv/cMTKEw3WaiX1uYDr2Df2TtATzrN4KxX?=
 =?us-ascii?Q?Wl0Bt8laA0dOWj9srAzgPGQVOX9yCSYf2abqW1VXBQPosAxuFQ1trjkQeO/u?=
 =?us-ascii?Q?uMtgPb2OPOu5KdPRY71kZCotiI7QtqJJZjXUERv7rOKHUJPpwXj30KtUEbbm?=
 =?us-ascii?Q?pBbtMJbZULbAywTRg7pHyIKJikiRLMtqSL6nTnytl5WeNEd9LPXENQQEEDno?=
 =?us-ascii?Q?k+U4Ki/HiuRf4OsZrvpiQkPn05fbsyQ9gAZij9OuCQXW+EWeng=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2024 08:19:09.3010
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ad450257-1a9c-4779-14df-08dce1f1b964
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D7.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6181


Pablo Neira Ayuso <pablo@netfilter.org> writes:

> On Mon, Sep 30, 2024 at 07:10:27PM +0200, Pablo Neira Ayuso wrote:
>> On Mon, Sep 30, 2024 at 07:01:42PM +0200, Pablo Neira Ayuso wrote:
>> > On Mon, Sep 30, 2024 at 06:25:17PM +0200, Petr Machata wrote:
>> > > 
>> > > Pablo Neira Ayuso <pablo@netfilter.org> writes:
>> > > 
>> > > > On Mon, Sep 30, 2024 at 01:45:09PM +0200, Jakub Kicinski wrote:
>> > > >> On Mon, 30 Sep 2024 12:56:20 +0200 Pablo Neira Ayuso wrote:
>> > > >> > On Mon, Sep 30, 2024 at 12:28:08PM +0200, Pablo Neira Ayuso wrote:
>> > > >> > > On Sun, Sep 29, 2024 at 10:42:44AM +0000, Danielle Ratson wrote:  
>> > > >> > > > Hi,
>> > > >> > > > 
>> > > >> > > > Is there a plan to build a new version soon? 
>> > > >> > > > I am asking since I am planning to use this function in ethtool.  
>> > > >> > > 
>> > > >> > > ASAP  
>> > > >> > 
>> > > >> > but one question before... Is this related to NLA_UINT in the kernel?
>> > > >> > 
>> > > >> > /**
>> > > >> >  * nla_put_uint - Add a variable-size unsigned int to a socket buffer
>> > > >> >  * @skb: socket buffer to add attribute to
>> > > >> >  * @attrtype: attribute type
>> > > >> >  * @value: numeric value
>> > > >> >  */
>> > > >> > static inline int nla_put_uint(struct sk_buff *skb, int attrtype, u64 value)
>> > > >> > {
>> > > >> >         u64 tmp64 = value;
>> > > >> >         u32 tmp32 = value;
>> > > >> > 
>> > > >> >         if (tmp64 == tmp32)
>> > > >> >                 return nla_put_u32(skb, attrtype, tmp32);
>> > > >> >         return nla_put(skb, attrtype, sizeof(u64), &tmp64);
>> > > >> > }
>> > > >> > 
>> > > >> > if I'm correct, it seems kernel always uses either u32 or u64.
>> > > >> > 
>> > > >> > Userspace assumes u8 and u16 are possible though:
>> > > >> > 
>> > > >> > +/**
>> > > >> > + * mnl_attr_get_uint - returns 64-bit unsigned integer attribute.
>> > > >> > + * \param attr pointer to netlink attribute
>> > > >> > + *
>> > > >> > + * This function returns the 64-bit value of the attribute payload.
>> > > >> > + */
>> > > >> > +EXPORT_SYMBOL uint64_t mnl_attr_get_uint(const struct nlattr *attr)
>> > > >> > +{
>> > > >> > +       switch (mnl_attr_get_payload_len(attr)) {
>> > > >> > +       case sizeof(uint8_t):
>> > > >> > +               return mnl_attr_get_u8(attr);
>> > > >> > +       case sizeof(uint16_t):
>> > > >> > +               return mnl_attr_get_u16(attr);
>> > > >> > +       case sizeof(uint32_t):
>> > > >> > +               return mnl_attr_get_u32(attr);
>> > > >> > +       case sizeof(uint64_t):
>> > > >> > +               return mnl_attr_get_u64(attr);
>> > > >> > +       }
>> > > >> > +
>> > > >> > +       return -1ULL;
>> > > >> > +}
>> > > >> > 
>> > > >> > Or this is an attempt to provide a helper that allows you fetch for
>> > > >> > payload value of 2^3..2^6 bytes?
>> > > >> 
>> > > >> No preference here, FWIW. Looks like this patch does a different thing
>> > > >> than the kernel. But maybe a broader "automatic" helper is useful for
>> > > >> user space code.
>> > > >
>> > > > Not sure. @Danielle: could you clarify your intention?
>> > > 
>> > > This follows the iproute2 helper, where I was asked to support >32-bit
>> > > fields purely as a service to the users, so that one helper can be used
>> > > for any integral field.
>> > 
>> > Which helper are your referring to? Is it modeled after NLA_UINT?
>> > 
>> > I don't think this patch is fine. This also returns -1ULL so there is
>> > no way to know if size is not correct or payload length is 64 bits
>> > using UINT64_MAX?
>> 
>> I found it:
>> 
>> static inline __u64 rta_getattr_uint(const struct rtattr *rta)
>> 
>> This only has one user in the tree so far, right?
>
> Well, this is a matter of documenting behaviour.
>
>> include/libnetlink.h:static inline __u64 rta_getattr_uint(const struct rtattr *rta)
>> ip/ipnexthop.c:                 nh_grp_stats->packets = rta_getattr_uint(rta);
>> ip/ipnexthop.c:                 nh_grp_stats->packets_hw = rta_getattr_uint(rta);
>> 
>> is this attribute for ipnexthop of NLA_UINT type?
>
> But it seems intention is to support NLA_UINT according to iproute's
> commit.
>
> commit 95836fbf35d352f7c031ddac2e6093a935308cc9
> Author: Petr Machata <petrm@nvidia.com>
> Date:   Thu Mar 14 15:52:12 2024 +0100
>
>     libnetlink: Add rta_getattr_uint()
>     
>     NLA_UINT attributes have a 4-byte payload if possible, and an 8-byte one if
>     necessary. Add a function to extract these. Since we need to dispatch on
>     length anyway, make the getter truly universal by supporting also u8 and
>     u16.
>
> so it went further to make it universal for 2^3..2^6 values.
>
> I am going to submit a patch to provide more info on this helper function.

Yeah, sorry, I wrote this to explain the rationale:

> This follows the iproute2 helper, where I was asked to support >32-bit
> fields purely as a service to the users, so that one helper can be used
> for any integral field.

... but of course I should have written <32-bit payloads, not >32-bit.
