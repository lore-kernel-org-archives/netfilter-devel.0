From: "Albert Veli" <albert.veli@gmail.com>
Subject: libnetfilter_conntrack endian issue
Date: Tue, 29 Jul 2008 12:24:41 +0200
Message-ID: <4e0fd89b0807290324v6f771a79q80dcafc6b03dae54@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_25483_25817133.1217327081746"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:22579 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629AbYG2KYm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jul 2008 06:24:42 -0400
Received: by wf-out-1314.google.com with SMTP id 27so6321862wfd.4
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Jul 2008 03:24:41 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

------=_Part_25483_25817133.1217327081746
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi!

I run contrack-tools on a big-endian arm machine and had a problem:

$ conntrack -L
conntrack v0.9.7: Operation failed: Address family not supported by protocol

The problem was in libnetfilter_conntrack-0.0.96/src/conntrack/api.c.
See attached endian.patch. In nfct_build_query() the *data argument is
converted into a u_int8_t*. This works for little-endian but not for
big-endian. The fix is a one-liner. Replace

 const u_int8_t *family = data;

with

 const u_int32_t *family = data;

After the patch it works:

$ conntrack -L
conntrack v0.9.7: 0 flow entries has been shown.

I also tested the patch on my little-endian laptop and it doesn't seem
to cause any regression there. Just wanted to let you guys know.


Best regards,

Albert

------=_Part_25483_25817133.1217327081746
Content-Type: text/x-diff; name=endian.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fj8cwkf10
Content-Disposition: attachment; filename=endian.patch

ZGlmZiAtdXJOIGxpYm5ldGZpbHRlcl9jb25udHJhY2stMC4wLjk2LW9yZy9zcmMvY29ubnRyYWNr
L2FwaS5jIGxpYm5ldGZpbHRlcl9jb25udHJhY2stMC4wLjk2L3NyYy9jb25udHJhY2svYXBpLmMK
LS0tIGxpYm5ldGZpbHRlcl9jb25udHJhY2stMC4wLjk2LW9yZy9zcmMvY29ubnRyYWNrL2FwaS5j
CTIwMDgtMDctMDIgMTU6MjU6MzguMDAwMDAwMDAwICswMjAwCisrKyBsaWJuZXRmaWx0ZXJfY29u
bnRyYWNrLTAuMC45Ni9zcmMvY29ubnRyYWNrL2FwaS5jCTIwMDgtMDctMjkgMTE6NDI6NDMuMDAw
MDAwMDAwICswMjAwCkBAIC00NTUsNyArNDU1LDcgQEAKIAkJICAgICB1bnNpZ25lZCBpbnQgc2l6
ZSkKIHsKIAlzdHJ1Y3QgbmZubGhkciAqcmVxID0gYnVmZmVyOwotCWNvbnN0IHVfaW50OF90ICpm
YW1pbHkgPSBkYXRhOworCWNvbnN0IHVfaW50MzJfdCAqZmFtaWx5ID0gZGF0YTsKIAogCWFzc2Vy
dChzc2ggIT0gTlVMTCk7CiAJYXNzZXJ0KGRhdGEgIT0gTlVMTCk7Cg==
------=_Part_25483_25817133.1217327081746--
