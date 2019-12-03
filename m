Return-Path: <SRS0=edwS=ZZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.5 required=3.0 tests=CHARSET_FARAWAY_HEADER,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3B98C432C3
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Dec 2019 02:42:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D486E20684
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Dec 2019 02:42:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbfLCCmp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Dec 2019 21:42:45 -0500
Received: from mx20.baidu.com ([111.202.115.85]:50460 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725957AbfLCCmo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Dec 2019 21:42:44 -0500
Received: from BJHW-Mail-Ex15.internal.baidu.com (unknown [10.127.64.38])
        by Forcepoint Email with ESMTPS id 6B15CB251582F;
        Tue,  3 Dec 2019 10:42:38 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Tue, 3 Dec 2019 10:42:39 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1713.004; Tue, 3 Dec 2019 10:42:39 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: =?gb2312?B?tPC4tDogW1BBVENIXVt2Ml0gbmV0ZmlsdGVyOiBvbmx5IGNhbGwgY3N1bV90?=
 =?gb2312?Q?cpudp=5Fmagic_for_TCP/UDP_packets?=
Thread-Topic: [PATCH][v2] netfilter: only call csum_tcpudp_magic for TCP/UDP
 packets
Thread-Index: AQHVpoxxHLXfJXfwnE60t8HgUdTDz6enuQpw
Date:   Tue, 3 Dec 2019 02:42:39 +0000
Message-ID: <3f31a6ab5eb945f68b12829aa39e8f47@baidu.com>
References: <1573630441-13937-1-git-send-email-lirongqing@baidu.com>
 <20191129081013.lhnjkft3sf7uyyhn@salvia>
In-Reply-To: <20191129081013.lhnjkft3sf7uyyhn@salvia>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.198.12]
x-baidu-bdmsfe-datecheck: 1_BJHW-Mail-Ex15_2019-12-03 10:42:40:145
x-baidu-bdmsfe-viruscheck: BJHW-Mail-Ex15_GRAY_Inside_WithoutAtta_2019-12-03
 10:42:40:129
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

PiA+IC0JCQkJICAgICAgIHNrYi0+bGVuIC0gZGF0YW9mZiwgcHJvdG9jb2wsDQo+ID4gLQkJCQkg
ICAgICAgc2tiLT5jc3VtKSkgew0KPiANCj4gQ291bGQgeW91IGRlc2NyaWJlIHdoYXQgeW91IG9i
c2VydmUgdGhlcmUgdG8gdGFnIHRoaXMgcGF0Y2ggYXMgYSBGaXg/DQo+IA0KDQpub3RoaW5nLCAg
dGhpcyBmaXggdGFnIGNhbiBiZSBkcm9wcGVkDQoNCkkgZmluZCB0aGlzIHVucmVhc29uYWJsZSBj
b2RlcyB3aGVuIEkgcmVhZCwgaXQgc2hvdWxkIGhhdmUgbGl0dGxlIG5lZ2F0aXZlIGVmZmVjdC4N
Cg0KdGhhbmtzDQoNCi1MaQ0KDQo=
