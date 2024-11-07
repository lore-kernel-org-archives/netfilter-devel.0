Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2077.outbound.protection.outlook.com [40.107.21.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7EC210186;
	Thu,  7 Nov 2024 20:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.21.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731011912; cv=fail; b=cg5Tw7gojnaLLJdA9PHfbITqlLqa419pVlSOf+lwth6nCTDGt3+BZUE77gw6Op2ajW0Oyt8EmqoLuPBbQKQOrGo546xaiIWM8+bIyNiZw5rXyLCKcmHTcbfwjnS02qSnf1Yzhq3Cs90f/uFLqxRGVStKsNK2x6iz0bbOK3phMIw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731011912; c=relaxed/simple;
	bh=kKUbk1vlorGjJ+WIjwQo3UB5ky+Fn1T4+4GP0xQcuYI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jp4Fck/Ruh0VuDwcn0r58R5GEkgDE1cl36F6e9ppye/S5RSZTNHwwosE9hMNTZ84LvU7jKoqKDl6qd4L6Nh7jP1BG23FIM3DM0gsD9Y9NKDSSAI4QvnVHXrslrmh8AdDktmpXTxcJj2tad/PhDeAzx2bs7Gibu7S88rYabOT1yQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com; spf=fail smtp.mailfrom=nokia-bell-labs.com; dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b=WwFeP6uq; arc=fail smtp.client-ip=40.107.21.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b="WwFeP6uq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bZ8Ld1ZCDlTliwDHLRyjuyaiAFQ2Z0TbjriCa1VMdt8dpRVboAJrV36whGie3tzbNkCrPRh7C5GCaBDR2MQp8tVCtdYvspxF4g8NnogWrmPmq5fZT9ga8pNx9rX33O3Aos1L2wq+NtqZOqwcA+gCVDZMTulMaXjVp8/+TN4benjMQFdX/plsBZ0h0AHdCT8204hGb+JSPPEoF7W/ApKmxCjYXXVbvlMuGZSrCGf70yUF9tZ5D87mbJFNd8RFfdhVO6et5a5j2W/Dy4pDJ8OG3adPF8M8pI2oMGA83Y+loR0U+eUJj588GVgqFPJGmIlNRx0VYuTnWR+++Y814wD3TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kKUbk1vlorGjJ+WIjwQo3UB5ky+Fn1T4+4GP0xQcuYI=;
 b=C4KTl86XDtaKyhpu5VJy50oDz6iJ1fdBE4lx6pzhH2GfsnBefRp4xDE/2epUET+3ytV91PEjKAcraN7Lxr7Sc1nyjBntPDpgrdHV+7JiPu5PnhNCl5g/0mEF+rbWJ3+v+fZXfuNgb+HDMuekG2jXB045az8kH4LFKW/Jh8aAF+o1Th1o5b/vCbJw1ylH30n/kGV1QMRNOfSn61+/al4OdRSNXh80hUJMDP379rTmgrxRyQiYQA3kddPzgOj3BKheZ/zvnCrjLCWnoMRXv05lc6h/wSnnSqs0aIS19rJUdFLl0TBWVYK2skzypI85MFNDOwkPRs+T/FYXgUIXBg+QnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia-bell-labs.com; dmarc=pass action=none
 header.from=nokia-bell-labs.com; dkim=pass header.d=nokia-bell-labs.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia-bell-labs.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kKUbk1vlorGjJ+WIjwQo3UB5ky+Fn1T4+4GP0xQcuYI=;
 b=WwFeP6uqOl+ipZsd4w5sp8EfQPrPhj9/YZHEmjdp6/2NhSDCWfG6BiQSr+u8HaHt+Sp8fmKhCVqJ4YjYeLW6T+oQlS4IXI0UkGdg60U09vHn2QsKf7wisJs5+LuaeqOUOu23xfzBPg9STyV0xjV7ZkuI/4QolyvxyQiYx2kD2CIEFDq6GZko9FGo6OTZaDevOkOmnKw56wv9izDaZuqmNAJVLU23rCo/vH1mFyYFwn6ecrZH0gHznO8qM6HEi3ePKz2X9Xt7j/r1L3Uo+cKSXJXadfgdX5sIOAnJBME9p2MdGIjf9hyTyqkqRPxBAymkc8w5Zru/fuK+PZm6o00Q+w==
Received: from PAXPR07MB7984.eurprd07.prod.outlook.com (2603:10a6:102:133::12)
 by AS1PR07MB8712.eurprd07.prod.outlook.com (2603:10a6:20b:47b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Thu, 7 Nov
 2024 20:38:25 +0000
Received: from PAXPR07MB7984.eurprd07.prod.outlook.com
 ([fe80::b7f8:dc0a:7e8d:56]) by PAXPR07MB7984.eurprd07.prod.outlook.com
 ([fe80::b7f8:dc0a:7e8d:56%6]) with mapi id 15.20.8137.019; Thu, 7 Nov 2024
 20:38:25 +0000
From: "Chia-Yu Chang (Nokia)" <chia-yu.chang@nokia-bell-labs.com>
To: Eric Dumazet <edumazet@google.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "dsahern@gmail.com"
	<dsahern@gmail.com>, "davem@davemloft.net" <davem@davemloft.net>,
	"dsahern@kernel.org" <dsahern@kernel.org>, "pabeni@redhat.com"
	<pabeni@redhat.com>, "joel.granados@kernel.org" <joel.granados@kernel.org>,
	"kuba@kernel.org" <kuba@kernel.org>, "andrew+netdev@lunn.ch"
	<andrew+netdev@lunn.ch>, "horms@kernel.org" <horms@kernel.org>,
	"pablo@netfilter.org" <pablo@netfilter.org>, "kadlec@netfilter.org"
	<kadlec@netfilter.org>, "netfilter-devel@vger.kernel.org"
	<netfilter-devel@vger.kernel.org>, "coreteam@netfilter.org"
	<coreteam@netfilter.org>, "ij@kernel.org" <ij@kernel.org>,
	"ncardwell@google.com" <ncardwell@google.com>, "Koen De Schepper (Nokia)"
	<koen.de_schepper@nokia-bell-labs.com>, "g.white@cablelabs.com"
	<g.white@cablelabs.com>, "ingemar.s.johansson@ericsson.com"
	<ingemar.s.johansson@ericsson.com>, "mirja.kuehlewind@ericsson.com"
	<mirja.kuehlewind@ericsson.com>, "cheshire@apple.com" <cheshire@apple.com>,
	"rs.ietf@gmx.at" <rs.ietf@gmx.at>, "Jason_Livingood@comcast.com"
	<Jason_Livingood@comcast.com>, "vidhi_goel@apple.com" <vidhi_goel@apple.com>
Subject: RE: [PATCH v5 net-next 13/13] tcp: fast path functions later
Thread-Topic: [PATCH v5 net-next 13/13] tcp: fast path functions later
Thread-Index: AQHbL2qBRhQl0rfQpUefXzlFQ/KWy7KryzyAgAB/c4A=
Date: Thu, 7 Nov 2024 20:38:24 +0000
Message-ID:
 <PAXPR07MB7984611FE916408B116692B2A35C2@PAXPR07MB7984.eurprd07.prod.outlook.com>
References: <20241105100647.117346-1-chia-yu.chang@nokia-bell-labs.com>
 <20241105100647.117346-14-chia-yu.chang@nokia-bell-labs.com>
 <CANn89iL3Wc9FGBGB7s0jHm2MZ0i+xA38NqR31AJpL-4nnBHcJA@mail.gmail.com>
In-Reply-To:
 <CANn89iL3Wc9FGBGB7s0jHm2MZ0i+xA38NqR31AJpL-4nnBHcJA@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nokia-bell-labs.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR07MB7984:EE_|AS1PR07MB8712:EE_
x-ms-office365-filtering-correlation-id: 527ce375-193c-40e0-7b40-08dcff6c20b3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?SVB2NHBnWnUwZFRWYko0aWUrd291MUFjSGZES2tKYjdCZFBrMmdQVWVFbFlS?=
 =?utf-8?B?UytwcElYK0JWV2EvajUzMlROdE8wcmZHdFZJMnNlNXJKeHpRb1d0cU95eWlv?=
 =?utf-8?B?aHFMVXVyRXpLQWdUYkt0TzRYUm9qNlh3TjVPYWM0Yk5oK2lWR2MyL085RXlY?=
 =?utf-8?B?Sml6aWE2WEp1a2VkYkFyRTNVLzVZQUJYOURYMkdvMEFqS21zcElFd29wZU1j?=
 =?utf-8?B?bHBlT2N6TVVnL2NyN05ML1M0b0c0WWdyb3V0T3pyTS90RmJybmNlRGxTUG95?=
 =?utf-8?B?bEQ0UFgwdVArYTZ0a0dGck1McXc0dnYrelA2QndWUURCWis4WXlSS3lmOVN4?=
 =?utf-8?B?RGJQZkw2WFBWdFBoOHB1YzBTM1NXd1FOaWttbmRqV0VXZ3lPUWJ6aW1Baysv?=
 =?utf-8?B?YldIT0dxdXFrUDBzMWNOT1I0QVc5OXdQcjhOR2x0SDdzV1BoL3oydDNESnN4?=
 =?utf-8?B?TW01MWNMQ0lyZzVwK3RMZTRKaGF3dHJxRGdOSmxmVFIrQkwvNU1aRkVzZENL?=
 =?utf-8?B?UEhtL3JLMEtycmIreFNDRk43RkZ2VUNuNy9SLzR1b2J4ZzBRQlZzdW9hWmRn?=
 =?utf-8?B?Y2MySkNzMVp4NXI5UUd4QW5wMG1PNFRWM3J6M1FZNVg5Q2V6Nlc3cTBFOUtS?=
 =?utf-8?B?TjF2R2ZxTWRGM1d2bjBGRi9DUkdmbFRuOTZDdmMxVVk4QW55NkY1NWtsaWlP?=
 =?utf-8?B?NXhjZm81Y3pNellNWC85TGduam4zTDJmT3MvalFqZFJ6eDQzNE5qa3B5WXpw?=
 =?utf-8?B?YW0wL09QUG52ZkRjdXQvOXNRc3JoTmFRcTlNSlJMNFJEVTlrSDk4VXdTdmhF?=
 =?utf-8?B?MlZVWDJVd0FKcUR4K1NnSThHZ1ZsYWhZRnZpdjZRNjZWc09kOG1mNi9qN3Jj?=
 =?utf-8?B?RGZ2T0NWbjNrRHU5S2dVdVBvekgvSm8vSExyY2Z2aFp3aWZRekF0RWVhQkJo?=
 =?utf-8?B?YlpGQzBNVlRFQTBWVlpKYmpMTlNVb0IyQmI3UVg3bW92QmJkRkErQmpUNUVF?=
 =?utf-8?B?M3pydlFrZTlQWXlyMzBwa0ZqSjUxWVF1bUdIZU9iKzNiWXY0UkZiaG8vb1Zo?=
 =?utf-8?B?TG96VXNrUnkxTlpINGVubFc4ejEvdWVHMkVhQ1l2SEp4YnIxb0lZbHlCSEQ3?=
 =?utf-8?B?MHo0aHpnZGd6a3dxdXZ0TFRPU3RlT3lmQXA3NEcwaS9BOHlGUVZER1BYTHlK?=
 =?utf-8?B?UUx6bFJnYVFkSFVSQjJ1azFudWpxaGdyUE5aM0ZmNWRweFFQNGpvdHlkd0dW?=
 =?utf-8?B?K3RVeDdOVkVmcHZPcWJ3clRaUVZmbTFodXZ0QVpzTU1oUkRsMVVvVW8xYkxS?=
 =?utf-8?B?Vk85Nk5nMHFya1NtTUVpOUNQWkFnQzBmLzNFU0lreW5vVDlEZGlnTXppVnhs?=
 =?utf-8?B?NUpnT3cxRVA0U1hwV3MrbVJONlptbXBVQ0RVRG1ITW1XN3RBd1FlSkRrVUgz?=
 =?utf-8?B?VjJIL3g0WFhxQmtWUTVOUU1haWtMZnYwN3d6UnBKSkE0M0JFT2VucnJIUEZE?=
 =?utf-8?B?cVE4TUZIUDZQT1BtcGpvV0tKa0dGanc4a3F3VXFUWG91QUk2bjhJRzN6V3kv?=
 =?utf-8?B?a2tQWEVwbG9yS1VmSUVBUmJCWTlLei9manhYKy9NQW4wOGV2WWRjUm52dmZl?=
 =?utf-8?B?TEJJQTB3QlpPSUZtQnFGWDVNRC8yY1dVN0RXZWxkMm1vQVREcmhxRjZjZjBR?=
 =?utf-8?B?b1prYVRrelFMbUJTRE82Wnd6UkRoSHk1QmpzaUN6RlhDbCswaWpoNzlvMFZS?=
 =?utf-8?Q?l9ik1elAMxPjRiThzwGZgLI4ebD3V1r2Dfcy0Un?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR07MB7984.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SHRZYllXbTVHMmNQN0t6MDFWQkVxT2hqZE5BMWF5TWZyUGYyWWRiR2lFbnJi?=
 =?utf-8?B?M1dqWk1DcXdRYzZGTjZ3N3M5Um11eTk0WFBVWnJHYlVTL1VHajhYUmdTUkNn?=
 =?utf-8?B?bXJ3UWdHajYvMlF3U0NJWGo1S1hvVkIwMStuSFFORGRBSUJwZHpHT1JlUG5J?=
 =?utf-8?B?Z0NWbXhZa09YVk9wSHVtQ0E0Y0w1SGl1M1FlYS9neFdiM2F0dndIQUV4azF4?=
 =?utf-8?B?eXprd0NuVVpFQ3VRbHhpckxYdDc0K2d5WDZCU0ZJRS9GVUxVWWMzUjJ5RERH?=
 =?utf-8?B?SEdISExrb01kQko2NHlxdVh5SUN1aDNSVlkwMCtmbS9UdGthbzVPZGQ3NVhr?=
 =?utf-8?B?ZWRrT09LQUZyN2hTV3BiWnB0WVNsMmZ1b01hSmJxdHdVbFQ1RVQwYUtKUUl5?=
 =?utf-8?B?MXNuaXhwbzhQblMrc2Q4RlJHWUNoMnVBcUVRVzE5N2dVbE1SN1RGQ3A3Mk9P?=
 =?utf-8?B?Y2twQWljei9pcWhjdGpyYTJUWjRBOEFmdGgzdW1oWXdZSXFvS0JHcy9ORDE4?=
 =?utf-8?B?d1JhRTBhNDBkSHplUVFDY1l1WHlvZHl3dDBXYjNEUm9JakhHemp6QUZpZU1p?=
 =?utf-8?B?Z09VUmhZcDdsNGRQbU44YlpEKzlyeVlDWW9VT2ZoNDNvVHV0NkViQ2c3dHNp?=
 =?utf-8?B?TCt2YW1YS0JGMU1BRllESldWZFl1NDVzUm13VStIMGVvajhwZmpMcFZ3V0h6?=
 =?utf-8?B?QXFvN0ptYUZqc3RHaldPQlVJNDRJSG92TGlESkdqU2VBaEdCc1JOamVDMDVE?=
 =?utf-8?B?MGNvbkZzNm1SRnNZTUVaeGtxTHg4cUdlVzVxSXJzYS9nbTVoV05iSmdXanMr?=
 =?utf-8?B?VWN5anJpc1NKZ1VBZXovNHNnc0JSUExpWmo3UW5NTFhqMlQwSStOYXMreUYv?=
 =?utf-8?B?dXFCbVhsTi9uOUVrUXpCUUFCMkNvdmJDdW1JVjlJS3hEdGQwTkkwaWhaUVhm?=
 =?utf-8?B?aHVwdnlxZjJzUDZLY2tRT2NxcWxSYVgzYWViZUZjYjQwYkpyL1diUjUwNy83?=
 =?utf-8?B?aWZOQmEvR2R3aGRKdUdmbllWRkI1ZGs4OGU0ZjladlhudnVmMmFKeEVkK1RT?=
 =?utf-8?B?alNuSUluQmh3aEl3dThaRU1xRW9DQlVhTnNGTG81U3Z3T1hHWFU5WnFrQWZz?=
 =?utf-8?B?NG1sUE83OHI2T0ZmZUowTEQzYnNWVWptTmRtUlNGVlpWQ0FIL2FTaXRnNmpq?=
 =?utf-8?B?VHZZU0piME9KMVpiSWJJVHhURElwUnlzY05nNXFUYmc1bThLaDB3ampFM2FD?=
 =?utf-8?B?NHp4YUpKc2E0OVlFTnJWc0Z5aXNOUUR6ekkrWmxrL0xISEk4THFVMWdITVM3?=
 =?utf-8?B?Q1FqVTBrZmdKRWd0ZW0wNFNCWVdnd1lUb01wTklCcnNaQlJERGFmSW1TWU5G?=
 =?utf-8?B?YlB1V1NrSEJ4MzBxd3RqNlU5ejUxcGZyZ2p0aWJVRTlQQk96QU1BbFBaNUp4?=
 =?utf-8?B?UXVBOW5VNWlXcG1CdkpGUmM0NFNYbXkxdFgvUnJLVm5LY1RlMHQyVFE0Qyts?=
 =?utf-8?B?TW83aTdzVVd5aktBeEJvTnlHbVA5elRsdTFnSVZkZzA2T2JXdExNZFY4d3pI?=
 =?utf-8?B?cytleVZEZlZ0TVNFSllWOXZNdnIzTGlqWXY5VkFhS1NkeUQrNldIMUFlTm9L?=
 =?utf-8?B?QU85NWpTRVNzb0FLMzQ0bEw4WUJDQURVSGVUaHlqM2llTHdXbGF2eVZTRDhJ?=
 =?utf-8?B?Tlp6SFd1RGNJNDZxTS9UeHQ5VkU5L00wSzg5UXVZRlYyZk11dVFOY0x4VnpB?=
 =?utf-8?B?N3Nla0Y1NGxxMDZwbzhrbi9IZVNncnBCZFFvQVlPUjZVeitNQXRoZEM4VEdM?=
 =?utf-8?B?amI4WEg5V3ExS3dsSDgyb05Nank3a1lkOXYwc2wrSGRGY053dWhBNFJZZ2hr?=
 =?utf-8?B?NlU1L1BZbHN6QVJXSWlJUk5mRUo0S0F0QUlFZjVjS3pTM2NvemQzVmdFaG00?=
 =?utf-8?B?UkZ6dlBiT1cxcUJHeWlqeFRUSTl3dGMzSm9WcXltTlIvMjZsOHVMbTA3Nmd1?=
 =?utf-8?B?b2RUV2JhNVNLUHJZckN2RFpTVkQ4NmVZd2hIeDY0Mi8zNGhDdnBoUERtWUUx?=
 =?utf-8?B?UW5QN05xMm4ySVgyQjFscnNWUGxBQW1FTUVpTDg3NXdzeHdyZlNvUXNlQlJK?=
 =?utf-8?B?YzBmOVFPQUpvVVRjRDVtOHhhejJMQ0oyTks2UzJTREl2akRWb08zamxvVCsx?=
 =?utf-8?B?ZVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nokia-bell-labs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR07MB7984.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 527ce375-193c-40e0-7b40-08dcff6c20b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2024 20:38:24.9546
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H418LB4OVyTFJ2PYsBzxO1eEr+9tYMmrMZhVeHKT9jv3kMuar3KR9hgv0mpzQhf+Uz24FfkNdl9xCpahZHOPZsHsmWx5LdzyyUEMJOZEzQG7GzmcHbjo34GyJiexCcdu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR07MB8712

PkZyb206IEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT4gDQo+U2VudDogVGh1cnNk
YXksIE5vdmVtYmVyIDcsIDIwMjQgMjowMSBQTQ0KPlRvOiBDaGlhLVl1IENoYW5nIChOb2tpYSkg
PGNoaWEteXUuY2hhbmdAbm9raWEtYmVsbC1sYWJzLmNvbT4NCj5DYzogbmV0ZGV2QHZnZXIua2Vy
bmVsLm9yZzsgZHNhaGVybkBnbWFpbC5jb207IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGRzYWhlcm5A
a2VybmVsLm9yZzsgcGFiZW5pQHJlZGhhdC5jb207IGpvZWwuZ3JhbmFkb3NAa2VybmVsLm9yZzsg
a3ViYUBrZXJuZWwub3JnOyBhbmRyZXcrbmV0ZGV2QGx1bm4uY2g7IGhvcm1zQGtlcm5lbC5vcmc7
IHBhYmxvQG5ldGZpbHRlci5vcmc7IGthZGxlY0BuZXRmaWx0ZXIub3JnOyBuZXRmaWx0ZXItZGV2
ZWxAdmdlci5rZXJuZWwub3JnOyBjb3JldGVhbUBuZXRmaWx0ZXIub3JnOyBpakBrZXJuZWwub3Jn
OyBuY2FyZHdlbGxAZ29vZ2xlLmNvbTsgS29lbiBEZSBTY2hlcHBlciAoTm9raWEpIDxrb2VuLmRl
X3NjaGVwcGVyQG5va2lhLWJlbGwtbGFicy5jb20+OyBnLndoaXRlQGNhYmxlbGFicy5jb207IGlu
Z2VtYXIucy5qb2hhbnNzb25AZXJpY3Nzb24uY29tOyBtaXJqYS5rdWVobGV3aW5kQGVyaWNzc29u
LmNvbTsgY2hlc2hpcmVAYXBwbGUuY29tOyBycy5pZXRmQGdteC5hdDsgSmFzb25fTGl2aW5nb29k
QGNvbWNhc3QuY29tOyB2aWRoaV9nb2VsQGFwcGxlLmNvbQ0KPlN1YmplY3Q6IFJlOiBbUEFUQ0gg
djUgbmV0LW5leHQgMTMvMTNdIHRjcDogZmFzdCBwYXRoIGZ1bmN0aW9ucyBsYXRlcg0KPg0KPg0K
PkNBVVRJT046IFRoaXMgaXMgYW4gZXh0ZXJuYWwgZW1haWwuIFBsZWFzZSBiZSB2ZXJ5IGNhcmVm
dWwgd2hlbiBjbGlja2luZyBsaW5rcyBvciBvcGVuaW5nIGF0dGFjaG1lbnRzLiBTZWUgdGhlIFVS
TCBub2suaXQvZXh0IGZvciBhZGRpdGlvbmFsIGluZm9ybWF0aW9uLg0KPg0KPg0KPg0KPk9uIFR1
ZSwgTm92IDUsIDIwMjQgYXQgMTE6MDfigK9BTSA8Y2hpYS15dS5jaGFuZ0Bub2tpYS1iZWxsLWxh
YnMuY29tPiB3cm90ZToNCj4+DQo+PiBGcm9tOiBJbHBvIErDpHJ2aW5lbiA8aWpAa2VybmVsLm9y
Zz4NCj4+DQo+PiBUaGUgZm9sbG93aW5nIHBhdGNoIHdpbGwgdXNlIHRjcF9lY25fbW9kZV9hY2Nl
Y24oKSwgDQo+PiBUQ1BfQUNDRUNOX0NFUF9JTklUX09GRlNFVCwgVENQX0FDQ0VDTl9DRVBfQUNF
X01BU0sgaW4NCj4+IF9fdGNwX2Zhc3RfcGF0aF9vbigpIHRvIG1ha2UgbmV3IGZsYWcgZm9yIEFj
Y0VDTi4NCj4+DQo+PiBObyBmdW5jdGlvbmFsIGNoYW5nZXMuDQo+Pg0KPj4gU2lnbmVkLW9mZi1i
eTogSWxwbyBKw6RydmluZW4gPGlqQGtlcm5lbC5vcmc+DQo+PiBTaWduZWQtb2ZmLWJ5OiBDaGFp
LVl1IENoYW5nIDxjaGlhLXl1LmNoYW5nQG5va2lhLWJlbGwtbGFicy5jb20+DQo+DQo+SSBndWVz
cyB0aGlzIHBhdGNoIHNob3VsZCBub3QgbGFuZCBpbiB0aGlzIHNlcmllcywgYnV0IGluIHRoZSBm
b2xsb3dpbmcgb25lLg0KDQpIaSBFcmljLA0KDQoJSW5kZWVkLCBJIHdpbGwgbW92ZSB0aGlzIHBh
dGNoIHRvIHRoZSBmb2xsb3dpbmcgQWNjRUNOIHNlcmllcy4NCg0KQmVzdCByZWdhcmRzLA0KQ2hp
YS1ZdQ0K
