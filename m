Return-Path: <SRS0=eJXe=SP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48064C10F11
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Apr 2019 18:32:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9807208E3
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Apr 2019 18:32:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alum.wpi.edu header.i=@alum.wpi.edu header.b="pTKGK8/w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbfDMScd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 13 Apr 2019 14:32:33 -0400
Received: from mail-eopbgr810071.outbound.protection.outlook.com ([40.107.81.71]:45376
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726936AbfDMScd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 13 Apr 2019 14:32:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alum.wpi.edu;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZEddEZo6A3DgvOLoVqjZtGF0cGQ4xAOM3iEWxPloNPg=;
 b=pTKGK8/wkduiendP2EUvPOlz13Jl/3DnmrUrpzM4I6qjk6Dc1/jJn+Tv1JIEs0R2mrUAlMpHuY/sG4R6FxIpu4GP2nlrDkdaCEuRIRv5GmjMj8LMdE4PS8eO3i6Dmrr4wYyYs6kYhNRbOhnAx7XVpIWUhwl7A8CSyicr25McKT0=
Received: from DM5PR2201MB1545.namprd22.prod.outlook.com (10.174.187.24) by
 DM5PR2201MB1258.namprd22.prod.outlook.com (10.174.177.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1792.15; Sat, 13 Apr 2019 18:32:29 +0000
Received: from DM5PR2201MB1545.namprd22.prod.outlook.com
 ([fe80::a0df:e9a1:178c:7754]) by DM5PR2201MB1545.namprd22.prod.outlook.com
 ([fe80::a0df:e9a1:178c:7754%6]) with mapi id 15.20.1792.016; Sat, 13 Apr 2019
 18:32:29 +0000
From:   "Neal P. Murphy" <neal.p.murphy@alum.wpi.edu>
To:     nhhabsburglothringen <nhhabsburglothringen@gmail.com>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "netfilter@vger.kernel.org" <netfilter@vger.kernel.org>
Subject: Re: iptables: undefined symbol: xtables_find_target_revision
Thread-Topic: iptables: undefined symbol: xtables_find_target_revision
Thread-Index: AQHU8ic+n+g8NBtbHUWEyxwK1PaVNg==
Date:   Sat, 13 Apr 2019 18:32:29 +0000
Message-ID: <20190413143226.1f9412e2@playground>
References: <e5c1c274-3032-cf1f-0fe8-a66527339085@gmail.com>
        <7be7c78a-cd69-bcc9-e181-c7c6eec68f43@gmail.com>
        <20190413004257.GA2270@dimstar.local.net>
        <2b4c9c9a-7524-8d72-26f4-34bf2eb95182@gmail.com>
In-Reply-To: <2b4c9c9a-7524-8d72-26f4-34bf2eb95182@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MN2PR04CA0002.namprd04.prod.outlook.com
 (2603:10b6:208:d4::15) To DM5PR2201MB1545.namprd22.prod.outlook.com
 (2603:10b6:4:36::24)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=neal.p.murphy@alum.wpi.edu; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: Claws Mail 3.14.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
x-originating-ip: [73.148.50.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a3f66fb3-62d0-4168-61fc-08d6c03e626f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7025125)(7027125)(7023125)(5600139)(711020)(4605104)(2017052603328)(7193020);SRVR:DM5PR2201MB1258;
x-ms-traffictypediagnostic: DM5PR2201MB1258:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DM5PR2201MB12584020747355BD7C6A4E7B88290@DM5PR2201MB1258.namprd22.prod.outlook.com>
x-forefront-prvs: 00064751B6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(346002)(39850400004)(376002)(396003)(366004)(136003)(199004)(189003)(6916009)(76176011)(786003)(316002)(5660300002)(6306002)(6436002)(50226002)(305945005)(229853002)(86362001)(25786009)(6486002)(6512007)(11346002)(8936002)(476003)(9686003)(966005)(486006)(97736004)(446003)(14454004)(68736007)(88552002)(2906002)(71200400001)(71190400001)(106356001)(6246003)(81156014)(81166006)(8676002)(4326008)(1076003)(66066001)(105586002)(53936002)(7736002)(99286004)(256004)(6116002)(102836004)(5024004)(1411001)(93886005)(6506007)(33716001)(386003)(26005)(3846002)(508600001)(52116002)(186003)(75432002)(54906003)(39210200001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR2201MB1258;H:DM5PR2201MB1545.namprd22.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: alum.wpi.edu does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: p3mcPZR/ntfV1SEkrELH/+H7iK2T7SHDPs1HHSHUMNRO/23LmqKVq6cYVE5St83eeJTA8Cg5pWBIAfChG8AhIJ7CPU6Tmzbi2EiSYMdzHH/HSbCXfYK2iamFuW1D8ZlQAtiFpuCsP21Zzx61WfQhG14wdico055rFa1yVol3f487RzEI+v1SkI9v8FVf6Y+YhkytQMr6TvAOirJdefdOJ4euL92VTbie9myW47tK0ZQ+QB2ajpirJZlg2LQ1ABatFTiOY18Wqchxn2WL5C5ApWfxjnM6Yco+IlyHQcxQIECtOxPEBkDlpezOVKLnwggbkoIIAx+TbmpF2M3zXfWahCfmwuoDBlXW4sHGSwlNlB7KJaQLfL5v6KNxCpe6Lkym6snBkB2lWPC/FTBmbS1G4CLiQVDYBqCzMpeUSj4AsC8=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <599FE7311548A048B3657FBE755DCB39@namprd22.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: alum.wpi.edu
X-MS-Exchange-CrossTenant-Network-Message-Id: a3f66fb3-62d0-4168-61fc-08d6c03e626f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2019 18:32:29.3807
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46a737af-4f36-4dda-ae69-041afc96eaef
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR2201MB1258
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Actually, because it's 'xtlibDIR', I believe the option should be
    --with-xtlibdir=3D/lib


On Sat, 13 Apr 2019 11:24:46 +0200
nhhabsburglothringen <nhhabsburglothringen@gmail.com> wrote:

> More interesting suggestion, very very thank.
>=20
> Today I will try to compiling with the modifications suggested and I
> will send the result.
>=20
> Actualy, in my sistem (debian 9):
>=20
> in /lib I have the libxtables.so.12.2.0 and the directory xtables with
> all other
> library;
>=20
> I have not the /usr/lib64;
>=20
> in /lib64 I have only one symbolic link to ld-linux-x86-64.so.2 that
> point to /lib/x86_64-linux-gnu/ld-2.24.so.
>=20
> I will try with and without the directive --libdir=3D/lib/x86_64-linux-gn=
u
> (that may is the correct pat for my 64bit library).
>=20
> After done, I will report the result
>=20
> Emy
>=20
>=20
>=20
> Il 13/04/2019 02:42, Duncan Roe ha scritto:
> > On Sat, Apr 13, 2019 at 01:07:36AM +0200, nhhabsburglothringen wrote: =
=20
> >>
> >>
> >> -------- Messaggio Inoltrato --------
> >> Oggetto: 	Re: iptables: undefined symbol: xtables_find_target_revision
> >> Data: 	Sat, 13 Apr 2019 00:56:20 +0200
> >> Mittente: 	nhhabsburglothringen <nhhabsburglothringen@gmail.com>
> >> A: 	Duncan Roe <duncan_roe@optusnet.com.au>
> >>
> >>
> >>
> >> Hi, thank you.
> >>
> >> I have test the 1.8.2 and the 1.8.0 with the same result.
> >>
> >> The older 1.6.2, working fine (I have completed the check).
> >>
> >> May be there are a bug ?
> >>
> >> Emy
> >>
> >> Il 10/04/2019 13:11, Duncan Roe ha scritto: =20
> >>> On Wed, Apr 10, 2019 at 11:09:25AM +0200, nhhabsburglothringen wrote:=
 =20
> >>>> Seems to be a problem of version 1.8 because compiling the 1.6.2 whi=
tout
> >>>> any modify, all working fine (I reserve further checks but it seems =
to
> >>>> be so).
> >>>>
> >>>> Can be a problem linked to the new name *legacy (maybe some library
> >>>> don't recognize it).
> >>>>
> >>>> Any idea ?
> >>>>
> >>>> Emy
> >>>>
> >>>> Il 09/04/2019 21:14, nhhabsburglothringen ha scritto: =20
> >>>>> Hi to all.
> >>>>>
> >>>>> I have compiled from source iptables v1.8.2 on debian 9 with a kern=
el
> >>>>> 4.9.144-rt93 64bit also recompiled for enable use of imq as module =
and
> >>>>> other stuff.
> >>>>>
> >>>>> no error configurig (./configure CFLAGS=3D"-ggdb3 -O0 -DDEBUG"
> >>>>> --prefix=3D/usr --sbindir=3D/sbin --enable-libipq --enable-bpf-comp=
iler
> >>>>> --with-xtlibdir=3D/lib/xtables) nor during compiling with make, but
> >>>>> running when I try to write a rule (for example: iptables -I FORWAR=
D -j
> >>>>> port-filter (after iptables -N port-filter) if I type iptables -L I=
 get
> >>>>> this error:
> >>>>>
> >>>>> Chain INPUT (policy ACCEPT)
> >>>>> target     prot opt source               destination
> >>>>>
> >>>>> Chain FORWARD (policy ACCEPT)
> >>>>> target     prot opt source               destination
> >>>>>
> >>>>> iptables: symbol lookup error: iptables: undefined symbol:
> >>>>> xtables_find_target_revision
> >>>>>
> >>>>> There are some person that can help me ?
> >>>>>
> >>>>> Thank in advance,
> >>>>>
> >>>>> Emilio =20
> >>> --
> >>>  Please avoid sending me Word or PowerPoint attachments.
> >>>  See http://www.gnu.org/philosophy/no-word-attachments.html
> >>>
> >>> 1.8.1 is latest.
> >>>
> >>> xtables_find_target_revision is supplied by libxtables.so.12.1.0
> >>>
> >>> Hope that's some help,
> >>>
> >>> Cheers ... Duncan. =20
> > Hi Emy,
> >
> > Your ./config directive --with-xtlibdir=3D/lib/xtables looks wrong to m=
e - I think
> > it should be --with-xtlibdir=3D/lib/libxtables
> >                                   ~~~
> >
> > Why do you think you need it anyway? I would miss it out.
> >
> > When building for 64-bit, I always include --libdir=3D/usr/lib64. Maybe=
 some
> > Makefiles look after that but it's in the SlackBuild template so I alwa=
ys use
> > it.
> >
> > Cheers ... Duncan. =20
>=20

