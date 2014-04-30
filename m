From: Janeks Jaunups <th3n3x@gmail.com>
Subject: [PATCH] ipset: Fix ethernet address parser
Date: Wed, 30 Apr 2014 11:35:53 +0300
Message-ID: <CAM=+jx8BjiVY6f3Gv8G3KPxr3KaDYkbTqeZWkxhBFakgdsnyLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a1134a210c93bfc04f83e6f6a
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oa0-f49.google.com ([209.85.219.49]:51868 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235AbaD3Ify (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Apr 2014 04:35:54 -0400
Received: by mail-oa0-f49.google.com with SMTP id o6so1554060oag.8
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Apr 2014 01:35:54 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--001a1134a210c93bfc04f83e6f6a
Content-Type: text/plain; charset=UTF-8

Hi,

Currently ipset would not parse ether addresses which are not exactly
17 characters long, for ex. 1:2:3:4:5:6

I've ran into this problem when trying to do fancy things with ISC
DHCP scripts/events, which gladly skips zeroes in front of address
element, at least in a way I was doing it.

on commit {
  set ClientIP = binary-to-ascii(10, 8, ".", leased-address);
  set ClientMac = binary-to-ascii(16, 8, ":", substring(hardware, 1, 6));

  execute("sudo", "/usr/sbin/ipset", "add", "-exist", "dynnet",
concat( ClientIP, ",", ClientMac));
}

Best regards,
JJ

--001a1134a210c93bfc04f83e6f6a
Content-Type: application/octet-stream; name="lib_parse.patch"
Content-Disposition: attachment; filename="lib_parse.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_humdcoun0

ZGlmZiAtLWdpdCBhL2xpYi9wYXJzZS5jIGIvbGliL3BhcnNlLmMKaW5kZXggNGRiODcyZS4uYmU2
ZTgzMyAxMDA2NDQKLS0tIGEvbGliL3BhcnNlLmMKKysrIGIvbGliL3BhcnNlLmMKQEAgLTE4MCwy
NCArMTgwLDI3IEBAIGludAogaXBzZXRfcGFyc2VfZXRoZXIoc3RydWN0IGlwc2V0X3Nlc3Npb24g
KnNlc3Npb24sCiAJCSAgZW51bSBpcHNldF9vcHQgb3B0LCBjb25zdCBjaGFyICpzdHIpCiB7Ci0J
dW5zaWduZWQgaW50IGkgPSAwOworCXNpemVfdCBsZW4sIHAgPSAwLCBpID0gMDsKIAl1bnNpZ25l
ZCBjaGFyIGV0aGVyW0VUSF9BTEVOXTsKIAogCWFzc2VydChzZXNzaW9uKTsKIAlhc3NlcnQob3B0
ID09IElQU0VUX09QVF9FVEhFUik7CiAJYXNzZXJ0KHN0cik7CiAKLQlpZiAoc3RybGVuKHN0cikg
IT0gRVRIX0FMRU4gKiAzIC0gMSkKKwlsZW4gPSBzdHJsZW4oc3RyKTsKKworCWlmIChsZW4gPiBF
VEhfQUxFTiAqIDMgLSAxKQogCQlnb3RvIGVycm9yOwogCiAJZm9yIChpID0gMDsgaSA8IEVUSF9B
TEVOOyBpKyspIHsKIAkJbG9uZyBudW1iZXI7CiAJCWNoYXIgKmVuZDsKIAotCQludW1iZXIgPSBz
dHJ0b2woc3RyICsgaSAqIDMsICZlbmQsIDE2KTsKKwkJbnVtYmVyID0gc3RydG9sKHN0ciArIHAs
ICZlbmQsIDE2KTsKKwkJcCA9IGVuZCAtIHN0ciArIDE7CiAKLQkJaWYgKGVuZCA9PSBzdHIgKyBp
ICogMyArIDIgJiYKLQkJICAgICgqZW5kID09ICc6JyB8fCAqZW5kID09ICdcMCcpICYmCisJCWlm
ICgoKCplbmQgPT0gJzonICYmIGkgPCBFVEhfQUxFTiAtIDEpIHx8CisJCSAgICAgKCplbmQgPT0g
J1wwJyAmJiBpID09IEVUSF9BTEVOIC0gMSkpICYmCiAJCSAgICBudW1iZXIgPj0gMCAmJiBudW1i
ZXIgPD0gMjU1KQogCQkJZXRoZXJbaV0gPSBudW1iZXI7CiAJCWVsc2UK
--001a1134a210c93bfc04f83e6f6a--
