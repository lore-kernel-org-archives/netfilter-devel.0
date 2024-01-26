Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2125.outbound.protection.outlook.com [40.107.105.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D3022313
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Jan 2024 19:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.105.125
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706295777; cv=fail; b=pU9ykV9ebuMwQtpsZThK626wNVYUq/ML9cIWE7ubA/YcUusTogVtsGNJmh0HYPaCdc0qAyCZBE1KfMnkIFawRcC621Vh+HdlbvnNsUiM0B0ZVjD+GVpKqNcAkREJciQZyHaQajneUuoRv9L6cT48Hdhlb+U7Ti50AcDPDrD+EPc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706295777; c=relaxed/simple;
	bh=5tk4RFU3rOUEQpi8lc9DqVpeRaoJDy33JiWmDZL/3kw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=grkPD6TBnHcgX/BrYiE4RyEyel3Ecr/0GzZflWerr9O+J4IVcQeRlULK5NHUMSRMSBVNeiYnb2p8WcaAicbSJaB0PnV7U+S5FHY0ooEq8Pyvw8MEUCaAiC84dJeRJBuy1Q66yeR1WqI2tNE/wB43uK+EUs+TYzOUE8P2Asf1/14=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=est.tech; spf=pass smtp.mailfrom=est.tech; dkim=pass (1024-bit key) header.d=est.tech header.i=@est.tech header.b=XT+9IAbK; arc=fail smtp.client-ip=40.107.105.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=est.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=est.tech
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=est.tech header.i=@est.tech header.b="XT+9IAbK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KlkZR4iS3E0v3DR5T1Isem0FYbA95xkogHf9AxE8gWHcdzIuWB1xlIhAwYX1po17E1bZVpGID+PNNvGaOt9VcK9yluJDDtXDWYO9RuNA7v1H0fi/3RWgngi8p+jCneG5PrWbZ/ESKlHs+nJgdld98Hsw+5gNXtFBU0u2FUSfto5wJ9RPkWs/LRZBwtBXRmjDYpSaV1rb5of7Tfc/6gQN63aIg2SosrE6zrGLqRww8KAmcrPdGc9oO2KxOuUgn0BC0z7P0HsYj9fxYe8sGNidt62XksZ6ZIL0HqrgpRIhPQ7zDDlR+SoKITu3qHK6LEXiFWCArQsJJ3oigWbk2vtEzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GYsBnhlg/dgYnz1l4wfk+s6X5CbNbGNXBmwDdahjdf4=;
 b=Wtk8W4K7Yq9tNqYwrXAlX/fxGbD7kBivNxpYyfaamVlJZw8eqrhLWNWOFz/mC22oJd9hAkRKoU+WXS1540FP5UPemg8RGUFt4J/rNkmRAqiufr8U7SXyQ6iHHsao+b3w2RaClk4u5Q3P1j/OVhizvYhleX1ea1fjXJsqmS+eC5h+PN6pXUZFVhTDq1Mbcci9z1wzsnzNxIWhp43AhCrmr2yFpNASgDivc5Bvg6nYF0+OdVBOhC0MiuVvG0FWUbejJkxONMP1mrSuaXoM8C821hPFgy9CU/NxHRZaR7VBqayfs1gp2DcDMgJaU5PMlhgAUIeo4Hmli8YpLrDhs518VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GYsBnhlg/dgYnz1l4wfk+s6X5CbNbGNXBmwDdahjdf4=;
 b=XT+9IAbKIO9VgHOyz93c6x4nFfCMiH4I4NIsLH+BnUTMDkfr1Xm+lOv5QDyyp4A7xTOs4k24nHom3uhwDpzrb7B+Z2xCV2xK9TC1DByQuyovrfopDm24QptxTyRFMfTuhOXLhH84Z/59rFKVM+iQ8LORFE6Uj4kfrrO9Nq/zilk=
Received: from AM7P189MB0807.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:115::19)
 by AM9P189MB1747.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:2fe::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.28; Fri, 26 Jan
 2024 19:02:51 +0000
Received: from AM7P189MB0807.EURP189.PROD.OUTLOOK.COM
 ([fe80::bad7:18c9:a3cd:6853]) by AM7P189MB0807.EURP189.PROD.OUTLOOK.COM
 ([fe80::bad7:18c9:a3cd:6853%3]) with mapi id 15.20.7202.028; Fri, 26 Jan 2024
 19:02:50 +0000
From: Kyle Swenson <kyle.swenson@est.tech>
To: Florian Westphal <fw@strlen.de>
CC: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>, Kyle
 Swenson <kyle.swenson@est.tech>
Subject: Re: [RFC PATCH 1/1] netfilter: nat: restore default DNAT behavior
Thread-Topic: [RFC PATCH 1/1] netfilter: nat: restore default DNAT behavior
Thread-Index: AQHaT+tcFeBrAhq3cUGK17abn+K/+LDsQNgAgAAz1AA=
Date: Fri, 26 Jan 2024 19:02:50 +0000
Message-ID: <ZbP4BFXtw4SPnMjN@p620>
References: <20240126000504.3220506-1-kyle.swenson@est.tech>
 <20240126000504.3220506-2-kyle.swenson@est.tech>
 <20240126155720.GD29056@breakpoint.cc>
In-Reply-To: <20240126155720.GD29056@breakpoint.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM7P189MB0807:EE_|AM9P189MB1747:EE_
x-ms-office365-filtering-correlation-id: 62a770f1-2778-44e5-eea6-08dc1ea164b2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 b06sJJrWGfF/MHIdykZRSSx7dasg5lFzz/Lysx3S4s2Wyn9Lm75yqTBIaJObcVO6LVlTAGfG3T71tQRixcKU35R7oCQhOFI3iPENct4icJ/ft7Znn6acy9jkEYj8IHxK3++8Qbc5ghiAPBENKfngKVVVu6W96FCOYGW7VBPVeF6KJoftl1mXBBJBcdFvaSnCpUBrK/zjXKQpWEPZKDTNcnxibbOwrNDZU5COCLO+EqgSu9hTY+efFOBC6lHbCJN/qpe5uUEezQPM4DgSdZKlOvLYvQ7NuY7rzWUjoHuzjPdbGsHv+iJ9bQwiR1xM+inDzcOg6EJmbhSvA02qqrWPpmbZsklur0AC4vh9BM5hRezeWxykAFjlWNEENXJXM/fagnmM2K/u6xTvRF4n7B2EfV2WVxMAajDLXlyncou3kvKiXjs0PKktxec4z2dSDN00WpJTHB6qHLGpsq62eVPeAfggRZJG6kWC4qEwRhjxl1+NHkd/m/tJN2R114NODMkqw2u2GnI3SK/J83gUiYXZrRx4aFu5ceGJqMvSkTso7W8l3zxVeYNZi+Gty7U2ha6ZJtX7r+BKWVZP390wtbkmKLHWL+bhFW1jW81+TeuUV6199w1G3yQdaPPfgsdAbCw0
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7P189MB0807.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(7916004)(396003)(366004)(39840400004)(136003)(346002)(376002)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(122000001)(83380400001)(86362001)(33716001)(41300700001)(38100700002)(478600001)(6486002)(8936002)(8676002)(4326008)(44832011)(76116006)(66946007)(91956017)(66556008)(316002)(6916009)(54906003)(64756008)(66446008)(66476007)(26005)(2906002)(9686003)(6506007)(6512007)(71200400001)(5660300002)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Mn0HYDjp4cFWTeFDDcVwSPs1y0IKN/cFcEtRcDx7nr7HsSdE8iFR2lwmoaOV?=
 =?us-ascii?Q?vJtvnFeHC9TlecroinGDncuCs/yssEXVsJKLYLuPkn7QVR7inrbke5l68i1J?=
 =?us-ascii?Q?+Q3PzbS95A1nVbPb14i2KjzCWlxrZcAEDSittEbySi7sTcPLqRFCko8dL90W?=
 =?us-ascii?Q?jOFFXkKgGauR9LFLMlHVAtJlpNLoXbGkONAxA3wkHQ51lXK3zlD18IKsp0rI?=
 =?us-ascii?Q?J2Ylz9rmuAFEDdTuKhhktlhwMlIRcAPA6ugMMPAGreimfs1Tlop2HWgMoLvZ?=
 =?us-ascii?Q?Jpt/Dsk/SZTwD0eBbYcj8rQcbB7A91GRxS1FitjR171n9AvX9DzTyPzirHWH?=
 =?us-ascii?Q?3z430nGrtMNY7h6b3IRdHxe3PgKKRgZveWiy9EPgoj6uTnuZgnQB4PMJIOt3?=
 =?us-ascii?Q?yKC+RZOujupczujrI/N1hVuEpzJEoj2ela0QpFewzFgjI6WMden6H1UUks+J?=
 =?us-ascii?Q?gwtur6tOzVprSe+vYrJAYdDDVSRmGNxnCWrmVyPawq5+9smTY79sSwMkIeZ2?=
 =?us-ascii?Q?rLF9nooxT7PIy/nqocRxMZtRCKy4FpZbXCzR59NpVVPglpYwYQ4eH1JZWwya?=
 =?us-ascii?Q?+c5XVKlo0SdZQ9RbCbE4Lg9LD4/z98ckzb3wcfifEsDfwsg/d+lZwXBdyhO+?=
 =?us-ascii?Q?TO+ADrndxBTsgdRAXzp3zOtJGuLWXc4p1a47kcn7NHJ/C49K4h2otK8vd6sO?=
 =?us-ascii?Q?wt7iqQ7KvnZ8Dhvrrv1KvXi9AvvGuTGLN/g5noVy6xDkN2Tgiep6XBvppSTH?=
 =?us-ascii?Q?VoQ19hyE5VWaA+kgIT/lFEVSnlMw/EFbl8mzZ85IDcdSL+I0BYp6Ts5XawG/?=
 =?us-ascii?Q?qD7y1DBUKnbGhvgqK/CLIqyljyUNjtmrEjvJtAn2X4+o1wrrfa2S9r1I6cYL?=
 =?us-ascii?Q?DsFBAuD1irijplUo91FKuC7lwtG6s6B/JAHtExVy7VnLGwmfRbe51SzYebQa?=
 =?us-ascii?Q?5ljoRC1s8AVkUali6VVTsYYtcfYkv2CiFYdn20TxIbG5pOj3UP2Hz48RjW84?=
 =?us-ascii?Q?3I40W6AArXNukLRqO0mUpnmh5Ou9ut+EJtIXdi43jX5Rum/+y9doUdkzYb4e?=
 =?us-ascii?Q?f7/KGzzUAWwq7t/ZX+k5lmEOxflAwpjp2jiHMlOfyhGX0RBP9leBDTqRCjDV?=
 =?us-ascii?Q?gXW20FihuAtpUSQVTdhMJDkb3yCApk4kVcYaJ97D8ixj5pkG0GyBzrMpffcI?=
 =?us-ascii?Q?dAmZZcPbtrdtvZ2hnWSg/rAUcdsbSSKf+lxztnixCqABFgXDtgLYNVbOVyNB?=
 =?us-ascii?Q?vRk9zjrmXz5YXewDhMgkBJPT0mXxCwEbipD0DS2Bjo0sF5yngv06Ui7VlwCY?=
 =?us-ascii?Q?DiJyNpdPcM5FsOtgneaJqhu8lnYc46T3IN57+70MNgJc3ulNM7X4GSV6l/m0?=
 =?us-ascii?Q?OytylEKlCe5vKBxIhQFWY4KAkgan3ne1PRKTFP0f24x4QehlR2ZzNFK9uW44?=
 =?us-ascii?Q?tb+I34H0MfQpGy5efmHD0CgXmxZH6BCbbBPDa3le8tMteJ4CQQeqKV1IDO9E?=
 =?us-ascii?Q?f8DkgROHLX7G3xOeHEHoZVabDvXXNn/U7Uu1KpkZIEIRZd4gSZ0STU+3wIaj?=
 =?us-ascii?Q?3L3RXogy5wb4zImwaeDANLlVR0hymZS6RvCmU8nnz1Upuy6jQDiu/MsOdhO+?=
 =?us-ascii?Q?3A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <959892E86AA208448E780241D7C65025@EURP189.PROD.OUTLOOK.COM>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 62a770f1-2778-44e5-eea6-08dc1ea164b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2024 19:02:50.7547
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XKI4rdNHX70Ak4ODnRccqwkDvKctuxMdXxEU/ZJxqBNfR9I4OhnOM0IpkHFFT6Ilyei7Nz+qTICB5XbfqMFAeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P189MB1747

On Fri, Jan 26, 2024 at 04:57:20PM +0100, Florian Westphal wrote:
> Kyle Swenson <kyle.swenson@est.tech> wrote:
> > When a DNAT rule is configured via iptables with different port ranges,
> >=20
> > iptables -t nat -A PREROUTING -p tcp -d 10.0.0.2 -m tcp --dport 32000:3=
2010
> > -j DNAT --to-destination 192.168.0.10:21000-21010
> >=20
> > we seem to be DNATing to some random port on the LAN side. While this i=
s
> > expected if --random is passed to the iptables command, it is not
> > expected without passing --random.  The expected behavior (and the
> > observed behavior in v4.4) is the traffic will be DNAT'd to
> > 192.168.0.10:21000 unless there is a tuple collision with that
> > destination.  In that case, we expect the traffic to be instead DNAT'd
> > to 192.168.0.10:21001, so on so forth until the end of the range.
> >=20
> > This patch is a naive attempt to restore the behavior seen in v4.4.  I'=
m
> > hopeful folks will point out problems and regressions this could cause
> > elsewhere, since I've little experience in the net tree.
> >=20
> > Signed-off-by: Kyle Swenson <kyle.swenson@est.tech>
> > ---
> >  net/netfilter/nf_nat_core.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
> > index c3d7ecbc777c..bd275c3906f7 100644
> > --- a/net/netfilter/nf_nat_core.c
> > +++ b/net/netfilter/nf_nat_core.c
> > @@ -549,12 +549,14 @@ static void nf_nat_l4proto_unique_tuple(struct nf=
_conntrack_tuple *tuple,
> >  	}
> > =20
> >  find_free_id:
> >  	if (range->flags & NF_NAT_RANGE_PROTO_OFFSET)
> >  		off =3D (ntohs(*keyptr) - ntohs(range->base_proto.all));
> > -	else
> > +	else if (range->flags & NF_NAT_RANGE_PROTO_RANDOM)
> >  		off =3D get_random_u16();
> > +	else
> > +		off =3D 0;
>=20
> Can you restrict this to NF_NAT_MANIP_DST?
> I don't want predictable src port conflict resolution.
>=20
> Probably something like (untested):
>=20
> find_free_id:
>  	if (range->flags & NF_NAT_RANGE_PROTO_OFFSET)
>  		off =3D (ntohs(*keyptr) - ntohs(range->base_proto.all));
> +	else if ((range->flags & NF_NAT_RANGE_PROTO_SPECIFIED) &&
> +	  	  maniptype =3D=3D NF_NAT_MANIP_DST))
> + 		off =3D 1;
> 	else
>   		off =3D get_random_u16();

Yes, absolutely.  I'll test out the change and send a v2 next week.

Thanks,
Kyle=
