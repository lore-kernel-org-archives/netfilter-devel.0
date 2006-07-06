From: "Eric Leblond" <eric@inl.fr>
Subject: [PATCH] libnfnetlink compilation on FC5
Date: Thu, 6 Jul 2006 11:09:35 +0200 (CEST)
Message-ID: <46066.193.48.8.196.1152176975.squirrel@mail.inl.fr>
Mime-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20060706110935_92828"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

------=_20060706110935_92828
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

Hi,

libnfnetlink compilation fails on Fedora Cora 5 which use gcc 4.1.

I attach to this mail a small patch that fixes this problem.

BR,
------=_20060706110935_92828
Content-Type: text/x-patch; name="libnfnetlink_FC5.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="libnfnetlink_FC5.patch"

Index: src/libnfnetlink.c
===================================================================
--- src/libnfnetlink.c	(révision 6640)
+++ src/libnfnetlink.c	(copie de travail)
@@ -37,6 +37,7 @@
 #include <sys/types.h>
 #include <sys/socket.h>
 
+#include <linux/types.h>
 #include <linux/netlink.h>
 
 #include <libnfnetlink/libnfnetlink.h>
------=_20060706110935_92828--
