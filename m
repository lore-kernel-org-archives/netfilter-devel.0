Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D853726AE5
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Jun 2026 11:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.156.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782212943; cv=fail; b=nEE8335/oEj++5Yzh6ki+44K1p7C5RpXtqAOU1hAJMD26JSyC31oJYCTJ7BWAgo0H1XFLlWRCNU/D3YfAiToRAGD+UXw8G/TVxAqyzqGawjntnQHwcrM5p7dn2cgXK/qTEAC2tCMvSpmQ5JS2JG1czFuNoPKCi/Itast/bl0+R0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782212943; c=relaxed/simple;
	bh=mM/uX+wa6aDLdPGNieAHwoRX5TkaeKv9zGeBb+iUJqY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ukyvRrvw/dsSQWqINyG8kDpK6sPjH/+K0AtLiVG3ZL8bfAxUvYIcFaHQ4iES1mZkyT+ZH2jMuZ/7dRz7WnbBDn+G2ptl5JhY0iFyzR8d8sV3G6spOpZydXaaO8d3qfQs0bZY4NaO8dGFVTvQ/63CJZPdS+0pZz+Iz55svo1JcCw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b=fydBMF3I; arc=fail smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b="fydBMF3I"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65NAwfJG936704;
	Tue, 23 Jun 2026 04:08:59 -0700
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11022141.outbound.protection.outlook.com [40.107.200.141])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4eyfr79bkb-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 04:08:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TDLe5QJv0m5j0I7x6ahF31hWCZrt91OS+oNSuKcMleDQvfw70R+gXkCuc+BPlG2zoy1g4BGXfygrsfSLzvDgnBUSOrxYIv3iDzlpN/mUXGboFGlqRMMfOuGZ6+7abJa6QhQuO8QnYUfg2PCbnR+Mz7WCT0+SHBPoeg4tisGJaYRFesMOYVnSOzfmMR2kNJGuTY55sQ7aTUlwfcFM6zsuQp2eUuBceo0/hUSJPetf1HeEIxe0x88Jisuof91Oo1tWcdbNnVhRGM5p2ca3w9i/CLwi7Szu5TMa/OCFYa0WsuUyZwl68BBvNF44PXrsk+b1gErgmEKOEHF4tnPtfTL3RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mM/uX+wa6aDLdPGNieAHwoRX5TkaeKv9zGeBb+iUJqY=;
 b=qra7cj+sYL4sXxbKCLAhGYekvCrwyEAMs7I4zHHhUg1DamQRrBpBc2nR2CWCWhCJdsKqEwY+I7jjde5LA1gK5k75pBrUzAnQkO7Nak0Bi3am5pZRi6qiyzJWipnzZOvVE+g84G4Ag4QHXbYc1LJhOEmjrjaz2l1vQNUQyWiVewVVoN0OE8aK2Ka8eeI6ob1GzK+VXLpmfQhFWinDlT9YMwDuQVpKpj4zpgDhH9/bjYiIbviXX0pc24cQ6Z0PX1vyhI3R1VGkkZlBKR3XoiSPalVRhdMhD6utC5WQkuclvC608wjCHXU0ZMvJTn1KkHHGsI7AKX35eFjs0XvTbMz4Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mM/uX+wa6aDLdPGNieAHwoRX5TkaeKv9zGeBb+iUJqY=;
 b=fydBMF3Iqt/zrzsWrGIudprPKEdTgajdcMj8j5zLt9i474cBL+/ByP8zM3VBWM6KlTnkjkIGwSb5mPKXZ3+G7Bw9UAgWSOw+IsVgQpkzhwZs4FxuOBpUqvpzOIQhAIxRkRSHgx/ZZVvX5bYbn7VuAEELNYzL0WB7U/WH9GtsULs=
Received: from MN0PR18MB5847.namprd18.prod.outlook.com (2603:10b6:208:4c4::12)
 by CO1PR18MB4778.namprd18.prod.outlook.com (2603:10b6:303:ed::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.20; Tue, 23 Jun
 2026 11:08:55 +0000
Received: from MN0PR18MB5847.namprd18.prod.outlook.com
 ([fe80::48b4:4ff8:d5f4:a49a]) by MN0PR18MB5847.namprd18.prod.outlook.com
 ([fe80::48b4:4ff8:d5f4:a49a%5]) with mapi id 15.21.0139.018; Tue, 23 Jun 2026
 11:08:54 +0000
From: Ratheesh Kannoth <rkannoth@marvell.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
CC: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: RE: [EXTERNAL] Re: : Re: [PATCH] libmnl: add MNL_TYPE_UARR for
 devlink u64 array attributes
Thread-Topic: [EXTERNAL] Re: : Re: [PATCH] libmnl: add MNL_TYPE_UARR for
 devlink u64 array attributes
Thread-Index: AQHdAvvI43WDuy7/9U2uSQkj1s8sWLZL+VaAgAAAyxA=
Date: Tue, 23 Jun 2026 11:08:54 +0000
Message-ID:
 <MN0PR18MB58475D278990EEFD8E6F2B4CD3EE2@MN0PR18MB5847.namprd18.prod.outlook.com>
References: <20260623043755.2435685-1-rkannoth@marvell.com>
 <ajpWYAQ1Od2ilpAk@chamomile>
 <MN0PR18MB58472CDD42C11ADA73EB5AA6D3EE2@MN0PR18MB5847.namprd18.prod.outlook.com>
 <ajpnjXPm4ccxQOmc@chamomile>
In-Reply-To: <ajpnjXPm4ccxQOmc@chamomile>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR18MB5847:EE_|CO1PR18MB4778:EE_
x-ms-office365-filtering-correlation-id: 2fc4e2d7-09f4-49ec-4c3e-08ded117d0a6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|11063799006|56012099006|4143699003|38070700021|18002099003|22082099003;
x-microsoft-antispam-message-info:
 KDiBDSaB4ADP2NJ/TOJzSS6CBNVXd5fOln46HO90sN7Xn4FGuYCJebf6p8xrs+HJWpswetoMFnByrMTRMxMbHUOFRf33KYCJu2rvsdDWT7zM4lTfnlP6tdGuvqG2iuAYDSfwEEqAAeHU0XeGyXv8p3pHUO6BeSq1LLhsJ7pq5FLUk0/HI83dmsUbTfmSGoGkwXONMlv3I/k+AKHp8NZ08YD+KPNVp2BDHDjVP9T29bOtrj29VkPZdaz83emMaw0whMIBPo0OF0n5lRi6mTvwfWZfTYkir24hZ8JPutyOGSL7NYXMVyUOobggxhg9quLjffoH+bEygeNMLXHtpjx59Lj4rUte5a1AU94dpqkJBbEP4e0ctqLXkPsEs42S9ZH7sPSHboH/dJU4kxM7uGn93VzFGkh0A8rxaxwm8cYVZrWx6vz0KOpRTRhR/qEvZVKpDagwo7jdTeMyfIxn2Bxug7BiCIKdIa5CMN2AG6ujeD7nxtf0NtLab3N4SHMAx4Hk00gqFy1ZKJueuxEsu+lVN/2LYGWa+uFgYkz67YWnAaxJMOKLnrA4qtxz9gLzmRfIIisiuI5c/6yEZOEsJRhR7KumYUJZ4ej4h/9BErgG10ECipPbayc7cr7jAsDGokj8qvj25LVhfoGl+uLL0KvCLaFU/vwoDIuUFYnPBZDSWlnnfLWdTxgJE7jYZTdBFPXixEvolXk1OMhn8ErcyiDWKUgwdj2t5eTqCWVt9frQD6M=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR18MB5847.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(11063799006)(56012099006)(4143699003)(38070700021)(18002099003)(22082099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?U0RRVmlqbTRyV01Mb2lLREcxckZ0YnZTcEFJQkQ4eUdJTmh4VStTalFzT1lV?=
 =?utf-8?B?NHA4cTJUMzJGTjlKcHRWRkxERzNGNW5HeFh5TnptcEtFczhTKzVwME5kRktH?=
 =?utf-8?B?RFYrL1FobjN6WnhWVGpjaUEzeGR3NzVOK2tHV1J2SEF1SHAxZzBtL3BUL3U0?=
 =?utf-8?B?YnN0MVFVK2pPMGNBQ2xueWNkQmdHdFptM1B5TnVudGlIaUVQVVpzNStmM3Ji?=
 =?utf-8?B?YktTUjV0d080ZFpvdmREbzhqNDlJdVdwcjJ1M2NTeTVGVzVwTEppbWgxVmtH?=
 =?utf-8?B?QWF2NFNoQ3lrTGJlTDEyMkk4YUxlMlQyTjEwS3IyZENrc05lcTZsWC9lWmZx?=
 =?utf-8?B?RXczK2ZUdVRVWGxBdGpUSTJ3aUxqUnJ3V01nT3hCNW9NRTZjeGtJYTRPZDli?=
 =?utf-8?B?RzdxVzh1Q2JKQlludkpuaUVrNnlPakdObGpLNkU2TVVDTDBNZkVMU0ZTUnZo?=
 =?utf-8?B?NzdCNXNIUXV6cGk5VHlRTFl1NkpSR0VmQTE3aVUzODFHOHR1M3pRZmpOSmVV?=
 =?utf-8?B?YnhKSE1TbGNwMkxubVoyZ2hic1BSL1REZEEzVXRvb2VkYnBDaDFvcm9yWitK?=
 =?utf-8?B?Mzh1eUFmL1JMVkdsSFk1aW4vQnRsYWZzQ2tNNjlxdm1acjdacFFVb21xQTVK?=
 =?utf-8?B?U01ycC9mOENDcXpiQmlKRXF4ckRHZ0FzZ25xd3g2ZDJDeEVxenA0V3BUNGJx?=
 =?utf-8?B?NEd1OXdqMCtHakpJYTJTdWFzNlE5S3NJYis2bU9OTXUzcDMzdnlwMGdBakZQ?=
 =?utf-8?B?Q0lvd0ljbTAvNFpvQ1RpQ3MvaHkwcXFhNlZnVjMzVm1nM3M3U0t5YXBuY3g0?=
 =?utf-8?B?L1crK1lQaFVMbmFDTUZKeTJjaFJ5eEdIUnNKQVV1UlFMY3NjTThUTnhmVlJB?=
 =?utf-8?B?dW1ObzlGQjJLWThFcmJab3UwbFlVSUo2T3RKbFJ0dzFTQ1FlaldHQzhRaUto?=
 =?utf-8?B?aUlPZXk1b0grakZwREltSHppNGRWRE5VYWkxSGEyQ3lVOUkwcGdnVFg1Rklp?=
 =?utf-8?B?dmN4dkRXWDJ6Z2tDZkQyME93dG1UUVZrcDZMa0kvOGxuakxHM0oyQTBxa2Fi?=
 =?utf-8?B?QXVHZTFGQjYzK0daV0lGalJlckF4a29jVFFFMXdUTlRLcnQ5WHFQRDZGUW9O?=
 =?utf-8?B?dUpTdlpJZHRDL1NqV3ZYczhYT2ZZUUdHc2x0cU15N3dtcUtPMGxzaXBOQ2V4?=
 =?utf-8?B?LzNsZTZjVEppTCtPRlYybjhaVUNEdzJzd2RRK0F4dFJuRmF5QmNXK2xwN0J4?=
 =?utf-8?B?MEw5WlFJem42QWRSYkRaUFZVdmE1WFlDUDZSTkJ1anFaeCtxai9RYTR0eXpo?=
 =?utf-8?B?YVFiWWhjWW1va2FXSENmdk5hK0ViQ241NFFIT1BJZnIyTDhsTUNER0dBYlFF?=
 =?utf-8?B?d0RkVmRWSStXTGxUWWJaMkRNNjRsREJVcm12cFFCUXd4akNHa3pPR0Q3T0JV?=
 =?utf-8?B?a01DODdNcThpaDR1QnhUU2h0c0tkNUJmUjNZVVVoYkc5c0ZsQzV5cGFMS3ZJ?=
 =?utf-8?B?bHdqUEhKWmxZS1VGR3Q0YlBMcGY4RitLbEZGejJYYjNlay8rSEI0SHZ5ZTVm?=
 =?utf-8?B?TGYzQlpnL2RnQWRPcFBROERBZ1hSRkI3OWhIOWVTR0RyOElDejNEWGJUVHpW?=
 =?utf-8?B?S1R6eXJUb1VOaVlCQldaM2NMMTlzUmVuaFk4UCtHTGcyaWlGanNPU2ptZndn?=
 =?utf-8?B?bXJ6c3BKdy9OTTlwT2FoYzBFTGJzVzIzT3plclZJTG9xckNEYTJuWkpSYzlZ?=
 =?utf-8?B?cEJDajVyRDdHYkNwTjhCM3VMeFVvdk5YUk45enFYWkhpeEFuSXBldndYQnNm?=
 =?utf-8?B?ZllpQlVUcHNOUVhCL1oyWVM5RVRsQUNIUUFvMHlySGd1YURuOGJ0WStCRm9U?=
 =?utf-8?B?OVJpQThKZXltSk56K0dXWnF3d2dRQjRSMlpDLzdQUzArdnZyb0JKWHIvbXhF?=
 =?utf-8?B?OGJLelQyRldCNHNDdGhJd1FsNW9BMjZseldST0ltZDV1R3RzeFRsUDA2cTYy?=
 =?utf-8?B?YXlOU3ptUEJqZFBPQ045WXlQeFB1TEhZbk55Q00vdFpINlFWNVNpOVZFcHhS?=
 =?utf-8?B?b1dpYlA0RHJrNFBXZnR5WW5GYjU5anBIQ3F0Um4zZWNoeDJxSzRVellUMUN5?=
 =?utf-8?B?MWlUeWF1YUdVRXBEV2QvWHBUR1YyV09BZVBRaS9BclJGRmtBNlJmRmhqY2Na?=
 =?utf-8?B?a1FyM0pMYWV1MWhtMDJwQlJ5MmJ4ejA4N0Y5ZExIVW9naDZoV3RuT1lJMk53?=
 =?utf-8?B?NnZKSzBQUEhNOEM0RlNyL2J0d0dhTStrVE42SkhHeHVBK3BwT1RLSEdQWmhJ?=
 =?utf-8?Q?1qOSAlcwjIM6OhIJN/?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	ZiSzwnpHQFi37W9LGIiexINo3cfD5pxWgrazEeqfuCnfGy75dK8KEQSccaOpjNZ7T/uhI55R9E5iUeHkpKUhETUTiK3r8YtkeRGKZdaSxO5LPc70i7aervqt9PuoVkYG99b7fOArXTgJ9kwqxbvyXd1F61E0XfxHqq256CQzJK9eEl8rhg7cuKxqCBXMwqxXuON/8aHV6BhYgt3mw05h4I06or8XFCTtDDAqRs28vHTPGWZLa1lJYo+WBeAocYWOZ1kzKQwrBQzRO2VUnRLSwT7M8u6Ku31epTUUAwau7YKCj4egWzJ2tqP/IdBFnjuhCLC+rvkEDuMr1KsiomLArA==
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR18MB5847.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fc4e2d7-09f4-49ec-4c3e-08ded117d0a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2026 11:08:54.7911
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fNWE/pqPnMAxt9JYcoW/I44/tjTddmjS10jLC0roixt3OaWv+54b5BjEkRTFcphSOXNV+ke7UHDuRrBK8VaATw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR18MB4778
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIzMDA4OSBTYWx0ZWRfX0Oqe88v7mpC0
 SU+GjM096Fbj7jiEzMsAjBZi1OkdYknVstEU9YKKIFYKAIsypcVwWmnzz08lD/IFeh/jlLMXw0g
 1bS0sXdZUUhUnoEnBSLTK/h1lblbjbI=
X-Proofpoint-ORIG-GUID: td87H0YEVcipdx0_Z-wGvgrGjvB-8QY8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIzMDA4OSBTYWx0ZWRfX3e4MO1i2IAUn
 pNHuC6k+uZTDFphF3Wl2zYugyzhDnSyP/ySdotfrEOQbaglUVDoR+1ETlTWQGfxVLazFJuVPh8B
 A6m7YAcEs0q35ofgy76WkysQARps5k5EuWdmFaflEWkdH2Ma8XVL045YdYZJdI9Okqy3Dnkvii+
 IRRMHRs/+m0y5QCmtNGUjX+QqPknvtMTrZTQ0V2mrzOK9t8H+PedOC78u0mcEKIoxNRbBuiB1cI
 0sM+QhkkL0U66uBRIEDhw6FQNpIcRgpIwN4LJkpqM7T72lG1QMd+6ebb3wzu6QliLQGzxCvl0zo
 9LA2KZ29KtVLxeYf0waz9Hgko6dBI58glT8KauxG8yXT26EpcunGgC5sbkwW/6OQuUUMdkJg5Db
 VAncN0JMDxPW6WvD65+BUyhmYqEAuik4IfyoYx3GS95RSfkbjcNkO27nkxSbjLFVLXZnDke6Lrl
 i2M+n2OfgpG/ujJ5v4g==
X-Proofpoint-GUID: td87H0YEVcipdx0_Z-wGvgrGjvB-8QY8
X-Authority-Analysis: v=2.4 cv=UIvt2ify c=1 sm=1 tr=0 ts=6a3a694a cx=c_pps
 a=vBdzEPurzP6004a/ctmFDg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=-AAbraWEqlQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=l0iWHRpgs5sLHlkKQ1IR:22 a=QXcCYyLzdtTjyudCfB6f:22 a=RpNjiQI2AAAA:8
 a=3HDBlxybAAAA:8 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8 a=O7PW6qKcQYa6RJwa8w4A:9
 a=QEXdDO2ut3YA:10 a=laEoCiVfU_Unz3mSdgXN:22 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-23_02,2026-06-23_01,2025-10-01_01

RnJvbTogUGFibG8gTmVpcmEgQXl1c28gPHBhYmxvQG5ldGZpbHRlci5vcmc+IA0KU2VudDogVHVl
c2RheSwgSnVuZSAyMywgMjAyNiA0OjMyIFBNDQpUbzogUmF0aGVlc2ggS2Fubm90aCA8cmthbm5v
dGhAbWFydmVsbC5jb20+DQpDYzogbmV0ZmlsdGVyLWRldmVsQHZnZXIua2VybmVsLm9yZw0KU3Vi
amVjdDogW0VYVEVSTkFMXSBSZTogOiBSZTogW1BBVENIXSBsaWJtbmw6IGFkZCBNTkxfVFlQRV9V
QVJSIGZvciBkZXZsaW5rIHU2NCBhcnJheSBhdHRyaWJ1dGVzDQoNCj4+IE9uY2UgdGhpcyBsaWJt
bmwgcGF0Y2ggaXMgbWVyZ2VkLCBJIHdpbGwgdXBkYXRlIHRoZSBoYXJkY29kZWQgMTI5IHRvIHVz
ZQ0KPj4gTU5MX1RZUEVfVUFSUiBpbjoNCj4+IGh0dHBzOi8vdXJsZGVmZW5zZS5wcm9vZnBvaW50
LmNvbS92Mi91cmw/dT1odHRwcy0zQV9fcGF0Y2h3b3JrLmtlcm5lbC5vcmdfcHJvamVjdF9uZXRk
ZXZicGZfcGF0Y2hfMjAyNjA2MTUwNDEwNDIuNTQ5NzE1LTJEMS0yRHJrYW5ub3RoLTQwbWFydmVs
bC5jb21fJmQ9RHdJQmFRJmM9bktqV2VjMmI2UjBtT3lQYXo3eHRmUSZyPWFla2NzeUJDSDAwX0xl
d3JFRGNRQnpzUnc4S0NwVVIwdlpiX2F1VEhrNE0mbT13RGl1ZWhXUTE0OWlGMTFzbXctb0otPjJE
WWN1bWNaMnBfVE90NmNaak5yQklKRXBKR2NIck1uemFvSmxEU0RWNSZzPTRsbGViWG9VOXpERjVN
OVhLNXZaOUxOTS1KcS1rYUNJaUJVcGZxZlplcWcmZT0NCg0KPlRoaXMgdmFsdWUgaXMgb25seSBp
bnRlcm5hbCBmb3IgX19tbmxfYXR0cl92YWxpZGF0ZSgpLCB0aGlzIHZhbGlkYXRlcw0KPnRoZSBh
dHRyaWJ1dGUgdHlwZS4NCg0KPkkgdGhpbmsgdGhpcyBpcyBub3Qgd2hhdCB5b3UncmUgc2VhcmNo
aW5nIGZvci4uLg0KVGhhbmsgeW91ICEuIFlvdSBhcmUgcmlnaHQuICBQbGVhc2UgYWJhbmRvbiB0
aGUgcGF0Y2guIA0KDQoNCg0K
