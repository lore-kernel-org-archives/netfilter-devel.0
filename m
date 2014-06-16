From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH] tests: Add json and xml test file for queue
Date: Mon, 16 Jun 2014 11:06:38 +0200
Message-ID: <1402909598-24943-2-git-send-email-anarey@gmail.com>
References: <1402909598-24943-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:59839 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551AbaFPJGs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:06:48 -0400
Received: by mail-we0-f177.google.com with SMTP id u56so5374064wes.36
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jun 2014 02:06:47 -0700 (PDT)
In-Reply-To: <1402909598-24943-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

New xml and json test files.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 tests/jsonfiles/66-rule-queue.json | 1 +
 tests/jsonfiles/67-rule-queue.json | 1 +
 tests/xmlfiles/77-rule-queue.xml   | 1 +
 tests/xmlfiles/78-rule-queue.xml   | 2 ++
 4 files changed, 5 insertions(+)
 create mode 100644 tests/jsonfiles/66-rule-queue.json
 create mode 100644 tests/jsonfiles/67-rule-queue.json
 create mode 100644 tests/xmlfiles/77-rule-queue.xml
 create mode 100644 tests/xmlfiles/78-rule-queue.xml

diff --git a/tests/jsonfiles/66-rule-queue.json b/tests/jsonfiles/66-rule-queue.json
new file mode 100644
index 0000000..016110e
--- /dev/null
+++ b/tests/jsonfiles/66-rule-queue.json
@@ -0,0 +1 @@
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":43,"expr":[{"type":"queue","num":4,"total":2,"flags":0}]}}]}
diff --git a/tests/jsonfiles/67-rule-queue.json b/tests/jsonfiles/67-rule-queue.json
new file mode 100644
index 0000000..0fefd68
--- /dev/null
+++ b/tests/jsonfiles/67-rule-queue.json
@@ -0,0 +1 @@
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":44,"position":43,"expr":[{"type":"queue","num":4,"total":2,"flags":3}]}}]}
diff --git a/tests/xmlfiles/77-rule-queue.xml b/tests/xmlfiles/77-rule-queue.xml
new file mode 100644
index 0000000..3073b47
--- /dev/null
+++ b/tests/xmlfiles/77-rule-queue.xml
@@ -0,0 +1 @@
+<nftables><rule><family>ip</family><table>filter</table><chain>input</chain><handle>43</handle><expr type="queue"><num>4</num><total>2</total><flags>0</flags></expr></rule></nftables>
diff --git a/tests/xmlfiles/78-rule-queue.xml b/tests/xmlfiles/78-rule-queue.xml
new file mode 100644
index 0000000..1876af7
--- /dev/null
+++ b/tests/xmlfiles/78-rule-queue.xml
@@ -0,0 +1,2 @@
+<nftables><rule><family>ip</family><table>filter</table><chain>input</chain><handle>44</handle><position>43</position><expr type="queue"><num>4</num><total>2</total><flags>3</flags></expr></rule></nftables>
+
-- 
2.0.0

