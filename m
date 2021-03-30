Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06F0FC433E0
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Mar 2021 18:05:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C14FF619D3
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Mar 2021 18:05:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbhC3SFJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Mar 2021 14:05:09 -0400
Received: from mail-eopbgr60138.outbound.protection.outlook.com ([40.107.6.138]:53979
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232628AbhC3SFG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Mar 2021 14:05:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PDScGjhWV1euLGaH/uD9yy6KKQ6nWYyZCOeKb2FRvLdj78lnFbFOOUUaPatU9Hia7lS1O6S8RjQezCaXVel63xHOtKLf6C2uH4/IuNNKFqdxbyjICoPBlDO2r466GgFx2G25RHRcYtk0nwshGqqa7GxBQEygG5jpNkAYa3tP6soD5QQJYFBNkJCNL4srxHKj6y/bxy9WB/e8vsNulJgDjPVRF5MhvdsgLI2vDkhYRVJ67edHdmIDmwbBl8EcmpvmqcWpECkeN/8cCTkTbgsub1yaUdh287yJtrkNZTP9yyO5eFZrnMNX1RUWpuhUdJOikrDwS/g6SwOB+kIhBwflYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=trRMJvGVaiD4Ymz8aID03OvI8nr3WYTcCqpiuoFxQDg=;
 b=PL1bQ5eS5VQCtPXDP3tGvbEX6jMdFLyY7kC4txZL+ARIboZuXftUtnJtguUOfTOtMDiozL8ByV0LoJcYbLgaAwbZDjngOBQIqkLRT82Ood2pVppME5Syv/q6x8Fsf6pzs4Dze3OcL2oJfbD+o1kBwZYF/jg3GXrl9nIonLCes7GeHv+/q/l9yGnyLl0uJ0viF2u7PvN86Wam7HiuPoQS3e+dpqfzbTrbAreyX3YwYh+jyPlWyNBL19mBAYtuDM+k5gz9h3no6NyKft+Qkf+fnXkMc1WresXC6f5BSJJDB1Y/beJFrByoFsbuRrLvlx7nFLetpeDWodLiFInRVO/QAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=trRMJvGVaiD4Ymz8aID03OvI8nr3WYTcCqpiuoFxQDg=;
 b=UhqyYryAxsj5TZRePIGfki7SgFw00ZPcnHxioRTWRjXC+shNtIORZk9aUnEwjvZ25R3n+25/qJ5QWKP7oKjBoWJ4Xc4fXwoO7IUKsfrS/brlYWISWTQpcWFmYb8VWqzRzl8ZY5aNm2PyXo+st9X3rjDk9UjvnKqN710eD5Qo/2g=
Received: from DB7PR08MB3579.eurprd08.prod.outlook.com (2603:10a6:10:46::15)
 by DB8PR08MB5195.eurprd08.prod.outlook.com (2603:10a6:10:bf::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29; Tue, 30 Mar
 2021 18:05:04 +0000
Received: from DB7PR08MB3579.eurprd08.prod.outlook.com
 ([fe80::c1d1:8590:6730:1cda]) by DB7PR08MB3579.eurprd08.prod.outlook.com
 ([fe80::c1d1:8590:6730:1cda%4]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 18:05:04 +0000
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     Florian Westphal <fw@strlen.de>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>
Subject: Re: [iptables PATCH v2 2/2] extensions: libxt_conntrack: print xlate
 status as set
Thread-Topic: [iptables PATCH v2 2/2] extensions: libxt_conntrack: print xlate
 status as set
Thread-Index: AQHXJW9JJKX2lguALUqxWtcQHZuCW6qczEQAgAAGFrA=
Date:   Tue, 30 Mar 2021 18:05:04 +0000
Message-ID: <DB7PR08MB357940C3E31AFB983408FFE7E87D9@DB7PR08MB3579.eurprd08.prod.outlook.com>
References: <20210330141524.747259-1-alexander.mikhalitsyn@virtuozzo.com>
 <20210330141524.747259-2-alexander.mikhalitsyn@virtuozzo.com>,<20210330173900.GB17285@breakpoint.cc>
In-Reply-To: <20210330173900.GB17285@breakpoint.cc>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: strlen.de; dkim=none (message not signed)
 header.d=none;strlen.de; dmarc=none action=none header.from=virtuozzo.com;
x-originating-ip: [95.165.169.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9cbd097e-26e5-40c3-5155-08d8f3a6586c
x-ms-traffictypediagnostic: DB8PR08MB5195:
x-microsoft-antispam-prvs: <DB8PR08MB5195F663A833E7AF244F6BACE87D9@DB8PR08MB5195.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eupwWfslcqc0V7xUJWOFBWVMHh4NPROq67A7Pli5ScqMkULtvGoDXSwbsunc4RO0ReTvvv5zlLufAqLb+TBl5EpWzGq+Lbu3A4t+k833h0i3+cQbVEa+9hKWdCDZWTO6DD2KcxNTLde+aaiS4TPXCYNGT4X+kzmL/QghTZKzjCfbI8hf5Mheko6js34g8RgCkKfhb7o+AKXrcxVLWupRUOUnXeRASdZv5MpmjuZWOsXjoHxfeJ1O04oBHgXf3RGK+YzYmBc4JR31m3QFGl7H/ajp+kiWTiRS6G2Rw+ugWG/GMp0nFqNgP6Yk5ErF+h35dp2IIbx3ee5hUHFJ+rtfiHRGQvg/6MhwvagrbAWTNaUn34pN3fzG0ULRU+jHRk/+HSaBdJiWSgS3BC++Wv2BwgvBDlJA6xuwrj9UM1Xx6rwayfm8oqOzJ0lBgtjbAsIG1qkCpGZRvKJ9WWfLIr91gcTeCd92B7ntumfBfm88BGZE5jqt63RVzR2qGncY4/LyQhxHxumailofXprinIRVbnEufVoEQunsQj/YkT4gEuNRRrDRPUFCqayg1IMQSGi7UMLC24ff4ZkAZm60xWUfy5T3Hg+JUqHomejvcWI5OyOTsnDhdxgA6mG5tBHxk/K9qVlwqYaRcXxCL+5qUKCatw2cHF4nXwY6KmVhoxIMqoI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR08MB3579.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(136003)(366004)(39840400004)(26005)(52536014)(6916009)(66446008)(8936002)(66556008)(64756008)(66476007)(66946007)(186003)(6506007)(2906002)(5660300002)(71200400001)(4326008)(91956017)(478600001)(54906003)(76116006)(55016002)(9686003)(86362001)(8676002)(7696005)(44832011)(38100700001)(316002)(33656002)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?UCIavEK/mB0SxQ6cbIpdUQy97BUs8cusU1ngQNpiBT6Zm4SdW0fg5TV1up?=
 =?iso-8859-1?Q?ey667u23ct79SGlkrSsXfvZrgQ0FXgJDDe8kj0kKLbF8uyoUuxFDWqzihW?=
 =?iso-8859-1?Q?duUqTCpbAOVFk9bgaKtK+YtwlQIEbDxQxKn4xG/O+FZemWlmKesbt+7nmJ?=
 =?iso-8859-1?Q?eUhjHRGA0m3B6Sjmud2Af0nMY/Qs150rguF+JdS/QBKHxN1scf88F9sCNW?=
 =?iso-8859-1?Q?+18ThpeC9CeGEELp7Zo9/k/nM8UgH5TM4AdNetIy6x68fQiFy3X/j98wSG?=
 =?iso-8859-1?Q?xSBV1TeqkjzaGLSBOm/WEKj2z9Yfg6imGskQHB+JTVYMSaYTjCA11CuOTv?=
 =?iso-8859-1?Q?6O1n8KWaEqe7zYdddAti9wcGQ/bZMN13cGjknR9Qa6n0QuwwvU8dvK7TmK?=
 =?iso-8859-1?Q?8wUE+4D0GQ2y+T6ptIJvAcDg+9tfRGQRGXuGbiuV0LFd7fY7EJCcX0LTkX?=
 =?iso-8859-1?Q?hwovRc12k162k1sj3QdYzoSo2hfznO72PcKOmpNRSp4oKk/PLN+E+WCrdb?=
 =?iso-8859-1?Q?GxBuvbQFHeotm3gl51IIL5GmuUzoinxoTzVSZkrnXbXrnEu2NQ16eBjt6p?=
 =?iso-8859-1?Q?rBI2wrUA7TpbOt42d10qlmFa9Yd3ZBuPGSSJ/WkUeqcbcySduHPM7umqjf?=
 =?iso-8859-1?Q?y5LZ01iWediozYKdCBKrW7yd86YSlbHejPNcjqkpIOlGM+WIPGERsdfGIa?=
 =?iso-8859-1?Q?s9g2lxofs7KYk7KHCvgjXnaEqny1wHnnp4BTzzhkI7FWmLp1A5mSEJTKS1?=
 =?iso-8859-1?Q?xNmPNEjDV5WHeVv/DLaWx1r8R2PW+oXbU9IgibbG/5xioZWaNfG8tt9uuZ?=
 =?iso-8859-1?Q?bQHkP4k7TDB/DCGA+D8QbsGEUGDAbbXs+PCWs1cPRZXm4qLD+uvRfLzMBO?=
 =?iso-8859-1?Q?yhHLZtS/NKZbgGoIcsIv5yCDn4FGBuKRLvsQBpDnAaPeuGcrZH0yT2ppfF?=
 =?iso-8859-1?Q?0QVuyTx51wh6cpp8d4++U4JVW2EThJ+/1eLTIFR3jGuwWpoD7fyXHxuqOT?=
 =?iso-8859-1?Q?+1QSbT/HC2F5Vh5TVahBk6wlPHD4hOzSwXnwRcPBdwCmP+8HWNHF7fZD7G?=
 =?iso-8859-1?Q?DBqyOMwP0Co4qKNjb66P99CTkPu+NhOirF3Y7Q20qHNSxTs+UFale1IYKx?=
 =?iso-8859-1?Q?NzXCYtx8HNBrbHnIt+YQH+xPKxXhkqjzcVYs0wcGwV79UcAoLhg+CizAMv?=
 =?iso-8859-1?Q?ZDzHPmLMIdsRcosE7z2G/XmaXal1SmFpJ9MRT+JjD6D3jWeuZ5c/V9qHlA?=
 =?iso-8859-1?Q?EAxeCSRWTnvkctaAEbOC14DS8MIWutAElEubmrKXh+1dqFwCWQqEIgRGYn?=
 =?iso-8859-1?Q?I/GEjKojIC3C/O23F9lyir9dD1e1WWGuHbmozqaZZZnZMMA=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB7PR08MB3579.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cbd097e-26e5-40c3-5155-08d8f3a6586c
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2021 18:05:04.5207
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P7X/Kp2GoxeIhc7j6lZoVxWRAqV6xExYsMsB3Gd1QFHnUOg8MJu4mnAQ/Sjcj6GNTgx2heFfCY48LSiCstbudhJo3/0CkXbMiKZZ/Tf0UXVjohCiUQYalui/5Wh+tBrf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5195
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,=0A=
=0A=
Thank you!=0A=
So, I need to fix nft and support that syntax?=0A=
=0A=
Do I understand correctly, that the same issue for state flags like=0A=
"established, related, ..."?=0A=
=0A=
Regards,=0A=
Alex=0A=
=0A=
________________________________________=0A=
From: Florian Westphal <fw@strlen.de>=0A=
Sent: Tuesday, March 30, 2021 20:39=0A=
To: Alexander Mikhalitsyn=0A=
Cc: netfilter-devel@vger.kernel.org; pablo@netfilter.org; fw@strlen.de=0A=
Subject: Re: [iptables PATCH v2 2/2] extensions: libxt_conntrack: print xla=
te status as set=0A=
=0A=
Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com> wrote:=0A=
> status_xlate_print function prints statusmask=0A=
> without { ... } around. But if ctstatus condition is=0A=
> negative, then we have to use { ... } after "!=3D" operator in nft=0A=
=0A=
Not really.=0A=
=0A=
> Reproducer:=0A=
> $ iptables -A INPUT -d 127.0.0.1/32 -p tcp -m conntrack ! --ctstatus expe=
cted,assured -j DROP=0A=
> $ nft list ruleset=0A=
> ...=0A=
> meta l4proto tcp ip daddr 127.0.0.1 ct status !=3D expected,assured count=
er packets 0 bytes 0 drop=0A=
> ...=0A=
=0A=
Yes, nft can't parse that.=0A=
=0A=
But ct status { expect, assured } is NOT The same as 'ct status expect,assu=
red'.=0A=
=0A=
expect, assured etc. are all bit flags, so when negating this needs to be s=
omething=0A=
like  'ct status & (expected|assured) =3D=3D 0'. (ct is neither expected no=
r assured).=0A=
