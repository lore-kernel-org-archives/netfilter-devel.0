Return-Path: <SRS0=jECH=SL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53525C10F0E
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 14:23:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11C6F20830
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 14:23:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=darbyshire-bryant.me.uk header.i=@darbyshire-bryant.me.uk header.b="yZaAm2UU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbfDIOXs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Apr 2019 10:23:48 -0400
Received: from mail-eopbgr20073.outbound.protection.outlook.com ([40.107.2.73]:26686
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726388AbfDIOXs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Apr 2019 10:23:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=darbyshire-bryant.me.uk; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IkGE27BekbCPWj33atWQuvayrUixjSZylyB3Jc6D9uU=;
 b=yZaAm2UURaPyoaJG7BcKXFLsV6qcazujjiBGyLvYKnk3b9EfDauXvqA/ucHEvD3NCdAyYeYoJNj/Z+udcjY+98MXIsuUuDfGtTnTwe5VJa6ohDjAUoPcxqSAC5IOb/Nrgk/H2hruiQkbdh/BtwmG5Y/RUcu3Idv6kE6IOVmmzvI=
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com (10.171.105.143) by
 VI1PR0302MB2639.eurprd03.prod.outlook.com (10.171.104.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1771.13; Tue, 9 Apr 2019 14:23:44 +0000
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::b584:8ced:9d52:d88e]) by VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::b584:8ced:9d52:d88e%5]) with mapi id 15.20.1771.016; Tue, 9 Apr 2019
 14:23:44 +0000
From:   Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
To:     Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>
Subject: [RFC nf-next v2 0/2] xt_connmark: add savedscp-mark action
Thread-Topic: [RFC nf-next v2 0/2] xt_connmark: add savedscp-mark action
Thread-Index: AQHU7t/WthBM4k97pUSXTGm2b7GAWw==
Date:   Tue, 9 Apr 2019 14:23:44 +0000
Message-ID: <20190409142333.68403-1-ldir@darbyshire-bryant.me.uk>
References: <FEBDDE5A-DC07-4E41-84B3-C5033EB20CCE@darbyshire-bryant.me.uk>
In-Reply-To: <FEBDDE5A-DC07-4E41-84B3-C5033EB20CCE@darbyshire-bryant.me.uk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0462.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a2::18) To VI1PR0302MB2750.eurprd03.prod.outlook.com
 (2603:10a6:800:e2::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ldir@darbyshire-bryant.me.uk; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1 (Apple Git-117)
x-originating-ip: [2a02:c7f:1240:ee00::dc83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c4347daf-6b53-4af5-8c05-08d6bcf6f85d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(5600139)(711020)(4605104)(2017052603328)(7193020);SRVR:VI1PR0302MB2639;
x-ms-traffictypediagnostic: VI1PR0302MB2639:
x-microsoft-antispam-prvs: <VI1PR0302MB2639744EA1ED430F96F0CA82C92D0@VI1PR0302MB2639.eurprd03.prod.outlook.com>
x-forefront-prvs: 000227DA0C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39830400003)(366004)(396003)(376002)(346002)(136003)(189003)(199004)(7736002)(386003)(81156014)(81166006)(71200400001)(8676002)(53936002)(478600001)(25786009)(6200100001)(305945005)(6862004)(4326008)(256004)(74482002)(14444005)(76176011)(102836004)(486006)(1076003)(14454004)(86362001)(36756003)(11346002)(2616005)(446003)(6506007)(71190400001)(46003)(476003)(4744005)(186003)(6116002)(54906003)(7049001)(316002)(37006003)(2906002)(52116002)(5660300002)(6486002)(6512007)(8936002)(99286004)(106356001)(105586002)(97736004)(50226002)(6436002)(68736007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0302MB2639;H:VI1PR0302MB2750.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: darbyshire-bryant.me.uk does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ICJs9XiBKhgB/6Y7tHOH8clYe6+t6YhTcTKOamT25VqOCAM7TvLKDSY8/5duCLaJkRqT8fuzLj9n8SELrnLpXck5di93m+bY8HwovoFmhSCwUufrQbU+KMEmH9otILfJrqSEMDeIuCrKNwt9N0u5O1GAIJuIL8R6UOpw4qqniAo3rTP49LJh9b3VCpGmK50PetR5Wqk9yAXOQMfobUvj3NIgSHSIRgCUCXFtX/WNtQ5n1W6TjqYTLTHU+2vhL3jpAI+kIzl4ewqeMqlVEL8jMB58nyl0VlGiw5oL+t25NvpkF5RSdGbVWxG2PCNz44DSkR6HCwmzHkOoqIU75X2ry1pR9nZojZem6TgrNHPmuk6qqVtFkr1b1aL+BETw8P7itX2e+czmbCBirhbKUdfmaId1wAZjcGAiiAf2EvkGJ5s=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: darbyshire-bryant.me.uk
X-MS-Exchange-CrossTenant-Network-Message-Id: c4347daf-6b53-4af5-8c05-08d6bcf6f85d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2019 14:23:44.3518
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9151708b-c553-406f-8e56-694f435154a4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0302MB2639
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SGkgUGFibG8sDQoNCkFzIHByb21pc2VkIGhlcmUncyB0aGUgdjIgcGF0Y2ggYWxvbmcgd2l0aCBh
IHBhdGNoIHRvIGlwdGFibGVzIHVzZXINCnNwYWNlIGxhbmQgdG8gbWFrZSBpdCB3b3JrLg0KDQpD
aGVlcnMsDQoNCktldmluDQoNCktldmluIERhcmJ5c2hpcmUtQnJ5YW50ICgxKToNCiAgbmV0Zmls
dGVyOiBjb25ubWFyazogaW50cm9kdWNlIHNhdmVkc2NwDQoNCiBpbmNsdWRlL3VhcGkvbGludXgv
bmV0ZmlsdGVyL3h0X2Nvbm5tYXJrLmggfCAgMyArKy0NCiBuZXQvbmV0ZmlsdGVyL3h0X2Nvbm5t
YXJrLmMgICAgICAgICAgICAgICAgfCAzMCArKysrKysrKysrKysrKysrKysrKysrDQogMiBmaWxl
cyBjaGFuZ2VkLCAzMiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQoNCi0tIA0KMi4yMC4x
IChBcHBsZSBHaXQtMTE3KQ0KDQo=
