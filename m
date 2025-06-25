Received: from mx0b-00015a02.pphosted.com (mx0b-00015a02.pphosted.com [205.220.178.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D98D8634C
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Jun 2025 08:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.250
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750840090; cv=none; b=tZbLV8L9CqsGDeflRXY+5xH3iDqGYyARgLwctn529Dks/kNOP1FUNSbxNA6tHqejxY4WqmHFIkKgQvLzl1alTz8eENUEfcXCaDYqhCcIzDXmwO256ZFLuRX5IEUbw3Yqnr8XwZ2PNxLRsLN/WGhJvAA1bhXAjx9S8jl3yN/4978=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750840090; c=relaxed/simple;
	bh=dxyFY5vm00L3+19+a6cMfNwPBbyCt7t4sN+fgiKh7rU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=M1kuwCWu0HEfbR4TZ2P63CDFlXG0J3Z5exitoA/93s2tupF7hJhXPMhlr3k7CHxF7ueA3Ptb4Ul5MQQg2ATFdcGyy1Sa5fa5DyifrXjL8e03gy4IInRiaoUNbcVdQp/mpqU+BTOZ3BJ6YpdRPB/ACp7kxtK6LCSv9cCA+BysK0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=belden.com; spf=pass smtp.mailfrom=belden.com; dkim=pass (2048-bit key) header.d=belden.com header.i=@belden.com header.b=Ts2qMaPO; arc=none smtp.client-ip=205.220.178.250
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=belden.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=belden.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=belden.com header.i=@belden.com header.b="Ts2qMaPO"
Received: from pps.filterd (m0264210.ppops.net [127.0.0.1])
	by mx0a-00015a02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55P3e8Iq027296;
	Wed, 25 Jun 2025 03:00:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=belden.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=podpps1; bh=dxyFY5vm00L3+19+a6cMfNwP
	BbyCt7t4sN+fgiKh7rU=; b=Ts2qMaPOGHTP42kkBQi2Z5lRcarHXdgiEVH9QRE3
	WLoZyI7K+NUO7jS63ae0FG3ifFzb+ObSMe9mgRZx6C6XTZ6bRuVgsRbuXVxO9RoJ
	UScnPK7UFbJLIff1Wsv+34qzYSxtvKB5ixloW8HQqLF9A/nigCoT1jWjxwbiSHSv
	5dK2A7jf4/5lHYHXtCyCJJZLiRRkIrh4/nObKBbvehuJKA6VXkzfpPr2Pami3YDx
	9sTXHfdvwvr25hLPjqW6J0Bcfvwid8Z5ZEvgJd0+1bzDr1950rIq0W6jAXPKvLcq
	QXWLySK8e9Ve8dqR+gf2OnIZpMx2CXfptXQ2PZyXNvBaBA==
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2109.outbound.protection.outlook.com [40.107.237.109])
	by mx0a-00015a02.pphosted.com (PPS) with ESMTPS id 47dt3qxxtb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Jun 2025 03:00:19 -0500 (CDT)
Received: from BY1PR18MB5874.namprd18.prod.outlook.com (2603:10b6:a03:4b1::7)
 by CO1PR18MB4617.namprd18.prod.outlook.com (2603:10b6:303:e0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.30; Wed, 25 Jun
 2025 08:00:17 +0000
Received: from BY1PR18MB5874.namprd18.prod.outlook.com
 ([fe80::87f6:31aa:bb07:965d]) by BY1PR18MB5874.namprd18.prod.outlook.com
 ([fe80::87f6:31aa:bb07:965d%3]) with mapi id 15.20.8857.026; Wed, 25 Jun 2025
 08:00:17 +0000
From: Sven Auhagen <Sven.Auhagen@belden.com>
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
CC: Florian Westphal <fw@strlen.de>
Subject: Cannot allocate memory delete table inet filter
Thread-Topic: Cannot allocate memory delete table inet filter
Thread-Index: AQHb5aNNhZSA/ulCI0+LraAw182A4Q==
Date: Wed, 25 Jun 2025 08:00:17 +0000
Message-ID:
 <BY1PR18MB5874110CAFF1ED098D0BC4E7E07BA@BY1PR18MB5874.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY1PR18MB5874:EE_|CO1PR18MB4617:EE_
x-ms-office365-filtering-correlation-id: d4dbe6ab-1d0d-4c88-d34d-08ddb3be52f1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?xVrbBrYojk6xAh1k4glb6tyDoBprsbmRhqC/FNX4WZTdI8e6tfIPsQVCEn?=
 =?iso-8859-1?Q?oYx4NZmRJHfr01IowuXewUCgCjqRNw1XSyeABKgLcHHkt7C7YG6GPGhTZt?=
 =?iso-8859-1?Q?4L6i5aICrECrK4eV53nDmJTANUCj1S3o7hkiEzjZIA7KlG1kIhGUBe3Cdh?=
 =?iso-8859-1?Q?/MlIePeQVeYOiCHds+zp1MtfueBZlKV79fCzUasVfVn1XF5Jy8vnxkjbPQ?=
 =?iso-8859-1?Q?tYg/NfWAaGsEes7tV72YsY/Ht4jWBUmoAR4YH2Y6LVc4saPSZJy2xxoEzn?=
 =?iso-8859-1?Q?wKd2FXPGL4iMhjdis1Zt5MtMMWTW89nlRGLnxzSHk3yerxCCE8uhLxLe5D?=
 =?iso-8859-1?Q?+YkfUQJKppwn03jh8riCLJ8nE1UtcOgRz7rlz61QWc5B5heiiRQke6bzOi?=
 =?iso-8859-1?Q?12Klk296ZmAYEtrugDE5JZV22uGB7Gd/IppTBK/MRFuOfohIEadu5pO7ND?=
 =?iso-8859-1?Q?V3+FyOnjlP3m+QdliKMlMj2/gpprxQaDfRCh9DWiI8EPdrD1u/mN7VPrOL?=
 =?iso-8859-1?Q?u54IIsP2HI0MD0YNGX16A/0Ay9d1kQd/gJpbXGjkE8w5cdyw1VAuvlFv5G?=
 =?iso-8859-1?Q?vJvRq+dXTIMu5rWkRcjta4J3rcG4bZFwCrFfe5LQGU4s8GU6aWQ3ZUV+gd?=
 =?iso-8859-1?Q?Y9+jBt98SN0E6nz0SNi12PEexjK+hy0RBMZeH8LdgENJogupTNXaDRmYNp?=
 =?iso-8859-1?Q?TrZvNM2psxSadeZz89KIJu412CCq5Rrrimlqh2jGQ5JpU4u+ZfQ+6gnPh3?=
 =?iso-8859-1?Q?3P+47bMfBJsIBbqrLKVAcwSTmpqe37xl5LgO8SLjT1wgf1kmlL3/KvJSau?=
 =?iso-8859-1?Q?EXyZI3xT0505xcJRAg+6kKvWK4tihtcsK4fB1JgTQTTeZdbkMpcNv0878O?=
 =?iso-8859-1?Q?NnTMxaaAQoUEs++7bA5RQPL40fpSpLc3G8LhueDCN4D7mpR96gLeMqDpnh?=
 =?iso-8859-1?Q?SVITcno8clUi6uMuhPT9+9feY5Yud3J1SQ/68Q6hzB+xoE+b7wMeCUfh5O?=
 =?iso-8859-1?Q?QuTKR9fXy3GROuAWtyCCUe6PPQq1E59jWPSuSlwsIQuIf1TKcWf0PVvXXH?=
 =?iso-8859-1?Q?fhp06WvUzf7O+pthjE5JEfe5HQiyzAnuBks2ZPyNwnwFzwe+yYcoabwuB2?=
 =?iso-8859-1?Q?tFLDMWqJwjunySbJvwOiwr/8vFMQMF7OxpSAP9C03wJXoP//QdAJ14D9pK?=
 =?iso-8859-1?Q?Fj731RDSJg6ME5iGA5vWuSRz87iO6U08aSZ8ySvlssSMh/edMLj3/nQ2LG?=
 =?iso-8859-1?Q?f3VFMPc/APMEBJkmNigdZ+uAO0AepwW7HhEshOkg9RsaLM+QHGAVJcgNLB?=
 =?iso-8859-1?Q?vb9UtVAhQHwMYlwZ2KtQOgTudwn/PSPFKpnTGNwCDUQoUHBYOqFCMIhje7?=
 =?iso-8859-1?Q?gxNtC1bI9Pmiji//rpDF69X4IpoeYjnbv6lUSkIBB6DbcotEqYRlkAujOA?=
 =?iso-8859-1?Q?ndJbi8oonv+nEsaMcb5h08aqLSshMmNO0Jm5dvhXL4QoDEKSWVzTo/WBUu?=
 =?iso-8859-1?Q?Yv1V1PZDqelv/yFzKz/LjuZd+jE9C0UENhZtEZZG6qGA=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY1PR18MB5874.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?D09lPeB0Svby9MYYL0N5jG8NsqDmIeKJ6+/B0HZ6k97FRrH7DzrLdC2G2A?=
 =?iso-8859-1?Q?lRDH6Z4czIiCiiSCh5CmfubS9e1Ks47Rvii7Bi839XvLa/50UhFInJei39?=
 =?iso-8859-1?Q?g8noxK21A39gOMREcNjFz8aGXuaObJFSzpawBC8x2PwpoRLvBPIgla0lWM?=
 =?iso-8859-1?Q?iMZsPSGwvt5zaI2Uo2YmqNDtnTzyRilQibPeLQ4GyPCm5qxzrAaDQdAEI+?=
 =?iso-8859-1?Q?pbg9TDsSDKjyRsftRtd+jhOlG+Q5s/9qA+MHRm3uvk/9Ole+3b5Xn/Gzu7?=
 =?iso-8859-1?Q?7oeJqnKrZHpveiE/jDtgasoMe6yXYn3YD93Qi3X0CTtZ7OyXiP1lLoYnID?=
 =?iso-8859-1?Q?ZMDE2dBGNfyTYwXJNy8gTKpbTEKP5W5UMUWMdYygGjPTmCtntotrEu1eA+?=
 =?iso-8859-1?Q?JkjSfi70/JDuCuMYQTVNI799XCHSvXkNiqGb9KY4KiVIbZla4+OpfCdS6r?=
 =?iso-8859-1?Q?weghfxVexTxvBhrahYE0VmgzPgu8GxPWbJGVpAn7tdPiiRcI1A7m4jDWUG?=
 =?iso-8859-1?Q?D/t1ZPg2DTCd8gEVeUpgXaQ34NrliYSadEflDyBft4udmbg7xZW/PKWjq6?=
 =?iso-8859-1?Q?sZ0fI2JgT+kjlyONJChhn6L2tcrYs8EX7+tB0NRpXvP1eBvucMtCslJXUS?=
 =?iso-8859-1?Q?897cNBoXw5Uqtp5cfwTeyK/8Ur31O7+rHXCFyo18p/7ip5DVHBJ2427Rpb?=
 =?iso-8859-1?Q?dYAChjsCzVwW10awMuRXuulVfTv/G3e533JMvLRHG4/dQV2lVnt4s2w2ky?=
 =?iso-8859-1?Q?zSBczH91wFTfRDjVJSnEnhY6DlRSNgcsIDM3LAWxnZq8zUUIGWdOJAzSCE?=
 =?iso-8859-1?Q?tuhWiR0XaG5o0tpfUqy6OhOEOvWC7s5JM7uOHIrC4c3L5bTfIV4g9i60IF?=
 =?iso-8859-1?Q?lC/MxENoGYREySaOJIRGALD4sQKBaoWRD7/IxwGiW8OQE9qyodjEuQoOBp?=
 =?iso-8859-1?Q?p3j+UTL/hWnH72rR4YpiT/Qv9azQvohKRr5irQO9GdoLgeAT7soofqnc4Q?=
 =?iso-8859-1?Q?dwbwg31jF5Mw0plhpagAqRXMHHtDNnyzTxc4cZevxCahoaNitX4jV++GQ/?=
 =?iso-8859-1?Q?JXaoEQ/AQVckzK37B/5Of0nJHIiNkKlUPU8ycjxP5EahMHGL5j8Wi9aIC1?=
 =?iso-8859-1?Q?yiOP+jaHP4GyAmu6swDN6vscpSXNkEqQlk5KKOYdNziigZUy7hlYSmb9Py?=
 =?iso-8859-1?Q?/2crbpM+rSU8h9li4mE6LI8kpPVbssQAIIW9lNLTc049YzqIM3Ma+hfx8U?=
 =?iso-8859-1?Q?2qsXf0HCOPqBZdGNNyW88XdYDEvHq2J33VoL0VgZpvm2ayW1Hg5xSLZq/h?=
 =?iso-8859-1?Q?ddlyVTctR7YQV0YRodYiW5vmb3QQzguoLB6RyR9jDBjouk/hX2mhXmbqiJ?=
 =?iso-8859-1?Q?Zu0h77rO4tJBgXK8QZD+nbnqcs9InGYjprQ82456Ox4mbteVAJsFnVr+0A?=
 =?iso-8859-1?Q?EILrWW2yykai7EOqTE2h83346cDm7p6n2oxNFXgtBTUe5GuKFQ5f94LHjc?=
 =?iso-8859-1?Q?4zgEWOf3jgqnc2yplhI9iTPJskr/OhTZir5qkaFL+jLfISxlQlK3I8IFzw?=
 =?iso-8859-1?Q?m2roYYlg5qcppYbHU8XpQt/te8mLvNvi0yf8nQzFZLqvGLJdboxvMM6FSX?=
 =?iso-8859-1?Q?EJ8+HXUxomgk7TpVLNiZ+pRBjlvqG/U8k2?=
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rcn1Q3MgJyhK5/K8aehiTg6ehXJc0mK5tTdAkKyTwzYZQK6Ax4f4MfIBBtbQypKjLb4Dpp41yZBs3SbiArt7LdeQ1uRGwvUTahNKMfDL1y4i4QMgFWewMFuoVyxdCaYhYytuqcJJS3TEkgGXFjFq06LCsrpL0JuVhYBt1VS8iX3W5/HyUqio+k29cPSWnJa38SognuWg0dU3V5sxcyYWgrikNDs1zuPbtAdQNis2ZVmVWaM0MPQ22Hs607O4dAAsTh2zpcTa+XpgtOQCY9MEwhqwCAljH5vSern/j9D7PH6GbEPyEv9jIfgFzv18vHgW2IfGb4LUf+2J4rrpJZPAaThrGO+rui9qtkXcDc58vtpWmjE7KvDAUiLzUnAtk4i/bH4vY4BBV4u+qE0bCpOI0OqsqvZEjkP7sCGdNWM0SrN9/6SRb+4onV8nSbNxaX4AFeeQRI2bMBUjwx1OMiyo3xdh15dY0JwqUtGIDfz25Ia8idqHCXnWql/L87dtdCkPMcE1FHySu/k7UzZKjNWUgwt3naEvICGA3BXhS6m+0nd7HLxdUZdQhrUNMWoZK8WgfIsvl9p/xjM5tbMzTTIA1kpVGPFSpxbvhk64xVtwTjeHscMfLVbSKeqH8+wosXOFfiWtrwRioIFxAauUHR8spw==
X-OriginatorOrg: belden.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY1PR18MB5874.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4dbe6ab-1d0d-4c88-d34d-08ddb3be52f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2025 08:00:17.3015
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0f7367b1-44f7-45a7-bb10-563965c5f2e5
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fw5R/QCxP7qU8AvhZ9qf1xCDCwMYi4ScK15Fo4fDT6i5oPR9t0FkAXvPGTg7Hy2sijmP2QLYUHwUvS7kgIW1pQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR18MB4617
X-Proofpoint-GUID: 7sJ6QfEHvvunchJ_FTZyssP9JIKgoK52
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI1MDA1OCBTYWx0ZWRfXwGvaYEBnc9V/
 7KcDfbqHWv4y898uPXIydwm2FS9QzbpmKGji/2FyPgmsCD2DMLvoxF4YlPqYW6lce46ayLYNmn2
 2xaU9KFSPkTzXBKKkAh8qOub7PgopuuDOeNvFJT14C8UDMpcIXFV7v69E8jNcA0HqBy8KoXyRs2
 SZZ8oO/Epq82zN3bzM1Y6zLGCQ7yKCMqWYwj1RLnOrIibBEuaSheWrYPi/fp256tp7SxCBWRDis
 Zgb+pg2ecsaWOYSA4tLPWTuCF3Jd9aQ6Jl0j3gGumKil11xN+Pl1BzAwliKphMrLRpJo0+oAGCW
 g2znIbHs6KHzBXc2JIw8kCJ4auILJrh/l2rSTUosBF6yI1IIDAKRQLGMUR+8cxsr/NtzR/hGWKr
 WG5CXu9OpqnarW6ZZZaOHUQGxazligXM8SYfv8W7mC40yz1z/MIpFG2WVCoXM0cv/Hv0eREj
X-Proofpoint-ORIG-GUID: 7sJ6QfEHvvunchJ_FTZyssP9JIKgoK52
X-Authority-Analysis: v=2.4 cv=GfsXnRXL c=1 sm=1 tr=0 ts=685bac93 cx=c_pps
 a=IZtX7zTm26LBIsBaguIpxw==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10 a=6IFa9wvqVegA:10 a=mCf63rc527wA:10
 a=ARQZgFeI3bi1JpomdRIA:9 a=wPNLvfGTeEIA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-25_01,2025-06-23_07,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 priorityscore=1501 mlxlogscore=721 bulkscore=0
 malwarescore=0 mlxscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0
 clxscore=1011 adultscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506250058
X-Proofpoint-TriggeredRule: module.spam.rule.outbound_notspam
Content-Type: text/plain; charset="iso-8859-1"

Hi,

we do see on occasions that we get the following error message, more so on =
x86 systems than on arm64:

Error: Could not process rule: Cannot allocate memory delete table inet fil=
ter

It is not a consistent error and does not happen all the time.
We are on Kernel 6.6.80, seems to me like we have something along the lines=
 of the nf_tables: allow clone callbacks to sleep problem using GFP_ATOMIC.

Do you have any idea what I can try out/look at?

Best and thanks
Sven

**********************************************************************
DISCLAIMER:
Privileged and/or Confidential information may be contained in this message=
. If you are not the addressee of this message, you may not copy, use or de=
liver this message to anyone. In such event, you should destroy the message=
 and kindly notify the sender by reply e-mail. It is understood that opinio=
ns or conclusions that do not relate to the official business of the compan=
y are neither given nor endorsed by the company. Thank You.
