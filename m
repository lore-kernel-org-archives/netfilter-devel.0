From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH conntrackd 1/2] conntrackd: Remove obsolete rule to catch ambiguous Checksum option
Date: Fri, 10 Mar 2017 10:41:47 +0100
Message-ID: <1489138908-3822-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41560 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936201AbdCJJl7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Mar 2017 04:41:59 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3094319665A
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Mar 2017 10:41:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2228EDA725
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Mar 2017 10:41:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 65EECDA816
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Mar 2017 10:41:51 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This warning has been there for long time, and the example files we
provide already come with the right syntax, so remove this old chunk.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/read_config_yy.y | 23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/src/read_config_yy.y b/src/read_config_yy.y
index 97f905d13091..2c08d4e5b1b3 100644
--- a/src/read_config_yy.y
+++ b/src/read_config_yy.y
@@ -185,28 +185,6 @@ purge: T_PURGE T_NUMBER
 	conf.purge_timeout = $2;
 };
 
-checksum: T_CHECKSUM T_ON 
-{
-	dlog(LOG_WARNING, "the use of `Checksum' outside the "
-	     "`Multicast' clause is ambiguous");
-	/* 
-	 * XXX: The use of Checksum outside of the Multicast clause is broken
-	 *	if we have more than one dedicated links.
-	 */
-	conf.channel[0].u.mcast.checksum = 0;
-};
-
-checksum: T_CHECKSUM T_OFF
-{
-	dlog(LOG_WARNING, "the use of `Checksum' outside the "
-	     "`Multicast' clause is ambiguous");
-	/*
-	 * XXX: The use of Checksum outside of the Multicast clause is broken
-	 *	if we have more than one dedicated links.
-	 */
-	conf.channel[0].u.mcast.checksum = 1;
-};
-
 multicast_line : T_MULTICAST '{' multicast_options '}'
 {
 	if (conf.channel_type_global != CHANNEL_NONE &&
@@ -693,7 +671,6 @@ sync_line: refreshtime
 	 | expiretime
 	 | timeout
 	 | purge
-	 | checksum
 	 | multicast_line
 	 | udp_line
 	 | tcp_line
-- 
2.1.4

