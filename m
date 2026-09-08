Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazolkn19013079.outbound.protection.outlook.com [52.103.51.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9BE1DDFE;
	Tue,  8 Sep 2026 01:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.51.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788831486; cv=fail; b=O3c0sJ8WHMYxz4RAO9voLn0TypBFO3eaGVHTNapNFSn0HoACJ5JNpFG369NPTd3hRAK3bxZWmM22MZJi77c1tufx7kA0ExYc8YqqERoj7535umRHruEeObWo2JcDyTW0iB8dCho1lhStuyg+eW34V+Iu+S0kmzQ15DqzrvhRQhU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788831486; c=relaxed/simple;
	bh=6QJKe9jyw8i9tsChTvJKObboP9zW/5TBo8u2s9EC74M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QdLazN3KHAWyXDdsftNWAmtEh2oVIeVuWIMk9aZSgDOGg6y5KXiwTiY1ER+FLtWdMcOI4DEdV9AL+gRdKDjc+U5OBYufB9cAgODiN1l93CVbpAkgJ0jd7jXZtZclqYnX9GM6+e9H7QbB58KO3fzIgDznk3o5SIeqrl/ICL9ljKo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk; spf=pass smtp.mailfrom=hotmail.co.uk; dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b=vFNb1zo1; arc=fail smtp.client-ip=52.103.51.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b="vFNb1zo1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pSTjvYGDVdZezpkUpqonfd33S8cpNTk9e3rf6ayNRPLUcjWzwiK4gkRd/7EFw2QT099RzJ/xzShj0ovnnLzf6hrgf/POa6/+BaGvxCx29x+QiretWMhj9u0NiibfMqLBjPmpmKZa/hJ79yB2MoLeoVo86QJrwxU4sX281E1Z00OAfG9G2dDxFRmrj3cEM7cCvpuWN+Wlj22nXnfIDW0lKaF7ROv6ejTnwfbnAaS+48O5uiAjoyXJIHkpjMlH/FqjEDt8Sjx5dCzrAiEDuZe68P5dhqWlPmQor6Mh7YXx4a9urr6DFn8cPUFkCKsPFez5/U2EGnq1ey8jIvf00R9wBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6QJKe9jyw8i9tsChTvJKObboP9zW/5TBo8u2s9EC74M=;
 b=NvC3wyjnAO4XG7iOBHHyZmgoMu6eMbAK5tIDnf9DkPrYaHqcwTmddJzR2/4LxrEiP8jfnAXPOxAuQVP64pNsScSDbvyGVExPYKNnS8S0rH18VjeXQw5TRCEOPfto7XHr/935UVkxqv4GQcBShZSh6CgrGqG9Q2NqzXRPVvp9Sg7izLaXjr2fiP+O9szC1PqYENAEa8izI5ZwP7QHwWQjDVqggvt0B39OfEcaxTlWi/OPt0n8WqemLABqJab9p678g0KYLEu6s6Jych1At+bLCk5uI41y+ZY+2YiW+11L2FLAqmUoUnuJlAbsjHFANqVR9RNLqy0CzC3gB10JNBd16Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=HOTMAIL.CO.UK;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6QJKe9jyw8i9tsChTvJKObboP9zW/5TBo8u2s9EC74M=;
 b=vFNb1zo1QRdx8yT6ogphwdIhP7OnwxacTIzMpBz0yCete6lcwkNlMg8NlPhQqy6Jvi7BUeONdXLy52+Ett8YSANJ2URmuEvI0c0PQGt5p+oC9Q4MCxSqi/r0X47u0PcHU7qGDVFCwa+0i3j8Qvw5wRG7ReqrxoGXpuXcSXsu90BjsflYPNsRRTbXlYd+ZSoqbY9hn+Wm1S+sjIvLWLfEbesHSI00aksESweeZxTLoXWS37Ra++xc7GZUpC3WG9VHHCu8ooje1bkVugwsAKV4j7QkQzVppm9LHon9PamnThoPBlX53dU33eqI76eJDhM/IQ8aNeAExC49ymlkaQw1uQ==
Received: from PAXP251MB0010.EURP251.PROD.OUTLOOK.COM (2603:10a6:102:1d9::15)
 by DB9P251MB0737.EURP251.PROD.OUTLOOK.COM (2603:10a6:10:37c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 01:38:01 +0000
Received: from PAXP251MB0010.EURP251.PROD.OUTLOOK.COM
 ([fe80::fb91:30d8:e31d:1f35]) by PAXP251MB0010.EURP251.PROD.OUTLOOK.COM
 ([fe80::fb91:30d8:e31d:1f35%4]) with mapi id 15.21.0382.014; Tue, 8 Sep 2026
 01:38:01 +0000
From: Aamir Ahmed <elb12345@hotmail.co.uk>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Chenguang Zhao <chenguang.zhao@linux.dev>
Cc: Aamir Ahmed <elb12345@hotmail.co.uk>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] netfilter: conntrack_amanda: fix port value truncation
Date: Tue,  8 Sep 2026 02:37:58 +0100
Message-ID:
 <PAXP251MB0010361C898A0568700DAC21C8B12@PAXP251MB0010.EURP251.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.53.0.windows.1
In-Reply-To: <ap7oV1cftWpjsBiJ@chamomile>
References: <AS8P251MB0001CCFE2A0F40637E5A366CC8B32@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM> <214d51c6-a71b-4b93-8dd7-6bd1c02b4c3f@linux.dev> <ap7oV1cftWpjsBiJ@chamomile>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0177.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::20) To PAXP251MB0010.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:102:1d9::15)
X-Microsoft-Original-Message-ID:
 <20260908013758.115847-1-elb12345@hotmail.co.uk>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXP251MB0010:EE_|DB9P251MB0737:EE_
X-MS-Office365-Filtering-Correlation-Id: 769b900f-09bf-4ffe-289e-08df0d49d1ad
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|24021099003|55001999006|5072599009|15080799012|25010399006|51005399006|23021999003|25031999004|37011999003|19110799012|8060799015|2604032031799003|12121999013|440099028|3412199025|26104999009|40105399003|2607281247196008|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dYqI/cV4+75mN0GaRCREwz2ZTm/4D5YGoE8s0zqjWG7NIApAmF7ueWsAzgos?=
 =?us-ascii?Q?Mbz6wyCFMnMVN/SBkSTFV+HR9A8B8jZgvAGvHkhOx7CUDE6imNB7p7I5doIf?=
 =?us-ascii?Q?jyUISqTFfROxJCbCMlO1qAiznymU8q0kIlYcPwoXx4XveI2vFmZLWYp3qPYu?=
 =?us-ascii?Q?r3QFKl8xam3tzisHamYprh7EuajY00xZ5LJaUZup0fHMLdQohEYzvhNsWh1P?=
 =?us-ascii?Q?6eUHgnZUote7kxhw52cSPaQvKWWweHE88KV/LALBsd9BzlaylbUomRoxOiw8?=
 =?us-ascii?Q?zfCOCNaMYFVLKEfq1nCZfIyneWPxt1DGC2LoSht81pRvyhsh00UdiNYRHQcC?=
 =?us-ascii?Q?FC6inBeLHEWOoVgHiFCnBGgg4AxKfEewIa/zEEjTWJdXneLgzK26t+3YymYA?=
 =?us-ascii?Q?wxyWt/WifCA2TBES8nXu+271E4iYpZvje0sxI5TbBIX6fypyGcPdnF+8KiQt?=
 =?us-ascii?Q?EJzSDWBYCySIX6nOnC5/W4OIIXWppeSchtXOs6IwbsDPUWtVImBwLW6Cqztr?=
 =?us-ascii?Q?qt0X/dLBR32+SFhiTW6vw1JfL1YDy2vEXW8jCnErlmJIapfsJ2Lo7Wq4WVp1?=
 =?us-ascii?Q?lcapfOQT0ziP0GnYXeA1Fvc1C7HFJ1+p2a92mC89aBKW7YlZde4y0O1KyLQp?=
 =?us-ascii?Q?nHk1mu0Wp2xtdbdkno3MMYxGszDS7wS5J6z8MwtmIJc8ddFJw4YBgNj6x4J1?=
 =?us-ascii?Q?1NnoeCrRIVBB81u0X3YL9L0HaAB+1NcWVZwAvRnyla9zzjluF8r3CeyDx8y6?=
 =?us-ascii?Q?XVCpoiw1woU0ca7Q87LjqA6fuL1SCA5VtTPyYVwsVxCkX35D2hLovPPrElX0?=
 =?us-ascii?Q?e9BxGTPqSZaJ7wMM+igvr9sWM5ta1fCtNbwRwrb4L8XugVbjvSkEmqSypN2l?=
 =?us-ascii?Q?jwrcRZdrWbUDTcq96JlOLQrBgE5E11Z/Mx++m3Uxanos2VTQiPh3ux4DyEwi?=
 =?us-ascii?Q?yyIX71s4cOIncHWK2Q0G9GJCvfG32raPXplH9H0UBK9I1CANWzEjg7e7BXTf?=
 =?us-ascii?Q?QVKatxQPJFQJ5C6tKh+uGAyUULvLfa0o9JHXCDB9b8HpqyAmlmF7iYHWcCv+?=
 =?us-ascii?Q?3euKDD6x8+n2v/GdEhwGk9Mi3Lbesf7UBoHBfwalQvDKUcmPbit5XEKH9TDo?=
 =?us-ascii?Q?XWtu1X69LpgtwEN/YcUXSM6CqVFHCIGfyw=3D=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IhG8AGjOEEerGSDq87vERBy81HRUXrmBjfHv14BLqLuggXKcvsy8/3Y20pWi?=
 =?us-ascii?Q?KsT+huHdVI4SE3dPaRsKU7bGsO8Kb7CIawG3ZU3A2vSjT8hjZQO4fjJ+SNy4?=
 =?us-ascii?Q?4eX93QDr+84GOUckeGL7ypNgUEhKs7DvL9rXlNs0Ith9bleSUYq81CbfRg4y?=
 =?us-ascii?Q?9lm0PGs9qQbzSNq4hUyLqsO/LLu8kG4+bymtoegwsjIU1t0FeZqg1dpTP4EL?=
 =?us-ascii?Q?C6lh+OqkTO8LWFZw0llse/z3UykTjzLlFVG8YEIV630UmeJOOr+G3wDPOY1I?=
 =?us-ascii?Q?0cA92RjZwuyP0UTSD/YYPE+6CRbIdSHy98ijMc/FRWduZRYGBJaUVXd+EfQb?=
 =?us-ascii?Q?cpx3CzplEVZD68HplMfKjqG8uP3/BqzJ2o9xXVy/WU3haHSs4X7H/RRvr+J1?=
 =?us-ascii?Q?agf4g6XulfQPkfKALm5zuGFkKuXTm95fRvRY/e75lPPsJIGw4PvjXmRZXFM2?=
 =?us-ascii?Q?mQnXKL7RzyIBN4ahComBTxCFwHjUfImJlxUyLiEL6f6Fv7HaBg8mWHLDPGVL?=
 =?us-ascii?Q?VJn57tUF3+gnTWC7t8nteEvtXrp8+LS2YHBRUs1DvhNFGOa82oNI/c0kTkBa?=
 =?us-ascii?Q?MPliH8364lZl0myeWSQZ8JnB3d8jaKiCvGObrn+eZR8iARaUv9PXELipRELW?=
 =?us-ascii?Q?2fpKaS9Tv8zZ7/oBtXqQF7vBjBclIDbm9iVaUSXassAQZHbHq7jZi6FB//f1?=
 =?us-ascii?Q?kITDpyDZhm42n3Zon+SaJRxSEIwJr3XtbJ9C/FZFgMh4x0HbVkZ4goNxVLQs?=
 =?us-ascii?Q?5JCg+2t7OqWFxC0MCdejWHWlONLlZxEJOfvG++XoQeLJLlTv1Zx0nQWKwKuQ?=
 =?us-ascii?Q?afS9oJIn/Z8MV7aNnxz8RQ0M22R6vBm0Xvb7K9OfyeHMsJ9RzktBrrAgkWqj?=
 =?us-ascii?Q?IxaOCwh9a8P5xo+ie2Is3YyQsPi10Y6wb8KJoAmDzMJGY959rySscs+bVu9F?=
 =?us-ascii?Q?CGp7G42XBp1JVLB89iIGiYdMT/RjHpoNFoo4/GdfR1Y2zCp2c/FpFIEixKsq?=
 =?us-ascii?Q?u6o702LrU/10ol/grZGEVuOuLFsDo1LDKOifiOgJ6BxXc0TLq6neMYa77g6l?=
 =?us-ascii?Q?M2knIstup11/OSUQjW29hMc81f/l3qkKoG84TtHIMe7j2nL6O57vZrYKKCTW?=
 =?us-ascii?Q?e28WAilY103SD3IV6A/93sorZt8Rcf9NR72m6ihkBD24dt7VKTtkMbPVI6z6?=
 =?us-ascii?Q?xQfCCsEsbdEM4rtZBnUJWtwgPKtrDBv3QkwhrSrN0JLicE/MasEnly4+LfXM?=
 =?us-ascii?Q?e+lxzGWkE5lbR+nO8BYj4+fiaD8pvImQ4GGF2eHn+4wU8fRBpw4pA95Vd0ng?=
 =?us-ascii?Q?6sBGNCgAd6BN/59C0zhdW48Z6su/FyYb6wdepjXJrrStjciu6Ru3H0LzjNzP?=
 =?us-ascii?Q?sUIFb+SSVEffQnDEiypCdA+WVrhwq8eey6ZN+/U7UQGUrZdZpNai2pxxg9Tt?=
 =?us-ascii?Q?yUKPOxqkf4c5Ds7srognG2aA98/IqdkO?=
X-OriginatorOrg: sct-15-20-9412-3-msonline-outlook-fe3f5.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 769b900f-09bf-4ffe-289e-08df0d49d1ad
X-MS-Exchange-CrossTenant-AuthSource: PAXP251MB0010.EURP251.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 01:38:01.4562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9P251MB0737

On Mon, Sep 07, 2026 at 02:56:13PM +0800, Chenguang Zhao wrote:
> len = min_t(unsigned int, sizeof(pbuf) - 1, stop - off) already
> limits the length so that it cannot be greater than 5. Could the
> len > 5 check here be dropped?

Yes, that is correct actually - will drop it in v2. I will carry your
Reviewed-by on v2 if that is OK with the change.

On Mon, Sep 07, 2026 at 06:37:43PM +0200, Pablo Neira Ayuso wrote:
> Please, specify target tree. This must go to nf-next.

Will resend as [PATCH nf-next v2], without the stable Cc.

Kind Regards

Aamir A.
