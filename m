From: "medialy" <medialy@gmail.com>
Subject: why counters in nf_conntrack not set in centos 6.x?
Date: Wed, 11 Dec 2013 23:05:01 +0800
Message-ID: <52A87F08.5040509@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
To: "netfilter-devel" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:65342 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab3LKPFA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Dec 2013 10:05:00 -0500
Received: by mail-pd0-f181.google.com with SMTP id p10so9618109pdj.26
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Dec 2013 07:05:00 -0800 (PST)
Received: from xt530x ([114.250.227.176])
        by mx.google.com with ESMTPSA id e2sm12872456pbq.20.2013.12.11.07.04.58
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 11 Dec 2013 07:04:59 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

DQpBbiBhcHBsaWNhdGlvbiBiYXNlZCBvbiBsaWJuZXRmaWx0ZXJfY29ubnRyYWNrIGFuZCBsaWJu
Zm5ldGxpbmsgZmFpbGVkIHRvIGdldCBjb3VudGVycyBpbiBDZW50T1MgNi54LCANCmJ1dCBpdCB3
b3JrcyB3b3JrcyBmaW5lIHdpdGggdGhlIHNhbWUgY29kZSBpbiBDZW50T1MgNS54LiBIb3cgdG8g
ZW5hYmxlIHRoZSBjb3VudGVyIGZ1bmN0aW9uYWxpdHk/DQpTYW1wbGUgY29kZToNCg0KaGFuZGxl
X2Nvbm50cmFja18gPSBuZmN0X29wZW4oQ09OTlRSQUNLLCBORl9ORVRMSU5LX0NPTk5UUkFDS19E
RVNUUk9ZKTsNCm5mY3RfY2FsbGJhY2tfcmVnaXN0ZXIoaGFuZGxlX2Nvbm50cmFja18sIE5GQ1Rf
VF9BTEwsIGNvbm50cmFja19jYWxsYmFjaywgTlVMTCk7DQoNCnN0YXRpYyBpbnQgY29ubnRyYWNr
X2NhbGxiYWNrKGVudW0gbmZfY29ubnRyYWNrX21zZ190eXBlIHR5cGUsIHN0cnVjdCBuZl9jb25u
dHJhY2sqIGN0LCB2b2lkKiBkYXRhKQ0Kew0KICAgIHN0cnVjdCBfX25mY3RfY291bnRlcnMgb3Jp
Z19jb3VudGVyID0gY3QtPmNvdW50ZXJzW19fRElSX09SSUddOw0KICAgIHN0cnVjdCBfX25mY3Rf
Y291bnRlcnMgcmVwbF9jb3VudGVyID0gY3QtPmNvdW50ZXJzW19fRElSX1JFUExdOw0KICAgIC8v
aW4gQ2VudE9TIDYueCwgb3JpZ19jb3VudGVyLnBhY2tldHMsb3JpZ19jb3VudGVyLmJ5dGVzLHJl
cGxfY291bnRlci5wYWNrZXRzIGFuZCByZXBsX2NvdW50ZXIuYnl0ZXMgYXJlIG5vdCBzZXQoemVy
bykNCn0NCg0KT1MgYW5kIGxpYnJhcnkgdmVyc2lvbjoNCkNlbnRPUyA2LjQgeDg2XzY0DQpsaWJu
Zm5ldGxpbmstMS4wLjANCmxpYm5ldGZpbHRlcl9jb25udHJhY2stMC4wLjEwMA==
