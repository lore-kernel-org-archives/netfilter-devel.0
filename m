Return-Path: <SRS0=bd9C=D3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33255C433E7
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Oct 2020 12:32:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC33722253
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Oct 2020 12:32:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=criteo.com header.i=@criteo.com header.b="DIAXLyGw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406077AbgJTMca (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Oct 2020 08:32:30 -0400
Received: from mail-am6eur05on2095.outbound.protection.outlook.com ([40.107.22.95]:64300
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404551AbgJTMc3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Oct 2020 08:32:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gnIatPfa6UFM/WONnX5Q+4vV4/NhbCcQs8rdY6nJIBe5WGe5b3kliCwwrod7IeRzd9yL/Zlv3gqQA81p9hqIoLFl+yJm87yCIM5t8/ZcqqrJcnT1ufCjJoNmZZmqVy0rRmlu1Qm78MXHLslTn7lku6L4D2rSf6hWmVMJ/zk5G9/Yn+8wWCyFyU8m05fYkaJsiWmXXo8aFM+ghYkIo2BR4YONVO3zitIrHMSMyRwuaUoi9/Ap8aSHGHl2+ju4MJNBpmd2Ees64QB7BDkiaL+GQ3zdnzweSd00OdEVjoAOE2TOoOJhAE3MQIGDN9lShshfeIOFthQqzVX07K9j/39Ulw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0b6Mh5jgqNnS21JbcFYN7gEWIcJ3lK9jn9KWTl+iyto=;
 b=QkqmNhNY5XFN/stJbAxsFJYiDzS85tzozoTB14UYtkuGuneNZSetWLEyF+3foZ3C6FsfrQwGgogVJC37/X4F8fY0HfTTe8kVtUvE2b1iP3zU3jkisZ/JQWzdjDOOQ5yziSkY4HUUHqcedLOhcz9opHTJi+SSp7RBCqcGeLcf8UOKkGAGuthR4RhWdPvwlhCjGm+B8E08+BpmSoMzhz+uYrY6CIuwSzvGZopT3LXIPCxYn5QFQBIEWwWOUudTcit2pFpj+dua5pD1iK3eRojl2CUBS2yJjkHWe8hp7N3Ph3xwGofk/rkTH/G7pNcSjwpd+u/Y5ELBvNViYkD+BR092Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=criteo.com; dmarc=pass action=none header.from=criteo.com;
 dkim=pass header.d=criteo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=criteo.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0b6Mh5jgqNnS21JbcFYN7gEWIcJ3lK9jn9KWTl+iyto=;
 b=DIAXLyGwLlCVePbpgdNlo8699w3AdVpAZKv48kZls0eD3P5XKuNDLnG4bVuEzHmmRU2oQ0vCWagJqSJURbtrXvKVYD4XJRtJG5YNhGdQU92Vhr0I0VkkV4Pz69sNwTKma61ZNSCnYVKykDfUf12Sq+eymkgYDUW1w8JZRu6phhk=
Received: from PR3PR04MB7356.eurprd04.prod.outlook.com (2603:10a6:102:8d::10)
 by PA4PR04MB7806.eurprd04.prod.outlook.com (2603:10a6:102:c9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.18; Tue, 20 Oct
 2020 12:32:25 +0000
Received: from PR3PR04MB7356.eurprd04.prod.outlook.com
 ([fe80::21a2:883e:b0be:5143]) by PR3PR04MB7356.eurprd04.prod.outlook.com
 ([fe80::21a2:883e:b0be:5143%5]) with mapi id 15.20.3499.018; Tue, 20 Oct 2020
 12:32:25 +0000
From:   Damien Claisse <d.claisse@criteo.com>
To:     "lvs-devel@vger.kernel.org" <lvs-devel@vger.kernel.org>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        Julian Anastasov <ja@ssi.bg>,
        Mahesh Bandewar <maheshb@google.com>
Subject: Network namespace, ipvlan and IPVS source NAT
Thread-Topic: Network namespace, ipvlan and IPVS source NAT
Thread-Index: AQHWpt0Q/OiJXEWplEmHLGgquQGiMg==
Date:   Tue, 20 Oct 2020 12:32:25 +0000
Message-ID: <1A2C4E81-2244-4104-B543-08713F000C0C@criteo.com>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=criteo.com;
x-originating-ip: [2a01:cb08:962:df01:9092:7478:d72f:e07f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 59df71eb-3a8e-4545-09c7-08d874f43344
x-ms-traffictypediagnostic: PA4PR04MB7806:
x-microsoft-antispam-prvs: <PA4PR04MB7806B1FA8D1EB0DE1C7A674C9B1F0@PA4PR04MB7806.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z6BSAgwznUsMvMzZ+TLtKxtu/uBO2Hhh2U6Y4NsCIbqxycD5U58bPhJObDC1xGMrHGWQvk922Y6eDfqW922PzinEYP8Ll8Mrz2pEboY2mMH5e7Y6JBTtgy1xRX5LAXfo+ThM8pNJWJawS40LnZ81hQbCtTw1SbNAkqz1QtaBOlVWsMadzLY3OMVq/eB1jkQ3qCOiqFcu9u+5iLxWcx2g0w2bj6/VLwsWx1MuSwGE8XixmHZU+64gJQXePbMcNlnxyZ036zDd/KKmoW+XICmfRKsV38MxFGtU7hYl3ZPWYMQ/mchsmEHZb9fjnwFmQf12FUjIKHn/gV/bRqL0WsslOQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3PR04MB7356.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(136003)(346002)(39860400002)(83380400001)(36756003)(6506007)(33656002)(76116006)(64756008)(66556008)(6916009)(66946007)(66476007)(2906002)(66446008)(54906003)(186003)(478600001)(86362001)(8936002)(71200400001)(4326008)(6486002)(6512007)(316002)(5660300002)(8676002)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: yJEjTwOIoM2QCghTGoL1737aw82vKA6E2cfUEHwT9M4gh0Sr0BJnMQA4FvBeTekjPBXsfJm43eja/yV2YjB8lpAEnRhhDouFNIee2ARLy8x7ORZ5v6oA8yKBThqgbHHg7UeAtjMPHWZMSQ1XbKS6LndnXQWBLA5rAFDtxsPk+pZWAfLUVUYt0dMqkBpYTMa/e1gA7ztW0KV/A9RbfC2RORfg/Z3N8/fyV3vKLhSjYYq1F19C5KxkAe/UJqZvkelh23zdFXxZ9beK2B8p9tNprtj2/oKIE0J5cLCxw6iKiSGOoLMhlq0BRe0TaI8Y3ZDdfqK8FKhwoHJVbZQ9TFdhz2ti78pLT2tlJ5R7GgQnXlWDB+IuCUf65EA1oiaCpUSzyEEnYTJKJX1ABlOosIlFuFNvkzjRZhJANBaKh6/MgwYBXQXX7ERDUkV7QDGLUdwUSvpXiaAJgXkPQBSa0hS0RFph2fRPKqurPpCfYhVqHRFUqzNrULlBeJUC0VQW6OR3yStyMbYTI4VOjj9+6lHu0yfy11HlzGjWNAlBinWqeTS4ilVnmQtUOqOBSz67N3PL9U1JvJqIGrQEes7uIAZOISmX+MNjYZMGrwRxAP085dULrxOGtiWOlBM9WhAu21/nrKEGT106bIxCAK0mG1xbqWEU+RRNzoUBDSmVYM3fggk+tkgwzBo0Sk5EPYH9BiSWOvkfNTu6WCmK347UjNcMrw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <CDC2C020F139F948A508E63A0DEB374F@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: criteo.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PR3PR04MB7356.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59df71eb-3a8e-4545-09c7-08d874f43344
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2020 12:32:25.2311
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 2a35d8fd-574d-48e3-927c-8c398e225a01
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0ZKwK1GPyxmPIO4fW2vCF0Er9YF1BcwhyOJXP0hG4x22wril0tOM7UnuwAKTeJ4NgwegtIDmjdLiGXhA6/2cgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7806
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SGksDQoNCkknbSB0cnlpbmcgdG8gdW5kZXJzdGFuZCBhIGxpbWl0YXRpb24gaW4gaXB2bGFuL25l
dGZpbHRlciB0aGF0IHByZXZlbnRzIGRvaW5nIHJvdXRlZCBJUFZTIHdpdGggc291cmNlIE5BVCBp
bnNpZGUgYSBuYW1lc3BhY2UuDQoNClNldHVwIGlzIHRoZSBmb2xsb3dpbmc6IHRoZXJlIGlzIGFu
ICJsdnMiIG5hbWVzcGFjZSwgd2l0aCBhbiBpcHZsYW4gaW50ZXJmYWNlIChpbiBsMyBtb2RlKSBt
b3ZlZCB0byB0aGlzIG5hbWVzcGFjZSwgbGlua2VkIHRvIHBoeXNpY2FsIGludGVyZmFjZS4gR29h
bCBpcyB0byBpc29sYXRlIGxvYWQgYmFsYW5jZWQgdHJhZmZpYyBpbiBhIHNlcGFyYXRlIG5hbWVz
cGFjZS4NClRoaXMgc2V0dXAgaXMgd29ya2luZyBmbGF3bGVzc2x5IHdpdGggbDMgcm91dGVkIElQ
SVAgZW5jYXBzdWxhdGlvbiwgYnV0IEkgYWxzbyBoYXZlIGEgdXNlIGNhc2UgZm9yIGFwcGxpY2F0
aW9ucyB0aGF0IGRvbid0IHN1cHBvcnQgZW5jYXBzdWxhdGlvbiwgaGVuY2UgdGhlIG5lZWQgdG8g
ZG8gbDMgcm91dGVkIGxvYWQgYmFsYW5jaW5nIHdpdGggc291cmNlIE5BVC4NCklzc3VlIGlzIHRo
YXQgaWYgSSBwdXQgaXB0YWJsZXMgTkFUIHJ1bGUgaW4gbmFtZXNwYWNlIHVzaW5nIGlwdnMgbW9k
dWxlLCBub3RoaW5nIGhhcHBlbnMsIHBhY2tldCBpcyBmb3J3YXJkZWQgYnV0IHNvdXJjZSBJUCBp
cyBub3QgdHJhbnNsYXRlZC4gSXQgc2VlbXMgbGlrZSBuZXRmaWx0ZXIgaXMgYmxpbmQgdG8gaXB2
bGFuIGwzIHRyYWZmaWMuIEkgYWxzbyB0cmllZCB1c2luZyAibDNzIiBtb2RlIHRoYXQgc2hvdWxk
IHRvIGdvIHRocm91Z2ggbmV0ZmlsdGVyLCBidXQgaW4gdGhhdCBjYXNlLCBwYWNrZXRzIGZvciB2
aXJ0dWFsIElQcyBhcmUgcmVqZWN0ZWQgd2l0aCBhIFRDUCByZXNldC4gVmlydHVhbCBJUHMgaW4g
bmFtZXNwYWNlIHNlZW0gbm90IHZpc2libGUgdG8gdGhpcyBtb2RlLg0KDQpJJ20gd29uZGVyaW5n
IHdoYXQgd291bGQgYmUgdGhlIGJlc3Qgd2F5IHRvIG1ha2UgaXQgaGFwcGVuOg0KLSBwYXRjaCBp
cHZsYW4gdG8gbG9va3VwIGZvciBWSVBzIGluIG5hbWVzcGFjZXMNCi0gcGF0Y2ggbmV0ZmlsdGVy
IGlwdnMgTkFUIG1vZHVsZSB0byB0cmFuc2xhdGUgaW4gcm9vdCBuYW1lc3BhY2UNCi0gYW55IG90
aGVyIGJldHRlciBpZGVhIGlzIHdlbGNvbWUNCg0KUGxlYXNlIGZpbmQgYmVsb3cgY29tbWFuZHMg
dG8gcmVwcm9kdWNlIHRoZSBpc3N1ZS4gSW4gdGhpcyBleGFtcGxlIHBoeXNpY2FsIGxvYWQgYmFs
YW5jZXIgaW50ZXJmYWNlIGlzIGVucDRzMCwgdmlydHVhbCBJUCBpcyAxOTIuMTY4LjQyLjEgKHRv
IGJlIGV4cG9ydGVkIGJ5IGEgcm91dGluZyBwcm90b2NvbCwgb3Igcm91dGUgbWFudWFsbHkgYWRk
ZWQgdG8gYSBjbGllbnQgaW4gc2FtZSBzdWJuZXQgYXMgbG9hZCBiYWxhbmNlciBmb3IgdGVzdGlu
ZyksIGxvYWQgYmFsYW5jZXIgSVAgaXMgMTkyLjE2OC4xMC4xMCwgYW5kIHJlYWwgc2VydmVyIElQ
IGlzIDE5Mi4xNjguMjAuMjANCg0KLSBJbiByb290IG5hbWVzcGFjZToNCmlwIG5ldG5zIGFkZCBs
dnMNCmlwIGxpbmsgYWRkIGlwdmxhbjAgbGluayBlbnA0czAgdHlwZSBpcHZsYW4gbW9kZSBsM3MN
CmlwIGxpbmsgc2V0IGlwdmxhbjAgdXANCmlwIGxpbmsgc2V0IGlwdmxhbjAgbmV0bnMgbHZzDQoN
Ci0gSW4gbHZzIG5hbWVzcGFjZSAoaXAgbmV0bnMgZXhlYyBsdnMgYmFzaCk6DQppcCBhZGRyIGFk
ZCAxOTIuMTY4LjQyLjEvMzIgZGV2IGlwdmxhbjANCmlwIHJvdXRlIGFkZCBkZWZhdWx0IHZpYSAx
OTIuMTY4LjEwLjEwIGRldiBpcHZsYW4wIG9ubGluaw0KaXB2c2FkbSAtQSAtdCAxOTIuMTY4LjQy
LjE6ODAgLXMgcnINCmlwdnNhZG0gLWEgLXQgMTkyLjE2OC40Mi4xOjgwIC1yIDE5Mi4xNjguMjAu
MjA6ODAgLW0NCmlwdGFibGVzIC10IG5hdCAtQSBQT1NUUk9VVElORyAtbSBpcHZzIC0tdmFkZHIg
MTkyLjE2OC40Mi4xLzI0IC0tdnBvcnQgODAgLWogU05BVCAtLXRvLXNvdXJjZSAxOTIuMTY4LjEw
LjEwDQoNCldoYXQgSSdkIGV4cGVjdDogYSBwYWNrZXQgb3V0Z29pbmcgZnJvbSBlbnA0czAgd2l0
aCBzb3VyY2UgSVAgMTkyLjE2OC4xMC4xMCBhbmQgZGVzdGluYXRpb24gSVAgMTkyLjE2OC4yMC4y
MA0KV2hhdCBJIHNlZSBmcm9tIGEgdGVzdCBjbGllbnQ6DQotIGluIGwzIG1vZGU6IGEgcGFja2V0
IG91dGdvaW5nIGZyb20gZW5wNHMwIHdpdGggc291cmNlIGNsaWVudCBJUCBhZGRyZXNzIGFuZCBk
ZXN0aW5hdGlvbiAxOTIuMTY4LjIwLjIwIChoZW5jZSBtaXNzaW5nIHNvdXJjZSBOQVQpLiBJIGFs
c28gZG9uJ3Qgc2VlIGFueSBjb25udHJhY2sgZXZlbnQgd2hlbiBkb2luZyBjb25udHJhY2sgLUUN
Ci0gaW4gbDNzIG1vZGU6IGNvbm5lY3Rpb24gcmVzZXQgc2VudCB0byBjbGllbnQuIFdoaWxlIHJl
YWRpbmcgbDNzIGltcGxlbWVudGF0aW9uLCBJIHdvbmRlciB3aGVyZSByb3V0ZSBsb29rdXAgaXMg
ZG9uZSBpbiBpcHZsYW5fbDNfcmN2LCBpdCBzZWVtcyB0aGF0IG5hbWVzcGFjZXMnIHZpcnR1YWwg
SVAgYWRkcmVzc2VzIGFyZSBub3QgdmlzaWJsZSBkdXJpbmcgdGhpcyBsb29rdXAsIGhlbmNlIHRo
ZSBUQ1AgUlNULg0KDQpDaGVlcnMsDQotLSANCkRhbWllbiBDbGFpc3NlDQoNCg==
