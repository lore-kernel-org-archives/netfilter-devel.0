Return-Path: <SRS0=kuYc=ZR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBF13C432C3
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Nov 2019 12:26:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C0C12082F
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Nov 2019 12:26:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=Mellanox.com header.i=@Mellanox.com header.b="WG8CbXjF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbfKYM0h (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Nov 2019 07:26:37 -0500
Received: from mail-eopbgr20056.outbound.protection.outlook.com ([40.107.2.56]:16670
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725868AbfKYM0g (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Nov 2019 07:26:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FJ8uApGqjaPL5Ev3hbjZb0RPn1FAZ+ol0o2OfQwfztbhQwGuMujlPQI4Li/clAwMHHoUX/efsxmEVIcfhholKRI0NQ6GEzzNUKgPwaLetB3T+PMopH6fMSQaoWlNBB5AE1TwErKDDdfYh6azInUoaE+hOtWnU0r+2R5hdSy8Ok/f029RODQrSx/kLH+PYSd47rDlqpBfg4APw7CKy1c12WdNAbM3mjiATXMpcST04PwoLes4wcBRaGlYkyi0IfTfx3Ap3qy1H9xnszwtQD+eziCv/t2PH+vxfv74MuteBy8uDlCsUYTrVV+7XEgDZHgjXucEhy2UfeBSerrVpOyjBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bSCzd7eSjgXTWGleh72TRPFz3rDeYDS8QbfJWl4HUXY=;
 b=I6/zP24Y1pjK9ijUFtbYhFau8ds8wviFiS06ZhlPeDgfZ/w2D40rmiBfKhusfs4OTX2pMgyYqaM9cCRPZZ2aUszddGG+FODwm4VELSRCBtHXwwN8ofFnJiUsnyFR46ZqWAFtzqOu+iwG0i4RKB/yykOaOqVz0nPvW/ZBF+1IN7+N7PFu2+W3csjaOafjbS4wMEK/GhU+U6hk1f8q+eVQPVaIKqL8BGszvZN1Dghkn+2bvY9FYyagByhENjNh8St+llYT92mcML0BIB5aItUHWNlVdQSeEemwZSDVKA8nQtdNyT5GyfuiBQPVPmxAcEiAd0lId57VkxolW5qcKmHGWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bSCzd7eSjgXTWGleh72TRPFz3rDeYDS8QbfJWl4HUXY=;
 b=WG8CbXjFRNAhDEFEfNLGXLmbDnFMoVeTbxbCLMHDeTDhLY1ECV9RVHNNcCnn84UZg2y0TcM1bsUimRdCXde+oEbjHFH7x3qgmQnBAuV1rGhiJFXrXtbeXk7eYlu7Fv8d+MuFaP9DAfa0FVE/7n1yI2emONQ4od69rLjLYJsBOLU=
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com (10.171.190.30) by
 AM4PR05MB3506.eurprd05.prod.outlook.com (10.171.186.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.19; Mon, 25 Nov 2019 12:26:32 +0000
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::2cc0:1303:718d:2e9c]) by AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::2cc0:1303:718d:2e9c%7]) with mapi id 15.20.2474.023; Mon, 25 Nov 2019
 12:26:32 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     "wenxu@ucloud.cn" <wenxu@ucloud.cn>,
        Pablo Neira Ayuso <pablo@netfilter.org>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: [nf-next] netfilter: nf_flow_table_offload: Fix setup block as
 TC_SETUP_FT cmd
Thread-Topic: [nf-next] netfilter: nf_flow_table_offload: Fix setup block as
 TC_SETUP_FT cmd
Thread-Index: AQHVo4uRcJ89Xiy4cU6Zw7rA1V3e9A==
Date:   Mon, 25 Nov 2019 12:26:32 +0000
Message-ID: <655aafe1-7033-1033-39f5-f120a32193a1@mellanox.com>
In-Reply-To: <1574224242-17972-1-git-send-email-wenxu@ucloud.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: FR2P281CA0015.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::25) To AM4PR05MB3411.eurprd05.prod.outlook.com
 (2603:10a6:205:b::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a522c2df-df35-42ed-b667-08d771a2b41e
x-ms-traffictypediagnostic: AM4PR05MB3506:
x-microsoft-antispam-prvs: <AM4PR05MB3506E272C49B2149E5680BE6CF4A0@AM4PR05MB3506.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-forefront-prvs: 0232B30BBC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(39860400002)(396003)(136003)(376002)(199004)(189003)(186003)(81156014)(31696002)(52116002)(8676002)(6512007)(81166006)(6506007)(386003)(2616005)(14454004)(102836004)(305945005)(26005)(11346002)(31686004)(8936002)(3846002)(5660300002)(19618925003)(478600001)(6246003)(2501003)(25786009)(86362001)(4326008)(4270600006)(7736002)(66556008)(229853002)(66446008)(6116002)(6436002)(110136005)(316002)(66476007)(6486002)(64756008)(555874004)(66066001)(36756003)(66946007)(558084003)(2906002)(99286004)(71200400001)(71190400001)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3506;H:AM4PR05MB3411.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2qjk8w7rUh0WSMu7uYrojEei/j+SuvbWWqxSnIGDACGUhx4IsmMCX2aP+7OiwPRL5Yvzq7PcbmnDBHxwLjtlpdtyoghKit3X2uoHDEBj0i3yv9USnCi26iKHoWfK1+dpga9maA10dPPlnCTIVxAV+teAeQsQUA9d6PEdSIZPdkLIZLZbXUmb3+ujbqs26DFVLPIAZoMrD5+Oe4Y+pT2yfCxFjnkJKQiwhfSXVdb6sDTimBEXCRIGPIJ2c933daAN4jd8G5o1fvHYqQ4ihfbbm/y/EoIUx3RV8rxmJu5CQsEzI964PrK93roCxKsKTYpCnyM5TrPSY7jdUnDfmwh9woMjdryHI8r1iwqnSS4MevtNog2vWMeF0BkfYlLnYkTUGAC5pIV+L1iVpKw8G0EQ9XWAxVqMMduMs9+xQrwOwjQzWCANN7QW9KiORMmy8B9J
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <696273F89A290E46907E7FF15D4345B7@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a522c2df-df35-42ed-b667-08d771a2b41e
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2019 12:26:32.3362
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W0WWvFa/bP3zQ7f874xj/hWVdgf9VBmAxOLNsdiXyKYRSXMIjuIZ19t0mQKLM7zxjqMvZLBICOwpPvM5nA1zFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3506
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

TG9va3MgZ29vZCB0byBtZS4NCg0K
