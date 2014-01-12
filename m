From: Ivan Homoliak <xhomol11@gmail.com>
Subject: Fwd: Bug 883 - Uninitialized values in libnetfilter_log.c
Date: Sun, 12 Jan 2014 10:14:38 +0100
Message-ID: <CA+J3vcL9Shwc1cFDPPMPmcn81niNfELxqf-XtEAqTO8Bij--mQ@mail.gmail.com>
References: <CA+J3vcL=6i2DfpGcGpPw6WSrw7tdWn=5Y8e8q6KObDe8t_kAOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=047d7b2e0f5d8306c904efc2639c
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:44348 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaALJOj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Jan 2014 04:14:39 -0500
Received: by mail-pb0-f47.google.com with SMTP id um1so6160457pbc.20
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Jan 2014 01:14:39 -0800 (PST)
In-Reply-To: <CA+J3vcL=6i2DfpGcGpPw6WSrw7tdWn=5Y8e8q6KObDe8t_kAOA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--047d7b2e0f5d8306c904efc2639c
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

I think I found few bugs in libnetfilter_log by valgrind and ulogd.
See the patch in attachment.

Version: libnetfilter_log-1.0.1
File: libnetfilter_log.c
GCC: 4.8.2 20131212 (Red Hat 4.8.2-7)
OS: Fedora release 19 (Schr=F6dinger=92s Cat)
Kernel: 3.12.5-200.fc19.x86_64

Regards,
Ivan Homoliak.

--047d7b2e0f5d8306c904efc2639c
Content-Type: application/octet-stream; name="libnetfilter_log-1.0.1.patch"
Content-Disposition: attachment; filename="libnetfilter_log-1.0.1.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hqapho310

MTM1YTEzNiwxMzcKPiAgICAgICAgIAo+ICAgICAgICAgbWVtc2V0KCZ1LCAwLCBzaXplb2YodSkp
Owo0NzJjNDc0LDQ3NQo8IAotLS0KPiAgICAgICAgIG1lbXNldCgmdSwgMCwgc2l6ZW9mKHUpKTsK
PiAgICAgICAgIAo0NzdhNDgxCj4gICAgICAgICBwYXJhbXMuX3BhZCA9ICh1X2ludDhfdCkgMDsK
NTAyYTUwNyw1MDgKPiAgICAgICAgIG1lbXNldCgmdSwgMCwgc2l6ZW9mKHUpKTsKPiAgICAgICAg
IAo1MjdhNTM0LDUzNQo+ICAgICAgICAgbWVtc2V0KCZ1LCAwLCBzaXplb2YodSkpOwo+ICAgICAg
ICAgCjU1NmM1NjQKPCAJaW50IHN0YXR1czsKLS0tCj4gCWludCBzdGF0dXMgPSAwOyAvL2lob21v
bGlhawo1NTdhNTY2LDU2Nwo+ICAgICAgICAgbWVtc2V0KCZ1LCAwLCBzaXplb2YodSkpOwo+ICAg
ICAgICAgCjU5MGE2MDEsNjAyCj4gICAgICAgICBtZW1zZXQoJnUsIDAsIHNpemVvZih1KSk7Cj4g
CQo=
--047d7b2e0f5d8306c904efc2639c--
