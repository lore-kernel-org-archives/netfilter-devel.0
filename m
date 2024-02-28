Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04902D60C
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Feb 2024 08:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709109675; cv=fail; b=uG7zyinWM+gLZ+E/lYlJDqqJqrhryoGOxThfno5MBdQB9eDGgjDiItwKSFiWIFfNwkjly/2cyY+qkDYCNKoLgbukqlfxvLiROAPAB5ojd0AVF2FjcIqV9fpm59jtLDlMLnJzK4+2tGF8Q7+oxLaayTd0tN0WccYs+q6G7nu/Tw8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709109675; c=relaxed/simple;
	bh=MS8ECbTTc45ps+9hD4fFWDcMy8ck5oVoPXuqTaAa4xo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mkEeEvyGZqgy9x0jYoDqTkmbudOsNfCcVE2HjPpX5Ml94cENRPl5sj5Ft5H8JHTRQz2WTeWwrV7KZIzdtvpttzpC6LYssSPpSurOd/OTx/tWZq3lR+aDU8yYc9o9PfnVMGj5Iwrc/uyWsDX+2AKuJ1HAyoepVxaeaJpfzWx0Mr8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=lYitXtzs; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=wEMdmuVC; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="lYitXtzs";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="wEMdmuVC"
X-UUID: 1de72d1ad61511ee935d6952f98a51a9-20240228
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=MS8ECbTTc45ps+9hD4fFWDcMy8ck5oVoPXuqTaAa4xo=;
	b=lYitXtzsXwrtj1uTWAJszuDZYgCKkkxT8DEyygy6eGAh+5I+pYW6+mX663zgY2AfyZrFoMdRfV9xP+zBzTSARz8GfFq36CjbcpNO6PzhiMjEqoBY8vIAfPSorglTpuxThM3D59XVz2r5/zoyGcct03T/RRu+aEpEQ3DvhI7+Wes=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.37,REQID:e6b7693d-f622-45fd-9cad-cdc34ed13671,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6f543d0,CLOUDID:a51dce8f-e2c0-40b0-a8fe-7c7e47299109,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 1de72d1ad61511ee935d6952f98a51a9-20240228
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <lena.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 156640336; Wed, 28 Feb 2024 16:41:07 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N2.mediatek.inc (172.21.101.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 28 Feb 2024 16:41:06 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Wed, 28 Feb 2024 16:41:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C1zwP/9mb5OPuUT4m9Uh1eeGEoBHEduTn9LGntB0z6TbtXY/539MNtcTPA5Wka6LnFNO5bWDHpUyChjDnfMHzW1qL+taAiNWaosfu/dIum+qZEdsMtYR3wXa2jGB/vFl1opk1CB7Rw1WGDNm7XUrdBcG10kP7bKyLb8fniof+Cxr1eo+bMYKuvCGlhYQMr1rNPytI8KqpbObO1wxhGUwCW2V3n8xto6cU6oQ/2+fSIje9p/QKokqPdCD+3aTocRsiadyF51snfxj0DNi13zgtnOJo4htoHdsj655tnjudhvLQTyMvXZerq0cc877Uh9RoNsAjMR0CnuL7wl5TKQezA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MS8ECbTTc45ps+9hD4fFWDcMy8ck5oVoPXuqTaAa4xo=;
 b=RyWTbPict3OoSk24kjQaxzBdkY13V2AKkzOi3HjFggt3UXRWkBPgO6dX4FllP7HJr8HbX9/bj66a2X0ItNEK2LofsYoy4zL4605yUGnluiOjV6IaBOs29Fi7DLomWhzicIXGYDDrqOMIP/wESOaImn90jhRy13uR8YOb1Hga5B5lX3qMAxqhdqkoNTVdOWViynKDedn7yjjEwaMyAYdqr/pVCsnkojAr1wHp5FBWAiP8uM++IZEON7Glg3zAj3VNLbbZKAyjgNpYp5vlQPF9JTNgMoA1AYRI12FmySUOgrv26w7UzXDmg6oOavXG4l8C7nMinMKiOYKR7VqVjVmayg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MS8ECbTTc45ps+9hD4fFWDcMy8ck5oVoPXuqTaAa4xo=;
 b=wEMdmuVCALAB4gSsYZioNGfM1VfulFypA0+HRFrk4oX6TAe0TpVPBs5vKXG/uJwwiUcbR/OXudgZfzpHMD48q2hO1Aagvz4xlua6/TiP4YGwoACmIyNhEx3MhwMMPK3mPzoSnfg4KqNPd5yc7ZjgqLdVLhDUqA1MfXOO7u22aXc=
Received: from SEZPR03MB6466.apcprd03.prod.outlook.com (2603:1096:101:4a::8)
 by TYZPR03MB7847.apcprd03.prod.outlook.com (2603:1096:400:464::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.33; Wed, 28 Feb
 2024 08:41:03 +0000
Received: from SEZPR03MB6466.apcprd03.prod.outlook.com
 ([fe80::8814:cbff:5bbb:98ea]) by SEZPR03MB6466.apcprd03.prod.outlook.com
 ([fe80::8814:cbff:5bbb:98ea%2]) with mapi id 15.20.7316.035; Wed, 28 Feb 2024
 08:41:03 +0000
From: =?utf-8?B?TGVuYSBXYW5nICjnjovlqJwp?= <Lena.Wang@mediatek.com>
To: "fw@strlen.de" <fw@strlen.de>
CC: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] Add protection for bmp length out of range
Thread-Topic: [PATCH] Add protection for bmp length out of range
Thread-Index: AQHaadevO0DwJD4/xEOirZ3z+A1vfbEfbEuA
Date: Wed, 28 Feb 2024 08:41:03 +0000
Message-ID: <e6ba89ec0be6cb1aca828f5fad5155b8d96b6941.camel@mediatek.com>
References: <Zd5uTlqVBBFpyjMB@strlen.de>
In-Reply-To: <Zd5uTlqVBBFpyjMB@strlen.de>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SEZPR03MB6466:EE_|TYZPR03MB7847:EE_
x-ms-office365-filtering-correlation-id: e14485d0-9e59-431d-250e-08dc3838ffa6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pBbbFxeowKxPvT43dMjWWTvVcuCkyU9ef1UADthjVF6RjZrMX7ndfskC9ZYDUIKN7mpGdFOqag9J8WrK1pTVnkvt7tqdMR5nxXO+NtAiMUE/Dzu6I5++KcYxrOWQsIobODOdDoLKK1JHHEWCnr8p44F/eks/mvZuFyAnERjv3BXCOQ3u07UV4xtUwO5vnsjWnO5N8iLsAYGDVDlAcunGnkcJrdnq34Gv5hGLArApbW9CwxD9H22g238atG2dlvIXRZ+KydBM0MT/wqniArkPBmnkKwLm/u+GdE4cCQYlJBERrvTEhd9xA4Whr0/5T9WjQM6W4hqjg9X800cts4e56eK+O8TkW4VJa/Cs0RMFqRO+sGze77eV/1cRmOjDqGLOfIsfVSiFrXlLI4GvHX8+4+EjL9XCfzKFnT7DTE2FKVTqTC7+WAy6nxox+rxcp3ArJ5M1McPzrNy5RXae2h25eCQb8wqL5UMjXXD5+Aw3cqvXe4l0VaXl93XeTQBcm7vMw37d20iKwKOyvUUN79DjHQpyHgJyVFqr3v/pOi2ZhDuXv0d5xA//uAqmtByUPhajqzS6MzwNaHovUozINPaiHolGZv8x16C9TeGdjTqTBkVMrQErQqPbLHV9PRqE87HY5W0wgOxjoY35QL1XLN4VPh2Voh0h+ayWEio8MVtUgQfy0oC/N/82ZWFz0EDzs/5ujnWNg42d3AoqntrMAfeh461b59QDRqMWzf8BN0iWqmU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR03MB6466.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(230273577357003)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UUVZblV0ZFFvbzJJaTNtamN4YnppSjlxNjRCQ3hwSVB5RldBdCs0RWNDQTZj?=
 =?utf-8?B?R0pLRUUrSnk2QlBiQlRDazNVampYUWpFQVRUYkxOYXNEU0xjQVZrR2F6NjVp?=
 =?utf-8?B?TmVFb1BVQ2s4YXJpUXN5eVJIZVN5aWkxWTZITnYrL1hVc3ZjM3luVWdWU1Np?=
 =?utf-8?B?Qld6N1oxUUZXU2dHYjRiK2FFSU9IelJDSGV5R25zR2tYQ3BZN1RDbGp3Vnlt?=
 =?utf-8?B?RlBwZHNpVzgxZ0JuZXlTanhtN0F1VVdhWVpwcUVESnF6SE5hc1dpdDc2S0I3?=
 =?utf-8?B?WjdWYlZacklHeTAzVngvQXFiVE4rVTN3cDJpUmRsVEMwekxyMWNOTnlTNk9Z?=
 =?utf-8?B?UUF5SGNqRytGcUk4UGxXNjVML1NJL0xPTXNacTMwOFJkKzBLNUJPWS9DVTI3?=
 =?utf-8?B?QXFNT3ppTjJPdU9VQldyNTgwakt6cHVObmRNcTNkYkJIZTkrdGFVcTlTU25y?=
 =?utf-8?B?aWl3MmhJOUxnQUl3Z3JsZ1ZRTVB3WVNVRXptSFI5YXRlTEFrM2dqWDZiRVlz?=
 =?utf-8?B?TzdZN0tEaTBpK3FXYVNXMTVBY05obHozdnlIM1FOVkplekhibVFhK1d3L2JN?=
 =?utf-8?B?dUZyU2tWK1NGaVhOejFCVG1HV3crWnE3L2duckh0SXVaYlJGZGZVMUVIc2tt?=
 =?utf-8?B?bzFmbWxxdUlWaVdZb1BabEhWenJTWENmQ0lvVFo5ai9PK2pHK295RS9rb2Vn?=
 =?utf-8?B?R2IxM3RMYXdyNE8zMkJ0ZHZCUkxPZ0tCVDhLM2N2QUcwU1RCOEdoc0tZbm5L?=
 =?utf-8?B?WkdKMlQxL01jdmFzc004MzJkV0V2WWo1ZWZuQlArWkZzNFkyODlRVjBCeFUx?=
 =?utf-8?B?U3ozT2lId0F0NDZVVlFVR3lIS1ZsWE56bnIvN1ppeWtObjdiUEJnNVo1b21u?=
 =?utf-8?B?UXNITVM2cWlObmh4QTN4QUFZaG9ndXg1QzBvaVFUMWtNOEtaRmpKcyszcm9t?=
 =?utf-8?B?TEdZUk5PMTJiSll2MFBobzJXM2Z0WHZ3RGhGY1lycWgwYUhqc3k0VzcwWjFM?=
 =?utf-8?B?RXpRT29KR1VESXFraStIWEs4Nkx4TWU5SUVNcGVCODNucVQyZkVHMDRnN0dW?=
 =?utf-8?B?bExydXBWK0lCaWo1QU5WdHB4VVNscGhjMG9pVDNNTHJPZ3FsZy9zS2tQVXRj?=
 =?utf-8?B?TSswOHk1MEJqNHFaRVdsMDVldmZpd1dzVU9LcDNWNVEwQkZpRFFVcFg2NVMr?=
 =?utf-8?B?ZDZUNG5MWHVobmlqU2twcUErT3VmbGVPWFNnVWJoZHV0YjFzQWxETHgvOVZq?=
 =?utf-8?B?VXJtNkQ2MkJWTDlFSHVRY2FzMGR2YTBIL3FPUTRZdys0N0lYbFZBTGZqalhG?=
 =?utf-8?B?TmsxQ0wwNHJ3emhuZzMwZ2NPMjBDN2hVMm1pYUxtN2EwNXpuTlV1Mnd3VWtI?=
 =?utf-8?B?OTRTeUFUZThvZzJOK3hNOHA0SWlTdGF4NUhhOE5DaTFkTG5RdnR3UWoyQzd0?=
 =?utf-8?B?RGxUVlRrNDFUU2ZicE8wVTRCK3NBMlVzZEx1akxZeDc4aXdDb2pNUG84RkJo?=
 =?utf-8?B?Y0ZPNjQ0cldNM1hYVjIzT3JzdnZWUmtpWmlTNDcvZXBVMnkrSytLZFFDQ3R5?=
 =?utf-8?B?RjZyUitYSS9NRWRLaFhNc3UwRmZYYjcrM0VUUzFPSlh4ZzB5WDZFZkdobmNp?=
 =?utf-8?B?L2tBclRQQ2NpeUwyZVJTOENmRHZGSUxZUHVnRmhGNHJ4TGN3SVBTSy9pOUla?=
 =?utf-8?B?STJjcDl4RGREYXZXeU5FWWpTV1d5NVBhVmpZdjQ3ZU9qMUVCOXcrTitVN0E3?=
 =?utf-8?B?WVZDbWdQRXZqYlZJOGRLejR0blZTaDE3bXVpejRncEdyeXlNb3JERnBBbWRB?=
 =?utf-8?B?dUV2ZkMyQW1MVEZmMzhvcEdNUE5UTmE1aVR0NUpQUnpaWmJ4QlNzOU1jZk9v?=
 =?utf-8?B?eXBlVWlzNXJtbDdLNjRYeDBnUVdNMVIwNXA5b1BHVjF5MExSakt4S0QzYWx2?=
 =?utf-8?B?ckhrYXBlM1lEZ0FrVmJYcVZTYXdxMU5kT09wamRxOUp1SVV3bFhaTWhPem9K?=
 =?utf-8?B?eTNuY2xYTlhadzFIV1lnYUpUbHZjUlFUeTVXM05mSkVBU0lya1cxVzlMejlH?=
 =?utf-8?B?ZFUxb1hYV0VQYVJ5RUhEYjJwQmYvdXpxUnV5dWh3NU9rc05jR1UvTzY4VHdV?=
 =?utf-8?B?TE5MRGcxSXl2ajlqcEhubmhTUDg1a3hJR2pzYkNBRFhpNk5vSDJvWkNNZkly?=
 =?utf-8?B?N3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <105F3EBA53F4134299425673BC297300@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SEZPR03MB6466.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e14485d0-9e59-431d-250e-08dc3838ffa6
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2024 08:41:03.7741
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TqBFp1h6pEEmeIdi5/SgcRYNky5ir/PG0CAPguRc28Wdibbpo/0+7cwRsJN4+Xsn+hpzEQiEPtJytdCYAWpL0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB7847
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--21.622500-8.000000
X-TMASE-MatchedRID: UuaOI1zLN1iFh/7ZHArNZya1MaKuob8PCJpCCsn6HCHBnyal/eRn3gzR
	CsGHURLuwpcJm2NYlPAF6GY0Fb6yCkF8Z0jCZWN8mlaAItiONP1Hnik1cEYK6bv408/GP5Hq+r4
	ksoUQ8wVW+rzIcpyAZkPo1ReogOLgE6qoNXpB3JzG693ff8j9ZBZO94uK1VSBVzOmd/bB9b7tAK
	hUF11H+zCOdGFPzIe9EG4tJ9m3jKxzgDEqoQagek+4wmL9kCTxFTmqwD90nsI2lCztgMwyoDPDA
	BDXPPETKvj2wLbLvvnXM7RcFSw5Z2JZXQNDzktS4pdq9sdj8LVn+sA9+u1YLdb1HR1TV5h09tSE
	+/rqNhjU0OGKE76N6BZX+gsJvjz2lwV2iaAfSWfSBVVc2BozSnJnzNw42kCxxEHRux+uk8jpP8t
	MOyYmaA==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--21.622500-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	3558932800CA8D25F7A99AD76B906815157E2785CAD6EF95A39115C4AC483B0D2000:8

T24gV2VkLCAyMDI0LTAyLTI4IGF0IDAwOjIwICswMTAwLCBGbG9yaWFuIFdlc3RwaGFsIHdyb3Rl
Og0KPiAgCSANCj4gRXh0ZXJuYWwgZW1haWwgOiBQbGVhc2UgZG8gbm90IGNsaWNrIGxpbmtzIG9y
IG9wZW4gYXR0YWNobWVudHMgdW50aWwNCj4geW91IGhhdmUgdmVyaWZpZWQgdGhlIHNlbmRlciBv
ciB0aGUgY29udGVudC4NCj4gIGxlbmEgd2FuZyA8bGVuYS53YW5nQG1lZGlhdGVrLmNvbT4gd3Jv
dGU6DQo+ID4gVUJTQU4gbG9hZCByZXBvcnRzIGFuIGV4Y2VwdGlvbiBvZiBCUksjNTUxNSBTSElG
VF9JU1NVRTpCaXR3aXNlDQo+IHNoaWZ0cw0KPiA+IHRoYXQgYXJlIG91dCBvZiBib3VuZHMgZm9y
IHRoZWlyIGRhdGEgdHlwZS4NCj4gPiANCj4gPiB2bWxpbnV4ICAgZ2V0X2JpdG1hcChiPTc1KSAr
IDcxMg0KPiA+IDxuZXQvbmV0ZmlsdGVyL25mX2Nvbm50cmFja19oMzIzX2FzbjEuYzowPg0KPiA+
IHZtbGludXggICBkZWNvZGVfc2VxKGJzPTB4RkZGRkZGRDAwODAzNzAwMCwgZj0weEZGRkZGRkQw
MDgwMzcwMTgsDQo+ID4gbGV2ZWw9MTM0NDQzMTAwKSArIDE5NTYNCj4gPiA8bmV0L25ldGZpbHRl
ci9uZl9jb25udHJhY2tfaDMyM19hc24xLmM6NTkyPg0KPiA+IHZtbGludXggICBkZWNvZGVfY2hv
aWNlKGJhc2U9MHhGRkZGRkZEMDA4MDM3MEYwLCBsZXZlbD0yMzg0MzYzNikgKw0KPiAxMjE2DQo+
ID4gPG5ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX2gzMjNfYXNuMS5jOjgxND4NCj4gPiB2bWxp
bnV4ICAgZGVjb2RlX3NlcShmPTB4RkZGRkZGRDAwODAzNzFBOCwgbGV2ZWw9MTM0NDQzNTAwKSAr
IDgxMg0KPiA+IDxuZXQvbmV0ZmlsdGVyL25mX2Nvbm50cmFja19oMzIzX2FzbjEuYzo1NzY+DQo+
ID4gdm1saW51eCAgIGRlY29kZV9jaG9pY2UoYmFzZT0weEZGRkZGRkQwMDgwMzcyODAsIGxldmVs
PTApICsgMTIxNg0KPiA+IDxuZXQvbmV0ZmlsdGVyL25mX2Nvbm50cmFja19oMzIzX2FzbjEuYzo4
MTQ+DQo+ID4gdm1saW51eCAgIERlY29kZVJhc01lc3NhZ2UoKSArIDMwNA0KPiA+IDxuZXQvbmV0
ZmlsdGVyL25mX2Nvbm50cmFja19oMzIzX2FzbjEuYzo4MzM+DQo+ID4gdm1saW51eCAgIHJhc19o
ZWxwKCkgKyA2ODQNCj4gPiA8bmV0L25ldGZpbHRlci9uZl9jb25udHJhY2tfaDMyM19tYWluLmM6
MTcyOD4NCj4gPiB2bWxpbnV4ICAgbmZfY29uZmlybSgpICsgMTg4DQo+ID4gPG5ldC9uZXRmaWx0
ZXIvbmZfY29ubnRyYWNrX3Byb3RvLmM6MTM3Pg0KPiA+IHZtbGludXggICBpcHY0X2NvbmZpcm0o
KSArIDIwNA0KPiA+IDxuZXQvbmV0ZmlsdGVyL25mX2Nvbm50cmFja19wcm90by5jOjE2OT4NCj4g
PiB2bWxpbnV4ICAgbmZfaG9va19lbnRyeV9ob29rZm4oKSArIDU2DQo+ID4gPGluY2x1ZGUvbGlu
dXgvbmV0ZmlsdGVyLmg6MTM3Pg0KPiA+IHZtbGludXggICBuZl9ob29rX3Nsb3cocz0wKSArIDE1
Ng0KPiA+IDxuZXQvbmV0ZmlsdGVyL2NvcmUuYzo1ODQ+DQo+ID4gdm1saW51eCAgIG5mX2hvb2so
cGY9MiwgaG9vaz0xLCBzaz0wLCBvdXRkZXY9MCkgKyA3NDgNCj4gPiA8aW5jbHVkZS9saW51eC9u
ZXRmaWx0ZXIuaDoyNTQ+DQo+ID4gdm1saW51eCAgIE5GX0hPT0socGY9MiwgaG9vaz0xLCBzaz0w
LCBvdXQ9MCkgKyA3NDgNCj4gPiA8aW5jbHVkZS9saW51eC9uZXRmaWx0ZXIuaDoyOTc+DQo+ID4g
dm1saW51eCAgIGlwX2xvY2FsX2RlbGl2ZXIoKSArIDEwNzINCj4gPiA8bmV0L2lwdjQvaXBfaW5w
dXQuYzoyNTI+DQo+ID4gdm1saW51eCAgIGRzdF9pbnB1dCgpICsgNjQNCj4gPiA8aW5jbHVkZS9u
ZXQvZHN0Lmg6NDQzPg0KPiA+IHZtbGludXggICBpcF9yY3ZfZmluaXNoKHNrPTApICsgMTIwDQo+
ID4gPG5ldC9pcHY0L2lwX2lucHV0LmM6NDM1Pg0KPiANCj4gQ2FuIHlvdSB0cmltIHRoaXMgYSBi
aXQ/ICBUaGVyZSBpcyBubyBuZWVkIHRvIGhhdmUgYSBmdWxsIHN0YWNrdHJhY2UNCj4gaW4gdGhl
IGNoYW5nZWxvZy4NCj4gDQpZZXMgYW5kIEkgd2lsbCBjaGFuZ2UgaW4gdjIgcGF0Y2guDQpUaGFu
a3MuDQoNCj4gPiBEdWUgdG8gYWJub3JtYWwgZGF0YSBpbiBza2ItPmRhdGEsIHRoZSBleHRlbnNp
b24gYml0bWFwIGxlbmd0aA0KPiA+IGV4Y2VlZHMgMzIgd2hlbiBkZWNvZGluZyByYXMgbWVzc2Fn
ZSB0aGVuIHVzZXMgdGhlIGxlbmd0aCB0byBtYWtlDQo+ID4gYSBzaGlmdCBvcGVyYXRpb24uIEl0
IHdpbGwgY2hhbmdlIGludG8gbmVnYXRpdmUgYWZ0ZXIgc2V2ZXJhbCBsb29wLg0KPiA+IFVCU0FO
IGxvYWQgY291bGQgZGV0ZWN0IGEgbmVnYXRpdmUgc2hpZnQgYXMgYW4gdW5kZWZpbmVkIGJlaGF2
aW91cg0KPiA+IGFuZCByZXBvcnRzIGV4Y2VwdGlvbi4NCj4gPiBTbyB3ZSBhZGQgdGhlIHByb3Rl
Y3Rpb24gdG8gYXZvaWQgdGhlIGxlbmd0aCBleGNlZWRpbmcgMzIuIE9yIGVsc2UNCj4gPiBpdCB3
aWxsIHJldHVybiBvdXQgb2YgcmFuZ2UgZXJyb3IgYW5kIHN0b3AgZGVjb2RpbmcuDQo+ID4gDQo+
ID4gU2lnbmVkLW9mZi1ieTogbGVuYSB3YW5nIDxsZW5hLndhbmdAbWVkaWF0ZWsuY29tPg0KPiA+
IC0tLQ0KPiA+ICBuZXQvbmV0ZmlsdGVyL25mX2Nvbm50cmFja19oMzIzX2FzbjEuYyB8IDIgKysN
Cj4gPiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKQ0KPiA+IA0KPiA+ICAgICAgICAg
aWYgKGJhc2UpDQo+ID4gLS0NCj4gPiAyLjE4LjANCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvbmV0
L25ldGZpbHRlci9uZl9jb25udHJhY2tfaDMyM19hc24xLmMNCj4gPiBiL25ldC9uZXRmaWx0ZXIv
bmZfY29ubnRyYWNrX2gzMjNfYXNuMS5jDQo+ID4gaW5kZXggZTY5N2E4MjRiMDAxLi44NWJlMWM1
ODllZjAgMTAwNjQ0DQo+ID4gLS0tIGEvbmV0L25ldGZpbHRlci9uZl9jb25udHJhY2tfaDMyM19h
c24xLmMNCj4gPiArKysgYi9uZXQvbmV0ZmlsdGVyL25mX2Nvbm50cmFja19oMzIzX2FzbjEuYw0K
PiA+IEBAIC01ODksNiArNTg5LDggQEAgc3RhdGljIGludCBkZWNvZGVfc2VxKHN0cnVjdCBiaXRz
dHIgKmJzLCBjb25zdA0KPiA+IHN0cnVjdCBmaWVsZF90ICpmLA0KPiA+ICAgICAgICAgYm1wMl9s
ZW4gPSBnZXRfYml0cyhicywgNykgKyAxOw0KPiA+ICAgICAgICAgaWYgKG5mX2gzMjNfZXJyb3Jf
Ym91bmRhcnkoYnMsIDAsIGJtcDJfbGVuKSkNCj4gPiAgICAgICAgICAgICAgICAgcmV0dXJuIEgz
MjNfRVJST1JfQk9VTkQ7DQo+ID4gKyAgICAgICBpZiAoYm1wMl9sZW4gPiAzMikNCj4gPiArICAg
ICAgICAgICAgICAgcmV0dXJuIEgzMjNfRVJST1JfUkFOR0U7DQo+ID4gICAgICAgICBibXAyID0g
Z2V0X2JpdG1hcChicywgYm1wMl9sZW4pOw0KPiANCj4gVGhlcmUgaXMgYW5vdGhlciBnZXRfYml0
bWFwIGNhbGwgZWFybGllciBpbiB0aGlzIGZ1bmN0aW9uLCBjYW4NCj4geW91IHVwZGF0ZSB0aGF0
IHRvbyBhbmQgc3VibWl0IGEgdjI/DQo+IA0KPiBUaGFua3MhDQpUaGUgZmlyc3QgY2FsbGVyJ3Mg
bGVuIGNvbWVzIGZyb20gZmllbGRzIGYtPnN6IHRoYXQgZGVmaW5lcyBpbg0KbmV0L25ldGZpbHRl
ci9uZl9jb25udHJhY2tfaDMyM190eXBlLmMuIEl0IHdpbGwgbm90IGV4Y2VlZCAzMi4NCklzIGl0
IG5lY2Vzc2FyeSB0byBhZGQgdGhpcyBwcm90ZWN0aW9uPw0KDQpUaGFua3MuDQoNCg==
