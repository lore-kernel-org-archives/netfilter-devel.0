From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 2/6] ulogd.conf: Comment library dependant plugins
Date: Wed, 22 Sep 2010 02:47:18 +0200
Message-ID: <1285116442-32490-3-git-send-email-eric@inl.fr>
References: <1285116442-32490-1-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:33857 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755547Ab0IVAy5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Sep 2010 20:54:57 -0400
In-Reply-To: <1285116442-32490-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Some plugins depend of external library. Thus loading of ulogd2 can
fail if they have not been compiled and are not present on the system.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 ulogd.conf.in |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/ulogd.conf.in b/ulogd.conf.in
index cda5bb9..de5bc11 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -25,9 +25,9 @@ loglevel=1
 # 2. options for each plugin in seperate section below
 
 
-plugin="@libdir@/ulogd/ulogd_inppkt_NFLOG.so"
+#plugin="@libdir@/ulogd/ulogd_inppkt_NFLOG.so"
 #plugin="@libdir@/ulogd/ulogd_inppkt_ULOG.so"
-plugin="@libdir@/ulogd/ulogd_inpflow_NFCT.so"
+#plugin="@libdir@/ulogd/ulogd_inpflow_NFCT.so"
 plugin="@libdir@/ulogd/ulogd_filter_IFINDEX.so"
 plugin="@libdir@/ulogd/ulogd_filter_IP2STR.so"
 plugin="@libdir@/ulogd/ulogd_filter_IP2BIN.so"
@@ -37,7 +37,7 @@ plugin="@libdir@/ulogd/ulogd_filter_PRINTFLOW.so"
 #plugin="@libdir@/ulogd/ulogd_filter_MARK.so"
 plugin="@libdir@/ulogd/ulogd_output_LOGEMU.so"
 plugin="@libdir@/ulogd/ulogd_output_SYSLOG.so"
-plugin="@libdir@/ulogd/ulogd_output_XML.so"
+#plugin="@libdir@/ulogd/ulogd_output_XML.so"
 #plugin="@libdir@/ulogd/ulogd_output_OPRINT.so"
 #plugin="@libdir@/ulogd/ulogd_output_NACCT.so"
 #plugin="@libdir@/ulogd/ulogd_output_PCAP.so"
-- 
1.6.1

