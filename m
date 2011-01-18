From: Jan Engelhardt <jengelh@medozas.de>
Subject: [2/5] netfilter: xtables: case-sensitivity avoidance (2/5)
Date: Tue, 18 Jan 2011 16:39:45 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1101181639370.15657@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1101181628540.15366@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Aaron Wright <wright_left@yahoo.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38338 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038Ab1ARPjq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Jan 2011 10:39:46 -0500
In-Reply-To: <alpine.LNX.2.01.1101181628540.15366@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

parent 10fc4644d17ccace699f2c62f9b15f8f024ddb4d (v2.6.37-3809-g10fc464)
commit b31552c3fd36bc862d8505f9f00f2ac7cc4dd8bf
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Tue Jan 18 08:03:37 2011 +0100

netfilter: xtables: case-sensitivity avoidance (2/5)

Provide obligatory courtesy forward header files for
include/linux/netfilter/ (for some time). These were not part of the
previous patch to simplify its diff.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Documentation/feature-removal-schedule.txt |    7 +++++++
 include/linux/netfilter/Kbuild             |    5 +++++
 include/linux/netfilter/xt_AUDIT.h         |    1 +
 include/linux/netfilter/xt_CHECKSUM.h      |    1 +
 include/linux/netfilter/xt_CLASSIFY.h      |    1 +
 include/linux/netfilter/xt_CONNSECMARK.h   |    1 +
 include/linux/netfilter/xt_CT.h            |    1 +
 include/linux/netfilter/xt_DSCP.h          |    1 +
 include/linux/netfilter/xt_IDLETIMER.h     |    1 +
 include/linux/netfilter/xt_LED.h           |    1 +
 include/linux/netfilter/xt_NFLOG.h         |    1 +
 include/linux/netfilter/xt_NFQUEUE.h       |    1 +
 include/linux/netfilter/xt_RATEEST.h       |    1 +
 include/linux/netfilter/xt_SECMARK.h       |    1 +
 include/linux/netfilter/xt_TCPMSS.h        |    1 +
 include/linux/netfilter/xt_TCPOPTSTRIP.h   |    1 +
 include/linux/netfilter/xt_TEE.h           |    1 +
 include/linux/netfilter/xt_TPROXY.h        |    1 +
 18 files changed, 28 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/netfilter/xt_AUDIT.h
 create mode 100644 include/linux/netfilter/xt_CHECKSUM.h
 create mode 100644 include/linux/netfilter/xt_CLASSIFY.h
 create mode 100644 include/linux/netfilter/xt_CONNSECMARK.h
 create mode 100644 include/linux/netfilter/xt_CT.h
 create mode 100644 include/linux/netfilter/xt_DSCP.h
 create mode 100644 include/linux/netfilter/xt_IDLETIMER.h
 create mode 100644 include/linux/netfilter/xt_LED.h
 create mode 100644 include/linux/netfilter/xt_NFLOG.h
 create mode 100644 include/linux/netfilter/xt_NFQUEUE.h
 create mode 100644 include/linux/netfilter/xt_RATEEST.h
 create mode 100644 include/linux/netfilter/xt_SECMARK.h
 create mode 100644 include/linux/netfilter/xt_TCPMSS.h
 create mode 100644 include/linux/netfilter/xt_TCPOPTSTRIP.h
 create mode 100644 include/linux/netfilter/xt_TEE.h
 create mode 100644 include/linux/netfilter/xt_TPROXY.h

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 22f1081..9de337e 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -576,3 +576,10 @@ Why:	The functions have been superceded by cancel_delayed_work_sync()
 Who:	Tejun Heo <tj@kernel.org>
 
 ----------------------------
+
+What:	Obsolete header files
+When:	soon?
+Who:	Jan Engelhardt <jengelh@medozas.de>
+Files:	include/linux/netfilter/xt_{AUDIT,CHECKSUM,CLASSIFY,
+	CONNSECMARK,CT,DSCP,IDLETIMER,LED,NFLOG,NFQUEUE,RATEEST,
+	SECMARK,TCPMSS,TCPOPTSTRIP,TEE,TPROXY}.h
diff --git a/include/linux/netfilter/Kbuild b/include/linux/netfilter/Kbuild
index b938380..4d96f22 100644
--- a/include/linux/netfilter/Kbuild
+++ b/include/linux/netfilter/Kbuild
@@ -59,3 +59,8 @@ header-y += xt_tee.h
 header-y += xt_time.h
 header-y += xt_tproxy.h
 header-y += xt_u32.h
+# old files
+header-y += xt_AUDIT.h xt_CHECKSUM.h xt_CLASSIFY.h xt_CONNMARK.h
+header-y += xt_CONNSECMARK.h xt_CT.h xt_DSCP.h xt_IDLETIMER.h xt_LED.h
+header-y += xt_MARK.h xt_NFLOG.h xt_NFQUEUE.h xt_RATEEST.h xt_SECMARK.h
+header-y += xt_TCPMSS.h xt_TCPOPTSTRIP.h xt_TEE.h xt_TPROXY.h
diff --git a/include/linux/netfilter/xt_AUDIT.h b/include/linux/netfilter/xt_AUDIT.h
new file mode 100644
index 0000000..0f045db
--- /dev/null
+++ b/include/linux/netfilter/xt_AUDIT.h
@@ -0,0 +1 @@
+#include <linux/netfilter/xt_audit.h>
diff --git a/include/linux/netfilter/xt_CHECKSUM.h b/include/linux/netfilter/xt_CHECKSUM.h
new file mode 100644
index 0000000..d83efa8
--- /dev/null
+++ b/include/linux/netfilter/xt_CHECKSUM.h
@@ -0,0 +1 @@
+#include <linux/netfilter/xt_checksum.h>
diff --git a/include/linux/netfilter/xt_CLASSIFY.h b/include/linux/netfilter/xt_CLASSIFY.h
new file mode 100644
index 0000000..a826183
--- /dev/null
+++ b/include/linux/netfilter/xt_CLASSIFY.h
@@ -0,0 +1 @@
+#include <linux/netfilter/xt_classify.h>
diff --git a/include/linux/netfilter/xt_CONNSECMARK.h b/include/linux/netfilter/xt_CONNSECMARK.h
new file mode 100644
index 0000000..0ceced7
--- /dev/null
+++ b/include/linux/netfilter/xt_CONNSECMARK.h
@@ -0,0 +1 @@
+#include <linux/netfilter/xt_connsecmark.h>
diff --git a/include/linux/netfilter/xt_CT.h b/include/linux/netfilter/xt_CT.h
new file mode 100644
index 0000000..bd12fd1
--- /dev/null
+++ b/include/linux/netfilter/xt_CT.h
@@ -0,0 +1 @@
+#include <linux/netfilter/xt_ct.h>
diff --git a/include/linux/netfilter/xt_DSCP.h b/include/linux/netfilter/xt_DSCP.h
new file mode 100644
index 0000000..a7e417d
--- /dev/null
+++ b/include/linux/netfilter/xt_DSCP.h
@@ -0,0 +1 @@
+#include <linux/netfilter/xt_dscp.h>
diff --git a/include/linux/netfilter/xt_IDLETIMER.h b/include/linux/netfilter/xt_IDLETIMER.h
new file mode 100644
index 0000000..ceccad1
--- /dev/null
+++ b/include/linux/netfilter/xt_IDLETIMER.h
@@ -0,0 +1 @@
+#include <linux/netfilter/xt_idletimer.h>
diff --git a/include/linux/netfilter/xt_LED.h b/include/linux/netfilter/xt_LED.h
new file mode 100644
index 0000000..0907572
--- /dev/null
+++ b/include/linux/netfilter/xt_LED.h
@@ -0,0 +1 @@
+#include <linux/netfilter/xt_led.h>
diff --git a/include/linux/netfilter/xt_NFLOG.h b/include/linux/netfilter/xt_NFLOG.h
new file mode 100644
index 0000000..4b59b1d
--- /dev/null
+++ b/include/linux/netfilter/xt_NFLOG.h
@@ -0,0 +1 @@
+#include <linux/netfilter/xt_nflog.h>
diff --git a/include/linux/netfilter/xt_NFQUEUE.h b/include/linux/netfilter/xt_NFQUEUE.h
new file mode 100644
index 0000000..3d0eba6
--- /dev/null
+++ b/include/linux/netfilter/xt_NFQUEUE.h
@@ -0,0 +1 @@
+#include <linux/netfilter/xt_nfqueue.h>
diff --git a/include/linux/netfilter/xt_RATEEST.h b/include/linux/netfilter/xt_RATEEST.h
new file mode 100644
index 0000000..c60d011
--- /dev/null
+++ b/include/linux/netfilter/xt_RATEEST.h
@@ -0,0 +1 @@
+#include <linux/netfilter/xt_rateest.h>
diff --git a/include/linux/netfilter/xt_SECMARK.h b/include/linux/netfilter/xt_SECMARK.h
new file mode 100644
index 0000000..abb7a63
--- /dev/null
+++ b/include/linux/netfilter/xt_SECMARK.h
@@ -0,0 +1 @@
+#include <linux/netfilter/xt_secmark.h>
diff --git a/include/linux/netfilter/xt_TCPMSS.h b/include/linux/netfilter/xt_TCPMSS.h
new file mode 100644
index 0000000..a1b235b
--- /dev/null
+++ b/include/linux/netfilter/xt_TCPMSS.h
@@ -0,0 +1 @@
+#include <linux/netfilter/xt_tcpmss.h>
diff --git a/include/linux/netfilter/xt_TCPOPTSTRIP.h b/include/linux/netfilter/xt_TCPOPTSTRIP.h
new file mode 100644
index 0000000..04b741d
--- /dev/null
+++ b/include/linux/netfilter/xt_TCPOPTSTRIP.h
@@ -0,0 +1 @@
+#include <linux/netfilter/xt_tcpoptstrip.h>
diff --git a/include/linux/netfilter/xt_TEE.h b/include/linux/netfilter/xt_TEE.h
new file mode 100644
index 0000000..43e28da
--- /dev/null
+++ b/include/linux/netfilter/xt_TEE.h
@@ -0,0 +1 @@
+#include <linux/netfilter/xt_tee.h>
diff --git a/include/linux/netfilter/xt_TPROXY.h b/include/linux/netfilter/xt_TPROXY.h
new file mode 100644
index 0000000..3c7d844
--- /dev/null
+++ b/include/linux/netfilter/xt_TPROXY.h
@@ -0,0 +1 @@
+#include <linux/netfilter/xt_tproxy.h>
-- 
# Created with git-export-patch
