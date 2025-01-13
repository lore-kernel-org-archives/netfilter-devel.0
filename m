Received: from lgeamrelo11.lge.com (lgeamrelo13.lge.com [156.147.23.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276AE230D1C
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Jan 2025 07:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=156.147.23.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736752287; cv=fail; b=M/yEeiPTGwcOJHe3+lJoZdn9h6Ry4mOshKN2rb+28GG5h96+XtDvLHBtGXHabJY/eoqL28DVh2qqqIs9XQ3RbcAsa52JPIAIUB9U8Kp5TtDa7jLTsVu6Kc21MMuDoiuW88N9t6JOmRRHxPNAvyB8sNVJZ+mA/Be6bR/E7QFBLeU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736752287; c=relaxed/simple;
	bh=+MdjTBI+5sp0XX4x+3WLHsJihtK8VtWNmGnGp44LakM=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=HUjtq/ihrrEojMwM4WvlqXnbq5HnYHwGYVofqy6x0RINXA1F3kmfztUcTs0Kvi73hDfFkwYUNaJLstiuXvHzGQMuyYeTtGM7cWz6/Oyf+6LgPDfJZjrurnaGUboFy0igU+xRuODdlJLFrpaCrsMbV1/5x4U9rZg6rR1UpeYI/FM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com; spf=pass smtp.mailfrom=lge.com; arc=fail smtp.client-ip=156.147.23.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lge.com
Received: from unknown (HELO lgeamrelo04.lge.com) (156.147.1.127)
	by 156.147.23.53 with ESMTP; 13 Jan 2025 15:41:20 +0900
X-Original-SENDERIP: 156.147.1.127
X-Original-MAILFROM: hongsik.jo@lge.com
Received: from unknown (HELO sniperexo4.lge.com) (165.244.66.184)
	by 156.147.1.127 with ESMTP; 13 Jan 2025 15:41:20 +0900
X-Original-SENDERIP: 165.244.66.184
X-Original-MAILFROM: hongsik.jo@lge.com
Received: from unknown (HELO SLXP216CU001.outbound.protection.outlook.com) (40.93.138.30)
	by 165.244.66.184 with ESMTP; 13 Jan 2025 15:42:13 +0900
X-Original-SENDERIP: 40.93.138.30
X-Original-SENDERCOUNTRY: unknown
X-Original-MAILFROM: hongsik.jo@lge.com
X-Original-RCPTTO: netfilter-devel@vger.kernel.org
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WRFvAdCTp4Lvs7KxP6MUUymcKMFQSNl4BiJ23c/w9EKf0+YaFzshQkTw8oWrMQhFBvMTYjlH4ZslTk99JFTM63k2iDrrXTSiS/HcvsSD/GBdojvynZu8/K1KOjFdHf3C73b7v6bb9VwFzD3tORUWW7SmnpCCuA/T9NuYb0a7wyElJaL7ReYR0VesbeQdz7EdNmgnxeEasM9jfvBrzRQ6IOyp1zAXaRYxjrpn5LofoeKEEBk166fIG/QA/mtVdSINYV1XwSdwx/QGyhXyzULwOS12n5/ZZEpg4RNbzCrfPoPbM1G5p2WUuT1y3JoKDgeBGjQSMz4kfQIGVRiO5E5ZVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+MdjTBI+5sp0XX4x+3WLHsJihtK8VtWNmGnGp44LakM=;
 b=si19RSxzSO9VH7alMajIQVq6Pj1kracZsq4yQ+xO8n5UVZ0eEg4iPZLwxa5v+07V28CUpa2U/SfkFi48Dsy8pp1TSs2D+QTJTv0GL/HHPxERRwbktRNrFqSqkD7fLMJfBAyWQwKEDJVNbWdoXgMYmXLHZl0AtWm5+RbQmokyxxPANTnLvIjz2F36ftAG1gV565wjw13iXW84qhK4nYb6m3mSNltzrAVBbpSfxe3lcPZlNnpBBCjiZHjz01zt3A6JLpiX7MuQ9td2y+jWJIotX3WiQKbQKkj9VQe4CXofbzg3wPRC1uSsfIEFSWaZgSblqU/t3inkb9UUhfza80Bkrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=lge.com; dmarc=pass action=none header.from=lge.com; dkim=pass
 header.d=lge.com; arc=none
Received: from SE1P216MB1558.KORP216.PROD.OUTLOOK.COM (2603:1096:101:28::7) by
 SL2P216MB1500.KORP216.PROD.OUTLOOK.COM (2603:1096:101:31::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.18; Mon, 13 Jan 2025 06:41:19 +0000
Received: from SE1P216MB1558.KORP216.PROD.OUTLOOK.COM
 ([fe80::cdf9:f1be:d666:7315]) by SE1P216MB1558.KORP216.PROD.OUTLOOK.COM
 ([fe80::cdf9:f1be:d666:7315%7]) with mapi id 15.20.8335.017; Mon, 13 Jan 2025
 06:41:19 +0000
From: =?utf-8?B?7KGw7ZmN7IudL+yxheyehOyXsOq1rOybkC9TVyBTZWN1cml0eeqwnOuwnA==?=
 =?utf-8?B?7IukIFNXIFNlY3VyaXR5IFRQ?= <hongsik.jo@lge.com>
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
CC: =?utf-8?B?7KGw7ZmN7IudL+yxheyehOyXsOq1rOybkC9TVyBTZWN1cml0eeqwnOuwnA==?=
 =?utf-8?B?7IukIFNXIFNlY3VyaXR5IFRQ?= <hongsik.jo@lge.com>,
	=?utf-8?B?7IaQ7JiB7IStL+yxheyehOyXsOq1rOybkC9TVyBTZWN1cml0eeqwnOuwnA==?=
 =?utf-8?B?7IukIFNXIFNlY3VyaXR5IFRQ?= <loth.son@lge.com>,
	=?utf-8?B?64Ko7KCV7KO8L+yxheyehOyXsOq1rOybkC9TVyBTZWN1cml0eeqwnOuwnA==?=
 =?utf-8?B?7IukIFNXIFNlY3VyaXR5IFRQ?= <jungjoo.nahm@lge.com>,
	=?utf-8?B?7KCV7J6s7JykL1Rhc2sgTGVhZGVyL1NXIFBsYXRmb3JtKOyXsCnshKDtlolQ?=
 =?utf-8?B?bGF0Zm9ybeqwnOuwnOyLpCDsi5zsiqTthZxTVyBUYXNr?=
	<jaeyoon.jung@lge.com>
Subject: Symbol Collision between ulogd and jansson
Thread-Topic: Symbol Collision between ulogd and jansson
Thread-Index: AQHbZYUZeSfuxQZz00yVbYxjbJSvMw==
Date: Mon, 13 Jan 2025 06:41:19 +0000
Message-ID:
 <SE1P216MB155825DDA1CD5809E1569DDE8F1F2@SE1P216MB1558.KORP216.PROD.OUTLOOK.COM>
Accept-Language: ko-KR, en-US
Content-Language: ko-KR
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=lge.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SE1P216MB1558:EE_|SL2P216MB1500:EE_
x-ms-office365-filtering-correlation-id: 61801b7a-22c1-436d-d3e5-08dd339d49cd
x-ld-processed: 5069cde4-642a-45c0-8094-d0c2dec10be3,ExtFwd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?UkdSUGVNa2t6N1JDbXp3Q2ZqbzdncE9XbExQVTdFUW9IbTNPdElZLzlvRHVs?=
 =?utf-8?B?VXpseHN2aHRXZVBHWG9kVHppMStiN05QM1ZtOGxCVkVKN0NqN2NZaHNCRUJT?=
 =?utf-8?B?a25HWWpLOENBZkdYWHlMbWNLMDBpenE0QXdMREJiKy90bTB3NlAxdERGc0x0?=
 =?utf-8?B?ZEZCSmlGa0VGMDlFdXFGaUxvSHBJVnI5d0wxOWlKOUh1L2FrVnBaWnZyM3VJ?=
 =?utf-8?B?ajZIcDJiTmF3NDR2RDZtOUlmajZNUTdmMW1pYktMbUZsSE4rOFQyQWVMQThM?=
 =?utf-8?B?TDVNTDdtNlhXWUFpaVZWNHU4VGpJcDFWZWNNa0R3OTR6aXcybHp1Zjc2RlNz?=
 =?utf-8?B?VzM3OFliNERveXpjRUxnT0puQ1g4cU0zbkJwakZTNFhKYzhRMEhLbWgrT29V?=
 =?utf-8?B?VXByaE1HdzJwc2VFa1RZbVpIWERreWFOK1hEOHBxdnFxaTJYVVdjRTlWcFJK?=
 =?utf-8?B?d3hPdHljZEdYcEt4azlRRUZKcmpZSFBydnd6Ymhib2NtdEdHV2c4L2hxazlz?=
 =?utf-8?B?dFFxVmZmeTl4VHFCLy91VlVhYTExaXMvKytwbCtGVjlpQW1jRUp0Z0FGOGFE?=
 =?utf-8?B?cktqK1NHOHB4aXV0QmRHTitMaUMxNnZ6U1MvSjhCNDBDSi92L2hXSEgzYnln?=
 =?utf-8?B?Tm9IT2NnbnpCRUMwNGhybndQZ0dtKzdScFRUbDdwd2lIYk16SkNQVE9EYW9D?=
 =?utf-8?B?SEZGaXl6TVpiZUxmWU9mU0o4WGxobGZtdUZWelAvR1lTZXRQWGwxNURIY2NX?=
 =?utf-8?B?bm5WM1lHZ1czRTkyczdCQmd5cCs2Y0xkUHlCcU1CUmdTaURaM1NKMitoZ3Ix?=
 =?utf-8?B?RDN5T0JucGNHV0k3dW44N1VBLzVDaWgwNGRPbzJKQnRZdHh5cnF3anFOdk83?=
 =?utf-8?B?VGRERGZmQUFVcGZPSWVOalIwelA1YXI0U0laVmZKVXp0VExyZnpMTVovQnZx?=
 =?utf-8?B?M1lHRmtwOHp3NHlNZFBHVkpicXNwYWJKVmI5eWt6VGs0VFArUitUUWtkY1Rw?=
 =?utf-8?B?TnJ4eFVWVUR3Nm1xOEgzUmZtdi9MV05sQlJDcWFSbHVHOHVYcCtONDB5UThL?=
 =?utf-8?B?Mk1vdno5RTByUDFzTWc0Uno2VU14M3U3SWtzVWZDSFFFSmdCVStuamgyYXRP?=
 =?utf-8?B?enJsT2pwL2pjU3dBZm5xOUMwSzB0T3J5Z2ZiS0VRc3p4UVVYbnJOY3FxSi9n?=
 =?utf-8?B?Ym5kU0FyNXRhTHdURytCN1lhRkVGU2tGVkFKbEJGcml6a0pJeDduOXUvZmZm?=
 =?utf-8?B?aDBiRjhBL1ZYeHMreUZ6MklaS1BiM3YyUlRpaHdEMTJBb2RLT000ZWt1ajZJ?=
 =?utf-8?B?SEJKekUyZDUyZDRDQ2JTb3JMbVZtK240ZUVMQzUrSHlhR2h6YnNDQWxhM3FK?=
 =?utf-8?B?VmdyaTF6SDN3bFNwRnRWeHZ5Vnoyc0R5TDdsbld3S0dqcENiSWNURWJMUGpK?=
 =?utf-8?B?MXpESG1ZQWNUQ2tMMjJyTjZvTDZUOVVCTXlSNXhrNFNQUmJ2L3ZwUWtZNXZ6?=
 =?utf-8?B?VXR2M3hISlFqaTBxQ2ExTTc4ZUpYYkw3MGlvNURCSVJUeGc5TmhOTnl2b3FJ?=
 =?utf-8?B?ZFA0OWY1MVJYNEVWMUdTOEdIR2Vocnp1OHdBUlFKZlQwcUFoVmpkOVU3SXBL?=
 =?utf-8?B?WVBoK2lHbStBQmVQRjhwNGQycEZVdkNlblMzc0Q4VFJpalZHbzU4QXR2d3d3?=
 =?utf-8?B?TWo2MkdId0dpVWhMWThCY1BKSWN5YjlLajFRdVE2d0h5LzZubEV3N21ZRGs1?=
 =?utf-8?B?K2FwSEFOb3F0RGNQUFRKSzFoWW11SmlZdktIcFA1TER6Znd4bDl0bzFJb212?=
 =?utf-8?B?blNqTXQ4Z2lKWnlVVjFaYndmd3c0eWlJRmUwaWx5M3JzUytKL21TVEhMT1hE?=
 =?utf-8?B?YStCME9qblJ6VTdnSExsVjZMN3h1RFlOdzVYSXE1QzhFV3c9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ko;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SE1P216MB1558.KORP216.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dVRkS3NCSGM3aGpLK1F5WVFOTk52UjhBTTJGa1BsU05INnVoQzM1NnNpSFJ6?=
 =?utf-8?B?NWNUZFA4NkVXRXUwb1pHWStCajByMldzdmxpT00rdE9ncUFPMnA4MHVUbEUr?=
 =?utf-8?B?TEhCYTl1MlVmNUNKT0VyR2NyTVpkVHZRZlJoRkZhZzJZZGZlOVpJdnBtZWxL?=
 =?utf-8?B?ZTB0YXJ6OFhCZmNoSXRHV3A1dXovSFpJanBVT3p1YlRwaHVlQ05ONnRxUUxJ?=
 =?utf-8?B?TGE4RVYrZVF4Wmw2YVZDTjlFWDVzSUxDb2dKZXlqc1d1OTdJR0k5ejlPRW1t?=
 =?utf-8?B?SEVrTGpDd0xuZEF5QS9GT1gyNmZoK2s1WDVpRlZsMWk3YXJZWXlzNnR1TzI4?=
 =?utf-8?B?UVAybHRBOEhvYmg4UmFNcFMzaXg1TDVBeFFPdGs2RXZJaXMwaWVSdjdYcnRX?=
 =?utf-8?B?ZnpoRHlCZ1ZaUUMvWTBENURFMFRVdTQ0NXE5ME1tSmcycng5cFBrdTFOY2NS?=
 =?utf-8?B?T09hb0kwak9wN3FKc1REbDJsdmpmV3p4Q2UxVmdlYkpZREswcTh1b3lWWXE0?=
 =?utf-8?B?M1ZLNVdlVGEvdGZ6L1ZlTFlJZ3dOeUxDVFJWY1VnL1phZEo4bWhZejhFVXl0?=
 =?utf-8?B?QndMM3lLemlqWERYMGdMK1dwT25tQ2FwNlQreHlDMFhHNkszdnQzK01LcFFo?=
 =?utf-8?B?V2REUlJVajRldDV4UUFFakQrQkJFQmVUTWFLd0hjaU9ES3o4c1VoYS8vSTAv?=
 =?utf-8?B?cXBVZHFpV2lIRHp4QVZTWjVsTlVXanZBUnVjZHdxdkJHSTIrSTNmNWhna29p?=
 =?utf-8?B?b0tGR3RBWTUvOEhIbUt0NHFvcEROY1BYd1FxVmcrcnVsY3NjYjF3UnhKUVo5?=
 =?utf-8?B?ZlV5SCtieUQ0STkxQ2hKWTB5cjFKNVEzajAzRFpJV2RqOE9qVVAydnhBNDVv?=
 =?utf-8?B?V1VtZ3pNOG9IeUlid3BuLzhrUFR6QWhwd2ZZVVp1TUJWaEIvWGUvYTZlSktE?=
 =?utf-8?B?YXFUSzhnK2hwNzNWNm9pbnp5Rk45clBPblM2VE1tM3RYdnhqYzNOdm91NzJp?=
 =?utf-8?B?RzA5Tk5PdldCSmR6TWMyMVZDQUQ5Z1BjWUF1Sk9teExLTWlNY1FmU0Z3ckox?=
 =?utf-8?B?dFB6YmxPck1kOTg2Qnl6SkozWkgzUVNhZTB4U3Jtb2NzQ0tRRXVJRC96MHJ3?=
 =?utf-8?B?VytuUE4zQkZrV0Y2Rkh6aDZKZ2FlejA2ZzlZcDY5Ymdhc3NNMjNHT0FhQVB5?=
 =?utf-8?B?a00wR0V3b2J2eERtT01TclZWR01EUjhTVnpRSkplL0VSKzVVcEVDTzQ0c1k1?=
 =?utf-8?B?TndDRGxVNjhsYm9sWU9rQzI4ZjdZOW5TN1JMM0diZ3VuZ1V4b215MFVjRW1a?=
 =?utf-8?B?NXE1YTZwZnkyd0FjZFJodStiVjBKYzRRKzdxc2JSaU03MGpydm9mUldTMUU2?=
 =?utf-8?B?MWFmdlNNNGpiS01OT285cWNVYWgzWWZJUURWZkI4WkFtbllOZzdGOWhabEN3?=
 =?utf-8?B?V1czYlhsVUtieTZNYW94dXp0MDhHOVowaHdFKzM3cERZSjhuRjNDcFlqWTV1?=
 =?utf-8?B?aU4rYnMwVmNKR3VXbkhHRU1DVjdhbDFPMGltc0h3elJsbU1yeHkvMHFnV0Vo?=
 =?utf-8?B?SDNVY2RSOHJ5UHNLKytlbHJCT3B5VjMrdG5qakhQL0sxbmtscTRVT2tUL3NO?=
 =?utf-8?B?cXNsa3YySEYwU3BKb2VoZk9MNXF6d2ZzT3ZXLzdFRGk5d2MzVTAycnkyQnNv?=
 =?utf-8?B?dkZEMzkrZlJ3QVdwaE41ZHp3Y3R6MFhvTUNZbmptYTk1dGRLUktKOFQ4ZEFU?=
 =?utf-8?B?QnpDN0d0bzY0R3N0aFY4UmVjTm5HQWN6ZHVJT2JacTM2RFRPRGc3RkVmY05z?=
 =?utf-8?B?akt1NWg1Z3RNTGNPZ2RYRWNGZG1ZN24wd09iL3BCalhIcHUxbWxpQVp5NVVo?=
 =?utf-8?B?dDB5TGtBR1IyRHkzNWlCU0tNWVIvMU4xeXJLbGVKdnBlTTVwbHlVRDNKUFpz?=
 =?utf-8?B?QU9sd28za3RnK1hmektQd3lIMHJReWlhZXVxRTcwelkyNzc5TUJ4MmVUR2Q3?=
 =?utf-8?B?NllzSjZ1Yi9Ka0J1UmFIb0cxZkQ3V3RqMFVmQmluZGY3MEcrQ3pvcjdpUnZl?=
 =?utf-8?B?dDRib1oyalhrUElTbmxWTmFFZGt4RmV6cXlYL0plWHc1RkpxMU1ONHFvdEFY?=
 =?utf-8?Q?WKkM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: lge.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SE1P216MB1558.KORP216.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 61801b7a-22c1-436d-d3e5-08dd339d49cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2025 06:41:19.7094
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5069cde4-642a-45c0-8094-d0c2dec10be3
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9pwy5YM+73aFTAjO6mcgA1bKdHBMzvw06n+4na6oNPDE3rIgjU5AfXGe2uOo/GNMBBGCtnwxAGNrbVtA3HqFzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SL2P216MB1500

VGhlIGlzc3VlIEkgd291bGQgbGlrZSB0byBicmluZyB0byB5b3VyIGF0dGVudGlvbiBpcyBhcyBm
b2xsb3dzOgpXZSBhcmUgdXNpbmcgdGhlIEpTT04gZmVhdHVyZSBpbiB0aGUgUEFDS0FHRUNPTkZJ
RyBvZiB1bG9nZCwgYW5kIHdlIGhhdmUgZGlzY292ZXJlZCB0aGF0IGJvdGggdWxvZ2QgYW5kIGph
bnNzb24gaGF2ZSBtZXRob2RzIHdpdGggdGhlIHNhbWUgbmFtZSwgd2hpY2ggY2FuIGxlYWQgdG8g
YSBzeW1ib2wgcmVmZXJlbmNlIGVycm9yIHJlc3VsdGluZyBpbiBhIHNlZ21lbnRhdGlvbiBmYXVs
dC4KVGhlIG1ldGhvZCBpbiBxdWVzdGlvbiBpcyBoYXNodGFibGVfZGVsKCkuIApCYXNlZCBvbiBv
dXIgYmFja3RyYWNlIGFuYWx5c2lzLCBpdCBhcHBlYXJzIHRoYXQgd2hlbiB1bG9nZCdzIGhhc2h0
YWJsZV9kZWwoKSBpcyBleGVjdXRlZCBpbnN0ZWFkIG9mIGphbnNzb24ncyBoYXNodGFibGVfZGVs
KCksIGl0IGxlYWRzIHRvIGEgc2VnbWVudGF0aW9uIGZhdWx0IChTRUdWKS4KVG8gYXZvaWQgdGhp
cyBzeW1ib2wgY29sbGlzaW9uLCBJIG1vZGlmaWVkIHVsb2dkJ3MgaGFzaHRhYmxlX2RlbCgpIHRv
IGhhc2h0YWJsZV9kZWxldGUoKSwgYW5kIEkgaGF2ZSBjb25maXJtZWQgdGhhdCB0aGlzIHJlc29s
dmVzIHRoZSBpc3N1ZS4gCgpGb3IgeW91ciByZWZlcmVuY2UsIAoxLiBPdXIgYmFja3RyYWNlIGFu
YWx5c2lzCihnZGIpIGJ0CiMwICAweDAwMDAwMDU1OGVkNDc3MzAgaW4gX19sbGlzdF9kZWwgKG5l
eHQ9MHgzNDMzMzI2MzM1MzU3ODMwLCBwcmV2PTB4MzA2MjM2NjMpIGF0IC91c3Ivc3JjL2RlYnVn
L3Vsb2dkMi8yLjAuOCtnaXQvaW5jbHVkZS91bG9nZC9saW51eGxpc3QuaDoxMDcKIzEgIGxsaXN0
X2RlbCAoZW50cnk9MHg3ZmM1YzM4NDYwKSBhdCAvdXNyL3NyYy9kZWJ1Zy91bG9nZDIvMi4wLjgr
Z2l0L2luY2x1ZGUvdWxvZ2QvbGludXhsaXN0Lmg6MTE5CiMyICBoYXNodGFibGVfZGVsICh0YWJs
ZT10YWJsZUBlbnRyeT0weDdmYzVjMzg1MzAsIG49bkBlbnRyeT0weDdmYzVjMzg0NjApIGF0IC91
c3Ivc3JjL2RlYnVnL3Vsb2dkMi8yLjAuOCtnaXQvc3JjL2hhc2guYzo5NgojMyAgMHgwMDAwMDA3
Zjk1MjM0NjAwIGluIGRvX2R1bXAgKGpzb249MHg1NWMyMzRjNmIwLCBmbGFncz0wLCBkZXB0aD0w
LCBwYXJlbnRzPTB4N2ZjNWMzODUzMCwgZHVtcD0weDdmOTUyMzNhZDAgPGR1bXBfdG9fc3RyYnVm
ZmVyPiwgZGF0YT0weDdmYzVjMzg1YjApIGF0IC91c3Ivc3JjL2RlYnVnL2phbnNzb24vMi4xNC9z
cmMvZHVtcC5jOjQxNgojNCAgMHgwMDAwMDA3Zjk1MjM0OGU0IGluIGpzb25fZHVtcF9jYWxsYmFj
ayAoanNvbj1qc29uQGVudHJ5PTB4NTVjMjM0YzZiMCwgY2FsbGJhY2s9Y2FsbGJhY2tAZW50cnk9
MHg3Zjk1MjMzYWQwIDxkdW1wX3RvX3N0cmJ1ZmZlcj4sIGRhdGE9ZGF0YUBlbnRyeT0weDdmYzVj
Mzg1YjAsIGZsYWdzPWZsYWdzQGVudHJ5PTApIGF0IC91c3Ivc3JjL2RlYnVnL2phbnNzb24vMi4x
NC9zcmMvZHVtcC5jOjQ4NgojNSAgMHgwMDAwMDA3Zjk1MjM0OWEwIGluIGpzb25fZHVtcHMgKGpz
b249anNvbkBlbnRyeT0weDU1YzIzNGM2YjAsIGZsYWdzPWZsYWdzQGVudHJ5PTApIGF0IC91c3Iv
c3JjL2RlYnVnL2phbnNzb24vMi4xNC9zcmMvZHVtcC5jOjQzMwojNiAgMHgwMDAwMDA3Zjk1Mjcx
OTM0IGluIGpzb25faW50ZXJwICh1cGk9MHg1NWMyMzU4NjkwKSBhdCAvdXNyL3NyYy9kZWJ1Zy91
bG9nZDIvMi4wLjgrZ2l0L291dHB1dC91bG9nZF9vdXRwdXRfSlNPTi5jOjM5OQoKSSB0aGluayB0
aGlzIGhhc2h0YWJsZV9kZWwoKSBzaG91bGQgYmUgCmh0dHBzOi8vZ2l0aHViLmNvbS9ha2hlcm9u
L2phbnNzb24vYmxvYi92Mi4xNC9zcmMvaGFzaHRhYmxlLmMjTDI3NSAgKCBqYW5zc29uJ3MgaGFz
aHRhYmxlX2RlbCApCkJ1dCAjMiBzYXlzIHRoYXQgdGhlIGhhc2h0YWJsZV9kZWwoKSBpcyB1bG9n
ZDIncyBvbmUuIGh0dHBzOi8vZ2l0aHViLmNvbS9pbmxpbmlhYy91bG9nZDIvYmxvYi9tYXN0ZXIv
c3JjL2hhc2guYyNMOTQgICggdWxvZ2QncyBoYXNodGFibGVfZGVsICkKCjIuICBJIGhhdmUgaW5j
bHVkZWQgdGhlIHBhdGNoIGRldGFpbHMgYmVsb3c6Ci0tLQogaW5jbHVkZS91bG9nZC9oYXNoLmgg
ICAgICAgICAgICB8IDIgKy0KIGlucHV0L2Zsb3cvdWxvZ2RfaW5wZmxvd19ORkNULmMgfCA0ICsr
LS0KIHNyYy9oYXNoLmMgICAgICAgICAgICAgICAgICAgICAgfCAyICstCiAzIGZpbGVzIGNoYW5n
ZWQsIDQgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9pbmNsdWRl
L3Vsb2dkL2hhc2guaCBiL2luY2x1ZGUvdWxvZ2QvaGFzaC5oCmluZGV4IGQ0YWVkYjguLjRiNDg3
NGIgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvdWxvZ2QvaGFzaC5oCisrKyBiL2luY2x1ZGUvdWxvZ2Qv
aGFzaC5oCkBAIC0zNCw3ICszNCw3IEBAIHZvaWQgaGFzaHRhYmxlX2Rlc3Ryb3koc3RydWN0IGhh
c2h0YWJsZSAqaCk7CiBpbnQgaGFzaHRhYmxlX2hhc2goY29uc3Qgc3RydWN0IGhhc2h0YWJsZSAq
dGFibGUsIGNvbnN0IHZvaWQgKmRhdGEpOwogc3RydWN0IGhhc2h0YWJsZV9ub2RlICpoYXNodGFi
bGVfZmluZChjb25zdCBzdHJ1Y3QgaGFzaHRhYmxlICp0YWJsZSwgY29uc3Qgdm9pZCAqZGF0YSwg
aW50IGlkKTsKIGludCBoYXNodGFibGVfYWRkKHN0cnVjdCBoYXNodGFibGUgKnRhYmxlLCBzdHJ1
Y3QgaGFzaHRhYmxlX25vZGUgKm4sIGludCBpZCk7Ci12b2lkIGhhc2h0YWJsZV9kZWwoc3RydWN0
IGhhc2h0YWJsZSAqdGFibGUsIHN0cnVjdCBoYXNodGFibGVfbm9kZSAqbm9kZSk7Cit2b2lkIGhh
c2h0YWJsZV9kZWxldGUoc3RydWN0IGhhc2h0YWJsZSAqdGFibGUsIHN0cnVjdCBoYXNodGFibGVf
bm9kZSAqbm9kZSk7CiBpbnQgaGFzaHRhYmxlX2ZsdXNoKHN0cnVjdCBoYXNodGFibGUgKnRhYmxl
KTsKIGludCBoYXNodGFibGVfaXRlcmF0ZShzdHJ1Y3QgaGFzaHRhYmxlICp0YWJsZSwgdm9pZCAq
ZGF0YSwKIOKAguKAguKAguKAguKAguKAguKAguKAguKAguKAguKAgiAgICAgIGludCAoKml0ZXJh
dGUpKHZvaWQgKmRhdGEsIHZvaWQgKm4pKTsKZGlmZiAtLWdpdCBhL2lucHV0L2Zsb3cvdWxvZ2Rf
aW5wZmxvd19ORkNULmMgYi9pbnB1dC9mbG93L3Vsb2dkX2lucGZsb3dfTkZDVC5jCmluZGV4IDg5
OWI3ZTMuLjM4YmFmMDUgMTAwNjQ0Ci0tLSBhL2lucHV0L2Zsb3cvdWxvZ2RfaW5wZmxvd19ORkNU
LmMKKysrIGIvaW5wdXQvZmxvdy91bG9nZF9pbnBmbG93X05GQ1QuYwpAQCAtNzAyLDcgKzcwMiw3
IEBAIGV2ZW50X2hhbmRsZXJfaGFzaHRhYmxlKGVudW0gbmZfY29ubnRyYWNrX21zZ190eXBlIHR5
cGUsCiDigILigILigILigILigILigILigILigILigILigILigIJpZiAodHMpIHsKIOKAguKAguKA
guKAguKAguKAguKAguKAguKAguKAguKAguKAguKAguKAguKAguKAguKAgnNldF90aW1lc3RhbXBf
ZnJvbV9jdCh0cywgY3QsIFNUT1ApOwog4oCC4oCC4oCC4oCC4oCC4oCC4oCC4oCC4oCC4oCC4oCC
4oCC4oCC4oCC4oCC4oCC4oCCZG9fcHJvcGFnYXRlX2N0KHVwaSwgY3QsIHR5cGUsIHRzKTsKLeKA
guKAguKAguKAguKAguKAguKAguKAguKAguKAguKAguKAguKAguKAguKAguKAguKAgmhhc2h0YWJs
ZV9kZWwoY3BpLT5jdF9hY3RpdmUsICZ0cy0+aGFzaG5vZGUpOwor4oCC4oCC4oCC4oCC4oCC4oCC
4oCC4oCC4oCC4oCC4oCC4oCC4oCC4oCC4oCC4oCC4oCCaGFzaHRhYmxlX2RlbGV0ZShjcGktPmN0
X2FjdGl2ZSwgJnRzLT5oYXNobm9kZSk7CiDigILigILigILigILigILigILigILigILigILigILi
gILigILigILigILigILigILigIJuZmN0X2Rlc3Ryb3kodHMtPmN0KTsKIOKAguKAguKAguKAguKA
guKAguKAguKAguKAguKAguKAguKAguKAguKAguKAguKAguKAgmZyZWUodHMpOwog4oCC4oCC4oCC
4oCC4oCC4oCC4oCC4oCC4oCC4oCC4oCCfSBlbHNlIHsKQEAgLTg4Niw3ICs4ODYsNyBAQCBzdGF0
aWMgaW50IGRvX3B1cmdlKHZvaWQgKmRhdGExLCB2b2lkICpkYXRhMikKIOKAguKAguKAguKAguKA
gnJldCA9IG5mY3RfcXVlcnkoY3BpLT5wZ2gsIE5GQ1RfUV9HRVQsIHRzLT5jdCk7CiDigILigILi
gILigILigIJpZiAocmV0ID09IC0xICYmIGVycm5vID09IEVOT0VOVCkgewog4oCC4oCC4oCC4oCC
4oCC4oCC4oCC4oCC4oCC4oCC4oCCZG9fcHJvcGFnYXRlX2N0KHVwaSwgdHMtPmN0LCBORkNUX1Rf
REVTVFJPWSwgdHMpOwot4oCC4oCC4oCC4oCC4oCC4oCC4oCC4oCC4oCC4oCC4oCCaGFzaHRhYmxl
X2RlbChjcGktPmN0X2FjdGl2ZSwgJnRzLT5oYXNobm9kZSk7CivigILigILigILigILigILigILi
gILigILigILigILigIJoYXNodGFibGVfZGVsZXRlKGNwaS0+Y3RfYWN0aXZlLCAmdHMtPmhhc2hu
b2RlKTsKIOKAguKAguKAguKAguKAguKAguKAguKAguKAguKAguKAgm5mY3RfZGVzdHJveSh0cy0+
Y3QpOwog4oCC4oCC4oCC4oCC4oCC4oCC4oCC4oCC4oCC4oCC4oCCZnJlZSh0cyk7CiDigILigILi
gILigILigIJ9CmRpZmYgLS1naXQgYS9zcmMvaGFzaC5jIGIvc3JjL2hhc2guYwppbmRleCAxZDk5
MTMwLi44ZmQ5OGExIDEwMDY0NAotLS0gYS9zcmMvaGFzaC5jCisrKyBiL3NyYy9oYXNoLmMKQEAg
LTkxLDcgKzkxLDcgQEAgaW50IGhhc2h0YWJsZV9hZGQoc3RydWN0IGhhc2h0YWJsZSAqdGFibGUs
IHN0cnVjdCBoYXNodGFibGVfbm9kZSAqbiwgaW50IGlkKQog4oCC4oCC4oCC4oCC4oCCcmV0dXJu
IDA7CiB9CiAKLXZvaWQgaGFzaHRhYmxlX2RlbChzdHJ1Y3QgaGFzaHRhYmxlICp0YWJsZSwgc3Ry
dWN0IGhhc2h0YWJsZV9ub2RlICpuKQordm9pZCBoYXNodGFibGVfZGVsZXRlKHN0cnVjdCBoYXNo
dGFibGUgKnRhYmxlLCBzdHJ1Y3QgaGFzaHRhYmxlX25vZGUgKm4pCiB7CiDigILigILigILigILi
gIJsbGlzdF9kZWwoJm4tPmhlYWQpOwog4oCC4oCC4oCC4oCC4oCCdGFibGUtPmNvdW50LS07
