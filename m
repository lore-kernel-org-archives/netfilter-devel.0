From: "Laurence J. Lane" <ljlane@debian.org>
Subject: [PATCH] iptables: iptables calls setsockopt incorrectly
Date: Thu, 8 Aug 2013 13:25:46 -0400
Message-ID: <CA+0KVf052HAN73aMrM95aosN-=49Esam1spX=sUyvd61sDYDRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=047d7b3432ca0b209704e372f4ee
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dunimos.ljlane.net ([216.218.223.72]:46233 "EHLO
	dunimos.ljlane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965673Ab3HHR0K (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Aug 2013 13:26:10 -0400
Received: from mail-ve0-f181.google.com (mail-ve0-f181.google.com [209.85.128.181])
	(using TLSv1 with cipher ECDHE-RSA-RC4-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: google-debian@dunimos.ljlane.net)
	by dunimos.ljlane.net (Postfix) with ESMTPSA id 0445729433
	for <netfilter-devel@vger.kernel.org>; Thu,  8 Aug 2013 13:26:07 -0400 (EDT)
Received: by mail-ve0-f181.google.com with SMTP id jz10so3302739veb.12
        for <netfilter-devel@vger.kernel.org>; Thu, 08 Aug 2013 10:26:07 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--047d7b3432ca0b209704e372f4ee
Content-Type: text/plain; charset=ISO-8859-1

https://bugs.launchpad.net/ubuntu/+source/iptables/+bug/1187177
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=710997


---------- Forwarded message ----------
From: LaMont Jones <lamont@debian.org>
Date: Mon, Jun 3, 2013 at 6:07 PM
Subject: Bug#710997: iptables calls setsockopt incorrectly
To: submit@bugs.debian.org


Package: iptables
Version: 1.4.18-1
Tags: patch
--

Since time immemorial, iptables has called setsockopt() and treated any
-1 return value as fatal.  Any system call can return EAGAIN or
EINPROGRESS (depending on the origins of the API), and good coding
practice requires checking for that and retrying or otherwise handling
it.

In the case of iptables, if multiple processes are calling iptables
concurrently, then it is likely that one of them will fail.  I have seen
this with xen, as well as certain firewall configurations where the
firewall rules are added as triggered by interfaces being discovered and
configured.

The attached patch fixes the issue.
lamont

--047d7b3432ca0b209704e372f4ee
Content-Type: text/x-diff; charset=us-ascii; name="retry-setsockopt.diff"
Content-Disposition: attachment; filename="retry-setsockopt.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: e190aaf510353da0_0.1

ZGlmZiAtdXIgeC9pcHRhYmxlcy0xLjQuMTgvbGliaXB0Yy9saWJpcHRjLmMgaXB0YWJsZXMtMS40
LjE4L2xpYmlwdGMvbGliaXB0Yy5jDQotLS0geC9pcHRhYmxlcy0xLjQuMTgvbGliaXB0Yy9saWJp
cHRjLmMJMjAxMy0wMy0wMyAxNDo0MDoxMS4wMDAwMDAwMDAgLTA3MDANCisrKyBpcHRhYmxlcy0x
LjQuMTgvbGliaXB0Yy9saWJpcHRjLmMJMjAxMy0wNi0wMyAxNjowMzozMS44MTk0NDgwMTkgLTA2
MDANCkBAIC0yNTk2LDggKzI1OTYsMTAgQEANCiAJfQ0KICNlbmRpZg0KIA0KLQlyZXQgPSBzZXRz
b2Nrb3B0KGhhbmRsZS0+c29ja2ZkLCBUQ19JUFBST1RPLCBTT19TRVRfUkVQTEFDRSwgcmVwbCwN
CisJZG8gew0KKwkJcmV0ID0gc2V0c29ja29wdChoYW5kbGUtPnNvY2tmZCwgVENfSVBQUk9UTywg
U09fU0VUX1JFUExBQ0UsIHJlcGwsDQogCQkJIHNpemVvZigqcmVwbCkgKyByZXBsLT5zaXplKTsN
CisJfSB3aGlsZSAoIHJldCA8IDAgJiYgKCBlcnJubyA9PSBFQUdBSU4gfHwgZXJybm8gPT0gRUlO
UFJPR1JFU1MpKTsNCiAJaWYgKHJldCA8IDApDQogCQlnb3RvIG91dF9mcmVlX25ld2NvdW50ZXJz
Ow0KIA0KQEAgLTI2NzIsOCArMjY3NCwxMCBAQA0KIAl9DQogI2VuZGlmDQogDQotCXJldCA9IHNl
dHNvY2tvcHQoaGFuZGxlLT5zb2NrZmQsIFRDX0lQUFJPVE8sIFNPX1NFVF9BRERfQ09VTlRFUlMs
DQorCWRvIHsNCisJCXJldCA9IHNldHNvY2tvcHQoaGFuZGxlLT5zb2NrZmQsIFRDX0lQUFJPVE8s
IFNPX1NFVF9BRERfQ09VTlRFUlMsDQogCQkJIG5ld2NvdW50ZXJzLCBjb3VudGVybGVuKTsNCisJ
fSB3aGlsZSAoIHJldCA8IDAgJiYgKCBlcnJubyA9PSBFQUdBSU4gfHwgZXJybm8gPT0gRUlOUFJP
R1JFU1MpKTsNCiAJaWYgKHJldCA8IDApDQogCQlnb3RvIG91dF9mcmVlX25ld2NvdW50ZXJzOw0K
IA0K
--047d7b3432ca0b209704e372f4ee--
