Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2086.outbound.protection.outlook.com [40.107.92.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E1A1C693
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Oct 2024 09:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727774363; cv=fail; b=u/XTBtz+MB+pZAOOw0oJRylFGFImTYUEO3GiHKEtIIpai2lT+U8J7XRSIk5kq7MTdLrmKiAmYGEOsNRnFyMO3Xaks+zmhnfA6FQlDz8HIAwGkoKqED9I/XSjtnUTlzVN/B/CWYfzWW+wcbwNBnH9r8nAAyP2KiR4cqLJXgy6sHU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727774363; c=relaxed/simple;
	bh=2GRc/bxKNxF/NswYk+G3q2ZtFIY9TRBmowWlzOy6zI8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=g7L72sJ6rPl0iNTEmxQTjX6XYoFmqBO6ps7EpKVuUSlM13vpj0gUZ7ZbfzPSPI4TfSOSBMOkMsn3d12YXCDfCcGfd7nXz2rN3kcttHbBD03A0tipkuDcp5nCQhv62PfWrzREybImedlaDjItVfb8ueoZ5ocwQPFwboWy2rsZgVU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PUfljpWg; arc=fail smtp.client-ip=40.107.92.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PUfljpWg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E5bqJnBHgA+yZtb21Kd9CsKD02HbI++odSa3t4bSKJ3feLzYAjZcoSSTXw3RdhSqQesrmCo5C9W61wXodE7aBbzGvXApcNXpLFLt86LfIySU2rFh7iHfimtNUH3cM+CznYnAu5dXniZ5do119Ir7d6+80chWEVoiXVnDANQIOk7v4fXgceRuYLu8Tr271gkqQzKIp0auCTFXbCxpItQeVf1Fx0ykqoloMhucMs4LTrOyTAPnQY4vVpnP6Gkul7fFfqul3I+hRLwpk5VB8+mazyzTdJ13i/CAHmObSCvU44Vtzkjlpy5dk//pbJ6CpxRj/3LmqDsOhw2fYg3GoDxSaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2GRc/bxKNxF/NswYk+G3q2ZtFIY9TRBmowWlzOy6zI8=;
 b=Ze4lf4vsTdBcZd7ibYOCx9jTFhtspGqEP7tb7xvj67LtHyswGvGwKGkcIP6uLzwTLB9HXQQTobFw3ynqOm4gH3Bc0dYgck/7ehhwoaIJbz508pmZWB2hy37mZ9pYARCE57JO9HENNYnnSv6HwdVEy2IuFajmnqeBCsS7i+T9rrDJvl+QFpq6mHJoU6D+sop+tsQlTnrFAgDOlbxJfo5oKoI/qTYy/FFS7rqp+CBFTKmQziZIYL4ACnxyrd1GVNBT3K1RpKIelvw3Y9q6M15bd2mmFwPnSqGrebuoLDHi6kLRC7nS1W8Kk1vJWjHmzZVAazKd4rriPLwV94TJouHXzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2GRc/bxKNxF/NswYk+G3q2ZtFIY9TRBmowWlzOy6zI8=;
 b=PUfljpWgyYD5I1EJG786N1hB7PyM/zXCPRg/K9vtPOXCnJ7QX2bP+KkJ2A75W8WQWAeeUpS5iVhyS0xlfJFDQd1vhRQAQiZG07xX2wugY6cJR9CawIrSWgdLvKgYRX9r1JfAB8e9rS6cnKA5+J06glIDx7tyIO/Gv6wAqkDoqafRMxW7H8Gk7ojWubure57IGL2MZfQ2QmE3HfydQWX3f21RDb0rZsIpEWbEJLAyn2hoTMi8Z9bm/afDYBp32r/T0c8bssYQLfScYd17+7DJs5P1e7de5vcewCTJmJ7Cgn0x0dyXQVZQGEoXhAmS3EAbwSMqpGC16280FutFXd+X8Q==
Received: from DM6PR12MB4516.namprd12.prod.outlook.com (2603:10b6:5:2ac::20)
 by SJ1PR12MB6244.namprd12.prod.outlook.com (2603:10b6:a03:455::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.25; Tue, 1 Oct
 2024 09:19:17 +0000
Received: from DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::43e9:7b19:9e11:d6bd]) by DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::43e9:7b19:9e11:d6bd%4]) with mapi id 15.20.8005.026; Tue, 1 Oct 2024
 09:19:17 +0000
From: Danielle Ratson <danieller@nvidia.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Jakub Kicinski <kuba@kernel.org>
CC: Phil Sutter <phil@nwl.cc>, "netfilter-devel@vger.kernel.org"
	<netfilter-devel@vger.kernel.org>, "fw@strlen.de" <fw@strlen.de>, mlxsw
	<mlxsw@nvidia.com>
Subject: RE: [PATCH libmnl] src: attr: Add mnl_attr_get_uint() function
Thread-Topic: [PATCH libmnl] src: attr: Add mnl_attr_get_uint() function
Thread-Index:
 AQHa4xP04Q22L7+AvUGSMh1A07WzIrIQbHoAgF6FOxCAAY8BgIAAB+UAgAANo4CAABGkgIABVWAQ
Date: Tue, 1 Oct 2024 09:19:17 +0000
Message-ID:
 <DM6PR12MB4516D58DD5C796F514AA12C5D8772@DM6PR12MB4516.namprd12.prod.outlook.com>
References: <20240731063551.1577681-1-danieller@nvidia.com>
 <ZqnkZM1rddu3xpS4@orbyte.nwl.cc>
 <DM6PR12MB4516F083558D7AB3466FAF9ED8752@DM6PR12MB4516.namprd12.prod.outlook.com>
 <Zvp9NShxCERRPDdi@calendula> <ZvqD1CmbNg_UAGQY@calendula>
 <20240930134509.489b54df@kernel.org> <ZvqeEa_37KEmL8li@calendula>
In-Reply-To: <ZvqeEa_37KEmL8li@calendula>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-Mentions: pablo@netfilter.org
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB4516:EE_|SJ1PR12MB6244:EE_
x-ms-office365-filtering-correlation-id: 5016bd96-2a09-47eb-2366-08dce1fa1fd6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?RmhLV3Q0ZFRYamRsZTlDT1RjUTdHQllVR05Nb3N3cjRPZ0JNRkNQUjEyUita?=
 =?utf-8?B?WTZybUhueTVrZ1F5NnlyZytZZ3VMck9BQlNJTm9VZ2o0SHNxWUN4SEltVUFS?=
 =?utf-8?B?ODZYVUcwMzZJVHpQLzBWV0ZhZS9iUUFMTklFdTRtQVFsQ2c0MVphU1o2ZzRH?=
 =?utf-8?B?aGVrSk5hbUJYTUdvR3ZFRlRVVkRQNEY0c3BpZ01VUlhsY1FKamJiamRHKzFJ?=
 =?utf-8?B?RmZPTkM5ZWd5Zzg2dUhsajFMYkQwckY0dWovYmlURmc0NldvSXY0SkJSRXps?=
 =?utf-8?B?UnpHNFhNNVhyQ241bDhLM1gyVWhZQ2Y1VEtOeFV1SUtzTDFuZFdtcjNlNTRR?=
 =?utf-8?B?VGorelY4aTRnUHVzdlQwUjJ0N2ZuMmlLMENBUVJjMU5YSUNmaFh6Mm5JVkU2?=
 =?utf-8?B?SUUwZVJWaEkwd0FiMU1sK1YraUtBd0lNMWZFcFc4Qm50MGxhNk4wZXV3TThh?=
 =?utf-8?B?L1NTTEtVZDAzczJvK1l3M0haV2J4WVhGc29mVEw3VHRzcVBnazBrbjQrOW9P?=
 =?utf-8?B?Yk5tUWdrMzJLakx2a0F0Z25pU3B3blVOREtTcjFvT203NE5OQ3ZvTDFaYjh6?=
 =?utf-8?B?L2xNNkZnbVRYOVo2UUdSalV2ZFc0dHI1WVBrMHNTb0Z6VEZnZVk1aXBSNWQx?=
 =?utf-8?B?MnVJaFd4dXhJR21SNkZrSmYzT00xRUtlSnRVRlREREZ1MTFhaFh2bFFMN3dH?=
 =?utf-8?B?Z3ZXN1IzajhzOHl3N1lWZW15dkxOQlVZVzFBUmo3emN0aGI4TkJYNG9xd1Vz?=
 =?utf-8?B?ZHEvZ0ZEbTc4eFVaT2hyRG1MUUVIZERQR3lYdmpSUjBrV28wYnpzcUJ6YVg3?=
 =?utf-8?B?SUNiakFJY01UY2VzSC9TRkJKcXVhcmIydWNBYzB1NFZHV2treXZWYzVZMWl1?=
 =?utf-8?B?MWdTR0VnUS9kQUVyR3d6aTBUQzB1V29mMDRUR2J6ZElXanZBdlIzM0RCOFZy?=
 =?utf-8?B?UnlJbEJCcHUxSmFXZEtNdzdiUE1FMWpWVHQydGxiU0pTMTNVZEl0NDNGSGlE?=
 =?utf-8?B?UE8zTHVNdnZ5MmJNM0UzTEJTa0l5NVZCVENTRWRxZGhqZmhGdTlLQzZZWDAy?=
 =?utf-8?B?eU1iWkpXWFlXaGxSemE5Q3lua2djN0lxL2xLNjFMZWtaTkxxcHNZcnVna205?=
 =?utf-8?B?cjJIa3BsaXI1ZWh0WGIzZjhOWmV6cXJxUnhMTjBnbGJ6Q0F4Y2ZaVUVUMEhU?=
 =?utf-8?B?TGtnSG05a3JhY3J5R3gvQ2FKY2ZVMTlMOUxkbEhVZXU3Y1VzUnp1T25sVFJ4?=
 =?utf-8?B?aCs5d0cwL1EvVTd6Nk1ycTF3TmgweGlTam5XOWh2ZitHNlhXYU0ybUpSK1Ev?=
 =?utf-8?B?T1NBZ2xvWDlSRDdEQXZid1NVYmlaRnozd0FBQUtFYWtqcGROTzg2T1pQNGJ0?=
 =?utf-8?B?dUxyRjlnZ0h4d2ZpSTdEK2pZZWd1eHRkcXRrSm05azJ0MUlTUTF3OU1WczhJ?=
 =?utf-8?B?WjBHUzNRTHlsdi9IYnlRWGZmL1d0cEFNSnFBb3MxYy9HUlZTMTlkeTMrMU9k?=
 =?utf-8?B?M0JPY1NEY1JXSGVLTnlLU0MzV21UZFdGSm45emtRZXJEUjNmN1RhWXcvSGdl?=
 =?utf-8?B?TXpReDFOak0rSmo1NFRveGdHclB6dFNnaHA1Q1ArRUNJK0V2MFNIZUxFNEpY?=
 =?utf-8?B?bDl4YWQ3bWQ0VFUyVGxOTWczOWNnRlNIZ1RoZHMyMDZpb1NBVW9jSzVRYy9P?=
 =?utf-8?B?cDFzdDRpQVhmdmxlUXBWZWVRdjA5U21NVllVL0ZBL0ZNMVRZMEF6bmV5QTlv?=
 =?utf-8?B?SDFXVzNUTmNweE92czdBaGp0Z2pGM1h5UHN4Wm4xWkF3T3JWVnVBSjhGTWRx?=
 =?utf-8?B?Qm1kTExTQWlBeXYvZTFqdz09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4516.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Rmdubi9HR2dwRjJ2TVVIemdrSXluYW9DM1VZM1dxL2tpZm1PVDc3UVdNaW1q?=
 =?utf-8?B?c0NwYVV0MzNjNXc3Z0FkTG5qTWN3STQwa0FxTkJzZXNzd1hMa2xWZFg0S3dJ?=
 =?utf-8?B?R1B4QmZxSzlDMDlZN2pMUVhVbERnK1QwTHVWZWVUWjYrOXFYQkxXL1Z6WXYr?=
 =?utf-8?B?NkZjMHkwNTRlYXhHMXEvbUpBcFFLUDhrM1hIZDZOaWhBV1FnZG5QcHo2VEVN?=
 =?utf-8?B?RXlIY0lHdjlpM2FoOWJYWE9aZjZXV3UxTzNMRFcvakFvc3hrTjE5NGFMaDBj?=
 =?utf-8?B?MUM1QUxLdm40U3ZIVUJxdTNNZS9ULzdTYVZiRWVZVHRSTE03aGJiWE9sT0dr?=
 =?utf-8?B?V2tFY0E0TjM2d1AxTDFXYjF1MWdzNzVtL1d6WUQ3TldmRmh5RDhvTDhVckU2?=
 =?utf-8?B?WlJLbStBaUcyVFhIc3Jvako0Vk5sNS9ZbU9ReTJ2VXRXYUtHMzdHVkY1SHZD?=
 =?utf-8?B?R0M1SWRRai9YczROb2Z1UmdDdEtJZ013QWx3Nlk0Y3RqM2IyZXBkTDVmTGdi?=
 =?utf-8?B?RU9ocnZrdmNGSitEbjhwZE4yZ0hTZkxJMTdGYWtBdlFydVgvODR5TXl3WEVW?=
 =?utf-8?B?OThXT3FyaUJoSGxVUDRsS1JZNU9DbmpEZUxPdVBoTTNQVmNtMnVxR1A5dW1O?=
 =?utf-8?B?WGMyZll0V01BWWYzU1hKNzlFeE5qQUkrTm45amlGMHdRN1NpcDQyeUVyblhx?=
 =?utf-8?B?RTR2YXMwajZtdEFScjhTVTBWeklIY0t6YTF2WGFtN1FSSVV0RkJFc0FiQjNy?=
 =?utf-8?B?UkdJUUVKM3llRXpjMklha2FQZHJ1ZkNJQkZZUnNwZHpZTFgyYysyOXlyV0hk?=
 =?utf-8?B?eVYvaTl1N0dYTWo2WWRUSlA0NWoyVGpzRUJiKzYxWlhvWkVYU0NTNS9nT0NK?=
 =?utf-8?B?TzR5cS82TWp2UGZRdnFRZVVzallLRFlDMnRsSkhDUUJ6dkQvaklXRTdmamtm?=
 =?utf-8?B?RWhxNDA2dnQ1Mm95L2Y4bWltT3hNYmswb0tZVzVNSlM3cnNRVnZEYmVQcXpW?=
 =?utf-8?B?a1R5OFBuSjRoMVlPUk5OZ24rWFQzVkFlZTFLQnREakxmV1ZpTFhwZUowazN1?=
 =?utf-8?B?b2FBbEpKUUpKMHhxTFhybUJxdmJUeEE4aGQxaGRNKzIzbEx6Rks0dFBFNmFj?=
 =?utf-8?B?Nm91bFhtSkg0RkpaeS9uZnpSOGdab2xCQ25HMjBMVko4VWRJVEpsWXB0YTlW?=
 =?utf-8?B?ZnpMZGZmbXgrT0ZoV3Z0dS9ucnpKaDNCZjBrTjEvVkdCTlBDd2RJcWlPUHYy?=
 =?utf-8?B?OEZUR0RqQVNjaE5rY3VsYzJyclFYRTFsMlVKeFhJVy9OOGc0Ujk2TlN4R0Nm?=
 =?utf-8?B?azZjMzVuQS9mOXVhbGVzWTJHN0dqbXFaQjhoV1JJci9Cb2RsTkNDRGlMMW9M?=
 =?utf-8?B?dWZYNm43RWpqaEVBdGVTQmJELzZLeDBYN2xGRlhEL0RGblczSlBXMFhxTWx0?=
 =?utf-8?B?S1ZMRDVJVFNaRTZtai9yTXhvUTJQckZDU1dqZGhjWktoRy90NjdZdTF3SXQw?=
 =?utf-8?B?MkpJSGxXcWk3NWwvS3J1SnVWQnFjTzQweHJXd0Y5Tm83WGpiTWZkRkhpWVFL?=
 =?utf-8?B?YVVocWEwWG1yRTBOVXF4N1NkdFc4bDRFN01zZTRFYlRiRlFqaGd5Z0k5Snk4?=
 =?utf-8?B?NU9vSEhLdFNmWDJzc2tPMklGcDlLaHJMZjRFQUc5SU0vMUFmZTRLZ0xkcm0z?=
 =?utf-8?B?bjN0b2FyYW9LY1ZWWE1zZXplZHUzajFDdVZsZHZIR3RlRzJiS0Z0bElFQm5z?=
 =?utf-8?B?aWtpcTBjQ0tmTG1EVWxCT0Z0N2k1dlpIdkNUWFIzdzl0Tm9WUitJVE5zRlJW?=
 =?utf-8?B?WmlLVmNMNG9QVndGbUxKQ0hoRWFuek15ais3NjFBN040M2dyUzY4OWlIbUJF?=
 =?utf-8?B?bkVmWDcxNFRsa0xFUHBTd1ZnNjVUV3VzbnQ3bGIrQkZYQ2pXdWpNaXgzdUFs?=
 =?utf-8?B?QkRSQnA0cDJwOXZ5Qm9kWjNUTFFtdU5BWEJEc3R3ZS82a3kzcDVRMDNabll3?=
 =?utf-8?B?RE9zbVpnOVMrWjdRcHhrczdLcG5EbkVRbVVkaGhpNDZSZ1JIQ01FTEhQY2pW?=
 =?utf-8?B?KzJOWVA1MzFqZ3laOEl2WWxXbDlOZ05Gc0paSnQxdkk5dHh1TUN4ZTZrNlNp?=
 =?utf-8?Q?5Qoqs7PyKEIQUCubLjm4a83Qb?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4516.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5016bd96-2a09-47eb-2366-08dce1fa1fd6
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2024 09:19:17.1951
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9Set0/XFfEGXcX5Hl3LEY1HNJYr0rrzIqBpfqa/69/9kvhb1OkvUt6ZLaRQSi/NmMmyzCA54xPDZCIEgIzI8Lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6244

PiBGcm9tOiBQYWJsbyBOZWlyYSBBeXVzbyA8cGFibG9AbmV0ZmlsdGVyLm9yZz4NCj4gU2VudDog
TW9uZGF5LCAzMCBTZXB0ZW1iZXIgMjAyNCAxNTo0OA0KPiBUbzogSmFrdWIgS2ljaW5za2kgPGt1
YmFAa2VybmVsLm9yZz4NCj4gQ2M6IERhbmllbGxlIFJhdHNvbiA8ZGFuaWVsbGVyQG52aWRpYS5j
b20+OyBQaGlsIFN1dHRlciA8cGhpbEBud2wuY2M+Ow0KPiBuZXRmaWx0ZXItZGV2ZWxAdmdlci5r
ZXJuZWwub3JnOyBmd0BzdHJsZW4uZGU7IG1seHN3IDxtbHhzd0BudmlkaWEuY29tPg0KPiBTdWJq
ZWN0OiBSZTogW1BBVENIIGxpYm1ubF0gc3JjOiBhdHRyOiBBZGQgbW5sX2F0dHJfZ2V0X3VpbnQo
KSBmdW5jdGlvbg0KPiANCj4gT24gTW9uLCBTZXAgMzAsIDIwMjQgYXQgMDE6NDU6MDlQTSArMDIw
MCwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+ID4gT24gTW9uLCAzMCBTZXAgMjAyNCAxMjo1Njoy
MCArMDIwMCBQYWJsbyBOZWlyYSBBeXVzbyB3cm90ZToNCj4gPiA+IE9uIE1vbiwgU2VwIDMwLCAy
MDI0IGF0IDEyOjI4OjA4UE0gKzAyMDAsIFBhYmxvIE5laXJhIEF5dXNvIHdyb3RlOg0KPiA+ID4g
PiBPbiBTdW4sIFNlcCAyOSwgMjAyNCBhdCAxMDo0Mjo0NEFNICswMDAwLCBEYW5pZWxsZSBSYXRz
b24gd3JvdGU6DQo+ID4gPiA+ID4gSGksDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBJcyB0aGVyZSBh
IHBsYW4gdG8gYnVpbGQgYSBuZXcgdmVyc2lvbiBzb29uPw0KPiA+ID4gPiA+IEkgYW0gYXNraW5n
IHNpbmNlIEkgYW0gcGxhbm5pbmcgdG8gdXNlIHRoaXMgZnVuY3Rpb24gaW4gZXRodG9vbC4NCj4g
PiA+ID4NCj4gPiA+ID4gQVNBUA0KPiA+ID4NCj4gPiA+IGJ1dCBvbmUgcXVlc3Rpb24gYmVmb3Jl
Li4uIElzIHRoaXMgcmVsYXRlZCB0byBOTEFfVUlOVCBpbiB0aGUga2VybmVsPw0KPiA+ID4NCj4g
PiA+IC8qKg0KPiA+ID4gICogbmxhX3B1dF91aW50IC0gQWRkIGEgdmFyaWFibGUtc2l6ZSB1bnNp
Z25lZCBpbnQgdG8gYSBzb2NrZXQNCj4gPiA+IGJ1ZmZlcg0KPiA+ID4gICogQHNrYjogc29ja2V0
IGJ1ZmZlciB0byBhZGQgYXR0cmlidXRlIHRvDQo+ID4gPiAgKiBAYXR0cnR5cGU6IGF0dHJpYnV0
ZSB0eXBlDQo+ID4gPiAgKiBAdmFsdWU6IG51bWVyaWMgdmFsdWUNCj4gPiA+ICAqLw0KPiA+ID4g
c3RhdGljIGlubGluZSBpbnQgbmxhX3B1dF91aW50KHN0cnVjdCBza19idWZmICpza2IsIGludCBh
dHRydHlwZSwNCj4gPiA+IHU2NCB2YWx1ZSkgew0KPiA+ID4gICAgICAgICB1NjQgdG1wNjQgPSB2
YWx1ZTsNCj4gPiA+ICAgICAgICAgdTMyIHRtcDMyID0gdmFsdWU7DQo+ID4gPg0KPiA+ID4gICAg
ICAgICBpZiAodG1wNjQgPT0gdG1wMzIpDQo+ID4gPiAgICAgICAgICAgICAgICAgcmV0dXJuIG5s
YV9wdXRfdTMyKHNrYiwgYXR0cnR5cGUsIHRtcDMyKTsNCj4gPiA+ICAgICAgICAgcmV0dXJuIG5s
YV9wdXQoc2tiLCBhdHRydHlwZSwgc2l6ZW9mKHU2NCksICZ0bXA2NCk7IH0NCj4gPiA+DQo+ID4g
PiBpZiBJJ20gY29ycmVjdCwgaXQgc2VlbXMga2VybmVsIGFsd2F5cyB1c2VzIGVpdGhlciB1MzIg
b3IgdTY0Lg0KPiA+ID4NCj4gPiA+IFVzZXJzcGFjZSBhc3N1bWVzIHU4IGFuZCB1MTYgYXJlIHBv
c3NpYmxlIHRob3VnaDoNCj4gPiA+DQo+ID4gPiArLyoqDQo+ID4gPiArICogbW5sX2F0dHJfZ2V0
X3VpbnQgLSByZXR1cm5zIDY0LWJpdCB1bnNpZ25lZCBpbnRlZ2VyIGF0dHJpYnV0ZS4NCj4gPiA+
ICsgKiBccGFyYW0gYXR0ciBwb2ludGVyIHRvIG5ldGxpbmsgYXR0cmlidXRlDQo+ID4gPiArICoN
Cj4gPiA+ICsgKiBUaGlzIGZ1bmN0aW9uIHJldHVybnMgdGhlIDY0LWJpdCB2YWx1ZSBvZiB0aGUg
YXR0cmlidXRlIHBheWxvYWQuDQo+ID4gPiArICovDQo+ID4gPiArRVhQT1JUX1NZTUJPTCB1aW50
NjRfdCBtbmxfYXR0cl9nZXRfdWludChjb25zdCBzdHJ1Y3QgbmxhdHRyICphdHRyKQ0KPiA+ID4g
K3sNCj4gPiA+ICsgICAgICAgc3dpdGNoIChtbmxfYXR0cl9nZXRfcGF5bG9hZF9sZW4oYXR0cikp
IHsNCj4gPiA+ICsgICAgICAgY2FzZSBzaXplb2YodWludDhfdCk6DQo+ID4gPiArICAgICAgICAg
ICAgICAgcmV0dXJuIG1ubF9hdHRyX2dldF91OChhdHRyKTsNCj4gPiA+ICsgICAgICAgY2FzZSBz
aXplb2YodWludDE2X3QpOg0KPiA+ID4gKyAgICAgICAgICAgICAgIHJldHVybiBtbmxfYXR0cl9n
ZXRfdTE2KGF0dHIpOw0KPiA+ID4gKyAgICAgICBjYXNlIHNpemVvZih1aW50MzJfdCk6DQo+ID4g
PiArICAgICAgICAgICAgICAgcmV0dXJuIG1ubF9hdHRyX2dldF91MzIoYXR0cik7DQo+ID4gPiAr
ICAgICAgIGNhc2Ugc2l6ZW9mKHVpbnQ2NF90KToNCj4gPiA+ICsgICAgICAgICAgICAgICByZXR1
cm4gbW5sX2F0dHJfZ2V0X3U2NChhdHRyKTsNCj4gPiA+ICsgICAgICAgfQ0KPiA+ID4gKw0KPiA+
ID4gKyAgICAgICByZXR1cm4gLTFVTEw7DQo+ID4gPiArfQ0KPiA+ID4NCj4gPiA+IE9yIHRoaXMg
aXMgYW4gYXR0ZW1wdCB0byBwcm92aWRlIGEgaGVscGVyIHRoYXQgYWxsb3dzIHlvdSBmZXRjaCBm
b3INCj4gPiA+IHBheWxvYWQgdmFsdWUgb2YgMl4zLi4yXjYgYnl0ZXM/DQo+ID4NCj4gPiBObyBw
cmVmZXJlbmNlIGhlcmUsIEZXSVcuIExvb2tzIGxpa2UgdGhpcyBwYXRjaCBkb2VzIGEgZGlmZmVy
ZW50IHRoaW5nDQo+ID4gdGhhbiB0aGUga2VybmVsLiBCdXQgbWF5YmUgYSBicm9hZGVyICJhdXRv
bWF0aWMiIGhlbHBlciBpcyB1c2VmdWwgZm9yDQo+ID4gdXNlciBzcGFjZSBjb2RlLg0KPiANCj4g
Tm90IHN1cmUuIEBEYW5pZWxsZTogY291bGQgeW91IGNsYXJpZnkgeW91ciBpbnRlbnRpb24/DQoN
CkhpLA0KDQpUaGFua3MgZm9yIGFsbCB0aGUgY29tbWVudHMuDQoNCkFzIEkgc2VlIGl0LCB0aGVy
ZSBhcmUgYXQgbGVhc3QgdHdvIG9jY3VycmVuY2VzIGluIGV0aHRvb2wgZm9yIGEgY29kZSB0aGF0
IHRyaWVzIHRvIG92ZXJjb21lIHRoZSBsYWNrIG9mIHRoaXMga2luZCBvZiB1aW50IGhlbHBlciB3
aGVuIHRoZSB1aW50IGF0dHJpYnV0ZSB0eXBlIGV4aXN0cyBpbiB0aGUga2VybmVsIGFuZCBzZWVt
cyBsaWtlIG1vcmUgcmVjb21tZW5kZWQgdG8gdXNlIHRoZW4gYmVmb3JlLg0KDQpUaGVyZWZvcmUs
IGFzIEkgc2VlIGl0LCB0aGlzIGhlbHBlciBzZWVtcyBtb3JlIHJlYXNvbmFibGUgdG8gaGF2ZS4N
Cg0KQnV0IEkgYW0gdHJ5aW5nIHRvIHVuZGVyc3RhbmQsIGFyZSB3ZSBkaXNjdXNzaW5nIHRoZSBu
ZWVkIG9mIHRoZSBwYXRjaCBhdCBhbGw/IE9yIHNvbWUgbml0cyBhYm91dCB0aGUgd2F5IGl0IGlz
IGltcGxlbWVudGVkPyBPciBzb21ldGhpbmcgZWxzZT8NCkkgYW0gYXNraW5nIHNpbmNlIHRoZSBw
YXRjaCB3YXMgYWxyZWFkeSB0YWtlbiBieSBAUGFibG8gTmVpcmEgQXl1c28uDQoNCj4gDQo+IElm
IHRoaXMgaXMgdG8gc3VwcG9ydCBOTEFfVUlOVCwgSSdkIHByZWZlciB0byBzdGljayB0byBOTEFf
VUlOVCBzZW1hbnRpY3MuDQo+IA0KPiBASmFrdWI6IGlzIHRoZXJlIGFueSBwbGFuIHRvIGF1Z21l
bnQgTkxBX1VJTlQgaW4gdGhlIGZ1dHVyZT8gV2hhdCB0aGUNCj4gYXNzdW1wdGlvbiBmcm9tIHVz
ZXJzcGFjZSB0aGF0IHRoaXMgd2lsbCBhbHdheXMgcmV0dXJuIDMyLWJpdHMgZWxzZSA2NC1iaXRz
DQo+IHZhbHVlPw0KPiANCj4gVGhhbmtzLg0K
