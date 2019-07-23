Return-Path: <SRS0=NVo7=VU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63272C7618B
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jul 2019 14:41:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 039B821738
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jul 2019 14:41:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alum.wpi.edu header.i=@alum.wpi.edu header.b="Pwf3GlKK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732696AbfGWOlZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Jul 2019 10:41:25 -0400
Received: from mail-eopbgr750047.outbound.protection.outlook.com ([40.107.75.47]:28411
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727819AbfGWOlZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Jul 2019 10:41:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uf/q8eMPawIqa0bKEh7hsFfBnREBQqYQ9PriGZ7nexFtrs0IPjmNcGiuUhs1B5Gj5bzr5U6EW13GSMM1tXOOcYoeJVpBjZzy1DTH4/cbTN4W4FZVr5oWt7kXiTD4UP91uWzQzQn32gFQqQq/LtBhQlI3ron1TBdD/gRdjlZmakEWS17M4Wz6TG4LL7Lu+h74dBCEZ9nFiIezo1GuTyY6iiqbv3G4vFjiXp4/RmnYidXOmohdoLymU+khb8Wu3zcqtF94HSXmyx6BoWXShlKfW9qIUubGLZCswU9ohejZ6uekMnuFf6YzRL+KctYazgXzkuGZL5HG4w2VSY7m4Ea7JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xUy7G2m5j7vwmy0WCQFY4j0G/6c5WS1Oksst6/g6mEE=;
 b=U9zbSvS3d0wQ7yglcVjwyqU9hov+BLa1vZvcavFV51/M2ORy9ErHiOyxgx8Mq2ix4p8jhML1RFW6K2y/mWSDvI3mCgS/uTotgnYXHxCGwsUcEdLLy5LAXB4I1c/l9EjpmfcjlKsQzi+Tb7DNV1lxE3Rl0ui+nFcahDHLr4m1s6GYKEDSs1YyM1tRmBeq7CuQ58ffLRI6SiZB6AK4slbsfGfikCUSa+F1CDKc4BmRkZJtXT2b1ScxuZ9G8+DeN2oRXGnYs0AK5yuLnJk6EG30kBYKFCAY3IKnPy+XqKxJ49Lkodg8eQadWSzVNhHwuNTPbYKYkt7GtwidPwec7f3i6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=alum.wpi.edu;dmarc=pass action=none
 header.from=alum.wpi.edu;dkim=pass header.d=alum.wpi.edu;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alum.wpi.edu;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xUy7G2m5j7vwmy0WCQFY4j0G/6c5WS1Oksst6/g6mEE=;
 b=Pwf3GlKK6LCOenJ/Zy7ElIdUkN1xLrrsrRMkJ9RmpiEVPJzHANVLIsRheX3212Gn1nmXHWNhU45kFVH0xifq6xRXntzAaP0fbdNTMiDC1uTu7yxHlC80Wy/77UPN8nFPju6OU4Qz7kzIKN1kyeKCMFPL/d6NG8IzkaKWxlDhi0A=
Received: from DM5PR2201MB1545.namprd22.prod.outlook.com (10.174.187.24) by
 DM5PR2201MB1129.namprd22.prod.outlook.com (10.174.186.36) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Tue, 23 Jul 2019 14:41:18 +0000
Received: from DM5PR2201MB1545.namprd22.prod.outlook.com
 ([fe80::8439:fff9:56cc:cd02]) by DM5PR2201MB1545.namprd22.prod.outlook.com
 ([fe80::8439:fff9:56cc:cd02%6]) with mapi id 15.20.2115.005; Tue, 23 Jul 2019
 14:41:18 +0000
From:   "Neal P. Murphy" <neal.p.murphy@alum.wpi.edu>
To:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: ct state vmap (nft noob question)
Thread-Topic: ct state vmap (nft noob question)
Thread-Index: AQHVQWSt18pkxeKRnUyuM5gpMmTbUA==
Date:   Tue, 23 Jul 2019 14:41:18 +0000
Message-ID: <20190723104114.3a8675cc@playground>
References: <87tvbd3yiw.fsf@goll.lan>
In-Reply-To: <87tvbd3yiw.fsf@goll.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BN6PR11CA0038.namprd11.prod.outlook.com
 (2603:10b6:404:4b::24) To DM5PR2201MB1545.namprd22.prod.outlook.com
 (2603:10b6:4:36::24)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=neal.p.murphy@alum.wpi.edu; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
x-originating-ip: [73.148.50.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ac84fdfc-e4dd-4011-7761-08d70f7bd235
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7025125)(7027125)(7023125)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM5PR2201MB1129;
x-ms-traffictypediagnostic: DM5PR2201MB1129:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DM5PR2201MB1129B4C2058450ABD33D50E288C70@DM5PR2201MB1129.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(376002)(346002)(396003)(136003)(366004)(39850400004)(189003)(199004)(6116002)(68736007)(6916009)(3846002)(33716001)(186003)(5660300002)(11346002)(6436002)(2906002)(99286004)(75432002)(50226002)(66066001)(305945005)(347745004)(52116002)(1076003)(446003)(25786009)(71190400001)(71200400001)(508600001)(81156014)(66946007)(81166006)(966005)(14444005)(6506007)(386003)(6246003)(6486002)(26005)(2351001)(6306002)(76176011)(256004)(88552002)(14454004)(16799955002)(229853002)(9686003)(6512007)(64756008)(316002)(86362001)(786003)(2501003)(5640700003)(476003)(7736002)(8936002)(8676002)(53936002)(66476007)(66556008)(102836004)(66446008)(486006)(39210200001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR2201MB1129;H:DM5PR2201MB1545.namprd22.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: alum.wpi.edu does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: C+7GuTTGWumcJeFu76lUqtDWunam67pLQdE0RmrxBjLAFidJrsMe6tYPSQcBV6ZOQi9ZMSkB5MJbkV9TzYvdbtCIZ6fRtnPoeVwxDFTFckhjl5YU01nivvb01lK4tyW0NkzQKS2/+C31aCb/XnbSVMmzTGQNfdFduNTEl8wCYGsAGP/f+FNIhA5+okNFrj2Jo587SCKU2avTevkjwR10PI3lw7eoC+0Kw1AL1UVB23+GUTgBZG45BuqrK1RQqGjnBEvt1jkm0DKV8y29vZ8bn8yXu8OdPzR3RaAeG+zkQrEoFdUsQP2f/jJzr6Z0cf6uaSGMqZDIgCwfwAi08sYLYBiqFAdXkYi/ooXOnDlnBsSUz2U+rwi/2vOjn8FiLHvaNw9KYuJtcvbeqMdEmBjmHZKy+RwBh6blQpmlqboQ+3M=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <037BDB99BBC94045A0857586A3DAAEBD@namprd22.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: alum.wpi.edu
X-MS-Exchange-CrossTenant-Network-Message-Id: ac84fdfc-e4dd-4011-7761-08d70f7bd235
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 14:41:18.0206
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46a737af-4f36-4dda-ae69-041afc96eaef
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: neal.p.murphy@alum.wpi.edu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR2201MB1129
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 23 Jul 2019 19:12:23 +1000
"Trent W. Buck" <trentbuck@gmail.com> wrote:

> (I hope these questions aren't too stupid for this list!)
>=20
> A stateful firewall ruleset usually starts like:
>=20
>     ct state established,related accept
>     ct state invalid drop
>     # Hooray, 99% of packets are now decided;
>     # we only need to think hard the ones in ct state new!

Personally, I drop INVALID packets in PREROUTING in order to waste no more =
CPU cycles than are necessary because we already know that that packet cann=
ot be processed.


>=20
> If you want to guard against a coworker "accidentally" adding NOTRACK in
> raw, you might tweak that to drop "ct untracked" as well:
>=20
>     ct state established,related accept
>     ct state !=3D new drop
>=20
> But nftables has these "verdict map" things now:
>=20
>     ct state vmap { established:accept, related:accept, invalid:drop }
>=20
> Is that "better" than the original?
> It's one less rule, so it ought to be more efficient, right?
>=20
> One obvious downside is you lose the ability to counter/log/reject the
> ct state invalid packets, because those aren't valid in verdict_expr.
>=20
>=20
> Why is the original allowed to have "established,related" without braces?
> [UPDATE: answered below]
>=20
> I'm a little bit worried because "nft describe ct state" looks like a
> list of flags (powers of two), and in parser_bison.y I don't understand
> ct_expr, but set_flag_list is using a comma as a bitwise OR.
>=20
> Can a packet be *both* established and related at the same time?

'RELATED' is the first ('NEW') packet of a conn that has been determined to=
 be related to an existing conn. As far as I know, once a conn transitions =
from 'RELATED' to 'ESTABLISHED', the system loses all knowledge that the co=
nn was ever 'RELATED' in the first place. I mention this because I've never=
 been able to determine if netfilter will close/terminate 'RELATED' conns w=
hen it closes/terminates the master. For example, if netfilter terminates a=
n FTP control conn, does it also terminate data conns that were 'RELATED' t=
o that control conn?


>=20
> If so, is "ct state established,related" matching any packet that has
> established or related *OR BOTH*?
>=20
> If so, does that mean it will accept some packets that my vmap (above) wo=
n't?
>=20
> The parser won't accept "{related,established: accept}" in a vmap, but
> it will accept a pipe.  Does this has the same meaning as the original
> pair of rules?
>=20
>     ct state vmap { invalid : drop, established | related : accept }
>=20
> I think so, because the pipe comes back out as a comma here:
>=20
>     # nft add rule 'inet x y ct state established|related accept'
>     # nft list chain inet x y
>     table inet x
>       chain y {
>         ct state established,related accept
>       }
>     }
>=20
> Oh using the English word "or" is probably clearer, at least for
> anglophones:
>=20
>     ct state established or related accept
>     ct state vmap { established or related: accept, invalid: drop }
>=20
> The equivalence of "or" and "|" and "," --- except inside a set/map ---
> wasn't obvious to me from the nft manpage (as at 0.9.1).  I "caught on"
> because equivalences like "ne" and "!=3D" were mentioned here:
> https://wiki.nftables.org/wiki-nftables/index.php/Building_rules_through_=
expressions
> (no bitwise operators there, though)
>=20
>=20
> PS: AFAICT if a vmap doesn't match, the rule doesn't match, so
> processing just carries on to the next rule.  Is there a way to have a
> "default value" in the vmap?  e.g.
>=20
>     ct state vmap { established or related: accept,
>                     new: continue,
>                     OTHERWISE: return }
>=20
> I can't see it in verdict_map_list_expr or in the manpage.
>=20
> PPS: my earlier "chain comment" question, I now realize the "NOOP rule"
> I wanted is just "continue", e.g.
>=20
>     table inet x {
>       chain y {
>         continue comment "This chain is the common start for INPUT and FO=
RWARD."
>         continue comment "It allows the things you (almost always) want."
>         ct state vmap { established or related: accept; invalid: drop }
>         iiftype loopback accept
>         icmp type { ... } accept
>         icmpv6 type { ... } accept
>       }
>     }
>=20

