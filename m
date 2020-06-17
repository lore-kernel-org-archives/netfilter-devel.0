Return-Path: <SRS0=x4zc=76=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18AECC433E1
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Jun 2020 15:06:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBD6E206FA
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Jun 2020 15:06:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbgFQPGG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Jun 2020 11:06:06 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:20228 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726329AbgFQPGF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Jun 2020 11:06:05 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-53-5uhEa_3bOfazzDN9lH_l0Q-1; Wed, 17 Jun 2020 15:59:40 +0100
X-MC-Unique: 5uhEa_3bOfazzDN9lH_l0Q-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 17 Jun 2020 15:59:39 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 17 Jun 2020 15:59:39 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Linus Torvalds' <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>
CC:     Al Viro <viro@zeniv.linux.org.uk>, Ian Kent <raven@themaw.net>,
        "David Howells" <dhowells@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Subject: RE: [PATCH 05/13] fs: check FMODE_WRITE in __kernel_write
Thread-Topic: [PATCH 05/13] fs: check FMODE_WRITE in __kernel_write
Thread-Index: AQHWQzOZSLTjK0HIqkOBmunfm0asUajc6RXQ
Date:   Wed, 17 Jun 2020 14:59:39 +0000
Message-ID: <a1dcd0f17c9c468980c2f62e8d2a4529@AcuMS.aculab.com>
References: <20200615121257.798894-1-hch@lst.de>
 <20200615121257.798894-6-hch@lst.de>
 <CAHk-=whfMo7gvco8N5qEjh+jSqezv+bd+N-7txpNokD39t=dhQ@mail.gmail.com>
In-Reply-To: <CAHk-=whfMo7gvco8N5qEjh+jSqezv+bd+N-7txpNokD39t=dhQ@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

RnJvbTogTGludXMgVG9ydmFsZHMNCj4gU2VudDogMTUgSnVuZSAyMDIwIDE3OjQwDQo+IE9uIE1v
biwgSnVuIDE1LCAyMDIwIGF0IDU6MTMgQU0gQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+
IHdyb3RlOg0KPiA+DQo+ID4gV2Ugc3RpbGwgbmVlZCB0byBjaGVjayBpZiB0aGUgZtGVIGlzIG9w
ZW4gd3JpdGUsIGV2ZW4gZm9yIHRoZSBsb3ctbGV2ZWwNCj4gPiBoZWxwZXIuDQo+IA0KPiBJcyB0
aGVyZSBhY3R1YWxseSBhIHdheSB0byB0cmlnZ2VyIHNvbWV0aGluZyBsaWtlIHRoaXM/IEknbSB3
b25kZXJpbmcNCj4gaWYgaXQncyB3b3J0aCBhIFdBUk5fT05fT05DRSgpPw0KPiANCj4gSXQgZG9l
c24ndCBzb3VuZCBzZW5zaWJsZSB0byBoYXZlIHNvbWUga2VybmVsIGZ1bmN0aW9uYWxpdHkgdHJ5
IHRvDQo+IHdyaXRlIHRvIGEgZmlsZSBpdCBkaWRuJ3Qgb3BlbiBmb3Igd3JpdGUsIGFuZCBzb3Vu
ZHMgbGlrZSBhIGtlcm5lbCBidWcNCj4gaWYgdGhpcyBjYXNlIHdlcmUgdG8gZXZlciB0cmlnZ2Vy
Li4NCg0KSXQncyBhIGNoZWFwIHRlc3QgYXQgdGhlIHRvcCBvZiBzb21lIGZhaXJseSBoZWF2eSBj
b2RlLg0KRmFpbGluZyB0aGUgcmVxdWVzdCB3aWxsIHNvb24gaWRlbnRpZnkgdGhlIGJ1Zy4NCg0K
CURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBN
b3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAx
Mzk3Mzg2IChXYWxlcykNCg==

