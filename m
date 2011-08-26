From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/5] libxt_TOS: update linux kernel version list for backported fix
Date: Fri, 26 Aug 2011 15:15:15 +0200
Message-ID: <1314364516-7875-6-git-send-email-jengelh@medozas.de>
References: <1314364516-7875-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:41495 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754495Ab1HZNSA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Aug 2011 09:18:00 -0400
In-Reply-To: <1314364516-7875-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Fernando Luis V=C3=A1zquez Cao <fernando@oss.ntt.co.jp>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_TOS.man |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/extensions/libxt_TOS.man b/extensions/libxt_TOS.man
index f989674..58118ec 100644
--- a/extensions/libxt_TOS.man
+++ b/extensions/libxt_TOS.man
@@ -28,9 +28,9 @@ Binary XOR the TOS value with \fIbits\fP. (Mnemonic f=
or \fB\-\-set\-tos\fP
 \fIbits\fP\fB/0\fP. See NOTE below.)
 .PP
 NOTE: In Linux kernels up to and including 2.6.38, with the exception =
of
-longterm releases 2.6.32.42 (or later) and 2.6.33.15 (or later), there=
 is a bug
-whereby IPv6 TOS mangling does not behave as documented and differs fr=
om the
-IPv4 version. The TOS mask indicates the bits one wants to zero out, s=
o it needs
-to be inverted before applying it to the original TOS field. However, =
the
+longterm releases 2.6.32 (>=3D.42), 2.6.33 (>=3D.15), and 2.6.35 (>=3D=
=2E14), there is
+a bug whereby IPv6 TOS mangling does not behave as documented and diff=
ers from
+the IPv4 version. The TOS mask indicates the bits one wants to zero ou=
t, so it
+needs to be inverted before applying it to the original TOS field. How=
ever, the
 aformentioned kernels forgo the inversion which breaks --set-tos and i=
ts
 mnemonics.
--=20
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
