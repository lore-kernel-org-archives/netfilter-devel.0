Received: from mx0a-00015a02.pphosted.com (mx0a-00015a02.pphosted.com [205.220.166.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A14D1531C1
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Jul 2025 04:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.249
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751430238; cv=none; b=rhEZeFcJGjz7DoqAnr4oJzrmQVsGZVZmh+t8r0fJ+wd2rnAgKdwYvRQNJLAF567PqqyGw3mm2oias531R2lfXl+KyLKVHS8NXwbt55aB325QR4fHCg9PGl5fDQhZyEDUBHUyEXSqteUrXY974kwkbrJ91Sn2rHbF/AKN4/o2Sz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751430238; c=relaxed/simple;
	bh=P2uehaPl4ppa+jjwzLvtO86UKkw7jEele2WeP8y8coI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=K7bahjlgX2DQ5VhV/UAzbCeDo6E8hMIQiWQ1rFJDR7T58QHR11HDj4WvkN83+xh9B+qO78oVovavXg6zAzELzMhQvOzgm8JUW5eRtO89encwhFOb4xDjY7vvS0j+e6LTZosIj3OaUiD4XgfqjbA8DVWVisyO6j1MRt/N0kPTP8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=belden.com; spf=pass smtp.mailfrom=belden.com; dkim=pass (2048-bit key) header.d=belden.com header.i=@belden.com header.b=Z2pxY9r9; arc=none smtp.client-ip=205.220.166.249
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=belden.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=belden.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=belden.com header.i=@belden.com header.b="Z2pxY9r9"
Received: from pps.filterd (m0264209.ppops.net [127.0.0.1])
	by mx0a-00015a02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5623FPW0015925;
	Tue, 1 Jul 2025 23:51:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=belden.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=podpps1; bh=/n
	H1y0V9g4TUKwWsXOHPHDfLhUD32qsVR827/w8KMj0=; b=Z2pxY9r9S+RV/fOEDK
	H603VC2HKZGJiYjgSontlLsfGXQCEAr6f2og+gZRQ63ROWTNY8nIYKnfiPcDn5dB
	qtDdBpAHpK2Y8gVjfhfDrqfrsOvCVqJuRfnQsNXq4t9jJJuXgxfpcW/pLWXT08Sm
	NoLGDAj9nKwXSRCDxrF/bIB8qcKUbuRUsgVANrdO0kNR6j4uzyXX9b3qUWnpS05+
	R+ZyevH2JGVl14ykzva0TSqqzLTpYX1/0LLU0ryhQTYm3sULoV/QARz0UazW4c04
	pumziX6k71Fk9GYdUk0pyTHHXzIiOCgRNAuDCSLTCljhsIFDKoGBnAcx4TTaDZfR
	REKw==
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2108.outbound.protection.outlook.com [40.107.92.108])
	by mx0a-00015a02.pphosted.com (PPS) with ESMTPS id 47jcqdpnkg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Jul 2025 23:51:41 -0400 (EDT)
Received: from BY1PR18MB5874.namprd18.prod.outlook.com (2603:10b6:a03:4b1::7)
 by MW4PR18MB5108.namprd18.prod.outlook.com (2603:10b6:303:1b7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.29; Wed, 2 Jul
 2025 03:51:37 +0000
Received: from BY1PR18MB5874.namprd18.prod.outlook.com
 ([fe80::87f6:31aa:bb07:965d]) by BY1PR18MB5874.namprd18.prod.outlook.com
 ([fe80::87f6:31aa:bb07:965d%3]) with mapi id 15.20.8880.030; Wed, 2 Jul 2025
 03:51:37 +0000
From: Sven Auhagen <Sven.Auhagen@belden.com>
To: Florian Westphal <fw@strlen.de>
CC: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Cannot allocate memory delete table inet filter
Thread-Topic: Cannot allocate memory delete table inet filter
Thread-Index: AQHb5aNNhZSA/ulCI0+LraAw182A4bQT78SAgAno9ICAAGSPfg==
Date: Wed, 2 Jul 2025 03:51:37 +0000
Message-ID:
 <BY1PR18MB58746682D8242701C8ABEDBEE040A@BY1PR18MB5874.namprd18.prod.outlook.com>
References:
 <BY1PR18MB5874110CAFF1ED098D0BC4E7E07BA@BY1PR18MB5874.namprd18.prod.outlook.com>
 <aFwHuT7m7GHtmtSm@strlen.de> <aGRX3xYlWBxFahbm@strlen.de>
In-Reply-To: <aGRX3xYlWBxFahbm@strlen.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY1PR18MB5874:EE_|MW4PR18MB5108:EE_
x-ms-office365-filtering-correlation-id: 5caa6715-f5d6-4d9f-e89a-08ddb91bbeca
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?d1B2g8/8V3vZflYk6obQtcg/UFRtqgzsxI1b/z8HIIXgi5V79725iTcYyV?=
 =?iso-8859-1?Q?OlpjDm3ok+76uq48Vu3TrB1EDxcaa/fo2v3yXNyoyzy0JBZCNPsEqfJjw2?=
 =?iso-8859-1?Q?oxUMp0jcmP317Kj0ce3A2gN8n23B5KHVK20X1Y6MbERvrwfhP4y8q36Vz8?=
 =?iso-8859-1?Q?9hxF1LEJgn6eB9VxgvLF4Gd/8/nlhbXgkCmUFd5Hq6m3FnLdYXx+j/EcTj?=
 =?iso-8859-1?Q?hOyJfE+5vf9wHdqhnbUXixvaZ7tGHbwX9CKryqbb/GijLFsIUrJugiMB7L?=
 =?iso-8859-1?Q?PyAI2qf92d6IJkhIRD8HGbAeYZUaJVTQ4DcM06Kd+CducRunijwHsseh1S?=
 =?iso-8859-1?Q?7s1I1zamGhuaezvX6aqzaIsCT79dQiiC1WL/td3n6s0BklMQyJghTt4iqO?=
 =?iso-8859-1?Q?DL3ZOiymxIzwWLvKFl/Qe9Ue0jjSNJvd/RVhwAMIkZPhX7uBOfKS8G30OJ?=
 =?iso-8859-1?Q?LBJs1A/ljZUAYVS4tklLqqnRifqR30WBKiD0h10bJm/fHT5d7/6mZjfxcm?=
 =?iso-8859-1?Q?tq3Po9BDy+vOq3ybdQEx0eAIOcCbtrz5w6gUYHwhAyKW5bVQlYaZI3alaf?=
 =?iso-8859-1?Q?pJdZttH03dJhoPHqytJAQYk3UoGkTIslcOh+gMbYFP9YFBMsiGOaGWTX2h?=
 =?iso-8859-1?Q?IrYr2Q63vFiulIKaUk6JVa5RRZKAwybxNdCFDuXBVjGO3TqDFBxDEYKTh2?=
 =?iso-8859-1?Q?fYTgyul/ZPQe44GZAmnc9Ab+xp5XJqxE0F7YStG6LClt31t6wkMBGue6m7?=
 =?iso-8859-1?Q?BFKGUP29ZSdLFz6mu4tYI8/7TMjhPHL5tfxeUd0c64oCK9CF+SMtaAFUI2?=
 =?iso-8859-1?Q?Su/TZlgo+CxjkvkWe0j6Q5ZHjQ4k0vWcs5gafkzDzXpUrdrQ2K20xdodd4?=
 =?iso-8859-1?Q?pjGDvvGBT3sezgShFjOD6uhLdhHEIPmDsVX3vZix3VbgApzQCJ3bwrhtQr?=
 =?iso-8859-1?Q?AJL6Cmytui0FCBJo40YKXOlH9qDMJOT1zon6U6pe6cgI09p9twv5C8ph58?=
 =?iso-8859-1?Q?YJpMYUD5CgYUcn3GYqL2xpaDZAafSpZwFxOPfjxOi6/0k62PlBNTpEPknU?=
 =?iso-8859-1?Q?/aO+mA+zoqMj+At4nK0wW+zxW/IBxBMQagtdJJNxSSzxopMPQn8jA5ZqmT?=
 =?iso-8859-1?Q?C4e95yakdK//DiylMsVGEUwyN7BTPVOwSK06lL4dwooH4UIRYvnYV6vLPs?=
 =?iso-8859-1?Q?G5kpSijohmBL61g8MXMJYRQojG7qfosBbtP5glMA2YO4SKinleLrA+JjIK?=
 =?iso-8859-1?Q?NOLQaC1fB7iwzMLM32WHieb60Lbi8n3hA08ljDqVARVdjqMC5tkaNqjSIr?=
 =?iso-8859-1?Q?u/thAeI+Wc8asgdCr1ZnLbkLhXDaB4nOIxHyR2q9LzoeWlE4uuj9EXXxSe?=
 =?iso-8859-1?Q?SRzfVx3ZkkmwJrFeHm5HFk93F/c3kQ8zbISVWoJyZtwdjxM/PcpmBhfAny?=
 =?iso-8859-1?Q?BttDCz3POnFV0csWnIyqRjEVXdzDEhGS0IAVqNX1lBtJTFlVNvykRc/dFv?=
 =?iso-8859-1?Q?dy7h95QyJmL3IYL8Daymkh543AI5PerGaBo7UMgGbSRmlk8hSw7ogKQcPX?=
 =?iso-8859-1?Q?macOiaM=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY1PR18MB5874.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?bhRfQK8RMg/Rh7wMbyeD5eThIhXh79i2AY7I1pNtgDWOO6sh9ee0EEl/ZO?=
 =?iso-8859-1?Q?K5w4yOjf5TRQtcVpMLBlDKbntyMLlsd+Fva5YdU8l2W1CAfb0PzzfTNFEN?=
 =?iso-8859-1?Q?W7DwkwfQ0y0KX99ScBiSaqpu5Bx8PhMeYKMjfA1fdJ+7pjlLmgeOxhectw?=
 =?iso-8859-1?Q?Nafy0P5kf7+B5EO98wK4+/5yQQyi8haeCm9UW1TGj8zg10QQIaZXYM6ohr?=
 =?iso-8859-1?Q?JeSJOThxPdYhKVBn+1TG6WSLTO62xHduFxx6ZYg0iHLFxwznMQAX9XJKtq?=
 =?iso-8859-1?Q?g6eFCtQTQCHp3bIaJVupRYEVqky64s78vlzDnPvYNSr0g5VYUZ1xI6icT4?=
 =?iso-8859-1?Q?K47R4SWGjGEPkvE8a6YaVciwHDS+YfqbFCZ2QYlYAWU0KE15tQd67nlt4j?=
 =?iso-8859-1?Q?qIh0GYPSDuSFNd6tQ1eX28gCZRvB/K48Qh+xdDYwg13+4lkEDu52/c2BoG?=
 =?iso-8859-1?Q?e2ZL4j2NmTFK1anMBu8lDa0O3X4wHxKSEGC5makFnwTVZBBo4A6/4eyHOv?=
 =?iso-8859-1?Q?5LOnFyvkRuZ5BbFgGh2EDcfs3q+E0vkl2d1pBG8/92jLk0lB5n8I6j8i0a?=
 =?iso-8859-1?Q?ffYOieCTP3PWZ8YIR3ys1uGxa2jwF6TuIgLt8CHm0wpzhY9ZUgVmJiJGp7?=
 =?iso-8859-1?Q?0UVdvLPGSTBGz1bUcWIcqoIiCuuGqWdRVzB9eaxMxHMMJbIP5FDZYafbA9?=
 =?iso-8859-1?Q?aVMuhkOyKyGm2yyOMmAem7B5Y74zB+HgMZIYZNkAiY5Zhi/71P0lQdvDlH?=
 =?iso-8859-1?Q?0b1HtbcxgkjppDzHG0nsBZTMRpGrPSrKVInexWOzm5znSC1vYvtokOBC5Y?=
 =?iso-8859-1?Q?+ns30tZWHaYPW/YvtZtl0KpLd5X7mu2RemfIPsXW2yb83N+1/qkdaEpSNm?=
 =?iso-8859-1?Q?Xut1SBhXVruUO7fZuBV4X8M9H7PJ9mo1v5O4f1bb7M3/wMzDtsMe9W0YNL?=
 =?iso-8859-1?Q?UQnpfUv8cwS6TTIo9F2BZtAf0tfmFXSh2KP0lHf8yDz5IIL/9TUa0pw7Zg?=
 =?iso-8859-1?Q?rDn8Iul2L5k/z3IG4YTTF6WL8YfeR5US77Y4D4g17cC6um5jSMGvdhGzX0?=
 =?iso-8859-1?Q?uCr+/SG4cmrkcvSI4Qf40cngQLdFfQcfvaVP+pZxEjWMI1ZMfFR8950tTW?=
 =?iso-8859-1?Q?OfGZ/1Kvs9B8tabolRM8fRQ68LuKUERdYsn0FhfaDRTrYsGFiiFEotDZ6N?=
 =?iso-8859-1?Q?ecsFGjBlItG4RgEqfTVdZmXeCBkhOIgvZ2pxQfjDwhv4qWdUg1od+35BUD?=
 =?iso-8859-1?Q?5ZRhVzaJzRe7mOLkmsMB9zCl29fWV5s9aTVp7lWHGwMuSZtSmSzREM9uT7?=
 =?iso-8859-1?Q?5YbBbvEFZaREeOH0iddonKFiJjp6HDk6rgpw6kgsBZtABdQIP+hBJm+MNt?=
 =?iso-8859-1?Q?q9QXRe0rBNXfSHFLs87OklxpcjZsD7Kv4kKE225yonf5kamALAn+2WAc33?=
 =?iso-8859-1?Q?cbV6M+sksAl7Q+XPv8aakA5ZUBisbXnkL0m4UtwSvhzVA7PcXwoQ0RQfnY?=
 =?iso-8859-1?Q?hAiUS0+E9o0kquKOIqxN7kfJGa/9mb6Q1kwL8AZS5GJsK/cuHxPxJFa2jm?=
 =?iso-8859-1?Q?5v5k5WEf4amph+/t5vaYDDyJFRaLA0oqSC+De0vtKwGdVhYiT4DVk30jRV?=
 =?iso-8859-1?Q?fPlw10GySoeDCHVrOTTv4Bv155Oj5WpveJ?=
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xLajeVKITlVtkOmORape2SvjLKbWzTeXP84ipdVlWdeJbJjL9CTffoUXwApd07MPzPO9OOsEM/oMG1oxZerzMp0DW4/2nCjX4xAc1LyxqMsHqORirKRA5DeqIxWtJro4RW8o1Z+HwgLOknXhK7WdppcYF0P734BxpGwCZrcvfiH09s5XU6AzdvtKag3ob/jkxu9rgk00bt151c0ZU3G7TSIy9Dz0lFCOPenZ10Sb2xl5PNDiAjVhpfom6O8tApgTA8ZgAFlYZ0tT7UmwBUHAxYz1zTSXeEofCKoDwVN1WLU+gapblLXbvY0fn9Aq2FtGP/kYLgl1OXA52ZkNP3z7QyXGRd9xDvwOMEp02gkMEI1zbk/DJNcMc8mkhmRS0W/zaKHeSjJrSe1SXiKVtipkSWUS4+WHUj2EEGJbvbOv8cBABb5kalnonDyIFN6pQssc6hf4gsaaM25Rb19aT0e3+Vs9XAxc5rDVVVQ1LTf3Q1rZsHt2KO0xY2/teXaKtQQGYfZ6/c3ixbLZ2OpMUd/riq70DG7VjMcvdslwgHKajKbBavdvYMKCZ/NzggUUInh99jRwbWOd6QfDaO0MreiCv2C46GTeh9oycyHXC25JfWROY1dafzJ/5QRsCxolsoOq
X-OriginatorOrg: belden.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY1PR18MB5874.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5caa6715-f5d6-4d9f-e89a-08ddb91bbeca
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2025 03:51:37.2489
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0f7367b1-44f7-45a7-bb10-563965c5f2e5
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YHRKxuvRvJjaNbx8gn/Z4YAGfOsU4kKg9eHZ1+XC8Bwad5CXuV8jQ3iBW9w9JB1GPoh9sEoIMEISIE3w+G2HUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR18MB5108
X-Proofpoint-ORIG-GUID: nSQbJMbJjczdz7xupnGAaulk_vh8GhO0
X-Proofpoint-GUID: nSQbJMbJjczdz7xupnGAaulk_vh8GhO0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzAyMDAyOSBTYWx0ZWRfX7jnIfrTA8+4a
 CDeVvv/APr5LOBQZEZqHCrIirMmDzE6spNXfInNBCLXRtYwL4/0U2ZhwH6ayI1oGJgPf/ApUWua
 CnZrXqLQHXSosrpmtkBZ/qbmGMTG70No0AqwNbFTCCxvdKFf6Qkhd43RIfxAQcjfG/I/qCdw37u
 +M02fSdqxstEZIjUA29sMmYf5RL7ZIqxm5qpu49aJth7UJJfk8vVowFK6FBmU80Xkji8aWg1/XE
 XY2fp4bBuWKTO5F8MrxEqr8mzwB90qQ2vIKosuCTiSH8laSWsv7K8TABqUwjI7hdxE7sLCS2Dpc
 +XHrVvlGJNLFRTsl1u+gsn0B/L+kw0Lhbl7BODUoR4Wq4uHHL1nycbE2ecUSiBMbPTMw3s/JeBG
 9hW8NpWfVaQYx7QLmuYI5O2xKs6Y40DYtZenE5jKdVUI71dJjKCS8tqwDjmyLoNn/0XSYCCX
X-Authority-Analysis: v=2.4 cv=VNrdn8PX c=1 sm=1 tr=0 ts=6864accd cx=c_pps
 a=Se1Kd4d4o2/Q5WTQO+3bhA==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10 a=Wb1JkmetP80A:10 a=mCf63rc527wA:10
 a=RSRYst51tkefKKZcTL4A:9 a=wPNLvfGTeEIA:10 a=zgiPjhLxNE0A:10
 a=zZCYzV9kfG8A:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-01_02,2025-06-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 mlxscore=0 lowpriorityscore=0 adultscore=0 phishscore=0 impostorscore=0
 malwarescore=0 bulkscore=0 clxscore=1015 suspectscore=0 priorityscore=1501
 mlxlogscore=988 spamscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507020029
X-Proofpoint-TriggeredRule: module.spam.rule.outbound_notspam
Content-Type: text/plain; charset="iso-8859-1"

That would be great.
I implemented a version of 2. also and will test it today.

I preallocate the transaction elements before the walk and just allocate mo=
re atomically if the nelems changed.
This should be enough to preallocate the majority of transaction elems befo=
rehand.

Florian Westphal <fw@strlen.de> wrote:
> 1). Leverage what nft_set_pipapo.c is doing and extend
>     this for all sets that could use the same solution.
>     The .walk callback for pipapo doesn't need/use rcu read locks,
>     and could use sleepable allocations.
>     all set types except rhashtable could follow this.

FWIW I'm exploring a change to nft_set_hash to avoid the rcu read lock
when calling ->iter() for rhashtable.

If it works, this would allow to just replace the GFP_ATOMIC with GFP_KERNE=
L.

**********************************************************************
DISCLAIMER:
Privileged and/or Confidential information may be contained in this message=
. If you are not the addressee of this message, you may not copy, use or de=
liver this message to anyone. In such event, you should destroy the message=
 and kindly notify the sender by reply e-mail. It is understood that opinio=
ns or conclusions that do not relate to the official business of the compan=
y are neither given nor endorsed by the company. Thank You.
