Return-Path: <SRS0=kuYc=ZR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3DB1C432C0
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Nov 2019 12:28:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C803A2082F
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Nov 2019 12:28:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=Mellanox.com header.i=@Mellanox.com header.b="q75ClJac"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbfKYM2f (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Nov 2019 07:28:35 -0500
Received: from mail-eopbgr150053.outbound.protection.outlook.com ([40.107.15.53]:52074
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727079AbfKYM2f (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Nov 2019 07:28:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cnhvrLTmIRJyJkjmkhcbrwPHjqaqs0hN0DoeCrcDcLWFTAbFeasWPYCY8VB6ZwpvIuAFBHSjDHVBC1LE5rSdCro+ObDIz2A+VObUbBkpfIqIZPex5hbu9KOjQpgNKjsINUniiM8o8Ngu9ZZTQCIDYNSHXiddf4tiHtJk273/BYOxSyl6XmoO3uC3PzuwnADcTRFFmV3SD3WNqO+u9RwsaB9dDzLIe135ePlLrcwkQzBXMc01bXtbPm/AUf4yLKMenk5csQ/cKWFBwPSwxCi5Vcuu32NyHQx64jGulJ1P2wIlG/K/BFVy3cqsc519ba5zV6X1Uj7BbYRXYlfBdlJxWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bSCzd7eSjgXTWGleh72TRPFz3rDeYDS8QbfJWl4HUXY=;
 b=LyjDZ8mqQ6XetnDUz/X3LoH5W7dSUmwkiHRY4U6zBhyAIydyUCkqnQ6TtGO0WXnfD/5QHupL3xzascGiTxtPSRamXLVUqBCiyhga4xEcVuO9bSKh+nKSKPVz/Ml7Xc7UQK2nAJMMRshP/9HC1qpH3tsAQeKOeiHcbup2kQoTBQDZ6en1bGfezpxTh7paeaFQKoGT9vcX9BenpyuCTyAJ/URGQWMeIpht0YTtIdz1oKR99JsgBJb5m/ojxQ57eqZvaci/KQqZD86g2IWvzc/wgUnJJiTHdk+oWvaGIBwZ4SWD6PHDs4LQLwNwp8YPCjuLoEPBFFm8NB9/LnXtquc1/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bSCzd7eSjgXTWGleh72TRPFz3rDeYDS8QbfJWl4HUXY=;
 b=q75ClJacQG6TZ4LJSzo0nTp80/H8/AyocU6Ne8N1ntQSk4gVwTa36kDK5Mc0J8l1N5d5Wl7x+o5G9xbu09UEq2ghxyrkvEd4Z0pP5jf9kh/ek523lZ0HKwwmrWQVYFHmNDKDVLR9dm9E/LFGBzR7VQF2pbo7haDuZ93MXg293H4=
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com (10.171.190.30) by
 AM4PR05MB3362.eurprd05.prod.outlook.com (10.171.187.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Mon, 25 Nov 2019 12:28:31 +0000
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::2cc0:1303:718d:2e9c]) by AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::2cc0:1303:718d:2e9c%7]) with mapi id 15.20.2474.023; Mon, 25 Nov 2019
 12:28:31 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     "wenxu@ucloud.cn" <wenxu@ucloud.cn>,
        "pablo@netfilter.org" <pablo@netfilter.org>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: [nf-next] netfilter: nf_flow_table_offload: Fix block_cb
 tc_setup_type as TC_SETUP_CLSFLOWER
Thread-Topic: [nf-next] netfilter: nf_flow_table_offload: Fix block_cb
 tc_setup_type as TC_SETUP_CLSFLOWER
Thread-Index: AQHVo4vY9m8d7Ke4TUCRK4NQuV0k3Q==
Date:   Mon, 25 Nov 2019 12:28:31 +0000
Message-ID: <bdb9a102-eb2f-d6e8-d6f5-6a4bb0dafbd0@mellanox.com>
In-Reply-To: <1574226742-18328-1-git-send-email-wenxu@ucloud.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: FRYP281CA0005.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::15)
 To AM4PR05MB3411.eurprd05.prod.outlook.com (2603:10a6:205:b::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 046c3ef3-973c-4e94-d2f4-08d771a2fb18
x-ms-traffictypediagnostic: AM4PR05MB3362:
x-microsoft-antispam-prvs: <AM4PR05MB33627EA42170F050943E2330CF4A0@AM4PR05MB3362.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-forefront-prvs: 0232B30BBC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(366004)(376002)(346002)(39860400002)(189003)(199004)(6512007)(25786009)(6246003)(4326008)(71190400001)(71200400001)(19618925003)(6116002)(3846002)(26005)(186003)(36756003)(2616005)(6436002)(6486002)(4270600006)(66066001)(11346002)(81166006)(8676002)(81156014)(66446008)(64756008)(66556008)(66476007)(66946007)(256004)(8936002)(2501003)(31686004)(478600001)(14454004)(555874004)(229853002)(2906002)(102836004)(31696002)(305945005)(7736002)(99286004)(52116002)(6506007)(558084003)(316002)(86362001)(386003)(5660300002)(110136005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3362;H:AM4PR05MB3411.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kclTjuF3eapjtqtv76XcCMdt8kTztH6qfjwiY71o3NYZPbe54PIMZfEHRfl/g4VsNEL2f3bkyDl9ynNC48yblrIFfrrSDfWuROok+33C9i6MM6rRnLM/gCk3hMpeJShn53F6GYk1uVswNjIpanzMA6FLIhEueI2kT7xGiZpiqhTXvXDFE/KxudwQgGIN9Am81yoOrmT4fGY5dgbqm36a3bDLAsUQ6JTzwCLpVaiyxvnMfEMSLSIbs4Tgbzppm7NuFCGjukw5uLfOzckun+deicZssOtt7YA9s/85KsgvGIyrGrJBH4NZ+lBWQJvwhI+aV/IbucXCHiMP0NkilnXNn0t7OggxFYVduEB5/nCuxjfBq82mucp2D1oKFe2WueA9xLlAWhGt5+I+s+VbF+PDUcaotkfSxXILjqPwjdd/WIlVlI0yTPGxgpsgGG+gdy5f
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <68640BF8165CD142B12EFE2A1A2BB729@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 046c3ef3-973c-4e94-d2f4-08d771a2fb18
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2019 12:28:31.2480
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1R14i0W9rpApyT7p5g4MkdYRQEcMuTKeJJK48Hk6xMEvnO91fieL4DkWJ3Dxd4JfbT3Yp6KDHfCFCVrPejlWig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3362
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

TG9va3MgZ29vZCB0byBtZS4NCg0K
