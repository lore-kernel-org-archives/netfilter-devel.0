From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6/7] remove unused header files in nfnetlink.c
Date: Mon, 12 Feb 2007 23:46:41 +0100
Message-ID: <45D0EE51.7020302@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060103020800040909020202"
Cc: Patrick McHardy <kaber@trash.net>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------060103020800040909020202
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------060103020800040909020202
Content-Type: text/plain;
 name="08.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="08.patch"

[PATCH] remove unused header files in nfnetlink.c

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6.git/net/netfilter/nfnetlink.c
===================================================================
--- net-2.6.git.orig/net/netfilter/nfnetlink.c	2006-12-26 04:38:20.000000000 +0100
+++ net-2.6.git/net/netfilter/nfnetlink.c	2006-12-26 04:42:46.000000000 +0100
@@ -30,9 +30,7 @@
 #include <asm/system.h>
 #include <net/sock.h>
 #include <linux/init.h>
-#include <linux/spinlock.h>
 
-#include <linux/netfilter.h>
 #include <linux/netlink.h>
 #include <linux/netfilter/nfnetlink.h>
 

--------------060103020800040909020202--
