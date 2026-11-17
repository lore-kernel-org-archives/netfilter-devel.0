Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.19
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794931990;
	b=358J7B7jprR5F8fXeeeyfQcqH11LW7XbvHJ4aUtor9DXS/L979dsdOTejPIbNtx7W1Nw
	 ksNt3WF1AdFCk5gHHuF7unmUw6xEnJhv7bcd4CbTFO/8qb/quUkNd0quCHf3UM/Qz+sWZ
	 /MI4EfLB7wP8NxLA4mVL9cwydsQ/Y0Bme3NlRWSbkYuTSYD4ndKNMzANpQw3YNj9+LNFO
	 2iAhK98r9Uuj3OHrMJo0QqsR42ZzO0T5oJTbwGS6ytQ516C8uNTYTBZ/iNcojy2IC4NPN
	 W0u76QT481HoJe9Au9WVsfCwD/Lr5PFDgoWeOaQFhvHkTy86fHEjl0VM89X9odh7RNg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794931990;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=Ip4kHiwEptNEn1s/Uh0GInETpDrMH/A2C/6rU3lAchk=;
	b=MHLb/AgLRB/aIG4re5jTUX/3/AmtdzW5OMJCHbcGnfrxd5OOvapGVINLBQpWJCifCZ5E
	 WP4dzjwC82XmFG3NjwgjD0BGFeeePSK6y5NZS+GKWHNAt/pifWioZhwum/vadzGrcfIeJ
	 3jVFO/rtM3p3YUSdbikSlJKdsWdXlQ+wiawWgv9VeS4T9qOtlx83ontnCth2j490fwutu
	 wK80nsWoQqLrsgdfVR+jvdMVPfKvPWKQd+8H+OCVwwGHoyTaFYN59XAkxc2Z3tisFhULG
	 LB6Oftq+W7ckBdyr78FrweKkfq7hqPUbUPbp8elcTmQaE7YVevu0FOVlco2VmbFgp4A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=awSMrNoK;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.19
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010019.outbound.protection.outlook.com [52.101.201.19])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F7D606A31C;
	Tue, 17 Nov 2026 16:13:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 38F7D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=awSMrNoK
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jdWCdmviTtlFvGwTheIZStGS6zeMLO8QU1lAlhvyGQgpIv+l/KqOWRXNPDI2pj1fZGmjLpFAlCSDKBd+MZ58WojUc4WaYdSjXtuPaz3UCwBZPfT8L71BIKtypl0M/dBz9VNOHl3N960vt37OjFZAB0NaI4/jYUf7mdkOGKSx0TkR/trd3L/OeCNRHJgV/FNEF0HRtz9Mk3wrjxg8sZ13UFzV7vq9JmKIop0vjcYuh90fDjEQxv6VqsrD335b8SiZdEK8q8VbR9nojS52poGBHtvJU/BsQYRKSN5PaxbSLqLovBH4NH7VW7Qpx/Lk+MgOclLsSjDL2e1Jq3gibY8IHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ip4kHiwEptNEn1s/Uh0GInETpDrMH/A2C/6rU3lAchk=;
 b=IvpaB4LkVlP+YGYUsaOWywJ8jtJk6bHMhYOjcduHyCvmGBeDtVsjEPI/JF6TiEoBopwzZ0Bt0v7Jz5Jp834WfARYNZ8g7h6JLzqc9O64Xx5DCZ4QDaRMCmnYi+W203g8m370PB2MtOnjBxTeROc8ieVSVxWe2xQThnkzWmBd5lyzxpCST9rwfR52zmYxLc+YDQL8EvJ/ini0UAO8L/VoHBTQCkxbLJpjK8a2Vqkz/tDcX5q7OVE9pF5OuAg6Gh+fks8xkpg0kkHDSVzQ4bdf3EXgdR+ELtxppPL9MKPhAIIvh9hybzVtVKO0rAKozKlUs7nBO4N2qoyEQ4j5PZilyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ip4kHiwEptNEn1s/Uh0GInETpDrMH/A2C/6rU3lAchk=;
 b=awSMrNoKzVKmF9mqlRqJJyPBnnQNeevqB93+MKHmq41k/B2RL2ybc20SzesH1tRYAO7N3G6yiAi0DmBgq04HDdIhnU0NYGskGJxS4qHBFTiC2z9yf8jGV+3tF2nzJ6G6nMMATmse+xJDvl5ejKu5k4Ameg1Kmr5oUVTd37HiaCyXqbzG0IstUiCcWvs409xVJhVr73AAdiv7G5/KFpcvouQ98SOgA+C3Hn36U3mJW0GceB7DMA8gwYw6yhQWzrrUXL/ft0pPZZ5TBa1mjoaPs+YxmoJ25oUBX4KFzDLz56WAQXg1bQnIFhzbHhxN6njzS59MzcXoYd330PVcTBG2pA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9407.namprd12.prod.outlook.com (2603:10b6:408:1f9::13)
 by MW6PR12MB8957.namprd12.prod.outlook.com (2603:10b6:303:23a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 16:13:04 +0000
Received: from LV8PR12MB9407.namprd12.prod.outlook.com
 ([fe80::208b:424e:47e9:8a96]) by LV8PR12MB9407.namprd12.prod.outlook.com
 ([fe80::208b:424e:47e9:8a96%4]) with mapi id 15.21.0615.009; Tue, 17 Nov 2026
 16:13:04 +0000
Date: Tue, 17 Nov 2026 18:12:55 +0200
From: Ido Schimmel <idosch@nvidia.com>
To: Leonard Lausen <leonard@lausen.nl>
Cc: netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	Shuah Khan <shuah@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v4 1/2] ipv6: Honor suppress_prefixlength in
 fib6_lookup()
Message-ID: <20261117161255.GA878128@shredder>
References: <20261117110813.9894-2-leonard@lausen.nl>
 <20261117110813.9894-3-leonard@lausen.nl>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117110813.9894-3-leonard@lausen.nl>
X-ClientProxiedBy: TL0P290CA0009.ISRP290.PROD.OUTLOOK.COM (2603:1096:950:5::6)
 To LV8PR12MB9407.namprd12.prod.outlook.com (2603:10b6:408:1f9::13)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9407:EE_|MW6PR12MB8957:EE_
X-MS-Office365-Filtering-Correlation-Id: 4dc311ab-be3b-4545-1b94-08df44c5a8c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|22082099003|18002099003|6133799003|261009223027099003|3023799007|4143699003|5023799004|11063799006|56012099006|261028144727099003|261102123227099003|261022105027099003|261026140227099003|261022075727099003|261026121527099003|261021121427099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	7Gzu5/7lx+OXySkjd6yM74mgeggZ0wxIf5P+HcwVmfP2i/YOzX+ZU2OWrW+RFlzAWBUusuX1dXElYE8Gx78gW1TqLYDgQGjFchNQ3n5h/qCzfgeZH48LmtwUtLx5tj1ypFDtTsjWLsLSaKsOXoU0SPr+7RFzBVKoln8MWMPhvavzz0MHSusC5yEjyyH5EDLX5NUpjf1eluzln7CWZ7CEwhkyUhXwed5es3OlBeIdKjHgxONiUraqjZ5iYJ9fSjtwV10M7+s/A5OymnEvkB3CGF7up3sQ8WUvBYcL+MwBMLttd+K46aN6K88w3sV5cPcnyKW+owIufQh74cwbZ1kIvQ/Ir+vvbjSPkMrEfq8OotdpLaKIwMujRc6JrN/bCZ5PyYpLIMaBvv3QZcc6yqVHq6DunWt1ynLQiGtCrpviidS8x8ZTk7stp9R+weqie64WqRyb5yATgK1T0nlZF6F3Fi34Q8Dx+jfhw9+bkdPIlvfSrUTT+l4PhqECYXfhMdbFPAO1WZb6NZ2bb/sNhqKMOMPxcCrPXfB5oXv5VQMHNbahDDIxAxUH+2JD/23ThcpfVHq6rlGEvtBhZWKoKCn8n/nO4rNPv1T4+5Qt0EIXkMPKn4ypeKSHDMjkfCGCbVwBm7dtAFaBjNzidcwSGsRSxBG8Id9CrNHgDyCTs0mL7EA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9407.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(22082099003)(18002099003)(6133799003)(261009223027099003)(3023799007)(4143699003)(5023799004)(11063799006)(56012099006)(261028144727099003)(261102123227099003)(261022105027099003)(261026140227099003)(261022075727099003)(261026121527099003)(261021121427099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XL/HUDTgRJb6oWx22/nA3MWx+aSwqHAhaW9224IhsgNSWJHUYTOYm+j5k0JR?=
 =?us-ascii?Q?w8RVxOUI4IFTKk+lDdpu6DTuAVXgE3CcJqjMkj3iWN81JvZ45FPeVS6tONDQ?=
 =?us-ascii?Q?fGFiTtWYWH/XTq4CI12/kNV3Rf5LbibAwAghC2VZoH751HCAYOX068ppjRz3?=
 =?us-ascii?Q?eSpsBWpROnpKFH0YHlZwvbhiGFrDyry4GsOdStS05WWKD4GOXMvwDjsSLoTF?=
 =?us-ascii?Q?61GC1SXZUkNcNNmkeZth7inHgRKZo6KyeNFHSKcr8JdgUz+aWDQulTpQAdfe?=
 =?us-ascii?Q?vwTyeAP7xeS3swbgcyKuhIyuZSU/tw4FfrivxgWa83/ahZwsIzJ+427KqEYQ?=
 =?us-ascii?Q?nlS2/rp1jHpHZ1+zGJlkQms37BYJ847XhJ+aRAb/eDJw0xj0mEALKbP9Re3t?=
 =?us-ascii?Q?YmBTkkxSuw+cCjBxrwyN2g3IJ1tlz19rZ1/Ag3mVejbuF7mkIv4VEyWmDf2c?=
 =?us-ascii?Q?8hH68NK1JSEHNGvLj7nrFL9BHDeuZAWReuPzdO9X9Wkkcu4Qmxi0EtkPtoJa?=
 =?us-ascii?Q?WRUc+FSkeb6ZmLNbL5d41sE/swPfE04q2qZfZB9JFb0tD81/zCZc4FGctIZC?=
 =?us-ascii?Q?V6hSJt7foBgWNdGmjTFD/siQTcgykmrpoxreTH5CwETHWfiknMkfT7t3AP1z?=
 =?us-ascii?Q?xGeOPZo+p/vIYMVNjxywT3Vdd11JeuHYpCmuCQKWmiCEA8DBWikoIj/k6YmU?=
 =?us-ascii?Q?rdPUSAB6XzCtvv09hgWObF6+y7ClgXkFMJup/JdCEK3gNgacaFOmkrnull1i?=
 =?us-ascii?Q?Zuk6OC8yjOLr/2g0sLXXFCvgo5OGVVZUK5MPHF7/rJgrXZ4mADZIQub4CB1N?=
 =?us-ascii?Q?FfRgMz2BWYTjs+Kv2E3JNwWc2i3cJPegOszXzIOvXy1eXdcjrJF6aSVcWUqU?=
 =?us-ascii?Q?gCsNXWLprqql7dQmWBaNm0E16ZDYYbCBUbis6dUqhkVlP8Z+F/Ax723Ap0ha?=
 =?us-ascii?Q?H4KOGJdrIa2HSC1dOoRr0mt4bptJy/tSDeXFU7gVYFSOq3Rus8HRe1S7V0ZV?=
 =?us-ascii?Q?0SaXxvSMPm9i2LUoor+a5LYlfLPHqxuQvRGrhekADzjO5DeM4lF0pfVX4gYq?=
 =?us-ascii?Q?DDqWHuWv1Fz9/w/gyw8I+SRBjnlCtQOH+pE1d/Bbfxp0ijTAOwySRIWyfv1Q?=
 =?us-ascii?Q?wi0kvzWFhnCfTpRJu6JWfwiq7I2TT40BFxktASWyH967fxU7QxOYVANCXkAy?=
 =?us-ascii?Q?O1r61UlJ7cIFzMGk2YTy5dSI937S4VnzIqqibEG2rbkmnz8TgEOkjZvy11CP?=
 =?us-ascii?Q?BGFAFRlBdMM6boAQA0T1YN+ISd3qUKebNfAyg/uapIv5mg6xi+miHJmlp53Y?=
 =?us-ascii?Q?NtUsbQJM+ff/UgT4QyrDCoQ2lmdsuyAhYvox+Yel1uHJ+2UD+sacOO7ihqdC?=
 =?us-ascii?Q?FkrFviYzX6JCBYgbxvPpEqPQn7iq/zrWzx0uZJD9FPquX4kiBZfH45tCBaDe?=
 =?us-ascii?Q?WUjqZh6BGBJx9IVN6uiyP8ZSp9E3FM4ZrxKpK8EdMDsGdEztneq94IGIkCod?=
 =?us-ascii?Q?1GZIEeTMAdV9xyHlqVV8C956fJ+El9APPxqSTmc9/o4yjrBHBNXEs7SmV8Xz?=
 =?us-ascii?Q?EtoXFmNeu08Hbs/JppAS5T2N4g85lkT6n95tu3agOkqDXv/QsYleIAxl+HM4?=
 =?us-ascii?Q?Tf9UElzZy9EEnqJ2wgroIHulaS+ylQe2/9jxkOW6hu+6HAsRNnR7P0hdl8V2?=
 =?us-ascii?Q?i4mp5+c4IxQD8d6OFtdhCRZqGA0+UYKONM/XmlNpcWBg6RJC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dc311ab-be3b-4545-1b94-08df44c5a8c1
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9407.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 16:13:04.3478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oy2Od1tCWKexq1K/qLGULoVKuIO3uQTSjDseJmKbBKDexXAPovQFn4fZjwdBxDQ/AQB6F7V6fXhCm+ZydmPvkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8957

On Tue, Nov 17, 2026 at 11:08:11AM +0000, Leonard Lausen wrote:
> When custom FIB rules are configured, fib6_lookup() performs the lookup
> via fib6_rule_action_alt() which calls fib6_table_lookup() and only
> populates the f6i, nh, fib6_flags and fib6_type fields of the FIB
> result. However, fib6_rule_suppress() only examines the rt6 field, which
> is only populated when the lookup is performed via one of the callers of
> fib6_rule_lookup() such as ip6_route_output(). As a result,
> fib6_lookup() ignores suppress_prefixlength.
> 
> This was not a problem for nftables until commit 1c32b24c234b
> ("netfilter: nft_fib_ipv6: switch to fib6_lookup") switched the FIB
> expression from ip6_route_lookup() / nf_ip6_route() to fib6_lookup().
> Since then, with a rule that suppresses the default route in the main
> table before looking up a VPN table (as commonly configured for
> WireGuard), the FIB expression returns the suppressed default route
> instead of the VPN route. Strict reverse path filtering then drops
> replies received over the VPN.
> 
> Fix by evaluating suppress_prefixlength against the prefix length of
> the FIB entry when the lookup is performed via fib6_lookup().
> 
> fib_rules_lookup() only invokes the suppress callback when the rule
> action returns 0. Unlike __fib6_rule_action(), fib6_rule_action_alt()
> returns 0 for reject routes and instead sets RTF_REJECT in the result.
> Do not suppress such routes so that they continue to terminate the
> lookup, as with ip6_route_output() and IPv4. Check the flags in the
> result rather than in the FIB entry so that blackhole nexthop objects
> are also covered.
> 
> suppress_ifgroup is not handled since fib6_table_lookup() does not
> perform multipath selection and the nexthop it returns might not be the
> one that is eventually used.

Simply deriving the 'ifgroup' from the first nexthop device would be
consistent with IPv4 and it only matters if someone is not putting all
the nexthop devices of a route in the same 'ifgroup', which would be
weird. I suspect 'suppress_ifgroup' is hardly used.

Anyway, this can be deferred to net-next.

> 
> Observed during WireGuard use and reproduced on unmodified v7.4-rc2,
> without instrumentation or error injection. Verified with namespace
> probes and nft_fib.sh on the rebuilt v7.4-rc2-based kernel.
> 
> Fixes: 1c32b24c234b ("netfilter: nft_fib_ipv6: switch to fib6_lookup")
> Link: https://github.com/firewalld/firewalld/issues/1600
> Signed-off-by: Leonard Lausen <leonard@lausen.nl>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
