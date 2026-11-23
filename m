Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.66.9
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795400868;
	b=FUCWtX9xmiA4xPctCQGXB1P6kqPLOVFxxAXfIh6hSK5qqQpDrefuQSMmKZaMK0DaQBBU
	 M6FR9Srl9u3R0XAOai91LkfBSNF4QZMDy4TdjJ2n4+u6+eSF+SOPy7SkgX6YAwSniJrCj
	 JoJ5rkU4SpoYn18Ml4uYtvWIn973O5kFVrySsaYYfq0S87Y4X/A8xxzi6yBPJTJyQDDns
	 ulfx7r9icqBNDDBfFfTp7orfz/xjZwS3Mkvho/dPaW1HL0pcSWhF1N2H5eSBn98D5FeOH
	 jNlJQaixGwQGoVAix+2IOmzYRcEwKoshXJtSAsTFQJVYcKZkhIUjkP6I0jsOXVmH6Bw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795400868;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:
	 X-Microsoft-Original-Message-ID:MIME-Version:
	 X-MS-Exchange-MessageSentRepresentingType:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SLBlob-MailProps:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=EBrldqAIBv3Z/hVlNah3042rzocjKOkIlVCKVSd1MmA=;
	b=PJBd/JJXiSeajG1RGw/PPb/4g2jF4rnKSPOtpLz8lWk4C+QNW+ylUVobQ11kELxgpe0i
	 CyEbqIS4vgHxjg3ihc6/uRF6M26EliCGwbR/UUB9bBwwJnAYS/bCmDVKEkGU7SBuNg3TI
	 mua659TJoSuvu+7Uj3IWVF/9BgNZzWQcln1NoiZ6YKS8D17Gy44R4GeJ5bhi+6Tjk9Vcl
	 MIsZFi1EG8ZyDRcXUEPBNLNENl+ErbkbLE+jKXilHf2eSLS+XIjBbdpGzGNosT8AG112Q
	 7T1CQKch3waqF2tlArikgVMLMD0p9g3paAyl1vCa/Tysfa/zEr2ZQ1//0gM35hFJUag==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b="q/0zeAw9";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.66.9
Received: from OS0P286CU010.outbound.protection.outlook.com (mail-japanwestazolkn19011009.outbound.protection.outlook.com [52.103.66.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10464606A31A;
	Mon, 23 Nov 2026 02:27:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10464606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=q/0zeAw9
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eYoTdfNNOQGtVQhbMKr9X35fhnpC1q+sLW8K+16CUc7/OoNOTHBJRpys6qeZfW2zGQz9Ik60uaN83T+8KKqSaGqpBcDJdQG5ZF9rEaZN7uIgHpZYZbGO2lCoMAPu/xTNcWIt0tV9IZmaaRubWnQyT/MxFZ57TdtbbsTjsxiyhengC8+reaSmuGjnlfZZbMZJJamytPWFKAgMYWKfBP6dH8zTcyVIP0+uRU8dQJiMxF+7Nsx9q6JOaxDGtP/KKFAqq2BPno0z/WTLftUcgd8nze6wRubhpOV/E3Oe2eu3FAI7QBWNe1WHrzvlFSlnHegglZXWrftUHe6QiBP4gMhqzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EBrldqAIBv3Z/hVlNah3042rzocjKOkIlVCKVSd1MmA=;
 b=PCXd6+6hmgSbWPKAvHM+1o3mi+qW+0LtetJCqn5rk1D9FaBglsvSMtGfGj4Np6BVJUZ7/rEAa4Juzc0q7pfIY5/UowRpL+N5lY/jOftJ4PMeGDkvvncXkyMX/QOSnM+fvbU8wA+Adw6sTbw2xWJyebDcSDi5jXMD00eKI38pW5YIvXFH1p5IDthywEZwkZ7a5vS8X5X6hP1mrL0/rigN74LdMfiY7Pp8bRfzHrVMB2Iai5TQfuhMCfETHx1v9UD/8DPzi6OZ/pnT/q2JjnaGT0xlmOO87UvrkIzVhCX7zqjMc/03HVxzh91t+dtVN8ElYFboc8spAKAWqOl5OfwzEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EBrldqAIBv3Z/hVlNah3042rzocjKOkIlVCKVSd1MmA=;
 b=q/0zeAw97125AGbonQBsAs0KWiJXJwNuBL2MxAwJHfphpoEbzBWM45WFh7t8ANN+CdOfwsjIpSOZiZHjg9pDCyRCnhnraQCg5jtLVTYX0XSa/Yd6fL67MQQh6rLkte/qnDyMZnwA86kcMGi37okGmXjZzYDtauHkgvRHAamdFBJblCcpvR1y7SG/z41BuyXI+PVUJscwcZO87hTR+UohYaIzZPuDz+4Y7LbYpuEck1hyZWGmae1KDWmfBQsi3BCc0fu8U5WZ1YFDmLLDNJgTeNiiaQgS4EaZz1iNcrcM/l/rLWZrvIXShlY/A7wpn9oqJCDlRIMABu0RULwTiDLI1w==
Received: from TYTPR01MB11000.jpnprd01.prod.outlook.com (2603:1096:400:39c::9)
 by TYYPR01MB16429.jpnprd01.prod.outlook.com (2603:1096:405:146::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Mon, 23 Nov
 2026 02:27:41 +0000
Received: from TYTPR01MB11000.jpnprd01.prod.outlook.com
 ([fe80::fe39:4f49:5d91:808a]) by TYTPR01MB11000.jpnprd01.prod.outlook.com
 ([fe80::fe39:4f49:5d91:808a%6]) with mapi id 15.21.0639.012; Mon, 23 Nov 2026
 02:27:41 +0000
Message-ID:
 <TYTPR01MB11000B5AC6D9C174AC489EA62CA452@TYTPR01MB11000.jpnprd01.prod.outlook.com>
Date: Mon, 23 Nov 2026 10:27:33 +0800
User-Agent: =?UTF-8?B?TW96aWxsYSBUaHVuZGVyYmlyZCDmtYvor5XniYg=?=
Subject: Re: [RFC net-next v2 00/18] net: introduce ipxlat stateless IPv4/IPv6
 translation
To: Ralf Lici <ralf@mandelbit.com>
Cc: antonio@mandelbit.com, bgalvani@redhat.com, coreteam@netfilter.org,
 davem@davemloft.net, dsahern@kernel.org, dxld@darkboxed.org,
 edumazet@kernel.org, fw@strlen.de, horms@kernel.org, idosch@nvidia.com,
 kuba@kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org,
 phil@nwl.cc, toke@kernel.org
References: <TYTPR01MB11000E65B4D5C27C27D7414B4CA762@TYTPR01MB11000.jpnprd01.prod.outlook.com>
 <20261114094722.114623-1-ralf@mandelbit.com>
From: Xavier HSINYUAN <XavierHsinyuan@outlook.com>
In-Reply-To: <20261114094722.114623-1-ralf@mandelbit.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SL2P216CA0151.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:35::6) To TYTPR01MB11000.jpnprd01.prod.outlook.com
 (2603:1096:400:39c::9)
X-Microsoft-Original-Message-ID:
 <06222a8b-074d-4ba1-9ee8-ec81c44bcb88@outlook.com>
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
X-MS-TrafficTypeDiagnostic: TYTPR01MB11000:EE_|TYYPR01MB16429:EE_
X-MS-Office365-Filtering-Correlation-Id: 24b379cb-c78a-465a-b2e7-08df49095941
X-MS-Exchange-SLBlob-MailProps:
	laRBL560oLSPhlJ95/U7v6W/AahuugGa4E0zKh4OOc3jFHgO/NH4HzQ9BvQ6mKielsUEGUsoG2LFfqpejiYWYQ6vA6AN2KCft0vEOOlZub3GBIcowfgREA5PeNo4W8OCAvtRt9GW8CB2EUHaDvew02b3B3rVaUQNxSQ/AwiunG4cJkqtJS630GNubWYiJk+mLqyL9P9mBc0IL+zNGxh+GheFex6RBllrRerjpM/Yc3170bLfvk8L1EXJyUlSwErt90C+7CgeAfKA0pXhpUjEeS00s7m6q3G3ZzX+wmJV+x+SZMfsQCJx7EWfTSiVj1/Qi2MKpsQwxZdH1pstl7dhFTNiJ+VrbdCrUlFe1ytaCw6xed9xgQN2BG+hj0olng2cKFN7a9xebbXq68aAwUsTpahSR3UtpbGEOsERv0HbrEPQOvZguyNucItpOjM9+xGvPSIkNJ0IWJkRMnz3Nf9XdsFhT9WmhIzHFBaJPMZyyxWnQaoZ0o/3607iv3GbMRf/ZvrK72DNQs2WpBMPpnVhZyn/0tAY4MKUVLf/nvhwADplpSHc4mZGuoHzqu1tsXeVXUNXGs2qbtLVuX1HfK1jVyNFOLC5z3RxT+pKC3/YBSHVwFoIa2GxY46cItKvXaeJ/H7ifrB0L8DAstNkUVR97HUV1kRtO5kiU3+EI17ApsYKlw4syp/Iz75gWSKfxtXlU7tinmfP0tm9VZWVQHAzae/KKZLah98ls8UOsylQbO/HMbj+3mmC7Z9YI9iWu/R+9Bjot8oWFxP4qFnqSsVq4qDqaWnTBul2
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|25010399006|8060799015|19110799012|24021099003|6090799003|51005399006|23021999003|5072599009|12121999013|15080799012|25031999004|40105399003|3412199025|440099028;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZzRnMnp6S21YZlhVWVpxdFU4eFhTTUdJenN3RFdMejhDejI3WDB0MGt2Ry96?=
 =?utf-8?B?SHh3dWRTakpYOWJKREg3U0xLMnRkUkM4WFFEcFNtZWo3QnNwM0ZUYlRxN0FS?=
 =?utf-8?B?TkFIb05VR3JYME5kSGFsTkYxUTVrM1c5V3ZHZnJnekJCdGlTbG0rR00vSGtR?=
 =?utf-8?B?UlJVSEZSNXFMaG52SVBwY0tDSVM0OFhDRU90OENHOFZpNDhsMjJEWHJDQXl6?=
 =?utf-8?B?TnE3Z1R5dGdWcDZuSmVvY1MwamVEZlBKSWRyNU9HeDN3YXMzMG41TEh6RmpF?=
 =?utf-8?B?K0FWQ1pxUkV1RnV0QWpHdUFXdTU3aFN2aS9VNGVPcmtEcTdING1SOG4vc0Rs?=
 =?utf-8?B?R00vNWsxYi9mMTdZOVMxcndIUW5aKyt3MUM4TzYxZWxJVkRrLzNvWFppeTR1?=
 =?utf-8?B?T1NoYmd5L3FueW03T25sdGtQS2lRZjJXU0JGd3hndXAvVVdqM2pseUovMm0v?=
 =?utf-8?B?MGJIdkgycmMzVmNOOTk5QUZxSStUdVFLdktUbmNzNkgyRVhjR1lkUDAzVzBK?=
 =?utf-8?B?Q1lndExka0poSy8reS80NEpsdXFpM0h3ZG53eEZXVEl1ek5mOVF4bXptYkp3?=
 =?utf-8?B?WTU0VGVlc1FHeWJxNi9ObzM1R1h4UksyWTBEQUFxaTQyd1RGTFdzVkF6TEk2?=
 =?utf-8?B?WFF4c3Q5RTFFZ09rQ0ovZWdxMTFQQ3lEU1dzTTRNRFV4UjJWNGdLU2JjZnd1?=
 =?utf-8?B?clVGdlhyS1hiZTBjbFBHOW8xYkRBWU1YZzFIZExOYnpZMXJ0alA4S3NJUTRx?=
 =?utf-8?B?akhxQ0ZRcXBYL2VjWjE0ZGw2RWRlS2hyNUw3cmxJUmRBSXFUWVdQTU9ab0s3?=
 =?utf-8?B?U21SdmJiV1lLQ2ZqOGkvQzRhMkZCbG9SeFI4QmtjQloyM05XWlBNaHZWQ0R2?=
 =?utf-8?B?N2tTUXo2NmQ1eHJMeVdQOGU2eExCWVdEZVUwMGFQQ0x4R045N2dPc09SVGJj?=
 =?utf-8?B?eEJaWE1GZHhLcytKQlp5blR6N3g4bFBPa04ydnQzWFRTNVdkR2lMWm05d1hQ?=
 =?utf-8?B?V0pMWjNQdlkvL0VuNFBsZUZFclE1WUlEZFBSLzdFWDlTR1k3YkdzZnovc0Yr?=
 =?utf-8?B?MUFuMnJLS05hRmFlU1lpeDRFdU9KSCtGTmVMOEFRUmVJUVFPSG1yVnVTczRC?=
 =?utf-8?B?R1d1YzJCd2N2bTJXRE5EK3VjUExOakQrREtyZHU5bmZ1eUd4V3FDUmN2K3Fi?=
 =?utf-8?B?d2Uzd21Ec01GcTdhbDhyTzVsY0I5ZmtSZzRDMmlNQ2szUXl3QURGNWtTSkR4?=
 =?utf-8?B?U3ZJRHZmclp0aFdNWEdINnFrZ1duTnF3YitCdHNhVmpPRlZRcTA1emRZNDha?=
 =?utf-8?B?L2VKK3VPa25xbFJodGJZaVB2YkQrdFR0d1ozajlqS0FCcWV4Z3BwWjB2VWxz?=
 =?utf-8?B?UmxVcytuaTVOMXc9PQ==?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cVBOUWdSTFV2bXR1czQ5UTE4Y0IwQ3NBUkFwU254cTczLzVoSFM2Vnpjc005?=
 =?utf-8?B?OEFYMnZWWkovK0Q1dWVMTkc4M3hGVXB4ay93NWNoMmd6dkllVm1icXd3NUtn?=
 =?utf-8?B?RUdyRGhpWVQraVQxNVV2d1pwOFU0Q2Q1akNSVUVuZ3Z0SDRXN3FDZEtNRVJF?=
 =?utf-8?B?RGNmN2pJcVkxVVlYNmE4QTRMYXBQcFJZcm1sVmZ5V0lYUmR1NC9wNzVJYVp3?=
 =?utf-8?B?VGFzVXFZYlFCUU1PNW1wcndhbjcyVmt2bkJRZ2RtUFREaGg0Ry8vanVUcm1i?=
 =?utf-8?B?YmJaRC96bkovV3U3L29qRkYxVTB0SDZ5b2pHOFhheDFXVXVQS1VvN3Z1NkRW?=
 =?utf-8?B?QVVGcG1RRUJoWENyUExYZ2h0NkdvNmFjSFpzSXBJaWNnTWVmMDBOVWRIakYz?=
 =?utf-8?B?aEZCdGdLcFlmSUpKRTJaTUQwSi9lTmVmWk9SMVhQTHA2NmlEMU1wVk5heVhx?=
 =?utf-8?B?RzBpZjY0cjJMTHRVQ1VOeDNJSzBpTHVPWENKYks0SmFjUFlFc1Noa3hhcHFX?=
 =?utf-8?B?Y0lXNU12TDFzbkM4MHcwVlNTNE5PUlEvZ0pqcklXc1I1SGNVNTJ1TjF4N0tG?=
 =?utf-8?B?NiszQlU2b2s1ZHdXVHN4Ui8yWm8yc3Z1ellaYlpEZzhmZkx3MVorWWRTSjdJ?=
 =?utf-8?B?M2QxQi9sc2xXandvTE5VZUJ3dTFTZEFqUVh0Vzd6V29ZMCs2a2FmSXp0dWFp?=
 =?utf-8?B?M25nUDFkdldUWXY2SFdoQUFDclloRkQzaHRoODE1NWRjVzlGWFBGYXhJMXNp?=
 =?utf-8?B?eTNTaXBwRkdFeUdKYWFQQlJNQmZVV0hLSmFMbCs5Wk9KRWpWckNWVFVVOVhh?=
 =?utf-8?B?Q0psdUlPdGpZSHNVUkY3bmdjUlVISTFuRGZNMlcyUDFmRko4aC9rcWVQaVlX?=
 =?utf-8?B?bjdWOVhRUXNLSGNMc3U3empCRlRvVVQyK2pHRnFrcHBmQXBlOXA5M1dkOWlC?=
 =?utf-8?B?SjFCSURNRVZXK2ZPeko5TXFyaE05V2RTSW9TVmdHVjRLQ2Q0WWtZeTZBNFAy?=
 =?utf-8?B?dGhJWnp5WjVZM2dkMXdhY24yMEZ1MTRWWjBXTjdLVWZ5UFNOWTFkWXVKWkh2?=
 =?utf-8?B?aDBUckJvZWNhSXpKbzBnNkRUdTkrWXNnNGxQQnFQM040YnVmOHh2d0ExeEJy?=
 =?utf-8?B?RWZFSHVmbytJTTgrS2RYRWdocVF1ZDZ1a2ZvaEk2K2lDU0FTUzV3SkYxa043?=
 =?utf-8?B?SnNob1A5Yy9ZK2pBcGFkVzVaMEpDdTYwa2Ftc2NrOEpsbTVodVArcFFHZ0d6?=
 =?utf-8?B?ekRSeG1heGJEMjNXSmdwWmorTUFwSXVKOEZ3UUNNdzdFeGlhVnMwRmlsWG1m?=
 =?utf-8?B?K3FYREVwUzBUNGpYaUlZSDVENXIzazAvcVhHUTFkMEx0TjVWczJoaGR6Y25n?=
 =?utf-8?B?VGs5U056V2FyYnlwNnV1aGcrbHBYeGNybDJkMUgvdzVBV1dnNHJHd2F0NHV3?=
 =?utf-8?B?WVFpL3BvRTdzVzJ3bUViQU4xN3M4SG5Zc0tLdXJ3QldvUWFkVHVqT2ZoSmZP?=
 =?utf-8?B?YXN1bUdaOU9lM1Rpa3NrSXFYUWJMY2hkVTBUdFhKRTd4TDdmekZNY0FoLzdY?=
 =?utf-8?B?RkVJVlNEUXdnU01aVExxWlY4V3hMOGFlOXhnUElyK212Q1NyR21EbUs5d2w5?=
 =?utf-8?B?QWEvaEFVQkd6MUZwNjB5RFo4VXAyV3gzS1V5akVWZmlrUlNFdUVwblVFbUNa?=
 =?utf-8?B?RkRNYlpsWHMrTnhXeHBSZmNsbDdWeEU4Vk5iTkhnM1Q1SWNUc3VKS3dTVzhq?=
 =?utf-8?B?ZlJ1TjUxQnZDNldjT202bUlaUmhXM2FOSWtrUkRzemJ1bTFVNUNqbkpBbzhN?=
 =?utf-8?B?TkRPYUxLWjBYUm82Z0pWOVVWOHZvTVVxVGcwQzhyZFAzUGlZbmpPT2Y5TXFR?=
 =?utf-8?B?VGduQWdYbWowTVJZcmI0SnMzOUFWTFNrUkJnaW5USHVGNlZpalI4TTRLeE1O?=
 =?utf-8?B?bUFWYmJWMDYybzdOWVIrcjRmMGNQdUE1N1BiZjRMeU1scmpTQ3VyMVIzbDl6?=
 =?utf-8?B?WE1sRmJqODdnPT0=?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24b379cb-c78a-465a-b2e7-08df49095941
X-MS-Exchange-CrossTenant-AuthSource: TYTPR01MB11000.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2026 02:27:41.4040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYYPR01MB16429

Hi Ralf,

Thanks for looking into this!

> Actually v2 has no netdevice attachment any more, the LWT is the only
> harness in this series.
>

Ah, I was thinking of a possible future netdev attachment at the time.
Thanks again for pointing that out.

> Aside from that, yes, the difference you describe follows from the v2
> contract. The selecting route terminates original-family processing, so
> that family only sees PRE_ROUTING (received) or LOCAL_OUT (local), and
> FORWARD/POST_ROUTING/LOCAL_IN run in the translated family only. That is
> indeed the first open question in the cover letter.
>
> Looking into it again, there seems to be two concrete problems with that
> contract:
> 
> - original-family conntrack entries are created at the entry hook and
>   never confirmed, so stateful rules in that family see replies as new
>   or invalid and a conventional ct state established firewall drops
>   them;
> - SNAT in the original family before translation is not possible, which
>   rules out NAT44 in front of a CLAT and the NAPT66-based NAT64 recipe
>   from the v1 documentation.
> 
> So I do not consider the current behaviour settled.
> 
> nf_hooks_lwtunnel is one way to add an original-family exit hook, and
> seg6 is a good precedent for the hook placement. I am less sure about
> the gate itself because it is global, cannot be switched off again, and
> is off by default, so the default configuration would keep the problem.
> 
> Two alternatives I am evaluating are calling the exit hook
> unconditionally, and moving the translation point to the LWT xmit stage
> so the original family completes its normal path. I will come back with
> a concrete proposal and a per-hook table.
> 
> Which setup do you have in mind: SNAT before translation, filtering, or
> accounting?

My interest is mainly SNAT and counting before translation. Well,
stateful SNAT seems a bit odd for IPv6, but with multiple upstreams we
may need to adjust the source prefix based on the selected output
interface for load balancing or failover.

That said, separating NAT and translation by utilizing netns and veth
pairs could already provide this, but letting packets pass through
original-family POST_ROUTING before translation would make setup (looks)
simpler.

Best regards,
Xavier
