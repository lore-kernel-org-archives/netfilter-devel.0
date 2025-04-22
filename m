Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011038.outbound.protection.outlook.com [52.101.70.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868242BB13;
	Tue, 22 Apr 2025 12:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745326652; cv=fail; b=JdwLe4Ie3P5ljd0yhDblwsRvb+VXrnrRCuJ81kHMiEGC3ZET29Pprr9+CqfmD0axnnjU3OthIvqIBMy2v+tLvNlAnlNO9qqXgHj5bt+grbLCYSsvH/Ksn0nCc3rQJefOzMkJXXNXr2KNPqPX1mrAfWtWEQQSFRayJTSidWL16TM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745326652; c=relaxed/simple;
	bh=AeBVdGROpJFMXv1xcArSiiXt7dZqI9IImoq+sOETGik=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=r/kj6zplZEqJFeTKnIkpocHNfMb5YZivVfe5wgFHOGP0GbaytDgVa1wYDfIaHloDDNtsrC95UbeiO3COhpHgkV1NAG9NOkYucc22sZTznj66EpF76XH6WzZpTWFrdIlaNQDVVa9z+772z5oWPryJZ2Tri6wqH+A5AZOhccrCMJo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=boskalis.com; spf=pass smtp.mailfrom=boskalis.com; dkim=pass (2048-bit key) header.d=boskalis.com header.i=@boskalis.com header.b=g9FQqMAd; arc=fail smtp.client-ip=52.101.70.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=boskalis.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=boskalis.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=boskalis.com header.i=@boskalis.com header.b="g9FQqMAd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iMhGJqE7A6ARYJXONZdDFyrBLFuLv6WXVcW52GtxI0wQx3DA+EK6lIQbuzENGNheRTH+kDDX3NkbHTcXgElFW3s2n8ZYSjH/vXDGkQchTP9LdaK44Pe/QWuQ4qU2Qeb0YTQ7N3dYR4wIFr/DpBZzqJKwQNpsGZ/QCEXopgCx+vgL19CiVKEfaN/VzRtRjd0IxGIfus73+jJmhXMQKDxexX/8LqOA7K0l8F7RduqJGvMDdGTfkB0G1qXSyAQytUR1/7g/6zUGZraMmebyw4yS+5ZqAx8zQ9s0TC6b3ba/snoAxqOwVWk3zEuOHb9CtXupMjLF//WMERNfBMM/1ng4bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AeBVdGROpJFMXv1xcArSiiXt7dZqI9IImoq+sOETGik=;
 b=xnGVAxQF0ZmsZeo2bprynPCFJkW+MNJIfIrWM69w77AqiPj1lji5bo1W8jftqrls/dlyWNQjyx3wP3T2gZK0l1sWRXwYElNe8Ea4CF72msjdD6C2n5QR4qjU5U+/qAb7bR3lzIObz/c7+rLue9jhbJATAyFu0KEjiC9vLwPEGSTQw6Vqs/97xrfYI4TAOJo1l5pFcz971f7fQokuNlZzBis7VQH2UnWAkJroXcywRqxCj56LzOO3onZuWiODHm5K2Wt1BUHGJNIKsOvtcNVqNLj8v+QoH/B+5mfYGi0XgvRHW10mdm/hSzqzBcYDKPJqrod30l33j8obXI802d3WGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=boskalis.com; dmarc=pass action=none header.from=boskalis.com;
 dkim=pass header.d=boskalis.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=boskalis.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AeBVdGROpJFMXv1xcArSiiXt7dZqI9IImoq+sOETGik=;
 b=g9FQqMAdmJgug5nC7CFIQUEsN4mO+4XfDPeI2I4h6W5RLOzDesQVFuSCiYUooFLN724pGDVjAuCSDf7P17xfmcwldjQ3Y2Zu5OTtGZv/pXgIEcAKQ9CKxaDthGWtCrp0/PZpl8bQbBHmUNsblHUe2FC5CAi8cy1SBntwMpgHTax4KxC2obt7SOLnp8ppEHKcivxBE0E/vFrxnN77xlvvMkMQNs5Nv0RoFNIgq4U/xH8cy5fGanS10Dw9ptlRNhJtGyPwPbJiGQ3qoyRNJRu6o4MCR3SODbcYKu6oqcbkziOs7jtpgW9BaleAcbMoZSAHOmIz87RgQODpFS6V9yTo2Q==
Received: from PAXPR04MB9074.eurprd04.prod.outlook.com (2603:10a6:102:227::7)
 by AM9PR04MB8987.eurprd04.prod.outlook.com (2603:10a6:20b:40a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.36; Tue, 22 Apr
 2025 12:57:27 +0000
Received: from PAXPR04MB9074.eurprd04.prod.outlook.com
 ([fe80::8ac4:824f:2113:8fd8]) by PAXPR04MB9074.eurprd04.prod.outlook.com
 ([fe80::8ac4:824f:2113:8fd8%3]) with mapi id 15.20.8655.033; Tue, 22 Apr 2025
 12:57:27 +0000
From: "Vink, Ronald" <ronald.vink@boskalis.com>
To: 'Pablo Neira Ayuso' <pablo@netfilter.org>,
	"'netfilter-devel@vger.kernel.org'" <netfilter-devel@vger.kernel.org>,
	"'netfilter@vger.kernel.org'" <netfilter@vger.kernel.org>
CC: "'netfilter-announce@lists.netfilter.org'"
	<netfilter-announce@lists.netfilter.org>, "'lwn@lwn.net'" <lwn@lwn.net>,
	"'netdev@vger.kernel.org'" <netdev@vger.kernel.org>
Subject: UNSUBSCRIBE
Thread-Topic: UNSUBSCRIBE
Thread-Index: AQHbs4YZyM0urWdZH0Ob6AbQPX224w==
Date: Tue, 22 Apr 2025 12:57:27 +0000
Message-ID:
 <PAXPR04MB9074384486EF24F9E05E931999BB2@PAXPR04MB9074.eurprd04.prod.outlook.com>
References: <aAeA_6rbRNqpIRE2@calendula>
In-Reply-To: <aAeA_6rbRNqpIRE2@calendula>
Accept-Language: nl-NL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=boskalis.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9074:EE_|AM9PR04MB8987:EE_
x-ms-office365-filtering-correlation-id: bd529fae-9d98-4e77-7996-08dd819d3c07
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|4022899009|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?IcWeGQ1+vet48Na+xzfPbA/DsGv7x07Y8eQa1nCD5W8Kc4C2+vbNZCCbZTyF?=
 =?us-ascii?Q?bEkzJQ/PJHMMl1XBoJVX1tekRPMtECXD9mU+izLiFrHaKBgUJEA7stGrMLVs?=
 =?us-ascii?Q?I+pSb4nHq4e6vK6d+O7Nnw3XfsH7bXU92WkL64ZaI1AahR46pouQt+Ki1ihT?=
 =?us-ascii?Q?eum3VIg4khYMerqN7++Wzxzrg0Ij2grr+NM61WxYPsD/rPQNJUVR8xqXkTkP?=
 =?us-ascii?Q?BKiKbkGyXkmLV9K+U71ZRgcUekDVijYUJKhFLLcycyC5G8gFp4hMTgaMrYbb?=
 =?us-ascii?Q?sWUtSpqrhenH0zIS4t1fgzQLz4BdNIlXzHZJ/9grODm5cc8lwXZTcNER53YZ?=
 =?us-ascii?Q?wACMJVmPGXU99LIxd8AOmuYP7bAVH1Bd5bIEJHIjKA/YQ0cmzTJObXdv9yTe?=
 =?us-ascii?Q?dvkO9A0iUVAyEJc3WZaPNumta+nA59eqiQHrMUqzKSqDlgcGiQ8kBhijfFPv?=
 =?us-ascii?Q?C1L9QZJ1FmKzw4gbSMlCI/VvEjiHsLBehOElk+/qRd7Q7ppvP5/1CEvAFwt9?=
 =?us-ascii?Q?qz5z1bUxUYD/1v3Gb9OmmMtsQHGcajJZ11O1fCLUXJKxAc4IEKJAdXsvdwEc?=
 =?us-ascii?Q?LE9ZHU5AdgIn4203lwf1z3BkVO4k9qd6YHwSE9GYhncfV65TaeBOluQ1YRE2?=
 =?us-ascii?Q?nQTbvLxwRtJAh/Md8Z+T7yBn8T1XXvnYdYrQ7CPRSyaAPg/9aEyESyRtHt+g?=
 =?us-ascii?Q?tKhrNkWQB8pwwTNcP9gB9/qbwSc/IXAveZdN4lEuDwn+7sjtPVtHpfhimHuG?=
 =?us-ascii?Q?7XsEuEhYdXzAToT2DDwASmLln5OnfZvBD5sq8m4a1xghs2BX5BjKes6W+YvT?=
 =?us-ascii?Q?3EkJy6j/FSGpTZ8RBLx4GN1Aj5zj70RrC9eMgZOHZILKwmQBdk29BVp5DKDk?=
 =?us-ascii?Q?vJlgxkpvp+qqCgM/yHi79rHa+1QUeXOHKA4eL/2TfMSoDkRLHo3UeIuo1gAu?=
 =?us-ascii?Q?t52MMzlyQJFnt3BS/7yV9cHHU3GmTRCeJH71C1E7SCf1zMXA8JdhgGEwj9tv?=
 =?us-ascii?Q?fvB4uP9NuwwGdgYApQXNPxNKP0X9NHy0GNLvKU9x8OUU+iUhW0DwPklmFHIG?=
 =?us-ascii?Q?0v0JZmHSBGghERDBhJE/zChth1tcWAvExHn5haOYRESNt/wfifDQtTZbL6ku?=
 =?us-ascii?Q?oNZN9tZK+Cj7+O3svIGw5qugBdwbwGDqDyWcawdABMPZ9kWc+uwmzo6aYoW7?=
 =?us-ascii?Q?3MnvytiL1EmIaRv5EwpNgr10abKZDHOPQHvFAZiRs1gK6rolF5bZZu7n3/rz?=
 =?us-ascii?Q?zt8/4lRFP2mruMWodcU9Fn0QEOPP8lO+lMy8jPro10b5qtedlCRfC80wPjoU?=
 =?us-ascii?Q?RuZkGDYMWR7d1U+mJDuM60rH1MN8YsnQ0YIrAKQ8lMeUEWrE+yQ1Uia9rGgn?=
 =?us-ascii?Q?sRQgYKDAT9WzxBfdUSWWPiCUcuGRmCipk5EK3cd22mROxyWg+NWUXIf2vjB4?=
 =?us-ascii?Q?KXxAOHFW32nQS4Jw+99cpJWkgKTl+RyKe071zGn1IHYsSVT9vfyiiek8YGgZ?=
 =?us-ascii?Q?T+wZjI0qMWMiP3A=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9074.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(4022899009)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Yy6R4CYdRtNB/xj/v7R1RP7ZdxEuKStDUK8GAySZXa7k1j7xRQO+U2QsHpUP?=
 =?us-ascii?Q?F/XpE5bD75f5tE+kUcET9bz5sjs6GkLwFsVudciRUlYp8IIe5umMvw3nSoHx?=
 =?us-ascii?Q?ejaLkWrl5CyDgP2xeASHVsGWNgA/yPL32g7+2kiFkZ0Wze3N9v3MRl+jOIwl?=
 =?us-ascii?Q?7MJuqWLKCETBlUx/hpK/EDEha9hr++ixADwG7/+zmGsLfor9a4j2PvC90aUe?=
 =?us-ascii?Q?Wfhjwh5XkYagRux8VV5gEbRK6UeenR3Wn5d6vxlQl8rSMAvMlG2L16DUEbFv?=
 =?us-ascii?Q?z75bMSgp6b9aoSuhXgTu4q7taLQxwB94kyXXIrytSz82+B6BGdevVyTPNBsZ?=
 =?us-ascii?Q?lis+R9iOg4c95pY5ioY6qYdzNE79HZAnjSOv58JHjN6xBie60rs0ZrkXfHRe?=
 =?us-ascii?Q?lvkLqDXNwTrSXQHo5wcAhA8C9VRWPzeRgwuhwtLS+JgPZhwJpmOyJad4kNPN?=
 =?us-ascii?Q?PfZUnpTOlQpApkOgXGJpFJp8FnRr2Bi5nAbja3JTI3Yanki8BjRRn+PCBSwO?=
 =?us-ascii?Q?IudRcDovTJCUQ0TVB6AJhrchKs6l8zNbzpztc5p4dntGgtWHYodYJ3Jv4Eki?=
 =?us-ascii?Q?/5ZilPdD6HwNh4MzVF7VQ9ZOUrLvExe9h+58kgzWV2ar9+sYmsfa8eMzqAO/?=
 =?us-ascii?Q?7mauPoTMtEcbpcxQqtrg7gM4ASBJV7YU1hTE7853sb/0J/UXuKudmiFkygE0?=
 =?us-ascii?Q?DRm0TDKfS7i15M/ZShTYgA2np08qk/FbiUb6oWVmx13Set0FaE3Jg4HdCtvk?=
 =?us-ascii?Q?J6oxD38CnhbWd1ipELgXVTa43NCfRv+SrgxVbsETJ+GnEZ/gjEohQPg29n6M?=
 =?us-ascii?Q?92qgAMjNgNbdIZpXYwnOYy+0+jpdACvuxYVdtqNRpFlUCnFzk4TJ4PTdv+QF?=
 =?us-ascii?Q?+ldS07ZRg9Fm5g8iZdtZwUVxGsZa76Gc2KNrhMmLBxGM5N5IoP1gwUnyTGyE?=
 =?us-ascii?Q?cgxFmiEawgh5irhSe2mXMbZuCmLPj7ndF09DMD/3jTvOPw9djkPxj1v45iLl?=
 =?us-ascii?Q?xhGw6SyplKkuNPgMB9ukyYUfPYwXAIOPn1BiKpH7d6r1eQBkb5z4CJkC1bl1?=
 =?us-ascii?Q?oQkiBiLVHkUikjg24a2UUvk+CLYyO/YRdjop60PqSAEa5IqN9zBYy3lVmWBu?=
 =?us-ascii?Q?Og1ONX8nWas2K9VAstYt3CDMc72rdghCqpvye2pz0UFLByVlSaEQCSHUO89h?=
 =?us-ascii?Q?pvjIBGmXLzhlUZh5mBSn/ECqdhHkGG/ccVY/tiBIlBph4B2KuSCecE7aFY8K?=
 =?us-ascii?Q?15RenWMRZgYVxKe7KCHVdzfA3eOw8oUferHMdVkdnFPVm0zPsATmRSjLBtlT?=
 =?us-ascii?Q?0MQWOWSmDYe6tOBQr8gCwlnUQvipMztsfvsgY9tmUu58ortCdDOjeOYq38O5?=
 =?us-ascii?Q?720y05oAUdBDQZVIdcg/w++62oM0N48Exfwb9yOALRhFIcKl7kE1+9mMljk6?=
 =?us-ascii?Q?wBYsbriDGvuyWaW7oGi/38udiSHODvhU3Xt53ygsD5DLZZlWv2H67EKrZHNx?=
 =?us-ascii?Q?K/FQuRNdE8dyj2yuvLFpU15VyWK3lTpFajSNwLQGlk3T403/3XedKCd0gwHL?=
 =?us-ascii?Q?xu299HGCccUG5GVWtIBJLKrQZL+FzxTvNJ7tKfLj?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: boskalis.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9074.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd529fae-9d98-4e77-7996-08dd819d3c07
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2025 12:57:27.3215
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e9059df4-f2a9-48d6-8182-7f566ea15afa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IJl4nMG6XdkQwpuf+U6DEwn6VAUs6/91iGiUSPlggNxE6CavTvBiia/Fud2DXBMPQxa3helyzfZDOx6zxh0eS693P/85Ye9OIm5bLqXZi3k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8987

UNSUBSCRIBE
________________________________


This e-mail is intended exclusively for the addressee(s). This e-mail, incl=
uding attachments, contains confidential information and/or privileged and/=
or proprietary information. If you receive this e-mail in error, please not=
ify the sender immediately and remove the e-mail from your systems without =
reading, copying, distributing or otherwise using its content in any form w=
hatsoever. The unauthorized use, publication, reproduction or distribution =
of this e-mail is prohibited.
