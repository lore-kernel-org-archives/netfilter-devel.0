Received: from EUR03-VI1-obe.outbound.protection.outlook.com (mail-vi1eur03on2055.outbound.protection.outlook.com [40.107.103.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA7ABE6C;
	Tue, 12 Nov 2024 02:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.103.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731377346; cv=fail; b=LqVPPriCm6Q/xYIM8AUIZhJYKzLcTRLnEK3VhhEr49KgyDn186GPwJ+S/dk59LbOx0rsUpl4Fijfirtay4CjwH/smrxA4jbzt6co9isZk6r4kVAOEtbWLKGBCfdYmMSZG3YG42B4JJeZbtEahNQGhZ0RFE5AWNHn0MPyZb+f8kc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731377346; c=relaxed/simple;
	bh=zgfApYYTfVdf9OtwW0KI8HiMMTCGvEMeksp80wSB9Ok=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cqcsT3G6WDIsa34LwIpvvGxT5B34zgxvuwzr5zDf4TJeBqi5rhNtOZu/WZe/VTh6hKtnOZ2wEww0pRmPNq9Oj4AxFq63GUOI/Rjeoa4m2zEcKT157l45EKyOZiD8i+xO6ohh09H7xQReG+XoXpUTn1THJa9Ddwpxu+sLX7UgGIU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com; spf=fail smtp.mailfrom=nokia-bell-labs.com; dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b=eIqDHwlk; arc=fail smtp.client-ip=40.107.103.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b="eIqDHwlk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wIT8Pz65o2gbUlqKUcNz+qr9BdGOIPQhAA0oGgnWyIvPIPP5ykp2HHaQjR4gFXXTVCsXN9LTMQooxIJqK/XWi95iF8HiZCuBNPIbd6Qv7uYqxFLZHfRxkWOxCjJm4V8rlrWFw7tovsM0mb0yo3f2GAOLpblmJkrZuVsiHxYMs9+klO3ihODsr2Smo1pWEjP0cp0vjQQ3YSICKOocu+IPhQlA/DKuOKP/n3ZPD7izsgGxCGgo4ZEQ5lmWByFiuDF9mPpvTRTxkeAspouoDcUoHK47QyWasl5yw9cIf5f3/Xy4WoNW2qDJI2KQP60yJKS5FyR5ydG9hoTtAoNmD5Ncnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zgfApYYTfVdf9OtwW0KI8HiMMTCGvEMeksp80wSB9Ok=;
 b=LC7bqsm5s+kkKI691RGfMdpS+lC1y5+mBuRRRzWn6VSTG7egEfMORjQgALhhIDZnlAjllb4P+zjyU7eDVXdQtausKIUNmQLe3N75MjAD1Z0uyTsAJ9af5w5gSADDNUKjgNvyVicC1aFh+0zEK39hNy8OwPHmdXQmn4X6zwS7uFO+c1AQrnv6qGlEHqjwbbJUDbI82inE4S1PG7+VITloTLaH8sYLnAdp7QIsqEeUgpj5aOAXd6GDcq67gz9x1ReBE6JZJF8YlKDV29gSJxG58MXLRAvkmXa1VtUGsQ6mjV47Y79GrMjeYA0Ly9gO/W30ja6ivFlUNrVC7UqwzwjdnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia-bell-labs.com; dmarc=pass action=none
 header.from=nokia-bell-labs.com; dkim=pass header.d=nokia-bell-labs.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia-bell-labs.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zgfApYYTfVdf9OtwW0KI8HiMMTCGvEMeksp80wSB9Ok=;
 b=eIqDHwlk0sgHk6spFyiF3MdkvFRYEGbmAp1HJVzaAkRonVYtJ2/PJT/JvVd0oqC6q7OBVz5+FQc0oa1oH+dp/1vIxmMdldH9tJEnSJC6iZ33tugadwW1YfRmajI/oPToGllMa92Gy3haalt6Xq+0frqYxLUewWedw9UShTln+wKl+lVRu7mSS/VnqJjfYgUskBMkW7Jh+DWQMq8IYd86LgW+f4jQywJS+XaLsYIaWIj05HIgSKC9KqFd68PT50APRch11+nNeNmovcVK14hsjSNaCEloHC0Afg00vUXsQs5VEC+7T5EUaPjY1Ld79pOII+IwStnuVxsiPGKyM05quw==
Received: from PAXPR07MB7984.eurprd07.prod.outlook.com (2603:10a6:102:133::12)
 by AS2PR07MB9027.eurprd07.prod.outlook.com (2603:10a6:20b:557::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Tue, 12 Nov
 2024 02:09:00 +0000
Received: from PAXPR07MB7984.eurprd07.prod.outlook.com
 ([fe80::b7f8:dc0a:7e8d:56]) by PAXPR07MB7984.eurprd07.prod.outlook.com
 ([fe80::b7f8:dc0a:7e8d:56%6]) with mapi id 15.20.8137.027; Tue, 12 Nov 2024
 02:09:00 +0000
From: "Chia-Yu Chang (Nokia)" <chia-yu.chang@nokia-bell-labs.com>
To: =?utf-8?B?SWxwbyBKw6RydmluZW4=?= <ij@kernel.org>, Eric Dumazet
	<edumazet@google.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "dsahern@gmail.com"
	<dsahern@gmail.com>, "davem@davemloft.net" <davem@davemloft.net>,
	"dsahern@kernel.org" <dsahern@kernel.org>, "pabeni@redhat.com"
	<pabeni@redhat.com>, "joel.granados@kernel.org" <joel.granados@kernel.org>,
	"kuba@kernel.org" <kuba@kernel.org>, "andrew+netdev@lunn.ch"
	<andrew+netdev@lunn.ch>, "horms@kernel.org" <horms@kernel.org>,
	"pablo@netfilter.org" <pablo@netfilter.org>, "kadlec@netfilter.org"
	<kadlec@netfilter.org>, "netfilter-devel@vger.kernel.org"
	<netfilter-devel@vger.kernel.org>, "coreteam@netfilter.org"
	<coreteam@netfilter.org>, "ncardwell@google.com" <ncardwell@google.com>,
	"Koen De Schepper (Nokia)" <koen.de_schepper@nokia-bell-labs.com>,
	"g.white@cablelabs.com" <g.white@cablelabs.com>,
	"ingemar.s.johansson@ericsson.com" <ingemar.s.johansson@ericsson.com>,
	"mirja.kuehlewind@ericsson.com" <mirja.kuehlewind@ericsson.com>,
	"cheshire@apple.com" <cheshire@apple.com>, "rs.ietf@gmx.at" <rs.ietf@gmx.at>,
	"Jason_Livingood@comcast.com" <Jason_Livingood@comcast.com>,
	"vidhi_goel@apple.com" <vidhi_goel@apple.com>
Subject: RE: [PATCH v5 net-next 09/13] gro: prevent ACE field corruption &
 better AccECN handling
Thread-Topic: [PATCH v5 net-next 09/13] gro: prevent ACE field corruption &
 better AccECN handling
Thread-Index: AQHbL2p+UUDyUHFwFU2s2ioOY+VE4LKrxcEAgABxwwCABq9cQA==
Date: Tue, 12 Nov 2024 02:09:00 +0000
Message-ID:
 <PAXPR07MB7984717B290B1BC250429D2BA3592@PAXPR07MB7984.eurprd07.prod.outlook.com>
References: <20241105100647.117346-1-chia-yu.chang@nokia-bell-labs.com>
 <20241105100647.117346-10-chia-yu.chang@nokia-bell-labs.com>
 <CANn89i+9USaOthY3yaJPT-cbfAcP0re2bbGbWU7SqOSYEW2CMw@mail.gmail.com>
 <37429ace-59c0-21d2-bcc8-54033794e789@kernel.org>
In-Reply-To: <37429ace-59c0-21d2-bcc8-54033794e789@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nokia-bell-labs.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR07MB7984:EE_|AS2PR07MB9027:EE_
x-ms-office365-filtering-correlation-id: 6109db5a-ec99-41c8-c9cd-08dd02bef913
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|7416014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?WW4wSngyOXBTM25zNjRlZmVlOURsSmVYcWRObTlGWThaNUpPY1lVNU55enY4?=
 =?utf-8?B?ZXJiZTljTk1rR2NwWW5YOGRvanpxb3ZpTVFKTVVQUFJiWTZHWFNVK0ZqUXRF?=
 =?utf-8?B?VmlNTXRRRlk0Q0RwaGh0ZnNINGxSWW1kYTRWSStPZ1ZIeWhNRmpQT0tqVk9F?=
 =?utf-8?B?cmhDUEJ0UGJ4Q25JMUMvNUJFck9WVGtDa3k0cWpPNUFZbDY1YnlTd1lSQXBH?=
 =?utf-8?B?L2syTERHZnlYTDNLVWdLOG8wWGJnVVpJay9Ub2gwb0Z4TXVFVzRNYXl1VWVv?=
 =?utf-8?B?TzZvNC9MTURKcVM0UnNCZG04UFp5dUJUdHNKelZ5ZTRTN2pFMEsxMktuVWIy?=
 =?utf-8?B?WGdHMlNSaDNIYWdVc25hZXRsYU1GNVlRVXlyRWZ1dFRPVlM2bURHTU1qKzhO?=
 =?utf-8?B?c2tkQlJQN1FDSHFDNjlOYlloalNadTdHb1o4eVRzRGdFYWY0bXBBMkp0cFBD?=
 =?utf-8?B?cWRGYUMvUmpJUkRVQS9FMmZtRUwzbGFTcUx0K0hZbnpuclhvV2tBUUI0azRt?=
 =?utf-8?B?NTlIN3U5ZjAwM1JzcHp6d2NVY012Yk5zcGhRTFB1ZkMrTFJ1K2M3SEo1cTRJ?=
 =?utf-8?B?M2dURjRpTnFVZzFYSFlpRXVqRHpReWhEOEhvbnFuMml5RUt2aVV4Sjl2aTBO?=
 =?utf-8?B?YjR3a29EbE91MGQvZi9XYzBEbDFDTkJzWjBBZVZ4eVBZaldvcWJTV2RudC8y?=
 =?utf-8?B?ckdvS2RqbFBWUnpWNkliWUkwR2xNeVVKbUJYVzdhOCtlWHphNHJ5N0xqQ0lo?=
 =?utf-8?B?Z2JESVoveHpLTmpEdWtWd1l1ZDdJUVMvdUZYT2tueS84N292SlZNaVA0d0hs?=
 =?utf-8?B?eUxqVm02b2ZWRVNDdEFpZ0tveENIYnExT2FMd2NlOG5iSUF1YVBtWWxsM05E?=
 =?utf-8?B?NHVVa1oyZXpnZ0lYRC84RFYxa24xeU9PLzF2OFBnMjlDbFpzVURhcUxwUHJK?=
 =?utf-8?B?eXJ4UitacUpHTVFrUUw2TG1EU216MGtsZlI0a1Rmcnc4Q3p4WW16SDFVbkJy?=
 =?utf-8?B?a2FMK3ZGdzh6Ull5Vnl1QmU0UVJnZEQ5cUZGWnRlSXFLejlweVhJNTFaNS91?=
 =?utf-8?B?Q2FnRTl1VFEvL1RldmJlVXN6alhrV1V6dDFBMm9NL1RWeTJEeFBJQlMwSjFa?=
 =?utf-8?B?Z0VkL0djYTRkM3VWMkRtQWc4ZHFVd1VTd1ZsdndET1dmQnUxaDRwVVljRTBj?=
 =?utf-8?B?MHkzSWNWYXFWU1dCRzFPQWdqeEtrYkgyTDlXVHJWY0wzRVAzZlJTMmlPWEN0?=
 =?utf-8?B?emJkU3piV3VZeWtwSW5NaEJGc3RvSEVtaEtaWUdQNlJhTHZ2ZGkzS3hGOElr?=
 =?utf-8?B?WGxJWUVNSFBWdENnQU43Z3dTbWNiZnJIc3pOdjc5Y0o1LzF0bmYyTGVNMUlu?=
 =?utf-8?B?VnM2ZTYwOGFBNWtOa2V5Q0hQMHlHWFFDb3A4TjdMWjJZVE9nRTJFaXJiZEFS?=
 =?utf-8?B?bVVZYktqSUEvdHJ5dkY2dGUwOHRCMDA5ZVFDQXh5S3grSDVJQno5RWJMUEEz?=
 =?utf-8?B?R2VmUXR4ek9MNHl5OEFjMkx3UHJsTGV0dEZuNWVnSVdBRjltcXdCbWc3T3Mw?=
 =?utf-8?B?dVRTRG1XS3g4Y0Nkem1MMmt4TmxtOHNHcXVCUWpKTHA0TWlYWFVtVnNteU1O?=
 =?utf-8?B?Y2RtZmcvZ0FiWkc3V0VoZXdGeDRZQ0VENTJjendWdjJsUVBLNXFKQ09LRStJ?=
 =?utf-8?B?RXVpM09vZDlzQnMzRTRzMWIzd2F3b1dCSDNaTUxYMDNOaXNMTlZvd09Lc2Zv?=
 =?utf-8?Q?YQe7hxcd3n1Xem/JZpNoT3nawLvGaSBPRUylCHY?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR07MB7984.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UDljUXF3bTdtVFc5bzAwK0lNNUNSOVlKa0d0eVFrdmlTaFF2aXlKZk02dkpk?=
 =?utf-8?B?Q3pPcHBrSGlPUmtGK3EyMnhrWUhFZUsvZEx4eVNqMDRQdUsxUkxUYk1SaUNa?=
 =?utf-8?B?bmxjeWZUU2g5M2RKeklneEEydUtEL0FwNzB2UWZnWXU1YzhmblpNSzVncHZj?=
 =?utf-8?B?S3VLYXYvY2l0cmhrNlNPNlVZSTROM0Z0NmZWVy92Q09NYWQxS3duOHkwMFVu?=
 =?utf-8?B?YzBxdUJGMzJRei9CSEw2eTFTQVkwbFU4ZDVvVk5OOHRzY3d1YkdmQkJ0NHFU?=
 =?utf-8?B?ZTdJdXJoVUlkL1RCaVhkRXlkZTZIZXdLSXZVTEJRd1UvNVUycHZwSTRFb2Jz?=
 =?utf-8?B?MXcrWUNmS3M2MWJmSTc1eEhyM3JqVmNRM1ZPTjhtWmU5NG5YQWZkQ3hGMS91?=
 =?utf-8?B?ZmRaNHhkU3llODNVSFJ6dzdZYXhUYzJlSGRlVjBCRzZNdjNkRXlFSldTTVBz?=
 =?utf-8?B?bjZnaGJ5NEdCVkRRZGc1Z2VuZUcvS0RHY1hDUDBJRmlmdGV6cC9waEFRVDll?=
 =?utf-8?B?cTVKaEl0SkpidzhxcGdXUFN3bWhuWUl6Vlg1bHVVVitpNEN6MnVSSTlWczBY?=
 =?utf-8?B?RDNMY1dIaStwWEtwSDJSQWhuVDJEdHk0d1RVbVBWejBSMFpEbWptdlpHcThn?=
 =?utf-8?B?RGY5aGtEei9Sa2QxNVFwcTlLdHBTZnJyVkNQMzYwWHc1UG9Wd3pUMXlWdVFQ?=
 =?utf-8?B?eHRmSFMzZDBvbEtWK3lhbU56RTBsd1hWYzZFVDB4NzVocjd1YWRpOUlVeHVj?=
 =?utf-8?B?Wi91eVpZWnBPQnpQM3J6MHVNMisyVmcvbDdzamQybXpSWVQySms3RW12Z1U5?=
 =?utf-8?B?L2s5UldhUTlZMGlrb3kzUWtsNnVEeGQ2UEU3S2Z5SkMyTWl1WUlBbi9qZWlY?=
 =?utf-8?B?NXV5Z0JGT0k3bjE5YmgrbDh0Skc2Z1lTTWJrTWtXNDFhaFpWR3o2MUJlTWJD?=
 =?utf-8?B?YUZwb3ZvQklpRmxmRTVhNFg1dmRxb3Y4NmJtRWZHV1h3TmJrSDVoR0FqcnhK?=
 =?utf-8?B?ZlRCcUNaYmphZEN4VGdyanRKaExtUm5KOUlzSFpHdVBMc0phT3cxYS9jQmRC?=
 =?utf-8?B?K29vaDRuajNnQ1JHU2pkRXZBSnVsbklpbWJOKzR5QUdGOW5jM1F5SVQ0QkRh?=
 =?utf-8?B?eHNST2U3RXNmT3h1aTFrN3lrQ3hSYU5NTmVQbDB4UjlsTm5wOUlrTE9ia1hT?=
 =?utf-8?B?SFdMMk1TZFVwaC96Y1k5WWRHV0JiUU1QYkt5Y0pOZlR0WnFiMW5wQUcyZll1?=
 =?utf-8?B?bzNGZlB0bVNpRXJvTDdmNkNGcDNRU0s3RC9sUWxCbmJTRUJiL2xhVUJlK3E2?=
 =?utf-8?B?QURkK28wMXVUMjE2WXhyVUdQdURJTTFMVzR0V1FPNUMzVm4wU085UFdmTkZx?=
 =?utf-8?B?Zm84WmhwWUVSN3c2NXVUTE82MnF0MEliNmVIMG5yaGNrV081QWZueWwxdTJ4?=
 =?utf-8?B?b3lYdTR5eHpTNE5ObHpoQ0Vyd3lhU2dyTmZreU9DejhCczJGUHhUZEQ5TldU?=
 =?utf-8?B?dFhPVmpacnNUSUQ5bDJBQlpabXlUZVNrZlhqQU1rLzNBdVhLaEJJc3JUeHNw?=
 =?utf-8?B?czEwNHQzcldtZVExYy9zR2RSRVlMNXYvdUdMSGVyS3lPNlZ2S0R6V3RNRnV5?=
 =?utf-8?B?MS9VWmdrU0dtSjZRUVA0aEdEVHZWT0RvZ3pJWUsyWm1IdkFVVzZzZDhTNzNF?=
 =?utf-8?B?RUNEcEVrclRUenRaTjBTZG5KRDBqb0dVTXdYTWNvQ2kwWkVIQVJSeUpjTDZG?=
 =?utf-8?B?eko5RFM3WDZrbEZWZ1hFZmdPYUZHK2lPY1ZTK0xzUTVBejNFQ1g0Q0FyUzdr?=
 =?utf-8?B?OG4zNnAwMklVMlI0RHY0c2RnaUZ4RUFldDJOeFZZNXdhNXh2NkZQOTlPQ0NI?=
 =?utf-8?B?YVErMlExeTNId1k5NzhtUDhzK0pHdnVNYVMvZ3NFeU5iMEc1ak5mN0VQUVVD?=
 =?utf-8?B?K2djdjlVSjdqZTN1RGtUR1B2Mm1FOWJHYzZJRUk5ZjNyeWxFTFJUOGY2anNO?=
 =?utf-8?B?N0dEWFBpcHpkUGUxZ2s2RXRsSkN2R0gyejB4OVVma09tekRnTmZndzF5dFoz?=
 =?utf-8?B?MUowQnl2dDIyaml6ODlUZHVrODVkbEpXMS9TTTJmdlI5dVBnTkVtcUJ1dDlK?=
 =?utf-8?B?bTFNNzhFRzdzVVZRZ1B6TTdLZXJqY2xIY3dDdGFFdlE5cmNkdXlwM0IrdTA4?=
 =?utf-8?B?UWc9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6109db5a-ec99-41c8-c9cd-08dd02bef913
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2024 02:09:00.2280
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c+7tIKAzwwsC00wnsw/VegQ7F42lxmLuljmVTLLjsyg85h20IlJBcmOWEVRIbAX8fJH8f5DRb7BPwfQ1hEIAM+HapKqw1C0YS6FepkPrm3XlUZVFKeP+ok0/sFfjfxy5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR07MB9027

PkZyb206IElscG8gSsOkcnZpbmVuIDxpakBrZXJuZWwub3JnPiANCj5TZW50OiBUaHVyc2RheSwg
Tm92ZW1iZXIgNywgMjAyNCA4OjI4IFBNDQo+VG86IEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRAZ29v
Z2xlLmNvbT4NCj5DYzogQ2hpYS1ZdSBDaGFuZyAoTm9raWEpIDxjaGlhLXl1LmNoYW5nQG5va2lh
LWJlbGwtbGFicy5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBkc2FoZXJuQGdtYWlsLmNv
bTsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgZHNhaGVybkBrZXJuZWwub3JnOyBwYWJlbmlAcmVkaGF0
LmNvbTsgam9lbC5ncmFuYWRvc0BrZXJuZWwub3JnOyBrdWJhQGtlcm5lbC5vcmc7IGFuZHJldytu
ZXRkZXZAbHVubi5jaDsgaG9ybXNAa2VybmVsLm9yZzsgcGFibG9AbmV0ZmlsdGVyLm9yZzsga2Fk
bGVjQG5ldGZpbHRlci5vcmc7IG5ldGZpbHRlci1kZXZlbEB2Z2VyLmtlcm5lbC5vcmc7IGNvcmV0
ZWFtQG5ldGZpbHRlci5vcmc7IG5jYXJkd2VsbEBnb29nbGUuY29tOyBLb2VuIERlIFNjaGVwcGVy
IChOb2tpYSkgPGtvZW4uZGVfc2NoZXBwZXJAbm9raWEtYmVsbC1sYWJzLmNvbT47IGcud2hpdGVA
Y2FibGVsYWJzLmNvbTsgaW5nZW1hci5zLmpvaGFuc3NvbkBlcmljc3Nvbi5jb207IG1pcmphLmt1
ZWhsZXdpbmRAZXJpY3Nzb24uY29tOyBjaGVzaGlyZUBhcHBsZS5jb207IHJzLmlldGZAZ214LmF0
OyBKYXNvbl9MaXZpbmdvb2RAY29tY2FzdC5jb207IHZpZGhpX2dvZWxAYXBwbGUuY29tDQo+U3Vi
amVjdDogUmU6IFtQQVRDSCB2NSBuZXQtbmV4dCAwOS8xM10gZ3JvOiBwcmV2ZW50IEFDRSBmaWVs
ZCBjb3JydXB0aW9uICYgYmV0dGVyIEFjY0VDTiBoYW5kbGluZw0KPg0KPg0KPkNBVVRJT046IFRo
aXMgaXMgYW4gZXh0ZXJuYWwgZW1haWwuIFBsZWFzZSBiZSB2ZXJ5IGNhcmVmdWwgd2hlbiBjbGlj
a2luZyBsaW5rcyBvciBvcGVuaW5nIGF0dGFjaG1lbnRzLiBTZWUgdGhlIFVSTCBub2suaXQvZXh0
IGZvciBhZGRpdGlvbmFsIGluZm9ybWF0aW9uLg0KPg0KPg0KPg0KPk9uIFRodSwgNyBOb3YgMjAy
NCwgRXJpYyBEdW1hemV0IHdyb3RlOg0KPg0KPj5PbiBUdWUsIE5vdiA1LCAyMDI0IGF0IDExOjA3
4oCvQU0gPGNoaWEteXUuY2hhbmdAbm9raWEtYmVsbC1sYWJzLmNvbT4gd3JvdGU6DQo+Pj4NCj4+
PiBGcm9tOiBJbHBvIErDpHJ2aW5lbiA8aWpAa2VybmVsLm9yZz4NCj4+Pg0KPj4+IFRoZXJlIGFy
ZSBpbXBvcnRhbnQgZGlmZmVyZW5jZXMgaW4gaG93IHRoZSBDV1IgZmllbGQgYmVoYXZlcyBpbiAN
Cj4+PiBSRkMzMTY4IGFuZCBBY2NFQ04uIFdpdGggQWNjRUNOLCBDV1IgZmxhZyBpcyBwYXJ0IG9m
IHRoZSBBQ0UgY291bnRlciANCj4+PiBhbmQgaXRzIGNoYW5nZXMgYXJlIGltcG9ydGFudCBzbyBh
ZGp1c3QgdGhlIGZsYWdzIGNoYW5nZWQgbWFzayANCj4+PiBhY2NvcmRpbmdseS4NCj4+Pg0KPj4+
IEFsc28sIGlmIENXUiBpcyB0aGVyZSwgc2V0IHRoZSBBY2N1cmF0ZSBFQ04gR1NPIGZsYWcgdG8g
YXZvaWQgDQo+Pj4gY29ycnVwdGluZyBDV1IgZmxhZyBzb21ld2hlcmUuDQo+Pj4NCj4+PiBTaWdu
ZWQtb2ZmLWJ5OiBJbHBvIErDpHJ2aW5lbiA8aWpAa2VybmVsLm9yZz4NCj4+PiBTaWduZWQtb2Zm
LWJ5OiBDaGlhLVl1IENoYW5nIDxjaGlhLXl1LmNoYW5nQG5va2lhLWJlbGwtbGFicy5jb20+DQo+
Pj4gLS0tDQo+Pj4gIG5ldC9pcHY0L3RjcF9vZmZsb2FkLmMgfCA0ICsrLS0NCj4+PiAgMSBmaWxl
IGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4+Pg0KPj4+IGRpZmYg
LS1naXQgYS9uZXQvaXB2NC90Y3Bfb2ZmbG9hZC5jIGIvbmV0L2lwdjQvdGNwX29mZmxvYWQuYyBp
bmRleCANCj4+PiAwYjA1ZjMwZTllNWYuLmY1OTc2MmQ4OGMzOCAxMDA2NDQNCj4+PiAtLS0gYS9u
ZXQvaXB2NC90Y3Bfb2ZmbG9hZC5jDQo+Pj4gKysrIGIvbmV0L2lwdjQvdGNwX29mZmxvYWQuYw0K
Pj4+IEBAIC0zMjksNyArMzI5LDcgQEAgc3RydWN0IHNrX2J1ZmYgKnRjcF9ncm9fcmVjZWl2ZShz
dHJ1Y3QgbGlzdF9oZWFkICpoZWFkLCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiLA0KPj4+ICAgICAgICAg
dGgyID0gdGNwX2hkcihwKTsNCj4+PiAgICAgICAgIGZsdXNoID0gKF9fZm9yY2UgaW50KShmbGFn
cyAmIFRDUF9GTEFHX0NXUik7DQo+Pj4gICAgICAgICBmbHVzaCB8PSAoX19mb3JjZSBpbnQpKChm
bGFncyBeIHRjcF9mbGFnX3dvcmQodGgyKSkgJg0KPj4+IC0gICAgICAgICAgICAgICAgIH4oVENQ
X0ZMQUdfQ1dSIHwgVENQX0ZMQUdfRklOIHwgVENQX0ZMQUdfUFNIKSk7DQo+Pj4gKyAgICAgICAg
ICAgICAgICAgfihUQ1BfRkxBR19GSU4gfCBUQ1BfRkxBR19QU0gpKTsNCj4+PiAgICAgICAgIGZs
dXNoIHw9IChfX2ZvcmNlIGludCkodGgtPmFja19zZXEgXiB0aDItPmFja19zZXEpOw0KPj4+ICAg
ICAgICAgZm9yIChpID0gc2l6ZW9mKCp0aCk7IGkgPCB0aGxlbjsgaSArPSA0KQ0KPj4+ICAgICAg
ICAgICAgICAgICBmbHVzaCB8PSAqKHUzMiAqKSgodTggKil0aCArIGkpIF4gQEAgLTQwNSw3ICs0
MDUsNyANCj4+PiBAQCB2b2lkIHRjcF9ncm9fY29tcGxldGUoc3RydWN0IHNrX2J1ZmYgKnNrYikN
Cj4+PiAgICAgICAgIHNoaW5mby0+Z3NvX3NlZ3MgPSBOQVBJX0dST19DQihza2IpLT5jb3VudDsN
Cj4+Pg0KPj4+ICAgICAgICAgaWYgKHRoLT5jd3IpDQo+Pj4gLSAgICAgICAgICAgICAgIHNoaW5m
by0+Z3NvX3R5cGUgfD0gU0tCX0dTT19UQ1BfRUNOOw0KPj4+ICsgICAgICAgICAgICAgICBzaGlu
Zm8tPmdzb190eXBlIHw9IFNLQl9HU09fVENQX0FDQ0VDTjsNCj4+PiAgfQ0KPj4+ICBFWFBPUlRf
U1lNQk9MKHRjcF9ncm9fY29tcGxldGUpOw0KPj4+DQo+Pg0KPj4gSSBkbyBub3QgcmVhbGx5IHVu
ZGVyc3RhbmQgdGhpcyBwYXRjaC4gSG93IGEgR1JPIGVuZ2luZSBjYW4ga25vdyB3aGljaCANCj4+
IEVDTiB2YXJpYW50IHRoZSBwZWVycyBhcmUgdXNpbmcgPw0KPg0KPkhpIEVyaWMsDQo+DQo+VGhh
bmtzIGZvciB0YWtpbmcgYSBsb29rLg0KPg0KPkdSTyBkb2Vzbid0IGtub3cuIFNldHRpbmcgU0tC
X0dTT19UQ1BfRUNOIGluIGNhc2Ugb2Ygbm90IGtub3dpbmcgY2FuIHJlc3VsdCBpbiBoZWFkZXIg
Y2hhbmdlIHRoYXQgY29ycnVwdHMgQUNFIGZpZWxkLiBUaHVzLCBHUk8gaGFzIHRvIGFzc3VtZSB0
aGUgUkZDMzE2OCBDV1Igb2ZmbG9hZGluZyB0cmljayBjYW5ub3QgYmUgdXNlZCBhbnltb3JlICh1
bmxlc3MgaXQgdHJhY2tzIHRoZSBjb25uZWN0aW9uIGFuZCBrbm93cyB0aGUgYml0cyBhcmUgdXNl
ZCBmb3IgUkZDMzE2OCB3aGljaCBpcyBzb21ldGhpbmcgbm9ib2R5IGlzIGdvaW5nIHRvIGRvKS4N
Cj4NCj5UaGUgbWFpbiBwb2ludCBvZiBTS0JfR1NPX1RDUF9BQ0NFQ04gaXMgdG8gcHJldmVudCBT
S0JfR1NPX1RDUF9FQ04gb3IgTkVUSUZfRl9UU09fRUNOIG9mZmxvYWRpbmcgdG8gYmUgdXNlZCBm
b3IgdGhlIHNrYiBhcyBpdCB3b3VsZCBjb3JydXB0IEFDRSBmaWVsZCB2YWx1ZS4NCg0KSGkgRXJp
YyBhbmQgSWxwbywNCg0KRnJvbSBteSB1bmRlcnN0YW5kaW5nIG9mIGFub3RoZXIgZW1haWwgdGhy
ZWFkIChwYXRjaCAwOC8xMyksIGl0IHNlZW1zIHRoZSBjb25jbHVzaW9ucyB0aGF0IFNLQl9HU09f
VENQX0FDQ0VDTiB3aWxsIHN0aWxsIGJlIG5lZWRlZC4NCg0KPg0KPlNLQl9HU09fVENQX0FDQ0VD
TiBkb2Vzbid0IGFsbG93IENXUiBiaXRzIGNoYW5nZSB3aXRoaW4gYSBzdXBlci1za2IgYnV0IHRo
ZSBzYW1lIENXUiBmbGFnIHNob3VsZCBiZSByZXBlYXRlZCBmb3IgYWxsIHNlZ21lbnRzLiBJbiBh
IHNlbnNlLCBpdCdzIHNpbXBsZXIgdGhhbiBSRkMzMTY4IG9mZmxvYWRpbmcuDQo+DQo+PiBTS0Jf
R1NPX1RDUF9FQ04gaXMgYWxzbyB1c2VkIGZyb20gb3RoZXIgcG9pbnRzLCB3aGF0IGlzIHlvdXIg
cGxhbiA/DQo+Pg0KPj4gZ2l0IGdyZXAgLW4gU0tCX0dTT19UQ1BfRUNODQo+PiBkcml2ZXJzL25l
dC9ldGhlcm5ldC9oaXNpbGljb24vaG5zMy9obnMzX2VuZXQuYzozODg4Og0KPj4gc2tiX3NoaW5m
byhza2IpLT5nc29fdHlwZSB8PSBTS0JfR1NPX1RDUF9FQ047DQo+PiBkcml2ZXJzL25ldC9ldGhl
cm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fcnguYzoxMjkxOg0KPj4gc2tiX3NoaW5mbyhza2Ip
LT5nc29fdHlwZSB8PSBTS0JfR1NPX1RDUF9FQ047DQo+PiBkcml2ZXJzL25ldC9ldGhlcm5ldC9t
ZWxsYW5veC9tbHg1L2NvcmUvZW5fcnguYzoxMzEyOg0KPj4gc2tiX3NoaW5mbyhza2IpLT5nc29f
dHlwZSB8PSBTS0JfR1NPX1RDUF9FQ047DQo+DQo+VGhlc2UgbG9va2VkIGxpa2UgdGhleSBzaG91
bGQgYmUganVzdCBjaGFuZ2VkIHRvIHNldCBTS0JfR1NPX1RDUF9BQ0NFQ04gaW5zdGVhZC4NCg0K
SSBhZ3JlZSB3aXRoIHRoZXNlIGNoYW5nZXMgYW5kIHdpbGwgYXBwbHkgdGhlbSBpbiB0aGUgbmV4
dCB2ZXJzaW9uLg0KDQo+DQo+SSBkb24ndCBhbnltb3JlIHJlY2FsbCB3aHkgSSBkaWRuJ3QgY2hh
bmdlIHRob3NlIHdoZW4gSSBtYWRlIHRoaXMgcGF0Y2ggbG9uZyB0aW1lIGFnbywgcGVyaGFwcyBp
dCB3YXMganVzdCBhbiBvdmVyc2lnaHQgb3IgdGhpbmdzIGhhdmUgY2hhbmdlZCBzb21laG93IHNp
bmNlIHRoZW4uDQo+DQo+PiBpbmNsdWRlL2xpbnV4L25ldGRldmljZS5oOjUwNjE6IEJVSUxEX0JV
R19PTihTS0JfR1NPX1RDUF9FQ04gIT0gDQo+PiAoTkVUSUZfRl9UU09fRUNOID4+IE5FVElGX0Zf
R1NPX1NISUZUKSk7DQo+PiBpbmNsdWRlL2xpbnV4L3NrYnVmZi5oOjY2NDogICAgIFNLQl9HU09f
VENQX0VDTiA9IDEgPDwgMiwNCj4NCj5Ob3QgcmVsZXZhbnQuDQo+DQo+PiBpbmNsdWRlL2xpbnV4
L3ZpcnRpb19uZXQuaDo4ODogICAgICAgICAgICAgICAgICBnc29fdHlwZSB8PSBTS0JfR1NPX1RD
UF9FQ047DQo+PiBpbmNsdWRlL2xpbnV4L3ZpcnRpb19uZXQuaDoxNjE6ICAgICAgICAgc3dpdGNo
IChnc29fdHlwZSAmIH5TS0JfR1NPX1RDUF9FQ04pIHsNCj4+IGluY2x1ZGUvbGludXgvdmlydGlv
X25ldC5oOjIyNjogICAgICAgICBpZiAoc2luZm8tPmdzb190eXBlICYgU0tCX0dTT19UQ1BfRUNO
KQ0KPg0KPlRoZXNlIG5lZWQgdG8gYmUgbG9va2VkIGZ1cnRoZXIgd2hhdCdzIGdvaW5nIG9uIGFz
IFVBUEkgaXMgYWxzbyBpbnZvbHZlZCBoZXJlLg0KDQpJIGhhZCBhIGxvb2sgYXQgdGhlc2UgcGFy
dHMsIGFuZCBvbmx5IHRoZSAxc3QgYW5kIDNyZCBvbmVzIGFyZSByZWxldmFudC4NClJlbGF0ZWQg
dG8gdGhlIDFzdCBvbmUsIEkgcHJvcG9zZSB0byBjaGFuZ2UNCmZyb20NCg0KICAgICAgICAgICAg
ICAgIGlmIChoZHItPmdzb190eXBlICYgVklSVElPX05FVF9IRFJfR1NPX0VDTikNCiAgICAgICAg
ICAgICAgICAgICAgICAgIGdzb190eXBlIHw9IFNLQl9HU09fVENQX0VDTjsNCg0KdG8NCg0KICAg
ICAgICAgICAgICAgIGlmIChoZHItPmdzb190eXBlICYgVklSVElPX05FVF9IRFJfR1NPX0VDTikN
CiAgICAgICAgICAgICAgICAgICAgICAgIGdzb190eXBlIHw9IFNLQl9HU09fVENQX0FDQ0VDTjsN
Cg0KVGhlIHJlYXNvbiBiZWhpbmQgdGhpcyBwcm9wb3NlZCBjaGFuZ2UgaXMgc2ltaWxhciBhcyB0
aGUgYWJvdmUgY2hhbmdlcyBpbiBlbl9yeC5jLg0KDQpGb3IgdGhlIDNyZCBvbmUsIEkgc3VnZ2Vz
dCB0byBjaGFuZ2UgZnJvbQ0KDQogICAgICAgICAgICAgICAgaWYgKHNpbmZvLT5nc29fdHlwZSAm
IFNLQl9HU09fVENQX0VDTikNCiAgICAgICAgICAgICAgICAgICAgICAgIGhkci0+Z3NvX3R5cGUg
fD0gVklSVElPX05FVF9IRFJfR1NPX0VDTjsNCg0KdG8NCg0KICAgICAgICAgICAgICAgIGlmIChz
aW5mby0+Z3NvX3R5cGUgJiAoU0tCX0dTT19UQ1BfRUNOIHwgU0tCX0dTT19UQ1BfQUNDRUNOKSkN
CiAgICAgICAgICAgICAgICAgICAgICAgIGhkci0+Z3NvX3R5cGUgfD0gVklSVElPX05FVF9IRFJf
R1NPX0VDTjsNCg0KVGhpcyBwcm9wb3NlZCBjaGFuZ2UgaXMgYmVjYXVzZSBWSVJUSU9fTkVUX0hE
Ul9HU09fRUNOIG11c3QgYmUgc2V0IHRvIGFsbG93IFRDUCBwYWNrZXRzIHJlcXVpcmluZyBzZWdt
ZW50YXRpb24gb2ZmbG9hZCB3aGljaCBoYXZlIEVDTiBiaXQgc2V0Lg0KU28sIG5vIG1hdHRlciB3
aGV0aGVyIHNrYiBnc29fdHlwZSBoYXZlIEdTT19UQ1BfRUNOIGZsYWcgb3IgR1NPX1RDUF9BQ0NF
Q04gZmxhZywgdGhlIGNvcnJlc3BvbmRpbmcgaGRyIGdzb190eXBlIHNoYWxsIGJlIHNldC4NCg0K
QnV0LCBJIHdvbmRlciB3aGF0IHdvdWxkIHRoZSBkcml2ZXIgZG8gd2hlbiB3aXRoIFZJUlRJT19O
RVRfSERSX0dTT19FQ04gZmxhZy4gV2lsbCBpdCBjb3JydXB0cyBDV1Igb3Igbm90Pw0KDQotLQ0K
Q2hpYS1ZdQ0KDQo+DQo+PiBuZXQvaXB2NC90Y3Bfb2ZmbG9hZC5jOjQwNDogICAgICAgICAgICAg
c2hpbmZvLT5nc29fdHlwZSB8PSBTS0JfR1NPX1RDUF9FQ047DQo+DQo+VGhpcyB3YXMgY2hhbmdl
ZCBhYm92ZS4gOi0pDQo+DQo+PiBuZXQvaXB2NC90Y3Bfb3V0cHV0LmM6Mzg5OiBza2Jfc2hpbmZv
KHNrYiktPmdzb190eXBlIHw9IA0KPj4gU0tCX0dTT19UQ1BfRUNOOw0KPg0KPkknbSBwcmV0dHkg
c3VyZSB0aGlzIHJlbGF0ZXMgdG8gc2VuZGluZyBzaWRlIHdoaWNoIHdpbGwgYmUgdGFrZW4gY2Fy
ZSBieSBhIGxhdGVyIHBhdGNoIGluIHRoZSBmdWxsIHNlcmllcyAobm90IGFtb25nIHRoZXNlIHBy
ZXBhcmF0b3J5IHBhdGNoZXMpLg0KPg0KPg0KPkZZSSwgdGhlc2UgVFNPL0dTTy9HUk8gY2hhbmdl
cyBhcmUgd2hhdCBJIHdhcyBtb3N0IHVuc3VyZSBteXNlbGYgaWYgSSBnb3QgZXZlcnl0aGluZyBy
aWdodCB3aGVuIEkgd2FzIHdvcmtpbmcgd2l0aCB0aGlzIHNlcmllcyBhIGZldyB5ZWFycyBiYWNr
IHNvIHBsZWFzZSBrZWVwIHRoYXQgaW4gbWluZCB3aGlsZSByZXZpZXdpbmcgc28gbXkgbGFjayBv
ZiBrbm93bGVkZ2UgZG9lc24ndCBlbmQgdXAgYnJlYWtpbmcgc29tZXRoaW5nLiA6LSkNCg0K
