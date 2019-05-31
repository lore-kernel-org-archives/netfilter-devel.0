Return-Path: <SRS0=7QpW=T7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC8F2C04AB6
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 May 2019 12:55:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F5212691A
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 May 2019 12:55:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=transip.nl header.i=@transip.nl header.b="IjYhbULN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbfEaMz1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 May 2019 08:55:27 -0400
Received: from mail-eopbgr130117.outbound.protection.outlook.com ([40.107.13.117]:28386
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726518AbfEaMz1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 May 2019 08:55:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=transip.nl;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RUWQ1n8TWmALvWPnkXHN2gc+n8eQlCR+6InfRPiPNes=;
 b=IjYhbULNJrw1qB8P9CEFbCEdU8YmDTBqyhL57heIoMALodo+KCoMv6o431qOytox/mIiw1jV88mloRoARFvmMdNLcWGZdZJArSfXYqMKK3OqAAsg0h7kdNWd5d+I3q/idvj5K2TAcythar9LuQSKNXglhviyUVo4Ytbx5q071p4=
Received: from AM0PR02MB5492.eurprd02.prod.outlook.com (10.255.29.141) by
 AM0PR02MB3908.eurprd02.prod.outlook.com (20.177.43.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.22; Fri, 31 May 2019 12:55:22 +0000
Received: from AM0PR02MB5492.eurprd02.prod.outlook.com
 ([fe80::8032:6f7c:6712:fdcd]) by AM0PR02MB5492.eurprd02.prod.outlook.com
 ([fe80::8032:6f7c:6712:fdcd%6]) with mapi id 15.20.1922.021; Fri, 31 May 2019
 12:55:22 +0000
From:   Robin Geuze <robing@transip.nl>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] conntrackd: Fix "Address Accept" filter case
Thread-Topic: [PATCH] conntrackd: Fix "Address Accept" filter case
Thread-Index: AQHVFSKmKzha36mmIUqp62mIzCyxuKaDwdGAgAFzTvo=
Date:   Fri, 31 May 2019 12:55:22 +0000
Message-ID: <AM0PR02MB54924197D9A4E4FA726BDABAAA190@AM0PR02MB5492.eurprd02.prod.outlook.com>
References: <AM0PR02MB5492D0F9BEB5814637C7D5C3AA1E0@AM0PR02MB5492.eurprd02.prod.outlook.com>,<20190530144329.76owimclaqyzqkmv@salvia>
In-Reply-To: <20190530144329.76owimclaqyzqkmv@salvia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=robing@transip.nl; 
x-originating-ip: [2a01:7c8:7c8:f866:12::1002]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ac992b26-e762-424f-24e4-08d6e5c73e58
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(2017052603328)(7193020);SRVR:AM0PR02MB3908;
x-ms-traffictypediagnostic: AM0PR02MB3908:
x-microsoft-antispam-prvs: <AM0PR02MB39088A4634B0449D625EA254AA190@AM0PR02MB3908.eurprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 00540983E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39840400004)(396003)(346002)(366004)(136003)(376002)(189003)(199004)(486006)(316002)(6916009)(256004)(66946007)(11346002)(446003)(6246003)(86362001)(9686003)(14454004)(2906002)(25786009)(46003)(66476007)(76116006)(33656002)(66556008)(5660300002)(52536014)(64756008)(66446008)(7736002)(305945005)(74482002)(73956011)(102836004)(55016002)(7696005)(68736007)(476003)(6506007)(186003)(229853002)(6116002)(76176011)(53936002)(71190400001)(74316002)(8676002)(99286004)(4326008)(81166006)(6436002)(508600001)(8936002)(81156014)(53546011)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:AM0PR02MB3908;H:AM0PR02MB5492.eurprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: transip.nl does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ecPb3EtkrfrBiCFbZvFhSxLv4g9fIEB8KMoASVNCazspUGysZoOcaUw8FvWh6x51RCwDacnpdXJ52bDvV1PxJD9x9v8/uqh8lM9fUinZ6xqVYdX2AQzYXXL7Gs4p0PrGU3n9DTYe6RCsCP0uNpQvwsoy2L8b+herBAh+JFAEMbzPcoHWz88tZBdFid+rEKkWdTXKgpOpnSboDhGLGtMjtqeVEgaQqlMGhwWAKWqGVSyQ3jijQzY6MZJMbXNWc2fSuWQX8aOBCZrNc1u2QKD26l9rRLg1PnBPHIFtSMPy6QT2kvippqZ3gn3yf3DfvZLxA5L2FbRO3ZgKzDi16mDdTXr1gvCynznilEjY5LiM0L9hMcWFalvCKKIHucoYsHXnj/bWJ/0vUfPHosNJv6QtuapKc3HhcEC3lXb/fn5d4kY=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: transip.nl
X-MS-Exchange-CrossTenant-Network-Message-Id: ac992b26-e762-424f-24e4-08d6e5c73e58
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2019 12:55:22.5541
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a4e75c98-a80e-4605-9b02-f5c4db1859b9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: robing@exchange.transip.nl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR02MB3908
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hey Pablo,=0A=
=0A=
Broken cases (will never match):=0A=
=0A=
Filter From Usespace {=0A=
    Address Accept {=0A=
        IPv4_address 127.0.0.1=0A=
    }=0A=
}=0A=
=0A=
Filter From Usespace {=0A=
    Address Accept {=0A=
        IPv4_address 0.0.0.0/0=0A=
    }=0A=
}=0A=
=0A=
Only way to "make it work" with the old code (only matches 127.0.0.1):=0A=
Filter From Usespace {=0A=
    Address Accept {=0A=
        IPv4_address 127.0.0.1=0A=
        IPv4_address 0.0.0.0/0=0A=
    }=0A=
}=0A=
=0A=
Note: This only fixes the Userspace filtering. The Kernelspace filtering se=
ems to have the same issue, but I haven't checked the code to see whether t=
hat is really the case.=0A=
=0A=
From: Pablo Neira Ayuso <pablo@netfilter.org>=0A=
Sent: Thursday, May 30, 2019 4:43 PM=0A=
To: Robin Geuze=0A=
Cc: netfilter-devel@vger.kernel.org=0A=
Subject: Re: [PATCH] conntrackd: Fix "Address Accept" filter case=0A=
=A0=0A=
On Tue, May 28, 2019 at 07:03:59AM +0000, Robin Geuze wrote:=0A=
> This fixes a bug in the Address Accept filter case where if you only=0A=
> specify either addresses or masks it would never match.=0A=
=0A=
Thanks Robin.=0A=
=0A=
Would you post an example configuration that is broken? I would like=0A=
to place it in the commit message.=0A=
=0A=
> Signed-off-by: Robin Geuze <robing@transip.nl>=0A=
> ---=0A=
>=A0=A0 src/filter.c | 10 ++++++++--=0A=
>=A0 1 file changed, 8 insertions(+), 2 deletions(-)=0A=
>=0A=
> diff --git a/src/filter.c b/src/filter.c=0A=
> index 00a5e96..07b2e1d 100644=0A=
> --- a/src/filter.c=0A=
> +++ b/src/filter.c=0A=
> @@ -335,16 +335,22 @@ ct_filter_check(struct ct_filter *f, const struct n=
f_conntrack *ct)=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 switch(nfct_get_attr_u8(ct, =
ATTR_L3PROTO)) {=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 case AF_INET:=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ret =
=3D vector_iterate(f->v, ct, __ct_filter_test_mask4);=0A=
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (ret ^ f=
->logic[CT_FILTER_ADDRESS])=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (ret && =
f->logic[CT_FILTER_ADDRESS]) {=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 break;=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } else if (=
ret && !f->logic[CT_FILTER_ADDRESS]) {=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 return 0;=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ret =
=3D __ct_filter_test_ipv4(f, ct);=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (=
ret ^ f->logic[CT_FILTER_ADDRESS])=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 return 0;=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 brea=
k;=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 case AF_INET6:=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ret =
=3D vector_iterate(f->v6, ct, __ct_filter_test_mask6);=0A=
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (ret ^ f=
->logic[CT_FILTER_ADDRESS])=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (ret && =
f->logic[CT_FILTER_ADDRESS]) {=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 break;=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } else if (=
ret && !f->logic[CT_FILTER_ADDRESS]) {=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 return 0;=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ret =
=3D __ct_filter_test_ipv6(f, ct);=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (=
ret ^ f->logic[CT_FILTER_ADDRESS])=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 return 0;=0A=
> --=0A=
> 2.20.1=0A=
