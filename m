Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazolkn19013080.outbound.protection.outlook.com [52.103.46.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6285E3C9EE0;
	Wed,  9 Sep 2026 23:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.46.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788996809; cv=fail; b=lYb8Uff9fkdvAfgwXTzwmBhmkpmQ+kZSD5o42HFCPZiFazT48E9id/EyRLDj/ZDwKfnlXsxPtsUW7syf1E7TnFadxOi/9vW95yGOoTEVF/Vv1vbMrOM8nOT4CyrDEp5uL+4tmhvnsNvM5bUT6Ue/TNz8o3A10BHPBGb/VQow9+I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788996809; c=relaxed/simple;
	bh=HuxJ71BZFweIQrNaHOi/Yn9is4495BpWGf0YwccHk1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=t2Yyzg5tLyat/jBaAqCnG+1AYnrQFjIUBdHH/IkyObALqSAZ9QUSk55h58Or2Me01+DYM0IS6izNRTN8jr2jBXrNEsrUehPZL5RlN6CPLHXW+wn5cHDpmuGoKIzLqldg6Gq/tMJTV40PGtV5kQ9jBkj8e2tD0BUjan3wJoTlQvg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk; spf=pass smtp.mailfrom=hotmail.co.uk; dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b=p3jMdBr3; arc=fail smtp.client-ip=52.103.46.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b="p3jMdBr3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qRX0ceE77VKfmACvCq70qj2KJ0q+wfUfQq7sxRVy/sSpj44SGtPHRJB5KWGIGmd6pX4ib+cMmZpP6zIGPxP42rPv/ZUyMucY960wWnR5fFtNB7g49yxAjcT0Yeelm/bxPfNl8oIJUOhsmCqOtjwpBqlfHVfUoIMCdmy1nqB2F2LP+5T7GTJJJU4yaYADYqxo30t9sFVEOWHdeDA4Ly3dJOXMgZr6IDISOm3n5qk+zDYjKi1PfG6KdqP2gJL0cTv9QcmHRZlcu8JgmkFhxH2ZwJNl1u19GIkzWqRvFCWIXi/M5WYvZQMfGIUerIodiFDen4XzUI/XGswb0WaxLY18AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Oecaw1qpU3L/f6wek2CmCfL5W1kSOjNFRy9kHePDGEM=;
 b=bH+iAIqn0EYMFQK+34newgxvi3/wEAaJ3vgSC6MYwBhJiKAXNX6hMMIdaNqfNXG3bGgLLMEU07uCPqz6RVZNNKoTVnUvCqtfcF9wa5Ia45axTzQcqFNA+/5qdgMzuSH3B1Z7G4KDqc28nwfKUN6GOi8fHFWoelCf9M+Z7iQEEE3JmhtGKtrOfYKliTn2eEpcfpxEyp7iWUr9uUmKe7J6wXaBqH6UgkE9Es/ZhburxI20EeRuk7t+yy40JXmjYHkedDsdhMoxsTHXC6AgDDlczjaFuWLdgSTXnLdBij+C2JlR6AHYIC4TIH1m0ydWvI7yDqQ9WDfCimMF+4d9gepOtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=HOTMAIL.CO.UK;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oecaw1qpU3L/f6wek2CmCfL5W1kSOjNFRy9kHePDGEM=;
 b=p3jMdBr3DjJyv1TqPVHUpqPdc09BumygnZgbZtfGb66uQ7qEOR3fzrlDRSOyKEbW7BO1wGDrgjdO7BjoKgzf6+xM7qViM8Q9O1UhL6OzEkqfb/9raCNH83cVIXV9WgtvRDUX7Yx1u3u7JHs4txaku0qaoFhgvQFzzPd8Z5ZjkUtoz6jssSFxb69hMhV/biTDwCmeGWy9invKYAifubhiB+XeA8iMrb5RvBFrkVtnXiAKUyYEB2fYVCx0Q9G10U2ptMOheiph2LECMZyYQbGQEscx2b71cx0x5dPmgO7RwWabGgflmrWzCJqTmzrYQpsfXj5gqmbvqrlppxiLkdR/bw==
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:344::22)
 by GV2PPF550781929.EURP251.PROD.OUTLOOK.COM (2603:10a6:158:401::b57) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Wed, 9 Sep 2026
 23:33:25 +0000
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352]) by AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352%3]) with mapi id 15.21.0406.007; Wed, 9 Sep 2026
 23:33:24 +0000
From: Aamir Ahmed <elb12345@hotmail.co.uk>
To: netdev-bot+sashiko@kernel.org
Cc: Aamir Ahmed <elb12345@hotmail.co.uk>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kuba@kernel.org,
	rc@rexion.ai
Subject: Re: [PATCH] netfilter: conntrack_irc: fix port value truncation in parse_dcc()
Date: Thu, 10 Sep 2026 00:33:19 +0100
Message-ID:
 <AS8P251MB00019366FF628C891D894A21C8B02@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.53.0.windows.1
In-Reply-To: <178899001368.219967.734841882054887472@kernel.org>
References: <AS8P251MB0001B81958B28F762352EF3DC8B32@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM> <178899001368.219967.734841882054887472@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P123CA0077.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:138::10) To AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:344::22)
X-Microsoft-Original-Message-ID:
 <20260909233319.31116-1-elb12345@hotmail.co.uk>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P251MB0001:EE_|GV2PPF550781929:EE_
X-MS-Office365-Filtering-Correlation-Id: 01001a42-d6cd-424d-302c-08df0ecabe10
X-MS-Exchange-SLBlob-MailProps:
	qdrM8TqeFBvhuFgLLe5qs4jWk9CHdv0AsDwKPsYsIIKZHAfh3dywNIJvi6oTafez1ixbB3nMJy4cnfslv5NeIfNuAnMyTUXYXM77d8z4luKPuK755FUvYatSN6Dc/tAGQbUbOaIlrmjQsaRIk20j/5n0jppSVa9wyqJv4sFsWwsbStMSZYMzqPbkwz80GznK/tnFlFz7J1MRPj+APyCZvhrnwlBskCCpJWHXQoJ68CzWDEOm+WIMx54Z0l9dFgIS0/Kr5YQKWQ4YXjKIYTa1Mdqcvt07MRJP7n+RVyAyN3O2TXJihAYNiezfPJpHgaDussCCf8FQhCQifU4jAwkam+VXY9ZdNz/NxacEc38MfKH59Dv1dwmDSJX+SoggUCCQFsK6hcEk7mzz8BlGgVxFRicDm/dvVdT4lLNyhUZTCO2y+osaQcsPWRtjMiSEhLknTz4CXT0wtq/SIQdqZz2xX7aq5rkor2ngDN9mhcq3QYwb0G60quFiCo4h6QmwYhT+BjBgOWYmqi7j41NamLWd6rY52UUN99n0GK7+u9nZmaTLfS3/si/165SxuNsJkrSA7cMNL0GRJPPjUM38SFomHQ5IjbJ4rRMWKxZPeXQbD2WVGQDEHu/qjoRPZynzTwqiyu4QD8ySGHKmiMs7XF1JGB6jWUA8sB6UenN7uI0WdCj7iQ7kP9faufXQPOw3Iw/Q1jtU1Qa6mXKfBBUuefPXReMwkzpoPRjFHMkeWthSIFdAhK77ZYEb0fp0KL82B6+SIDj+X1gyhc1/0oG3kR29qMJqXpt37U0d
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|51005399006|23021999003|15080799012|8060799015|12121999013|37011999003|19110799012|25031999004|25010399006|55001999006|5072599009|6090799003|24021099003|40105399003|1602099012|10035399007|2607281247196008|4302099013|26104999009|3412199025|440099028|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UWIxTE4rK2c4L21YQTN2c3p6NzhLRFZNQUFOL0I1K0VmdjFCQm9CRWlTM3ZI?=
 =?utf-8?B?d3JZbXpqdEVDd0RYM21lY2NoSWF2dEhrM1ZFODBCSmFLSEh3QWoyTm9TaFUr?=
 =?utf-8?B?L0JqV0craExzWHBCbzRQcWU2WUZTU29UWnFINVhkL2NxcXpUSkM3YklrTlht?=
 =?utf-8?B?ZEdaLy91NEhpcFQrTUEwUWY2TUc1TVRTMHZQK1ljNnBlTC9wN2ZUTVNrdHI2?=
 =?utf-8?B?THFBWnh2NWZTVGhUVlVZVDVHRE0zNXVYWkdXa0dGemNZWVhKdkdNVEpkNm1N?=
 =?utf-8?B?dUNYSHNYNTVWQVlWQ3I5QWd6L25PVk1RZjNXc25LM1o5VDBJVk9sdGVMTFFm?=
 =?utf-8?B?VlpNbFJaSElyd3RmcStuQVFlOHVpS0J2NVYvUlQ3MklSMXorcUpFVTVVaDlG?=
 =?utf-8?B?NERhYlpDN0xPLzBOYlVlbUFhNHRqSGNkczkvSGVuc1Nud1M3S3B0MzlMcnlJ?=
 =?utf-8?B?RWtzbS9jR1pUV0RyM2E0eUdXWmc4RkRYdE5FMDhwalFPWXhkQ25QMVE4MTVN?=
 =?utf-8?B?MUZkZVdwNHZHa1hnWlRHQTBMSkI2K3k5UEVOQmVxcVJxN0oyVVdrUEllU3RX?=
 =?utf-8?B?VFRsVXpEb3VwR1hncTBGcmpVeU1WeThWU1hYL1dpaHR1eGFHMm5tQlNEQWdH?=
 =?utf-8?B?MkVRSEp6dGRvNFZIOGxWWVFWRUFJeTZ0ZDRpVVlkMUhnZHBKQmlWNXZGY0ht?=
 =?utf-8?B?UHFSbG0wV0FNQ1hmWkRaRW05MnJhcmpEZHR4eDlHWFh4WDREbmliREl4QWNk?=
 =?utf-8?B?OERGWWpWNjhGNWpuVldpaklGNTBSTUEyRlJ3QVF4WWFTWmdnOVZkd254OVA2?=
 =?utf-8?B?cm83ZG9MWm5MckgxZXRzWG0zMnBWSWZCREpuWHEvbmQ3bEh2a0pIZzBWNE1p?=
 =?utf-8?B?OUdMTXIrMU1FaG5ubXpSNHlIcWcrSXNvdnBtakRmZU51RDV1U3ZBTnpIbFVL?=
 =?utf-8?B?UmxFM1dYTi9pdEQ4a2FMRUNLSkJ2alVlR243UldZT2dYY24xTjgzWnFtMjNz?=
 =?utf-8?B?QlhEb0lXSFQvdDN3VytjdXg1RkhwOU5BRjhvL0FZQk9KeVFoeUhnbUlzd0Rq?=
 =?utf-8?B?SFk3MkswYlMxbHRCZTdERUE4MDZrNjJLU2w3dEZkeUtMb21xSUVSb1EzZXcz?=
 =?utf-8?B?N0NUVkNCYVRXNTBWNGhmSVhlRmdvK0E2cTFldk5zblZtS1FPTDdBOWpGRFVh?=
 =?utf-8?B?R29LNVpCS2tLSnJXazZIOWMvQ0N4S3FrQXYxOXM0VHZaaUJ1TVRaeWlSalgw?=
 =?utf-8?B?Zmg2ZmZ2TnJPUmw3dG9NTVJhbGJKS0wrMEpNay9kZzRoS1NFeVRLVzFXUDlO?=
 =?utf-8?B?Wm1qYThNc2wxdWpKUnhTb1hjamxOWHV2RWtEd0NvdlNqMnN6enZSUGN1Znp1?=
 =?utf-8?B?VlVFQmdMSTB1ejc1NHVOL3MvbSt1MEE0VTBkU3lWTFBRUXpsQXBsT3B1Tm5L?=
 =?utf-8?B?TStjTDdMNnpyNzZaRzRLS0RrdTFjWm9DL3pMelEyLzNrUWxMQ0VPMnB2MEJj?=
 =?utf-8?B?U0RZQU1kQWt6QnBldzNvbU9QMmp5c0xST1dzQjZDbDNZRm45T21aNTRHL0Fa?=
 =?utf-8?Q?xiqthxQvToHQ6jeReT4vBSBAw=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NzlzTEdBeDdvd1FoNUJrVFFpQUtmVlZrWFp4ejZud3ZLVFp4OTF6NXdQUGU3?=
 =?utf-8?B?VHkxK0d3bnpBZEdRNkRDK3NVWG1pQ2RvSDBsdVNyR083OGVQazRuNFNvUTBH?=
 =?utf-8?B?NVBJUk9sMU90UVN6YlF2NWhCckM3ZzQ3NkdLZjczUkRxalFrQ1ZRallTVmJS?=
 =?utf-8?B?bHdBMDM0alZubWM0ODRpWjlYSTQwQW14UVM1OFJvZjJncjZPWWpKWU1qU2s2?=
 =?utf-8?B?WS90VnJXaVhJUFlCaGs2MmJiK3VzYTN5eDZnY1hLSFVkV2MvalpMdXAxM3Rw?=
 =?utf-8?B?VWhPQVNkNkZDcGdrNmd3T1RrTmZ4RWNkcjRrenI5UDJxRGgyb0ZkYk40ZlMx?=
 =?utf-8?B?NUZDNjNGTFVsRW9HbmVzTE03UDZ1RWhDa1AvSHNpcitoTitRY0ZMb1hFSXd4?=
 =?utf-8?B?L1JtOWlqZ2FTRzBQdHM5RkJUTHE5OHBvOXdmeUVhZzZrZmhaTzh1SXpINUZ3?=
 =?utf-8?B?ZE85eTBnUGx5S1B5Wk0zWElNdHNRNzdvaFhOUHJOUnVvUWVkNFdRNTVDeWlW?=
 =?utf-8?B?TzhlcW5sbzZCQTB4MWlSQ2t2RVhPR1JyNXZiOERiZ0FUNFZrQjMwZkNuc01a?=
 =?utf-8?B?cHRvcklMTUh2d05UcmtzLzFRaEhJektFdmExVzRFTG40bVZsZ09UU3JFbS9R?=
 =?utf-8?B?b3Q3RTQxQTMvcGFTYzVqbXJxMzhEdjBNaTZHbFZSbVJ4OGxKV0h0ZXFGa3g2?=
 =?utf-8?B?Qi8xcWIzdEZBaE1BQzVvTWtMM3pNWEI0WU5TSm0yeVdGSXNXalJWT0wwODc4?=
 =?utf-8?B?dGVYSE8vK2hJT2Nld2h3eHJERDBlRGtqS1JjY2pYSnV5S0NiUzlqYThXRUFx?=
 =?utf-8?B?U1c5Z05VYlA5Y0hXV042aFVIU2lQNFVzVjRzU2FMZWlSUmtxTHAvZkZCZWZy?=
 =?utf-8?B?TzU2RGR5N3k2QXJJc09OeDVKZ3pKb3JKbS9oOTJBN0VKQUF5Q2hUV3ZEdXUv?=
 =?utf-8?B?b1pVNWpqSEp0bkJYZUpXSk9Ub3hZTVZZdHpUYUVNS2RrVzdQWVJtdFgxS0Q2?=
 =?utf-8?B?SENybTdIYjdiOCtDSkR2MjZUcCtUMmcyQmFTR1ppNFV4TEhldzJiVnV1Lzls?=
 =?utf-8?B?NWV1d1k2SEhicGZoc3Y5ZnVaUm8vZ1V1WDhiMVE5RlZTN1dKUXNneTViZDBW?=
 =?utf-8?B?Y3pWRXRzVzZTb0FnSzV2WmtaakdJeEtRYTRkWmdnN3IwRENGeG5VZEg0TTJ3?=
 =?utf-8?B?cXdVOG5PK0c4NFg4SktiTkRGN2V6bGJpYmVaYWk4Z2tJcEYrSTNIQjdSNWRu?=
 =?utf-8?B?QlFRUG04ZjVHdVNuOVRvS3hJNFQwdVV0QmJZb2duQURwYlVNWW5yMjRFZFh2?=
 =?utf-8?B?YUdjVkFqbVFzRWM2WTBYdDg0ck56R2tjUlBJek9sTVFETFU3TmwzSHg3UzZR?=
 =?utf-8?B?b0tVZUx1ZUxmbks3OTAyTmp3eExxNWk3VkRIaTl6blZGQ1BPUnkyRzZhZW0y?=
 =?utf-8?B?ekJLRTJRV05mN09QR3QycHdkbG1aeHFxMmU1RHdsTTQ5TEJPOWUrbzFEMWdw?=
 =?utf-8?B?azdjVGgrYi81Q1FsN2xST0pBd2FPZXRUcUJnTWZuR1h6b25lc216ZFVxRmFJ?=
 =?utf-8?B?TGRyYWZlTytFWUZPRFZVeGJMMldlSHRlU0FuWUNEMW00a1hOVUN1M0pmQ3lI?=
 =?utf-8?B?eDVBQmNiYUNUMVFwTkJxaTBmeFZmUGdjVnJUVWNkY1ZwWTNxRWN1aERONmpP?=
 =?utf-8?B?d1JrdlRLTGtLUWprcWVBT0swZjNPUTBqR2crK1hKL3NEQksyNHk3b3k1TzBt?=
 =?utf-8?B?NUd1L2VUbHZWVFNuSHRINGtEZE93VG1qZVZIa3o2RGNTZkNyazNDYjZ6M3Bz?=
 =?utf-8?B?SnBTU0pvbWMvcWZSSVlnVUtlYVNXRGEzY0JTMGwvejJIOFlBMGJCVVozVktE?=
 =?utf-8?B?emhvV0UvRnZkQmVqdkdRSlZyWDd5YXBJWjBZaFh0Zm1KRmNYWkhPNEFKV1ZS?=
 =?utf-8?Q?NO15RYxM7rm2zG9ODhwkbBs2lh2ScvgD?=
X-OriginatorOrg: sct-15-20-9412-3-msonline-outlook-fe3f5.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 01001a42-d6cd-424d-302c-08df0ecabe10
X-MS-Exchange-CrossTenant-AuthSource: AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2026 23:33:24.6956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PPF550781929

On Wed, Sep 09, 2026 at 09:40:13PM +0000, Sashiko AI review wrote:
> Does the truncation still happen before the new check runs on ILP32
> (i386, ARM32, MIPS32), where unsigned long is 32 bits?

Yes, it does.

Florian mentioned on the amanda thread a queued series which adds a
shared parser for all the helpers:

  https://patchwork.ozlabs.org/project/netfilter-devel/patch/20260503083220.630655-2-rc@rexion.ai/

That should cover this. I will drop my patch for now, thanks.

Kind Regards

Aamir A.
