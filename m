From: Matt Bennett <Matt.Bennett@alliedtelesis.co.nz>
Subject: Extending connmark to 64 bits
Date: Tue, 17 Nov 2015 23:14:22 +0000
Message-ID: <1447802062.16644.12.camel@mattb-dl>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:56418 "EHLO
	gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957AbbKQXO3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Nov 2015 18:14:29 -0500
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client did not present a certificate)
	by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 2AF69805F1
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2015 12:14:27 +1300 (NZDT)
Content-Language: en-US
Content-ID: <11ADA85BEFE0B04D90CC99A8CA240916@atlnz.lc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

SGVsbG8sDQoNCkN1cnJlbnRseSB3ZSBoYXZlIGEgbnVtYmVyIG9mIHJvdXRlciBmZWF0dXJlcyBt
YWtpbmcgdXNlIG9mIGNvbm5lY3Rpb24NCnRyYWNraW5nLiBBcyBzdWNoIHdlIG5vdyByZXF1aXJl
IG1vcmUgdGhhbiB0aGUgMzIgYml0cyBjb25ubWFyaw0KY3VycmVudGx5IGhhcy4gT3VyIGZpcnN0
IGluY2xpbmF0aW9uIGlzIHRvIGV4dGVuZCB0aGlzIGZpZWxkIHRvIDY0IGJpdHMNCmFuZCB1cGRh
dGUgcmVsYXRlZCBhcmVhcyBvZiBjb2RlIGFwcHJvcHJpYXRlbHkuDQoNClRoZSBtYWpvciBxdWVz
dGlvbiB3ZSBoYXZlIGlzIHdoZXRoZXIgdGhlcmUgaXMgYSByZWFzb24gdGhpcyBmaWVsZCBpcyAz
Mg0KYml0cyAocGVyZm9ybWFuY2UgcmVhc29ucyBvciBvdGhlcik/DQoNCklmIGl0IGlzIG5vdCBw
b3NzaWJsZSB0byBleHRlbmQgdGhpcyBmaWVsZCB0aGVuIHBlcmhhcHMgdGhlcmUgYXJlIG90aGVy
DQpvcHRpb25zIChiZXlvbmQgZGlzYWJsaW5nIHNvbWUgZmVhdHVyZXMgbWFraW5nIHVzZSBvZiBj
b25uZWN0aW9uDQp0cmFja2luZyk/DQoNClRoYW5rcywNCk1hdHQNCg0KDQo=
