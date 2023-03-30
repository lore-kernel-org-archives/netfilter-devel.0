Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2CA0C6FD1D
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Mar 2023 08:49:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbjC3ItD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Mar 2023 04:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbjC3Is7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Mar 2023 04:48:59 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2098.outbound.protection.outlook.com [40.107.8.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD045B8E
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Mar 2023 01:48:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lwqDu1DyL9k5mUhNX7GIaQ7bARAFo/Obsxj0DkuBwCt8LzRKkbSmwxcugYtszrDRijMgvnpJDQ7Mv6OrJGQgB7BH4+1BT/E/q9RmIlAAJpN7cJIieKuANxDdHyM+6Dn8hj7Nj3JrcdJR4cJJqLB55UNX5QstwovbjmN94/iYsWgfr/LU9EGWosbF2VSODFAEU3CAfhlTzAZIPnrJZT7/DevzLds+FF087EAH8CLzZkxuU94wEmT7R7maci6a0e5zQaXJzMT7oOXrf8UMM9G4A/uV8Bx0yddexPNk0y+19clhRPgW6O3m9WIWNG5guqRG2IeC0EWxjil7OIS+zxYTxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rwf5RJWyCwvOBC5c7PZ96fiu3NhntQbXcs/ZHcc+2Ak=;
 b=H6j4F2QN8lvmpXAZE0HV9ShPj3zHMZ1e2HGCy2Ww1tf4v4qMNqnzvp2wSOvzo3nil0/r3BKIwsXgx0c5UT5WV/XpUHv5pcbu8Uzpok+h4Dt2eEFmC24SJv/N1Cm5L9ZTSF1K9dJ2ijoWPAsHjPtvng2d3B29JUMn9obTZIfUj578O0YhLpFk7B5I0qp+7V3U1b8pIIfimYbGxefCFX7x9sthZGu+GEVIG9cfvFifGvYlMzVuhnpf4VavnCBmupikdM3Vvzpfcs04/d3PGAvO6+eUEgGs7HiGpLP2Ej/z70BUtsTSLcTL75CqVU9KWdqXEFok+jxBeJAeaVEtxcX/yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prodrive-technologies.com; dmarc=pass action=none
 header.from=prodrive-technologies.com; dkim=pass
 header.d=prodrive-technologies.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=prodrive-technologies.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rwf5RJWyCwvOBC5c7PZ96fiu3NhntQbXcs/ZHcc+2Ak=;
 b=p5/YA6G/SXEYnfte4uuv6ru4cxTC3vFb5k1tsepHtbFa/cYOJQgNShxce5FS7eLL+G8JkA6LvownXXL0zPKEvsIlvD/P+iAzNHcTegqxhBhQSbCzDkZF/z05528V1jHqoRTYCFlcNYk9DMLERIRZfFKh0L9UC76w70IguEps8Ys=
Received: from AM9PR02MB7660.eurprd02.prod.outlook.com (2603:10a6:20b:43f::24)
 by PAXPR02MB7797.eurprd02.prod.outlook.com (2603:10a6:102:230::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22; Thu, 30 Mar
 2023 08:48:52 +0000
Received: from AM9PR02MB7660.eurprd02.prod.outlook.com
 ([fe80::8203:5198:960f:908b]) by AM9PR02MB7660.eurprd02.prod.outlook.com
 ([fe80::8203:5198:960f:908b%9]) with mapi id 15.20.6254.021; Thu, 30 Mar 2023
 08:48:52 +0000
From:   Kevin Peeters <kevin.peeters@prodrive-technologies.com>
To:     Phil Sutter <phil@nwl.cc>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: RE: iptables patch
Thread-Topic: iptables patch
Thread-Index: AdlhRd8vxRo6EOAnSHqnLy8oibYvxwAADfyQAAAMYkAAAAsqkAAR0gUAACA3GeAAByq7AAAt2oKw
Date:   Thu, 30 Mar 2023 08:48:52 +0000
Message-ID: <AM9PR02MB766020CCB0BAF3AEC73E96D2A88E9@AM9PR02MB7660.eurprd02.prod.outlook.com>
References: <AM9PR02MB76606476D4EED1FF1938F8A8A8889@AM9PR02MB7660.eurprd02.prod.outlook.com>
 <AM9PR02MB766074FF89D28CE6655CA0B6A8889@AM9PR02MB7660.eurprd02.prod.outlook.com>
 <AM9PR02MB7660795D89727FA09BD370DFA8889@AM9PR02MB7660.eurprd02.prod.outlook.com>
 <AM9PR02MB766039341028D34A400D381CA8889@AM9PR02MB7660.eurprd02.prod.outlook.com>
 <ZCMN+lPI1YxWTyiQ@orbyte.nwl.cc>
 <AM9PR02MB766031C4F54E853C3D3AC1A6A8899@AM9PR02MB7660.eurprd02.prod.outlook.com>
 <ZCQWRF8aPQeu6Biv@orbyte.nwl.cc>
In-Reply-To: <ZCQWRF8aPQeu6Biv@orbyte.nwl.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=prodrive-technologies.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM9PR02MB7660:EE_|PAXPR02MB7797:EE_
x-ms-office365-filtering-correlation-id: 6714fc83-5c4e-494e-976a-08db30fb96c1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cPgm5oI9Ctxc0tWQvzgk0RggmdrLqBvWjMIeTTmVQ4vSuK+EqKka2YG/MG86+OhBenv7Zm2UUexOGzyteHZQRkMT+r43qdX5eVEVBqv7+gFih3fDjG8t0FMSrZfvm20qJEw/jTm6s/WRVQ/VNhulJzT0gBSnyRCuFP2EdwBuzXyEacTRWuoBnqmBpcW2UKuxQwjmrjPKig7wnnW75k9HWdS7enfIHv+7lrEBqrubU0Rr39D7fri64OQe7mlvpmNYIyU7xcIxl+vOPtr7gCbfHkzqeg/GuPbet0yC7X/VrcTH+fPfAW0ffUpmkUY4DfvOMoHzd0dJXQ67UgHxLrAZYm0OrUzUKVgJD3FAWCMeDjrKVzBsVqIbxSAGidgyJK7Hr2RmX8rTp8o8PLCrHTRKYygv5qaR+YVKtlaUJCZV7+UNG/aG00S++BoZb3i2ucZezxxZ0xhe0TgHaoTUuFHCbYN8BksCrwloe3NR9Yo9xumE68GIRkITshrb4fy7mqnyepzBE/KLrCL4096SV6oj2HHniZjQQsQaXSHQ9NBRtp4dLcy8ZOeNpYQ3/pgHjiDFSxP0oksc/LfLjwCf+Zqrr3EzIbYJXnfyJRyOtjzfnc+R+j6+n6LBGTRgV7Bu2rKa
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR02MB7660.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(136003)(366004)(376002)(39850400004)(451199021)(6916009)(122000001)(38100700002)(33656002)(44832011)(7116003)(5660300002)(8936002)(4326008)(86362001)(38070700005)(66946007)(76116006)(8676002)(52536014)(55016003)(64756008)(66476007)(66556008)(41300700001)(66446008)(3480700007)(83380400001)(26005)(9686003)(6506007)(2906002)(7696005)(71200400001)(478600001)(316002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YYmtlF/MzRQeCNZWi98ScHH7zkARGnZMu9s5EM+yGn1ukJlfHikmdmiqTXUk?=
 =?us-ascii?Q?xSlAavZLxJhWup3Gwwb49KXxkO4NlBJ+HK/E3os2e92QRNxgStLW79umtbEG?=
 =?us-ascii?Q?gxCCqFqVHJz9wQkHjHCiFWcY1DrGDfLrmhv9uYX5fyRp5OLVc4AIgWGeboGv?=
 =?us-ascii?Q?/Cj4k+P2MLtrF+dCLOReArMkv2jfBtITyuvSbz3Fo/OjfamVnwxNUPscNC4Z?=
 =?us-ascii?Q?TI6IIwaJBUeFsbw5R5e931j5dM5pw2PdnHPq/FEvExID8vG+pMhI/GxEH+rs?=
 =?us-ascii?Q?ozHaMu2Lhr4ZTgNN/7pL+ogR222+5nSEIVWzEhYzHfx7O1F8mweMaRyaiDBx?=
 =?us-ascii?Q?G3eoFKw7Qkbux0GuQUhr2c+pBPaEd65XPnax+0mGLpOvFvxhWi5MchlbWkNi?=
 =?us-ascii?Q?jn4Xhb0rZhaHEuo+S35l+DDFGC3R0wUSZiu9BKxtcVJmLD8eoe46iX6K6k/i?=
 =?us-ascii?Q?Q/c0sIkO4GEkFj9oKRHm9TG/gELQWog6dR3YNLiJHdADAw7oVEbzDmeK3Rla?=
 =?us-ascii?Q?5saIAzq87pglEHKeYef9/40RkA16wSyKg6VIZO6WBnwu6qZBt0gS04K40IoC?=
 =?us-ascii?Q?xadDcvouwxZlj70VPoMWHe9KzsagrIerIXYkPyplHStgqNFruKa0mvpumXRY?=
 =?us-ascii?Q?mQ6XhwDix/wpdWRYrFo58AlDfeaMgVylEfnIMOZK+HNhlOw27XVJh2O3cW5D?=
 =?us-ascii?Q?nfZRVdUud6ttwuT+WjDlAQ3z3WdyI0x/rUiY03BpuNHZkhpHVtrPzIUytDcs?=
 =?us-ascii?Q?HR0XpCT2TT562TSBnTVeo/OC7IH85Mn9Mw4dXzkbwEqahFJlK5erBTBdcU5J?=
 =?us-ascii?Q?deOyG4IJKfARsWH1sbbm3NVpHMKIzU9WUQIPH0aqVPlSXfUAKsmPVDntYnts?=
 =?us-ascii?Q?wRNCNjlurv8aMRjJQ0iPoAoAa0h2c4v0GBsyru2R+xAVXDEm0lrGauxTPCV4?=
 =?us-ascii?Q?/+Fx5bwiCnJNONJed83jVxnwBXMvHW/96KW0Pp52skmuHdl0EjnLwXaCuR09?=
 =?us-ascii?Q?03hzVOZ8t8xYXI8A4FKAzXLewOhy8sZ2sVjQ7ICaKSkU8eYwX34G+EP8FfyQ?=
 =?us-ascii?Q?WmCwI1Q1jzpyTjVLzpBxUmEVOhdbtXqG31CtR4HzMdV/j9iBm3+KGwhJVBPm?=
 =?us-ascii?Q?X2eyuEK8dgG4r9a2574ZK2pWxT2KbAr/EXdRiQgqMkPXynfI4M0pQzq70AI9?=
 =?us-ascii?Q?FlgrEYC4uR8AWFXXdlRNyrYveXpK5spOrLe2EslOpsyjHH2VuTsc0xPAlpdF?=
 =?us-ascii?Q?p4lAjNZ3GpOszeZRXdzs7vcRDqP1Vlu64/LcnY15lmpsdQiajitMAxQPmMB+?=
 =?us-ascii?Q?C9DErTWjwp0LqZi3u8P/EVrTr8U6lIX9pKIwXmHVp1gYdcHYHgDiWWzrObO1?=
 =?us-ascii?Q?ke6yu0GFukaUcyuIaaSi/+VTJwCJZQFjLpen0x8yd0bqWL6/nP9ttLxbTgfe?=
 =?us-ascii?Q?7I1fpnKVSWcf265rHtOoDP7qdwlAPGzBUEgZpHJnRCv9iNBBskL86Px3pklL?=
 =?us-ascii?Q?oodyjkBk2R2VMMxRV4NWRIvOuC/Fn77BuNrTqWHMNSPqOvqWFj88KHIBuPS6?=
 =?us-ascii?Q?4HzoKAVqDttoK3wPTCOfhScBEAWCnOsIM0gg9WeBJtyUnCxpv/1PaWeyEh69?=
 =?us-ascii?Q?gn3WzKEuMQXfixtdiC1SZ/k=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: prodrive-technologies.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR02MB7660.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6714fc83-5c4e-494e-976a-08db30fb96c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2023 08:48:52.6696
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 612607c9-5af7-4e7f-8976-faf1ae77be60
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jO5zEnUF6yp25Oa6FOyUc9nx81w8BOdjlGQZ7gwUCen4dMfamZSccXooQIQUJgcQoGLsYMxLeyu1XIqMLBRxmKCcGa/znbeVV+4rS97DfHobt/H1CqZfXVTeKGIthHmT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR02MB7797
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello=20

>> >> I am using the 'iptables' source code in one of my software projects.=
 More in detail, I am calling libiptc and libxtables from my own software A=
PI to add/delete/... iptables firewall rules.
>> >>=20
>> >> While developing, I bumped into one issue while using libxtables and =
made a patch for it which we now use on our checkout of the 'iptables' repo=
sitory. We do however use multiple checkouts of this repository in differen=
t places and don't want to add the patch to each of those checkouts.
>> >> Would it be possible for you to add this patch to the mainline of you=
r repository so we can stop patching it locally?
>> >>=20
>> >> The details about the patch:
>> >> In libxtables/xtables.c:
>> >>=20
>> >> The libxtables code uses a xtables_pending_matches, xtables_pending_t=
argets, xtables_matches and xtables_targets pointer list to track all (pend=
ing) matches and targets registered to the current iptables command. In my =
code, I add/delete firewall rules multiple times from one main process (wit=
hout killing the main process in between) by calling xtables_init_all, xtab=
les_register_target and xtables_register_match every time. When a rule is a=
dded, I call xtables_fini to clean up.
>>=20
>> > I don't think you should call xtables_register_{target,match} over and=
 over again. Why don't you follow what iptables does and call xtables_find_=
{target,match} to lookup an extension? It tries loading the DSO which calls=
 xtables_register_*. After adding the rule, you should free the rule, not d=
einit the library.
>>=20
>> If I understand correctly, xtables_find_* will only look for the desired=
 match/target in the list of pending matches/targets. If the match/target i=
s never registered up front, the list of pending matches/targets will be em=
pty and xtables_find_* will fail. This is also done in the iptables flow, e=
.g. in extensions/libxt_tcp.c.

>The functions search for the extension in xtables_pending_* list, but if n=
ot found they will call load_extension() unless NO_SHARED_LIBS is defined. =
In the latter case, extension code is built-in and extensions'
_init() functions are called from init_extensions*() functions which in tur=
n are called by iptables at program start.

Ah indeed! It seems like I have NO_SHARED_LIBS defined, which is why I have=
 to manually register the targets/matches.

>> I do free the rule after adding it, and it felt reasonable to deinit the=
 library as well, as this is also done for iptables.

> The various iptables binaries deinit the library at program exit and don'=
t reuse it.=20

> I don't know what you used as blueprint for your implementation, but you =
might want to have a look at iptables_restore_main() in iptables/iptables-r=
estore.c. It basically does:

> | xtables_init()
> | xtables_set_nfproto()
> |=20
> | init_extensions()
> |=20
> | /* do all the work, repeatedly, unlimited if reading from stdin */
> |=20
> | xtables_fini()
> | exit()

This is what I based my code on indeed. The only difference in my code is t=
hat I do the init()/fini() calls on every rule I add. This is no hard requi=
rement so I can change it if you think that is the best option.

Cheers, Phil
