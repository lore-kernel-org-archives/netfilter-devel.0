Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D873624D7
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Jun 2026 10:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.156.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782210840; cv=fail; b=ma0T4sllcLA0npWHdwZgGq1VHYmtoB2PrX1iJL+HqUjTy3sbnQyNz/9CjYVImpdRaWFWHBzG45VH8Q0n20Rj7Gdq0Egr3kT9ui1/mZZ7haiKiUCmdfCla8HDaZQRjfIyRXnKzPuE80A5x/6KziytMvjte7NzzcjBfFOkReOhxdU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782210840; c=relaxed/simple;
	bh=bE1cCyNqvLV5Jg6XBklHMZr7zJWD+h47BwuSUez/HMM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TDHdkE+upxTQpHvLgHcfwFk72VAZu/WPas07wT1i5dSQMEkyKbqR/fOBGNMAxQADkZnlGgipmYqEYkSoayfaZgAuxOpuEDps2P5cC5dU95nbtkvrDQ6Z2FuyjlC15/tica+uML+ANlBRg5vjm+LNQrJIAC53YN9d1NdO82UrtOc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b=akZOltMn; arc=fail smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b="akZOltMn"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65N6h3SG458141;
	Tue, 23 Jun 2026 03:33:55 -0700
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11022123.outbound.protection.outlook.com [40.107.209.123])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4eyfr799j6-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 03:33:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bU7lPlIQMGPEGCJPHSlFjrK3lnFr3hT3kIZzceMhK58PNxkJxhVNhIP/sJ+zGh1qc4oOthqB9oFtbINhxkhPUbXmX1vP/yyTYcG8SQMUBk83kIuEz/EdMaGcJTDusxXtp9HPquPCgbo4HatMAO9+xYr2j7n3cz/T4L6BGqz9eBq4oZwXSljnBW5A3vJgj93MR5YSmgvqMRrM9uJiVtC+bI+VwFJcuyp6BJKdx+KjJgZzdvrDa1RWkjNGstAxuDEzg9iPF27M1ts9PSMXYkoMiD39+OGqpJMN6k7RtijQJ1CrbSCzmw971ErflHJGHHW2xyr0iwYydzBqyvEHdM/zpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bE1cCyNqvLV5Jg6XBklHMZr7zJWD+h47BwuSUez/HMM=;
 b=sVGt6X6h9dvL3lekvMi4RsBwh4eVETppfVqGNfRLVFW5QD5zJrl5XTxlsDM9Y+2oNNRAD0IyMDILi2iJrgaHOMPgDcv5dPUIQueisc99H8q9JeUwtRFcvzalSBLwj3C8M44KH6TSsegKRyfP+VtY4QAA11TQkM1v58HIVEgo+RC6g7qylcTjTf/wfd4QnIQ1oXt9NpQIrF7H6JWorWV/w+nIRZxu47kQDjOa3R9m6KlMvzo+xOv/Az4IgTqFPRHVtHP5Q22BMPEySNcIyf+hQYrDO1LnqQAMh4YR7PBDfqlWFimXZQUS4txVt0QDoZxdDd/K4ksykkJu3vwA/2rv4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bE1cCyNqvLV5Jg6XBklHMZr7zJWD+h47BwuSUez/HMM=;
 b=akZOltMnchHXhewm01znzv+eDN9e/gLXYwRHS0HO7fi0q9RdMhMvdW7jj+fYtHCJeVUt5hOkjUanxRJP2rI21ZDXpDAw0akwCHSsJP3bTHj7PyTuNGraJMmLabzn8lT049PDt4ASQIbWQSpmVTcdGTnSAQrxiQTRRqp0enBtbyY=
Received: from MN0PR18MB5847.namprd18.prod.outlook.com (2603:10b6:208:4c4::12)
 by DS4PPFD2021F577.namprd18.prod.outlook.com (2603:10b6:f:fc00::ac2) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.20; Tue, 23 Jun
 2026 10:33:51 +0000
Received: from MN0PR18MB5847.namprd18.prod.outlook.com
 ([fe80::48b4:4ff8:d5f4:a49a]) by MN0PR18MB5847.namprd18.prod.outlook.com
 ([fe80::48b4:4ff8:d5f4:a49a%5]) with mapi id 15.21.0139.018; Tue, 23 Jun 2026
 10:33:51 +0000
From: Ratheesh Kannoth <rkannoth@marvell.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
CC: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: RE:: Re: [PATCH] libmnl: add MNL_TYPE_UARR for devlink u64 array
 attributes
Thread-Topic: : Re: [PATCH] libmnl: add MNL_TYPE_UARR for devlink u64 array
 attributes
Thread-Index: AQHdAvvI43WDuy7/9U2uSQkj1s8sWA==
Date: Tue, 23 Jun 2026 10:33:50 +0000
Message-ID:
 <MN0PR18MB58472CDD42C11ADA73EB5AA6D3EE2@MN0PR18MB5847.namprd18.prod.outlook.com>
References: <20260623043755.2435685-1-rkannoth@marvell.com>
 <ajpWYAQ1Od2ilpAk@chamomile>
In-Reply-To: <ajpWYAQ1Od2ilpAk@chamomile>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR18MB5847:EE_|DS4PPFD2021F577:EE_
x-ms-office365-filtering-correlation-id: dfcec722-5a0e-4872-8a91-08ded112eab1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|13003099007|38070700021|18002099003|22082099003|56012099006|4143699003|11063799006;
x-microsoft-antispam-message-info:
 Z9+0ws8jq0AqLdtRUgw8WnA6NKvNevbJ0Vfvx0ddczQNgaYSUcppbeIOA22lLcHdz5L6zkTulrNwmLdqiBeGbt/rM7BFLtp4QaGfGurR/3/fGXrVTPVSBaz8rd/Qf72bhkmSHgv5clnfingxTfhO8chVi8ut6mbUM+rynKzJznr/s9dvoWibFsOWfDatj3xmcE3Mbc5MMwaDAYqjd5R/sZDRYLGzalY3QIjItfd2EWaCG4Jd1r9YXdtzHbUUDsOEdi1QZwqAdcpHtZJN8c103n04CDmyY5BtNpkKBLfHaXoFXOaFCqqm/etIOSkI2QoVHZYcazXf4PSOHgQyMoUYBS7uCmsmUN1zdLZk7QSOVdN2L6l/rLtBh8/iZvgGbyEVeF3pcb7DoQvofFwV/gY9X86OzQFuEj7hlMABATUL9qhZe4xNMkhlTIBlRjG2GKESQwfz82+4gfVzZnpsgqZG6X0POyKLpoZayVltcg9CpfRrtFXkwnPMH86TKVDBSi4V1Z8TzlNKWlbXQG8lHQVGYeM1YVfEfZWxHq/hRHtE30ULxxMYAWdd7wXs5IDWneOTnK6bx8GOeLeRP0JLIQmtitBifKYpT9tH5mRzQtpw12DOQU35r1itc5I/B5PGL2T5aRocfVp96vcTX2onuTXXAHmNv7cb+QmTVpuAbIHrj157algUONY8h5UaIt0uW4/KBWzuPhoofgYzTPrg7X1M4JeFsYhRkU3qW5LaR/v2mJQ=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR18MB5847.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(13003099007)(38070700021)(18002099003)(22082099003)(56012099006)(4143699003)(11063799006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UEZzeVByZE01YVEvb0cvRlA3NE9xQ0JnVXIzaW9nMHhMREkwVjBXR2VhWUNC?=
 =?utf-8?B?WFk4VU9xZTN6YVJmWUc4RVNXZjlHa3psS1gwT2NSMkZHWnNRV1Zxb0k0aWlC?=
 =?utf-8?B?TkRiSHBTK1hMemFMZDVMYTMrSkFWcGJZQW9EcUVDT3FlODlzZUI0Z0pKT0hX?=
 =?utf-8?B?Tkgra1hDdGJPVmUrL0pJYjNUVHphdEtCVTJKZytsbWI4WFJHZFZhQ2RVa1Nl?=
 =?utf-8?B?cXBVVHRtbFNNeHc3YUF1WmpHRkljcUgyRXpGNUZIN2h0UWJhanJDNUxXRHZX?=
 =?utf-8?B?emRoaU5KUjR1Q1AvcWFVaUVJMWo1WnBoOGtYZ0x4bjlpcHUvYnJERkQvYURp?=
 =?utf-8?B?d0FDZ3gvN3RWY3I1ZW1ZMWhGY3NIaGZmSjhUR09pTEp6YzJ6YW1ISUdqK3hE?=
 =?utf-8?B?V3pOSGxuS1l5OGlDMzNwSGxtYktZVlhNMktRZUZjOUpndTBYaUZuUW9oNkxT?=
 =?utf-8?B?aDFQUkxNcmthb1oveEw0c1A2RkVuMENCWjVKajgrNjV3OGJqQTRwNFlmY0w3?=
 =?utf-8?B?eStGMmU2eklnRWJNb29xdGZkWVhmQWNGVVY4WEdNSXZnVzE1a1AwRm9YVmFk?=
 =?utf-8?B?R20zc1ZFdS9FUFRqMnB4OEZUajZja3pNRWR4blVtSjNMUHZma014YkVERVVY?=
 =?utf-8?B?L3pyYmlsYnNWVlc1NHJRTGVaTDd1QUdHQjIxTmtOSjNkWjNlckdwYmNLUUhM?=
 =?utf-8?B?UVFxeGZWQVNZeFhRKzdZbkpISkowNGd1Mnhkb1MrcmNDZGUwWGg3Szg2UFJw?=
 =?utf-8?B?bFhrd1ZQRVp2OEZNb21PekpBREpmb1JweWhmNGp5dnFJUkZxd1JZcGczdWJN?=
 =?utf-8?B?Um9FMzhqenFKRVpCc0hSdy9NQmcrS1V0VFNnUGNSd3JndlJpbllLQmhkRHpp?=
 =?utf-8?B?YkdielAzTTRXRm0rVUZmd24ya25CTnl1dUpBQ1R6OEdTQ1ZUQzJld0ltN2lh?=
 =?utf-8?B?RlFwSlFLVXd4dDkybC81V0FHdnBTQzM1eDZhYzFISEU1RlF0UEtkTk1sNzBz?=
 =?utf-8?B?dEdsd0lqV1BHbnhTS1VwdUlJeHRPZnVHelFWTlQwZjlMdVpBL2Zxc2FzUlgr?=
 =?utf-8?B?NmJjUDdjanIyRXk0RnZ5RFlrS1lkejI2QjFFOEFPQVdrYUdVUXRMN1lUN0p0?=
 =?utf-8?B?R0Fjc0Q3YUhIMHowRDNIREN4aTZ4Qm52ZXFKREpxSGZ3ZzZuY1UrQXE3MEtq?=
 =?utf-8?B?Mld6RVl1Si9xckVIYU40cGZwVnNyTHpQMzRhdXNTdjZBdW02bDhzc1NTZHYr?=
 =?utf-8?B?ZWllc1BWQWYyZjdCVmVBTkdLTXBibXo1UTh3eDBUejNKUXZwOGxnSDdhR3JZ?=
 =?utf-8?B?dTBpQzhjb0VTenBvVGVGNXhpR25tTzZIcy95UzVGaU9ZczUyd2JVc1UraHcx?=
 =?utf-8?B?SmxwdGNCR0RBYnhiTlhaTXh2N2xFYmFkSktZUnBmQWNiWlNITzhzQ2hmRTIv?=
 =?utf-8?B?ak9YQlVuNXVSOTFWdU8wcGpiU1A1Y1RDOG9mUENob0x2T3hVRmZ6QkcxcFZ1?=
 =?utf-8?B?MUxEdWpmZ002YTQ1UDlzWE5HTitIQXQ1Y21ZbWZxWmpiZmlsTHFYTXJtUWJD?=
 =?utf-8?B?c2puZlJLaUhLMHN4N2RYWEdQaEx2UkNjK2cvUFVqUTM2V2dmYzdDY1I5SGh6?=
 =?utf-8?B?clBkdGRnVlBPazFTNEdKcEVFeUtxeVlsZm1wdDRkQ05COHFYQVV1VmREaG45?=
 =?utf-8?B?M3lyYjNjdnE3V3o4WXgwL2FUdHdrdVJCbzR6UzAwaElod1VzNW53aE1iU2M2?=
 =?utf-8?B?RXBvZEkvdlMydkcxR2ZxM3ZlOERxRndmd29QaU04eWpXNlIzSm05WnQrZzBH?=
 =?utf-8?B?UmxVdnRwVTVrdlUzYllQN04rRGdQSnpTWGJZM0NhS3RscndBSGhTb3E5OHlZ?=
 =?utf-8?B?MWxKYklON2xjZlZVb3U0dVo5V293Z0YyZXFEN1Z2UHExUUtsaURZdlR5elJt?=
 =?utf-8?B?S1Z6OWhPV0JUdlExMUwyQVRWNFlyVW84THYwOWxIMTBHOVg1OFhVelV5OGly?=
 =?utf-8?B?Z1ZYL3REcWJWOGNSSWVzRU4wdkJsMUp0a2ErL1N4S2cza1FCbVNSQ3l3S2pv?=
 =?utf-8?B?c1EyZmRXOUpkZWI5OWRlZkZqb0J1QmREZDlEZ092V0dhRHQ3Z0lSL0lHZ3lJ?=
 =?utf-8?B?azNLT3lZalpaVHRUU3loUDE0THFZM01rK2UrUjkzTXY1RGZDTHkxd1Q0V0Jx?=
 =?utf-8?B?TnJBbmhyeWtKbjNlUlFVOWwybEpzRnlpZDZ3M0VjdkdTOUhLVHZPeTR1elEz?=
 =?utf-8?B?cmRTY1pQNTVnK1RhYzMyRGdZSlJ2Zm15Ti93NStTMW5DMXp5OEJVR2tUb05Q?=
 =?utf-8?Q?+/KaZQ1rlKqxCNgdzi?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	s0ieV/JP8sv2AqgVyrJShdjuDDAHNRw6c8kUd0bOyPQYXsHDwSphlk+Wh26AI3h80w7FfctdPeCMfyb+hsAclxsCZ3gVio3PTemd8gezNy5pne/Fnk6DLiyoZMQMCTnF3fyOWAevGDwAm+g62Kd97KskmwvmB5CfplhvDG/BXSydWfKvv7EVQnOK+y3XB0Iku5x1MujbfW8fUZ/a5iInbd49gUbPQ+1nkPZiuvEay5fmnGJozvrT05mxIDBNVpYUBrq10XEQkIwZ6xHSkoPVqe2vQsdsoX40W8GqlkbNPeIqkpFIUyWVfBOSf16sXYRoB3Iy4P7GHiOtfvCciZf+QA==
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR18MB5847.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfcec722-5a0e-4872-8a91-08ded112eab1
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2026 10:33:51.0065
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1DV6sb1Sz3rGcN1Z3sXH2Sz71Bs6Sja1e4YTK4OQE7QeajbNJJdZgzXRz8apa/emlXPwV96c6B0kNWejdr4HoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFD2021F577
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIzMDA4NSBTYWx0ZWRfX+0jvgQ1kJu7p
 hxfsAbKPB7vW+kJrfO9ch+AF5V6xKGjFJVhMsGkLGpTIY2AsreHUW9cj9mQ8kJlQcWy9rAg2MXr
 haHr4TU+tWK4/qYMPieQ3ztJGwHfcCE=
X-Proofpoint-ORIG-GUID: iY_D0DA7L38PQ-ohBsFWM6VbXASsZk-K
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIzMDA4NSBTYWx0ZWRfXyk5qm05qnq9u
 rfiNZunw2K2FZ2aq1t9cEEy/dgDLHttDkrTz+Jh/keo+SzrB0VBUXBDS3j2DJkyzwkVm5JJO08b
 /OuWhxHQfMf6zLUYVhCIUnBZqlUUs83tvHAcax8xFLad3RJDiPqs7Fs1AnxT1S7FOYbtCOXEFBl
 N4AMA9tEIyofCJjs/5HeBRyjL0IysiiaG7rSgS2gjDJigs1j0/Z9QwP2DR2hG3k4ydqewZGRox1
 CPllLT4XjJHPgd3Go0rbuVijdiPdR0KWTq704gqyoPurAyxm/Bcidj1pZGKAZjULq4lOquvM+DF
 ehNJxX6VslQIkQnyfERKR/i18Js2d/ueG3fqDeJpcipMERQQZW9R9g6lTe6b99zs3IlC/BsvHye
 ETv+S4uibtfvyxiq9pWDN19XL677c7MkXOe80rMNbkZmhrMny38OPFvdHUdyegeFzcXFRaHVo/r
 GmcVijtxUFpmZ/wznaw==
X-Proofpoint-GUID: iY_D0DA7L38PQ-ohBsFWM6VbXASsZk-K
X-Authority-Analysis: v=2.4 cv=UIvt2ify c=1 sm=1 tr=0 ts=6a3a6113 cx=c_pps
 a=EEuUCq1UVZeKBjwkVe0TyA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=-AAbraWEqlQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=l0iWHRpgs5sLHlkKQ1IR:22 a=QXcCYyLzdtTjyudCfB6f:22 a=VwQbUJbxAAAA:8
 a=M5GUcnROAAAA:8 a=3HDBlxybAAAA:8 a=sgybqDIb_XGg4t8g55QA:9 a=QEXdDO2ut3YA:10
 a=OBjm3rFKGHvpk9ecZwUJ:22 a=laEoCiVfU_Unz3mSdgXN:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-23_02,2026-06-22_01,2025-10-01_01

RnJvbTogUGFibG8gTmVpcmEgQXl1c28gPHBhYmxvQG5ldGZpbHRlci5vcmc+IA0KU3ViamVjdDog
W0VYVEVSTkFMXSBSZTogW1BBVENIXSBsaWJtbmw6IGFkZCBNTkxfVFlQRV9VQVJSIGZvciBkZXZs
aW5rIHU2NCBhcnJheSBhdHRyaWJ1dGVzDQo+ICBpbmNsdWRlL2xpYm1ubC9saWJtbmwuaCB8IDEg
Kw0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEv
aW5jbHVkZS9saWJtbmwvbGlibW5sLmggYi9pbmNsdWRlL2xpYm1ubC9saWJtbmwuaA0KPiBpbmRl
eCAwMzMxZGE3Li4wNzhkNTE3IDEwMDY0NA0KPiAtLS0gYS9pbmNsdWRlL2xpYm1ubC9saWJtbmwu
aA0KPiArKysgYi9pbmNsdWRlL2xpYm1ubC9saWJtbmwuaA0KPiBAQCAtMTMzLDYgKzEzMyw3IEBA
IGVudW0gbW5sX2F0dHJfZGF0YV90eXBlIHsNCj4gIAlNTkxfVFlQRV9ORVNURURfQ09NUEFULA0K
PiAgCU1OTF9UWVBFX05VTF9TVFJJTkcsDQo+ICAJTU5MX1RZUEVfQklOQVJZLA0KPiArCU1OTF9U
WVBFX1VBUlIgPSAxMjksDQoNCldoeSAxMjk/DQoNCj4gIAlNTkxfVFlQRV9NQVgsDQo+ICB9Ow0K
DQpJIHdvdWxkIGxpa2UgdG8gbWVyZ2UgaHR0cHM6Ly9wYXRjaHdvcmsua2VybmVsLm9yZy9wcm9q
ZWN0L25ldGRldmJwZi9wYXRjaC8yMDI2MDYxNTA0MTA0Mi41NDk3MTUtMS1ya2Fubm90aEBtYXJ2
ZWxsLmNvbS8NCkJ1dCB0aGlzIGhhcyBhIGhhcmQgY29kZWQgdmFsdWUgMTI5LiBJIGJlbGlldmUs
IEkgbmVlZCB0byB1c2UgYSBtYWNybyBoZXJlIGluc3RlYWQgb2YgMTI5LiAgDQoNCg0KVGhlIHZh
bHVlIDEyOSBpcyBiYXNlZCBvbiBfX0RFVkxJTktfVkFSX0FUVFJfVFlQRV9DVVNUT01fQkFTRSA9
IDB4ODAgKGkuZS4sIDEyOCkgZGVmaW5lZCBpbiB0aGUga2VybmVsLCB3aXRoIGN1c3RvbSB0eXBl
cyBzdGFydGluZyBhdCB0aGF0IG9mZnNldC4gVGhlIHJlbGV2YW50IGtlcm5lbC1zaWRlIGRlZmlu
aXRpb24gaXM6DQogIEBAIC00MDYsNiArNDA2LDcgQEAgZW51bSBkZXZsaW5rX3Zhcl9hdHRyX3R5
cGUgew0KICAgICAgICAgIERFVkxJTktfVkFSX0FUVFJfVFlQRV9CSU5BUlksDQogICAgICAgICAg
X0RFVkxJTktfVkFSX0FUVFJfVFlQRV9DVVNUT01fQkFTRSA9IDB4ODAsDQogICAgICAgICAgLyog
QW55IHBvc3NpYmxlIGN1c3RvbSB0eXBlcywgdW5yZWxhdGVkIHRvIE5MQSogdmFsdWVzIGdvIGJl
bG93ICovDQogICAgICAgICAgIERFVkxJTktfVkFSX0FUVFJfVFlQRV9VNjRfQVJSQVksDQogICB9
Ow0KU28gREVWTElOS19WQVJfQVRUUl9UWVBFX1U2NF9BUlJBWSByZXNvbHZlcyB0byAweDgxID0g
MTI5Lg0KUGxlYXNlIHNlZSB0aGUga2VybmVsIHBhdGNoIGZvciBmdWxsIGNvbnRleHQ6DQpodHRw
czovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyNjA2MDkwNDA0NTMuNzExOTMyLTUtcmthbm5vdGhA
bWFydmVsbC5jb20vDQoNCk9uY2UgdGhpcyBsaWJtbmwgcGF0Y2ggaXMgbWVyZ2VkLCBJIHdpbGwg
dXBkYXRlIHRoZSBoYXJkY29kZWQgMTI5IHRvIHVzZQ0KTU5MX1RZUEVfVUFSUiBpbjoNCmh0dHBz
Oi8vcGF0Y2h3b3JrLmtlcm5lbC5vcmcvcHJvamVjdC9uZXRkZXZicGYvcGF0Y2gvMjAyNjA2MTUw
NDEwNDIuNTQ5NzE1LTEtcmthbm5vdGhAbWFydmVsbC5jb20vDQoNCg0KVGhhbmtzLA0KUmF0aGVl
c2gNCg==
