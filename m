Received: from mx0b-00015a02.pphosted.com (mx0b-00015a02.pphosted.com [205.220.178.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0046F26B2A3
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Jul 2025 08:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.250
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751357787; cv=none; b=sMCLGT50/8UX8Yqq81aWRcMeejRViewFt7FwTz4TMUx7J5Ejftqjp3fZe/6DAoLIAuzlNy1PKID6DA4lMKH37VJP4G8Yu9VhHLJw6vQuq/NfxAnFiSncDFgTPCI8G44r1TIHHwLaE9fo8k5gok6P7G+6QmMKMot1xem0HaQ5EjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751357787; c=relaxed/simple;
	bh=2r5OqKagF9ZrfqUrWB/XkzMcRtJ6Xma7/J/OZalZrAo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=I9vAmcyJBY3S/K5VYn/oTEzMVKQGwHCVyS3dP2uK2Kx9FG73RH3pCvAuJ+OOJz6FKmOOOuRupy/PhXKxxgDH+deGXGkMXbclSFMPeh95OVAahkbvspp8klZHtasSHjPKwYHJ85DoEiYdoH1lSot32z0aRnbpeJ5YNV8lAr3fskU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=belden.com; spf=pass smtp.mailfrom=belden.com; dkim=pass (2048-bit key) header.d=belden.com header.i=@belden.com header.b=zQHeE1er; arc=none smtp.client-ip=205.220.178.250
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=belden.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=belden.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=belden.com header.i=@belden.com header.b="zQHeE1er"
Received: from pps.filterd (m0264210.ppops.net [127.0.0.1])
	by mx0a-00015a02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56111nEG014035;
	Tue, 1 Jul 2025 03:16:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=belden.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=podpps1; bh=2r
	5OqKagF9ZrfqUrWB/XkzMcRtJ6Xma7/J/OZalZrAo=; b=zQHeE1erhwk1E2DbDC
	v57V48dpS6sZJO4xWSO/x3uXTqMb/RyH+orsnuBmrvsRR0Af9s8pj54LLkRU8Wjh
	8LUSqiMoXjfN53YrGkm4zUIqguMno/EzJErXhtyIFDT/lmHV1wsPgzRT0q4bd+FU
	c/s8ig0TeDlwlgsteIYShhCog2d7WQLOpzhs8GWY7CBNzMnUP+5x740dAnI5h6Vb
	dNIUPCwuJ5sUlJq3E6297HRXnDnPT37MocuG9xVPMEOIVOJhlBL8LiQ1r9Zm3HJp
	Ozt+nnjyAInaT/Cj/1BQGbya3IQoKOpBnfnz5cJYlpBLDwU6kmNtwWrK2eaRgpGx
	PyMg==
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2137.outbound.protection.outlook.com [40.107.93.137])
	by mx0a-00015a02.pphosted.com (PPS) with ESMTPS id 47jdrx4kmb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Jul 2025 03:16:01 -0500 (CDT)
Received: from BY1PR18MB5874.namprd18.prod.outlook.com (2603:10b6:a03:4b1::7)
 by PH0PR18MB3910.namprd18.prod.outlook.com (2603:10b6:510:26::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.31; Tue, 1 Jul
 2025 08:15:49 +0000
Received: from BY1PR18MB5874.namprd18.prod.outlook.com
 ([fe80::87f6:31aa:bb07:965d]) by BY1PR18MB5874.namprd18.prod.outlook.com
 ([fe80::87f6:31aa:bb07:965d%3]) with mapi id 15.20.8880.030; Tue, 1 Jul 2025
 08:15:49 +0000
From: Sven Auhagen <Sven.Auhagen@belden.com>
To: Florian Westphal <fw@strlen.de>
CC: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Cannot allocate memory delete table inet filter
Thread-Topic: Cannot allocate memory delete table inet filter
Thread-Index: AQHb5aNNhZSA/ulCI0+LraAw182A4bQT78SAgAAE4DuACQBmIQ==
Date: Tue, 1 Jul 2025 08:15:49 +0000
Message-ID:
 <BY1PR18MB587473C6870ED217731B73F7E041A@BY1PR18MB5874.namprd18.prod.outlook.com>
References:
 <BY1PR18MB5874110CAFF1ED098D0BC4E7E07BA@BY1PR18MB5874.namprd18.prod.outlook.com>
 <aFwHuT7m7GHtmtSm@strlen.de>
 <BY1PR18MB58746445C00F31B0BAF392ACE07BA@BY1PR18MB5874.namprd18.prod.outlook.com>
In-Reply-To:
 <BY1PR18MB58746445C00F31B0BAF392ACE07BA@BY1PR18MB5874.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY1PR18MB5874:EE_|PH0PR18MB3910:EE_
x-ms-office365-filtering-correlation-id: 4712727e-d45d-43cc-9a1d-08ddb8777d0e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?4+8k3crHr30OzKXF4/EFDYHFris+znq1pU4YsYq9uDM+UoAUxIX46ichCx?=
 =?iso-8859-1?Q?EjgJ0N2ApraqYjMISkL/YvUIaq4RQnduKmu9Bf117VjG9OH2LP+UIRc7yp?=
 =?iso-8859-1?Q?apUTNlxW83JtWa66jRZ1aKT+UQp8G0zk7EpG3r/jZ72kkRaTHJcDe7JCgK?=
 =?iso-8859-1?Q?qXIK5/A2BI2bIixqZ5PhItX7XszW+IdsWG9Edh2tXmuDxvcJ5gYswN8Y07?=
 =?iso-8859-1?Q?pyQZ3YYqsz4DNowG/UhAWzjAhL/QzSPgpDraZ88CZtBIQYQqTu9vP9UzQB?=
 =?iso-8859-1?Q?izpTY147ecNASG0OYTbLcXfMzHBurHEgJBfr/ahFnWw2iT+FdVa0DepF9k?=
 =?iso-8859-1?Q?a4nXZ4YXXbKTnVC1ce/PLr+MCzx08YkJyjF7EtB6xekj0aZLSKOYvPZTcz?=
 =?iso-8859-1?Q?aUFck5heDvBr9AXYikCSG3FVeylwvAvO60HHCdVXgt8LKfabct2kv5Uies?=
 =?iso-8859-1?Q?mr3fjxkqTc+JR+I13kRiz/7DuS2c9sgyXVkjzbU3exmUQ5SMteEtFxiKV/?=
 =?iso-8859-1?Q?8blPJBnqfYjL8l8F4Hm8i545TNqlTwvLafTeo1FshpjVq6bKkf02kV9BMh?=
 =?iso-8859-1?Q?EtXY/zMdHdrHpUIgztMAXbGCe9XUlvwwgRPxABsWUKSsq3XCpSuS3DB3lA?=
 =?iso-8859-1?Q?CWjUgNWybyygqzjN2Ur20VaG0qbRjv+LTD2H9PnbsUzCcctiJd3U/mPaVI?=
 =?iso-8859-1?Q?UK6YkjZcDTa6aMMGWvqEcOLRXgkm+4TEM6Fp2vckrkM7LTKp2gpOpLA6Mg?=
 =?iso-8859-1?Q?9BWTpV3EcEeKj+/MWRm6OjE4BW5bs50t1ZAp9e02yYKKw/MTQYt18jD6V/?=
 =?iso-8859-1?Q?9/X0g8oB4eoLHFQAN787QeD/Smguv5QnqlcZbox+LgBozaoXsCnSBMVwSO?=
 =?iso-8859-1?Q?yU90J1h1PnNvE0w6lSjNiOtIu+avW/TvSCitNH1DJuQsLrg2T1ettkdgab?=
 =?iso-8859-1?Q?dNED8mEMQ05KxSTQ+vX1UWck4/mrLJ7+MTa09yVOTvFp/hj9q6sKTcIOoj?=
 =?iso-8859-1?Q?Tt7IbZy6Zj0rFA+bNl2Ng552BW53bZQAQro02jT0zhdE1e3J2e/7U2GuDs?=
 =?iso-8859-1?Q?c5PgseHv8bQC82VWlCvVq1IWqHhHAec9/DLHNffhXRMXihGpjiTrKdlWm5?=
 =?iso-8859-1?Q?7ow6D+012XSWMjiOjrBFRVjDuSftdyJrJNkTWCp7czda+a87zx4Dn8g+K5?=
 =?iso-8859-1?Q?yFzmCDjOhZkl3ivg5NgkkhqXbAdQNiG/ZMsGKNWAzbxVkAbxTHlq11BKUH?=
 =?iso-8859-1?Q?7SyawcNpZgRdz8go0p1TLsm2+qU1VZhTNbyiixW7FJ+G8tiyCDQwrwgXdA?=
 =?iso-8859-1?Q?963BCllaN1ASFJhGQe7hMzZdkN9/gipxgM5d9E7QpVf7qmk7f8nssiMkDl?=
 =?iso-8859-1?Q?DtU0yxF+EsG9BDJ5TotKTPoA9cskTE4drLXR+3BNU3uFzn+ey6Nz2tB0lc?=
 =?iso-8859-1?Q?Hv1TZIPdcX4qAmGzyWbiJdHh6FMAcx06dVKS0Ow6qWo9RGwJqhkAw/laFc?=
 =?iso-8859-1?Q?LHQRzDWXbBBcY/ub6HA3VGqMRpcQbD7MFcsxJ1LCHtig=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY1PR18MB5874.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?rMfwNedGptDcmQ51J5yY+Dm5VtL5xwvyAmXjB1gcmBnYWnOx0r4LOZUuIQ?=
 =?iso-8859-1?Q?4TJK+umqx6q2u1Q5d06vZoRvCnxqfXccZT2jNxCA688bYw6sItjWkJc4hG?=
 =?iso-8859-1?Q?nyEwVWb3oAR5uYBXNGqArPvRoF9B/oRwZDGmkiymo2Zdl1NqXztD9Mz25r?=
 =?iso-8859-1?Q?KFoUCl4yEDtmaCSas6bf0F2fIswldzXV4ejICGnceNz0of8L3pUcJ8gBhk?=
 =?iso-8859-1?Q?E3jy7qk1KVPnvAKrThHK00koEXDtyGKUZe0jK6vF1jPXwVEM0UX0smqUjt?=
 =?iso-8859-1?Q?3mlBHT7V/Hx3Q6zCmetkcaubR3VR8t+8825CGQ/PyldswU1sYBi5KswLeu?=
 =?iso-8859-1?Q?+6DzD/52TPjLLAYO2QrKzhqH/mx9zTNlN8VrHFpSqi3yvnBnKd3Gq9xfd5?=
 =?iso-8859-1?Q?1nuC54FW3rCBgT5bZFsYDa97BUsuyVSLq5ZDQgbl1/8E4Vq6TrJ88rTYR1?=
 =?iso-8859-1?Q?xCmBj40M9kOAHWjk/Pa6szlxfShMOVUiKA/o6WMBUDabgk+X6AY1NnzcAo?=
 =?iso-8859-1?Q?UraHWpDjV/vSAdUIvq4nedXvOp5kL7gYRiYKuAeepvHSnSjQ5vLBDuaNs7?=
 =?iso-8859-1?Q?PA47Rh/+py5tyRJi6Ya5AhbTfy/3LNXjlV0tcgzxriNpYKSulJa/qgr3Qd?=
 =?iso-8859-1?Q?t2Qjv+vcm7z3dGKqKWOSYYwcTre6nkuwpuRcfc5HbqV2IIU5Rp12VuUNEr?=
 =?iso-8859-1?Q?7C8q8fpq2kjrsyx1VYFF+5IVA7phKraRwo4ASaYBQ5hTPkGzBBToJ4S62M?=
 =?iso-8859-1?Q?eNQuXWfr1PkgnOS/D48h8q/cgCeVvovl0p4GsJyG7irEzshsK2P2i4dtO0?=
 =?iso-8859-1?Q?JrUM/MQrHz1Gjq8EmIMWjhZABRWwS+PXzYWzGYqCpcXCliU/G4nGGz/iCJ?=
 =?iso-8859-1?Q?hn8+VzLg3YuAXDvtjfqOy0GkZZT6tdIph1bNldzBo8poSLDRqu0uC9proI?=
 =?iso-8859-1?Q?gFqno8k41OmBLMcFOBhmH161z5slccQiXAhOMA55uLHf79CMUQowuoNnXT?=
 =?iso-8859-1?Q?hCNrmpnwRn7WEKNHUT1uUDvtZLgdfoiDMc40u5sorwA47A+iA0253h0j6Q?=
 =?iso-8859-1?Q?MFmSI0gYxzLqj4uwkOF9UDxUuXgAzcWhHx0ZBI1gZVQSpxlWPaSO1K7KZA?=
 =?iso-8859-1?Q?4CKvYaodKD7jEXEi3k7Hv0ewlQxGbzludKTPzGFlrp5pgdVJwQHuv2xt5V?=
 =?iso-8859-1?Q?vuDD+imE/ar7RQ0NZ2nNQ9RFOuYSPEMdQo/bkOESDQXRxq6zUSUHe12GMm?=
 =?iso-8859-1?Q?QVHBH0mCz3gg5xGNJiyr+uyYeNyPfjmv+gK0H/qkHgW7KWg4bKW4WV1MMu?=
 =?iso-8859-1?Q?NVT3cbI2H+g8Ct3bGqg87VVPURFAlLf+siUd6MoREJShTqsoP0qOyIdCQD?=
 =?iso-8859-1?Q?M4PJPrpXRELBztpw8zzZYLp9gLjTqz7YC9mgEEnJo8hA0ZM6x0lGc9M8fn?=
 =?iso-8859-1?Q?exu0yAtHZe99q08G0N24H+/VHrEKvMug4vbrZ1ZbhTeNDyknyGnADle5p7?=
 =?iso-8859-1?Q?OHaN1r9gZZ3yxXcplJL4uHmIFOzf8IHH077LSKnWxedJmU5uhEP7+xt2G0?=
 =?iso-8859-1?Q?bU0oWlHOyYS5FpUtFxM7LrspPx4wKZEog87nBakb9eTE3VxQDIandxUZgX?=
 =?iso-8859-1?Q?vUlRI92XXgE3aO4YUKL/xa0ttMCaov8VUi?=
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	AS4XndWcISg6Nsp9mif4FhcKN/4nQFGoHCuvC2RZykF22VAOsHhaUwGzQT5Cx02ttH02mygQ7lg/X3Bh+00BKYK07PIIJhybYQmVM4tW0mb0MZhsT0OhOcAOlliPDSMnMzoXF/QnXshDcOIz8E461MpIZMwxoQSyym4qWzbKsUAG8bb+E1RBk97nK8MuGR4Ev/FkCMRCTqvfVgcCxs1hXmYx+31a7EOEWFtFHVXJ0QZmRCk7Lr2sXGfhyfgVua+Ag/d9R+CUvGOGP+jf7QvmOyEQFSatcgBBvwKUuwwrZdW+2qLHs1+Qw/9hV/NO5UBZNCYFN5sKIdBXdN/qZ4TA8AoiTDjgD1wXsqgsgESkvVY5dIHs6py4ZsbfjgugDs3rzU88UemQyq5P2bZMZ5TxMikFPoEjl3ongwNsVflINUK9dixn7IzC2P3cGyysXzHgunGYZEfpontImM3JOhos691wEyL3VUala/STBb8foRA7JdnBMtH8p3+72CBA5tV3Q/T9gKMr8opFLhh/unWtpoC1+kKdQ5sgBswS0WP6RqTuumt6U2xPkopK2aiXlfZe3PQqqyNp3Jdrc88jPgpxT/yqan/Nqx7Hvw3RIaywLbgmfdS4FlKQhCHPZV/rWJt+
X-OriginatorOrg: belden.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY1PR18MB5874.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4712727e-d45d-43cc-9a1d-08ddb8777d0e
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2025 08:15:49.5034
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0f7367b1-44f7-45a7-bb10-563965c5f2e5
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PqrbMx6jK/ZSKxV+VVrPurwXRowHvezgyUuK2nmoSSRse3TNynY8cDg2ZHGmr6/phzVh3fnSyhn6zWHtXqJz2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR18MB3910
X-Proofpoint-ORIG-GUID: 2Nn648GKaVTJfPVdZ_cGDnTxXodWdwvb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzAxMDA0NyBTYWx0ZWRfX2xyrDyTWCYHQ
 5R0bwbKQFy4dSiZ1gJeyzSrsKc7KpT7YeAqN1l7LGIhVf0jOVu7+7bYeb582hMiCp3ZqWO8JsX9
 /MwDqrSxpsk1YDCBQfdQVFzvHbklV4l3N2K9zutMDlroFbylLprCNvMTuJGWzguY8OIa+/1Db8Q
 bR04oZPHGizGXd4xtt9ZzkqgdBEp9i2KwfT30M016OF8DyI+s1sQuMBsKQvPF17qxNXUhs+jqIv
 QNxNJpS5iuGrHrTZDJP+dkj6VaWeX0kZ9B7CwueICuX9Z4NWs4GhDXCNc5dijS+BmDHlF92uplk
 gQF6CJzbLoMnNUatIYgM9ujL8zMF7Fuvft0f0Blsd+Lf5XuozL4cBQYOq+3od0SYQha5uME3es8
 2WshW4lF8CGtiBuJLsFoa+GZAmfA2jhhUDxosG0hfYAUgj0B94Xq3f2rrZ3JteBL5p4qQIN5
X-Proofpoint-GUID: 2Nn648GKaVTJfPVdZ_cGDnTxXodWdwvb
X-Authority-Analysis: v=2.4 cv=TqjmhCXh c=1 sm=1 tr=0 ts=68639942 cx=c_pps
 a=VX/sFGoG5OGT23SVPy1oZw==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10 a=Wb1JkmetP80A:10 a=mCf63rc527wA:10
 a=WDlp8lUfAAAA:8 a=VwQbUJbxAAAA:8 a=13osMLhPKtgnuos-js4A:9 a=wPNLvfGTeEIA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-01_01,2025-06-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 spamscore=0 lowpriorityscore=0 phishscore=0
 bulkscore=0 mlxlogscore=924 suspectscore=0 impostorscore=0 priorityscore=1501
 adultscore=0 mlxscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507010047
X-Proofpoint-TriggeredRule: module.spam.rule.outbound_notspam
Content-Type: text/plain; charset="iso-8859-1"

One question regarding option 2.
Don't I need to rcu read lock the nft_set_flush now because when I prealloc=
ate the transaction I need to make sure that the nelems do not change befor=
e doing the walk?

Best
Sven

________________________________________
From:=A0Sven Auhagen <Sven.Auhagen@belden.com>
Sent:=A0Wednesday, June 25, 2025 4:51 PM
To:=A0Florian Westphal <fw@strlen.de>
Cc:=A0netfilter-devel@vger.kernel.org <netfilter-devel@vger.kernel.org>
Subject:=A0Re: Cannot allocate memory delete table inet filter
=A0
Thanks, I checked and this setup has a lot of sets and some of them have 10=
0-200 entries.
When I clear all the sets I never have the error.
The nft_set_flush must be the reason.

I think 2. is the general solution that should work for all cases then.
I will have a look into that.

Best
Sven

Sven Auhagen <Sven.Auhagen@belden.com> wrote:
> we do see on occasions that we get the following error message, more so o=
n x86 systems than on arm64:
>
> Error: Could not process rule: Cannot allocate memory delete table inet f=
ilter
>
> It is not a consistent error and does not happen all the time.
> We are on Kernel 6.6.80, seems to me like we have something along the lin=
es of the nf_tables: allow clone callbacks to sleep problem using GFP_ATOMI=
C.

Yes, set element deletion (flushing) requires atomic (non-sleepable)
allocations.

> Do you have any idea what I can try out/look at?

Do you have large sets? (I suspect yes).

As for a solution, I can see two:
1). Leverage what nft_set_pipapo.c is doing and extend
=A0=A0=A0 this for all sets that could use the same solution.
=A0=A0=A0 The .walk callback for pipapo doesn't need/use rcu read locks,
=A0=A0=A0 and could use sleepable allocations.
=A0=A0=A0 all set types except rhashtable could follow this.

=A0=A0=A0 Then, we'd just need a way for the generic flush code to
=A0=A0=A0 see that the walk callback can sleep (e.g. by annotation in
=A0=A0=A0 set_ops).

=A0=A0=A0 Upside: Clean and straightforward solution.
=A0=A0=A0 Downside: won't work for rhashtable which runs under
=A0=A0=A0 rcu read lock protection.
=A02). Preallocate transaction elements before calling .walk
=A0=A0=A0=A0 in nft_set_flush(), based on set->nelems.

2) is a bit more (w)hacky but it would work for all set types.
And I could be wrong and the alloc problem isn't related to
nft_set_flush.

**********************************************************************
DISCLAIMER:
Privileged and/or Confidential information may be contained in this message=
. If you are not the addressee of this message, you may not copy, use or de=
liver this message to anyone. In such event, you should destroy the message=
 and kindly notify the sender by reply e-mail. It is understood that opinio=
ns or conclusions that do not relate to the official business of the compan=
y are neither given nor endorsed by the company. Thank You.
