Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2136.outbound.protection.outlook.com [40.107.20.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD9F50A68
	for <netfilter-devel@vger.kernel.org>; Thu,  8 Feb 2024 23:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.20.136
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707436600; cv=fail; b=qwEwJxCrx+R//ZHu9kbAJtE7NrCDYNravht8vCSIhbueGpRb1+ApWPcawdDDOgdFrlp93mSVOjgW9DgD3nTF5+IYdYJcXgfM4qv2r6vlH3FK7jUTgS/g8F8wexdoY7JEL3jLzsvqihQRsiOsUiueSdBjAUAW5vhIVMjorlXiIoA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707436600; c=relaxed/simple;
	bh=yrjKp6DPTYe1FjkybqUFXPG2Yl7E7qKJCMcLuFu+IhI=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=DxFVdLK6xiWZIz55oi8/roGS6zV7Fa/aLiai4nHuuw6M0pg50C2kudARPa6VHkJyN3/IulwV66dajurEPrJOAKp8VhK5HUxXy4NRhNw8WbCJP6b6MYtVEFr64ApVvxy7ZX5loc1UIrCvLuBIZZalSH6Jma9I4HZ/MqUyWhyx/Rk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=est.tech; spf=pass smtp.mailfrom=est.tech; dkim=pass (1024-bit key) header.d=est.tech header.i=@est.tech header.b=icyS1r83; arc=fail smtp.client-ip=40.107.20.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=est.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=est.tech
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=est.tech header.i=@est.tech header.b="icyS1r83"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=avhEV8YD0oEnI3mFFopHZj1jaIoQCzhmqUf9NY7ClvoHB5EHgBfWBLktizPlvxmfq53NvOXNNUFTjTW6C33B3O6AOJnnb8STutSQbJquw9MITqZ6le3zZLkRuyr/mqPhybJ2LKLhngUVbfArq0HHRAp8WHQia8Fm3gSlP22sIl5bqD6ZkU2BYDkK8KTylWRC6Fv1cBKOoFi0ZuMBAwkoaASfZ1LAitmX0UI19uUAGc/bjknByXRdGjOjANi/Lbvz2D7RAZ2cmbipEyYtLx1GplrN0pliEyoS4HA3Go37NggVpkAj+w4qxEms44UgLfZ831mgZRhe9G1iHXXpuqLa7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aRNnyFNeqCVe+iSF+b56Jdoflrx23fkj4m5FnE+gT0s=;
 b=PIwAP22mwkOikoSNu6yMpMnbvRp9nrZYcH+wfQXdUxFuw5L7KFL/TnWAIn9AkWtnOjjNmsPvfX9f/OoMmjalhMxtDIMGoV5Y1JMO5bvbxHBaI90K+13oOhHPhrWd7HqGFGZ/WbxGKRMY/CMuGABBzOENwxJZsrOx+6ivhf7hcDS594ytyci5T7m+AteodLl4pHaOi0apFyg9Pjjyv4F9auxx9WHAFmnHmcrSkQdSmm7OsTnT+GPBLgOOXivnlQekiqWWI+j+YS4h5FJsQduqIx6O7ea6rsSDo9CJhT4RB49Mg33WwHYTyDLtXHH0MqRogS9Yi6nmLtX/PWbaXddKZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aRNnyFNeqCVe+iSF+b56Jdoflrx23fkj4m5FnE+gT0s=;
 b=icyS1r83bhtKUOc0F3ao/1/GmoU13FGcQQ4QL7jxVfihpWy48RiijoftlcKshUaEQCCnmmmFwzGEwBC+UfCFhy6C0sy4ff4TDtzdkuP/8yFvydyMb6qFridxIEUtHJQXE0yOW67rcdYSS6wT7bJugNr+fvC26HDFMxZjcdoGp4A=
Received: from AM7P189MB0807.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:115::19)
 by DU0P189MB1892.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:34c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36; Thu, 8 Feb
 2024 23:56:31 +0000
Received: from AM7P189MB0807.EURP189.PROD.OUTLOOK.COM
 ([fe80::bad7:18c9:a3cd:6853]) by AM7P189MB0807.EURP189.PROD.OUTLOOK.COM
 ([fe80::bad7:18c9:a3cd:6853%3]) with mapi id 15.20.7249.041; Thu, 8 Feb 2024
 23:56:31 +0000
From: Kyle Swenson <kyle.swenson@est.tech>
To: Kyle Swenson <kyle.swenson@est.tech>, "netfilter-devel@vger.kernel.org"
	<netfilter-devel@vger.kernel.org>
CC: "fw@strlen.de" <fw@strlen.de>, "pablo@netfilter.org" <pablo@netfilter.org>
Subject: [PATCH v3] netfilter: nat: restore default DNAT behavior
Thread-Topic: [PATCH v3] netfilter: nat: restore default DNAT behavior
Thread-Index: AQHaWupw30ISB5ZeFkipq+Ch9Lyfdw==
Date: Thu, 8 Feb 2024 23:56:31 +0000
Message-ID: <20240208235612.3112936-1-kyle.swenson@est.tech>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM7P189MB0807:EE_|DU0P189MB1892:EE_
x-ms-office365-filtering-correlation-id: 28d40361-55d7-437b-690c-08dc29019313
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 ukmmZ47+j+xOV6U+OD2GrqIAgH56DGFeNU5gcpx6H4SoV7wmyTX4X0whX7OJl3LSVcOojsrut8mPzkBcYi8sH3u/kfAgPXFE+cHu+7F7qB198YYgTyzi3ESpPbdpBnT7vvrElp9n3vrZN+NGiryh0eaAHlKQWgAXAYf5R9ltKJ1XCb349lm4cLq5b0j06Bn6TtU3KEwRNRLYVhpo7XlEF5Xo1XaC2IC9qaSHjWshS7BE2Q/TFrfAT0Zcyln3ZyzZAMM2vtOFqRPgIaqyvWv0vq+qcIZhiltTJjaW4t7pC/K4YUv0K004UF0A+/eqaxWncnMuHmq9/n+DAMEZCLz7R+lQp7ldrLWJXRV8AqiW6W930xfzQtiX+uRlHdwRY4o3lgtYPs5gv2/pRYNcHyp1+gX+BqF7eH3siM5gxb5/OwlXg8lNJoP+/sOE1ILSu+rByggdjiNlC5UpJ/yOdxxmJL63n2WbNDmBDs6F7Jx++Or1/0lT5CvZSWMtWfv6/TFukhZxG19dAz+EehyTxJPvI5vOnNvP6ZG2vPhBEx7BIHYCCI/tCZThrqnxp/R+5Ga5OtCgEGfK3lGA9KGkBQJ5M872dtj6OwoO/4zvLX1tsFvv+QPBC2StIBulFGCBiXcv
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7P189MB0807.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(39830400003)(376002)(366004)(346002)(396003)(136003)(230922051799003)(186009)(1800799012)(64100799003)(451199024)(2906002)(41300700001)(5660300002)(86362001)(36756003)(38070700009)(4326008)(66946007)(83380400001)(6486002)(8936002)(478600001)(44832011)(122000001)(38100700002)(71200400001)(66476007)(1076003)(6506007)(64756008)(54906003)(110136005)(66446008)(76116006)(66556008)(26005)(316002)(8676002)(6512007)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?ik9g0Pjg1OgEQ546WAW7ann3QzsVm55U4ylN3aW1uMzYvY6svfxEhQ9e/Y?=
 =?iso-8859-1?Q?dZDuuAg/zeWbDQi6QTH43HISQ+7otVYYK2fvZho17IqXrR4EJLpYkktAVz?=
 =?iso-8859-1?Q?+Rv2ext4qttwGPbn5VJU5uBXx29NidAW3i//Cvw8pJJaKc/5rGYNEoqHYi?=
 =?iso-8859-1?Q?BMn4tYhYEDCpW8sVrsoOXuFqhOwSA8YGqgGLx9UUfK0hj9o+/Xj+1BoSHj?=
 =?iso-8859-1?Q?5a3J+XPEq64uNP2Bhor1X1n+6+omQ8iYu6mT/hmdu5fD/vtH5o5IFTfWAu?=
 =?iso-8859-1?Q?pyVw1N9V5N8LhA1AGh0oAhuLFyHM9lvZQfwjvxCFFZqYzrgjAidqfEKeKZ?=
 =?iso-8859-1?Q?jK9R7gGQ7sxIYDF1wrbNlMWzMcMl31qPy03cKe1zhL5qt6Orom/48tKNf/?=
 =?iso-8859-1?Q?d/WKggz/YT+jfXTtzolgdARiKxBp9dueoGStD8Acnv6HmE884UtDRcPygm?=
 =?iso-8859-1?Q?sM7uzPW/Z1k2mYbciOTrhTcjlfktp8NTSSb5k0Mc9E2OprPtdGSiMlCCAj?=
 =?iso-8859-1?Q?V/3VlT2ORZDMXaoCQLsEwtZ5QgK8NlVbL8AeyvFzrRM5DbPGXQu7fGPwwF?=
 =?iso-8859-1?Q?PtXKOE2K2Vd3dYTjxGrLjeXVmEtP8+oqL4SALwkayks9DROBVVdkqm0W31?=
 =?iso-8859-1?Q?7mH26/sMHlS6CUBX0YE8h5uMlq1JNA/CJBpAqEYILOXZE+pwPw6EA/jYJL?=
 =?iso-8859-1?Q?Jg52PSTJuj9PtMnGg64sJ+f8sC0LEONHfrIU6L/VCDcKGgErCb7jjZoxkL?=
 =?iso-8859-1?Q?5XJS1KQTEktFT9svT4XqaFJ5JViUSyxmlCPvIgkOW2RLsGh65aHayKnwuB?=
 =?iso-8859-1?Q?RrYl0jSH51LRwHvAui1KbsfW3VFcxxQrZ5D14C+y2gtgVEsTaHEqTGa1H8?=
 =?iso-8859-1?Q?97fk+Va2YnGhaOSNtehADfjlHQ7Rf8gc9dv9eyQoCyXTw0u5VGNxeY5BJ8?=
 =?iso-8859-1?Q?WwebjnvviYl7RxR0xSnkhjMNpNwBqJdHd79vXqQd4QkLTb3MJP4KpfGvrt?=
 =?iso-8859-1?Q?xhMCkM4SP5NRbsbq7L3xvQGQY164/2K7hGfZCexuWsbRceFb4FyncdrdJV?=
 =?iso-8859-1?Q?hfJS6HW1Cq6gWr2LuRhDj0HfUCYxk7wzof3SNaiVai43VGjQDWOWqtu8J8?=
 =?iso-8859-1?Q?VfiUvaL35vuJzx/7ONoUacF7wj3OTEoJ7APxQT7QxBqgaTUXIJxGhReIYn?=
 =?iso-8859-1?Q?J/rAm03Ru5ryespPNqEb0+In39hlrG3ZtK28niaJybyLsNqJBrI4084lPg?=
 =?iso-8859-1?Q?DGGIzxSCip6G7ktajhsDcoGsS9w+Z5ag8asl/KzTUZHnBxUSsubukaUEcF?=
 =?iso-8859-1?Q?FEIJTma+XLc3DPIM49M7Hs9h8yNwYVufFzvqTf139Ukn2P+rvXaLt8455M?=
 =?iso-8859-1?Q?TX1W9wJ0+dcg4q6jgyHiYxsPSo0z2+/8/8W0Hdv8dcHWRxVVU5Na+pMzbL?=
 =?iso-8859-1?Q?Wq55KCsmCuIuopRLuSTuWIUPZms2MeGffI1g17cK0LEMURL2KfHbvYLpK1?=
 =?iso-8859-1?Q?bkouuNvSzx8ZLYn4B1cQeyUjwvwTKBm9w7B1X1TSFFD08VOHX0mV63oEwO?=
 =?iso-8859-1?Q?ZtcbCNgIvjT3qlvxPT1avWDXBSuNcGXxyfeH/WRGkWE/i1FMTGTkq+ftNa?=
 =?iso-8859-1?Q?qsmwQtaG8RxulWm3Pt1mumiQlIITVBk0F2YEa6iOVXcCvPXUIfk/jvyw?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 28d40361-55d7-437b-690c-08dc29019313
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2024 23:56:31.8502
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vD2ZPYUPpEEE4TTGPcvAXFUcXiQJjuNDbwZ9TvdGGoc3nit+i6h0lM3H58Jqol2h1GZ6kWeRpKDOL8OlfY5ioQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0P189MB1892

When a DNAT rule is configured via iptables with different port ranges,

iptables -t nat -A PREROUTING -p tcp -d 10.0.0.2 -m tcp --dport 32000:32010
-j DNAT --to-destination 192.168.0.10:21000-21010

we seem to be DNATing to some random port on the LAN side. While this is
expected if --random is passed to the iptables command, it is not
expected without passing --random.  The expected behavior (and the
observed behavior prior to the commit in the "Fixes" tag) is the traffic
will be DNAT'd to 192.168.0.10:21000 unless there is a tuple collision
with that destination.  In that case, we expect the traffic to be
instead DNAT'd to 192.168.0.10:21001, so on so forth until the end of
the range.

This patch intends to restore the behavior observed prior to the "Fixes"
tag.

Fixes: 6ed5943f8735 ("netfilter: nat: remove l4 protocol port rovers")
Signed-off-by: Kyle Swenson <kyle.swenson@est.tech>
---
 net/netfilter/nf_nat_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index c3d7ecbc777c..016c816d91cb 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -549,12 +549,15 @@ static void nf_nat_l4proto_unique_tuple(struct nf_con=
ntrack_tuple *tuple,
 	}
=20
 find_free_id:
 	if (range->flags & NF_NAT_RANGE_PROTO_OFFSET)
 		off =3D (ntohs(*keyptr) - ntohs(range->base_proto.all));
-	else
+	else if ((range->flags & NF_NAT_RANGE_PROTO_RANDOM_ALL) ||
+		 maniptype !=3D NF_NAT_MANIP_DST)
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
