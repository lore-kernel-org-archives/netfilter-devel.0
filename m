From: Jan Engelhardt <jengelh@medozas.de>
Subject: [4/5] netfilter: xtables: case-sensitivity avoidance (4/5)
Date: Tue, 18 Jan 2011 16:40:11 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1101181640000.15657@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1101181628540.15366@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38348 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753Ab1ARPkN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Jan 2011 10:40:13 -0500
In-Reply-To: <alpine.LNX.2.01.1101181628540.15366@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

parent 497bdc4ad9f727d41df3e2e4868cb692b701116f (v2.6.37-3811-g497bdc4)
commit 94b1a89f0d094d5467a7437af9d86b303943eb8c
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Tue Jan 18 08:51:05 2011 +0100

netfilter: xtables: case-sensitivity avoidance (4/5)

Provide obligatory courtesy forward header for
include/linux/netfilter_ipv[46]/ for some time.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Documentation/feature-removal-schedule.txt   |    3 +++
 include/linux/netfilter_ipv4/Kbuild          |    3 +++
 include/linux/netfilter_ipv4/ipt_CLUSTERIP.h |    1 +
 include/linux/netfilter_ipv4/ipt_ECN.h       |    1 +
 include/linux/netfilter_ipv4/ipt_LOG.h       |    1 +
 include/linux/netfilter_ipv4/ipt_REJECT.h    |    1 +
 include/linux/netfilter_ipv4/ipt_SAME.h      |    1 +
 include/linux/netfilter_ipv4/ipt_TTL.h       |    1 +
 include/linux/netfilter_ipv4/ipt_ULOG.h      |    1 +
 include/linux/netfilter_ipv4/ipt_ecn.h       |    1 +
 include/linux/netfilter_ipv4/ipt_ttl.h       |    1 +
 include/linux/netfilter_ipv6/Kbuild          |    2 ++
 include/linux/netfilter_ipv6/ip6t_HL.h       |    1 +
 include/linux/netfilter_ipv6/ip6t_LOG.h      |    1 +
 include/linux/netfilter_ipv6/ip6t_REJECT.h   |    1 +
 include/linux/netfilter_ipv6/ip6t_hl.h       |    1 +
 16 files changed, 21 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/netfilter_ipv4/ipt_CLUSTERIP.h
 create mode 100644 include/linux/netfilter_ipv4/ipt_ECN.h
 create mode 100644 include/linux/netfilter_ipv4/ipt_LOG.h
 create mode 100644 include/linux/netfilter_ipv4/ipt_REJECT.h
 create mode 100644 include/linux/netfilter_ipv4/ipt_SAME.h
 create mode 100644 include/linux/netfilter_ipv4/ipt_TTL.h
 create mode 100644 include/linux/netfilter_ipv4/ipt_ULOG.h
 create mode 100644 include/linux/netfilter_ipv4/ipt_ecn.h
 create mode 100644 include/linux/netfilter_ipv4/ipt_ttl.h
 create mode 100644 include/linux/netfilter_ipv6/ip6t_HL.h
 create mode 100644 include/linux/netfilter_ipv6/ip6t_LOG.h
 create mode 100644 include/linux/netfilter_ipv6/ip6t_REJECT.h
 create mode 100644 include/linux/netfilter_ipv6/ip6t_hl.h

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 9de337e..c90ca01 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -583,3 +583,6 @@ Who:	Jan Engelhardt <jengelh@medozas.de>
 Files:	include/linux/netfilter/xt_{AUDIT,CHECKSUM,CLASSIFY,
 	CONNSECMARK,CT,DSCP,IDLETIMER,LED,NFLOG,NFQUEUE,RATEEST,
 	SECMARK,TCPMSS,TCPOPTSTRIP,TEE,TPROXY}.h
+	include/linux/netfilter_ipv6/ip6t_{HL,LOG,REJECT,hl}.h
+	include/linux/netfilter_ipv4/ipt_{CLUSTERIP,ECN,LOG,REJECT,
+	SAME,TTL,ULOG,ecn,ttl}.h
diff --git a/include/linux/netfilter_ipv4/Kbuild b/include/linux/netfilter_ipv4/Kbuild
index e2c887e..97fd48c 100644
--- a/include/linux/netfilter_ipv4/Kbuild
+++ b/include/linux/netfilter_ipv4/Kbuild
@@ -3,3 +3,6 @@ header-y += ip_tables.h
 header-y += ipt_addrtype.h
 header-y += ipt_ah.h
 header-y += ipt_realm.h
+# old files
+header-y += ipt_CLUSTERIP.h ipt_ECN.h ipt_LOG.h ipt_REJECT.h ipt_SAME.h
+header-y += ipt_TTL.h ipt_ULOG.h ipt_ecn.h ipt_ttl.h
diff --git a/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h b/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h
new file mode 100644
index 0000000..8bebe1f
--- /dev/null
+++ b/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h
@@ -0,0 +1 @@
+#include <linux/netfilter/xt_clusterip.h>
diff --git a/include/linux/netfilter_ipv4/ipt_ECN.h b/include/linux/netfilter_ipv4/ipt_ECN.h
new file mode 100644
index 0000000..651c4fa
--- /dev/null
+++ b/include/linux/netfilter_ipv4/ipt_ECN.h
@@ -0,0 +1 @@
+#include <linux/netfilter/xt_ecn.h>
diff --git a/include/linux/netfilter_ipv4/ipt_LOG.h b/include/linux/netfilter_ipv4/ipt_LOG.h
new file mode 100644
index 0000000..a3c3baa
--- /dev/null
+++ b/include/linux/netfilter_ipv4/ipt_LOG.h
@@ -0,0 +1 @@
+#include <linux/netfilter/xt_log.h>
diff --git a/include/linux/netfilter_ipv4/ipt_REJECT.h b/include/linux/netfilter_ipv4/ipt_REJECT.h
new file mode 100644
index 0000000..9698dee
--- /dev/null
+++ b/include/linux/netfilter_ipv4/ipt_REJECT.h
@@ -0,0 +1 @@
+#include <linux/netfilter/xt_reject.h>
diff --git a/include/linux/netfilter_ipv4/ipt_SAME.h b/include/linux/netfilter_ipv4/ipt_SAME.h
new file mode 100644
index 0000000..9b5beb7
--- /dev/null
+++ b/include/linux/netfilter_ipv4/ipt_SAME.h
@@ -0,0 +1 @@
+#include <linux/netfilter/xt_same.h>
diff --git a/include/linux/netfilter_ipv4/ipt_TTL.h b/include/linux/netfilter_ipv4/ipt_TTL.h
new file mode 100644
index 0000000..b0af8e3
--- /dev/null
+++ b/include/linux/netfilter_ipv4/ipt_TTL.h
@@ -0,0 +1 @@
+#include <linux/netfilter/xt_hl.h>
diff --git a/include/linux/netfilter_ipv4/ipt_ULOG.h b/include/linux/netfilter_ipv4/ipt_ULOG.h
new file mode 100644
index 0000000..0caec20
--- /dev/null
+++ b/include/linux/netfilter_ipv4/ipt_ULOG.h
@@ -0,0 +1 @@
+#include <linux/netfilter/xt_ulog.h>
diff --git a/include/linux/netfilter_ipv4/ipt_ecn.h b/include/linux/netfilter_ipv4/ipt_ecn.h
new file mode 100644
index 0000000..651c4fa
--- /dev/null
+++ b/include/linux/netfilter_ipv4/ipt_ecn.h
@@ -0,0 +1 @@
+#include <linux/netfilter/xt_ecn.h>
diff --git a/include/linux/netfilter_ipv4/ipt_ttl.h b/include/linux/netfilter_ipv4/ipt_ttl.h
new file mode 100644
index 0000000..b0af8e3
--- /dev/null
+++ b/include/linux/netfilter_ipv4/ipt_ttl.h
@@ -0,0 +1 @@
+#include <linux/netfilter/xt_hl.h>
diff --git a/include/linux/netfilter_ipv6/Kbuild b/include/linux/netfilter_ipv6/Kbuild
index 38ba2f6..0bdfdfd 100644
--- a/include/linux/netfilter_ipv6/Kbuild
+++ b/include/linux/netfilter_ipv6/Kbuild
@@ -5,3 +5,5 @@ header-y += ip6t_ipv6header.h
 header-y += ip6t_mh.h
 header-y += ip6t_opts.h
 header-y += ip6t_rt.h
+# old files
+header-y += ip6t_HL.h ip6t_LOG.h ip6t_REJECT.h ip6t_hl.h
diff --git a/include/linux/netfilter_ipv6/ip6t_HL.h b/include/linux/netfilter_ipv6/ip6t_HL.h
new file mode 100644
index 0000000..b0af8e3
--- /dev/null
+++ b/include/linux/netfilter_ipv6/ip6t_HL.h
@@ -0,0 +1 @@
+#include <linux/netfilter/xt_hl.h>
diff --git a/include/linux/netfilter_ipv6/ip6t_LOG.h b/include/linux/netfilter_ipv6/ip6t_LOG.h
new file mode 100644
index 0000000..a3c3baa
--- /dev/null
+++ b/include/linux/netfilter_ipv6/ip6t_LOG.h
@@ -0,0 +1 @@
+#include <linux/netfilter/xt_log.h>
diff --git a/include/linux/netfilter_ipv6/ip6t_REJECT.h b/include/linux/netfilter_ipv6/ip6t_REJECT.h
new file mode 100644
index 0000000..9698dee
--- /dev/null
+++ b/include/linux/netfilter_ipv6/ip6t_REJECT.h
@@ -0,0 +1 @@
+#include <linux/netfilter/xt_reject.h>
diff --git a/include/linux/netfilter_ipv6/ip6t_hl.h b/include/linux/netfilter_ipv6/ip6t_hl.h
new file mode 100644
index 0000000..b0af8e3
--- /dev/null
+++ b/include/linux/netfilter_ipv6/ip6t_hl.h
@@ -0,0 +1 @@
+#include <linux/netfilter/xt_hl.h>
-- 
# Created with git-export-patch
