From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 43/50]: ipt_SAME: add to feature-removal-schedule
Date: Sat,  7 Jul 2007 14:24:01 +0200 (MEST)
Message-ID: <20070707122316.1589.80159.sendpatchset@localhost.localdomain>
References: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ipt_SAME: add to feature-removal-schedule

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 4d2355649d522d4ced604b5f1002d6a314ca5a30
tree d72fc9ad1fcb90d552f055cc3cd9939238e3d672
parent a145c8a34ab8aee235642d69b4fbc56846e92e63
author Patrick McHardy <kaber@trash.net> Sat, 07 Jul 2007 12:16:03 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 07 Jul 2007 12:16:03 +0200

 Documentation/feature-removal-schedule.txt |    8 ++++++++
 net/ipv4/netfilter/Kconfig                 |    2 +-
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 7acecad..c284edd 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -329,3 +329,11 @@ Who:  Tejun Heo <htejun@gmail.com>
 
 ---------------------------
 
+What:	iptables SAME target
+When:	1.1. 2008
+Files:	net/ipv4/netfilter/ipt_SAME.c, include/linux/netfilter_ipv4/ipt_SAME.h
+Why:	Obsolete for multiple years now, NAT core provides the same behaviour.
+	Unfixable broken wrt. 32/64 bit cleanness.
+Who:	Patrick McHardy <kaber@trash.net>
+
+---------------------------
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 46509fa..fa97947 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -230,7 +230,7 @@ config IP_NF_TARGET_NETMAP
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config IP_NF_TARGET_SAME
-	tristate "SAME target support"
+	tristate "SAME target support (OBSOLETE)"
 	depends on NF_NAT
 	help
 	  This option adds a `SAME' target, which works like the standard SNAT
