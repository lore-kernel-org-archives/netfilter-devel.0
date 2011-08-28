From: Eric Leblond <eric@regit.org>
Subject: [PATCH 2/2] pcap: add file option to configuration file
Date: Mon, 29 Aug 2011 00:43:32 +0200
Message-ID: <1314571412-9707-3-git-send-email-eric@regit.org>
References: <1314571412-9707-1-git-send-email-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:52191 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab1H1XSi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 28 Aug 2011 19:18:38 -0400
In-Reply-To: <1314571412-9707-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 ulogd.conf.in |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/ulogd.conf.in b/ulogd.conf.in
index b7b714b..5fe2639 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -171,6 +171,8 @@ directory="/var/log/"
 sync=1
 
 [pcap1]
+#default file is /var/log/ulogd.pcap
+#file=/var/log/ulogd.pcap
 sync=1
 
 [mysql1]
-- 
1.7.5.4

