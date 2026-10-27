Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.186.79
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793121626;
	b=dzarNn1hhcQjBojjXNqUoAP0SSgdAC3N/eiZm4+7WvaMqatD2KI5lbBn4BT2S3olOhn9
	 aGKzhpy8ax+0ql9UGY6Adzp/EzJ5xQGTD+9NWK3e66QGm6aUvY42c8NvRaWtQZc4mL+sZ
	 LZjjFnogWOLuRNA/ivrkP/PbuHcirej2ly7RiMQoTaeyk7krNLHZSqnNYU1QF7+S7wEuP
	 T9UP8msnuodAa56z8TvEtEpaz3QCasQXi5pjFv7HwEipH+7hSZO01pxoOqmugZxuX/dIc
	 cqkyeoBALPrOxh89nCovDP1tZTdIqXJ663AixjR355jSyiPimvlcD1KYlQL9SpaQnSQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793121626;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-ms-exchange-senderadcheck:
	 x-ms-exchange-antispam-relay:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:Content-ID:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=e6ndKKZtMGOT74B/9rgn0WznPVE+E/j5uOQBOC6zLx0=;
	b=fJX9Q+SCL1xQRJygJZgenzBypV4xCzhnFx0pBCC52QWE2mnlKnyGJShC+EJjnmiw5dyi
	 GokwLQz00lKK07vkWfPQ96WpdSmpGxbmsJCMaU/3IUcBV91CG+X/Gskltbyqu2JDzGCFy
	 Cplk0V8RMI8deiVXYB83mDMwjfoubt7tVqjvirPUf6msFVGM1kvqbaa5b8aPp3XkZowZQ
	 Tu+h6WLRd5AtnTf2mzOwaTvnFwj1Y+MGPCZKurRV5Z8HEi5rs3cf7OOHrjs0z+SjVmHXm
	 fmfM1DwAerUqkX6ALT0AXUmf+8yX9J+G/oUw8AiFuPAYCNCqSxQyLi8vO/m4vneHj1w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=student.ethz.ch;
	spf=pass smtp.mailfrom=student.ethz.ch;
	dkim=pass header.d=student.ethz.ch header.i=@student.ethz.ch header.a=rsa-sha256 header.s=selector1 header.b=MwCjzqdr;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.186.79
Received: from ZRAP278CU002.outbound.protection.outlook.com (mail-switzerlandnorthazon11020079.outbound.protection.outlook.com [52.101.186.79])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41887606A31D
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Oct 2026 17:20:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41887606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=student.ethz.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=student.ethz.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=student.ethz.ch header.i=@student.ethz.ch header.a=rsa-sha256 header.s=selector1 header.b=MwCjzqdr
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hX/ko6inlCCyZOR2ljVlmKaZ3zlJ/fSjhpC4MEa0atLd0oJlNkOyIPRahcmMZjgNr0NRDNTJvv3+nsuEp4idWhtCLAVsfTfdSrBCyiN2LJfABIaL4ZWdHfo9jYiXZRe7+tdY2YJFO9qv/1fOE73gWuLZh30Cpu11gOqBEqlyOSh4fDAMa/wlOFzK3ykIRu/KenZoh8g+w9U80UpmWTsNnqGpKm4KGDseCVXJTQcpyPdiWDieCGRlQqI1t3c3bDjGt78nH+TX57+fMRGdZkuhOt1hZ4VYX9TrZtmofrgzJmEmEn4A3YwdjuOxV0A3kx5DalJtbQTakMWrGgORGFp0ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e6ndKKZtMGOT74B/9rgn0WznPVE+E/j5uOQBOC6zLx0=;
 b=S35wA2ZzP65HiTBJBdsUSNrs5ecsHAaNj9thuoBieqyV9uL7/8l9ifYVT17KoSHHIdM2uJ79Bc1OZIwFnROQANXdBZC80hj8pw75iauRWjfz2jfZrzQHYjkYPiQaTKM8/ymxZ4309kw7C4XIUshAyb6jwmRbKNoyJqZkRUUoXdAAQopMg92HlzEBzGTNJHWT9l1jn7z0F9h6aJ4h52uL8NpPjvUruFAHAGYXYTOEuHMmM/WSeu0Ou4LMdmaQzKGujds98Kh6FtYKpPJLSFGyw7w6cS6thdfsUbJBfBtNrv6+2rfjmAAr9RmPp7bifCsiI27pbMc9mLPAvOlLcSY0BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=student.ethz.ch; dmarc=pass action=none
 header.from=student.ethz.ch; dkim=pass header.d=student.ethz.ch; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=student.ethz.ch;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e6ndKKZtMGOT74B/9rgn0WznPVE+E/j5uOQBOC6zLx0=;
 b=MwCjzqdr9KRj5xZQ8UbnR6i4+u776uC3d4jdCzGEevsVvshv6NHsZ9TMUzCuQA3YxK2SVTjg0tZfLh2+0tTE85GYMwa8z4bDrJqVgtj7oBQecGwMMqhDclGbjQuczsmxHUqmc0snrsUf5oH/pYKvLRPDMcmi6F8zE3VQ64gSrgEuLT871cEa1MiFAGIxvBjUVGvSAPIEeoMMJbcc8vFKWlBI12aUSvFHK7iOIkQ5JBwroXlH1g26OSugI5IcER2xlGi9jcnunZjK5+wCTxodd2qtCUFuvzck4QMZIoIpXccAAric/uzLc564YpZQxhJAVJ7cY65EvamgSO4RTsgMJQ==
Received: from ZRH2PF31110D8CC.CHEP278.PROD.OUTLOOK.COM (2603:10a6:918::20b)
 by ZR1P278MB1024.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:5b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 17:20:20 +0000
Received: from ZRH2PF31110D8CC.CHEP278.PROD.OUTLOOK.COM
 ([fe80::e2c5:87ce:d2d2:97fd]) by ZRH2PF31110D8CC.CHEP278.PROD.OUTLOOK.COM
 ([fe80::e2c5:87ce:d2d2:97fd%3]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 17:20:20 +0000
From: "Finke  Lennart" <lfinke@student.ethz.ch>
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: "linux@vger.kernel.org" <linux@vger.kernel.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: [PATCH] lib/ts_bm: fix missed matches with TS_IGNORECASE
Thread-Topic: [PATCH] lib/ts_bm: fix missed matches with TS_IGNORECASE
Thread-Index: AQHdZjdx/dBeHuNj00Ss2+HpEJDA1w==
Date: Tue, 27 Oct 2026 17:20:20 +0000
Message-ID: <48F87C26-7D3C-490B-ADA1-2FB0E3E10F53@student.ethz.ch>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=student.ethz.ch;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: ZRH2PF31110D8CC:EE_|ZR1P278MB1024:EE_
x-ms-office365-filtering-correlation-id: a2057371-992d-4806-7581-08df344e93ea
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|10070799003|366016|23010399003|1800799024|786006|261009223027099003|261022105027099003|261021121427099003|261021123027099003|261021130227099003|261021133027099003|261021135927099003|261022075727099003|261022115727099003|10067099003|56012099006|261022113327099003|261026121527099003|18002099003|261026135527099003|11063799006|38070700021|261026140227099003|261026130827099003;
x-microsoft-antispam-message-info:
 Rv3AgqM10vSLBO2XTxaEuSZD+RErHJ7mX8wIDjRlJNYAJywrwfa+xbufexImRmk7nZKs7GgTHoOF7mpJkNbhf8eg6v8o0z7UpJ7MsH5TR0ryoLB5dcR/ffLRnnt+CzJi9NZ58Zgi6PhRFiAQWh6lFi19mwCCESWU53nE6fmk5L4/fj0F+hiUB8nqax9+I35X304CE+RgbgnA25nVGSUPMMxGKnWzEqMk/+XgE+jW4DZ+IULo3s3cTy2ClWauQjXbtP/UqchVmeb3AmVCDslvW5RPeTA8aieC8tvCdXLOvP1uP3S63MJYeSFfZIY89hNQLWMidFsIexGkR3mIDOmJwFgnT0xRw2zRm6jn4JNEMhrUD+j/VoNxfMDQo2Vj/VSZZzFoJl+f8V+J2vUAkib6v2butXN/vSAoTeMVo/XBc/4Q5t7HvmF3Hb7yk/fi0VrZ/u4MZ473aCTRtriByeuV53AF17d0QinAtgdeqA1Yjw9eN/KWpgaRtVIt4iD+mc9FqOklk1bCTRaMtyAKPWhT8B2yd/wQAGcQ5YQT2+dQp75+GuBVRDQhbJ0jc5Ict6ix6vUF5N3iYJMyFcEglDwheDY+uuATlidJYklav4uio7Nih3n0nbT6ET+GJcBMqxKjxXt8B/6EhYQK6pMU7QKXzpCyufFaVfQD1VPj4/Dej5x26/ULSQs2Kbju5Z4Bk3aK0GLRW/b19NzrjMf6Ni5zgUfPn9wZVd9O7l9KJ44WxHc=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRH2PF31110D8CC.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(23010399003)(1800799024)(786006)(261009223027099003)(261022105027099003)(261021121427099003)(261021123027099003)(261021130227099003)(261021133027099003)(261021135927099003)(261022075727099003)(261022115727099003)(10067099003)(56012099006)(261022113327099003)(261026121527099003)(18002099003)(261026135527099003)(11063799006)(38070700021)(261026140227099003)(261026130827099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?yGUmLBqE/qJmhl0z+dW0sYPEsFaUMbrKm2VkPpEROAa1nsAS5hIhj0cYhXIy?=
 =?us-ascii?Q?8GzEW9ZrDfIiF3Ylbi9VvCp5aNv8xn0JP6WXLA6ohq8/5X46Po5f120fxkqT?=
 =?us-ascii?Q?9LGMvnnnvAlyyyaCsNTlaMFYVCwTGSr2HNtoa9ZD3xj4A9BWXfz57D1wcteF?=
 =?us-ascii?Q?9qWsjR88rt9LEUbwqUe40D3zKrb3m2/v2VtJOg8lRaAoORlIEl4Yn8V8m/BG?=
 =?us-ascii?Q?sUvlnXESgFv5uNX9w1+YnBvB5Ib8q0lfDIeg3mVBmEc1LRtzflB0DSkh+URh?=
 =?us-ascii?Q?TBhz1L2ZNBu/ZsOez+LNMNIFB0CheB+lx4UUChHzDZYfWX66FZQGklpsckSd?=
 =?us-ascii?Q?vIq2t9kuDvDGpaBD1eHnwiGcx826ckAFgYP1EJKX5AzheUDacIllrkjzq3qj?=
 =?us-ascii?Q?c+uQA1D0URFOUahgdQLZyVADQWJRiPlu+6j+qZKArFW13ADlF9zPZqB72pjq?=
 =?us-ascii?Q?OEcj0krdyyYGKKYLZHrSh5xkpm028edm0eI/jzQafRQ21ZFLFTJYlBaET6z0?=
 =?us-ascii?Q?hzm13SsOnkfDbldVdLLwRzQbR7Y6511ammjalrgmNvLLNKSMm37j68ckA18z?=
 =?us-ascii?Q?kkS+m4+B0M/D0wql/OMYZUDun26tAPFUcAyfbvVtwoTndlrq3sEwUOsal5jH?=
 =?us-ascii?Q?jCR7eSoLT3/TetgTzth2dCEJ4Qe9zlhnQRvn7RZvkjA7PJ41qhdgu1Eldykx?=
 =?us-ascii?Q?BJ9jO8pQOL/4gwLIAJRCmYTISYs2iqcW10I3Aj7wtiWj9dESWMt11crod+ju?=
 =?us-ascii?Q?5WIGD8T36WA8w2K1boQFMuTqLcyGcGARmohtJiHrsABNiErMqZvo0NQjfxAe?=
 =?us-ascii?Q?kHFqBi7BLdJpfPO96jVPgTPOvCCki8Iqcr++zosHOwvE6xt/zHu57qTjZHfJ?=
 =?us-ascii?Q?UbgKJCbYKVjiedmRap3IjqTwrDW+Ws6Z9Gx1ONS9OSJ1/DMbnlGdrQ8mrZgD?=
 =?us-ascii?Q?Qm/bN9czhlzzfzLrFBIu8YNpgkyf0OjZ8pS1/oVmrZSpbLA6/kSxWPqs8uXI?=
 =?us-ascii?Q?nYc6AtcWD2n5LCI3wxQxUevVB3vBvwKiBJUZAeE3LBjoOgvxJXULbwyokewf?=
 =?us-ascii?Q?wDM95uGG6QYHyb3A8N8EMGAMGWrbh2UuTKaJiwwCzhp0NtRRmTHlGujwmKIb?=
 =?us-ascii?Q?+f5UjZKk6z1ALCaUnnHGMatMTkZ/Np4IigMOPGMjtRdU0N79jx2+dZa3BPV6?=
 =?us-ascii?Q?AohqavuCRPESiMn/XQ8Ipi6Cg/hII7VGB40NAneU+6aLTz+dEW3vbJJl3Xr0?=
 =?us-ascii?Q?HZvr7OAiBh8qgJxfbs/fYD4vZ/23RSy+SztRMn65GkfzmqgjPty2Rn074MMK?=
 =?us-ascii?Q?NkcuqXAnsOSKs0QlPxJJWCAnUCEiqiKaXeJr26dOBPXNIp0t8xIPryPnBvaI?=
 =?us-ascii?Q?6Fyz58hp2/LSqAV5BxYb6tX9ZGbbZbnjaMJ0yXYV5XmZQCGyPpTPsL9DVxvZ?=
 =?us-ascii?Q?+Y0zj7ZDUJwFRyyKK7lJDGA5A/F5AGEvjlhD/rqiX9+IhmidKzPvzFJIE2eL?=
 =?us-ascii?Q?8qouy+9POnB3iyRs2Br4AeJRnKVEEjqKm/685hthX8/PFDKBHvS/jYEG5H03?=
 =?us-ascii?Q?4v9dMQ6NAPDHBW6B/V9KWSy1uu6wHXs0TdZ1URr0sDbQzN5LX5eRvAB44thc?=
 =?us-ascii?Q?uf5qN45Tc5Yo/S6FLd1eE16ZYt7Zjpo/91cSpz6q3qieOMmordIaHmLz0Izr?=
 =?us-ascii?Q?zXwzdYUbHvRxt4uTdPzZVAj0pGEIul53hhJwUePX+w7PX2UinNEbBzOGsN2x?=
 =?us-ascii?Q?34OojcAj5g65tc8vwX2IOj/AqOxs+zA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5F9FA4EC952AC5478FF9125205301DA0@CHEP278.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-OriginatorOrg: student.ethz.ch
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: ZRH2PF31110D8CC.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: a2057371-992d-4806-7581-08df344e93ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2026 17:20:20.3334
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9634a6ec-a266-45a3-ab14-74c4211fc582
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hs3SUnc7FhmvI9ug/7f+/SoLVe2sNtNowPtudTjl56Ps5ikHY/noDsmAq95oLVZ9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZR1P278MB1024

With TS_IGNORECASE the pattern is stored upper-cased, but bm_find()
looks up bad_shift[] with the raw text byte. The extra tolower()
entries miss bytes like 0xff and 0xdf, whose toupper() is a different
byte that lower-cases to itself, so matches are skipped: "\xffZ" is not
found in "Y\xffZ".

Fold the text byte with toupper() before the lookup and drop the
tolower() entries.

Fixes: 3b76d08190e6 ("textsearch: ts_bm: support case insensitive searching=
 in Boyer-Moore algorithm")
Cc: stable@vger.kernel.org
Signed-off-by: Lennart Finke <lfinke@ethz.ch>
---
 lib/ts_bm.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/lib/ts_bm.c b/lib/ts_bm.c
index 676105e84005..f809aa05f5fc 100644
--- a/lib/ts_bm.c
+++ b/lib/ts_bm.c
@@ -101,7 +101,8 @@ static unsigned int bm_find(struct ts_config *conf, str=
uct ts_state *state)
 				return consumed + (shift-(bm->patlen-1));
 			}
=20
-			bs =3D bm->bad_shift[text[shift-i]];
+			bs =3D bm->bad_shift[icase ? toupper(text[shift-i]) :
+						   text[shift-i]];
=20
 			/* Now jumping to... */
 			shift =3D max_t(int, shift-i+bs, shift+bm->good_shift[i]);
@@ -130,18 +131,14 @@ static int subpattern(u8 *pattern, int i, int j, int =
g)
 	return ret;
 }
=20
-static void compute_prefix_tbl(struct ts_bm *bm, int flags)
+static void compute_prefix_tbl(struct ts_bm *bm)
 {
 	int i, j, g;
=20
 	for (i =3D 0; i < ASIZE; i++)
 		bm->bad_shift[i] =3D bm->patlen;
-	for (i =3D 0; i < bm->patlen - 1; i++) {
+	for (i =3D 0; i < bm->patlen - 1; i++)
 		bm->bad_shift[bm->pattern[i]] =3D bm->patlen - 1 - i;
-		if (flags & TS_IGNORECASE)
-			bm->bad_shift[tolower(bm->pattern[i])]
-			    =3D bm->patlen - 1 - i;
-	}
=20
 	/* Compute the good shift array, used to match reocurrences=20
 	 * of a subpattern */
@@ -193,7 +190,7 @@ static struct ts_config *bm_init(const void *pattern, u=
nsigned int len,
 			bm->pattern[i] =3D toupper(((u8 *)pattern)[i]);
 	else
 		memcpy(bm->pattern, pattern, len);
-	compute_prefix_tbl(bm, flags);
+	compute_prefix_tbl(bm);
=20
 	return conf;
 }

base-commit: 21a7f44fd0765fcc5194130b28767786eba1d1e7
--=20
2.50.1 (Apple Git-155)

