Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2107.outbound.protection.outlook.com [40.107.15.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17AE61A2C05
	for <netfilter-devel@vger.kernel.org>; Wed,  8 May 2024 14:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.15.107
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715179009; cv=fail; b=lIs2w8Edm04sdpZLvWFI/AxQgZAXQPOI3FeqsnT2TqELnq4rQ0fqnjRwHazas1os5K0dx5tUDLep+biSeZbFacUe7yYVzxlx+IiJZf0TWVQWLMjwGPI+sl49Lw/wqRWoICd9iu9xbnfmG94F87o56ZX2/5BvsdBjxvgnpPkn94U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715179009; c=relaxed/simple;
	bh=BTbwbwhpdkdtTGWI7QJtT4iQP+uKKAVAT0K1PH4/4O4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=S1vrQoGHxhzXTn8aDoVmJZiTrBcdTWZVKN5psGRXRvIfdIqboKffMDcjhFUMGCWtv0bHxbmBS4XRqTmaBlPyduUgCVs8LFghOYhD0kJFVLZTjoVJ9EpAoIeccLK7uiuFpCcCc1AVZQAr2aV0mRtAyca81mMh1vjtEaoLEjJRwUo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de; spf=pass smtp.mailfrom=voleatech.de; dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b=MwcKY5bJ; arc=fail smtp.client-ip=40.107.15.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=voleatech.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="MwcKY5bJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ev+NREte/KmJmSmqw8L9MVYq5uqDENDmNbxAC1xHTTaAH2eKj/GXQf6yeZaGVIOAxBxG39MRRd1XkYLU/bGiGkZHnfffhccB8ApLdbBzRa48iuL1y6s9snsCulXr8xgC4H+nyCdebgRprS/KVjATbfJx2o19FTgHQs2a3xgMCywW2DKpAWvgqBTRMJbDLk3AdTWo9W9FMiGP5ETpBrE0g2W5xWdKjuRZAKL7PT1ZJa5/3FSaqBVF8uIbgVzg8wMU/54hgPpsnlMZISUglCrhZJ/1Eao9M/iV3QuGe1ay6tomGJTqzKqNPZMP7bgu8SYgFn0ZEuPZKKJwVOXrrt8duA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5LCBGTQLchRdMQY3EIqHqmgLtrJWuFAc/bS+ERww2k0=;
 b=Q2wU0U0e3Iiz95K0GtYdSa8rXcAlI/IS1AO6/K8naEkYgwz0kH/MthXm7l+tOHvAWnMNoUG01DSTX0hdZEYAmYWbWpFmDm6zXp0p3t60v6GBPXXPqt+RtYOpZiZOEWK/SHbAqIW5aee24gG+esuLRPP4/mywXwhuQMN2hBFAm52PI0Qq1XWRjI/sdSUpDoJxC9KAV1b1fkUpPby7W3+ASrVqWmAsSoandjFs2fD8WgVGA5KD85jOF8UvBzZwkEgZyOU+C4kwzqOrAuAoDvTI36/Ngq+j8RA735BlSMz08MKJWJcAzAtIyyfGmOzl35SL7xjA5Ja2Wr1RYAFU0/c8uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5LCBGTQLchRdMQY3EIqHqmgLtrJWuFAc/bS+ERww2k0=;
 b=MwcKY5bJ63c0jl/pneYmVviaBG52ue2l3G0lR5zF2FVqj8iXa2D12AGKIG6yw/ZM8C4CYfkG090Qo5sR4gnH7x/nfAFgbxQM+X4c55iERGfVlNUp3aN7ZO3hnKRgmUe6okytHc7SNN239+Alo/FQNwjmysXN506pU2Esri/okgg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from DBBPR05MB11225.eurprd05.prod.outlook.com (2603:10a6:10:538::14)
 by PAWPR05MB9941.eurprd05.prod.outlook.com (2603:10a6:102:339::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.45; Wed, 8 May
 2024 14:36:43 +0000
Received: from DBBPR05MB11225.eurprd05.prod.outlook.com
 ([fe80::eb7:22e6:e723:9086]) by DBBPR05MB11225.eurprd05.prod.outlook.com
 ([fe80::eb7:22e6:e723:9086%6]) with mapi id 15.20.7544.041; Wed, 8 May 2024
 14:36:43 +0000
Date: Wed, 8 May 2024 16:36:38 +0200
From: Sven Auhagen <sven.auhagen@voleatech.de>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: Could not process rule: Cannot allocate memory
Message-ID: <rbeisl7bkwboam42zvnrz55aw5vwj2svwby2oayjwkhbagaxjl@vbpf5pr2dllc>
References: <qfqcb3jgkeovcelauadxyxyg65ps32nndcdutwcjg55wpzywkr@vzgi3sh2izrw>
 <20240508140820.GB28190@breakpoint.cc>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240508140820.GB28190@breakpoint.cc>
X-ClientProxiedBy: FR2P281CA0083.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9b::7) To DBBPR05MB11225.eurprd05.prod.outlook.com
 (2603:10a6:10:538::14)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBPR05MB11225:EE_|PAWPR05MB9941:EE_
X-MS-Office365-Filtering-Correlation-Id: f8931052-ed46-4b17-a093-08dc6f6c47f4
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7uOdRTZcZ/JcHO3ZJd1ptjrdoLMwKmzJO3+Dzs88xd1mBkHcYWbLJ7DhdAg8?=
 =?us-ascii?Q?7Y6KA1/gABOGnHKVaZ/s0yySQ170jcsfjqCiVuEo4Tir3XqqgOAuPY8r1evO?=
 =?us-ascii?Q?q7HPMZQBdGSgBgQZ/bgIUWaTmKS5P8uO0D/KzdVXcvcYlYZU8arYBvP7BeTa?=
 =?us-ascii?Q?Uhdch9DSn4PzUR0ION2i8cJ1SmMaBHKGu/pKyly0+9wPADMyFKMNNvkXyrvq?=
 =?us-ascii?Q?++JCzR6obLXNjjlvgcS9ZTnp5lnvvwPeroX56oLU3Y1vpyy5pg2c1JakVZQF?=
 =?us-ascii?Q?32rz0VrQfTeFrqLbJcw9cJI7+dD6MK4vHDc0oicF93/3602HJnzk+7Q60jLH?=
 =?us-ascii?Q?nav7UqjD09Wu7/X9BRKJlVKJUEJxRPTRqkpPpLhhUlXxJLVgRNARICAuzvWb?=
 =?us-ascii?Q?DJiHOqEEmZ4P+rQ+l5AaI/3z5fLLhscu86OQ1/c9qDzFGSZMuQLeG9AtqbWW?=
 =?us-ascii?Q?SIpCmP+gV6qcDwkNp47Rd1Z2FpA9xBvr+2nXHKTfEQweGWGNdtR3swZLghoZ?=
 =?us-ascii?Q?Q9quivSmYYy1bU1ut5uEufv5xnqLIngRC8zbBeU/wQZeIdRvD3W+Nd109oxy?=
 =?us-ascii?Q?bVQumRNCcFoyiXjkcJk0LD9YpZLrW0ZXRLaIKT2TByORzFyT5Z7+9CJ9J3O+?=
 =?us-ascii?Q?WvPxGnalt9FHaGT3+wgy54rH5xpfoYjjRc8EnbqPS8/r0my5fRc0t8gg2Pa9?=
 =?us-ascii?Q?I0J6M/aG2l7JpnbqFBzf5XJOiVfjv7aNYCLBJa17lQmHEQPRscEoyxYR2OQK?=
 =?us-ascii?Q?erHOJ3mwxTi4vBiEg8X+pBwMuRrzdoyOGJrqNy23iFmqXRsbCfs+lyNDx10J?=
 =?us-ascii?Q?FXRZVDauAYaLl2d5Ppbd+rkuBB3PcumgFcPABv8veGaSjxPcl1wRjYK1Idyr?=
 =?us-ascii?Q?x7QQyw9ZJWmEgB0/Ge6EZHLiXLNthCPHXT2xKXGQh+PwsMedLTsYpEwIvqcJ?=
 =?us-ascii?Q?mbd2ru0kOyS6oa5WCxcOGPZu4Q1ipML6JIFgq93Q/f8lpOdntlzZ9Y3g3h5G?=
 =?us-ascii?Q?Nppy47I0Z5yBMMjW46EYsJO0Kr8zHNa/s9zefrvOLKNcbyy5NdjMHv1RoNo+?=
 =?us-ascii?Q?GeC0J5eLnmnEaZ5BseiOjecVQsZ4IrxiOPbMHvNzB1rR6LQCnqvouYomS6pX?=
 =?us-ascii?Q?JaQ+fsiEMGSdU8SseDqGANKw8vn4DsdbApO6X0y2umzo53KFaclPRMqvyGf1?=
 =?us-ascii?Q?j/iFs/pzFTlMQf9Vaz3EaB3lGazJQNVV3vzlFfkkFiBs7CGoyVn7mRgbjO9d?=
 =?us-ascii?Q?OTv3Z1bK/1r8C9HhanGkQ8C1I8GJGl8rNOPW5aavHQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBPR05MB11225.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?irYTqzTdHgH09W6ifDTk6L5Mn+ypS5mtzYkaFADJrbJVr7LwF+WBVeME8lSd?=
 =?us-ascii?Q?A995t9atiBVGal72wG7eQSHHgSCHmUlC79+ZppJcd3yHyn+CWEaRK7GHGXDD?=
 =?us-ascii?Q?meKnakOpH1n6SMk5WVXMcBK32yLOKgnv3fTWgIWJD5IE4y3ZzrEZkoCv8JGg?=
 =?us-ascii?Q?D8tFSetZJ8Xp1BBgMKrv58GpM7TTGlFRKDI5U4ssq1Trd6u/az1T+8dcEX17?=
 =?us-ascii?Q?1JsHBwUjbMi+VXClU421sUdxApSQoCmHvKD9qB05P0Vxv1YnRDLZj0o4RsNt?=
 =?us-ascii?Q?9TThn2q9bSGhyYim7V5lX09d2rP15fh+1XTK8XcFK2mXcups83qZW55zhsW/?=
 =?us-ascii?Q?b5mbHytFytjk4HYCk5szVa+ZLFfVNGBT6JeDRB7EHk+iV1eYRhHgxU6p9mTh?=
 =?us-ascii?Q?wZX7Vq00JOSI9oXtqF55N0Uxbvjvhzi1WHw3GC9CXZexxxtmuGztbbml2MJS?=
 =?us-ascii?Q?k21vLsmBDVWKRvqEbFxF/VmtmohiHu912Ld75oOvoibA6zH+LtTNsNTXdNnD?=
 =?us-ascii?Q?K8VjSyEI6c6l0ICBGos/cRVurunYU85C5K3gsiTRQzvp6lBP4E57GIGm50SA?=
 =?us-ascii?Q?mtm1PSpyPByiXZ072rGgjnxI9i0ulcIDK56Mqvg3ec9V3s4ZoOmAFsvNkOSp?=
 =?us-ascii?Q?jiXaegBsh+4V31tzdqFS2z9R8ne8tEGWBW4w1VxIwfTmiVqC/k7yPMbwKKBA?=
 =?us-ascii?Q?g8I2mnZNaMP29L2/Oc6uPp6y4YDbm362cklga4gWV1+R+cm+s9fA6N+OG1XB?=
 =?us-ascii?Q?nJVC97YPeyzSB3KsnrokV9ZWe2fqXpDH9MhFdIRrr18B/1XMxrQZK1gy3BsG?=
 =?us-ascii?Q?cw8Bxh+S9Tmgh4QKshAonVv91vn3a0i4LZ4IPbJdQaho3+5ia9z3JqV/jNsL?=
 =?us-ascii?Q?/Jll3iFHXvw7YxhEgMhM7hv/9QUL6r5RX/neYKq+pKhx5L5hqkMTUOlzqFiy?=
 =?us-ascii?Q?N6ULHLttlrWwP7iUzqZCXEVpuZ/pSfT/WUb4WHgBExWE/tzfCD4rtNvdOTvR?=
 =?us-ascii?Q?cEoaX9leLEVQeE7nmKZ1BvMgkjQ7sA+QqY/s6mWTf3/WqoUHrBHMHw0Yu+Ix?=
 =?us-ascii?Q?HBY1IzPJLXFf0Hjq8GMef9eYfuz+Cz5iTzgaja6kxKO8copriyIm93yW0QQ6?=
 =?us-ascii?Q?D1ZIqvfQ8xHrleJUL5BjEw5i3fb2oWyTP0lTumlkSYWbfLlNcrCM0LVcpGVm?=
 =?us-ascii?Q?Tj37bXcrpDnljvHEJ+/c/qOgLslSiYEVodmY1w/StN/j3leLVeSUHTcUFhwn?=
 =?us-ascii?Q?RaTRDZBDn7Yx5vDDddVXppayHoMXa/j+QVmMzn0sMI7y27ETLxbBkGwFv0qK?=
 =?us-ascii?Q?K/WZu3ssRIxfuAv42it67rROF56JeDWmS5KWQ3yS3nirV9qkVl+/nEv1dUeZ?=
 =?us-ascii?Q?A3+z91qHeu2IFO82oKkrNKEARko6sWK/Z7OUIOw6rjODwP3J5jQHrLg7BPRT?=
 =?us-ascii?Q?aGiIyKzeASZbmDsWBhu4ZTKQKTiQOYk/vJwtlvFTa9tGf9GTQ3IkHScNP5tw?=
 =?us-ascii?Q?By4sjsEFcOvy7IaRq+WNRlyjMLVdl/KqHIQIYW30KJC0kM9s7Q1stK8V/DQv?=
 =?us-ascii?Q?tUy04Cmy20dxIvUS2fS5ksrtwAEtysWxzDY1lBnTaP9BuU0OYEngahbgysed?=
 =?us-ascii?Q?IA=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: f8931052-ed46-4b17-a093-08dc6f6c47f4
X-MS-Exchange-CrossTenant-AuthSource: DBBPR05MB11225.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2024 14:36:43.4792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ry+aOkFSkYXl9MHKbse+PxIaZGXZuSV6O3k+WrNe3Lklo6MPTE6FdjVrA+Wom0LvTv6wGycp33QHTaPkPFCLsCNwUzBRvvsHwU68iYxgJ3U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR05MB9941

On Wed, May 08, 2024 at 04:08:20PM +0200, Florian Westphal wrote:
> Sven Auhagen <sven.auhagen@voleatech.de> wrote:
> > When the sets are larger I now always get an error:
> > ./main.nft:13:1-26: Error: Could not process rule: Cannot allocate memory
> > destroy table inet filter
> > ^^^^^^^^^^^^^^^^^^^^^^^^^^
> > along with the kernel message
> > percpu: allocation failed, size=16 align=8 atomic=1, atomic alloc failed, no space left
> 
> This specific pcpu allocation failure aside, I think we need to reduce
> memory waste with flush op.
> 
> Flushing a set with 1m elements will need >100Mbyte worth of memory for
> the delsetelem transactional log.
> 
> The ratio of preamble to set_elem isn't great, we need 88 bytes for the
> nft_trans struct and 24 bytes to store one set elem, i.e. 112 bytes per
> to-be-deleted element.
> 
> I'd say we should look into adding a del_setelem_many struct that stores
> e.g. up to 20 elem_priv pointers.  With such a ratio we could probably
> get memory waste down to ~20 Mbytes for 1m element sets.

You are right and also loading a large set like this takes a lot of
time as well besides the memory.

