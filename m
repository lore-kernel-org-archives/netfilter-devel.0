From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/07]: Copyright/Email update
Date: Fri,  2 Nov 2007 12:23:13 +0100 (MET)
Message-ID: <20071102112003.22803.18148.sendpatchset@localhost.localdomain>
References: <20071102112000.22803.92699.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45734 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbXKBLXO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Nov 2007 07:23:14 -0400
In-Reply-To: <20071102112000.22803.92699.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: Copyright/Email update

Transfer all my copyright over to our company.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 94b462899348cbd662b8d0864c55a30a4700d52d
tree 2e90518d47f77c6b4b8b3f2b54f7cd54cde0bdfd
parent 9cfc1fadc1b0b5963fa8bef95f3653b8b2fb72b7
author Jan Engelhardt <jengelh@computergmbh.de> Fri, 02 Nov 2007 11:58:=
56 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 02 Nov 2007 11:58:56 +=
0100

 net/netfilter/xt_connlimit.c |    5 +++--
 net/netfilter/xt_time.c      |    3 ++-
 net/netfilter/xt_u32.c       |    5 +++--
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.=
c
index 06cff1d..d7becf0 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -4,7 +4,8 @@
  *   (c) 2000 Gerd Knorr <kraxel@bytesex.org>
  *   Nov 2002: Martin Bene <martin.bene@icomedias.com>:
  *		only ignore TIME_WAIT or gone connections
- *   Copyright =C2=A9 Jan Engelhardt <jengelh@gmx.de>, 2007
+ *   (C) CC Computer Consultants GmbH, 2007
+ *   Contact: <jengelh@computergmbh.de>
  *
  * based on ...
  *
@@ -306,7 +307,7 @@ static void __exit xt_connlimit_exit(void)
=20
 module_init(xt_connlimit_init);
 module_exit(xt_connlimit_exit);
-MODULE_AUTHOR("Jan Engelhardt <jengelh@gmx.de>");
+MODULE_AUTHOR("Jan Engelhardt <jengelh@computergmbh.de>");
 MODULE_DESCRIPTION("netfilter xt_connlimit match module");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_connlimit");
diff --git a/net/netfilter/xt_time.c b/net/netfilter/xt_time.c
index ef48bbd..ff44f86 100644
--- a/net/netfilter/xt_time.c
+++ b/net/netfilter/xt_time.c
@@ -1,6 +1,7 @@
 /*
  *	xt_time
- *	Copyright =C2=A9 Jan Engelhardt <jengelh@computergmbh.de>, 2007
+ *	Copyright =C2=A9 CC Computer Consultants GmbH, 2007
+ *	Contact: <jengelh@computergmbh.de>
  *
  *	based on ipt_time by Fabrice MARIE <fabrice@netfilter.org>
  *	This is a module which is used for time matching
diff --git a/net/netfilter/xt_u32.c b/net/netfilter/xt_u32.c
index bec4279..af75b8c 100644
--- a/net/netfilter/xt_u32.c
+++ b/net/netfilter/xt_u32.c
@@ -2,7 +2,8 @@
  *	xt_u32 - kernel module to match u32 packet content
  *
  *	Original author: Don Cohen <don@isis.cs3-inc.com>
- *	=C2=A9 Jan Engelhardt <jengelh@gmx.de>, 2007
+ *	(C) CC Computer Consultants GmbH, 2007
+ *	Contact: <jengelh@computergmbh.de>
  */
=20
 #include <linux/module.h>
@@ -129,7 +130,7 @@ static void __exit xt_u32_exit(void)
=20
 module_init(xt_u32_init);
 module_exit(xt_u32_exit);
-MODULE_AUTHOR("Jan Engelhardt <jengelh@gmx.de>");
+MODULE_AUTHOR("Jan Engelhardt <jengelh@computergmbh.de>");
 MODULE_DESCRIPTION("netfilter u32 match module");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_u32");
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
