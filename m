Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2094.outbound.protection.outlook.com [40.107.8.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4772264F
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Jan 2024 00:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.8.94
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706227528; cv=fail; b=nPr9mGzVgATVAiC0SLI5ukoaezb9TIyO0QIB4bYyC1Q+kmLMuTxM1oaHKU3FeyjFFZjjKJLqnIUvtYLra7oVoYqA3VHjxNiUgefg+vMB2cZFJaGA3/FPIzS9EzJx6G3YVoGLpjWpx9pZADZiNUIYx0AzVrMw1FpNa9pKevlvxAI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706227528; c=relaxed/simple;
	bh=LzXnN3Tbt8zPlgp1oO7IalTDdWEqbxhZMmKEshxDp7A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Y0WT/VA+ibW6JaimITk3yNe3xetDZfIDFoGZJqnVFhjat5NNQL0CFi9eO4XvVwuGHS8roYnypck2WgE7XxzXQ0PJDHoyMh+eSlZSieUcMqQwSo3df0ybyfmB0PfV7jfEIPWYNJCNyvoJSWxu5YXKVkWRnnLLrr5tfrwdj89BB2w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=est.tech; spf=pass smtp.mailfrom=est.tech; dkim=pass (1024-bit key) header.d=est.tech header.i=@est.tech header.b=H46rIyiP; arc=fail smtp.client-ip=40.107.8.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=est.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=est.tech
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=est.tech header.i=@est.tech header.b="H46rIyiP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PgRWKQUSuxYXvrW2FB31sn7WBP+EzZkVW5tXosYWLGcaRnHYtKw6hlfLj9ERXeCKGe8Pp2HYP8xNGXYVIvusGPG+7oohmyggsrPKTLXFVTXPcPxT1BSwwBWkxLqKQMjh392iPjpdU/ps2E+jha3APCLFVxScK+HzD0krL25q9orN22NnJrc3cwJtAgw3JFyDBQihPe4FnyXgzuIF+XARk5j+t+yxhT+EBVHKPHQRSCE4S0Xetcb5SiCwfOn5bnqgV+9p95PB6rpiMy3K1EtWkUbTOjXZulQ4zgWG2ksK9ikeK8NWseb7X6Amw8MnwA+Gik7v1rp8B2khrKvxTfX+XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UZDeHATz0/xW0iCBAVzP+toWj/5nAHWvXG8CaUJXSog=;
 b=I7nv15U3MVJvxfyGqydrMfkaNNnljwnXRMR70bFgaD1YfokzwdIvoyMwopMXRtyhAOLENdb6dNv2RCV5JXRWF2ja1XK+MxFjoeFzZoIB1q6Nitx4qbMkPwJ2bOLUuV0UxXiby7Y2RjR9Lv8vhnjVaKChPbWl0nogmbJF346bmGdrc7l8sJ5mvO02+ueuE9q1ZI7GBx2e/Td8ubA17DaNMXp4+sv1F4AgPUcJfKXjKyl9QkIDtQwgPsFQD8yS+4VC9Rmp2fDtKgGwj5QtVHwAIp+pSyWdQeJH0yc2sh2qkeND0MJXj49zuGq7JgKVO5JjKBW5IlBDVOJ1V0/XcA9riA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UZDeHATz0/xW0iCBAVzP+toWj/5nAHWvXG8CaUJXSog=;
 b=H46rIyiPliolu02JhtVe7CaDi7WBo4cztG56tPoxEr32levxF5m2LwML2SxHl4iBpPTP98nVTXMEvMBszPbcmmckf+H0ZVgube88vahzjAaeYxDclNodntiSvlXbUfV7YJkgai4nobr9p+XFlaoc1UbP4ocwz8+wSukSNGLOJlQ=
Received: from AM7P189MB0807.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:115::19)
 by PR3P189MB1050.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:29::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.27; Fri, 26 Jan
 2024 00:05:24 +0000
Received: from AM7P189MB0807.EURP189.PROD.OUTLOOK.COM
 ([fe80::bad7:18c9:a3cd:6853]) by AM7P189MB0807.EURP189.PROD.OUTLOOK.COM
 ([fe80::bad7:18c9:a3cd:6853%3]) with mapi id 15.20.7202.028; Fri, 26 Jan 2024
 00:05:24 +0000
From: Kyle Swenson <kyle.swenson@est.tech>
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
CC: Kyle Swenson <kyle.swenson@est.tech>
Subject: [RFC PATCH 1/1] netfilter: nat: restore default DNAT behavior
Thread-Topic: [RFC PATCH 1/1] netfilter: nat: restore default DNAT behavior
Thread-Index: AQHaT+tcFeBrAhq3cUGK17abn+K/+A==
Date: Fri, 26 Jan 2024 00:05:24 +0000
Message-ID: <20240126000504.3220506-2-kyle.swenson@est.tech>
References: <20240126000504.3220506-1-kyle.swenson@est.tech>
In-Reply-To: <20240126000504.3220506-1-kyle.swenson@est.tech>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM7P189MB0807:EE_|PR3P189MB1050:EE_
x-ms-office365-filtering-correlation-id: af97df32-ad04-4366-0aab-08dc1e027ecf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 nTszY2Rbg/OljV4i0iLjntse+BGj41I4IitnoHVSY0pFWksmQeKCT7RYVQnO9els+Y8MMkQnSV4t/t4OvQA8/8s54TOmVbjYWDv8dWQt20snEFETdhUSHHnN4Ro2ihSfCdgZQMvJcgtouboIlGqPfhEE59X3rvPwq7QB3SOiywrRE11ebJklgzK4dF8fVmq6IQwnoGTUurpvAZ8omzYAzpchmdqTVF4iAZ/ZOuTIxgIrGve3pv/2TW4sg09aRKTz/D3YSoJfnFvJG4Z9bBoivjzleuR6NiqdCDY3nc/N7DvzqQRRHI5frdW+dyreeUjVIs03ZjayqfK/BKfpwqUD6dTEZzhIZ3rGxBHxc/iQgtBnvxWAbZGlAAUTRtjv7G1p6FicwJGePsw+OW/j4ZN6x0pdWNjiQ8xAtr57w2S9A7PLnsXWVk/FV6W2GJAoV4SB9pmuFCKXP1ZevNhE+kr/LluZDXSZcvPDbp9Xuu35Lpj+psBrKqijCsDMMVj66n9ECxDTHi9i08rGKlsgxnFxTc8bIx/ybV8eXx4WT1/4h4lkPb/gJf970GpUB9V5EiDVMfQujPFOahdYtI7ah2ymY+rHw6bI5bqJdWQwK+nIf1D62SCM1KjEawm7zo+QDphA
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7P189MB0807.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(396003)(136003)(376002)(39840400004)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(2906002)(86362001)(41300700001)(36756003)(38070700009)(6506007)(38100700002)(71200400001)(1076003)(26005)(6512007)(2616005)(122000001)(64756008)(66446008)(66476007)(66946007)(76116006)(6916009)(316002)(91956017)(66556008)(478600001)(6486002)(83380400001)(44832011)(8936002)(8676002)(4326008)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?3Z7XAxzwYu2vAhlz+WdHgHuET9nT7kpORRZCv8yC+ePFM6CvMX7ivNkv6b?=
 =?iso-8859-1?Q?5kcK1gsVUw2fkHxOZPm+lYoVEz5H9wvkGYMxSc2tqx0yIxYYzrZjcCPNCW?=
 =?iso-8859-1?Q?KDyhb39eTfFADyl1QbT56p8CCq9MIn1GfYDSLeO0KnKgTfliAZokjNn7W7?=
 =?iso-8859-1?Q?uHuNAlAP+wNlcoDBGqo4OmotmohK03SShr+tvOSXy8F5pnf4LIlO2o5J6I?=
 =?iso-8859-1?Q?hx16PuGJg6vQ4j6t2Q/zl+QTRY0jGD0kPwR6xFrHsbvhVQYQFhDex1MgKM?=
 =?iso-8859-1?Q?V6BODbLBoZQvJO0KiedCBuNb2D/MfBiBDauk1TqSgDu/Q/VaIcVmcNc7pf?=
 =?iso-8859-1?Q?TilPSd4xs8Yg2jZ2vuH+uTbEArROfdSLk/Ct/nssdO7xiJ//d5Ic8bAtoi?=
 =?iso-8859-1?Q?yPQzOc/0kZF5eOBz1rw9EyW/FKXWhuCec2Fl+4oqSEFPGe0XLdXlzImG+8?=
 =?iso-8859-1?Q?amXndc/rYGjRaEHEYxeTEXuZgzRaL+A926VTGenLmCv3+ClVIvL3kthsG8?=
 =?iso-8859-1?Q?Gk0UAo2GhPfnQQP0C1vdw4bXqDnN2asbkAYpFwhci/sA0aV5t9e/TbQ8JL?=
 =?iso-8859-1?Q?E/pHe7WSGtoDd8szYXTuCK0TdbeXL2fL7wWPf3E/7v6oIxSzFlWDWd4T6q?=
 =?iso-8859-1?Q?ZcmZUTbR+Sjpw6SE+itSWQaPXlE5IcClJ3YSJM2NkTiTGkurfoW+Qbq8lX?=
 =?iso-8859-1?Q?B9SuuqeRHPBS18evYD7HJOUgM3bifaDkUoNy45Ph+5KCVXL3sra8qxx2vl?=
 =?iso-8859-1?Q?lDPi9KBt7sqlaM/KuLPZr/Os/j8QIORghdQBNiMRxB0g6cAePS6iMrHdje?=
 =?iso-8859-1?Q?BfhDuN37N+0W59UIS/p3HFCx+rDB8HOensOIxpaUNf0Dow39lYR5xZty4G?=
 =?iso-8859-1?Q?kEXSQPNqmyKabl+cECeEVEj5J7HmuEq7Y8o/zKNtvQLVUlby+IS3fpL0Q/?=
 =?iso-8859-1?Q?GVtx/s8bB/Ta9PlGfZCeYjJKXiPdfUCAtImNne01mtwRy6XWkjo0w9EgC0?=
 =?iso-8859-1?Q?zSuUG5H55xW402wh3uPZDuiwiBf2f+RUNtlehTSw07CNX+OG5Rjmp5ZvdU?=
 =?iso-8859-1?Q?z6Za7b4/+r884XcgKfGe8IGSWhWrAY8LofDghUfNDbrhLYkS8rtdUwvnn7?=
 =?iso-8859-1?Q?UyqnzRFmIsizomDAT0bybskreYRpyMBh0+aZUcKpEGVd+v+h9W7C9nGebJ?=
 =?iso-8859-1?Q?otmmYhPLFmpeGw7WVgGATeS0pQGEun9ytzLjlc+L+ZnpsSGMK0MJZ/7clQ?=
 =?iso-8859-1?Q?zOOpJg20NLNaymZ51l7gqH6ytKHKpeVp39S3EKzMfSq/YwKD4PNmjnPPRG?=
 =?iso-8859-1?Q?/EN1CyW1kduHQ557ijKEDJUpPkeXMnhPvgg5eo49H2cv0n+8GrHOliXbNj?=
 =?iso-8859-1?Q?YwvxrbjPmlC6o2eI9UfMVVgSiuXmF3JerxLv7yrfhla3Mi5BnpPjHnDs8h?=
 =?iso-8859-1?Q?MEiq66SKL1OfuHRiclXp8q+aSiQNyNTXdX/w7HuJHURO2hNDu1SojPKvRV?=
 =?iso-8859-1?Q?at5sAcGES+ufiVEd1qaKwlJz6oX7mQmM7+yMiWkNNyqwQ3IFvnhBueeuTM?=
 =?iso-8859-1?Q?k4F/3VihDMHOfENVSvzmrFzpemaZhMK7tSbDQvSysr9ps26wd3+xOzRDW5?=
 =?iso-8859-1?Q?TjdE3BevYEVxL6V+jRVyxS4mxDTjj7rYku91KPq45Qps1Cr0lOPXP4IA?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: af97df32-ad04-4366-0aab-08dc1e027ecf
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2024 00:05:24.5617
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CN5qHgWjdD2XUp8mDslxkSoVub0H2q9d5RIGg86n64NE+HtjlmC1QVVBHNCc72HFSMCMl4m+jHBqJc0lOWcDWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3P189MB1050

When a DNAT rule is configured via iptables with different port ranges,

iptables -t nat -A PREROUTING -p tcp -d 10.0.0.2 -m tcp --dport 32000:32010
-j DNAT --to-destination 192.168.0.10:21000-21010

we seem to be DNATing to some random port on the LAN side. While this is
expected if --random is passed to the iptables command, it is not
expected without passing --random.  The expected behavior (and the
observed behavior in v4.4) is the traffic will be DNAT'd to
192.168.0.10:21000 unless there is a tuple collision with that
destination.  In that case, we expect the traffic to be instead DNAT'd
to 192.168.0.10:21001, so on so forth until the end of the range.

This patch is a naive attempt to restore the behavior seen in v4.4.  I'm
hopeful folks will point out problems and regressions this could cause
elsewhere, since I've little experience in the net tree.

Signed-off-by: Kyle Swenson <kyle.swenson@est.tech>
---
 net/netfilter/nf_nat_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index c3d7ecbc777c..bd275c3906f7 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -549,12 +549,14 @@ static void nf_nat_l4proto_unique_tuple(struct nf_con=
ntrack_tuple *tuple,
 	}
=20
 find_free_id:
 	if (range->flags & NF_NAT_RANGE_PROTO_OFFSET)
 		off =3D (ntohs(*keyptr) - ntohs(range->base_proto.all));
-	else
+	else if (range->flags & NF_NAT_RANGE_PROTO_RANDOM)
 		off =3D get_random_u16();
+	else
+		off =3D 0;
=20
 	attempts =3D range_size;
 	if (attempts > NF_NAT_MAX_ATTEMPTS)
 		attempts =3D NF_NAT_MAX_ATTEMPTS;
=20
--=20
2.43.0
