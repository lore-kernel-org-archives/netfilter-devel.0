From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH] libnftnl: gitignore: Fix mistake in gitignore regexp
Date: Tue, 17 May 2016 21:11:39 +0200
Message-ID: <1463512299-1105-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:36301 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbcEQTLv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 May 2016 15:11:51 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If a whole directory was ignored, files inside it will not be checked.

Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 .gitignore | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/.gitignore b/.gitignore
index 3d6ebf4..1650e58 100644
--- a/.gitignore
+++ b/.gitignore
@@ -23,9 +23,9 @@ doxygen.cfg
 # Debian package build temporary files
 build-stamp
=20
-examples/
+examples/*
 !examples/*.c
 !examples/Makefile.am
-tests/
+tests/*
 !tests/*.c
 !tests/Makefile.am
--=20
2.8.2

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
