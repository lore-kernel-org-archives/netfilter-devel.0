Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2094.outbound.protection.outlook.com [40.107.8.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F09FEDC
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Jan 2024 00:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.8.94
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706227525; cv=fail; b=QZO1tqAYsnejCoC05pQdUskCqkCXztAhixTjAwXX9O08zF30joWl9NqnOKWqcJ2LMdAZexY2RQdgPELCxWQLBT1KvRjh02/srEPnhlJguUBnyCnC7Frr41VVjPTtpg/tlBSMXETyIfJjXtcc20yueR7x/idTfdYp1SJ3mOuI8ys=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706227525; c=relaxed/simple;
	bh=hcWvChVQ2eQji50vt4O6rQZ+sBKw8YQb/uVf74EAppw=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Lg+brEJz/T8VjGmjlSAt1TNLVkyy+V03rjNIf+INa0LpiBe9Cy6aLJvN32NZbMR7xSeErLpzWpplIu9ISyv1fDjH3kgGcWRgfd0dASwC9peMQG9hz7F/AFckN0OJl1T6MLvAGYOZYD/SsAZ6SFypzYFy6Cvk/UPDJ8aOhRtCzbA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=est.tech; spf=pass smtp.mailfrom=est.tech; dkim=pass (1024-bit key) header.d=est.tech header.i=@est.tech header.b=O/gOURKt; arc=fail smtp.client-ip=40.107.8.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=est.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=est.tech
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=est.tech header.i=@est.tech header.b="O/gOURKt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HLrSv1eiMTrI284tKGD3ItHtS1xDkrWwP2CFE20Q9Rd4vPIY38sfAsVKWBDu38LsqxNhxLxFGhjO+GhcR8f/Yk59+vyl6Roel+9BlN5qLdxbczM/s0Z9I5/L5FUbgCPc73YBFplXVEwPk2+4gArITCRcM4WxXnEx/ZLuzmuT41frDEQITn0bVMODtaL+P7sIQC55yEX7igxd+YfsvJtoQm3JdC1a4ZQiYgteR+NK87JILH00EXwEReOuyrQKYOxI2z7C7qoHY2T6punxZC3PGcPta7JZjK1RSIYgkLLEWRrLIVtKWpdv4Lq/ttYtnLDiTDg7kRBaqU3KLLJtiPEkqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1ksu6h5y7PpeUsNFIOBivGKrP1MfqpRNS8IC22O4Doo=;
 b=c6dkZjI/ZyhYzCZ5I1LN2v1faFHmLcS4cze71YJe+zAy1thPxvIe1KNajRQNK5lQVGuxQikm8/eaKXbZ2tbdER5q6kkB9tgmhsujKRo5fpzBLUfxuIJj3jZmf14/L/973j0BWfhvC9aSVbYs0yizEKMzwkIeeuNTJ3H9rw8KJrcsmRJQMOGZUmPf0wt2VECFMbUsT4W5NAJSaHSxtzMCP4zIayqZS0iWZOVumJrQFygw29k6aWQD3SCRXXyzanFnRlEpJVeEjrlxe0VpNtkmguWuK2PQXjnowLmOw0AYd6gNglILzLn0IaQKEYcqdCGu+faqACN8UHOOUc/HS621xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ksu6h5y7PpeUsNFIOBivGKrP1MfqpRNS8IC22O4Doo=;
 b=O/gOURKttu5o30hFNAyKkogFus5Q/hnB99FbkEwm6pi01fm3i4lXbTQ+mWnSmz9HOJp5zOyH7BLRds1JYtIC/2SFXPSEurUMpJbvtvjCatyTvab0GIvAO5yDI3DtnlNn0GuhcElTbLQSAQ0GgmLjWu5GB2ohkoPJQII+gf0DTvg=
Received: from AM7P189MB0807.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:115::19)
 by PR3P189MB1050.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:29::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.27; Fri, 26 Jan
 2024 00:05:19 +0000
Received: from AM7P189MB0807.EURP189.PROD.OUTLOOK.COM
 ([fe80::bad7:18c9:a3cd:6853]) by AM7P189MB0807.EURP189.PROD.OUTLOOK.COM
 ([fe80::bad7:18c9:a3cd:6853%3]) with mapi id 15.20.7202.028; Fri, 26 Jan 2024
 00:05:19 +0000
From: Kyle Swenson <kyle.swenson@est.tech>
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
CC: Kyle Swenson <kyle.swenson@est.tech>
Subject: [RFC PATCH 0/1] netfilter: nat: restore default DNAT behavior
Thread-Topic: [RFC PATCH 0/1] netfilter: nat: restore default DNAT behavior
Thread-Index: AQHaT+tZ52yfgc6AbkyfWCnppvYusw==
Date: Fri, 26 Jan 2024 00:05:19 +0000
Message-ID: <20240126000504.3220506-1-kyle.swenson@est.tech>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM7P189MB0807:EE_|PR3P189MB1050:EE_
x-ms-office365-filtering-correlation-id: bff398ff-86e0-4dde-8753-08dc1e027bca
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 WpLwQ3qIEJrTIce1F9YI6N/Trrp/dI6YaQB7Mo9AGefoOpRFNoFwj0/zr9HRXofQ7+eUANQswQrw8lfUEX1tVKdtzSOZo7RF45QLM4hE9PXUXvWTdJVIRgd8h0d0DRDdpEFZ4YZ2rOIV/e9zD9utw9MwsiAEyXRDasvajoNBk8WII7RRzau6n9riSOExBP7BKxfkDglN02E+ZuSWbbk6IL4P3tCK8zwECbgmOkPKxtBD+A7Axn78FAztt3lW82d+QvzpGu2IIkRI0FHCLxVa88w338jv0dU6uesk/glntwnn8i0x4ZrA3K2B4HspTN6npiuohzqQQwblVEnAgiVk3xo3FrgUGqvrDlzCxUggT3BNzPa3GfzJIkKv6YiDTrh+l8cxcTTid+bkR2YmOxnR/0UjSgC/4/PAKU56ykEFmG4Qb9AYpV8keK7X9ctMc5q87g3vs1E2CwoLCR+72RWoYj95Uq37DO3f4Rzr2oePRecq7xTYBNl2jV/z6nxb2jtjpP6lVzAvJ+EJwyaQOh6DQljxw/G18jrvVQj9LqNuk0C3cdgQ/skgWUsuMd6kR70C7dv7Ai57fjfHE5xZZqNFpA3jN+GfAtn/GieRVOPQCRON2hpPxwMQUkveGPdoxQtA
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7P189MB0807.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(396003)(136003)(376002)(39840400004)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(2906002)(86362001)(41300700001)(36756003)(38070700009)(6506007)(38100700002)(71200400001)(1076003)(26005)(6512007)(2616005)(122000001)(64756008)(66446008)(66476007)(66946007)(76116006)(6916009)(316002)(91956017)(66556008)(478600001)(6486002)(83380400001)(44832011)(8936002)(8676002)(4326008)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?mJuCeSZOfJTLZQsU1Vw+rauDKhtYrgUJqC9alCufceS6L0Z9hMUxqt9gY7?=
 =?iso-8859-1?Q?bnb/eKbNVK8lQrGrk0VmvDi/hba8Mm5P4tXLpIpNCSTrbfIlQZFbHD7Ej3?=
 =?iso-8859-1?Q?6dw9DIXS/KyOry1YtvdPPzi3BszTVyTWtshyJ2I2sU1psFF5l+Qy7pCYoS?=
 =?iso-8859-1?Q?m222xs+z02KPzupmujZzYZr4UXyrIkYqxtIcNCPrMPo5DYiyc8FmnIOEWr?=
 =?iso-8859-1?Q?CG2G0Oe9IR7ArS/4HivF+y6avJdcCh0/cTTgfUkn/Xm6dqFyBYiDS1NwtE?=
 =?iso-8859-1?Q?IuH5wCzy/D17MnyhUrrajAxHPu9bhz8k1UZb0SfEdTIQb5oZ+Ock+2Nl6I?=
 =?iso-8859-1?Q?YZJkq86ZTQ2ENvjruMIRBrxVNbHVA26w6anPWqX2HPd4uUqVuyCeVtyJrt?=
 =?iso-8859-1?Q?ltcAVb5SuSAjVJq67LPxNEWGeTBSgVmi3doFqTCESo/ViAx/tLJ0HQhC3u?=
 =?iso-8859-1?Q?+opzF8h5xQ0zeo3jkgAIJsHjygC9am8INhP7enfb/kNXgOla6iQXre13bT?=
 =?iso-8859-1?Q?R/EJRRwsekpw8kQZcHggOV5VZ8m0RL9DaKAtvvTaxSnt13W32JdYR8jnSZ?=
 =?iso-8859-1?Q?I+YHMA6Z71luNCa7NPY7lJmDlw9kr30teiB9Ug7a4UkA0OKktkBqh2zyqs?=
 =?iso-8859-1?Q?R6CsGHKyfDBGMmRibdnazfOQvyghApxAyK2Naf9RFda2NqytdjpsFObw/z?=
 =?iso-8859-1?Q?bz0uc/cnsUA4NL2AlRrW8ICo96NhbSD+L83IkltR2FrjmbuZMmfSabF3WP?=
 =?iso-8859-1?Q?Xh2DbCSup5jX9H6lwJ6DDh0WGs2uKwZZiy7xGNexzLuB5rTzPdGCYDtiLf?=
 =?iso-8859-1?Q?2FyikDuJdevIjmAB7mka6+4bot47QQfyE6TymqPVTpPxqvcAGH1J8VuW4E?=
 =?iso-8859-1?Q?52yk8LWy6Se0kFuoD/ifGq9oznbSHS9VZMOeKVJdzp70eTQqnCFnTTy1oj?=
 =?iso-8859-1?Q?yB5j4aHYoMYYQBgNc0Xh8gnTs9q53JUiemjSiqp9batL+JusVsVppBzh1x?=
 =?iso-8859-1?Q?fv3KOytm2i6JgOPSmGrGoap5BZzdhMpuPDvXYljPLcSWFgqYVxlMOUolDe?=
 =?iso-8859-1?Q?F8nFjVHEtoW1LtHosD2e7Nl3Pte6LnInLwGG4oIWv6w04H+W6rJ1MbPyOj?=
 =?iso-8859-1?Q?XHHCC0Y+pwy6nFScMnn2LNIJEpYEPd1ChI1xoayuNYbsgOnzAmRPot4IcE?=
 =?iso-8859-1?Q?f56dnluRr71SNPXWVFxh7JEl9tKdmZieBxiJ/Ycn7HJh6+TbIQG4xygCNS?=
 =?iso-8859-1?Q?XPQUobCpD1iEarqLXkSOvt+clmkJA8hn+RvXth4FdLXqNVG3Iyi8L5kQbg?=
 =?iso-8859-1?Q?AhVXKyNrglT2QpDUrskhRQBssbhPWsaJ8DLzFVUoixVaUAfWWHzP3yR2y9?=
 =?iso-8859-1?Q?EJoNcZCUl4tcHXUL9S7iceZo2awS2qAZgDC57hYQc3M7xn8uLgbuaT7gdj?=
 =?iso-8859-1?Q?FrYYt/J7G3vzikgZCOHgC9oVX5dMDO9Xj45OiueuxdHxpTRMSi77ny52DI?=
 =?iso-8859-1?Q?JKlNOmtPv9sflU/5EVoB6RfuLR9n5CaoflXB4juK3jG9U+bVpAi32UjExA?=
 =?iso-8859-1?Q?TPavWAeWK1CGmZzGkAH/64hacLJbfDpewgjZh1aQvXFPovWRSjjMxcf1WP?=
 =?iso-8859-1?Q?WgUCKjJMioL2T/qBG6jOpWANfmt7ONotiJ5Hc7m5xRk6b2y6qfa2aNZA?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM7P189MB0807.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: bff398ff-86e0-4dde-8753-08dc1e027bca
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2024 00:05:19.5389
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pCvOkRuWUxcTzRwc8c9IF7ZLxDCdQrQhqIWhYQ3jc5kWF+Jrhlapa0vhi7U8YzqnTi9wJ9CaRtrb8dwbn3klRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3P189MB1050

Hello,

We have noticed what appears to be a regression from v4.4 in the DNAT
port selection logic in nf_nat_core.c.  Specifically, we're expecting an
iptables command like

    iptables -t nat -A PREROUTING -p tcp -d 10.0.0.2 -m tcp --dport 32000:3=
2010
    -j DNAT --to-destination 192.168.0.10:21000-21010

to DNAT traffic sent to 10.0.0.2:32000-32010 to
192.168.0.10:21000-21010.  We use the range on the LAN side to handle
tuple collisions that might occur with a single port specified via
--to-destination.

The behavior we're seeing currently, however, is the behavior we'd
expect if we were passing --random to iptables (but we are not passing
--random): the DNAT'd port is random within the range.

Through my naive debugging, I've arrived at this RFC patch and have
included it mostly to illustrate the behavior our userspace is expecting
with the above iptables command.  The hope is that I can be educated
with what other folks expect the behavior to be, or what I can change in
our iptables command to get the behavior we're expecting.

Thanks so much for your time,
Kyle

--=20
2.43.0
