Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1C4DC6FD18
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Mar 2023 07:32:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjC2Hc3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Mar 2023 03:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjC2HcC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Mar 2023 03:32:02 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on0727.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe1e::727])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456E94ED1
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Mar 2023 00:29:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kf4fweksk3vrWUQWpfGqKK4ofGSd9e7v5mCeb5HuCYsXo4/pfxDPjji2fxS6cmFIghdiB9hGQJ2RNFXnWb6Kq5SQ6fCUFOhssMDQmqIiDWwI98u9+K3QkbdnVhkGGSuJtz7owbyoubAFHf6THmwfzxN42wASh7MgCEE0odmXkrra0hMmPXcPdUTRMPchsbTdepyhsMg7EzdHLgSIr/eybpm/GJEf5r7bsD4MIXlNC52jt4oJUbxbeoLMm/Z9zWbKGAxt0Y70ZN1QnZ2c0uN4b1Un2LZHKQFpYX5LNfOZNM3K3iYXKYFAu9MsG7EEbgrrrJGuyB3oYKNsv6vLQjH2qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bYPPm2UmRKKnY7t/GI/+hhxt9cDvCEVJcSgQ1+uR6CM=;
 b=R1PV6mGz3oDaAqugE1ChLkQYtVeAH5EynPVglAYWtX1CzXEajz86T8PWe3CaaqsvO7IMScxRwt2W91c6aj0h3nyHqgS/dZGNtXxlZ9ekSPTVGBKpxWEa0FvX0VZrLhantIinTLYyG82iGZhxkwTzFPKUQ4nmdxkd/76t4rqQH8edDcdgSZDz3bjHO/+y5Ta53t5lNxVC7oEiNm4IYas2wTfm9rymPXd0rZVMcVTWMuF1iieVZrhgwtEDN4ZPGqCloNw3LboZjwL0hZOHmsPdkAg6c58AzhKBO9uUNgmFZDShwwwz6EYnCqYy9/GVOtoh93NANTIscrr+zqqK4VYZlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prodrive-technologies.com; dmarc=pass action=none
 header.from=prodrive-technologies.com; dkim=pass
 header.d=prodrive-technologies.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=prodrive-technologies.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bYPPm2UmRKKnY7t/GI/+hhxt9cDvCEVJcSgQ1+uR6CM=;
 b=W+kxJGn2mpQ0/ICgnjJ3d4z82YmUppYQ0gSFkN325g/J/v0aSTFh555izMdOT3nHojmO9nqk0TT1A0ys5YpvN43Halo5s9sGIz7Feo0F2/2J084kD6yCGe3RVSrzqTDDbW6ee222KN52NJsQ18Ag6/ZUb8qMbhmvIqB04yBYwJw=
Received: from AM9PR02MB7660.eurprd02.prod.outlook.com (2603:10a6:20b:43f::24)
 by PA4PR02MB6734.eurprd02.prod.outlook.com (2603:10a6:102:d3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Wed, 29 Mar
 2023 07:29:07 +0000
Received: from AM9PR02MB7660.eurprd02.prod.outlook.com
 ([fe80::8203:5198:960f:908b]) by AM9PR02MB7660.eurprd02.prod.outlook.com
 ([fe80::8203:5198:960f:908b%8]) with mapi id 15.20.6222.035; Wed, 29 Mar 2023
 07:29:06 +0000
From:   Kevin Peeters <kevin.peeters@prodrive-technologies.com>
To:     Phil Sutter <phil@nwl.cc>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: RE: iptables patch
Thread-Topic: iptables patch
Thread-Index: AdlhRd8vxRo6EOAnSHqnLy8oibYvxwAADfyQAAAMYkAAAAsqkAAR0gUAACA3GeA=
Date:   Wed, 29 Mar 2023 07:29:06 +0000
Message-ID: <AM9PR02MB766031C4F54E853C3D3AC1A6A8899@AM9PR02MB7660.eurprd02.prod.outlook.com>
References: <AM9PR02MB76606476D4EED1FF1938F8A8A8889@AM9PR02MB7660.eurprd02.prod.outlook.com>
 <AM9PR02MB766074FF89D28CE6655CA0B6A8889@AM9PR02MB7660.eurprd02.prod.outlook.com>
 <AM9PR02MB7660795D89727FA09BD370DFA8889@AM9PR02MB7660.eurprd02.prod.outlook.com>
 <AM9PR02MB766039341028D34A400D381CA8889@AM9PR02MB7660.eurprd02.prod.outlook.com>
 <ZCMN+lPI1YxWTyiQ@orbyte.nwl.cc>
In-Reply-To: <ZCMN+lPI1YxWTyiQ@orbyte.nwl.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=prodrive-technologies.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM9PR02MB7660:EE_|PA4PR02MB6734:EE_
x-ms-office365-filtering-correlation-id: 66f3fa09-e06b-4457-442a-08db302747c7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aa83AeWwGvYee7azfD1uR5KbI/SyTrlz9ViITWOOWrIHFQu3ooHMVpMcj3B9a8Tik8oAKlbPzzh90ymvUXd7nvGMdMVIjb+t8DUP4c0HAnz5uK2WXf1Q3uBbm5iW/YyyXqWOm1vHmo1mXcvnNCk4ST7XPlfFVyvxOrZ3P77NE22ptBbQqKNKNApFG5zbaIpavm77BsGbtyxK76J1X+j5+MhFh8+yHZm2Hl4r8uB0kk4wPYgfJbdPqe5hiBa2CyO+9Y8V9S9Zah0CjLdipNoTdAmVKmVK6BlMWhbO8E+6+s3qCbGMKRN1c2XSbo5srwWelf5haX51qcIxTTs03V3EZCXVTgtH+YdnZ7mptGOyL9zAhbDNaVBN8t/FWbIfcJaacyC0uz4cqRTZStPZYgDM7QStATcl83LAfCg9qiX6C5E93w5G6QqqxFKwflSs7oiWZxNv8g6081o/BZ9VdFcE+vCkzPr7lNl+I9K4qZMuYHtdU0MgyUHfoTlrSLT3gomoZKf9EUEcdVPR2IspOsFdUyAIoNql9KimFR1YJNpwJQac6TdtDcaI7iytBbJghBCgdIF1fjrzx2c8WRiftn7sYLitbR9Cv91TdGuPbUjHbfNGoAkdVJLeEgs3MBDFc+6V
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR02MB7660.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(396003)(39850400004)(366004)(136003)(451199021)(6506007)(26005)(9686003)(76116006)(83380400001)(66556008)(71200400001)(64756008)(6916009)(186003)(7696005)(4326008)(66946007)(41300700001)(66446008)(66476007)(8676002)(7116003)(38070700005)(8936002)(52536014)(44832011)(38100700002)(5660300002)(122000001)(2906002)(316002)(33656002)(86362001)(478600001)(3480700007)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?X/ecbXkXOqzw97p0wGwYlv5Fk2kTRtIUcz1Z/g1HV0jhdFCYo0X6E+gl9sIU?=
 =?us-ascii?Q?2xO0h8PEU5J19HxVBuTaH+0vZM/ERNoTHuK7Ztl+kB0q5NMzzUomnZycsom5?=
 =?us-ascii?Q?2jers9mKHihkj9UK7m2IBRWy7VsNxTsyOvggWp2r3Q5IsoM7fGha86KHklaX?=
 =?us-ascii?Q?2oXUc+5M2JLBc1n4eaXvIxZOZGRMcj5RNP+pW8tPM3BKEnEUmRYbDswNRdRu?=
 =?us-ascii?Q?kaNraqcq4kJuW0c3NHRjOyiK7TLk8HB+9gEkTihQWGkbwat3fs3WcAGCQWF6?=
 =?us-ascii?Q?ogx96RBHe2w7936h4LAeJVwtOq7O/iuwvPbygtEFXjB9YO5cjepp1H7Pzzrj?=
 =?us-ascii?Q?Tr5HyJ6RyRNsw/khggWJXpyxUd8Q8P9HpiQYMnuDbpLBUysXB1UTRKwjhp4X?=
 =?us-ascii?Q?3WQEzA9vFDWu7y70C6sgj8/jbP7qgUihw+0A1rUnEas9gLqFtanADnrPACCd?=
 =?us-ascii?Q?r30KlYDCivlmja1V69UIsKKeywPJqaDfjSGmHH0eJCaxhPCYExqT2E2trnSi?=
 =?us-ascii?Q?fM4goLuJocEDyhswlyt5aSa98rvzHz3T9IulVglaNCRlK8B0qsGnmuzV7VUC?=
 =?us-ascii?Q?KuLh8ou8d5CjGwlWH9GuYIrgipQ15A0sbCfucYfLbUmKtt8pA8trctem8ZMa?=
 =?us-ascii?Q?ZDgjZ4GKEs0pHd1OqCUbRiZrSZcBGVHK4WTUDDzTApmznX1n95b2B4I9DyKr?=
 =?us-ascii?Q?uZMKdB4ek6ADn8IWgH/KYr6RjHeP3euUVBjs4rMKZc0CIIUmEc1PEp4ohj0C?=
 =?us-ascii?Q?84fbkeVtig+6KDV7+25NcLFsoT0YmXhvaONmHlnIknCeqYLY2edh6TYNuL52?=
 =?us-ascii?Q?OFTYEmj2nIoGOvJTcRdXYPaQV50pHxyzGQ/tTEjazBIvmJHnJ8IqVU6K2DwQ?=
 =?us-ascii?Q?JrWcQyW/4Evwn5COWwU5r9Fss4h07BAChEr8XZxq3+NdTNYPrIP9BR9LJCXJ?=
 =?us-ascii?Q?HEwigwrkGB7D0q9n1syycVFFy5Jcrh58dWoRlr6t16REfvzrPPVIJ+erELVM?=
 =?us-ascii?Q?uD2oX9966tavsj7qHRprdSFVRCCYp0KEvjHXPezsij7QXRHFJdTtYgvR1TGO?=
 =?us-ascii?Q?kxMw8lhyKhKw6xfm82r7cOZbkoxNsX3cGcznomLaCPKOYhZ4ZRDr+jXfhVS2?=
 =?us-ascii?Q?t2gMv/5gKKqXxPA3uR5OCSTXgHbBRXRJ1FV2ZBBvWbnHoqdGc/gg6s6RrDwL?=
 =?us-ascii?Q?4S0VnMFq66pxj8sKiwJc53e/ENhvQkY7W+GnTGIamY8aBcRv1Ks3LzEXt2kg?=
 =?us-ascii?Q?wD/HNG1Lgx51Q2HMD5bqIqobyHOehfK05opM8C8Z+/P80dmyf7HggF4/Fkp+?=
 =?us-ascii?Q?BriqaPb03jMURZHh9qjQnbLAtP6ZaLA4dYC4FbnBam2bFyiH0k7hq0rUcvzr?=
 =?us-ascii?Q?7iUjR+P/gAN10OUGxbeALtezOsDS8l6CS0TxNs2lT3mDXZJdZy567IFLy7Ws?=
 =?us-ascii?Q?3lwWr+bSnxjzo4CguctE0FuydO5V+3hrK/CGJ5WsbLd/rFdk4zTSvV+lqQIZ?=
 =?us-ascii?Q?4b/sizaHH5Koltiukmr5AiDgsUvVM2b56nONzPZ4DagxtQ3C07N7croV2Z5H?=
 =?us-ascii?Q?XHK9ec6T9OWuZNbHwV3WEPlN1WmQHY34zdk5OmRTEs8Y207dKX7hwY1AFRLR?=
 =?us-ascii?Q?BRDtA0pgZaaydUEDXC+Mxjc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: prodrive-technologies.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR02MB7660.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66f3fa09-e06b-4457-442a-08db302747c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2023 07:29:06.9101
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 612607c9-5af7-4e7f-8976-faf1ae77be60
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bygN1S14fOZNFq4rHBINCDc9e6cHRhFtZFgf52XvyRWCl5u9cQdk9ZBzaSyAcgJ/bl1kDJeaoStTEbbb1K4+PlnEdpjj1Ygxg2/jcosefb7jzPKMuSoDQFdW2vkWhjLr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR02MB6734
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello Phil,

>> I am using the 'iptables' source code in one of my software projects. Mo=
re in detail, I am calling libiptc and libxtables from my own software API =
to add/delete/... iptables firewall rules.
>>=20
>> While developing, I bumped into one issue while using libxtables and mad=
e a patch for it which we now use on our checkout of the 'iptables' reposit=
ory. We do however use multiple checkouts of this repository in different p=
laces and don't want to add the patch to each of those checkouts.
>> Would it be possible for you to add this patch to the mainline of your r=
epository so we can stop patching it locally?
>>=20
>> The details about the patch:
>> In libxtables/xtables.c:
>>=20
>> The libxtables code uses a xtables_pending_matches, xtables_pending_targ=
ets, xtables_matches and xtables_targets pointer list to track all (pending=
) matches and targets registered to the current iptables command. In my cod=
e, I add/delete firewall rules multiple times from one main process (withou=
t killing the main process in between) by calling xtables_init_all, xtables=
_register_target and xtables_register_match every time. When a rule is adde=
d, I call xtables_fini to clean up.

> I don't think you should call xtables_register_{target,match} over and ov=
er again. Why don't you follow what iptables does and call xtables_find_{ta=
rget,match} to lookup an extension? It tries loading the DSO which calls xt=
ables_register_*. After adding the rule, you should free the rule, not dein=
it the library.

If I understand correctly, xtables_find_* will only look for the desired ma=
tch/target in the list of pending matches/targets. If the match/target is n=
ever registered up front, the list of pending matches/targets will be empty=
 and xtables_find_* will fail. This is also done in the iptables flow, e.g.=
 in extensions/libxt_tcp.c.

I do free the rule after adding it, and it felt reasonable to deinit the li=
brary as well, as this is also done for iptables.

>> I do notice when adding a rule in my code twice that on the second time,=
 the (pending) targets/matches lists are not empty and when I try to regist=
er the same target (the one I registered in the previous rule) again, it li=
nks to itself and creates an infinite loop.
>>=20
>> I managed to fix it by setting the pointers to NULL in xtables_fini.

> Your patch seems to leak memory because the list elements are not freed.

Indeed, but every time I try to free the list elements, I get crashes, e.g.=
:

*** Error in `/usr/local/sbin/iptables': free(): invalid pointer: 0x000055c=
b6cea7168 ***
=3D=3D=3D=3D=3D=3D=3D Backtrace: =3D=3D=3D=3D=3D=3D=3D=3D=3D
/lib/x86_64-linux-gnu/libc.so.6(+0x70bfb)[0x7f665dcf1bfb]
/lib/x86_64-linux-gnu/libc.so.6(+0x76fc6)[0x7f665dcf7fc6]
/lib/x86_64-linux-gnu/libc.so.6(+0x7780e)[0x7f665dcf880e]
/usr/local/sbin/iptables(+0x4762d)[0x55cb6cbfd62d]
/usr/local/sbin/iptables(+0x148db)[0x55cb6cbca8db]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf1)[0x7f665dca12e1]
/usr/local/sbin/iptables(+0x130ca)[0x55cb6cbc90ca]
=3D=3D=3D=3D=3D=3D=3D Memory map: =3D=3D=3D=3D=3D=3D=3D=3D
55cb6cbb6000-55cb6cc29000 r-xp 00000000 08:01 14288797                   /u=
sr/local/sbin/xtables-legacy-multi
55cb6ce28000-55cb6ce33000 r--p 00072000 08:01 14288797                   /u=
sr/local/sbin/xtables-legacy-multi
55cb6ce33000-55cb6ce3e000 rw-p 0007d000 08:01 14288797                   /u=
sr/local/sbin/xtables-legacy-multi
55cb6ce3e000-55cb6cea8000 rw-p 00000000 00:00 0
55cb6ed21000-55cb6ed42000 rw-p 00000000 00:00 0                          [h=
eap]
7f6658000000-7f6658021000 rw-p 00000000 00:00 0
7f6658021000-7f665c000000 ---p 00000000 00:00 0
7f665da6a000-7f665da80000 r-xp 00000000 08:01 14417934                   /l=
ib/x86_64-linux-gnu/libgcc_s.so.1
7f665da80000-7f665dc7f000 ---p 00016000 08:01 14417934                   /l=
ib/x86_64-linux-gnu/libgcc_s.so.1
7f665dc7f000-7f665dc80000 r--p 00015000 08:01 14417934                   /l=
ib/x86_64-linux-gnu/libgcc_s.so.1
7f665dc80000-7f665dc81000 rw-p 00016000 08:01 14417934                   /l=
ib/x86_64-linux-gnu/libgcc_s.so.1
7f665dc81000-7f665de16000 r-xp 00000000 08:01 14417941                   /l=
ib/x86_64-linux-gnu/libc-2.24.so
7f665de16000-7f665e016000 ---p 00195000 08:01 14417941                   /l=
ib/x86_64-linux-gnu/libc-2.24.so
7f665e016000-7f665e01a000 r--p 00195000 08:01 14417941                   /l=
ib/x86_64-linux-gnu/libc-2.24.so
7f665e01a000-7f665e01c000 rw-p 00199000 08:01 14417941                   /l=
ib/x86_64-linux-gnu/libc-2.24.so
7f665e01c000-7f665e020000 rw-p 00000000 00:00 0
7f665e020000-7f665e123000 r-xp 00000000 08:01 14417947                   /l=
ib/x86_64-linux-gnu/libm-2.24.so
7f665e123000-7f665e322000 ---p 00103000 08:01 14417947                   /l=
ib/x86_64-linux-gnu/libm-2.24.so
7f665e322000-7f665e323000 r--p 00102000 08:01 14417947                   /l=
ib/x86_64-linux-gnu/libm-2.24.so
7f665e323000-7f665e324000 rw-p 00103000 08:01 14417947                   /l=
ib/x86_64-linux-gnu/libm-2.24.so
7f665e324000-7f665e347000 r-xp 00000000 08:01 14417935                   /l=
ib/x86_64-linux-gnu/ld-2.24.so
7f665e52c000-7f665e530000 rw-p 00000000 00:00 0
7f665e546000-7f665e547000 rw-p 00000000 00:00 0
7f665e547000-7f665e548000 r--p 00023000 08:01 14417935                   /l=
ib/x86_64-linux-gnu/ld-2.24.so
7f665e548000-7f665e549000 rw-p 00024000 08:01 14417935                   /l=
ib/x86_64-linux-gnu/ld-2.24.so
7f665e549000-7f665e54a000 rw-p 00000000 00:00 0
7ffecad4c000-7ffecad6d000 rw-p 00000000 00:00 0                          [s=
tack]
7ffecadb0000-7ffecadb3000 r--p 00000000 00:00 0                          [v=
var]
7ffecadb3000-7ffecadb5000 r-xp 00000000 00:00 0                          [v=
dso]
ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [v=
syscall]
Aborted


This crash happens when calling free(dptr) in:
static void xtables_release_matches(void)
{
	struct xtables_match **dptr, **ptr;

	for (dptr =3D &xtables_pending_matches; *dptr; ) {
		ptr =3D &((*dptr)->next);
		free(dptr);
		*dptr =3D NULL;
		dptr =3D ptr;

	}
	free(xtables_pending_matches);
	xtables_pending_matches =3D NULL;

	for (dptr =3D &xtables_matches; *dptr; ) {
		ptr =3D &((*dptr)->next);
		free(dptr);
		*dptr =3D NULL;
		dptr =3D ptr;

	}
	free(xtables_matches);
	xtables_matches =3D NULL;
}

Kind regards,
Kevin Peeters=20
