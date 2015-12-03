From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft] bug in sets cache
Date: Thu, 3 Dec 2015 12:44:24 +0100
Message-ID: <CAOkSjBgczdvb_6wnjJ9n-WKt3HwEqwx66FP9iddzQ_UTjaRTqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a11468750cb00a20525fcea16
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:35488 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756081AbbLCLop (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Dec 2015 06:44:45 -0500
Received: by wmuu63 with SMTP id u63so17483865wmu.0
        for <netfilter-devel@vger.kernel.org>; Thu, 03 Dec 2015 03:44:44 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--001a11468750cb00a20525fcea16
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi there,

I've found an annoying bug in sets handling in nft, likely the cache stuff.

How to reproduce it:

# start with an empty ruleset
% nft list ruleset

# load sample ruleset
% nft -f ruleset.nft

# delete rule referencing set 'test'
% nft delete rule inet test test handle 2

# delete the set 'test'
% nft delete set inet test test

# load again the sample ruleset
% nft -f ruleset.nft
ruleset.nft:2:1-2: Error: Could not process rule: Set 'test' does not exist
table inet test {
^^


I've invested about an hour trying to figure out by myself where the
problem is, but cannot spend more time by now.

find attached the ruleset.nft file.

best regards.
--=20
Arturo Borrero Gonz=C3=A1lez

--001a11468750cb00a20525fcea16
Content-Type: application/octet-stream; name="ruleset.nft"
Content-Disposition: attachment; filename="ruleset.nft"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ihq6bjsu0

dGFibGUgaW5ldCB0ZXN0IHsKCXNldCB0ZXN0IHsKCQl0eXBlIGlwdjRfYWRkcgoJCWVsZW1lbnRz
ID0geyAxLjEuMS4xfQoJfQoKCWNoYWluIHRlc3QgewoJCWlwIHNhZGRyIEB0ZXN0IGNvdW50ZXIg
cGFja2V0cyAwIGJ5dGVzIDAgYWNjZXB0CgkJaXAgZGFkZHIgeyAyLjIuMi4yfSBjb3VudGVyIHBh
Y2tldHMgMCBieXRlcyAwIGFjY2VwdAoJfQp9CgoK
--001a11468750cb00a20525fcea16--
