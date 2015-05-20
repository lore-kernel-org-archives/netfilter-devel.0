From: Chas Williams III <Charles.Williams@brocade.com>
Subject: [PATCH] cthelper: don't pass up a 0 length queue
Date: Wed, 20 May 2015 07:50:50 -0600
Message-ID: <1432129850.12119.27.camel@REM-DF8MK12.vyatta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:24305 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753288AbbETNvH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 May 2015 09:51:07 -0400
Received: from pps.filterd (m0048192.ppops.net [127.0.0.1])
	by mx0b-000f0801.pphosted.com (8.14.7/8.14.7) with SMTP id t4KConfk026246
	for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2015 06:51:06 -0700
Received: from hq1wp-exchub01.corp.brocade.com ([144.49.131.13])
	by mx0b-000f0801.pphosted.com with ESMTP id 1ugcd51h9y-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2015 06:51:06 -0700
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

SWYgdGhlIHVzZXIgZGlkbid0IHNwZWNpZnkgYSBxdWV1ZSBsZW5ndGggaW4gdGhlIGNvbmZpZ3Vy
YXRpb24gZmlsZSBpdA0Kd2lsbCBoYXZlIGEgbGVuZ3RoIG9mIDAuICBBbGxvdyB0aGUga2VybmVs
J3MgZGVmYXVsdCB0byB0YWtlIHByZWNlZGVuY2UNCmluc3RlYWQuDQoNClNpZ25lZC1vZmYtYnk6
IENoYXJsZXMgKENoYXMpIFdpbGxpYW1zIDxjaXdpbGxpYUBicm9jYWRlLmNvbT4NCi0tLQ0KIHNy
Yy9jdGhlbHBlci5jIHwgNCArKystDQogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwg
MSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvc3JjL2N0aGVscGVyLmMgYi9zcmMvY3RoZWxw
ZXIuYw0KaW5kZXggZmVjNDBmYi4uNmJhNzMxYiAxMDA2NDQNCi0tLSBhL3NyYy9jdGhlbHBlci5j
DQorKysgYi9zcmMvY3RoZWxwZXIuYw0KQEAgLTQ2OSw3ICs0NjksOSBAQCBzdGF0aWMgaW50IGN0
aGVscGVyX25mcXVldWVfc2V0dXAoc3RydWN0IGN0ZF9oZWxwZXJfaW5zdGFuY2UgKmN1cikNCiAJ
bmZxX25sbXNnX2NmZ19wdXRfcGFyYW1zKG5saCwgTkZRTkxfQ09QWV9QQUNLRVQsIDB4ZmZmZik7
DQogCW1ubF9hdHRyX3B1dF91MzIobmxoLCBORlFBX0NGR19GTEFHUywgaHRvbmwoTkZRQV9DRkdf
Rl9DT05OVFJBQ0spKTsNCiAJbW5sX2F0dHJfcHV0X3UzMihubGgsIE5GUUFfQ0ZHX01BU0ssIGh0
b25sKDB4ZmZmZmZmZmYpKTsNCi0JbW5sX2F0dHJfcHV0X3UzMihubGgsIE5GUUFfQ0ZHX1FVRVVF
X01BWExFTiwgaHRvbmwoY3VyLT5xdWV1ZV9sZW4pKTsNCisJaWYgKGN1ci0+cXVldWVfbGVuID4g
MCkgew0KKwkJbW5sX2F0dHJfcHV0X3UzMihubGgsIE5GUUFfQ0ZHX1FVRVVFX01BWExFTiwgaHRv
bmwoY3VyLT5xdWV1ZV9sZW4pKTsNCisJfQ0KIA0KIAlpZiAobW5sX3NvY2tldF9zZW5kdG8oU1RB
VEVfQ1RIKG5sKSwgbmxoLCBubGgtPm5sbXNnX2xlbikgPCAwKSB7DQogCQlkbG9nKExPR19FUlIs
ICJmYWlsZWQgdG8gc2VuZCBjb25maWd1cmF0aW9uIik7DQotLSANCjEuOS4xDQoNCg0KDQo=
