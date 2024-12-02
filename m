Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95EC70814;
	Mon,  2 Dec 2024 18:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733162806; cv=fail; b=rKjqW15rZBLPbvDklCP/sYs1EqR1VZDthx822WDKYA8SaT6XoDfY9y9UMMKPtaQZHhaf4J6izzFNHmEORW83hkJIge7zxeK/3pfUuDWxXcooHt/lE+KPpjkZOzBzTY38fET7xHxla91/mFgfmKf5mqj5/e0mPJA9ux9ar6QfexU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733162806; c=relaxed/simple;
	bh=9PlEDyqOx+iQ1+V3SqmD9rY9hrfhTyyYeq4GrQ9ocL0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XnrEBlk3pTktu5H+p4i73opeslbXawaiLDk6KMCJRHGnntgZ3nzkLWwwT+mjV0B08jOABbnNrSP0vN2ouIKGo5YbsDcvjjhOtmxO29tED7Xg45zPPGZ1n+0hy2MKu31MCUIS2WZv00fUnrIel6QHdEWHIVZ/KTkbQNTxC8cFRcA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CgVzXsct; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FwCODn8a; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CgVzXsct";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FwCODn8a"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B2HfePo014909;
	Mon, 2 Dec 2024 18:06:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=9PlEDyqOx+iQ1+V3SqmD9rY9hrfhTyyYeq4GrQ9ocL0=; b=
	CgVzXsctVzWhR/s1Dg9HUnEskAPzUVK8t5S4MlDxNDpmBeZIAfdTNti6CjgQyMAE
	vaSAstNUq8AP6VUVDrl1aTTfpb6HVYEr9+6Fs3C5DlYtqPROVP548X1uDm33ZyDU
	56rpnTyuvb71nyEyazVnM1orniqTMl+k7rU6jjC8FQG0bbdnc1aY6Ljwmp17G2LA
	npyTzJ/el5e8LQ9ELcwuodjb7K/g5ksfIAshBN2LB4cXnTi+OJX9yrboJk/0gmMS
	v1Lih2jiqY3MPE0nwMU2Aleh6xWXmIXCmSTJLMep3MiOjOWk0xiwwg7YTG5LDqfk
	qZJGNsCbP7P7HXO2za1pTQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 437sg24afh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Dec 2024 18:06:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B2HLwhb037979;
	Mon, 2 Dec 2024 18:06:06 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 437s5797mu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Dec 2024 18:06:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DnSF/XilKkUpcNDr2bt5Icx+VupCaoAJHoHcMFpIcQdxTtXrqdXaGxeI1s/0iijI1PIrfRbKaS4PrlRvD4yRaXqHe5TpOKDf44BYvt6pPdOyrejKBR8/XbeG6v8ypei4gYjoRV6/B5tnR3vxbTsWOywOg/eaf6eyEmfJpnQ92De/vNJXn/Uwd98ClwYp0Dc49rFGw+9a7Q1ovtrT+XLjnKJ2L5kzDabO1LKiSvNI5y0kVyA7yQLoambfa+CrBOxQRX+1juLHcaXdYcxSoQNaB1db0/F0J+bt+a2s3rtQTvZSNv7sWTeYp8KjyMoD0WswXscMT8XfSdBon1iwS6uhZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9PlEDyqOx+iQ1+V3SqmD9rY9hrfhTyyYeq4GrQ9ocL0=;
 b=NmuhEtPEla6rb0+hwv/WBN6aiug/y97kOGmafFZO+18VRRyAexvbgZjaNqQYjDua/8GMplJWqGsa2x6gZNJ7DpXaAURCHeJo+sw7z2NebAJ5VBjqwYD1rVUwkRLME2mjrxetyPgeMpkdyGQl9kNGTphGbyP7wqFnW1kQWhJ/R1OgI5joLNkHhfxc48QWHiWUaNr24fdYvmj7ujeUmvx4/60lcBve9jxo4UKY73C9AsvNIjGwhOy9hKnskwAoUnrsTgJB5acLRaZm5n+AA/8KrHlKDPj2kkVneqtMgdi23JkhhqMbYLhZwBS/adjS5MDsJa2pzpNmy08MXvXgD4LcDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9PlEDyqOx+iQ1+V3SqmD9rY9hrfhTyyYeq4GrQ9ocL0=;
 b=FwCODn8apbVKiYdoXaPXzxOIzjk8pHnlO1KIeVX81wI/kAN+bq9VlQLT4kmQy80h6RaHpnAF53q6/CGbgkbvGwoTYv8Wc9Yy8m4mcOlmDUNCx+HoV5rRxQlBZu2PQY2wjMsd1mEupGoX4P+/L/Rz2ekrqQu+WnMtz0WPiZtU+ZY=
Received: from SJ2PR10MB7860.namprd10.prod.outlook.com (2603:10b6:a03:574::11)
 by DS7PR10MB7190.namprd10.prod.outlook.com (2603:10b6:8:db::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Mon, 2 Dec
 2024 18:06:03 +0000
Received: from SJ2PR10MB7860.namprd10.prod.outlook.com
 ([fe80::3c8f:5ef8:3af5:75b8]) by SJ2PR10MB7860.namprd10.prod.outlook.com
 ([fe80::3c8f:5ef8:3af5:75b8%6]) with mapi id 15.20.8207.017; Mon, 2 Dec 2024
 18:06:03 +0000
From: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Florian Westphal <fw@strlen.de>, Eric Dumazet <edumazet@google.com>,
        xingwei lee <xrivendell7@gmail.com>, yue sun <samsun1006219@gmail.com>,
        "syzbot+e5167d7144a62715044c@syzkaller.appspotmail.com"
	<syzbot+e5167d7144a62715044c@syzkaller.appspotmail.com>,
        Paolo Abeni
	<pabeni@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov
	<kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pablo
 Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik
	<kadlec@blackhole.kfki.hu>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>,
        "netfilter-devel@vger.kernel.org"
	<netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org"
	<coreteam@netfilter.org>
Subject: Re: [PATCH 4.19.y 1/1] inet: inet_defrag: prevent sk release while
 still in use
Thread-Topic: [PATCH 4.19.y 1/1] inet: inet_defrag: prevent sk release while
 still in use
Thread-Index: AQHbP30BKKQ7xQRXn0ulbtmWukeRN7LS1taAgABz1QA=
Date: Mon, 2 Dec 2024 18:06:03 +0000
Message-ID: <A4268D36-F178-4138-B266-A2D88446AF5E@oracle.com>
References: <20241125205944.3444476-1-saeed.mirzamohammadi@oracle.com>
 <2024120254-glare-crust-e398@gregkh>
In-Reply-To: <2024120254-glare-crust-e398@gregkh>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3776.700.51.11.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR10MB7860:EE_|DS7PR10MB7190:EE_
x-ms-office365-filtering-correlation-id: 48c34bba-28eb-419a-5c41-08dd12fbfc32
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?UXhRSnBKUlJSV0FPOXlYTElnZU1uaklXRnJNMUk3M1VIazBoTzJEQ3J2SDVD?=
 =?utf-8?B?QjlIOUh2aWFiV1l2OHRuTVlySHNDSjRTd3NDU0RDcGZBODhWWTJmdGw3L1pG?=
 =?utf-8?B?cHI1VzZKK2ZZZDBmcWVKc0Q1ZlFqcmRQQkoxRVFOZDBoZDI2Wnl1dVVFV1ZZ?=
 =?utf-8?B?TExoRldVYU0zR1VQQUgwQ01KRDdiQ2NkZmg0UW04NXJwVFI4NjNMZHNMQ2xR?=
 =?utf-8?B?dDZNaWRKSUtiY0l4K2tjcGJUTlFxM1oraFdkQU9UTFd0bEFMVER3WTQyVGNz?=
 =?utf-8?B?R05kWlhwbmkvTGpSM2ttNlZrWWJZTHZORHdUMHpVZnI1UysrenFuR1FGN2Fk?=
 =?utf-8?B?ZjN3QWFXQzd2akRwMG5EM3NIS09LTUluNEsrNnNaMTdBYnB0WkI0RGY0aHVj?=
 =?utf-8?B?UE9QODFEL21JQTFNeUFmNCszeGtEbSthcmc5NUNQS1QyL0JHeCt5c1paM2k4?=
 =?utf-8?B?ejZHVVVMMGJWV1NTQ05ZT1Z4VnJvUkpqS3FPSWNnR1NTVk1HRWx5eTcrOW1S?=
 =?utf-8?B?UHpYSTNXMHpxMW4wakt0SlpiWVFQVmFxLzRUaVdSSGduOFJSZHQvUUEyU2hk?=
 =?utf-8?B?L0ZJRjM1S0JNNnFCaXM3cE5BVWsxcXFENlp1UndTdTl0ckhiVG1XT2pnOFdi?=
 =?utf-8?B?UnYxdUJuVnVQWHo1YWxYeWhsVER5THFLa0RERitzVFRRN2ZNbW1KVmNJMFEz?=
 =?utf-8?B?S01Jd1lJYkk3a1lWam1nQWFvTDBJY0Z2TlNLdTd2RURDeVhNa1E4bUFWVEFt?=
 =?utf-8?B?bGsyWE00MzFpdTFGTFl5VzBLSlJHU1V1NWZHRWZLZkFzVnBYNHlhTU9uVGRt?=
 =?utf-8?B?T3lNS2tGMzNPUGJLazYveGNVTVBBR05SeHJVY3Fsemd2UWdvTWJubkIxM2hB?=
 =?utf-8?B?Q1lDQU45V0twQS85Vk12YURwV3pYTWs1SFlmS1k1Y1FRTnlHWlBjcEhiSk82?=
 =?utf-8?B?bGp6bnk4ZEpxMjl0TTBDYjRmZFRyd2ZyYmNWQTlLNU5kWVlYWjMrNVZSaVl6?=
 =?utf-8?B?bTZvNUNTM0R1S1E3RUhocEI4akpJUmhTL2I2UWlOdEx5ZTNLaVp1a1hLL09S?=
 =?utf-8?B?enAydmlMcncybTEzZnVsOWtUZWpXUDdPQWw5aU1ncGxlV2NBQU5HY2srNjhR?=
 =?utf-8?B?dnlaSVRjS0t3THVLY25ReVVxVllWZlhEMXpNZ0R1MTlSVHJNVW9pSlFOdTNo?=
 =?utf-8?B?L1Y3TkdmRlBDY1crRStUR3dacmRRb1psSjlmZzZEYVFSc2sxYlYzY0RUTEtD?=
 =?utf-8?B?YkRsVjJWRWhHVkZRZU1JeDhpaUt4bE1zZTdRZ0VsSmtUUDh1UU1IeVBnSXFr?=
 =?utf-8?B?RTFLVGxZUkJvU0IwdkhCTUwvVndmY1E4WG5ib2Rva3VZMnBlQVRSTWtJWmpV?=
 =?utf-8?B?T05FUlZtc1NVY2YweGNRcUJCZFBwZUVSeDJUUng3OUk1bENka3BwWXczMmdw?=
 =?utf-8?B?QjR5WjFzRUVqSXNaYlEzalFGM3NLV3ZLUUR1T3R1UHl1Ymt3UHJWdk9ydnZm?=
 =?utf-8?B?YzJLQkY1cDhiMmhsbWlUWTc3YW9BSnpDWjc2dFd5TTJpdHR6WFFxNi9PN2wy?=
 =?utf-8?B?aXEwVDVEaHlMalVva2pHelJzMTNEK2F6TEJBYnl4Tm9zVyt5TDlYcXlZL3pY?=
 =?utf-8?B?eTJsNlFnVXdGUTlETGtQWmhySFlFZUtNOHIrcExKbitJeGRiMk4yczlPSnZI?=
 =?utf-8?B?UDZsWURHdUNKS04wSWwxS0pJK0ZxbG9NRjNxWWk5UDJ6VnhzNTlDYms0a0NB?=
 =?utf-8?B?UVcrVDFQZkNSOVdHK1FlcmVWdWhmNUo5RnJuTER3UTVTRmxIL2lqdVdNdXpz?=
 =?utf-8?B?K0xwa2RiZHlMUjAra0xKMWNKVEFHT2szTnIwZkxqWGZQRHdzT2VELzBFMmVT?=
 =?utf-8?B?TDRmL3RVWkxIRjNZMEpELy8xVmw1bVAyQklVdmVXN0dDRXc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR10MB7860.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VForSkdWMmtBdzBESk5zeUdSbWFNVnlGT2RwTDlLYjJwbEdrYThsY1ZWL1hM?=
 =?utf-8?B?Z3VMSUNJZUpWWHJKL0U2MzdIekp6QWdDS2YyOFZ4TENaaWNGTThObTIzczll?=
 =?utf-8?B?azZDd2w2NWQxRmEyT2NpendGSmE0L1JDOUttZTQ1Zis3b0lPNVBxeGJLR3cw?=
 =?utf-8?B?UzJ0TTZDZ2RLaS9wYVQwQ1pQUGRQdndXb3UwWE5MYVVidmhxZmI2blJPZUli?=
 =?utf-8?B?N1JHeEswbHByRmZXd01oMXp5dHZRS1hKSVpkbGFOaU02R25jLzN6QXZkNmNo?=
 =?utf-8?B?bTBVWFNEQkpkMlJOL281emhwOWhseVJQSkI4WDdGdDZKSUFMSGwxc2x3QkdU?=
 =?utf-8?B?a0ViYUVXUzdURUlpN3l5OVN4VDI4QVpFcDlwL2l3WFJTT0lFN2JwSkJ4blRY?=
 =?utf-8?B?eU9sR293TUlBellUV2NTT3J1T1R6VkVwd3lEY2R3UW5FNmI0SkJCVFJJMjBy?=
 =?utf-8?B?UFdhMkp0UzIzaUZ6TXhBbDNSUWgrbVlXSUNLd2oxb2t3bTVZbjhmeG96UFlZ?=
 =?utf-8?B?WUwyN0NGeWQwN2JqaVU5a3FMMnpCeTZ1clJuQnhhd2Z4TnVxdVJ5L1U2bU55?=
 =?utf-8?B?OXVXNWwyUjFCdGxDMkRuUlI2UVgrTlRyMk9aT004ekM5bm9BWGxyL1lYZklR?=
 =?utf-8?B?dUJyVEtuQkIySTd3bGJkNmdDQy9XR24yekRHZWpmaEdKL01tV2ltMEJjK0t6?=
 =?utf-8?B?elhVZ0UzNGxKQlhKcW1YQWhnZ3EvWE5qLy96eGtzMlZtVkJMTE1rYkgzSm9O?=
 =?utf-8?B?VERwaDJKNHB4eXJmakNxanZDVzVPTDdRZFNkaVdKanljVDVEL0tBYlo1K3A4?=
 =?utf-8?B?RGVUVE4rbVlQd01URlBzRGRLbmNMNWQwUUM5TTRpTWdjSDBNcTQ1UnVCNnhO?=
 =?utf-8?B?K0lqbHRFWFNHSU1aOFJqdlhlQU01OFFDTm9PNnNsc0tNRjJqYmVoSHAwYlN4?=
 =?utf-8?B?b0VoZUFFM21oR09tNFhzcXRrbGlkeG5IRzdKbGNmRVNvcVZtcUVZdmNKZ0Rj?=
 =?utf-8?B?Q00yZU9kWkhGNG4vRXZRY3FQUG1PTWhYbkVHaGhLeUM3RTZEN24vQnpGUWtm?=
 =?utf-8?B?cjdaZTQ4aE05bEYyT0xzZWF3TDI0aWxjbTh5TDJOcnR0RWdtKy9pbVowMWVU?=
 =?utf-8?B?N2VnaENGRGl5U3M3WXA5TDZFcWJXZ3dlb3lub09JWStkMkY4VEw0eUdwOW5k?=
 =?utf-8?B?aTRKTnpsMGFFdzNPdGVHL3lZa205aUZBT2J2b2w0U3NtTkdtdnVyVStFS3pk?=
 =?utf-8?B?RGtoVkx3SHllblhlQ0tJdFRwQW5NSkh5VDNUWFExUndpN3REdm5aVVUvaURQ?=
 =?utf-8?B?d1pqamd6aTlmNFNDQzBPZmZKSGFqNXFmbG9WMk1wVnVKZ3U2SEsrdE00UzZa?=
 =?utf-8?B?cUtDanNTbHNHcDBHd0xKU0NVcnVLSDdPaHU5TXhiWnZ3WVpSRlo1b2Y2RGVa?=
 =?utf-8?B?eDQvZVBvemNJcldqR3FYV0tqdWxqR3RkNUlxN3JXR2lzMjdiODJ5NFJscGFj?=
 =?utf-8?B?MDdSQkJMcFpBQyttTkFsZnd3YytqZjR6ekJMb0tySlFqQjRyaUZ5a09XcmRR?=
 =?utf-8?B?TGlkVGcrSkNubU1Vc3l3ZDZ1cGVZeVh1ZGQ3cFZiVlNSM1o0Z05KTzVOM1lz?=
 =?utf-8?B?cmxpQUF6bVZCTVR1UFdDc2pjZG9vNk5PbStNT3BMaTFMc2hMcm1YQ3dZVjI5?=
 =?utf-8?B?MmFKUkhQNEtOS09OcFdJWW1nZFVPWEY4bXVTK2Z0eC90UTRNSm5sc1hRZlVm?=
 =?utf-8?B?SXRldEhrTktiQTgvVVNOWWFLNy8wUlJjZjBRM3NsbHYrcXdqRytrZmJPSmZV?=
 =?utf-8?B?a1gyM0lvZkVxZFd2TEpwdEtydEtueE9HWkdwdUNBUFBiYmxZb05zS2lkL0hW?=
 =?utf-8?B?OHZsZjNxUXZIeGdYOGhLbm9HNlpWT1ZSbm5Lclp4cmdqYno4NUsyTGpnTW1y?=
 =?utf-8?B?SnhiY1U1QU9Vd3MrUGpxdHVYK28zcU8xdGJYREFPU3JycjIxL3BTWVBQTDNJ?=
 =?utf-8?B?Rlc4dHFqS3RFODl6TmtzV3N6YnpLa2svb1F0V0NmMXR3bGhKQWZrVGxzYWdn?=
 =?utf-8?B?QU1nRFlxK242b0pjTDBIZ0hEZkpQYzk0THRtOGFlQ05tRXROZFJjMTVRUitp?=
 =?utf-8?B?bFdtL1YvL2hGUWZzWVNxS0NNbnJ5SkdDci9NbVV2VDh0TytGOHM3eWxOY2gr?=
 =?utf-8?Q?0aiJHhlmhPrgqe33UaKYcfE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D8F9C3C3E7278C47B03056AA6575FDFF@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3w0snr/i766ZmwDhrXqB98vcWtIKLjamLSAqMiDcbPhMax4iEJoRush3nVrO4UEkpr58PrjlaReLcD2yxPl9Dyf85FUpWbteyGhNhDTfI5CmiVn3QwPPtpSotz1mRRt82l6xZ7TG/+Gfck9DWdYH8SUULG3PV9su4NCcDsY+iUE90yknm/Q7++6js0qq9rgMKy0oEj4MLxI4FgG0QDnn8s0W44OnzH85yWZrdBsxlUt4Obw8mKhOqqrcouS7n8Ol3y9ax/B+OAe7x3jgByNc7pwwfXI3ZbBLOhfjcPIaOjlZcIkxp8zt08xHMlerPdTxq371brFEu69HzkdqFKxF82LSt0cBrwKZzJMm71xpb/TAgfUTQJKeL0l0d65qyLp+MDC5RIbOfg97zz7bEWuq/g+Qi7tg3B4IZNEHfCNEjIPuxF3zvcDg31rX/FRCo44nIxy3XxixcLY+mNX66Ykw+IkT3b1f28EVC+G7auwiU3MjmJKgnGaft/0naadaPrFahH+vDl3eLT0+x6lRYb/7dpQxt1PuZCGgkkgrWJ6lW9ZaWcZnWaA4BXTXD6MOikuA01ovwismsoTDqkn/6NLjmzrWIab705YuNZesN0gDkqk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR10MB7860.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48c34bba-28eb-419a-5c41-08dd12fbfc32
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2024 18:06:03.3290
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JM76ie666z4pcZuYHjtTiTOwyQrxaIz028Fog9lilvr+4KFGgmKfQcTQsRMg2uqgaDCoN4S/vP4mHTUO9KYSJMYZvwWRBo/PDWTJftLdOuk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7190
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-02_13,2024-12-02_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412020153
X-Proofpoint-ORIG-GUID: JoOPekL92RdNuJqIKfVnGQdBb5LMnlZY
X-Proofpoint-GUID: JoOPekL92RdNuJqIKfVnGQdBb5LMnlZY

DQoNCj4gT24gRGVjIDIsIDIwMjQsIGF0IDM6MTHigK9BTSwgR3JlZyBLcm9haC1IYXJ0bWFuIDxn
cmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz4gd3JvdGU6DQo+IA0KPiBPbiBNb24sIE5vdiAyNSwg
MjAyNCBhdCAxMjo1OTozN1BNIC0wODAwLCBTYWVlZCBNaXJ6YW1vaGFtbWFkaSB3cm90ZToNCj4+
IEZyb206IEZsb3JpYW4gV2VzdHBoYWwgPGZ3QHN0cmxlbi5kZT4NCj4+IA0KPj4gY29tbWl0IDE4
Njg1NDUxZmM0ZTU0NmZjMGU3MTg1ODBkMzJkZjNjMGU1YzgyNzIgdXBzdHJlYW0uDQo+IA0KPiBP
aywgYnV0IHRoZW4geW91IHNheToNCj4gDQo+PiAoY2hlcnJ5IHBpY2tlZCBmcm9tIGNvbW1pdCAx
YjZkZTVlNjU3NWI1NjUwMjY2NWM2NWNmOTNiMGFlNmFhMGY1MWFiKQ0KPiANCj4gQ2FuJ3QgaGF2
ZSBpdCB0d28gZGlmZmVyZW50IHdheXMgOigNCj4gDQo+IFBsZWFzZSBmaXggdXAgcHJvcGVybHku
DQpTdXJlLCByZS1zZW50LiBUaGFua3MsDQoNCj4gDQo+IHRoYW5rcywNCj4gDQo+IGdyZWcgay1o
DQoNCg==
