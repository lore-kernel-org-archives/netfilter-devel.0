From: Chas Williams III <Charles.Williams@brocade.com>
Subject: cthelper's and default QueueLen -- bug?
Date: Thu, 7 May 2015 08:41:55 -0600
Message-ID: <1431009715.6436.2.camel@REM-DF8MK12.vyatta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:56004 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751394AbbEGOnU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 May 2015 10:43:20 -0400
Received: from pps.filterd (m0000542.ppops.net [127.0.0.1])
	by mx0a-000f0801.pphosted.com (8.14.7/8.14.7) with SMTP id t47CgfCc032676
	for <netfilter-devel@vger.kernel.org>; Thu, 7 May 2015 07:43:20 -0700
Received: from brmwp-exchub01.corp.brocade.com ([208.47.132.227])
	by mx0a-000f0801.pphosted.com with ESMTP id 1u7uau1k4y-6
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Thu, 07 May 2015 07:43:20 -0700
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Y29ubnRyYWNrZWQuY29uZiBzdGF0ZXMgdGhhdCB0aGUgZGVmYXVsdCBRdWV1ZUxlbiBpcyAxMDI0
Lg0KDQoJIyBNYXhpbXVtIG51bWJlciBvZiBwYWNrZXRzIHdhaXRpbmcgaW4gdGhlIHF1ZXVlIHRv
IHJlY2VpdmUNCgkjIGEgdmVyZGljdCBmcm9tIHVzZXItc3BhY2UuIERlZmF1bHQgaXMgMTAyNC4N
Cg0KSG93ZXZlciwgaWYgdGhlIGNvbmZpZyBmaWxlIGRvZXNuJ3Qgc3BlY2lmeSBhIHF1ZXVlIGxl
bmd0aCwgdGhlDQpkZWZhdWx0IGxlbmd0aCBpcyB6ZXJvIChkdWUgdG8gdGhlIGNhbGxvYygpIGFs
bG9jYXRpb24pLiAgVGhlDQpxdWV1ZSBhbHdheXMgc2VlbXMgdG8gYmUgcHVzaGVkIHVwIHRvIHRo
ZSBrZXJuZWwgcmVnYXJkbGVzcw0KaW4gY3RoZWxwZXJfbmZxdWV1ZV9zZXR1cCgpIHNvIHRoZSBr
ZXJuZWwgZGVmYXVsdCBpcyBvdmVyd3JpdHRlbi4NCg0K
