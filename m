From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH] libnftnl: Add to .gitignore all auto-generated files when a "make check" is done
Date: Mon, 16 May 2016 14:39:01 +0200
Message-ID: <1463402341-13221-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:60289 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951AbcEPMjQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 May 2016 08:39:16 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It ignores files inside "test/" and "examples/" except all c code (*.c)=
 and the
"Makefile.am"

Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 .gitignore | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/.gitignore b/.gitignore
index 5fada45..0d11936 100644
--- a/.gitignore
+++ b/.gitignore
@@ -22,3 +22,11 @@ doxygen.cfg
=20
 # Debian package build temporary files
 build-stamp
+
+# test and examples
+examples/
+!examples/*.c
+!examples/Makefile.am
+tests/
+!tests/*.c
+!tests/Makefile.am
--=20
2.8.0

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
