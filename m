Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5D1440C;
	Sat, 23 Mar 2024 10:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711190241; cv=fail; b=iElXxl/OZKYMeec9+CHjD7T6vyEsVqkVkyER8d6EzU5tPx88oECwgGkR/MmFF5PHBKWZiEkzR0C/bEnRiSSMWR5cQDSi7rRlKLsn6/L1WloZ4wto+4cLM8+cqQL+PrPqmeVLPlIJijwMZm2I8lsFUnFWviTft1fmITO0dFT7htw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711190241; c=relaxed/simple;
	bh=OYoZ5MqZbMVpbphkB8rn1EQ0Cv6Fu6vTzT7fzXggUv0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=f8weZHGDfUL0VlFHBQpRtN5ri38uOatxxFA3hiK8baysue4pIiE+WIdpyui1TDdRjLpQwEZNffoS1nh/Kv6elFiC1g0TbCbOsBjrKeqW4J+fIP6RyE/A3o3dVBja2KNSF1cXRMm+A5kGx7qV+Puynpx8lqgcA5d6gW10YQa4ons=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ezZo9kVd; arc=fail smtp.client-ip=40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ezZo9kVd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z0ZN+FNzIBk0OEwiEavw5DhwcpiGOoxOOUud+ulsF0TXByW0EUzTS4s98D2yKsLv09TmBTRccihcOvChO88tUPlBXb82vevhJZh/aLo0InnuZIbCC+vdeiEiBt9Fe49fYgORhk5NpRKC4jj+NmtpEWPhGBHUw+59HyXWd3sCLt9SwZzcwKYRC1LLbCu1M4s+MoAye8aO9ius1za0b7+3xD33liEqs4OQy8liIpe3HMcH1C+ygpyPXv8KJgVp1rO76F/kaS+4gnKVeS4fpTJSRzXD/fGVICQl5Uqi+8CuPv+FNvo5AkiIQv1Vf7bsxmKRMJe2pw0fQuPig2NNmIUS1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OYoZ5MqZbMVpbphkB8rn1EQ0Cv6Fu6vTzT7fzXggUv0=;
 b=oemJX0+NQy/2KO4dN9KmvBKYGjVAlwy9nLQSCLPaAN3V5fUkP6dXo33tsj0MzuBts1KfI4DJIITHeDw0VMXLbN9UCTVDtYdJqEj78+gG927eIVV8MVqyC4cqYZ5D3cVKeAucdTscM37wHs71zoRRLwsRsmAYreSZsdsi9rT1mqyfk7Qk4FMGytpf/6BtDkHdfH/by3sku0uMQS4nvouIIPHBRbrt/P3N8QEh36LmjsdGvlO0nQHJ0LXgKbfPMAOreEPc8PF2sckroZ/9Y8mwXwKtZjmlH43qEzxhFx9iIC+mZ9pMjb+HprPIoQL7Pfb1cAhFnwEl65D1piiWRcMQcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OYoZ5MqZbMVpbphkB8rn1EQ0Cv6Fu6vTzT7fzXggUv0=;
 b=ezZo9kVd9cQM4600lz5Elt8l1tkLMtQ22InZH8WmakqGTkch6g+fz4JhclaOvNt6kAOfaxnqzaIb65yfUgWIXQuoV1AQBnJp8CSpIqckCAn1zhzOn06glaCVrWyb8PlB97FBy5QMqw5O/JBGVFLYwfb2WD6NSkiN78XWthCHjX8arCSFDF497j1TfNns9Q+f5e4lvXSs5/aNdHVvh95F9kx1dGtdWqboCGytV1h4/FxSWXQaRGJZrg8IOGOQa8mYGt2EoLsmqxMSN9lwywRcyw02FcGM672ozrpYxfkfd3pau9U1lYTFENeH8QFJJIZTsx3Eb4x0gdHZn+1n1dtZIQ==
Received: from IA1PR12MB6235.namprd12.prod.outlook.com (2603:10b6:208:3e5::15)
 by IA0PR12MB7750.namprd12.prod.outlook.com (2603:10b6:208:431::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.34; Sat, 23 Mar
 2024 10:37:16 +0000
Received: from IA1PR12MB6235.namprd12.prod.outlook.com
 ([fe80::2afb:c838:f5b0:6af3]) by IA1PR12MB6235.namprd12.prod.outlook.com
 ([fe80::2afb:c838:f5b0:6af3%4]) with mapi id 15.20.7409.026; Sat, 23 Mar 2024
 10:37:16 +0000
From: Jianbo Liu <jianbol@nvidia.com>
To: "pablo@netfilter.org" <pablo@netfilter.org>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "fw@strlen.de"
	<fw@strlen.de>, "netfilter-devel@vger.kernel.org"
	<netfilter-devel@vger.kernel.org>, "davem@davemloft.net"
	<davem@davemloft.net>
Subject: Re: [BUG] kernel warning from br_nf_local_in+0x157/0x180
Thread-Topic: [BUG] kernel warning from br_nf_local_in+0x157/0x180
Thread-Index: AQHaeRh+r2dUlP7fzkayCsPDG8BqZ7FDtn8AgAFzdIA=
Date: Sat, 23 Mar 2024 10:37:16 +0000
Message-ID: <d6084a1cdd0e6d2133c8586936266aedd8eb3564.camel@nvidia.com>
References: <ac03a9ba41e130123cd680be6df9f30be95d0f98.camel@nvidia.com>
	 <Zf15Ni8CuRLNnBAJ@calendula>
In-Reply-To: <Zf15Ni8CuRLNnBAJ@calendula>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.40.0-1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR12MB6235:EE_|IA0PR12MB7750:EE_
x-ms-office365-filtering-correlation-id: 26d8c4ea-4a81-4af2-5033-08dc4b253591
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 1KZ4qML99JNwJG5Eag5wO56EroZgBGMTdQKpW7csVaWUSej4MnScX6Zo3fqE+W0jzh1zDJLtsaCpjQ+5kIlm/qYgy7Cec6Rrr5Idz+eSHinm3O3BYL4RrL93kPebi1LdvvOX2VvZYTPATes/NBy5LULpCSCldcXpslSPEdgPANpIc8yAVmpEdyXtKeRNun9Wa3SbaBEqYz9K6+Iqo1S8yT4q9AvLhTi7aMGDjnG2X0+GR5UBMVqWE/DNT+9GPIaE6ckUX9zfxHogVUoj+8IT3tNAC549gSBORBexnPJrdBfCO/CfsgoEGgWn7mMCxbn4RIGO7etEvSoRPENZxXtIBj6By8+vSiazqDeA1I82jfuITaiwEcxDYjiSSF4cusXdMHVmlsnNEvUoLOgAZ+F4Gg0vdY7Q184jqfa74U4a0RQ69mXGCZGBYcsSnSd6GOknm7didDy7xrXA7zcEFheDu+XWl0/8T5cZMsh1BRqfcvAzG88a0g8q1GFLn4LkHnlEuCmpMuUhv5C0BHhM2b7GgUfLLpZnQ3K1/ATZqIyj+HjNTm5gpmKq23p6/2/ugfh9AZCsuXCjClaLq+LVYT9/OlLqLyHXFky3SQUNTk/fJZwo4lIQ6YXZpAV/RnHca8opdPfchsujlbY0+UPBg5hBvb0FePItBXo2PVnLgW2iKREKSzOewFHW2zBe6IhjAp7yfU/1HiE1ehrSMomHTwMwFzX/Zdx7gIH/Du4SPM3rigA=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6235.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bElwbjU3RWZoa1hMeWtRMDdwUFdDTlZrVmQwOXh3My9kZXUwbVY5SUw3ZFVv?=
 =?utf-8?B?T2JIYjNOMENzV0xLSHZDa1AvVThvZVRLS2hwcDREZVN3S0tRYjdWQ3hqMlY1?=
 =?utf-8?B?S1U0OGhBNzcvcXVMNnA5TUlkR3dGcjJuSkNudElubFZGUjliSUo1RGxFZjdh?=
 =?utf-8?B?SGI3czZiQ2JydGIyVDhKYkZLSTZWSFliMWFnYk83Y3YxZVVObnNtWm90cXVI?=
 =?utf-8?B?eTR5cUxtNXNMRUNWK0ZEeXFzWHFpbm5uSCtFMXArL0JEbXR3Vnp2Z0pwOGZR?=
 =?utf-8?B?RmtqdUY5NVJUUUNpSEwwT3RMSkxGd2xGNEJCY21hWSszbFJha2I0TWRrV1NX?=
 =?utf-8?B?MGVpVTNMR0lOYWtjOG5JVGJLVlNtcEhXTnlwRHdQSWtSNzIybjlxaDRtWmE3?=
 =?utf-8?B?UG9PTEZIUjJRcXI2RDJCTGI1SHVUeUY2a3NPVmdmWjhSeXprS2lyRkZOT1R2?=
 =?utf-8?B?TDArc3JGSGVGSHZRd0VET1UrSGtkTmt0SUJ5cDMvbk1pQUFmb1M4S1lhb0ph?=
 =?utf-8?B?cHFDcjdPejJxZlJEZnR5aVhEYkZjQ29XVWx2Y01nZlluQ21JWnA5UExyVE84?=
 =?utf-8?B?eXdFUlhmQXhYSjAvN3JGQ0JZOE9xdjRadjJla3g2Q2VodVlVdFNPRU5Gb0c5?=
 =?utf-8?B?Zm9OUWZDc3drYWhWN1lOVGxhMXI1N0ZuVWdoYmVNTEJpeWphMkxYdVVxbE5C?=
 =?utf-8?B?bDJwZjJETGZTMlFFZ3dLVkF0bVdBSjRpQnRhRVRsK3liZXNoM0k3OFRLVVo1?=
 =?utf-8?B?cXFXL1p6d2t0akdCSmduSi9VckVGSDhmMUozWHdlUXN0RG9uRmgxRDJwQVdZ?=
 =?utf-8?B?NXp6VEhkRHFMTXlaZFJlNWFPQVhrbFZYTWtNT1BPRDdodGhhbzBycjZZYjQz?=
 =?utf-8?B?clI3MUxrdVd1dEFxZzVwb2ZZZlRsajBZOHVLNyt1aXkrUFdjVG1kcCs5d1ZX?=
 =?utf-8?B?RWdNU3RVNE5VKzdSbWRYY20rNENhekhMRlpoNTc3alprWnBKWXJRY3VEYmJk?=
 =?utf-8?B?bkRoa1pzNGVRcndSWU5sei9xWXNpN2czNGF2WURyNXliOU9GQVNoUnFXL2Nn?=
 =?utf-8?B?amppSktteFhqZjVZV0pySHlkNzdvMHJTNXA4V2NKc2RaWmdYSGNwTy9vdXhO?=
 =?utf-8?B?VFl4Wk51L1ZYaUpFMGcydm45d0gyb1kzVUMvMGNhbEVTWHZuNWZZR2gyd1d0?=
 =?utf-8?B?WThlZXZNbXZNNzUwdEZYOStOQytTRkd4aGgrd0ZaeGRORFJjSkRiankxbm9p?=
 =?utf-8?B?YlEra2xacktnaDRmbmR3ZGJzb0NhbFd1eTFaV0FjR3kyREFJd29uUlJRSm8x?=
 =?utf-8?B?cThtL2NHbDJ0cXhTZVpJTCtPT0VTL1M3MFhiRTJXcllaNitMM2RnNVZsL0V5?=
 =?utf-8?B?Y0dwM3ZGbzI5bGVtcW1qMlhORjc0WnVPaDRUWVdQZDVzZ3FqdkZoNG1FRmc3?=
 =?utf-8?B?dkVHQUdDSm1vZFBmRHNGekhNKy9TcXI4dXpQdTQvcHZZSndUd3NtY1pJNG9W?=
 =?utf-8?B?Q05ONENkRVpFaXNGbzVaejVGWUo0NVJCOHVVczZ5Mkl5OE5GQjQzd1FCaFhp?=
 =?utf-8?B?aHlBMWgzWS9KS3N5THU3QU1Jb2wyempCZUFzc1ZnaDh5VFJmTEF5NGIwTDc5?=
 =?utf-8?B?MnA2dWxkRzBhVGtsUm1zeEVESkFVNmRLUkZJOFNPTmVTOXFjYmpsV2Q1V0ly?=
 =?utf-8?B?OGg3cjQwVXE1WVl0ZWI4NTdlYVJLT0RBOFFpS2lMT0RpLzdocUtINWpwU0xu?=
 =?utf-8?B?a3ZLWTh4bHl5Uyt6KzVkeU8rdzhSeWFGcXNBR1ZzU3ZUOXh3aGVrT05ydFUx?=
 =?utf-8?B?bzVnakpyeG5xckJuNCtVZFdFallJWUpENDdiSzRTcHM3azhCcklUZDF5ZHRX?=
 =?utf-8?B?Yk9NU0Y5QjMwMjZLWEFtRzFJSjFRM2wvTytlMXQwWk9PN2h6S2x6WVdkOTJt?=
 =?utf-8?B?SDlDMjhXc2s4OXB2TzlqZGhzSERZVnE3TjRkallhWnNwb3ZVRHFYdkR1WVdt?=
 =?utf-8?B?V3hyWjlvaXpVRnBJejFXV2JoRm9wR2EvNjBvMDhRWVJlam9SWmx4ZWw0a1p4?=
 =?utf-8?B?aUVxNlhaWmIrVVRCUkFUS0ozdjFQUG81Nnp6NC8zcWgrU2gzaDJsNEVJeUox?=
 =?utf-8?Q?z6F6ArsglLQKCn8t58i5RmEFX?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6FDCA2CB085B5940A90F81507675198E@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 26d8c4ea-4a81-4af2-5033-08dc4b253591
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2024 10:37:16.4151
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9ETxhj4CFoUPQ589JOs92puowoplptUqlbU1UP2FtGXqhVcBDgR1mz/41hOnIwdTm6qwYxQUNPV2KuRGgeFdYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7750

T24gRnJpLCAyMDI0LTAzLTIyIGF0IDEzOjI3ICswMTAwLCBQYWJsbyBOZWlyYSBBeXVzbyB3cm90
ZToNCj4gSGkgSmlhbmJvLA0KPiANCj4gT24gTW9uLCBNYXIgMTgsIDIwMjQgYXQgMDk6NDE6NDZB
TSArMDAwMCwgSmlhbmJvIExpdSB3cm90ZToNCj4gPiBIaSBGbG9yaWFuIGFuZCBQYWJsbywNCj4g
PiANCj4gPiBXZSBoaXQgdGhlIGZvbGxvd2luZyB3YXJuaW5nIGZyb20gYnJfbmZfbG9jYWxfaW4r
MHgxNTcvMHgxODAuDQo+IA0KPiBDYW4geW91IGdpdmUgYSB0cnkgdG8gdGhpcyBwYXRjaD8NCj4g
DQoNClNvcnJ5LCBpdCBkb2Vzbid0IGZpeC4NCkl0IGxvb2tzIGZpbmUgd2hlbiBydW5uaW5nIHRo
ZSB0ZXN0IG1hbnVhbGx5LiBCdXQgdGhlIHdhcm5pbmcgc3RpbGwNCmFwcGVhcmVkIGluIG91ciBy
ZWdyZXNzaW9uIHRlc3RzLg0KDQpUaGFua3MhDQpKaWFuYm8NCg0KPiBUaGlzIGZpeCBpcyBub3Qg
eWV0IGNvbXBsZXRlIGJ1dCBpdCBzaG91bGQgZml4IHRoZSBzcGxhdCBmb3IgdGhpcw0KPiB0ZXN0
Lg0KPiANCj4gVGhhbmtzLg0KDQo=
