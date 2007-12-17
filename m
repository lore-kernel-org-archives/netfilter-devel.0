From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 2/7] Introduce nf_inet_address
Date: Mon, 17 Dec 2007 13:51:35 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712171344040.32270@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0712070335240.1262@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0712070336010.1262@fbirervta.pbzchgretzou.qr>
 <475E639A.9040501@trash.net> <Pine.LNX.4.64.0712151300360.22877@fbirervta.pbzchgretzou.qr>
 <47666B52.1050802@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50245 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbXLQMvh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 07:51:37 -0500
In-Reply-To: <47666B52.1050802@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Dec 17 2007 13:28, Patrick McHardy wrote:
>
> Userspace has to deal with these types, they're already used
> in many other structures. I've already added the necessary
> defines or typedefs to the iptables headers some time ago.

Yeah, but these defines were missing from libiptc, so I copied
them there (see patch).

> We should probably just include <linux/types.h> to fix it
> though. Could you give that a try?

It works, so please use this one:
===

Remove our own definitions of the Linux types and use <linux/types.h>
instead. libiptc needs it too, or otherwise will choke on union
nf_inet_addr.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 include/libiptc/libip6tc.h |    1 +
 include/libiptc/libiptc.h  |    1 +
 include/xtables.h          |    6 +-----
 3 files changed, 3 insertions(+), 5 deletions(-)

Index: iptables-modules/include/libiptc/libip6tc.h
===================================================================
--- iptables-modules.orig/include/libiptc/libip6tc.h
+++ iptables-modules/include/libiptc/libip6tc.h
@@ -2,6 +2,7 @@
 #define _LIBIP6TC_H
 /* Library which manipulates firewall rules. Version 0.2. */
 
+#include <linux/types.h>
 #include <libiptc/ipt_kernel_headers.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 
Index: iptables-modules/include/libiptc/libiptc.h
===================================================================
--- iptables-modules.orig/include/libiptc/libiptc.h
+++ iptables-modules/include/libiptc/libiptc.h
@@ -2,6 +2,7 @@
 #define _LIBIPTC_H
 /* Library which manipulates filtering rules. */
 
+#include <linux/types.h>
 #include <libiptc/ipt_kernel_headers.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 
Index: iptables-modules/include/xtables.h
===================================================================
--- iptables-modules.orig/include/xtables.h
+++ iptables-modules/include/xtables.h
@@ -2,6 +2,7 @@
 #define _XTABLES_H
 
 #include <sys/types.h>
+#include <linux/types.h>
 #include <linux/netfilter/x_tables.h>
 #include <libiptc/libxtc.h>
 
@@ -234,9 +235,4 @@ extern const char *program_name, *progra
   extern void init_extensions(void);
 #endif
 
-#define __be32	u_int32_t
-#define __le32	u_int32_t
-#define __be16	u_int16_t
-#define __le16	u_int16_t
-
 #endif /* _XTABLES_H */
