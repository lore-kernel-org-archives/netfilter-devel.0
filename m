Return-Path: <SRS0=iRt+=ZL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51759C432C0
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Nov 2019 12:21:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22EA7208CC
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Nov 2019 12:21:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="Gs4RJWqQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727511AbfKSMV0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Nov 2019 07:21:26 -0500
Received: from mail-eopbgr140110.outbound.protection.outlook.com ([40.107.14.110]:34114
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725280AbfKSMV0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Nov 2019 07:21:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XfkpqIPOpMgoT6gFQ76DccpMSsQ0R6R0yAeXhBWjpKWyHuU0QlZrzzwbSpQB7Z0qRaNT+kEu9v3j31O5TPtyiU8DQBYs+PPVnYHLNqIxeToNao2u0SJTPh3vFrZ4kpaDSf2MIalKPYvZ2wbGI38soOOZKsN6NGzoMzGijdLN+8l011zbv/rhR6m8kv+zUf24qy/rUX0L9CZw1+g3H1YNZJCpKqhUXIJ8PYyQA0O13KJu/e0O+f9bYDnfia1qr3CWdEgpWZXw4JlE1jFRFFGhujQsEpsi+44exKZpfUEGH07BNjrM5jis0ObV4kkujX+7lH3nYKVSDSNJG4a6xinMIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=10k2FpB/MqieiQEGgK6Xnkl7IAOOFsPsIyzls0KiPiM=;
 b=UiKQ5OsvbW5zgn6/qiiIBWdiq7BA39qljxPTHylu12QcBKtTJDu8FaPmXMzFoyLoH7QWCVMwF4uIt+BdZe5VCIZXZDd4cXH/9LzO/2K3PO/NajPolpPoMWIDrnZGXfw2II34aH0Pzhd7sWG1yIQeCLOGly2mO2m38D5DCSXC5mewDfghQABwNPaks1u9VJWyLzbVeF4XXcka3YhPn/ORgG8EEzRu7gCPrCZP/4SEZL8O58+88zUH9eQrrtG/HNlP0sTqWncmIOumlZM/OXAwj4AYvy9TOcdRa3jTPgeTmoWvj1BVPFbbPKwjdDKmB2o0TuCiFpgzOlNJhgzE/+DuUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=10k2FpB/MqieiQEGgK6Xnkl7IAOOFsPsIyzls0KiPiM=;
 b=Gs4RJWqQolcjWFusJG9i2Yeul6Xc7380BW6th7MGeCeR4loSRbJXzBjhzZDkb9G5BN0zWR2t3sWlqt+mRPXd1NRX8QfoAdppjVp2qSqFiMi4Yq+lvQl53kFAFabYthh9/GBhIrYvPOgCQl/EzyIDbdg65pYE/fok5SEewMFbnzE=
Received: from HE1PR0801MB2010.eurprd08.prod.outlook.com (10.168.92.138) by
 HE1PR0801MB2041.eurprd08.prod.outlook.com (10.168.98.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.16; Tue, 19 Nov 2019 12:21:21 +0000
Received: from HE1PR0801MB2010.eurprd08.prod.outlook.com
 ([fe80::2c87:78f7:1184:31fb]) by HE1PR0801MB2010.eurprd08.prod.outlook.com
 ([fe80::2c87:78f7:1184:31fb%5]) with mapi id 15.20.2451.031; Tue, 19 Nov 2019
 12:21:21 +0000
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Choosing best API-way to full dump/restore nftables
Thread-Topic: Choosing best API-way to full dump/restore nftables
Thread-Index: AQHVntPaFlAn9lHXRkeG1927Klo0PQ==
Date:   Tue, 19 Nov 2019 12:21:21 +0000
Message-ID: <20191119152120.85eaddcc5d6f76c6980bd68a@virtuozzo.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR06CA0128.eurprd06.prod.outlook.com
 (2603:10a6:7:16::15) To HE1PR0801MB2010.eurprd08.prod.outlook.com
 (2603:10a6:3:4b::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=alexander.mikhalitsyn@virtuozzo.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
x-originating-ip: [185.231.240.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 43f1e32a-6c37-4260-4920-08d76ceafc6c
x-ms-traffictypediagnostic: HE1PR0801MB2041:
x-microsoft-antispam-prvs: <HE1PR0801MB2041EB7109A37A4FDEBB921FE84C0@HE1PR0801MB2041.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 022649CC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39840400004)(396003)(346002)(376002)(366004)(136003)(199004)(189003)(6486002)(6436002)(316002)(5640700003)(256004)(5660300002)(14444005)(6512007)(4744005)(8936002)(50226002)(1076003)(52116002)(86362001)(8676002)(81156014)(81166006)(99286004)(186003)(36756003)(478600001)(6916009)(26005)(66946007)(66476007)(66446008)(102836004)(66556008)(2501003)(64756008)(6506007)(386003)(71200400001)(71190400001)(305945005)(2351001)(486006)(7736002)(3846002)(476003)(2616005)(6116002)(25786009)(14454004)(413944005)(66066001)(44832011)(2906002)(43043002);DIR:OUT;SFP:1102;SCL:1;SRVR:HE1PR0801MB2041;H:HE1PR0801MB2010.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wDzeoD03VSF8N/DUDBIH+jfLWNM5j7e5ts95VxZeE39lKCFd9LIj90QPJK2Wkb85t0hWM8gEiUOZ53U5Tqu16wT43JRdEZBWQT2eU/62nHhIruB3fGfLPxISkTaeoB26GcFXwW+XUTD3gs6hdghCOlBJ5XK9vXUJYGxqluwXiAzgwHNrhlSRmsMycy4LIJAvhnpTeiXNDTlhs1JBsl3PuNrrMdnV60OvvvjI6j2qPT5J1En91sel+SQgcK0x2WInWznMFgWbimucdlLHHLS73cWiG/IO3ys3NnhlhL+EAIguiAVOhajrzTTRymy/SVxgJ9qShXUxnh4frjTMqKkv0BR7DXMM0JB5fZIfaLgIBD9Q3+1rJ0Ha+9BYtdbpSr/xI8zxJWAJja5NLqTVccwMVKfxBUh6Lu6svRotkQ5NstYoGOgJDUZ8Znod0qLdO1cS
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E9A3006A440E6A40B726FF5944763ACA@eurprd08.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43f1e32a-6c37-4260-4920-08d76ceafc6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2019 12:21:21.1045
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7LJI7B47Uly5Krt/LZ1wEaECxwuDkgBxUi7BOuQvo1KxBA6+xwwS8+fww0s4Xyv0rD+cjapmKBK9WjUehlpgr47mpSceYiKs37j/aYhiObOwK4+iYivkaxomt/3xWqKG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB2041
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Dear colleagues,

In CRIU (Checkpoint/Restore In Userspace) we want to add support nft dump/restore. Initial implementation directly uses `nft list ruleset > dumpfile`/`nft -f dumpfile` but it's not the best way because fork/exec is needed. We want to use some API. But after diving into libnftnl and nftables code I've realized that it's not so simple: in libnftnl there is some partial code for JSON support in nftables too. But as I see in libnftnl JSON doesn't fully supported. In nftables I've found tests/json_echo/run-test.py test that uses libnftables.so shared library that exports some functions for dumping/restoring full ruleset as JSON. After some googling, I've found that recently CLI and API interfaces related to JSON/XML exporting functions of nft have changed significantly. Question is: What API I could use to have confidence that in the near future it will not be deprecated? (We need only make *full* dump/restore nftables)

Thanks
Regards, Alex
