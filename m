Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2101.outbound.protection.outlook.com [40.107.7.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50468159589
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Jan 2024 21:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.7.101
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706562778; cv=fail; b=tnxUIjOfo84YUb/hAViZZ8E5w5WoRUYKkSAfy+T9UIOMXzTlmPnz5jcZeSkyWTaOuT+7WvDY963H8GB/DcGC0ZrJxGKAzHriAIt5iDHOlN4630w7jL7Lf232yYlHW9UJOXjQf1b+SPnBz3gif8xoUtsd53CgN0wpYgxHLrLOla4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706562778; c=relaxed/simple;
	bh=PxKP+gmBo9u3+SeyzPMCqZ18YVQj4PWC6i/sRXSVZrE=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=BO3uGUY1ck0Kblfs/PkmvDD6MfXb+byxd+Dv9mWZgCzjm+DX0u10+hQb2PiMeZeGJHoWxmtho6cndmCdB1Ap2d/JwDXQnIoUFh4WiNKgGehEx3KcAt4tFFDeOHZm3FmIyhZOi1L+HeLIzWkdrBYKxpv+fn5sKSZpuq8h2muughI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=est.tech; spf=pass smtp.mailfrom=est.tech; dkim=pass (1024-bit key) header.d=est.tech header.i=@est.tech header.b=hXNnGSt0; arc=fail smtp.client-ip=40.107.7.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=est.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=est.tech
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=est.tech header.i=@est.tech header.b="hXNnGSt0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c80RjQ5mi19vTSKAo5PycBimK/hxzg3+MFz6xD1BrGzUc2s007Xsys5o0EP3nIYo0EtdtWi1TrXPtVPMskH2DyAR9Pi2qw2gGFg+85AVr9h56laGOZzcYBt2dteoaZ9G8rE5jOUvubvfng0zOtjnYbVShQhaBdwpMHftSUKQ1Hn8Hm4Oja+pgoKP78QPE1CGg/jEWoDI9nokj+Fr8by+l8wwLkDfYLHTRkhr4Iurda3hAy4NGgGGPs+U346PgNsJ8FdKsAJzi8Om93l+8l4LdoM5RbtfKxuNqu9mHz8xm9T87SK0rKfeHTpRVJMu5+fQwx8edSbfPQjKTLtbx7m2kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Kr9FE0lZ3MKoLAdyY3GCpb/0QYqWl72lEOpO9I3wz0=;
 b=iMj1nzMx2bdMUw9lGeSPWSMB82JN5xhp5WDbCYt/Pa+wskdYviUqB7tuEf2TjnNIM+5+e7QZMXiD8JhKGbxsZFkQzUSAF1XPnlo4J9+moyOQ7DhRrfkOFhj6gjh9w5zk8sK3WzURFo3+4PmNMsNasbjjXXfFUfD7TsSOULdeapph/DoOyRzxdZBaINuoxCox/mqs1pTPQ4gYQm6p6/jJZNECSpahTrC8XbcOUaqTqhRR7pZ+xUxZ8tJSYm5NmFvkKmDPB1oDTc53Pf4vrbzQQnN/Vdl9TCOrJrIF18sT6163xw0oUwS2geNNKv/Y8lbmDdqkdsWXIN0mcHUw7z890g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Kr9FE0lZ3MKoLAdyY3GCpb/0QYqWl72lEOpO9I3wz0=;
 b=hXNnGSt0LtGA7cE64RdgTpDxSLmWBNZ9QDfq8bc/UjacHly064DtOB5Ho3z7xsBTt9pzwdXAwhTLnC0rY2VI+IYidD7CKb3vjnXXSpmJUFgkHGDPaym3TfV4+0T2snZ+t/iM4pBR0br2/N9IaCfdwsus02TuGKnAsdxE+ypA7LM=
Received: from AM7P189MB0807.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:115::19)
 by DB9P189MB1836.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:326::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34; Mon, 29 Jan
 2024 21:12:52 +0000
Received: from AM7P189MB0807.EURP189.PROD.OUTLOOK.COM
 ([fe80::bad7:18c9:a3cd:6853]) by AM7P189MB0807.EURP189.PROD.OUTLOOK.COM
 ([fe80::bad7:18c9:a3cd:6853%3]) with mapi id 15.20.7228.029; Mon, 29 Jan 2024
 21:12:52 +0000
From: Kyle Swenson <kyle.swenson@est.tech>
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
CC: Kyle Swenson <kyle.swenson@est.tech>, "fw@strlen.de" <fw@strlen.de>
Subject: [RFC PATCH v2 0/1]  netfilter: nat: restore default DNAT behavior
Thread-Topic: [RFC PATCH v2 0/1]  netfilter: nat: restore default DNAT
 behavior
Thread-Index: AQHaUvfrqHUPR8sc90mEOJXASCqkvA==
Date: Mon, 29 Jan 2024 21:12:52 +0000
Message-ID: <20240129211227.815253-1-kyle.swenson@est.tech>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM7P189MB0807:EE_|DB9P189MB1836:EE_
x-ms-office365-filtering-correlation-id: f53e514e-dbf2-4cf2-0929-08dc210f0e24
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 BVrglq818rYLLlit1cW8Q7ghU/9U2RwvhFftuw/X9AMYY8VHtmIb5Qhaqn+mzXfrxi+sdvi4H2XUZl73yxe7c3u5jFclyAyT2/9VCZnM9gRIOWxMH3fvrtqtk2zGO5f+UhK04VYKxtVaWxbu0x/+QE91RHvNNCjk/JtWGLbAT6//EcZPhF8DR3RHid9Si1ZTAUjubkGAlpTdeQLLTlWL1MprqIdS3HPhJ0p3v11pDBLOQ5uoZTPjCCz06abrfHHJxpO5sF+zxM7FqeyNw7E1ttb96IBSqZp4zSsH4BTvLJeXS08Yy92fTOgiUS/zGh1AVKy5rI3q+6HUETTpE3BCMiPnWwD2qeOZECDfChCqTeFjFiz/YKxIFQEmrjCrGPnmHaCZKEvR/HZTrSbLe1I9WYSGVdMfhLy2pwWd96elKmbeijRuMvwTu7W/LFk9Utu8S/guJqrZl1NUNCYB5Jj//GsmtAJC73lLZ7vc55W+0HCxC/fojTKLX6wBS/KhRmhrCILTIwNnUS1gEAf8WIKvck4n99VZ6WV8jEWHT+1dEeteG89oCAF1kFcxRHMD7bpxfjUDWAfjN5ts2YhcsVuTDkmnpCP//VU8p2cxY5Ou5mtKaFP/Qfhxj/rsqJHAtFLM
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7P189MB0807.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(396003)(39840400004)(366004)(136003)(346002)(376002)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(38100700002)(2906002)(44832011)(5660300002)(122000001)(38070700009)(41300700001)(36756003)(86362001)(6486002)(26005)(478600001)(6512007)(6506007)(1076003)(2616005)(71200400001)(8936002)(8676002)(4326008)(83380400001)(66946007)(66556008)(66476007)(66446008)(64756008)(54906003)(6916009)(316002)(76116006)(91956017);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?4l9kJnBOLjccGQlCrx8FwhE32B22XfYThnag3ogJNf6lBYLPkp/9rTWDoK?=
 =?iso-8859-1?Q?bxlCVk1SU6OCC0plqbUDI5HfJuptHc2S9pVUckiSI/wScF0qNxsXyimspd?=
 =?iso-8859-1?Q?0O11D92V4LGSwNZqMsuXXu/Zqu5btvAY9lBc9QA3/eF/v6MmGcjJ3+MM6x?=
 =?iso-8859-1?Q?VeJE/c9BOuMiKdma8nDZnF/p7/0jq+WErjF60B/o5J8TQ0p79gt1h+fbRK?=
 =?iso-8859-1?Q?LH4fpXLkymMRwL6NcCqDObtW0pINkD7Yb7kE1J5u21M3XhbvvOgXSe0nep?=
 =?iso-8859-1?Q?xcZWkhJcQu940qimtApKoGBE3swllqYZNdSTX0u87Do0BXKkVy71XZ3XCd?=
 =?iso-8859-1?Q?GK/SlyIYEGyrk+uklNOJCitTXn2HvmmxgXxQhOiTn/jtylmgx/BIpxfx7Y?=
 =?iso-8859-1?Q?ORo8JApV5bmHHP7vv6bS5PsDil9HUVfUxA/7lAHgHsuOKZFp7b+8VytHru?=
 =?iso-8859-1?Q?oF+hwoJ3OuSAMrc4HC4LM53RWvxfN/rFGrswRab2bWwNgWLfI20HfrbQDr?=
 =?iso-8859-1?Q?hTLhShF+SZ3bKTgHGuUVNXydBfUoFv+7mMkRlwTTaBC54+gX8KGI/7HSxW?=
 =?iso-8859-1?Q?oKloz/f6vsg848q0Zubr9UX6lLpTAb7H1r/6ubUxL807W0XRE0ul+NpuM/?=
 =?iso-8859-1?Q?K+jX5Tg9sA05fcBpc1l8fg2/RXhHf5SE1nRKsui/z7VxBGu4nx4bnKZG8N?=
 =?iso-8859-1?Q?fXtw3tkaePDbWVHNq3liq5RQOfaou7476odfUZwKWyAAat5Fh0z87v+hjq?=
 =?iso-8859-1?Q?v08iZQ0UvTMmZ+mwgVOUjIXD9y/W9aXRsJHE7loQSQmHGIn/FAhv+XM3py?=
 =?iso-8859-1?Q?GlU6ecAP6P+EvpEume/B+CPbNMuFLQo1Ic1S+mXAvKTOc5IJPM5gYc3WDH?=
 =?iso-8859-1?Q?M0dpq5tnKeYxzrmvT/MQiJ63tQM3vwzseLJvKvoGOcWLxw8Hdx43ksAUeA?=
 =?iso-8859-1?Q?p2vfbdHtiogBjKQ5IoJ0koU476+cvFGjZDkuruQszb9wEvNVyXm9B7/Gym?=
 =?iso-8859-1?Q?nqSxWnqeDd3RGRemMvQ+/WFk0tk1/dgiWm6VZU0a5SAQNHsZXMOmYZdvnr?=
 =?iso-8859-1?Q?M8BeS3NXsGs/H7dOFqi+ad2L6tVDOpWp1L8uMlCENKJ+dmhBONhYmRx0PO?=
 =?iso-8859-1?Q?QlROdjG69KhCA+eo2wT7CHXgiTuBXr9YAB0/9FsGfBa1Gjy2S8wggfah2G?=
 =?iso-8859-1?Q?g9EyXQYXy8pGUp0NIsGMT9hdG/bjcLi0MvKobpLNMypHOXKH+HsKNeBEPj?=
 =?iso-8859-1?Q?NTs/mbqccd1MJH/u0jIywstSwMvm4cN8WlIDz9DljgJxW1a2j673OD9+mD?=
 =?iso-8859-1?Q?nodhIpK34RLcszZVhhHLulfBYNm7BRxVdznISB6Wjk8kJ+rVgdKNzNP9N3?=
 =?iso-8859-1?Q?jePp4AO0DEurYNwM+hlI39XFkpfWih/EYFaWjoBLI1UKVRwCtSWwB2GXwz?=
 =?iso-8859-1?Q?OLPM2koZlIbACRj20yGZArsek2AsM6tarQyc+LfwvxhBBwQk/+A3wp4JU1?=
 =?iso-8859-1?Q?6uRUQW90dfgUvAUVyySgV+8n5c4eBao8cOuG8IWC1IsiD6UUv6wuvwEHj9?=
 =?iso-8859-1?Q?yQ1ubDZFDRWHD+rPGT0q3f435eL0XNjms7VRK1Ir7DhiuBCyDF1sZylxR+?=
 =?iso-8859-1?Q?M5fOU28BpNXlO4ueMEpdrt4wv75w2H1XhPOLw28Y3OLRN+jpU0ORQkQA?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f53e514e-dbf2-4cf2-0929-08dc210f0e24
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2024 21:12:52.5062
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tvyfp7o8drlo5PvQRjdqyMdUOYhHL+cEo81By5WqUWHL/NOnScZldwX7RP0QZvWMM+POs6n0lUI294LszBg2OA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9P189MB1836

Hello,

We have noticed what appears to be a regression from v4.4 in the DNAT port
selection logic in nf_nat_core.c.  Specifically, we're expecting an iptable=
s
command like

    iptables -t nat -A PREROUTING -p tcp -d 10.0.0.2 -m tcp --dport 32000:3=
2010
    -j DNAT --to-destination 192.168.0.10:21000-21010

to DNAT traffic sent to 10.0.0.2:32000-32010 to 192.168.0.10:21000-21010.  =
We
use the range on the LAN side to handle tuple collisions that might occur w=
ith
a single port specified via --to-destination.

The behavior we're seeing currently, however, is the behavior we'd expect i=
f we
were passing --random to iptables (except without passing --random): the DN=
AT'd
port is random within the range.

Through my naive debugging, I've arrived at this RFC patch and have include=
d it
mostly to illustrate the behavior our userspace is expecting with the above
iptables command.  The hope is that I can be educated with what other
folks expect the behavior to be, or what I can change in our iptables
command to get the behavior we're expecting.

Thanks so much for your time,
Kyle

--
v1 -> v2:
- Restrict to NF_NAT_MANIP_DST so that we don't have predictable source
  port conflict resolution, without changing the --range and --random
  override behavior.
