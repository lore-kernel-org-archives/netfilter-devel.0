From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] test: update to fit latest limit changes
Date: Tue, 22 Oct 2013 18:25:45 +0200
Message-ID: <20131022162545.10302.28662.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:46611 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753361Ab3JVQZ4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Oct 2013 12:25:56 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id E2EFF51ED1B
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Oct 2013 16:25:53 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1zVu9S9S9mMr for <netfilter-devel@vger.kernel.org>;
	Tue, 22 Oct 2013 18:25:48 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id C842C51ECD4
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Oct 2013 18:25:48 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Update tests to fit the latest limit changes in
commit [e91ea14] (expr: limit: operational limit match)

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/jsonfiles/27-rule-limit.json |    2 +-
 tests/xmlfiles/27-rule-limit.xml   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/jsonfiles/27-rule-limit.json b/tests/jsonfiles/27-rule-limit.json
index 1f066b4..6d91244 100644
--- a/tests/jsonfiles/27-rule-limit.json
+++ b/tests/jsonfiles/27-rule-limit.json
@@ -1 +1 @@
-{"rule":{"family":"ip","table":"filter","chain":"input","handle":27,"flags":0,"expr":[{"type":"limit","rate":321321,"depth":0}]}}
+{"rule":{"family":"ip","table":"filter","chain":"input","handle":27,"flags":0,"expr":[{"type":"limit","rate":321321,"unit":0}]}}
diff --git a/tests/xmlfiles/27-rule-limit.xml b/tests/xmlfiles/27-rule-limit.xml
index aa81b4e..38a19f8 100644
--- a/tests/xmlfiles/27-rule-limit.xml
+++ b/tests/xmlfiles/27-rule-limit.xml
@@ -1 +1 @@
-<rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><flags>0</flags><expr type="limit"><rate>123123</rate><depth>321321</depth></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><flags>0</flags><expr type="limit"><rate>123123</rate><unit>321321</unit></expr></rule>

