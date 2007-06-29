From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 18/20]: ipt_SAME: add to feature-removal-schedule
Date: Fri, 29 Jun 2007 02:45:21 +0200 (MEST)
Message-ID: <20070629004419.25566.91149.sendpatchset@localhost.localdomain>
References: <20070629004354.25566.59266.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070629004354.25566.59266.sendpatchset@localhost.localdomain>
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
commit 9e2478bf5637fa674b2e902e6c220a4ddf787be2
tree 3bc9d9fe8083fdb80af4943a09e47f433d189a75
parent 7a171312164be3cc200fbc04c8c93c32dc4f0649
author Patrick McHardy <kaber@trash.net> Fri, 29 Jun 2007 02:19:58 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 29 Jun 2007 02:19:58 +0200

 Documentation/feature-removal-schedule.txt |    8 ++++++++
 net/ipv4/netfilter/Kconfig                 |    2 +-
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 7d3f205..e643a70 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -348,3 +348,11 @@ Who:  Tejun Heo <htejun@gmail.com>
 
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
