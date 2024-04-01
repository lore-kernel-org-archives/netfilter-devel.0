Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04254D52B;
	Mon,  1 Apr 2024 09:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.100
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711964391; cv=fail; b=Mb/jc1mfNZvlN5vLLItODV/Y+5wLRp2yU3B3bGicxTc72RvMN0sX+7dHvgOqHcCetAAe4X6T9Ds4Yuo/qy3kdBWJ2MVAbedeli7wrvvgjAVAxfy1K7YDrKqPeGo4ebzKG054upBA7KRImZrQKNaBB8+85X/gMYnXqxj2Dm55rUM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711964391; c=relaxed/simple;
	bh=SsiuLwAf95R7H8rUF4ev1uIEayx3okpcRn9Z9pjOn5o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Dqt62c6qQ58gy82vHNFWsrbd7cEsRZJz+K49xeMcVEKFEPznZ04vRCEwQ7uuDOak92uWMHsJ9QiHyVUYME41lp8Xo1mZ1Ajhkf6mD6qFR7+kQGviA4T8ynVMwWPQqzC4CFFzy6TOcqlhv7pPLNpY1txshswoUig5GquUkveG7xE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gp2M3lIr; arc=fail smtp.client-ip=40.107.236.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gp2M3lIr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MSuVJtRMhIB4lhrNUzIzn2g+gcPbzxuac4rwN9ArroGZZVWNzQdtOLNZYjHpNx4hKWulZe7QS7uyfVvn5n0Pdfcxk1PT9EJjVO7eWZKwPyRrTzkuY8zsUhIv3DIe2ZlzqjziC3eFEuiJiz5flIEA6eQfV8djQPY8rPRWwq5QgIDDt9CyBZMGNax3R5aIMV9udTxpn31VKzHs1m0+ijfmrX/9GQR84VFV5KVX38SinilgaqemGs1a9VH9ZYZD97hsgUeKsMkoeakWNCC0BJqiy6DkyZV1P2Qoohl7nwqm4cuYxND7UYhXlNld/0VuT3IddWaoVoVVAa9qWyD/TBvTpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SsiuLwAf95R7H8rUF4ev1uIEayx3okpcRn9Z9pjOn5o=;
 b=WAA/xkD7vxUZGzNL4DJLOmT1VGdJkjLxSeY1JmdLovKD3xmKQyCtEXDN5OCWSsHE0Q6JXKs6LXA15Iezj/k6MuQh2nwOaHWuMUjb3bxVbrMYrg46nPUhV4NFvbnKf4bMX11EFtqlSs8DSklGvMraYp99OsXuxJY808u/5Bj5Fwf4/vMX4uZrQxctUn5aMeAc+UQ+NlNwP7qoh+Xz4UMbawgt4MIQq9Su601nGittVEHNnyXpEOMgHL6zhoJmgXroN+lbL4nBYC1n4+Hufz/vUupx5iEIk6hrmUT05Ajf3JBAfKoMCCfW5mmnvX0mGU9xSKbmxItbbfjiPyAGgrT64g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SsiuLwAf95R7H8rUF4ev1uIEayx3okpcRn9Z9pjOn5o=;
 b=gp2M3lIr3k9j/hPClBI12pUsKCN/viZ5PvZGExwkE+TO7rEKtJr0Yc2UnxbiKFCqZRdU2gTtdwEiihK/mlXju472MRH8kFstKl3Rir2kcDhteTNkbgiYIZfv1D8J1PcSdzSnb2FZV3DnnL9kflFwFeqKhg0xHMKxD2zOW6KRJyI2luT9yOQrdk1SFqoR+rdFBOY4Kx7xfnSv04A2pyr0hlPPK62jMAVl+XvLVQb/sV2eyu8V7McYyQdpw2Xp5VyBgpDRdMQf5tw3De5kveHwDvkKUXHCPxmcZg9WBO3j1QRgxRGdRA4fbPIG0k/Quhe9YtwhqoMxXzzAtcr1r+0aJQ==
Received: from IA1PR12MB6235.namprd12.prod.outlook.com (2603:10b6:208:3e5::15)
 by MW6PR12MB8733.namprd12.prod.outlook.com (2603:10b6:303:24c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Mon, 1 Apr
 2024 09:39:44 +0000
Received: from IA1PR12MB6235.namprd12.prod.outlook.com
 ([fe80::2afb:c838:f5b0:6af3]) by IA1PR12MB6235.namprd12.prod.outlook.com
 ([fe80::2afb:c838:f5b0:6af3%4]) with mapi id 15.20.7409.042; Mon, 1 Apr 2024
 09:39:44 +0000
From: Jianbo Liu <jianbol@nvidia.com>
To: "pablo@netfilter.org" <pablo@netfilter.org>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "fw@strlen.de"
	<fw@strlen.de>, "netfilter-devel@vger.kernel.org"
	<netfilter-devel@vger.kernel.org>, "davem@davemloft.net"
	<davem@davemloft.net>
Subject: Re: [BUG] kernel warning from br_nf_local_in+0x157/0x180
Thread-Topic: [BUG] kernel warning from br_nf_local_in+0x157/0x180
Thread-Index: AQHaeRh+r2dUlP7fzkayCsPDG8BqZ7FDtn8AgAFzdICABB3CAIAJ9yUA
Date: Mon, 1 Apr 2024 09:39:43 +0000
Message-ID: <d134a3fb58c27abab012aa154401e403e6e46b84.camel@nvidia.com>
References: <ac03a9ba41e130123cd680be6df9f30be95d0f98.camel@nvidia.com>
	 <Zf15Ni8CuRLNnBAJ@calendula>
	 <d6084a1cdd0e6d2133c8586936266aedd8eb3564.camel@nvidia.com>
	 <ZgIkm3KNK78qpptx@calendula>
In-Reply-To: <ZgIkm3KNK78qpptx@calendula>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.40.0-1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR12MB6235:EE_|MW6PR12MB8733:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 OA4cqoZgYEgpDkvbj8JjlwFBPPOAXxHncSD82Tgy/0K8ZTFee891TXKBZs7vvOFTLZXo9VlUGyVtcYNXPEVaxn9zQe36/0UqrHMRWbI285XuzqjUAvyjcP0UaokIK5CoCzkwdUp8Y0Ac8XtNzuCZtTkEoTVH7xV5CHCMuIdzT7nPJjZqUkhmkdHrA2X9pS1d3JeUuAMJBWktM0/Rfm08qXmerW2RP3ylhBOHomR369LdLCeZFM1+RdLFMQG8wOhbSyR7efLAHK7+t3rVmrrOpiP/IQrCgpFSFiYV+Px1suh3o0XkZRXoFUDQ8xfGbmQQWZ6NmS9zlP/3BYwPf2smGfaaWW0HU7/hHqWSLAYzkpqJj92P2lCKMLGlpM39oY+N76UOfpSQOIzmOz2sUZipKhlVB0How11yiizeaCzcCa323SQPqZJ8TQu/tCTDM07qLwk2cZXO1Tegr2Cw0OfLP0T7MHgwXRxuTBo4aS8Jen0NO0xDipCmGvt+Fxa6mqDc+4vg3lbRt43Iw4VBUd++GiMM1inBAWmzPnYOsgdXOJMG4bPiM2RLQOiG/ubnio9GSOm+xw3njUUM5V9t+QAOZzUlmfD9nxN0yZUUvx5KNzbj06Rsx6PyHifKuHUpp6tOWeHsbG3kLOl1etPxoCbHziViz1Fn/1uPg7C7DLqzno8=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6235.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?T2xNSmRZd2tLUy8yZUlDNUhXZkRQRWcvbmZ2UFdlQS91K3lYQ0RrOVMyTkt4?=
 =?utf-8?B?dDBSSGszblhtazYyU1o4Z1dOekU2RFJzV0hCRk9hSVZXQkNjTEhwYlppaDlk?=
 =?utf-8?B?b01NYVU0Vk9rV3pFVS9jOFByR3pNenBUUWEyQlVaU0REbkFVcjJpVFhqZjQ3?=
 =?utf-8?B?ZEc3ZzhWT1dRWEJkRHRzU2h1K0NjOC9uVDBock93dElGRTE4YlM0QTlSbk1z?=
 =?utf-8?B?QUNwMlNEa2EzRTFWVGJYbDZUdHFoQTc0Wmx0MVZIbHlybi8waTlvZGliTU82?=
 =?utf-8?B?TzlpZzVRYVRObWt5Zm5TdkNvd0ZEdVl5L3hnYU5JUG51bzk4WUVGdmVPSTIr?=
 =?utf-8?B?ck5OcVdHRTBGSXBiTXg0ckh1a01XM09aUlFUK0hlMkV3SnFNK3c5R2thYkM2?=
 =?utf-8?B?dlpCVDVNZlNBZVB0b3pNYzJsakRFRWViYkVWUUZreWdzVlNWa0lPdnRNcUdr?=
 =?utf-8?B?Z1l5eUZyaXJ1RnY5VmxPbEdRODgySjEvUHpYRGZLY0p5ZWpDV2dpVUQ4NS96?=
 =?utf-8?B?MU5wQ1pGaFJhcm1Xdi9wb09FQVIyek02aVk2MmZ4SGZ5UlpKNEtYakFSdjV3?=
 =?utf-8?B?cTJHSXY0ZFB4eVhleGZuYzg1bnJ2N3NISVRvZGJWVzgzd2JGajRPWUNoNmk0?=
 =?utf-8?B?dkRTeW5HQkdiemdDUFhMRC9LNGtacFh3cXluUlBkZ2lNeDVkdHdnZE1hZnVh?=
 =?utf-8?B?SC9pU3lhdGFkb2xKQkFGZWxDU2p6UnI1SHN1N0tYdWhlYlpIeWZkWCtuU2J5?=
 =?utf-8?B?cGNNZk5HUmhrN0llUEZNSk9SVXhiNno4UWhnWWE3aTRtS01BVG0vbWxUVENk?=
 =?utf-8?B?RzRxdWhRelVUUFRRUVRIUUhHV0plMkU2Y3JFaHY2akR4U3JYNWV5QVVLNjkv?=
 =?utf-8?B?K2N2OVJMN2ZlZEFPd1pkcThJNlJVMEJFMklkZHNiYkkveXZFcWJpc2ZLRkhV?=
 =?utf-8?B?aDZXbzh3Q3JHa3I3eFg2Vi9UTnFOaFRVclhZbldKTXkxTjhnTWlaUktTUDBq?=
 =?utf-8?B?bTVyNkYwNVhzV3c4Nkluc2RteS9iNlBvMEhRTm52bmJGazI2UUlGMHZaeHI4?=
 =?utf-8?B?eHdOWU9KU0ZOWEJpL3hwcjh5UnRUeG5MaWIwMFRveFIzZUw2K1BNTGx2WWlB?=
 =?utf-8?B?TjcwZVd6bmpab3htM2t3U2lmbk9xTW1LSHU1NkN3cDJBdU5NeFV1b2ROakVu?=
 =?utf-8?B?b1ZSbEZYQ3prZTdCQ0hXbTdmTThKWW5na0hrUzBpYWhFTk1najhVMGFtRHlj?=
 =?utf-8?B?eWhWVHhIaDZ3VXphN3huTTBzV3dnTUlUcktwbHV2SCt4cHdmeUdodVZCWFZl?=
 =?utf-8?B?SSt0MC9DVVFDVERnSlpKTXlhblFvdVlxMWpaaDFqSzFMQVRURVdTS3h6bk1P?=
 =?utf-8?B?NGRmUVZ2bDc0a056dVltVnBQNnFWV2RpMHpGVzNmM084QjlocThDV1lSMTVm?=
 =?utf-8?B?cmdFQW85WTdrTHcyRXhTQWg0WFVMa3puVnp3TWhkdU8xUDVBWFRlaEdLVDNu?=
 =?utf-8?B?dlkvTU50WndDYytYdG1NTmYxa3FaUE9RUFd4emdqUldsT0lQYzVSdWl6MWlV?=
 =?utf-8?B?WnVqQ2VOVjhROFM0aHQrWmx2UHVPeGkxKy9qZkFpanIvL2Z1TWZRRytRdkpH?=
 =?utf-8?B?VG5EbDZoODRsSStiT3dsTFFuVStLVzJaYzg2UmRISjNtNmNUSngxY2UzelAz?=
 =?utf-8?B?cFRkRnF1TkVOYmhGSDFWVHdsakpKV2hqc0hBckgvVnhGWjQxbUZ2bVdVbGlW?=
 =?utf-8?B?bGlZQS93aTJyclU0ZUhoRGplelhNbkdBQzM3UkhDNW0wbjdsV2kwa2J0d29Q?=
 =?utf-8?B?dlVLZnMxS3ErdUo2SWxzR2NjVjBMc1krMkM1N29QZEFtQ2NkUURzaTFFT3A3?=
 =?utf-8?B?a1R2MnRUS05vaC9iWmM3dTZCSk5aYTZ6andRK0xqdnk1Q2JoRzJPdXNBS2pR?=
 =?utf-8?B?TjdERnJ6VmdXRGFWTXVsWjNzWnBBT0l2eXV3RG9EQ2RadlNmd2dxczBQc3RC?=
 =?utf-8?B?T25mMlVNalpSQUFzZEFINHFvV2N3MllsNzd4TUJQaWEwRkREZXFETy8yUlo3?=
 =?utf-8?B?dWRRZVVCbXdHdnZteDJESHd6bTF3YjRoL0RsdUtWNlU5ZVRBNmNpMW5VWCtY?=
 =?utf-8?Q?zvknuwAT5UnTL2WXQAOxxcSHE?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <88C66BD1B7A30D4DB6423950575EABE8@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6235.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27d463a7-0b72-4d10-d1c7-08dc522fa97f
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2024 09:39:43.9954
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FT+5mjMhesHXd+FIn9dw/c6WG2pWfFsAzJfVMwUfcFY5LWdXbAv1YO0FA0ulgE7H1hh3RZJnwjYH7RzO2MVqBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8733

T24gVHVlLCAyMDI0LTAzLTI2IGF0IDAyOjI4ICswMTAwLCBQYWJsbyBOZWlyYSBBeXVzbyB3cm90
ZToNCj4gT24gU2F0LCBNYXIgMjMsIDIwMjQgYXQgMTA6Mzc6MTZBTSArMDAwMCwgSmlhbmJvIExp
dSB3cm90ZToNCj4gPiBPbiBGcmksIDIwMjQtMDMtMjIgYXQgMTM6MjcgKzAxMDAsIFBhYmxvIE5l
aXJhIEF5dXNvIHdyb3RlOg0KPiA+ID4gSGkgSmlhbmJvLA0KPiA+ID4gDQo+ID4gPiBPbiBNb24s
IE1hciAxOCwgMjAyNCBhdCAwOTo0MTo0NkFNICswMDAwLCBKaWFuYm8gTGl1IHdyb3RlOg0KPiA+
ID4gPiBIaSBGbG9yaWFuIGFuZCBQYWJsbywNCj4gPiA+ID4gDQo+ID4gPiA+IFdlIGhpdCB0aGUg
Zm9sbG93aW5nIHdhcm5pbmcgZnJvbSBicl9uZl9sb2NhbF9pbisweDE1Ny8weDE4MC4NCj4gPiA+
IA0KPiA+ID4gQ2FuIHlvdSBnaXZlIGEgdHJ5IHRvIHRoaXMgcGF0Y2g/DQo+ID4gPiANCj4gPiAN
Cj4gPiBTb3JyeSwgaXQgZG9lc24ndCBmaXguDQo+ID4gSXQgbG9va3MgZmluZSB3aGVuIHJ1bm5p
bmcgdGhlIHRlc3QgbWFudWFsbHkuIEJ1dCB0aGUgd2FybmluZyBzdGlsbA0KPiA+IGFwcGVhcmVk
IGluIG91ciByZWdyZXNzaW9uIHRlc3RzLg0KPiANCj4gWW91IG1lYW4gZGlmZmVyZW50IHRlc3Qg
dHJpZ2dlcnMgbm93IHRoZSB3YXJuaW5nIHNwbGF0Pw0KDQpJdCBzaG91bGQgYmUgdGhlIHNhbWUu
IFRoZSB0ZXN0IEkgcnVuIG1hbnVhbGx5IHdhcyBjb25maWd1cmVkIGJ5IHRoZQ0Kc2NyaXB0cyBJ
IHBvc3RlZCBpbiB0aGlzIHRocmVhZC4NCg0KPiANCj4gTm90IHN1cmUgeWV0IGlmIHRoaXMgaXMg
dGhlIGJ1ZyB0aGF0IGlzIHRyaWdnZXJpbmcgdGhlIGlzc3VlIGluIHlvdXINCj4gdGVzdGJlZCB5
ZXQsIGJ1dCBJIGZpbmQgaXQgb2RkIHRoYXQgcGFja2V0cyBoaXR0aW5nIHRoZSBsb2NhbF9pbiBo
b29rDQo+IGJlY2F1c2UgcHJvbWlzYyBmbGFnIGlzIHNldCBvbiBjYW4gY29uZmlybSBjb25udHJh
Y2sgZW50cmllcy4NCj4gDQoNClRoaXMgZml4IHNlZW1zIG9rLiBJIGRpZG4ndCBzZWUgdGhlIHdh
cm5pbmcgb3IgYW55IG90aGVyIGlzc3VlLg0KDQpUaGFua3MhDQpKaWFuYm8NCg0KPiBXb3VsZCB5
b3UgcGxlYXNlIGdpdmUgYSB0cnkgdG8gdGhpcyBwYXRjaD8gVGhhbmtzIQ0KDQo=
