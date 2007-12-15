From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 2/7] Introduce nf_inet_address
Date: Sat, 15 Dec 2007 17:21:30 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712151720530.22877@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0712070335240.1262@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0712070336010.1262@fbirervta.pbzchgretzou.qr>
 <475E639A.9040501@trash.net> <Pine.LNX.4.64.0712151300360.22877@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34756 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756754AbXLOQVc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 15 Dec 2007 11:21:32 -0500
In-Reply-To: <Pine.LNX.4.64.0712151300360.22877@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Dec 15 2007 13:06, Jan Engelhardt wrote:
>Userspace iptables does not seem to properly cope with it, though:
>
>In file included from /ws/linux-2.6/include/linux/netfilter_ipv4.h:8,
>                 from=20
>/ws/linux-2.6/include/linux/netfilter_ipv4/ip_tables.h:26,
>                 from include/libiptc/libiptc.h:6,
>                 from libiptc/libip4tc.c:29:
>/ws/linux-2.6/include/linux/netfilter.h:53: error: expected=20
>specifier-qualifier-list before =E2=80=98__be32=E2=80=99
>make: *** [libiptc/libip4tc.o] Error 1

=46ix for iptables:

=3D=3D=3D


Add __beXX types to libiptc.
Also add __be64/__le64 for completeness.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 include/libiptc/libip6tc.h |    8 ++++++++
 include/libiptc/libiptc.h  |    9 +++++++++
 include/xtables.h          |   12 ++++++++----
 3 files changed, 25 insertions(+), 4 deletions(-)

Index: iptables-modules/include/libiptc/libip6tc.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- iptables-modules.orig/include/libiptc/libip6tc.h
+++ iptables-modules/include/libiptc/libip6tc.h
@@ -2,6 +2,14 @@
 #define _LIBIP6TC_H
 /* Library which manipulates firewall rules. Version 0.2. */
=20
+#ifndef __be32
+#	define __be64	u_int64_t
+#	define __le64	u_int64_t
+#	define __be32	u_int32_t
+#	define __le32	u_int32_t
+#	define __be16	u_int16_t
+#	define __le16	u_int16_t
+#endif
 #include <libiptc/ipt_kernel_headers.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
=20
Index: iptables-modules/include/libiptc/libiptc.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- iptables-modules.orig/include/libiptc/libiptc.h
+++ iptables-modules/include/libiptc/libiptc.h
@@ -2,6 +2,15 @@
 #define _LIBIPTC_H
 /* Library which manipulates filtering rules. */
=20
+#ifndef __be32
+#	define __be64	u_int64_t
+#	define __le64	u_int64_t
+#	define __be32	u_int32_t
+#	define __le32	u_int32_t
+#	define __be16	u_int16_t
+#	define __le16	u_int16_t
+#endif
+
 #include <libiptc/ipt_kernel_headers.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
=20
Index: iptables-modules/include/xtables.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- iptables-modules.orig/include/xtables.h
+++ iptables-modules/include/xtables.h
@@ -234,9 +234,13 @@ extern const char *program_name, *progra
   extern void init_extensions(void);
 #endif
=20
-#define __be32	u_int32_t
-#define __le32	u_int32_t
-#define __be16	u_int16_t
-#define __le16	u_int16_t
+#ifndef __be32
+#	define __be64	u_int64_t
+#	define __le64	u_int64_t
+#	define __be32	u_int32_t
+#	define __le32	u_int32_t
+#	define __be16	u_int16_t
+#	define __le16	u_int16_t
+#endif
=20
 #endif /* _XTABLES_H */
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
