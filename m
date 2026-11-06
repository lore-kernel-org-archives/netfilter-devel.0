Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.66.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793974694;
	b=leRwqlFnR1F1YhHqTZcdz7uwRMD0+U5qEk3wu4Akr8uvIWrWkn2lEJNY0Ji3xsmIrClR
	 bSDZBvwS3+ceqVJsGHxemoyF7/49Vk3V9Kv5s2VK0HMqufGh+4dsT+Uuy0/V0ZKlO8KCS
	 93u6p/gJsgUciz94eD9r1cLmIYCZAix2w7fRdmOXObeMn8oox1mqWY3H3g9vpDoia94Uv
	 da2hYPMO7u4C1gXbuSbMMl+41uBkEViClfjIfR2Cv26Bc5ltXKy0EjTH/xSnwdyV/rotw
	 PGjSt5LfI2LYKn4Cy8WKEX+IPwjwshWgUZeNwEhbK5Z4ZDCth29n8cCHrOAurP21Gvw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793974694;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:To:Cc:References:Subject:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:
	 X-Microsoft-Original-Message-ID:MIME-Version:
	 X-MS-Exchange-MessageSentRepresentingType:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=jI9IgHLgBvrzmUQUntUBOe+/lcv42MSX0TIp963LpgQ=;
	b=mz/WzuDf2lN2tFtKbhJXAglimJxSS2V/keKsOsoASSnc4y3Qt1uD9meCdssoxiyB9Ssh
	 iH4e3zMMz4jPHrkEOD+brJ5ehlGT/vK4r+CltprcYrScF8dpA/VqsIxxArXMQxYXzV5d+
	 S5gnC5yfJyBnPCKOvm/7iH/he+2AjjgXVKOnURcqnu4JVHs7ZpfgTqEu61L8MjFLmfgqE
	 X3CUHplbN7GMwqme/RdfmTX5xVjIkaWFQ9tNanoVXHi3y8UvKX4uG8RXYFGDqo4Nua4dd
	 9XAvVmUGDmEN1iaHCC/CaAk0jsLCdWWsiOnjOqwWshpHKcCbhG01knIveg4Bx7f4Mig==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=Y8jExoOI;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.66.28
Received: from OS0P286CU010.outbound.protection.outlook.com (mail-japanwestazolkn19011028.outbound.protection.outlook.com [52.103.66.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36CEA606A32C;
	Fri,  6 Nov 2026 14:18:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36CEA606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=Y8jExoOI
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PmWJ7c5kI7Ui+G1BGWVe6g6GQe+pknuvN/6XpkoIYc9ul+eeZL5PaavRRDG7YP9cIIY74ALih4u2Ew4f0zCl9iWBk1AsHIgOhwQxl4GtvOSWnmUgY1C6/SsnmsHBZcWVHfDehWQFa4pY8t0cPviarbfi5eMfE8Jo1yYoA96NCfXGzO8QZyruyIa0rmwkuzpKS33vNuhgt6+MdVEOpAd4wd4w32KsBhBk58lSsG9ptW+ClOwzGv/cEW3uBQlQIV+tRoPKMCUbWF3wHCgIF4JcBpR5bONt+/YE4ZEYpeLoojwrq4ClL/NHX0Eggbu5iybUP6RXauaitM+AR2XupaFEjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jI9IgHLgBvrzmUQUntUBOe+/lcv42MSX0TIp963LpgQ=;
 b=h373YudAyddFrVNROndYC0vWRfziF654gA9VnbSteznsL7zLc9CRuK4g5c8/wbOKwVZvoydFLOHlR1o5lQ4tn+UxX14CJfMr7HwEbuEYxOaJKXEEeQiCB/VfR7SYNQVcLskV+1l3FkX0ZB4H8sCj17XUTEGIJZQXUx8Q1apiXg5/uFtLNyEL561fsob1Zud/L3YSHbLfjCY7hm8P2GQPNZZ76bFpcR6jmZe1M2QFT2NgAU6gzmh0OVHdtT+YGB4/FJZnNHy83jbm0EhsY1qu2qffFjaTybrBsGzMisABbj4vnHbJEediRlkLwrATi/KeRG0DEOUw/jBSdsa39Yw7OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jI9IgHLgBvrzmUQUntUBOe+/lcv42MSX0TIp963LpgQ=;
 b=Y8jExoOIV3I1xh3eY+kG9w/9l4MBqdnTopB0FpH/he+wtycdU36p3+bn32wccfllKFZE1eUsQ4rGQ24piyEgNTIdSUNFdKRm/uy/dAjayQX8El/68OTo8nJ4zjNENCjX7M+yo9YbKc5mTGRDhPpcQlPF63Ye0QnGGVQSovl0UOHoarh2RgPJNnG68Y8hVTBt6bNkmyKXubhK5wqs9z94Y2AfUzNgL0usZD1y8ODv8R0oUyGEBLj8Ya92iOXWtetOcKIthmI7BkT4qnfHW+CHuuNpi8D7VrUsMgFE6jKeOCJxRo7d+naR0JOuY+ChMN21CRQgER59yKadEijl5A/Fvg==
Received: from TYTPR01MB11000.jpnprd01.prod.outlook.com (2603:1096:400:39c::9)
 by TY4PR01MB15500.jpnprd01.prod.outlook.com (2603:1096:405:272::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Fri, 6 Nov
 2026 14:18:07 +0000
Received: from TYTPR01MB11000.jpnprd01.prod.outlook.com
 ([fe80::fe39:4f49:5d91:808a]) by TYTPR01MB11000.jpnprd01.prod.outlook.com
 ([fe80::fe39:4f49:5d91:808a%6]) with mapi id 15.21.0592.010; Fri, 6 Nov 2026
 14:18:06 +0000
Message-ID:
 <TYTPR01MB11000E65B4D5C27C27D7414B4CA762@TYTPR01MB11000.jpnprd01.prod.outlook.com>
Date: Fri, 6 Nov 2026 22:17:57 +0800
User-Agent: =?UTF-8?B?TW96aWxsYSBUaHVuZGVyYmlyZCDmtYvor5XniYg=?=
To: ralf@mandelbit.com
Cc: antonio@mandelbit.com, bgalvani@redhat.com, coreteam@netfilter.org,
 davem@davemloft.net, dsahern@kernel.org, dxld@darkboxed.org,
 edumazet@kernel.org, fw@strlen.de, horms@kernel.org, idosch@nvidia.com,
 kuba@kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org,
 phil@nwl.cc, toke@kernel.org, xavierhsinyuan@outlook.com
References: <20261024092532.172005-1-ralf@mandelbit.com>
Subject: Re: [RFC net-next v2 00/18] net: introduce ipxlat stateless IPv4/IPv6
 translation
From: Xavier HSINYUAN <XavierHsinyuan@outlook.com>
In-Reply-To: <20261024092532.172005-1-ralf@mandelbit.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SEWP216CA0013.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b4::14) To TYTPR01MB11000.jpnprd01.prod.outlook.com
 (2603:1096:400:39c::9)
X-Microsoft-Original-Message-ID:
 <a82e166c-726d-4040-8511-403fee62729c@outlook.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYTPR01MB11000:EE_|TY4PR01MB15500:EE_
X-MS-Office365-Filtering-Correlation-Id: b4d307c0-c402-46c8-3c77-08df3c10c6ba
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|12121999013|24021099003|25010399006|4140399003|6090799003|25031999004|23021999003|5072599009|15080799012|19110799012|8060799015|40105399003|52005399003|440099028|3412199025|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WVhQTGNJVW53MFoyUVRBcjRnZkY2WjR0MzIrTmZENWc3eXdsdEhBZGxLK29i?=
 =?utf-8?B?S0Zoci8wVmJmYzRvd3NxeFlHU1h1ZFFaOFBscFI0VThKMEF5WlBLMzYySkVC?=
 =?utf-8?B?RkpqbWRCVERXa0ZmNXRvV2VkK2x3dHh2Ty9IRXF0RDJVV3hzRFUwelFQMCtk?=
 =?utf-8?B?UlJ5dWdPT3pJaDZaaHpMZFlIb0Z6cWIvazY4UHdPUi93aG44eThIeDZPaXRC?=
 =?utf-8?B?aEN0cnRzU2lkcGVkd3RFSEI0YTZkSkozb2RKQ0VFR2RMZkVjcXRQYTN6Q0lw?=
 =?utf-8?B?aWlDZDhZd2szT3QyR2lOc3lWejdGeWxCUndEeDRzdkR4QlhRQVprVXI0UUdj?=
 =?utf-8?B?dkR5K3pKbERaL0g5U29hZXFORlZSQmhPWEE5ekZsZVdBMlJmUy9wZkdZYWM5?=
 =?utf-8?B?c01QNkJxSXNQS2hoTmgvS2wzYWlPVFhjT0MwZ3VGUXBjL09lL1J0dmhZVzdC?=
 =?utf-8?B?Rk5oL29vTDlmc1FvUVFxRVBLa0lnaVJSOTNvUmdwalhvb2ppSTJEMzA5dnI5?=
 =?utf-8?B?T1p5R3NIMmFtVHZoV0UrS3gvaVlEU3VhbzdpWDcwZDZscTVMWGZCSFQvT1BU?=
 =?utf-8?B?VTRWdGtUMzB3ZzczQzlkWGphTzZqQ1hORVBVbmVJSFlna1NDMGIwdXllQksx?=
 =?utf-8?B?TnBHWFBLSjd3b2I4OXZwcE9XM2RZUXdRNWlSdDEzVHFHM1Y5bGRKQW5WbGR0?=
 =?utf-8?B?WXVHNnkzaFNvUnVYNVovaTh4V2l0YVIxRjNXcjRzMzVmY01mYUUwdnVUbElP?=
 =?utf-8?B?eklQWFNOeXhWek1yeWx3bnFrWkNPMjdlTTk3WHpLUnJTM0V5NDgwTHZTYTZp?=
 =?utf-8?B?Y3dXN2wyMVVQN3pBaHRKZVR0WGpJSzZUcGZ0YnlIelNEVXREVDRLejdKb3lo?=
 =?utf-8?B?MDRnNFRFeDFEM2hPQy9qUHZTdDJINmc4NENWaHZHQUMzem9kdWFmYU96Wm1v?=
 =?utf-8?B?UEdvdTM3R0hjWlVDR1lseE1TZUIvOFFoSk9LTjA3U1FYbDkxOG9GOTVoSmJp?=
 =?utf-8?B?R3lJRVpoL0ZEN0U2cmhRaDZSNmRrL1lsSmUva0xEYnp4N0V4VkNQTjNTYndX?=
 =?utf-8?B?N1dlTzVZd1ZLeGorSnJzZmw3Sko2d0V5dUVwbVVPVUI1QnZveUgvK3lLRXBX?=
 =?utf-8?B?dWNxQUpwQnAwUmNhcHc5bUx2bExHUXBKbERLdWl1L3JkOEVEQktET1BrNXc2?=
 =?utf-8?B?clFuaXFtQlg2WnNycVFqeXBlUjMzVkhnUGhSZ3d0K2dtc2tWL1RsM0NNZyt2?=
 =?utf-8?B?TW5SaDlGUzNVLzY1RDhFZk8xdWJscFM5MGRYdFgxVUhBNEEvdUtpWlhYUFZU?=
 =?utf-8?B?QmRyL2FjeFQ3OXJkbXMxTkxpOS9hQ3pYUXF6S0tjWkdxdThRTDVGYllTOEtB?=
 =?utf-8?B?YjI5b0FRVFFzQi8zNXArS0xvRFBMckV6STQ5WVUrK1hUdmhiRTdwZlZOTTVU?=
 =?utf-8?Q?7+RgGO3f?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MWcwVDJXajhyUlNVKys0bHNvNVZyajJkc0N4bFh1NFZoeGErOTAzdnhKV0ls?=
 =?utf-8?B?UWZydmg4djVyOTJXaFFCdUVadjRvTHd4eGgyRVVSem1hN0dxRGxNTjhsYlZU?=
 =?utf-8?B?K3RiUTBNekFzbXdTKzdjcGUwa0UyR1F0U0JPamNuTmkwMnNnUmg1d1hhL1NX?=
 =?utf-8?B?Wk9kNXNiaGJTdDllbktPMUVWQjJaUjZaV2d2Y3pSeGNzREs3MWxJS0g2U0tO?=
 =?utf-8?B?T2ZtSWV0NWNZUTFraENZY282T1paT292S1Q5aHZNcDA2RFVDR3gybmlONkhC?=
 =?utf-8?B?UlRzeWdCOUhVblQ3TEFJQnlHeDN4dElZSkQwaUtqOTJ3ZzRBNExCSElSMnFV?=
 =?utf-8?B?R3lQdnN0R2h4VnlXNzdJRm82ZU01WXl4TUxnOTBKYmpGbjlSYmRNK1F5RkI2?=
 =?utf-8?B?WXd0UEZhM3JRcFF3WEdXd09QMHduWFN5eFFJY1dsOTYvdWFJQlRiVjJaeTZM?=
 =?utf-8?B?VmdZc3JRcU1naTBwbUx3NGJQdzJPRnV3OUpramQ2S1BjY1lKSk9JVnBPMWhN?=
 =?utf-8?B?dlViOGZ5STAzZXBEUm5DQzNBdE9vT2M2Z2NiYW5tTWdPMFJESWR0Zm9ab3ly?=
 =?utf-8?B?eHZMc2QyZmVFbDk2NmlLanhtYU1FelVOVURrdEJTMkQrLzJSMUE5RVVhWmV3?=
 =?utf-8?B?UE1YTmJaOURrUWZoeEFsUUxxM3grWHplMWh2NkJCRTJGVVNKN0x2Q2poWTdF?=
 =?utf-8?B?YXJxbEtRa3p1eUF5ZUZnUnFVSUNGWG4zVUVLYmU4Q1ROWGtOYjhHSjdHS2xH?=
 =?utf-8?B?ZXlBYThITWNJRU9vY2UvN3ROTGtuMVVBSGdWSDY3SVM4RDcrWWNxdyttQ3JB?=
 =?utf-8?B?SVlHWEVOSEJIa3pzWmFBSW03VVJOMnc0RXlZYXVucXVBWEV6MGU1WDltVC9t?=
 =?utf-8?B?VkpBdkFjM1B6YVE0RmpIT296RXZ0VHZFYmFNbEd0dWJYa2pmejgzc0p0TTMy?=
 =?utf-8?B?UTM3YmcxL2l3MDBxMEdRVHpoVzZBSWRPaDZhazhUTG44WmhGQ1ZSM05Da2tx?=
 =?utf-8?B?T1phMzRoV0FoWkNUaVhFbjJYK29ncHFaYnlnZUI0ZjRneGZmSGU0azQ3dlBT?=
 =?utf-8?B?VkpBaHF2bnhudVRtRmthR0FHZDlFYTBhRFg5RjVPNFkyTHFmMkRpdGF1cE1D?=
 =?utf-8?B?TDViVnd0bzVocmFlV283QjM0bmF4SU9CRVFqUWdiVnZ5bVV6MEhMTXQvVmo3?=
 =?utf-8?B?Sy9CVk5tZlJlT1l6RDhPZ2JEUFBtVmZyMmYvdUZuUmZrZFhvTnp2MGIxa3dv?=
 =?utf-8?B?N1Q4WUg2Zy85dVoraTZDOElqc0dhWExUckdyMFFWM2xUdytPSjlIek50cGEw?=
 =?utf-8?B?WC9ncEJFK2p1alVGNG1HSVM0UXM2bGoxQy9hd2FXMXpoVGlhMzdPTHN1VFpJ?=
 =?utf-8?B?aTNTaXVBQXdMMk9mbGZsU25PdU5hUVpnYlo1NGl3RER6a0xrTjc0L0JEbkNY?=
 =?utf-8?B?ZlZmaG0ySklyQzNiLzc3b1dZRC9SSGxVc1N2OWpybWcxOVZ5ZnlBdFA1N25k?=
 =?utf-8?B?Y3VaZERwNUFUTldvK1RyWnJwNithZzNqR25oMy9GTEdyeWhQUUxQL1VTQlkx?=
 =?utf-8?B?WU1lOEtyK1YxQlQ0K3VmVDRzejF6SUc5MXY4WG8wais1VXRYRzl0eE9NaGl2?=
 =?utf-8?B?dFNXZ2FCOW5jZ3MyWHZ4YlVTeEhhNG1mN2lvNEFsaG9naVF4bER1K1pQNHlv?=
 =?utf-8?B?WWQ4blhLUjF0RUIzSEdtVFBpUkVWaU9QanBLYnUxL1lndWVSSjlweklWT3Y1?=
 =?utf-8?B?UHNNNkhKSWZ0TXJiMXlOQmhxaEFsQnRockcrNHBoaUE5Y3JnMlpSTkdrelNE?=
 =?utf-8?B?NWVVbDZCZUFsSEM0Zm1xVUd4czJEWDhCOWJneEpHWWsxYjBnNWp4cmdjOWJi?=
 =?utf-8?B?dks2cllpbnhnTEo2SG1OcWdpTkFtaHRSM1V2UVkvSmVvQnY5UzR0aFhjS085?=
 =?utf-8?B?QktvMk5lV2dJOUFDUlhNcHh2NHJvRnFKd0lEd0pvTEcyTWYweTNoRnRVaTRV?=
 =?utf-8?B?ajJzMnRVNk1BPT0=?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4d307c0-c402-46c8-3c77-08df3c10c6ba
X-MS-Exchange-CrossTenant-AuthSource: TYTPR01MB11000.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2026 14:18:06.8184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY4PR01MB15500

Hi Ralf,

Thanks for your v2 series!

Here is a question about netfilter hooks in ipxlat-lwt. In RFC v1,
netdev-based ipxlat allows POST_ROUTING rules to be applied for
original-family before translation. Currently LWT path translates first
and does not check nf_hooks_lwtunnel to optionally run original-family
POST_ROUTING before translation.

Is this difference intentional since it keeps LWT path simple and leave
such cases to netdev path, or would an optional pre-translation pass in
LWT path also be worth considering?

Best regards,
Xavier

