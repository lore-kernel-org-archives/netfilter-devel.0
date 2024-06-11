Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98E8170846;
	Tue, 11 Jun 2024 05:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718085528; cv=fail; b=mEI34NScUl5UucIgfUllXiNlP+mL1xx7UBbs/HkjsgsqShh9SLYBrxfBijgPuXPzvCS/PnpiE/7IvF3TQ1Clgc+vg8TOTTC1DjERx1g4DcbwslvtWIgxyViV9FFMrGfRlcvZU3BlzaOLd1hRajWnNcPu2dCMJJr3tan5xDS1bZk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718085528; c=relaxed/simple;
	bh=AepCv7JHOe+ixzaNQAdireV10Z5SVmRkFavu49SrxfI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lwnNg75w+bm3bF4UT6eDDBhqjJJg00z/jeaoN1xzCP6ANjuw1GLlRmj7VV3g/WlzRMeA913FNPUBDPBQUfNvMQgBPHsr2prQ8EbSuCzfKPChszTTco+WhUdpceEt/XRL8HSFL8qMAkEhEWBMh5hWqLXy5G+gcDGmaZ4mdD2xbUU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=C6H6IE87; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=A1RwUo1q; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C6H6IE87";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="A1RwUo1q"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45AMMvl3026683;
	Tue, 11 Jun 2024 05:58:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=Dh0tJfvWKXs9zjhEB7mNhhfzhFiA20XkriUGkV33yCc=; b=
	C6H6IE87MnYtvXglomYL92GjklXkrnX96d1sQX9In16xs9dBDxLE45BmSI4mAsqb
	gZsAwSnoBIov1z9AQWxY5QaiiV7WRSsU3Tti68DRX0STs4w3LXNJ/RUkHowR9eVW
	nLNe5+vjK4Jkx1qnaghAUJcIOFmZLOWMrQA7axDGnP2fxqxN9YVHp7zg+lRrK9ld
	dqulZxq05eHFEDVYLpnTtum3s136jjpgoD2UXSslw7cqZahcmucjKRgZbl5KGUD8
	pnTwx+VEAGdWEP4cZ3Q1CvswgiUCw8Ictasb/EIklwHctjxGKeTCioUXaKZHgNxz
	PCfp8OwjQYdXkjs3fKbsAA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymhf1c1up-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Jun 2024 05:58:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45B3mwAY012553;
	Tue, 11 Jun 2024 05:58:41 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ync9wbgjj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Jun 2024 05:58:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y6qj3Ia4NLs37509IZ2yjs34CM1cKo+1P47gsconlp5jso7cj6OWqa9mK6GCZYy270fVq2Ih9yxumQiAdfWrdnUPJFYOnJqJ6Hv0tL5w5cYClgtgRahk5S1CgbE5K7GMK/IpsuTLoCLC0aP7xGr2JnWxQ6eNeux7Q8uFYNerlKM0CX85Ual4ilJuNlHbWXjznwN9KOv76wHboOgp70JejKNx40oLjh46+lKAImRc025kHkW+CTchtzKuY2m6TRd8RP8encwepVz0KwXaSZyxSKHMLk9o3+rnZsss0nHagOZQ2B5bszO1U+vATE4Rn6RNxJokKFFIWWsXJDW6r/IaBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dh0tJfvWKXs9zjhEB7mNhhfzhFiA20XkriUGkV33yCc=;
 b=CgGw5qGn4ZK6BbDQcgo4ZF94jGCEbRCzGcZVgmzpDjdNtnqyGwaiTy0oc56i3/iOTbE/GFh7b3/YPHCAFY4eY8s1xawKbFMaxYFR7hI6WswChRmxGFnJjwLUO3uvGcRhyb75YhUZRjQ233lzkxQBbayX48Srf+N0OQg2KP2VVbjSS9EVOUKOnIYhAznSAkOY97K6Uvn9WA+KsqBcBCZYKjp0sT/5eSqwUJRbVOYWackOKtWJPT76LxOulKq5A2VO+4Bh49mBqVi0Kl2+ahwMa+F7Z3mQDSM0pZKor8tMW4NBOvpv9WS7ILLnGTE5iTfB9PXnUvBbCbPLgvo62VVekw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dh0tJfvWKXs9zjhEB7mNhhfzhFiA20XkriUGkV33yCc=;
 b=A1RwUo1q2ADHmuxPst7Fb9Zk/zAWjTNp9dbAgG4quedMqfiVFdxwNUYkjxa4/6iiItUB+I1dLT9iYyfdiH7X0OLudcubPUvDN15W9Cpjs462gk3ha/6oKk0CrA2j5T20WasWFlDBnE6DqObU6EWXJxiIvVDaLYdBXwc58q4uYPU=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by CH3PR10MB7209.namprd10.prod.outlook.com (2603:10b6:610:123::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.37; Tue, 11 Jun
 2024 05:58:39 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%6]) with mapi id 15.20.7633.037; Tue, 11 Jun 2024
 05:58:39 +0000
Message-ID: <c3789a4c-f262-444b-8234-8431cded548b@oracle.com>
Date: Tue, 11 Jun 2024 11:28:29 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: Testing stable backports for netfilter
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <652cad2e-2857-4374-a597-a3337f9330f0@oracle.com>
 <Zmd3XaiC_GiCakyf@calendula>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <Zmd3XaiC_GiCakyf@calendula>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR01CA0097.apcprd01.prod.exchangelabs.com
 (2603:1096:820:3::13) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|CH3PR10MB7209:EE_
X-MS-Office365-Filtering-Correlation-Id: be97da55-01f8-4178-76a6-08dc89db8a6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?NG8zemJxeTBvYXpXUlI2NXFGZkNkVzBRNkJGVFYvR0Y5aENlVVlKanZNMVdz?=
 =?utf-8?B?cDE1aHdsclFpV21hNk4xank2c201a3pseU9BdEk2WUhLR29xcU5PMm5GK25G?=
 =?utf-8?B?ZmloSHVRYzdWaGdLNkRBbTNEWG0zV3VvYmV5bUYrNDA1dFRBOGR4K1ZRTlRq?=
 =?utf-8?B?MnlUN0FtR2puMjBvMTdUK21BQ1JWU3JuNlVCVVBvUCtsVVpuRnR5RnVyRWsv?=
 =?utf-8?B?QUxoSjR1UytyQlpDb3Y5WU9rMS9HUnE3ZGFCWkdiSUtGZHNwVzhXcVlOUDFr?=
 =?utf-8?B?TzVXQVVRYVpuSm1zbmxZS3o4b25YL2Z5d0ZuK0ZFaEhUVkQrQUZMUDB2Q05U?=
 =?utf-8?B?ajFBMUYwemJyeTY5ZzFVWVdpZGs3M0dnV29wYmczcDgzNTB6UDN5YWw5bFdN?=
 =?utf-8?B?NHloV0xFYi9hck9pMURwbzNwNDFKaHpQUVRTb0xmNTZuaVlVd2hEUFFMaFd0?=
 =?utf-8?B?Q3pyS096RnJwdmxneW53TTRMdmQvS1B2M1hoQmtxRHJCZ0VYTEJjZzdYM2hS?=
 =?utf-8?B?R2k3Q3JYTXpvZmRrOEhkeGUxOXJhS1ZaekVGQ0NKVVFHenB4Q1g5MjhpNld1?=
 =?utf-8?B?T1RZc1h6Q2hiVGdQM3dKY0Q2NE8rWXZVNG1xZC9hb1ZWTVpJb3Byc1BDWEJD?=
 =?utf-8?B?KzM4QjdXTmRqZ1gwS3h5WnBuSTJwTUt5ZUh1UXhoQW9ld0J5SzR5SXBxSXFi?=
 =?utf-8?B?bExVWnVuUGV6UCszL05sMXQ0VEtWNVYzZE10bGZWRU1yQVJpbFZhS0twVzln?=
 =?utf-8?B?Y04zd2htdVd1dGlXRWZmYUJ4dVpCdHd6SFBEMmpHZ3dMVkxGSUhYV0psb0l4?=
 =?utf-8?B?YStZcXZwY0U1RWZ4MXo2NXNhOW1Bc2Q3U3ZHMTdyRFdXd3ozcWczTlJVaVdh?=
 =?utf-8?B?WlVXbHk1c0VOb2EydnhtQVVqdk4wcFNIcjBYZmJQTjNWM1hQd1RBOHE1VFBU?=
 =?utf-8?B?ZUF6Vm5GUm1PS05zS2pGdDRyYmtNMU9Femd3eFd5MEUyU1BXdmZrWnRNUVhD?=
 =?utf-8?B?YVdscmhwd2Zsd3g3Q29YbzBEa3RDUy9vem04NXdlbVVoZWVvTll0aktlUWd3?=
 =?utf-8?B?eEZOblFORllsQ1VCMzJDRjk1azZ4d053enplNDFSaVhZY21pMlVWdGQ2aC9Z?=
 =?utf-8?B?Z3ppVXVvUTVmVlROdXZWb3RjNGF0aTRZTzZlaklyZmljaUxLazRZcit3dkow?=
 =?utf-8?B?ZjdueFRzSmdMTk96MDlpeGhlVDlwRW13NXdHWGpzTWFabmwvSGhkK3J4YXRP?=
 =?utf-8?B?ajdVRGFsNzZmQnVENU8zT2o2M25BNTlVc0J4WFYyVjdjckc4c29aREpmREIw?=
 =?utf-8?B?dURWK3FOanhCSlVaM0VaMzc4UHFjQ2Z4dWxGalczaldkYXNTclYrbnA5TExh?=
 =?utf-8?B?T0FHMHRIZGRySy9sUVJPU1ZFMkpCWExjcVFhM1hod0U3NGxReEJNQ1lUSnVX?=
 =?utf-8?B?VHRhWnUyWFUzckFENzVLOXhaa2o4K0ptTUl0ZGhWNnczSUlrV0tGYk5hSm44?=
 =?utf-8?B?RllRREJHSHBURkp6N3RiZ0FGTUZGSGp6YXVxSGdSRjJkeFcrMDh4dlRvRVBK?=
 =?utf-8?B?SlArbVE3WWlaV1lmYXhhQ01IU2dGSUZFQm4rWmdHMDh1aXpZaTgxZHF1ODZN?=
 =?utf-8?B?d2ZsS2RWbE5NeFBYRVRFcGZpVG9LZFJCZkY5Z09VZW1LMHFxREVobUNNVjl1?=
 =?utf-8?B?SDZ3dWRjWXFLY1FpZzZWMGEwYzdvU0o5b3l4YW80QTlEM1RKZ3pEQS8vaUta?=
 =?utf-8?Q?g1mF0/Ea/LZ0LjbOYNLNMQfpPH3Dfsv8tdLRstB?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?cmZUQ0Q3MGhoTTB2anBYRWxHaktVTWdIUUpNZU55UFZpSlA0elZVakhINlgz?=
 =?utf-8?B?VmFkR3RLTXMvNXhKQ3pybVlQWG1yclVscERjYkxYWUhlMzNkaUhncTV5dWxS?=
 =?utf-8?B?SG5UK1lWSFJJVjBEQTdjcE5pK2IzQUpvcCtvbmxxWFQ2MkhMdCszODFqZk1i?=
 =?utf-8?B?V2drYk5Nc0pFTEJ5WW43M2czSFI3MGh4WksvTFc3YkR3QmtUOFJJOXc5Mmly?=
 =?utf-8?B?dHlGQ3h5eFVwUmxQT2JybFVYV2ZmeUhqTHVxblZZQU9DbW0yODdPOU40aXFY?=
 =?utf-8?B?K3B5ZUtodlQ3UktzODVMZHQ2UVVjYjdlR2JtMG1oUVNCdDNjVytybXg4b0Rw?=
 =?utf-8?B?L0ZSVjhTNEZHaWZKcEJvZnJ0MWx1eUswREJvV1ZVZjdHM0tsdmM0V0tOMklK?=
 =?utf-8?B?ZnprU3hwbGdiTmFXRUhqcERxU3BkUlRjM3NybGhvdndpVFZiNDBsQTFIRHVj?=
 =?utf-8?B?bEY2bFRRNTF3MmJZdGtwZkRrSmdlbkRVaHNTdFhEVVN6dnd0Z0RhMFhKRElt?=
 =?utf-8?B?cUdVbzVlRVJ2Z2w3SHJvNHVadWwvRUpPaC9FRCt1NzY4d0lWZlI4TWFIWFU0?=
 =?utf-8?B?OEdqTnVtaGppL3M1WUN4NXBBT2R6N1BFd0tydHRKemlhTXhUcWE1QUxLMURh?=
 =?utf-8?B?dm1IVnVoSkFQdmc3WnQ4VjhNK0hrN3FXT0h2VUUwV1hVVHNHaUVIM1lqaVlP?=
 =?utf-8?B?SXg3VkxKWERvWmk1S2dmSEhqSWFYZ2IxeWRUcUtiZzJ0RlZUcVJRQ2F0cGZo?=
 =?utf-8?B?d1hTMWxDSVFaZmlrRzQ2SDQ0MU9DRzRwMSthdjk2d1lSNlQ3NHpUeDlnUjh0?=
 =?utf-8?B?T0h0b2t1Q0JrMnRTMUIvTDc4aHBwbU1iYzczWEg3OEwrZDI5bVpicy9MUi85?=
 =?utf-8?B?WkIrakgwVlFMQVRZMG41MDdBaHFBZVVxYTFEb0o2L29OdFFpU040OXRxWWRW?=
 =?utf-8?B?MlNkRVo3alMwMHNtN1RudWg5RGwyQ2F3M0ZkNEFGMHo5OCs3SmYvT3QrYW1Z?=
 =?utf-8?B?bE1uQUV5d3RoNUtnY3R0QjV3OGYvRUEwc2p3RG1HTXZKVkwyb25EVk80SnpF?=
 =?utf-8?B?RVRHcmhvTjBpT1A2N3ZPR3cyZEtqSkpFMUttT0RGM2ZPaXRQNytJbitiVkVL?=
 =?utf-8?B?MEpnNHpmR1JCTk9vdjR4azNsTHc2L255NkpybGNtOW0xZ0RjMk1oOTF1T2p6?=
 =?utf-8?B?S3JoVzA0UFNwR1JCRTVabEhrZXM1Yjh5WENzaE5UK0V0eUdud0lQNEdvN0xx?=
 =?utf-8?B?blVrTHl0MmpjS1NuN21tWG4xVCs0cm50OWlndVQvYkJpeFI5Sm16RktXaDV0?=
 =?utf-8?B?clp6a3JhczZmUXRRZGFSLzRQQTJFZENCM0lWa1VZMlFKL0hFcVhKZTJWQzVs?=
 =?utf-8?B?aHUyWEFxMnNzOTJObnZmUWE5dXQ5RVY4bDcyRlJNdWZ2UTV2cmdybGRtQ2Fw?=
 =?utf-8?B?MUZGRTM0ZFhycHM3VU1uakRHYmxMVjh4eVB6WjUzRkVubFB6b2I3ZUdaYzdG?=
 =?utf-8?B?cE9ZRXVDVTRVTFRXZzVFR2tXRGl4YXdpejZFQWxVQlJ4MGIyTzR2ZkJvSWcr?=
 =?utf-8?B?bm11b2t1MHcwV0k3Z201NDQxRDEzMXJIbGFiSTJscnl4aGdzckpvYWVpd0Uz?=
 =?utf-8?B?RlJsMW1qSnpCMzNyaTI2YTcxa2tGM0ExcWFGRWF2dkVFQ1J2ZXVUOEY2dmVQ?=
 =?utf-8?B?aHRVVzB5c1krREdjSlV5bk1BZFl4SnZTbHRaYmZ5MHdBcWc0dllOZFRvbysy?=
 =?utf-8?B?b3JoVHVka3g3SldNcjRqZWxrSzJKaHJEWkRMYWVJTVo0MERyM2NUWkRYUld2?=
 =?utf-8?B?YkpRQzZJZUJHSjFla1R4UWsvdDgrMTFLTXFrTmIxNU85QlU5Z3ZtWkpKeG1K?=
 =?utf-8?B?Y3R5M2xpZVNRYUlHTlNDWi8wYlZBMDc5YWlLVzZ4eWRFazFHeExLTGQ3SU03?=
 =?utf-8?B?RGltdHVyQm1GUDgzR010b3hFd2MxNXh1NEN6azg3akdNei8yaEFkWXBzSjIx?=
 =?utf-8?B?L0NQNGtrZExNVTZEQnV4cldPYUJobTROSUpnWGtMS0JZZkpMc1JQU0FaSTR2?=
 =?utf-8?B?b3hHVGUwc0tqTHRJVkxDMWk5Y1RGU0VCTlhEWUNQQXdHYVZ2UUJrRzhKS0l4?=
 =?utf-8?B?R0xFUHJPV3dSNkxpbGZabXdDdWxRVjV2U3JaUTFuRkk4UEZoNFN1alZTcGxx?=
 =?utf-8?Q?u24zBm1CZwHG7rZbzISnWrw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Ua0Uj1+P/RLRAewGNs/4KQseAeqHj5i1B5qp8sinY7NshIJ9LBRREDUVbSX87pBrU2sYVS9ibFK1w1BCCYi6vthhNZSs3TtLYx7me0MjoMOTqvmwHnNOfZP4LSxBnOKKBg83kE9RN7jee5zBkxY3hoxcHppIsCd+d/w8xzm6LEjQxrC93yitrW6JThnLIsLJQpno09HOfIvQdAoDX0ceiP05vTzcBGMzCFIw863+9wnvY1BYpZ/TX347aD4fPN+BfCCHMEG1gX5eOntyY4KveFWPo5G90YCGb9iYLIBpyYgONvYs8F674YzBHW+B+4K3EL6h16advN7U4vtjb3ck8y1wZOGLn1oIbPsU6GsMc/zrG2b9DxxmiRWY0Rxo0iCwXDtrtfVqd++Q0m2P2IthCDUdfwmE/OmPger857kds0JuDxyVqAR3Bv8GuamynQMe7HoPL/wRA49mLpHj2YaxAhYxxnAvBTQIOaafJQbDMN11TlxZioChGeoA0Rte+aVM7BtuXw2eoh6f5rrq4Vc9xfgpdgMLit8cCey3hIMyaMXd0JYyHjnsor49lEvag3ds6kDS5Ipzm0EFt2sfj96+wsUcrF9Fw/Ej9QnxWdwHOG4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be97da55-01f8-4178-76a6-08dc89db8a6d
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2024 05:58:39.5859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: taWEsFrAwfYJJECrLiaq46z2zSuFivDmRIxBB8YZfbXnq6Oih9Nm+qpkvNX1Bx7BIKWPl2lVDhAFcu9YrikcL+QzjrSTfskJTfn+AdmCQ+gJvGRy9iCCDWckit7ngH6v
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7209
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-11_02,2024-06-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406110044
X-Proofpoint-ORIG-GUID: jZmS8CJky5chwFU332MKJf_e8BX_4bEj
X-Proofpoint-GUID: jZmS8CJky5chwFU332MKJf_e8BX_4bEj

On 11/06/24 03:29, Pablo Neira Ayuso wrote:
> On Mon, Jun 10, 2024 at 11:51:53PM +0530, Harshit Mogalapalli wrote:
>> Hello netfilter developers,
>>
>> Do we have any tests that we could run before sending a stable backport in
>> netfilter/ subsystem to stable@vger ?
>>
>> Let us say we have a CVE fix which is only backported till 5.10.y but it is
>> needed is 5.4.y and 4.19.y, the backport might need to easy to make, just
>> fixing some conflicts due to contextual changes or missing commits.
> 
> Which one in particular is missing?

I was planning to backport the fix for CVE-2023-52628 onto 5.4.y and 
4.19.y trees.

lts-5.10       : v5.10.198             - a7d86a77c33b netfilter: 
nftables: exthdr: fix 4-byte stack OOB write
   lts-5.15       : v5.15.132             - 1ad7b189cc14 netfilter: 
nftables: exthdr: fix 4-byte stack OOB write
   lts-6.1        : v6.1.54               - d9ebfc0f2137 netfilter: 
nftables: exthdr: fix 4-byte stack OOB write
   mainline       : v6.6-rc1              - fd94d9dadee5 netfilter: 
nftables: exthdr: fix 4-byte stack OOB write


> 
>> One question that comes in my mind is did I test that particular code, often
>> testing that particular code is tough unless the reproducer is public. So I
>> thought it would be good to learn about any netfilter test suite(set of
>> tests) to run before sending a backport to stable kernel which might ensure
>> we don't introduce regressions.
> 
> There is tests/shell under the nftables userspace tree, it also
> detected the features that are available in your kernel.
> 

Thanks a lot for sharing. Will try running these before sending any 
netfilter backports to stable.

Regards,
Harshit

