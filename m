From: =?UTF-8?Q?Magnus_=c3=96berg?= <magnus.oberg@westermo.se>
Subject: [PATCH] nft: include/mini-gmp.h is not included at "make dist"
Date: Thu, 17 Mar 2016 11:07:04 +0100
Message-ID: <56EA81C8.1080408@westermo.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1.elc.beijer.se ([195.67.87.135]:1120 "EHLO
	mail1.elc.beijer.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935612AbcCQKXa convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Mar 2016 06:23:30 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Added missing dist. file mini-gmp.h in include/Makefile.am

Signed-off-by: Magnus =C3=96berg <magnus.oberg@westermo.se>
---
  include/Makefile.am | 1 +
  1 file changed, 1 insertion(+)

diff --git a/include/Makefile.am b/include/Makefile.am
index 465d804..58c58cb 100644
--- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -3,6 +3,7 @@ SUBDIRS =3D linux
  noinst_HEADERS =3D 	cli.h		\
  			datatype.h	\
  			expression.h	\
+			mini-gmp.h	\
  			gmputil.h	\
  			iface.h		\
  			mnl.h		\
--=20
2.5.0

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
