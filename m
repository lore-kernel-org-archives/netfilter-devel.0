Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2043.outbound.protection.outlook.com [40.107.21.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236811A238D;
	Mon, 30 Dec 2024 09:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.21.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735552269; cv=fail; b=hLsMe8pFQ9Sdm7DFOV/qosjM9llHsvygL7rtA8OLwU7xPouZ0NlCcWYmjgKB1Zppb+lq5uiM1XHDX+ZAkpPDiieVi1Z6e+x43bmhl8mneVaryXEdINUg9uk7OlVDO3hZlZqSI56pffTZP24lsYiOxXAC25oDqzXsQrw3KcDyx2k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735552269; c=relaxed/simple;
	bh=nsscWX9UHF0UwBpKJ7Ugwg+yOuqZDkpLxCKn/DjCuEA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aFXV2F3WTH8R1OnVQ+kkKH9lpxBvjcp9Ndwq4a2M4hYyTeQORz2C2NHeGkkAxOfywtmBVQ2OPJ5OFUFDs/swhbc+NW1hHqR8HfTmlEhPrawIAwQy+7viJRR1c0CPbeso9MmBakkB+BZSqepgf43bzV9iT4Yz7DINXF/xHlmBmdI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com; spf=fail smtp.mailfrom=nokia-bell-labs.com; dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b=grJzUaQJ; arc=fail smtp.client-ip=40.107.21.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b="grJzUaQJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E//Qs3/ppjEAvjG8yz/ZHXHA2Qy/cCdIzejof8ZJFDT4XrcE2izn8y2KSl1JnMEoiMbfKSfQCjgThzZxLXnwGtQJ4J7E58Maq3gAUt+qwdj3o0JzsK2pKpcDvOz0fnwUiBr246ql0poPXLrDQ23B+VXRidzSXPA4dYufNO7+tUXeuPzKE19/Egp8OjkGwpHWmzTYjhEOzVdPE/MLdLuiLdWX5vs+ba11XxXdhw+xDVtzZrD8hIn1Cmbu68lQWEvHaDrt3OP4ClCvD5LWTWoJXSp3qr0UYxJ9NWT+dKfnuaD+vEhs+HTBKMEXVv74bHUn/Z52H+rfPFMoI7no69N/fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nsscWX9UHF0UwBpKJ7Ugwg+yOuqZDkpLxCKn/DjCuEA=;
 b=Gwebq6Sw/YYDLi4xkabBMMBtZpFu4KCir0SnGvGcBQ3Z8Z+z8qeoZbV8K2ZF+gdP7bYbD90tRnAjQ+YPMqd6s/myR5Yj9eJcnscCYWRdxU59/btoFN/bNRFNgHUQhETpCr+lkeUY2XMRlO0nOG2INS/zoNFCtJZjybPo/eToae08ne/fMhyhheNZLOpPYHM9O5JkFQkcoEvbEit1a7i1aoOhJwZqYVX+s68UzwHqww2r3szisqdSCkVEHsNjcrco9wWPxQ4aU8CfoImHl1OUvuQROR/9sA+AL085vJ7F8ABwRCIT2zFCLKfavfQzkqjez6ZGUDDUYdw43GXf4k6eAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia-bell-labs.com; dmarc=pass action=none
 header.from=nokia-bell-labs.com; dkim=pass header.d=nokia-bell-labs.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia-bell-labs.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nsscWX9UHF0UwBpKJ7Ugwg+yOuqZDkpLxCKn/DjCuEA=;
 b=grJzUaQJXaS+E5QN04JMIeFBBldcXkmCycDJagqaOEGLvmYPR081KIGmzrh0nr0eqgiKOGGYPEd8qBxLnWxh/uHSUOpOZCBvWb7hCNKnnYy1SsQvQKq1M9TyOda4PpdTSxNnmHNK7RqAAf8K76uCD7RCao8N0/bNoPt0uhl9IeZLvY4RsPQvswkCrH/FKwfHtu4FoFqLLaG5Xs0TVsWWyUQ/YUsF1aehpMgaa+IHHUEK+2FO0WosmkU2wDvfNKmixCASkur9GMPz/MW/OTKtYw11BWDgw9dRrZkQbCEQ+WSWc+vy8A4JzQX+soCArCqHltS+ul3fvSyLCGvbY1pEww==
Received: from PAXPR07MB7984.eurprd07.prod.outlook.com (2603:10a6:102:133::12)
 by PAWPR07MB9791.eurprd07.prod.outlook.com (2603:10a6:102:390::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.18; Mon, 30 Dec
 2024 09:50:59 +0000
Received: from PAXPR07MB7984.eurprd07.prod.outlook.com
 ([fe80::b7f8:dc0a:7e8d:56]) by PAXPR07MB7984.eurprd07.prod.outlook.com
 ([fe80::b7f8:dc0a:7e8d:56%6]) with mapi id 15.20.8293.000; Mon, 30 Dec 2024
 09:50:59 +0000
From: "Chia-Yu Chang (Nokia)" <chia-yu.chang@nokia-bell-labs.com>
To: Jason Wang <jasowang@redhat.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "dsahern@gmail.com"
	<dsahern@gmail.com>, "davem@davemloft.net" <davem@davemloft.net>,
	"edumazet@google.com" <edumazet@google.com>, "dsahern@kernel.org"
	<dsahern@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"joel.granados@kernel.org" <joel.granados@kernel.org>, "kuba@kernel.org"
	<kuba@kernel.org>, "andrew+netdev@lunn.ch" <andrew+netdev@lunn.ch>,
	"horms@kernel.org" <horms@kernel.org>, "pablo@netfilter.org"
	<pablo@netfilter.org>, "kadlec@netfilter.org" <kadlec@netfilter.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"coreteam@netfilter.org" <coreteam@netfilter.org>, "shenjian15@huawei.com"
	<shenjian15@huawei.com>, "salil.mehta@huawei.com" <salil.mehta@huawei.com>,
	"shaojijie@huawei.com" <shaojijie@huawei.com>, "saeedm@nvidia.com"
	<saeedm@nvidia.com>, "tariqt@nvidia.com" <tariqt@nvidia.com>,
	"mst@redhat.com" <mst@redhat.com>, "xuanzhuo@linux.alibaba.com"
	<xuanzhuo@linux.alibaba.com>, "eperezma@redhat.com" <eperezma@redhat.com>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"ij@kernel.org" <ij@kernel.org>, "ncardwell@google.com"
	<ncardwell@google.com>, "Koen De Schepper (Nokia)"
	<koen.de_schepper@nokia-bell-labs.com>, "g.white@cablelabs.com"
	<g.white@cablelabs.com>, "ingemar.s.johansson@ericsson.com"
	<ingemar.s.johansson@ericsson.com>, "mirja.kuehlewind@ericsson.com"
	<mirja.kuehlewind@ericsson.com>, "cheshire@apple.com" <cheshire@apple.com>,
	"rs.ietf@gmx.at" <rs.ietf@gmx.at>, "Jason_Livingood@comcast.com"
	<Jason_Livingood@comcast.com>, "vidhi_goel@apple.com" <vidhi_goel@apple.com>
Subject: RE: [PATCH v6 net-next 11/14] virtio_net: Accurate ECN flag in
 virtio_net_hdr
Thread-Topic: [PATCH v6 net-next 11/14] virtio_net: Accurate ECN flag in
 virtio_net_hdr
Thread-Index: AQHbWJNWUY8AUXN8qUKyr3sYVzL95LL+biyAgAAc8gA=
Date: Mon, 30 Dec 2024 09:50:59 +0000
Message-ID:
 <PAXPR07MB79849952690901A50688EFEDA3092@PAXPR07MB7984.eurprd07.prod.outlook.com>
References: <20241227191211.12485-1-chia-yu.chang@nokia-bell-labs.com>
 <20241227191211.12485-12-chia-yu.chang@nokia-bell-labs.com>
 <CACGkMEu990O+2Sedj+ASv0P5TnZR9THiOdHmx=L0hOxQRXPcsg@mail.gmail.com>
In-Reply-To:
 <CACGkMEu990O+2Sedj+ASv0P5TnZR9THiOdHmx=L0hOxQRXPcsg@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nokia-bell-labs.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR07MB7984:EE_|PAWPR07MB9791:EE_
x-ms-office365-filtering-correlation-id: e33a3f65-3059-41ba-084e-08dd28b7770f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?Q05FZmE4ejIybno1dlYvY3l0WmZua3ZuWTRUbEtKM2dGczIwS0VpbzRCOE1T?=
 =?utf-8?B?VDY2aVFLNkZQRGdFV000NjdxZk1adS96YzFibnp4WXY4M0d4MGgxM3NselNL?=
 =?utf-8?B?ZmxiS3huY1paWkdiWjc4OXlJYUxDZlMwZzBwWXBqclloTExyS3dDbWV0S2Jy?=
 =?utf-8?B?V1N0cGRrL0FsSVdyNFhYU3kzNTdxaXBzK2ZjaytDN0o5VVBNcUc0eDlObHNz?=
 =?utf-8?B?bnFtSUwxN3hNeEE4Sm5WRHFIOCszTGpXb0xETU43VHdzd0RVd015OCsybVB6?=
 =?utf-8?B?cGxKcHVnL2hCdGtiTEMrVnFhMzJQVkorelNnR1V2NDZYUDRnd2NHOENVbnRY?=
 =?utf-8?B?WVZaTVQ4QkpoM0JseHQyUE5md2pueitnMUE0UmFhVEk3bVppZGlpV1JXUkZa?=
 =?utf-8?B?V09KTWp6UFJtRHZEVVBiMzN1UnIwS1VhR201dk45aG1lakV4V1QrOEJrR0Q3?=
 =?utf-8?B?bGhhSmJnWTUvWUY3QUtjOG5TZTA4WUJoNGNid3FZZk41ZHo2SzN3bno3KytY?=
 =?utf-8?B?aytNcG5ucFpLWmFVNDRjV1ZKTnJUbWxEZEJRd1FWOXgwWGNzdklQYWhrSkpz?=
 =?utf-8?B?WjIzN2djcDE5YmJkeksrQWRuUTRuLy95K3dBQTY2MHFFWS84VXkvMllvd2Rv?=
 =?utf-8?B?NDlxTHdaeHc5RkNJV0lqTHM4QUVQOXhjMlE2SGg4KzdpNEdoeXpxWnlQbmJG?=
 =?utf-8?B?UlJ1djhTVHN6YXZyNnFBbVlLR0JTQUxabFgvMlhPWW15VTluS3pJTWZ6MUNy?=
 =?utf-8?B?MkhPajZlenBnMWRReG1ZUTFURFNXR01ET05iWnErS05OZjhBbTlFZlhDdEh1?=
 =?utf-8?B?WnRkTDNKMDhNV1NOQmgreEZNV1VDNnlNWUdIbWMrcm9MVEdQbmI1aVkxbnRV?=
 =?utf-8?B?V21tbVhjTlNmVXZSU3JSbTBmTFhicVk5ODVyVS94ek5ENmZrZ28rNCs1cEQ3?=
 =?utf-8?B?WXFrQXNXYWUwN3RjcVJDS1ZsTXNLczE2YzkveGNWbTBaSzA0K0pqVUMwd09h?=
 =?utf-8?B?S2FIcXp6UGhwUWJGQ1dwcHZGUUdDTnJiSkxaajdUalNRckNKd2VnbXBhQTU3?=
 =?utf-8?B?cHJ6RHBnaGtUQmJicTZRWm5UNkxUVmdOcXZvMmRtY2dJVmEwT0wwQmM0UWN3?=
 =?utf-8?B?cHJ2RUFGV3AvSlN0c3JFYUJaUC9wQnUvWGoxTndoY1FRTnYwZzNWb0tSbWFk?=
 =?utf-8?B?NHNjRCtLNUg3LzZYMll0RndCZUkvN3lLTWpjb2hHWWJUQ0I3TDZuejNCRHEx?=
 =?utf-8?B?SlU0NEZNTFNraENrVzI3TTRYUjhuL3c4ZEJsM2E4eU15dzdMMHBKS1ljcVRU?=
 =?utf-8?B?Ynhxb3YzejFudzA4UU1Uc1ZBUGhsQXZ0SGw0UERjc3p2RFpDQjBBdU1yY2Mr?=
 =?utf-8?B?SURELzVNYVBTcWJraUZrQThGamxVSTJIdGZ1TlhCTHdiR2gvVVZHaUZsMW1z?=
 =?utf-8?B?dyt0K2RWclZRS0YxZUxtdkovS0oxRmZmMUJEQlZHUmtWYkg0ZnhXMldOQTRD?=
 =?utf-8?B?eHcrOFY3N05pcm05cWE4YW5RekV4b3RVZUJySHJpbEFudCtEMjZ1R0xZb042?=
 =?utf-8?B?Wko4aUFBZFZ0WVJxNG95alFiOUdnajdrZFJTeUh6a3ZhcEVTOGR2ZDdqM2RK?=
 =?utf-8?B?d20wMkZNT2lEMFlzUHVGaVFTNGtxb2hXa1pOaGg3SkZ6YjVpNnF1a29iVGR6?=
 =?utf-8?B?NmVtK0kvYUlYN0NLU1R3YWFYZWF3c2YrZ3VGQ0VHa2dDNnVlUUt3M0RjNjdy?=
 =?utf-8?B?aENLUDJBMmlnTkFoUnNwWWV2YWswelloa2p5RkxJOE9KWWZmbGlHcStKSkRW?=
 =?utf-8?B?TXptc2Z6TUZIMTYrSHYvSCtEaTRGSjBtN0hzMVRvOGVQbW9zYk1TYXd4Wmp2?=
 =?utf-8?B?eHNXVGtsQ0RwR1piR2NhQ1FMcjdEY2dZcGwzK2hQcENuMHc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR07MB7984.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eDlEdmhYN1dVRjNLUXlsK1hQQnBaeFRNZnY5bFV1cXZiSlNTUWlEbzc4R21w?=
 =?utf-8?B?Uy9ZcmRsbVc1NmJqMUFTUzQzZzFCYlBVRUwzSHd3eHRvejRyWXNOSnYwL00x?=
 =?utf-8?B?R2Fnem9QdHhDcm93UGdGR3g5TWNzeTdQZEEyOXJoK0dSaUdDSFlEM0krNU5E?=
 =?utf-8?B?Y1Z0MUlDL0poOFVsalA5djJ2LzNwRFV6ZlN0VlludDJhLzBTNXZ3RVRnUTZ6?=
 =?utf-8?B?MVJEYXJoa01NNEhmT1NxQ0dGQU0yNHJBblhxbFFhRUJWdGY1NXc2c2lvQnNJ?=
 =?utf-8?B?a0M1UjdNVmtpQ2cwcHpTZTA3cXAzZjdueithaG9scW84NEhqeEh0T0M2RFFH?=
 =?utf-8?B?TVZWQnNJWW5YL2FWdDl2dVRSeU9MZnoxUWJIbFZaZENUekZIQW9tMmdxaWJu?=
 =?utf-8?B?QW84ZzNXNEUxNktTVlUrbTVjVW1GOGhRdGQyM2luVFYxN09va280TjhNNzZZ?=
 =?utf-8?B?aE5XaVNhTTdOZzZ3MFN1QXdlSUVPY1kzeFBLbTVkS3JrdFRIalpjNFpnZFNU?=
 =?utf-8?B?QnBISzZBVktnR1hNMjBxTFJyR2pTc0pTOFB1TW5rL2lwNld4d2J6cUhjc29P?=
 =?utf-8?B?TTN5cisxa2ZQWGMraUdZM0hLVThsQUwyWFFvdk44ZEl4MDVua3MrbStaMExx?=
 =?utf-8?B?SzJyYlhlc24yMXYrTDRhQkRGRTEyVEdMazIvc2FEY0FRWllZZFord0JCY0tI?=
 =?utf-8?B?b1BDL0NpOTNmZkU2MGNiSHFzRm5KN3p3M0hMckttWXNTcDhPUXhxSE9aQVUx?=
 =?utf-8?B?NGFPNWRKd2YyWUlLUHRpZ2tiZ0ozdWh1ZTRubERaaW9LTDZJcG50elE4Y1py?=
 =?utf-8?B?WlJITnlaVEkzVmxLdFJkZEEyUytTbGVLK2twWXFOTTJhV0hpNjV4N0p2a1FU?=
 =?utf-8?B?L01DeUdsOHdUSE9JRzZYVkxrR0c1dkRET2pGNk11UmVYRDk5OXQxREVPcWMr?=
 =?utf-8?B?MHN3cGxXTXBlcFNtVnVjS1ZwaHBSbXlSYnNWMmYvLzZaaXlHOWJzUzNtM3Jz?=
 =?utf-8?B?U0hZV1BzK3JzSVZ0enZOeDJnMnJydVR2YzlEUi9YZFRvZ3dGVWpaRHNKaGI4?=
 =?utf-8?B?VEtqcm11MXpLRjNyNGxJdGpiMFM3aUswWFVtSzRvV1ZEenpmSmlsWFluSmlM?=
 =?utf-8?B?ZHdob05odERhL1lIb3FtTFFXSDE0QVNiVTY3Z281SjJ4RkNPMEpzc0x4dzNz?=
 =?utf-8?B?enFuc0dKKzJCSy9LUk9pSjdjdXE4RFZuOXl2TWRlb3crOGRUejhuSmRRYVRk?=
 =?utf-8?B?ZmxIQ0lkWnMrdkFSUVE2d25HUXY2d3E3cVE3Znh5cEtCak5qVDltN3JMOTRF?=
 =?utf-8?B?Q29TZnhFa3hadmZiOW5GendNRXhnSnVMZDJNc2VDcThONEFCamtjSTE3UWV2?=
 =?utf-8?B?ckt2YWxHRlpTZ2VqS0hMVHM5YUg3WnhVY29ZSHJPZXkwRkltTURIOER5WjFC?=
 =?utf-8?B?NUptKzNoZk8zS1Znbmg1a0NkVEk4cTZOeFdVOWJrNFFYck5pREN6bHB1c2p6?=
 =?utf-8?B?bTdQbzdFN0c4RFFmTlNVWVVzaVpVQlJHVW5UdGpQUnF4QjRVd0NLWGlNTmZj?=
 =?utf-8?B?LytLUHZRRWZnb2NQU21FMThxSGpDQ1hhMkoyakJjdUZUQjN3OXM4QVVXeG1k?=
 =?utf-8?B?a212a09QelF1L0NLL3RDc0pDR0lmVTA2U2pHQUd6T21RT1VCc0ZxN3VMZEN4?=
 =?utf-8?B?SXo0aGQrZmdKaUpkVVc1VHdPck5xeXFPKzAvTnBuR0lRMjdPNTBrdTJwaWdE?=
 =?utf-8?B?UWExOXNnWHBDcFhxUW9Wb2QzaGt0a0U2MHd4ZEI5T2VHREIrQjJzVUhOYWJO?=
 =?utf-8?B?QW41ZzBjTFBvOS9pV05oYTJXUFlnSUk1WWtxVFlNRzJ2SEJad3lNaXNmQjI4?=
 =?utf-8?B?RG5lSWw4amxNRnVTdEVoWVU4a2NuTkh2S1dBUkg5U3A1TTJBUnN4bkl0S2dO?=
 =?utf-8?B?dTFnT2Z6ZkhnS3VhY3VPeWdCWWYxcUZyMUNoTzZSK2V4OFJ6N01KWFVyMWs1?=
 =?utf-8?B?YW5Ud05NeEFzYVk0SUNJOE5yT2ZUK1RRZXcrd3puWm5STjBZL0FwaVY4MExw?=
 =?utf-8?B?K1RRTmFKbExjMWZ0dWw2eEJqcUJNYUorWTRENnMyODQ0dHZlWk5iNnB3bjBu?=
 =?utf-8?B?a3JjNzdUaGZibUJpa0RjT29qWWRVVzF6dHp5ZnpRemtqYUxUVnp4OUVjMFBx?=
 =?utf-8?B?c3c9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e33a3f65-3059-41ba-084e-08dd28b7770f
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Dec 2024 09:50:59.7461
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WC0L4fADqJSrKd5FtivLJq6PIm3bORB1NDawWw1v0eI1iFmMUD1XcW7XaZBUoGCvM8LevPJKaCzJhu18ilWtSbpRVn6CYh/kT0qmPsWzosbPzrY5l2lb5f7vsEUAi1xp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR07MB9791

PkZyb206IEphc29uIFdhbmcgPGphc293YW5nQHJlZGhhdC5jb20+IA0KPlNlbnQ6IE1vbmRheSwg
RGVjZW1iZXIgMzAsIDIwMjQgODo1MiBBTQ0KPlRvOiBDaGlhLVl1IENoYW5nIChOb2tpYSkgPGNo
aWEteXUuY2hhbmdAbm9raWEtYmVsbC1sYWJzLmNvbT4NCj5DYzogbmV0ZGV2QHZnZXIua2VybmVs
Lm9yZzsgZHNhaGVybkBnbWFpbC5jb207IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGVkdW1hemV0QGdv
b2dsZS5jb207IGRzYWhlcm5Aa2VybmVsLm9yZzsgcGFiZW5pQHJlZGhhdC5jb207IGpvZWwuZ3Jh
bmFkb3NAa2VybmVsLm9yZzsga3ViYUBrZXJuZWwub3JnOyBhbmRyZXcrbmV0ZGV2QGx1bm4uY2g7
IGhvcm1zQGtlcm5lbC5vcmc7IHBhYmxvQG5ldGZpbHRlci5vcmc7IGthZGxlY0BuZXRmaWx0ZXIu
b3JnOyBuZXRmaWx0ZXItZGV2ZWxAdmdlci5rZXJuZWwub3JnOyBjb3JldGVhbUBuZXRmaWx0ZXIu
b3JnOyBzaGVuamlhbjE1QGh1YXdlaS5jb207IHNhbGlsLm1laHRhQGh1YXdlaS5jb207IHNoYW9q
aWppZUBodWF3ZWkuY29tOyBzYWVlZG1AbnZpZGlhLmNvbTsgdGFyaXF0QG52aWRpYS5jb207IG1z
dEByZWRoYXQuY29tOyB4dWFuemh1b0BsaW51eC5hbGliYWJhLmNvbTsgZXBlcmV6bWFAcmVkaGF0
LmNvbTsgdmlydHVhbGl6YXRpb25AbGlzdHMubGludXguZGV2OyBpakBrZXJuZWwub3JnOyBuY2Fy
ZHdlbGxAZ29vZ2xlLmNvbTsgS29lbiBEZSBTY2hlcHBlciAoTm9raWEpIDxrb2VuLmRlX3NjaGVw
cGVyQG5va2lhLWJlbGwtbGFicy5jb20+OyBnLndoaXRlQGNhYmxlbGFicy5jb207IGluZ2VtYXIu
cy5qb2hhbnNzb25AZXJpY3Nzb24uY29tOyBtaXJqYS5rdWVobGV3aW5kQGVyaWNzc29uLmNvbTsg
Y2hlc2hpcmVAYXBwbGUuY29tOyBycy5pZXRmQGdteC5hdDsgSmFzb25fTGl2aW5nb29kQGNvbWNh
c3QuY29tOyB2aWRoaV9nb2VsQGFwcGxlLmNvbQ0KPlN1YmplY3Q6IFJlOiBbUEFUQ0ggdjYgbmV0
LW5leHQgMTEvMTRdIHZpcnRpb19uZXQ6IEFjY3VyYXRlIEVDTiBmbGFnIGluIHZpcnRpb19uZXRf
aGRyDQo+DQo+W1lvdSBkb24ndCBvZnRlbiBnZXQgZW1haWwgZnJvbSBqYXNvd2FuZ0ByZWRoYXQu
Y29tLiBMZWFybiB3aHkgdGhpcyBpcyBpbXBvcnRhbnQgYXQgaHR0cHM6Ly9ha2EubXMvTGVhcm5B
Ym91dFNlbmRlcklkZW50aWZpY2F0aW9uIF0NCj4NCj5DQVVUSU9OOiBUaGlzIGlzIGFuIGV4dGVy
bmFsIGVtYWlsLiBQbGVhc2UgYmUgdmVyeSBjYXJlZnVsIHdoZW4gY2xpY2tpbmcgbGlua3Mgb3Ig
b3BlbmluZyBhdHRhY2htZW50cy4gU2VlIHRoZSBVUkwgbm9rLml0L2V4dCBmb3IgYWRkaXRpb25h
bCBpbmZvcm1hdGlvbi4NCj4NCj4NCj4NCj5PbiBTYXQsIERlYyAyOCwgMjAyNCBhdCAzOjEz4oCv
QU0gPGNoaWEteXUuY2hhbmdAbm9raWEtYmVsbC1sYWJzLmNvbT4gd3JvdGU6DQo+Pg0KPj4gRnJv
bTogQ2hpYS1ZdSBDaGFuZyA8Y2hpYS15dS5jaGFuZ0Bub2tpYS1iZWxsLWxhYnMuY29tPg0KPj4N
Cj4+IFVubGlrZSBSRkMgMzE2OCBFQ04sIGFjY3VyYXRlIEVDTiB1c2VzIHRoZSBDV1IgZmxhZyBh
cyBwYXJ0IG9mIHRoZSBBQ0UgDQo+PiBmaWVsZCB0byBjb3VudCBuZXcgcGFja2V0cyB3aXRoIENF
IG1hcms7IGhvd2V2ZXIsIGl0IHdpbGwgYmUgY29ycnVwdGVkIA0KPj4gYnkgdGhlIFJGQyAzMTY4
IEVDTi1hd2FyZSBUU08uIFRoZXJlZm9yZSwgZmFsbGJhY2sgc2hhbGwgYmUgYXBwbGllZCBieSAN
Cj4+IHNldGluZyBORVRJRl9GX0dTT19BQ0NFQ04gdG8gZW5zdXJlIHRoYXQgdGhlIENXUiBmbGFn
IHNob3VsZCBub3QgYmUgDQo+PiBjaGFuZ2VkIHdpdGhpbiBhIHN1cGVyLXNrYi4NCj4+DQo+PiBU
byBhcHBseSB0aGUgYWZvcmVtZW50aWVvbmQgbmV3IEFjY0VDTiBHU08gZm9yIHZpcnRpbywgbmV3
IGZlYXR1ZSBiaXRzIA0KPj4gZm9yIGhvc3QgYW5kIGd1ZXN0IGFyZSBhZGRlZCBmb3IgZmVhdHVy
ZSBuZWdvdGlhdGlvbiBiZXR3ZWVuIGRyaXZlciANCj4+IGFuZCBkZXZpY2UuIEFuZCB0aGUgdHJh
bnNsYXRpb24gb2YgQWNjdXJhdGUgRUNOIEdTTyBmbGFnIGJldHdlZW4gDQo+PiB2aXJ0aW9fbmV0
X2hkciBhbmQgc2tiIGhlYWRlciBmb3IgTkVUSUZfRl9HU09fQUNDRUNOIGlzIGFsc28gYWRkZWQg
dG8gDQo+PiBhdm9pZCBDV1IgZmxhZyBjb3JydXB0aW9uIGR1ZSB0byBSRkMzMTY4IEVDTiBUU08u
DQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogQ2hpYS1ZdSBDaGFuZyA8Y2hpYS15dS5jaGFuZ0Bub2tp
YS1iZWxsLWxhYnMuY29tPg0KPj4gLS0tDQo+PiAgZHJpdmVycy9uZXQvdmlydGlvX25ldC5jICAg
ICAgICB8IDE0ICsrKysrKysrKysrLS0tDQo+PiAgZHJpdmVycy92ZHBhL3Bkcy9kZWJ1Z2ZzLmMg
ICAgICB8ICA2ICsrKysrKw0KPj4gIGluY2x1ZGUvbGludXgvdmlydGlvX25ldC5oICAgICAgfCAx
NiArKysrKysrKysrLS0tLS0tDQo+PiAgaW5jbHVkZS91YXBpL2xpbnV4L3ZpcnRpb19uZXQuaCB8
ICA1ICsrKysrDQo+PiAgNCBmaWxlcyBjaGFuZ2VkLCAzMiBpbnNlcnRpb25zKCspLCA5IGRlbGV0
aW9ucygtKQ0KPg0KPklzIHRoZXJlIGEgbGluayB0byB0aGUgc3BlYyBwYXRjaD8gSXQgbmVlZHMg
dG8gYmUgYWNjZXB0ZWQgZmlyc3QuDQo+DQo+VGhhbmtzDQoNCkhpIEphc29uLA0KDQpUaGFua3Mg
Zm9yIHRoZSBmZWVkYmFjaywgSSBmb3VuZCB0aGUgdmlydGlvLXNwZWMgaW4gZ2l0aHViOiBodHRw
czovL2dpdGh1Yi5jb20vb2FzaXMtdGNzL3ZpcnRpby1zcGVjIGJ1dCBub3QgYWJsZSB0byBmaW5k
IHRoZSBwcm9jZWR1cmUgdG8gcHJvcG9zZS4NCkNvdWxkIHlvdSBoZWxwIHRvIHNoYXJlIHRoZSBw
cm9jZWR1cmUgdG8gcHJvcG9zZSBzcGVjIHBhdGNoPyBUaGFua3MuDQoNCi0tDQpDaGlhLVl1DQo=
