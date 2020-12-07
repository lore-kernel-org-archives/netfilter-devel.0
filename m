Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2D33C4167B
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Dec 2020 14:56:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B58B223609
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Dec 2020 14:56:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgLGOzv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Dec 2020 09:55:51 -0500
Received: from smtp-out.kfki.hu ([148.6.0.45]:44695 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725931AbgLGOzv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Dec 2020 09:55:51 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id 3ADB067400CB;
        Mon,  7 Dec 2020 15:54:47 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Mon,  7 Dec 2020 15:54:43 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
        by smtp0.kfki.hu (Postfix) with ESMTP id 3E4C56740131;
        Mon,  7 Dec 2020 15:54:42 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 56F6A340D5C; Mon,  7 Dec 2020 15:54:42 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id 52376340D5B;
        Mon,  7 Dec 2020 15:54:42 +0100 (CET)
Date:   Mon, 7 Dec 2020 15:54:42 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
X-X-Sender: kadlec@blackhole.kfki.hu
To:     Ed W <lists@wildgooses.com>
cc:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [ANNOUNCE] ipset 7.8 released
In-Reply-To: <c4778467-3abe-b40f-c4f7-945576fa097f@wildgooses.com>
Message-ID: <alpine.DEB.2.23.453.2012071419590.30865@blackhole.kfki.hu>
References: <alpine.DEB.2.23.453.2011192141150.19567@blackhole.kfki.hu> <c4778467-3abe-b40f-c4f7-945576fa097f@wildgooses.com>
User-Agent: Alpine 2.23 (DEB 453 2020-06-18)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="110363376-800897950-1607347615=:30865"
Content-ID: <alpine.DEB.2.23.453.2012071553000.30865@blackhole.kfki.hu>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110363376-800897950-1607347615=:30865
Content-Type: text/plain; charset=UTF-8
Content-ID: <alpine.DEB.2.23.453.2012071553001.30865@blackhole.kfki.hu>
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, 4 Dec 2020, Ed W wrote:

> Hi, I'm having some difficulty compiling ipset 7.9 in kernel 4.14.78 as=
=20
> provided by Variscite for an arm board
> =20
> I've trimmed the build log and errors, but it seems to revolve around:
>=20
> Pre kernel 4.18 the header
>=20
> =C2=A0=C2=A0=C2=A0 ./include/linux/ipc.h
>=20
> would include
>=20
> =C2=A0=C2=A0=C2=A0 ./include/linux/rhashtable.h
>=20
> (later it includes rhashtable-types.h)
>=20
> This in turn draws in the jhash.c copy, which in turn includes=20
> ip_set_compat.h, which then causes some errors due to drawing in things=
=20
> where we haven't yet finished reading all the header files
>=20
> I'm not sure how to work around the compile fail in ipset-7.9? I agree =
I=20
> can't rule it out to be a problem due to the vendor kernel, but the=20
> include tree seems to point clearly to the issue above in ipc.h=20
>=20
>=20
> Note: ipset7.7 gives me errors about =C2=A0=C2=A0=C2=A0
>=20
> =C2=A0=C2=A0=C2=A0 error: 'fallthrough' undeclared
>=20
> Which seems fair enough given the age of my kernel. I could probably fi=
x this

That is fixed in 7.9.

> ipset 7.6 compiles ok for me.
> =20
> Any guidance please?

Please give a try to the next patch on top of ipset 7.9: it separates the=
=20
compiler compatibility stuff from the kernel compatibility part and that=20
helps to resolve the include file issue.

diff --git a/.gitignore b/.gitignore
index 46a78dd..0e8a087 100644
--- a/.gitignore
+++ b/.gitignore
@@ -20,6 +20,7 @@ Makefile.in
 Module.symvers
 modules.order
 kernel/include/linux/netfilter/ipset/ip_set_compat.h
+kernel/include/linux/netfilter/ipset/ip_set_compiler.h
=20
 /aclocal.m4
 /autom4te.cache/
diff --git a/configure.ac b/configure.ac
index 1086de3..2f06590 100644
--- a/configure.ac
+++ b/configure.ac
@@ -851,7 +851,8 @@ dnl Checks for library functions.
 dnl Generate output
 AC_CONFIG_FILES([Makefile include/libipset/Makefile
 	lib/Makefile lib/libipset.pc src/Makefile utils/Makefile
-	kernel/include/linux/netfilter/ipset/ip_set_compat.h])
+	kernel/include/linux/netfilter/ipset/ip_set_compat.h
+	kernel/include/linux/netfilter/ipset/ip_set_compiler.h])
 AC_OUTPUT
=20
 dnl Summary
diff --git a/kernel/include/linux/jhash.h b/kernel/include/linux/jhash.h
index 8df77ec..d144e33 100644
--- a/kernel/include/linux/jhash.h
+++ b/kernel/include/linux/jhash.h
@@ -1,6 +1,6 @@
 #ifndef _LINUX_JHASH_H
 #define _LINUX_JHASH_H
-#include <linux/netfilter/ipset/ip_set_compat.h>
+#include <linux/netfilter/ipset/ip_set_compiler.h>
=20
 /* jhash.h: Jenkins hash support.
  *
diff --git a/kernel/include/linux/netfilter/ipset/ip_set_compat.h.in b/ke=
rnel/include/linux/netfilter/ipset/ip_set_compat.h.in
index 8f00e6a..bf99bc0 100644
--- a/kernel/include/linux/netfilter/ipset/ip_set_compat.h.in
+++ b/kernel/include/linux/netfilter/ipset/ip_set_compat.h.in
@@ -519,18 +519,5 @@ static inline void *kvzalloc(size_t size, gfp_t flag=
s)
 	return members;
 }
 #endif
-
-/* Compiler attributes */
-#ifndef __has_attribute
-# define __has_attribute(x) __GCC4_has_attribute_##x
-# define __GCC4_has_attribute___fallthrough__		0
-#endif
-
-#if __has_attribute(__fallthrough__)
-# define fallthrough			__attribute__((__fallthrough__))
-#else
-# define fallthrough			do {} while (0)  /* fallthrough */
-#endif
-
 #endif /* IP_SET_COMPAT_HEADERS */
 #endif /* __IP_SET_COMPAT_H */
diff --git a/kernel/include/linux/netfilter/ipset/ip_set_compiler.h.in b/=
kernel/include/linux/netfilter/ipset/ip_set_compiler.h.in
new file mode 100644
index 0000000..1b392f8
--- /dev/null
+++ b/kernel/include/linux/netfilter/ipset/ip_set_compiler.h.in
@@ -0,0 +1,15 @@
+#ifndef __IP_SET_COMPILER_H
+#define __IP_SET_COMPILER_H
+
+/* Compiler attributes */
+#ifndef __has_attribute
+# define __has_attribute(x) __GCC4_has_attribute_##x
+# define __GCC4_has_attribute___fallthrough__		0
+#endif
+
+#if __has_attribute(__fallthrough__)
+# define fallthrough			__attribute__((__fallthrough__))
+#else
+# define fallthrough			do {} while (0)  /* fallthrough */
+#endif
+#endif /* __IP_SET_COMPILER_H */
diff --git a/kernel/net/netfilter/ipset/ip_set_core.c b/kernel/net/netfil=
ter/ipset/ip_set_core.c
index dcbc400..85961fc 100644
--- a/kernel/net/netfilter/ipset/ip_set_core.c
+++ b/kernel/net/netfilter/ipset/ip_set_core.c
@@ -21,6 +21,7 @@
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/ipset/ip_set.h>
+#include <linux/netfilter/ipset/ip_set_compiler.h>
=20
 static LIST_HEAD(ip_set_type_list);		/* all registered set types */
 static DEFINE_MUTEX(ip_set_type_mutex);		/* protects ip_set_type_list */

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110363376-800897950-1607347615=:30865--
