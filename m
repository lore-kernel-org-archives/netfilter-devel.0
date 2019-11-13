Return-Path: <SRS0=8p/T=ZF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=CHARSET_FARAWAY_HEADER,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6619CC17440
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Nov 2019 02:00:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48E15222CF
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Nov 2019 02:00:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730465AbfKMCAT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Nov 2019 21:00:19 -0500
Received: from mx20.baidu.com ([111.202.115.85]:52899 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730369AbfKMCAP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Nov 2019 21:00:15 -0500
X-Greylist: delayed 2823 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Nov 2019 21:00:15 EST
Received: from BC-Mail-Ex16.internal.baidu.com (unknown [172.31.51.56])
        by Forcepoint Email with ESMTPS id 942849F3D217;
        Wed, 13 Nov 2019 09:13:03 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 BC-Mail-Ex16.internal.baidu.com (172.31.51.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1531.3; Wed, 13 Nov 2019 09:13:04 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1713.004; Wed, 13 Nov 2019 09:13:04 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: =?gb2312?B?tPC4tDogW1BBVENIXSBuZXRmaWx0ZXI6IG9ubHkgY2FsbCBjc3VtX3RjcHVk?=
 =?gb2312?Q?p=5Fmagic_for_TCP/UDP_packets?=
Thread-Topic: [PATCH] netfilter: only call csum_tcpudp_magic for TCP/UDP
 packets
Thread-Index: AQHVmaBlMDoswT42d0CyLxswK8HJyaeIS5tw
Date:   Wed, 13 Nov 2019 01:13:04 +0000
Message-ID: <1072b63d920747948e87f6536d38458c@baidu.com>
References: <1573285817-32651-1-git-send-email-lirongqing@baidu.com>
 <20191112213018.6uay6m3jxycjyks2@salvia>
In-Reply-To: <20191112213018.6uay6m3jxycjyks2@salvia>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.198.12]
x-baidu-bdmsfe-datecheck: 1_BC-Mail-Ex16_2019-11-13 09:13:04:710
x-baidu-bdmsfe-viruscheck: BC-Mail-Ex16_GRAY_Inside_WithoutAtta_2019-11-13
 09:13:04:694
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

DQoNCj4gLS0tLS3Tyrz+1K28/i0tLS0tDQo+ILeivP7IyzogbmV0ZmlsdGVyLWRldmVsLW93bmVy
QHZnZXIua2VybmVsLm9yZw0KPiBbbWFpbHRvOm5ldGZpbHRlci1kZXZlbC1vd25lckB2Z2VyLmtl
cm5lbC5vcmddILT6se0gUGFibG8gTmVpcmEgQXl1c28NCj4gt6LLzcqxvOQ6IDIwMTnE6jEx1MIx
M8jVIDU6MzANCj4gytW8/sjLOiBMaSxSb25ncWluZyA8bGlyb25ncWluZ0BiYWlkdS5jb20+DQo+
ILOty806IG5ldGZpbHRlci1kZXZlbEB2Z2VyLmtlcm5lbC5vcmcNCj4g1vfM4jogUmU6IFtQQVRD
SF0gbmV0ZmlsdGVyOiBvbmx5IGNhbGwgY3N1bV90Y3B1ZHBfbWFnaWMgZm9yIFRDUC9VRFAgcGFj
a2V0cw0KPiANCj4gT24gU2F0LCBOb3YgMDksIDIwMTkgYXQgMDM6NTA6MTdQTSArMDgwMCwgTGkg
Um9uZ1Fpbmcgd3JvdGU6DQo+ID4gY3N1bV90Y3B1ZHBfbWFnaWMgc2hvdWxkIG5vdCBiZSBjYWxs
ZWQgdG8gY29tcHV0ZSBjaGVja3N1bSBmb3INCj4gPiBub24tVENQL1VEUCBwYWNrZXRzLCBsaWtl
IElDTVAgd2l0aCB3cm9uZyBjaGVja3N1bQ0KPiANCj4gVGhpcyBpcyBmaXhpbmcgNWQxNTQ5ODQ3
Yzc2YjFmZmNmOGUzODhlZjRkMGYyMjliZGQxZDdlOC4NCj4gDQo+ID4gU2lnbmVkLW9mZi1ieTog
TGkgUm9uZ1FpbmcgPGxpcm9uZ3FpbmdAYmFpZHUuY29tPg0KPiA+IC0tLQ0KPiA+ICBuZXQvbmV0
ZmlsdGVyL3V0aWxzLmMgfCA5ICsrKysrKy0tLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgNiBpbnNl
cnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL25ldC9uZXRm
aWx0ZXIvdXRpbHMuYyBiL25ldC9uZXRmaWx0ZXIvdXRpbHMuYyBpbmRleA0KPiA+IDUxYjQ1NGQ4
ZmE5Yy4uNzJlYWNlNTI4NzRlIDEwMDY0NA0KPiA+IC0tLSBhL25ldC9uZXRmaWx0ZXIvdXRpbHMu
Yw0KPiA+ICsrKyBiL25ldC9uZXRmaWx0ZXIvdXRpbHMuYw0KPiA+IEBAIC0xNyw5ICsxNywxMiBA
QCBfX3N1bTE2IG5mX2lwX2NoZWNrc3VtKHN0cnVjdCBza19idWZmICpza2IsDQo+IHVuc2lnbmVk
IGludCBob29rLA0KPiA+ICAJY2FzZSBDSEVDS1NVTV9DT01QTEVURToNCj4gPiAgCQlpZiAoaG9v
ayAhPSBORl9JTkVUX1BSRV9ST1VUSU5HICYmIGhvb2sgIT0gTkZfSU5FVF9MT0NBTF9JTikNCj4g
PiAgCQkJYnJlYWs7DQo+ID4gLQkJaWYgKChwcm90b2NvbCAhPSBJUFBST1RPX1RDUCAmJiBwcm90
b2NvbCAhPSBJUFBST1RPX1VEUCAmJg0KPiA+IC0JCSAgICAhY3N1bV9mb2xkKHNrYi0+Y3N1bSkp
IHx8DQo+ID4gLQkJICAgICFjc3VtX3RjcHVkcF9tYWdpYyhpcGgtPnNhZGRyLCBpcGgtPmRhZGRy
LA0KPiA+ICsJCWlmIChwcm90b2NvbCAhPSBJUFBST1RPX1RDUCAmJiBwcm90b2NvbCAhPSBJUFBS
T1RPX1VEUCkgew0KPiA+ICsJCQlpZiAoIWNzdW1fZm9sZChza2ItPmNzdW0pKSB7DQo+ID4gKwkJ
CQlza2ItPmlwX3N1bW1lZCA9IENIRUNLU1VNX1VOTkVDRVNTQVJZOw0KPiA+ICsJCQkJYnJlYWs7
DQo+ID4gKwkJCX0NCj4gPiArCQl9IGVsc2UgaWYgKCFjc3VtX3RjcHVkcF9tYWdpYyhpcGgtPnNh
ZGRyLCBpcGgtPmRhZGRyLA0KPiA+ICAJCQkJICAgICAgIHNrYi0+bGVuIC0gZGF0YW9mZiwgcHJv
dG9jb2wsDQo+ID4gIAkJCQkgICAgICAgc2tiLT5jc3VtKSkgew0KPiANCj4gUHJvYmFibHkgZGlz
ZW50YW5nbGUgdGhpcyBjb2RlIHdpdGggdGhlIGZvbGxvd2luZyBzbmlwcGV0Pw0KPiANCj4gICAg
ICAgICAgICAgICAgIHN3aXRjaCAocHJvdG9jb2wpIHsNCj4gICAgICAgICAgICAgICAgIGNhc2Ug
SVBQUk9UT19UQ1A6DQo+ICAgICAgICAgICAgICAgICBjYXNlIElQUFJPVE9fVURQOg0KPiAgICAg
ICAgICAgICAgICAgICAgICAgICBpZiAoIWNzdW1fdGNwdWRwX21hZ2ljKGlwaC0+c2FkZHIsIGlw
aC0+ZGFkZHIsDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgc2tiLT5sZW4gLSBkYXRhb2ZmLA0KPiBwcm90b2NvbCwNCj4gICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBza2ItPmNzdW0pKQ0KPiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBza2ItPmlwX3N1bW1lZCA9DQo+IENIRUNLU1VNX1VOTkVDRVNT
QVJZOw0KPiAgICAgICAgICAgICAgICAgICAgICAgICBicmVhazsNCj4gICAgICAgICAgICAgICAg
IGRlZmF1bHQ6DQo+ICAgICAgICAgICAgICAgICAgICAgICAgIGlmICghY3N1bV9mb2xkKHNrYi0+
Y3N1bSkpDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc2tiLT5pcF9zdW1tZWQg
PQ0KPiBDSEVDS1NVTV9VTk5FQ0VTU0FSWTsNCj4gICAgICAgICAgICAgICAgICAgICAgICAgYnJl
YWs7DQo+ICAgICAgICAgICAgICAgICB9DQo+IA0KT0sgLEkgd2lsbCBzZW5kIFYyLCB0aGFua3MN
Cg0KLVJvbmdRaW5nDQo=
