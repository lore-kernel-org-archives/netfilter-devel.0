From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Subject: xtables-addons 1.38: libipset uses symbol that's not in library
Date: Fri, 26 Aug 2011 13:25:09 +0200
Message-ID: <201108261325.09143.a.miskiewicz@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36697 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab1HZLZN convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Aug 2011 07:25:13 -0400
Received: by fxh19 with SMTP id 19so2459607fxh.19
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Aug 2011 04:25:12 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Unresolved symbols found in: /home/users/arekm/tmp/xtables-addons-1.38-=
root-
arekm/usr/lib64/libipset.so.1.0.0
        ipset_errcode

so

--- xtables-addons-1.38/extensions/ipset-6/Makefile.am~	2011-08-20=20
17:02:31.000000000 +0200
+++ xtables-addons-1.38/extensions/ipset-6/Makefile.am	2011-08-26=20
13:15:36.983190997 +0200
@@ -8,12 +8,12 @@
 lib_LTLIBRARIES =3D libipset.la
 libipset_la_SOURCES =3D libipset/data.c libipset/icmp.c libipset/icmpv=
6.c \
                       libipset/mnl.c libipset/parse.c libipset/print.c=
 \
-                      libipset/session.c libipset/types.c
+                      libipset/session.c libipset/types.c src/errcode.=
c
 libipset_la_LIBADD  =3D ${libmnl_LIBS}
 libipset_la_LDFLAGS =3D -version-info 1:0:0
=20
 sbin_PROGRAMS =3D ipset
-ipset_SOURCES =3D src/ipset.c src/errcode.c src/ui.c src/ipset_bitmap_=
ip.c \
+ipset_SOURCES =3D src/ipset.c src/ui.c src/ipset_bitmap_ip.c \
                 src/ipset_bitmap_ipmac.c src/ipset_bitmap_port.c \
                 src/ipset_hash_ip.c src/ipset_hash_ipport.c \
                 src/ipset_hash_ipportip.c src/ipset_hash_ipportnet.c \


--=20
Arkadiusz Mi=C5=9Bkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/

--=20
Arkadiusz Mi=C5=9Bkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
