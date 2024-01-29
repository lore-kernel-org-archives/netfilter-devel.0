Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2114.outbound.protection.outlook.com [40.107.8.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC72D1586C9
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Jan 2024 21:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.8.114
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706562416; cv=fail; b=gdtPeiAqrkWsJa6O3cShVpARwIavJZEsspTPkBSJb6fO9yQdDrtghcWuREbmZ3Jix0ZdHitTAz/pH0vnzND52FO8AQxzKkzWIg22GSJpCI0dYBkYquLnWtNRZe6bkqr0v34s4ZR+dbDk0R0cBubchPP9nQT9yLa9vACivmQrX5Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706562416; c=relaxed/simple;
	bh=AwyltsZ9A0CSskZQY3lx6e9/3+sGfFxuj1e9LphacOU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=q7fEpzoFZQCdAUqXWW0Gp0EHpTjTPKYao0LVwSd0NDg4UNZHqjzJy5K0JZYs3M0xejBX0LG/RG3AbU8VvH1QHbij7QMxutuHny/Cj6ePtb6LY/SOTBbtD5iRor7u62S6H41J52GgDrKdjMRTmdQ66f1Y2Fpdyy8gWBb2CBKNWyY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=est.tech; spf=pass smtp.mailfrom=est.tech; dkim=pass (1024-bit key) header.d=est.tech header.i=@est.tech header.b=HHnrYA3/; arc=fail smtp.client-ip=40.107.8.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=est.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=est.tech
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=est.tech header.i=@est.tech header.b="HHnrYA3/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D6LPNrKda+IfS8sYaAcH+PMVv44RtvLkicWV19/dFt9/iyLQbM5yjfSwnC2GGh/t0TF3fuwnPmDlR7MGOTq3QiEiHfZs8yslvumv5K+ksHmFluDtvUPSdnvu/rWpR9oyj/OWk8r9kpCvTYAXfTZ63Lc3wYnuHdr0nTYm6y82sFKTmrzCFtoXp8uErXFs8vHnh2cUrys+qbJCBJ2dOG0VT8M+rFFhBx+9LifJS9aGtEG/pRFDYNNSvmpLgQYErHOC3Be94+oHkYa17+O2ZlkU4qj2yTnPTQf5qNzztNscdHuuv3ov50G4VuCCiGpaLNi0s1jlhZY8ubDPK+SWjLhTvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uNGPjapCAAMKVxU0taf7+FayhIG5Dz8rDI571DzNy7U=;
 b=mkCZWlXvf7ykf9lsiZKAtvs5wzggNeKhF/+/KWqddEFM0BDBMCDWEAAkgZGF4wb2i1udmQVddSwQzY0V3Wvv5LdtF3m38ggrZeEaIHsSXIEQah/l6/gQ+hC+h0HkSxjbMO+TSFP4QUZbTRD6P30vOPG0aEVsbw+DGkycEb1jBg1PzJeBB8nAm1yvVdM4XPURSxX85Igp35xErUUoyyj5riIdPhVEL/WABUiM4oSmgJN3fm2AQ5D8cELPm1vDjc8adfNHCPIc9L0B9COEUz4wfV6htruz/7jHFsdYJY4LZuFysF1ji2Q2Sm6lFeIYI2XRTjb7yhklx3FbhnGruywM/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uNGPjapCAAMKVxU0taf7+FayhIG5Dz8rDI571DzNy7U=;
 b=HHnrYA3/BXX/WJ+znljHgp7JbVP3sgeivsD6BU1hOGohw6gUOezKNgwqXnD/DK4y6d44zWVVrsM4keehczgThk13QuqKr17QmUsmjsjbVIXDU/rmpl2TPlXLTu5Ndz5WneWFr3175Xm6iBHCZhad9WqosK+hthbyJMM6Jz6asMQ=
Received: from AM7P189MB0807.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:115::19)
 by GVXP189MB1982.EURP189.PROD.OUTLOOK.COM (2603:10a6:150:3e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.32; Mon, 29 Jan
 2024 21:06:48 +0000
Received: from AM7P189MB0807.EURP189.PROD.OUTLOOK.COM
 ([fe80::bad7:18c9:a3cd:6853]) by AM7P189MB0807.EURP189.PROD.OUTLOOK.COM
 ([fe80::bad7:18c9:a3cd:6853%3]) with mapi id 15.20.7228.029; Mon, 29 Jan 2024
 21:06:48 +0000
From: Kyle Swenson <kyle.swenson@est.tech>
To: Florian Westphal <fw@strlen.de>
CC: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/1] netfilter: nat: restore default DNAT behavior
Thread-Topic: [RFC PATCH 1/1] netfilter: nat: restore default DNAT behavior
Thread-Index: AQHaT+tcFeBrAhq3cUGK17abn+K/+LDsQNgAgAAopoCAA/zzAIAA59oA
Date: Mon, 29 Jan 2024 21:06:48 +0000
Message-ID: <ZbgTZhKiJ1dfDzOU@p620>
References: <20240126000504.3220506-1-kyle.swenson@est.tech>
 <20240126000504.3220506-2-kyle.swenson@est.tech>
 <20240126155720.GD29056@breakpoint.cc> <ZbP4BFXtw4SPnMjN@p620>
 <20240129071656.GA9973@breakpoint.cc>
In-Reply-To: <20240129071656.GA9973@breakpoint.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM7P189MB0807:EE_|GVXP189MB1982:EE_
x-ms-office365-filtering-correlation-id: 06ae845d-fc09-445e-91d5-08dc210e353d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 R9OzPWpRS4+4TVWV8sRfrRIbcZFY1nAMxIO3AImun8fBuOpkqYBruc6ItPcgYi3aBba5c+JQRWNTBc1YBAmknnTMAsp33RJUvtxIiPUu48docLTPQuwHWsnW628vx7xLnzYw+p2P+vx4vNgrkxad/Rc2cyvOd62xokfhs7bCop5C/IoG/qw6O1yQOG/0Ri6AiUtkTe3D6HDIAM3pgmerq+FIhKmOLZBLswQuD4XzWaWtJjLfhY4efWzDewyZjoqc2Wmo0sEUkLR76X1Lb8FDHpF9IE7dhwUa2kXaIj5R4B9SMh08wjiJ+nC/dHdoHKPPVPv5gqN3uNaEQZlkLJMYkg7Kfa5N/EAczTtUakb2w3tBnwcdKksXQ7fW5G8ZoF2bnESypee2hlYKcWzEYgvbDIZB45RmZWNvZz4ntzvje7S4IAztd/9UEKgvhm7D+4+r/qUyMM50/rvdbHNIGuPb5Gam9ZhRRVRL3bRCH3FdjiqAHg74tym8dI8JbgOz1qz7SlpR6qgs5LW/n3jWbQjLjE9ewCxjIuzoiPMxxkmxD952X9aZ4j8pT0PN2ictvv2NMbXqjKIgVFqs9Pws3vFU/I+VLkKw/W7Efww2ARBJt1sxZtykx4BfjfFqPjcvYz9N
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7P189MB0807.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(7916004)(366004)(396003)(39840400004)(376002)(136003)(346002)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(86362001)(316002)(76116006)(6512007)(9686003)(6506007)(66476007)(66556008)(66946007)(64756008)(6916009)(66446008)(8676002)(44832011)(122000001)(4326008)(6486002)(26005)(38100700002)(8936002)(71200400001)(478600001)(2906002)(4744005)(5660300002)(38070700009)(41300700001)(33716001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?1K+sya37SS1ET0mrYx+kod7oVp/ndZ+nCGhDs43hldQZS/H49fI1pYVTbEqY?=
 =?us-ascii?Q?qHLW/GQupBgLUm9K+0uLXCG4Kb0Kcz7HI2v/M2We3XjlE733JBY24wjL+6Z0?=
 =?us-ascii?Q?mSDR9rwO1DoCdQBZc4CojEY9zrBpll8iT3LYk6FwF0cvE8bSJ3M0s8oL0tSm?=
 =?us-ascii?Q?0e1wgikSwks931rcvntIYDOcJ8DXrgRwet+VFrBNMWQY9uRdmHUAxkJ3XKdd?=
 =?us-ascii?Q?fuoiBcvA+R/DxTS472nZIxcM5euvwtDAtFpTAhfvfwjmvkaEYPPqvfaJWSow?=
 =?us-ascii?Q?rpwBW2DkeOgd6sFhMnWiw3jqnZcp7LrN3DWXebjrGnX5/0D0KaGyPg4bsu6v?=
 =?us-ascii?Q?5MLk17FjR7a8u3DOgWg5q3/i1ZIr7ArtT68tB1ff1mlrjxb9dbohvoeVOAlo?=
 =?us-ascii?Q?VTX3N7Pc75lGyfFPC171OL/c94/uetopfLnQAVezbUfwr1nIIDm2O4yFVtMw?=
 =?us-ascii?Q?0P1bFWTkBnRmMOMAV6oCuzQXUs0wpdNyGF8MneXrIFDGJbAqnkdeTABBe3rh?=
 =?us-ascii?Q?bIm5/EI32mKBvAPsqwnQcliVfVGxgOJRtGsRG1VLO91BSF6aaeNXqF6w+7Iq?=
 =?us-ascii?Q?c/kF4ABqwURFPmQS0UPihetw0yqTKfLix8zH6Z79if/yE50y0JQcN4Xuu6V8?=
 =?us-ascii?Q?112f36rZ/EkgZhpruU7v0IpSb28UnW/8ELPRHflHVbQka32LZrsjKngPUF2q?=
 =?us-ascii?Q?oLGoi6T1+z/KnPHGvf2Jm/QJ+ICaC/fBUUn3vg7INJnqxsLdyMKf6bOJ0ZvH?=
 =?us-ascii?Q?9srwgNq58Xi9Wlq0TvQJUSSpQyRaUBv0UT/jn2/NsOcl0IQbi/C4aRkJLYnB?=
 =?us-ascii?Q?JqU2Hq+xFGY1QrzdTbbDFyLx1l5hQQQaEzU7woUbEq0SBf6Q8MqbFmR1v8yI?=
 =?us-ascii?Q?BmYIwPi25gHr2HcQklOOFIuPa5pUJs+MbkOUIMjBypEPj1gbPE/0KKrTSSX/?=
 =?us-ascii?Q?XZndzcx/3UAqxF6Yc6o5Pus2g4enRJsbiS/FdxPxEAa9q4w3YidsHidKBAoi?=
 =?us-ascii?Q?gRVTwJ5xFVK4bD2xdyYvVORX/CTXzW5GS29H63iZmw4MdZi7ATNyotrNCDNH?=
 =?us-ascii?Q?ZyB5lmaL0oij+rl4iD3GNc+dQXdpYwCw2fk7JYX84K6RbCnXzuAgodSLMvXH?=
 =?us-ascii?Q?GUnxW1KmJVpXE/DRZpiIJcGEQ928TYHhJaXFazwiz/CWNvrWf8cMPbGk7dni?=
 =?us-ascii?Q?iTP4xUE3xBEpwntuU1h7fLRg3IX2TX/HFDiRfddffOZNJ5lij4fw7JR0qZo0?=
 =?us-ascii?Q?al8/FIG3hfRdQx1D4npuXY+MXr2pCdWs1tClDFKKPVoniOBzmBtkYU41nXhB?=
 =?us-ascii?Q?sFnsb2ax0xIxIKwxBaIF3S+W+1fGm7WOsEkJVUgGWg4ohNuCXK4Hdi5YfbOH?=
 =?us-ascii?Q?MbMPurEkfS6KXFswEUFH0WN292ZXLRzTDJ6MxVcopXWdHjblWOST6bMlJ6Ny?=
 =?us-ascii?Q?KqZD/Dmew+6o/i+sgAvUxfcA+cNSc+2zwA21MnItnn9MeDB/hHFauatKlucx?=
 =?us-ascii?Q?oGsQ/b1HafPr1S1yLaNCGO8Y6gH4r8i2xr6kNTD3+O9whZ8c2OfzKjTIkJEJ?=
 =?us-ascii?Q?TJh2LV5xVhRCZR+GeZuUzRhh2XVI1ADOLYriEOIV?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FC6BBB8D302C5F49B62AC3A5EC84F426@EURP189.PROD.OUTLOOK.COM>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 06ae845d-fc09-445e-91d5-08dc210e353d
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2024 21:06:48.5723
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2zmRKV/wqadyPR3dbtEaJTYfbIPJFmAMkuT+zGXTsy/h6nTYj9TFVvOx0ZYnfPvhDwIuXndPGNEUYPU/HnlfSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXP189MB1982

On Mon, Jan 29, 2024 at 08:16:56AM +0100, Florian Westphal wrote:
> Kyle Swenson <kyle.swenson@est.tech> wrote:
> > > Can you restrict this to NF_NAT_MANIP_DST?
> > > I don't want predictable src port conflict resolution.
> > >=20
> > > Probably something like (untested):
> > >=20
> > > find_free_id:
> > >  	if (range->flags & NF_NAT_RANGE_PROTO_OFFSET)
> > >  		off =3D (ntohs(*keyptr) - ntohs(range->base_proto.all));
> > > +	else if ((range->flags & NF_NAT_RANGE_PROTO_SPECIFIED) &&
> > > +	  	  maniptype =3D=3D NF_NAT_MANIP_DST))
> > > + 		off =3D 1;
> > > 	else
> > >   		off =3D get_random_u16();
> >=20
> > Yes, absolutely.  I'll test out the change and send a v2 next week.
>=20
> Thanks! Please tweak the suggestion so that --random still overrides
> --range behavior.

Sure, no problem.=
