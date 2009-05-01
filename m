From: "Roche, Christian (EXT-Other - MA/Rabat)"
	<christian.roche.ext@nsn.com>
Subject: Wrong format produced by iptables-save for uid-owner
Date: Fri, 1 May 2009 18:32:36 +0200
Message-ID: <0D554AB869C49444A06B363CEA61264A018C24CA@DEMUEXC027.nsn-intra.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: base64
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from demumfd002.nsn-inter.net ([217.115.75.234]:14739 "EHLO
	demumfd002.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbZEAQcj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 May 2009 12:32:39 -0400
Received: from demuprx016.emea.nsn-intra.net ([10.150.129.55])
	by demumfd002.nsn-inter.net (8.12.11.20060308/8.12.11) with ESMTP id n41GWb3T026230
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <netfilter-devel@vger.kernel.org>; Fri, 1 May 2009 18:32:37 +0200
Received: from demuexc025.nsn-intra.net (demuexc025.nsn-intra.net [10.159.32.12])
	by demuprx016.emea.nsn-intra.net (8.12.11.20060308/8.12.11) with ESMTP id n41GWbFc000769
	for <netfilter-devel@vger.kernel.org>; Fri, 1 May 2009 18:32:37 +0200
Content-class: urn:content-classes:message
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

DQpIaSB0aGVyZSwNCg0KZm9yIHNvbWUgdGltZXMgSSd2ZSBidW1wZWQgaW50byB0aGlzIGFubm95
aW5nIGJ1ZyB3aXRoIGlwdGFibGVzLXNhdmUgKEknbSB1c2luZyBGZWRvcmEgQ29yZSA4KS4gIEkn
dmUgZ290IHRoZSBmb2xsb3dpbmcgcnVsZXMgaW4gbXkgY29uZmlnIDoNCi0tLS0tLS0tLS0tLS0t
LS0tDQojIExpbWl0IEludGVybmV0IGFjY2VzcyB0byByb290IGFuZCBzcXVpZCBwcm94eQ0KaXB0
YWJsZXMgLUEgT1VUUFVUIC1vIGV0aDEgLW0gb3duZXIgLS11aWQtb3duZXIgcm9vdCAtaiBBQ0NF
UFQNCmlwdGFibGVzIC1BIE9VVFBVVCAtbyBldGgxIC1tIG93bmVyICEgLS11aWQtb3duZXIgc3F1
aWQgLWogRFJPUA0KLS0tLS0tLS0tLS0tLS0tLS0NCg0KTm93IGlwdGFibGVzLXNhdmUgZ2VuZXJh
dGVzIHRoaXMgOg0KLS0tLS0tLS0tLS0tLS0tLS0NCiMgR2VuZXJhdGVkIGJ5IGlwdGFibGVzLXNh
dmUgdjEuNC4xLjEgb24gRnJpIE1heSAgMSAxNjowNzozNiAyMDA5DQotQSBPVVRQVVQgLW8gZXRo
MSAtbSBvd25lciAtLXVpZC1vd25lcjAgLWogQUNDRVBUDQotQSBPVVRQVVQgLW8gZXRoMSAtbSBv
d25lciAhIC0tdWlkLW93bmVyMjMgLWogRFJPUA0KLS0tLS0tLS0tLS0tLS0tLS0NCg0KUHJvYmxl
bTogdGhlcmUgaXMgYSBzcGFjZSBtaXNzaW5nIGJldHdlZW4gIi0tdWlkLW93bmVyIiBhbmQgdGhl
IHZhbHVlLCB3aGljaCBsZWFkcyB0byA6DQotLS0tLS0tLS0tLS0tLS0tLQ0KaXB0YWJsZXMtcmVz
dG9yZSB2MS40LjEuMTogVW5rbm93biBhcmcgYC0tdWlkLW93bmVyMCcNCkVycm9yIG9jY3VycmVk
IGF0IGxpbmU6IDI2DQotLS0tLS0tLS0tLS0tLS0tLQ0KDQpJcyB0aGlzIGEga25vd24gaXNzdWUg
PyAgU2hvdWxkIEkgZmlsbCBhIGJ1ZyByZXBvcnQgPw0KDQpUaGFua3MsDQpDaHJpcw0K
