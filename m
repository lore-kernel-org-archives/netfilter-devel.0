From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH iptables] extensions: libxt_connlabel: add unit test
Date: Sat, 23 Jul 2016 15:11:39 +0800
Message-ID: <1469257899-27058-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:59207 "EHLO m12-17.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbcGWHM6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Jul 2016 03:12:58 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

Add some unit tests for connlabel match extension:
  # ./iptables-test.py extensions/libxt_connlabel.t
  extensions/libxt_connlabel.t: OK
  1 test files, 7 unit tests, 7 passed

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 extensions/libxt_connlabel.t | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)
 create mode 100644 extensions/libxt_connlabel.t

diff --git a/extensions/libxt_connlabel.t b/extensions/libxt_connlabel.t
new file mode 100644
index 0000000..aad1032
--- /dev/null
+++ b/extensions/libxt_connlabel.t
@@ -0,0 +1,18 @@
+:INPUT,FORWARD,OUTPUT
+# Backup the connlabel.conf, then add some label maps for test
+@[ -f /etc/xtables/connlabel.conf ] && mv /etc/xtables/connlabel.conf /tmp/connlabel.conf.bak
+@mkdir -p /etc/xtables
+@echo "40 bit40" > /etc/xtables/connlabel.conf
+@echo "41 bit41" >> /etc/xtables/connlabel.conf
+@echo "128 bit128" >> /etc/xtables/connlabel.conf
+-m connlabel --label "bit40";=;OK
+-m connlabel ! --label "bit40";=;OK
+-m connlabel --label "bit41" --set;=;OK
+-m connlabel ! --label "bit41" --set;=;OK
+-m connlabel --label "bit128";;FAIL
+@echo > /etc/xtables/connlabel.conf
+-m connlabel --label "abc";;FAIL
+@rm -f /etc/xtables/connlabel.conf
+-m connlabel --label "abc";;FAIL
+# Restore the original connlabel.conf
+@[ -f /tmp/connlabel.conf.bak ] && mv /tmp/connlabel.conf.bak /etc/xtables/connlabel.conf
-- 
2.5.5


