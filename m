Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2043.outbound.protection.outlook.com [40.107.220.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16D11A254B
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Oct 2024 08:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727769905; cv=fail; b=IDJ+9gHTuCXiz0juJG9UBsB45sWNMzLIOuvbh6WkqrnsOLLUDSjZRuf68RrGpQwAptKuRsJ+Qf8PVIWm/JDym489RRwmXBbeHbXmmZ3N5BJwiDKYmSYW/6od0OmEbDNZUXlZVKfs2sYqBE2sCc+Kn7QCerfwmL9cRtxuDs+9hJA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727769905; c=relaxed/simple;
	bh=0SlcPHcmclEA/mR9pg0DQBVYaQvQb4anRrLIZMuaFa8=;
	h=References:From:To:CC:Subject:Date:In-Reply-To:Message-ID:
	 MIME-Version:Content-Type; b=C5Xiz1xfC4ifPFHiSqRx1jOTSMFS2dnGqkUyfc0XXNDkYo2Dg1qLM8naag+DenM8hs5Sc/yS9gbkQSb0eoexWf33xSJTXgNAlg+HJy95vz3z/jiYnQmYsTzQWX39JbZd/Es9suf2Kw24z9B/mb10beVdTwCjK3JsBTknhMXzv34=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pW2yfwQA; arc=fail smtp.client-ip=40.107.220.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pW2yfwQA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NYjTXEF/IjJYRcwVUSlhuLFlPecj05kmS30X6wCeF/qy1JYwtaEgSzR/JOHdAfBqtkDXjvZHRLzSHI6nBDlNFCcewKU4qHnvAO4KjrV1cr+1yb8HqjKX0HB7HRjTL8x6jkO3OFtqKRLq9PXZlUCecJmI2ZhzXGvZklCbdHtIHF5PMHngBtKINzPz13elCJVORnhkLrUv+8RcspifkCvPNr+vS2+UJJWz+n82bOnnVAMgz8SBlLp3PMhIDFe9q2moKcrd1zRUa06kQRSadyfwL86fFNI741eR5faVDC8Q53qEmIx5gf/lgdKlSlYLW+SCz9FRXXofw4wKEhckmoqE7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZywV2PfIuJEV7C9dHbaimThc0P6wvG9MviM+4VnJUF0=;
 b=Ah8n0Mzz0UlvDfUwv4GekUroVNzyO9LfsquchAwyr46nBxNoNUSb3UbUQuEp2gJGD/yikvtU8i2GdhTDGkiYUoVC6T4+rQnlakywmr7mod5Zo4afIvkqLyWubrjO3fcSmxzNSWVFcqKOtClbx+VKVPUiN5hAhMdlS6ng8l9alP6V4KVIpgJ6LCW5wcV98ZUwVU0A7pMi0AWXh3vrRU9wynvWTroW+TaVH0ly53Kku0NuqTIqMyRsUsyxMQXQrjt/72bY4EtO7JNQL64YEYaba+eBQPuuPgYypbobb6+j5mpEJvFJJon4wZ8c0x+dCQ5W1Ks5m0lzvbD2nJu9UaI10Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=strlen.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZywV2PfIuJEV7C9dHbaimThc0P6wvG9MviM+4VnJUF0=;
 b=pW2yfwQAJb5YRCGQywlsgsEhV+XfhcxcoQwWVcZSoJhq4W0Q0LyBEHnRQn6OtRXR0ekJTQ9K+SvGZvxNreO50JTZcgC7ZSsrLbVpps0+yCxc8rxCaAUtJ+DVT+5N3qOPLrADL9Heb6crHR+xt39ZErBwjBet8zptkNHibnEhReOSCI3PIBn7ya1G35eGt4CkfWS8t2YGFsCjG1yzwszMP2La2hc7CGdk4IcXp8mWvmm27SXVh9h/yqsY6siypiMnTQ+lHcjrhxhYnNwomfwnv19Q0r/OCCDNgGSVwEUnpJrRYFU3iFCeSbl/H5IhPGcApGnyEIdCGH0OUQnxYEFMJQ==
Received: from BN7PR06CA0055.namprd06.prod.outlook.com (2603:10b6:408:34::32)
 by CH3PR12MB8545.namprd12.prod.outlook.com (2603:10b6:610:163::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.27; Tue, 1 Oct
 2024 08:04:57 +0000
Received: from BN2PEPF00004FC1.namprd04.prod.outlook.com
 (2603:10b6:408:34:cafe::32) by BN7PR06CA0055.outlook.office365.com
 (2603:10b6:408:34::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.27 via Frontend
 Transport; Tue, 1 Oct 2024 08:04:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF00004FC1.mail.protection.outlook.com (10.167.243.187) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8026.11 via Frontend Transport; Tue, 1 Oct 2024 08:04:56 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 1 Oct 2024
 01:04:39 -0700
Received: from fedora (10.126.230.35) by rnnvmail201.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 1 Oct 2024
 01:04:32 -0700
References: <20240731063551.1577681-1-danieller@nvidia.com>
 <ZqnkZM1rddu3xpS4@orbyte.nwl.cc>
 <DM6PR12MB4516F083558D7AB3466FAF9ED8752@DM6PR12MB4516.namprd12.prod.outlook.com>
 <Zvp9NShxCERRPDdi@calendula> <ZvqD1CmbNg_UAGQY@calendula>
 <20240930134509.489b54df@kernel.org> <ZvqeEa_37KEmL8li@calendula>
 <87cyklm7i2.fsf@nvidia.com> <ZvrZciPsfppMf9dl@calendula>
 <ZvrbgAHBWknkk2fe@calendula>
User-agent: mu4e 1.8.14; emacs 29.4
From: Petr Machata <petrm@nvidia.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
CC: Petr Machata <petrm@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
	Danielle Ratson <danieller@nvidia.com>, Phil Sutter <phil@nwl.cc>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"fw@strlen.de" <fw@strlen.de>, mlxsw <mlxsw@nvidia.com>
Subject: Re: [PATCH libmnl] src: attr: Add mnl_attr_get_uint() function
Date: Tue, 1 Oct 2024 09:51:43 +0200
In-Reply-To: <ZvrbgAHBWknkk2fe@calendula>
Message-ID: <874j5wmepi.fsf@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FC1:EE_|CH3PR12MB8545:EE_
X-MS-Office365-Filtering-Correlation-Id: 9824c298-568e-4494-46d3-08dce1efbd61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WY7JrZ0iv2NGb+Ta41FHmffOVyJS9G8fzdlvQQR32MlFY0md+j1n5DnIXi7F?=
 =?us-ascii?Q?KqaR2Gb/B+r3vR2AeqgViCSmAAAg7ATrCnLlZ+IGGf93ggBBQEz2PyN/tYvE?=
 =?us-ascii?Q?N1vsmJE6mfKW1V+4pRQLi1/k5+U/kq1EbIVju1PsnuTH8Eizxy7ZdwbW4mDx?=
 =?us-ascii?Q?Sju9b4lQfO+MEWpJzxuaKMhKWHYD2FAyIoBnUpqXkkfNUPhKKvXo4tSFGPV0?=
 =?us-ascii?Q?IGZV0+HMqrrOzg94UvHOoGzR9QMIc5K6zkRcsMUagIqf6oP3+OCK5BgsyT37?=
 =?us-ascii?Q?rG9VIjZ+V8g9iQzU0ke9r/HoZCQv6tg4lhvmxFAZuVpJssYCY9zw9xcnFSve?=
 =?us-ascii?Q?19X+r/avfYWR72VnmY4w3lJInL6fyCxVZz3uf8+7+4k/BzOD32LiM9E2V0EX?=
 =?us-ascii?Q?E7lzOcpRAxUZQqefp87P35LP3Ol4YylOvDQDBBMhS+l9KF+Zr01QkwExvKcM?=
 =?us-ascii?Q?gPNkrCxjankGH7qVUeFueyia96QkREb5pcyYzNNsJgnO5002kHyfh4/YVDhL?=
 =?us-ascii?Q?uKdOFmr+fou9NDygmvi3negne7ylDouuOZVr65H2rCa4yLbBIAz1iBiAbhH9?=
 =?us-ascii?Q?WnthfVEUBZB8fpjFpLxPuulztb5dhK4GUtmKHz/j/b2imITl+nXNOwhFJ5Zj?=
 =?us-ascii?Q?tfALS59VD71EelvyRVlileO6xNayx06+LUA6ZprYIQDLlsHubDu8wI0MVDf3?=
 =?us-ascii?Q?AOOAPUCSFsls71KsQROwxgyF1txUGhlf1T3T+1RwjMDrEvz4kUZZPY3tCK/a?=
 =?us-ascii?Q?vpp/W0Ku/5IBl83bevDadV7Nr1wvQn+8HBk2p3/X/1XVufTWHGcoHfobm1vU?=
 =?us-ascii?Q?M7ZqTW+BfBYa1pIYZ7psFiLAjVRoR397Ztvm4ci0nrUX1FWAO0N/7kAvfzyS?=
 =?us-ascii?Q?bLwVb+nvupMLan3147mUBF/Th5egWHv2C1gI9JJgbLW1ooIO0GyMKz1uIjBA?=
 =?us-ascii?Q?l5qmgPDWhwbw9JzD2xZU61UPSjRzjAvjmX/3/PgI/MhBbXhGW2wFV7ONHPLj?=
 =?us-ascii?Q?OvklHvYhNDhx0SOkysxDJ7D/ZXh0+QJn6RuGgUifey/PuOAE/H1a+it4SFyL?=
 =?us-ascii?Q?nzz8HCIuWrfoMrjbES8R7+/6M984dWhZuWOb6lFH8iEJlbtBXfHy8Of3a11A?=
 =?us-ascii?Q?Yb2ZI885nlspXAA5m/+XQwF3asKcqOsOM6TaxfPcrP8xameiUYxDW+LQricX?=
 =?us-ascii?Q?/UUnVRqeJUK3Oo8I4/rpxOxp30Hd4WXHKMRlqhuLuZyMEFludii2KySNExJV?=
 =?us-ascii?Q?L7BTFWrUUw1pUF0YZ5h7sp/ix0tgfAA3dSm/Xgv8IkC+YlrZKDGODzrlEpCJ?=
 =?us-ascii?Q?0U2ie0CHdiB9CLXl4qKKEg243/hiVScYwvmv0/aMtuDc3dHdfiJMXn3YnuNW?=
 =?us-ascii?Q?3uRy/nENakMLdlgZAkXYrkc4w0E6c0ZfRHfHtjZyL7keu/q8PZoJDkrrtH39?=
 =?us-ascii?Q?W1yo8ne6JFQ7SWmqYWjADsZhCULTZh4t?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2024 08:04:56.7032
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9824c298-568e-4494-46d3-08dce1efbd61
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FC1.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8545


Pablo Neira Ayuso <pablo@netfilter.org> writes:

> On Mon, Sep 30, 2024 at 07:01:42PM +0200, Pablo Neira Ayuso wrote:
>> On Mon, Sep 30, 2024 at 06:25:17PM +0200, Petr Machata wrote:
>> > 
>> > Pablo Neira Ayuso <pablo@netfilter.org> writes:
>> > 
>> > > On Mon, Sep 30, 2024 at 01:45:09PM +0200, Jakub Kicinski wrote:
>> > >> On Mon, 30 Sep 2024 12:56:20 +0200 Pablo Neira Ayuso wrote:
>> > >> > On Mon, Sep 30, 2024 at 12:28:08PM +0200, Pablo Neira Ayuso wrote:
>> > >> > > On Sun, Sep 29, 2024 at 10:42:44AM +0000, Danielle Ratson wrote:  
>> > >> > > > Hi,
>> > >> > > > 
>> > >> > > > Is there a plan to build a new version soon? 
>> > >> > > > I am asking since I am planning to use this function in ethtool.  
>> > >> > > 
>> > >> > > ASAP  
>> > >> > 
>> > >> > but one question before... Is this related to NLA_UINT in the kernel?
>> > >> > 
>> > >> > /**
>> > >> >  * nla_put_uint - Add a variable-size unsigned int to a socket buffer
>> > >> >  * @skb: socket buffer to add attribute to
>> > >> >  * @attrtype: attribute type
>> > >> >  * @value: numeric value
>> > >> >  */
>> > >> > static inline int nla_put_uint(struct sk_buff *skb, int attrtype, u64 value)
>> > >> > {
>> > >> >         u64 tmp64 = value;
>> > >> >         u32 tmp32 = value;
>> > >> > 
>> > >> >         if (tmp64 == tmp32)
>> > >> >                 return nla_put_u32(skb, attrtype, tmp32);
>> > >> >         return nla_put(skb, attrtype, sizeof(u64), &tmp64);
>> > >> > }
>> > >> > 
>> > >> > if I'm correct, it seems kernel always uses either u32 or u64.
>> > >> > 
>> > >> > Userspace assumes u8 and u16 are possible though:
>> > >> > 
>> > >> > +/**
>> > >> > + * mnl_attr_get_uint - returns 64-bit unsigned integer attribute.
>> > >> > + * \param attr pointer to netlink attribute
>> > >> > + *
>> > >> > + * This function returns the 64-bit value of the attribute payload.
>> > >> > + */
>> > >> > +EXPORT_SYMBOL uint64_t mnl_attr_get_uint(const struct nlattr *attr)
>> > >> > +{
>> > >> > +       switch (mnl_attr_get_payload_len(attr)) {
>> > >> > +       case sizeof(uint8_t):
>> > >> > +               return mnl_attr_get_u8(attr);
>> > >> > +       case sizeof(uint16_t):
>> > >> > +               return mnl_attr_get_u16(attr);
>> > >> > +       case sizeof(uint32_t):
>> > >> > +               return mnl_attr_get_u32(attr);
>> > >> > +       case sizeof(uint64_t):
>> > >> > +               return mnl_attr_get_u64(attr);
>> > >> > +       }
>> > >> > +
>> > >> > +       return -1ULL;
>> > >> > +}
>> > >> > 
>> > >> > Or this is an attempt to provide a helper that allows you fetch for
>> > >> > payload value of 2^3..2^6 bytes?
>> > >> 
>> > >> No preference here, FWIW. Looks like this patch does a different thing
>> > >> than the kernel. But maybe a broader "automatic" helper is useful for
>> > >> user space code.
>> > >
>> > > Not sure. @Danielle: could you clarify your intention?
>> > 
>> > This follows the iproute2 helper, where I was asked to support >32-bit
>> > fields purely as a service to the users, so that one helper can be used
>> > for any integral field.
>> 
>> Which helper are your referring to? Is it modeled after NLA_UINT?
>> 
>> I don't think this patch is fine. This also returns -1ULL so there is
>> no way to know if size is not correct or payload length is 64 bits
>> using UINT64_MAX?

That's no different from the other mnl_attr_get_uX() helpers that just
assume the user has passed in the right attribute type.

> I found it:
>
> static inline __u64 rta_getattr_uint(const struct rtattr *rta)

That's the one.

> This only has one user in the tree so far, right?

Well, two, but yeah, the u8 / u16 stuff is not currently used.

> include/libnetlink.h:static inline __u64 rta_getattr_uint(const struct rtattr *rta)
> ip/ipnexthop.c:                 nh_grp_stats->packets = rta_getattr_uint(rta);
> ip/ipnexthop.c:                 nh_grp_stats->packets_hw = rta_getattr_uint(rta);
>
> is this attribute for ipnexthop of NLA_UINT type?

Yeah, both NHA_GROUP_STATS_ENTRY_PACKETS and
NHA_GROUP_STATS_ENTRY_PACKETS_HW are NLA_UINT.
