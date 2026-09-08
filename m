Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazolkn19013077.outbound.protection.outlook.com [52.103.46.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9C7481DD;
	Tue,  8 Sep 2026 03:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.46.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788837523; cv=fail; b=F0rfzrnxe0r2Ny/b1lgD4/CeHsnjwpj1VtOWyAjN9k4qURPZhYyohBdUW+m7XgSDg2Gcr+rG9KE6F/fJ3mHhALLgVOGZ+KDJSqrHzfnoPMUcGr6pMo0ryN8TcDjWYtvkaybksN9Rpus4vH2Drmhg6r2KwPGRwCMsDnZ2N1uJRX0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788837523; c=relaxed/simple;
	bh=5JS1qiiPiZCPYs65oJ9pmFySKvyhpa3YOoE7RRTvi2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Z6vnMHmWyjMF05NQmJt0A7BoJ7KL+6JV1iyoqU6mEWwZNBeMGZusPsab7GO/OTuRWpQ0vj7bMepl3puPy7/W5uQr54BQM5efSnSGdNVRPBmDerUPqr8lw4yZ/2ZaTvZVgcAoUh1kQ5ephI9vLh77KRmoG3ItyRyP2Dr0n6b3SwA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk; spf=pass smtp.mailfrom=hotmail.co.uk; dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b=uDLkHn32; arc=fail smtp.client-ip=52.103.46.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b="uDLkHn32"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zQu2mwgqiX34sAQEc+IDARWj57fp8Q4E/bm8d0FHOi7P98OQW/H7AEHA7fuKqlZw96J3qfWvK7mqwp32/EbzEaurvDxTxBfxQgeH77JAk+dngKql6Z5ZswfBBimVZ4ZW2js4KUxxA3/g7rIEr928khVBnf4FQGWpPv3OT+j5zDDKvYBzU9DxuSXxeZKblVhQ6xxflyJnhG/dq1sTegjo8i7G97CkvXL09wq8YdI23KCiXh9kS+O26VKSKlkP8+RjwEOOE463QIoKqWDVsDIB9c5HjGb5DjyRPZgA4TEvALtMSJw3Aek6d3AumHm+lzjQAF8vhCJUmXP43diSjswj7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zCHYZLa7wjgL66/xKcdbhNbpjaue4rPQeUVm6kvCC/o=;
 b=dXYph8oGqF1d7xx3g7oUL8brFzsCz+i6j20hXThaxnpx3wYpPgmsAAIKGDC077Sq7v6LZ72LvfY6sM9FrzRDlZvtrZH7oN9es4S1MuKUP1ZtCt8EoTc9D8yARrfXN8bFU8z4laG4rJIYBR81WkSDuy+MxNH6mLPFVImjc8imn2UF8dOjyUlKLDKhccLDzvDitXHGSeYRxJmXpCPDEHtBLefXe7Eh3rvgwCi2/6XzzkCqMQrN0LSTpXcFTvs+gT7J0wEbh5pvLyia9b1Pk13igACWAVS+C3+qe8cqJbsIewoFGmambwqkFxnzyO926dwPQTrd8j5VjmOkqQbv3AkzzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=HOTMAIL.CO.UK;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zCHYZLa7wjgL66/xKcdbhNbpjaue4rPQeUVm6kvCC/o=;
 b=uDLkHn32qit7n3/pFHWft8N+TTNub03xYon9swJqzm+6WL1p996OTWA/pNLLiGyRkW2qlEfdPx1QxBuIiQkdM66Uh9Ebo999ETmz2l0ioQPmjImStd8FFKnnXcbwlJBNFbN7Q/q9D0mtMVge7dkFq3LEfaHsuLcGI7gdq6rcuFjcOm0EJPtFfinSAKPvyv+SkDbRY0Ge3OmL8RfpTNdrl0hniiPY/X7eCHyi9T0zaQRw0ZeEVFjZdoL4T3il8xD9q40MTBhxGv3NK1/+4iuosH/VMNGAapyVQlLQoZp216L47Lr4KEReLjQRidFx4InueMAkOLBWidEFkJX8wy4l2g==
Received: from PAXP251MB0010.EURP251.PROD.OUTLOOK.COM (2603:10a6:102:1d9::15)
 by DU0P251MB0851.EURP251.PROD.OUTLOOK.COM (2603:10a6:10:3b9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 03:18:39 +0000
Received: from PAXP251MB0010.EURP251.PROD.OUTLOOK.COM
 ([fe80::fb91:30d8:e31d:1f35]) by PAXP251MB0010.EURP251.PROD.OUTLOOK.COM
 ([fe80::fb91:30d8:e31d:1f35%4]) with mapi id 15.21.0382.014; Tue, 8 Sep 2026
 03:18:39 +0000
From: Aamir Ahmed <elb12345@hotmail.co.uk>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Aamir Ahmed <elb12345@hotmail.co.uk>,
	Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] netfilter: nf_conntrack_h323: fix OOB read in decode_enum()
Date: Tue,  8 Sep 2026 04:18:33 +0100
Message-ID:
 <PAXP251MB0010F1E23D8D01B42D64A492C8B12@PAXP251MB0010.EURP251.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.53.0.windows.1
In-Reply-To: <AS8P251MB00011EEAA381DC17852BA37CC8B22@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
References: <AS8P251MB00011EEAA381DC17852BA37CC8B22@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0616.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:314::16) To PAXP251MB0010.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:102:1d9::15)
X-Microsoft-Original-Message-ID:
 <20260908031834.123948-1-elb12345@hotmail.co.uk>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXP251MB0010:EE_|DU0P251MB0851:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a151680-7b6b-4164-132e-08df0d57e0d9
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|23021999003|51005399006|25010399006|15080799012|19110799012|8060799015|2604032031799003|37011999003|25031999004|55001999006|6090799003|24021099003|5072599009|40105399003|2607281247196008|440099028|3412199025|26104999009|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QVNhcFBtSDN5Y1ZTZ29VL29Zd3NVNGhmSFR4Z2ZlUUF4cmFBZVpVVUdRZS92?=
 =?utf-8?B?cG83QlFtNkovcHZTSyszUFdoVXE4MlVpckh4ZnhlNWtXSTBtSnZtbzhsd1hS?=
 =?utf-8?B?VUpnZjdFUXJjWmk1T2xZa0lXcWxvbEpqNWNiQ1hGbEJMVU5aMy9ZOTFLVUlq?=
 =?utf-8?B?MmU4SmphakQ1UkVod0dna2V4aUo3bC8xTXM4RDgyQ0E1d0ZvUEVoRGp2eW52?=
 =?utf-8?B?NDQ2ZFdWUVZUdUdhZXNncU9RMzNTRmQ3czJ0RDhOY2FVbm5XcEJaaDdHUlBH?=
 =?utf-8?B?eElxRjhhRzd3RG5GNS9SaFZDZmZabDJpQ09BTFE3Qm1aaUFlaFA4YlNVMStP?=
 =?utf-8?B?OWNMbDFwRUE1TmxoVkJOcFJiWUhCdlZma0Qyc2dMaE5sZFZLWm9uVzI0UTBq?=
 =?utf-8?B?Qzc3cXpzZTN0bzlUdzRVK1p0YXdTUjAwT0dBUWlOcnB0ZzZoT2lEdVJaTSs0?=
 =?utf-8?B?OHJjZDM3dFFSQ2M2bjh0SUlEMUhhV2RxT1pvSElIOCtnZkE1ejd0UTZ4dWdR?=
 =?utf-8?B?ZkJzZm9nU0pkWDQwTjE0MktETTBVUTNna0liV1NjMDFuUTdZOHFlSlc3ZVRi?=
 =?utf-8?B?K1I5ZnN1N08wdG5GczRwZERJRHF3bXoxSUFGcGdTMnFzWWpRODkzdHVHeFYz?=
 =?utf-8?B?bUtuQi92QWplZnFDZWpWU1E5WHNjTWJ2YUl1N0J1MHZKbEdmcFNZME9qVXhm?=
 =?utf-8?B?Vkw0Z2QwcnU3b3F5NmhGVGpVdkNnQk1pMFgwWVJvWXhTVlpnaWNWZGd2NzJK?=
 =?utf-8?B?WGRPTUV5aGMrcjRKN05XRjdHRGhpQWRKOG5WdTBISFpVZDArZnUzUjVkY3Z2?=
 =?utf-8?B?SERSSnpheis3dWVTL2hoUWZzSG9iYTZmYUxseXZlQ01ZZ3BkYTBUVytBTUJu?=
 =?utf-8?B?d3NvR3RBMXJHdzdXVHl1ViswYVpyYTYzbFV1dUZJc3MyL1Z2dEFVRFZkT3Q4?=
 =?utf-8?B?ODZVTytoR1dJUHZPbWtUL0RQTVY1aW9kTmNBTVYyQ2tOYjVZRm5td3I0RCty?=
 =?utf-8?B?VHVCckx2eHRnSWZld3VsSXF2RHhMZEVYWVU1eE1zNTlQZXhhd08zWEZiZEJT?=
 =?utf-8?B?b1VOSllHSmdBNm1OTlNyK3Q0bWl2V0xLNmc2K09qZjM3YkJJL2pJZ1VOSTBu?=
 =?utf-8?B?WGErRTNNazlzbDNTWUVvNW93NnM1ME5IbWVxeDBwcTZjalRJdXZJeFp2dVo3?=
 =?utf-8?B?V2NqYkpuNFVOam0waFlkRWFKcHNReCtJL2pkVmt1UFBITkV4MGZ6dzlIOVJk?=
 =?utf-8?B?ME85eXN3K3ljL3VLMXVoK0hRd2g1R0NKOFRGb1BMWWQyL0Q2c2hwc3NaWEJm?=
 =?utf-8?B?OE40M0ltZHlVKzNwaERiNDd4OElFaCs4dVArbE5mU2hqNmNLenZiM21GRE00?=
 =?utf-8?B?cGlBcVBPWGxKdFIzdnpnWFZvWmhJek5lNTdpMzk5RDUvTkswaVZHWnBZMWNh?=
 =?utf-8?B?VWh2OURpYXk1bnJvOWVCaXZLMVNLQ1QyaWtFdzB2RFBhNGY3TW81aitzUFUv?=
 =?utf-8?Q?3H4mS4/EVlrJwVPJUca1DWF+3QL?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z1JRckxkbUY4RWJyWGxrWUJ0NVFhUGF5eWVPTDQwLy9EQmIvRXNkNmNMY3d1?=
 =?utf-8?B?bTJIdml1bFBGekFOS1FlOXY5YlhzVnRuM3FuNXp2LzJ3NjJnYWtUTkJJS1FG?=
 =?utf-8?B?aHZmc0J4b2ZRR0N0N29PWXFxTWMwNkJNNTNqWHBXdFBSYkMrSzVQZTJQN014?=
 =?utf-8?B?a1JKdW5vOGNJenlldjUyeDh2eWJYSTlOTFRFYzVTcG5OK2hmRTJ3RHRtaVll?=
 =?utf-8?B?KzNZUjFKbU12MEtxNFEvU3VFMnVQL1hxcnBjK09JeFh5VGpxbEo2SUJ4SlJZ?=
 =?utf-8?B?T3FwV0d3R0hjcDF1R1doZ3FxdHNUeUI4UjRjQmpXZmIrT3gyNktxWSttcThQ?=
 =?utf-8?B?Uk1SQ1Yram5lbllwcE9uNEtxQW42Z0lJeSs3cEhNQ0NvT1NvWXBVZUtDNDE5?=
 =?utf-8?B?S1EzZHYyNXNhY3hkQ1BxbEZnQ2twdndsdnVSWEJuSmhxZ09qVDdqVkxwejlU?=
 =?utf-8?B?YzFsbEdMcUV2OFZsT2t2b3Rxdjk5ZWxRdXY4NnVUQnpMYTJiSUl2L2UxNFhR?=
 =?utf-8?B?TlZKZjN4eHVBWThLRmhOOVQwVHdWN0FZbjRHQm9STGxmY0JPNUl4QSs1cDVT?=
 =?utf-8?B?WksxSkMwbkdmeXQxQWxsSlRONFFyc2hJcmNYWGUrTVY2dTNGVTZxa00rZ2x1?=
 =?utf-8?B?RFlQeTdTL3JYKzhIY3UwaFVXbUMvSjB1WXNqVWtrL2F6ODNCNmRUcE5ESkov?=
 =?utf-8?B?NThTTjBIUWpUV1NsU3lac290VWowN0tCRnVxdUNiS0NnV2lBOG1tWlAxTUNt?=
 =?utf-8?B?aTFxU2dBVE5WUDZrRW1LZHFvL2tpbmY0b0NKc2ppSE9YS3I0M1Jwd3FkRHd0?=
 =?utf-8?B?L25taUR3R1Q5ZjVzNnIra3NkZThXbjF1NmFKNGFSWG9pVmhTSEcxL29EOGZU?=
 =?utf-8?B?ZzZnWVRhaXg3UVEvMHU0M1ptbFlDKzlmZU9ETFh4OWI4aFEweWw2WUozZDNy?=
 =?utf-8?B?VkxuaVpMRXViVTJsaS9ERmZqVE95VitJMDZXQWNWK1M2NHowR2pPQXdHcHpN?=
 =?utf-8?B?VW1oMTg5cFYzNXBkUWF1OUhUL0RKWGs2M3h5b2pjNEtnSVZBSU94SlJORmdz?=
 =?utf-8?B?SHQxL3JBOExNaVo2WHFQeXA2bFIrZG5RRlJEbndWSnRxb1o3NGlNUDByL3Nm?=
 =?utf-8?B?VHh2a1NhNm1FWXQ1ejhOS1dQVDlWV1R2d3ZDMytLSnBLUUUvNFFQK1BnRmtI?=
 =?utf-8?B?VU0rZDhiVHl4TFAxVVBNUFkxSXFkZWxQMGRSa1A2WVB6dFptYnZ6RytmakVE?=
 =?utf-8?B?YmJhSktsdXpJVmZ3bCtuaGVBakJ4RCt1ZVd2N2VuU2tQTUVyUU9XSS9vNWZD?=
 =?utf-8?B?UHNGRFNlZjdqZ1p2cUYrKzlzeVRnNW5kcFdlTjhXUThSUU5ZR1M0aDZ3N3VL?=
 =?utf-8?B?RTU3M1VSR1hDS2pERGVXc1hZRTNzOUdWZE5paGh0NG9ERXY1L09UaVhYLzM2?=
 =?utf-8?B?aHk2Z2RjN1JUYTB1RTBSTUxKYkRJczE0VS9mOWxKL0tTcEdGRVFMU3lzbFRB?=
 =?utf-8?B?WVFVbEowMnBUOUJLNFFCNTFtU3JMOTNNMmtOUUZCYzBPdkt0NEJHMENGSEs0?=
 =?utf-8?B?ZEtTUnA1V3psV0ZSKzQyZzJsK250My94N2N2Skh0dUJ5QjluNFRXYlZUTW9n?=
 =?utf-8?B?WE12SExnUWcrM0pFbUpsWUpMTWYwb3FrQUowY0pDenkxN2hpRzBxZ0xCMm1j?=
 =?utf-8?B?b05RbFlyK0RlNmpnQ1BPY0hrSlQ1enF2MXp2dm40SFk3Zm5UL2N3dS9JZ0pG?=
 =?utf-8?B?WDJ6UmZ4QWEvSTJHQnBHR1lPeHBHSDhGQ1I4dURlUEFLWXpjbzJ2NExsanV3?=
 =?utf-8?B?ZUcwcFVMRWhWVjlZZ1pFcTdlTkJVc2lFTG41bEtRUitjQjQyZ1p4US9uRzFK?=
 =?utf-8?B?RzBOZStHaG5pSlg0WTF3L0luYTgycDJXRmpZN0lnZVB1VFBzTm1oYjgvODZK?=
 =?utf-8?Q?uywqJjJida421lb7WGj74XEXcf6a5cCq?=
X-OriginatorOrg: sct-15-20-9412-3-msonline-outlook-fe3f5.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a151680-7b6b-4164-132e-08df0d57e0d9
X-MS-Exchange-CrossTenant-AuthSource: PAXP251MB0010.EURP251.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 03:18:39.8379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0P251MB0851

Please drop this patch - decode_enum() cannot be reached.

The types table has four ENUM fields, all named screeningIndicator,
and each one sits past its parent SEQ's root field count (Setup index
28 vs lb 13, Connect 14 vs 4, Alerting 12 vs 3, ReleaseComplete 7 vs
2). They are therefore only ever seen by the extension loop in
decode_seq(), which skips any son without DECODE:

	if (!base || !(son->attr & DECODE)) {
		bs->cur += len;
		continue;
	}

All four are SKIP, so the decoder is never dispatched. No SEQOF item
or CHOICE alternative has type ENUM either, and Decoders[] is the only
reference to it, so the unguarded get_bit() cannot run on any input.

pw-bot: rejected

Regards,
Aamir Ahmed
