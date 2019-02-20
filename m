Return-Path: <SRS0=AQmx=Q3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0429C43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Feb 2019 18:51:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1D5A20859
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Feb 2019 18:51:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbfBTSvn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Feb 2019 13:51:43 -0500
Received: from mail.us.es ([193.147.175.20]:37580 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725798AbfBTSvn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Feb 2019 13:51:43 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 30E921031E8
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Feb 2019 19:51:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 207A0FC5E3
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Feb 2019 19:51:32 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 15AD1FC5E1; Wed, 20 Feb 2019 19:51:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 13D48FC3F5
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Feb 2019 19:51:30 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 20 Feb 2019 19:51:30 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id EE6374265A4C
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Feb 2019 19:51:29 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH conntrack-tools 1/3] conntrack: extend nfct_mnl_socket_open() to use it to handle events
Date:   Wed, 20 Feb 2019 19:51:32 +0100
Message-Id: <20190220185134.3608-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add parameter to nfct_mnl_socket_open() to subscribe to events.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/conntrack.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index d638a6a2db9d..a5861cbb85ce 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -1848,14 +1848,14 @@ static struct nfct_mnl_socket {
 	uint32_t		portid;
 } sock;
 
-static int nfct_mnl_socket_open(void)
+static int nfct_mnl_socket_open(unsigned int events)
 {
 	sock.mnl = mnl_socket_open(NETLINK_NETFILTER);
 	if (sock.mnl == NULL) {
 		perror("mnl_socket_open");
 		return -1;
 	}
-	if (mnl_socket_bind(sock.mnl, 0, MNL_SOCKET_AUTOPID) < 0) {
+	if (mnl_socket_bind(sock.mnl, events, MNL_SOCKET_AUTOPID) < 0) {
 		perror("mnl_socket_bind");
 		return -1;
 	}
@@ -2566,7 +2566,7 @@ int main(int argc, char *argv[])
 
 	case CT_LIST:
 		if (type == CT_TABLE_DYING) {
-			if (nfct_mnl_socket_open() < 0)
+			if (nfct_mnl_socket_open(0) < 0)
 				exit_error(OTHER_PROBLEM, "Can't open handler");
 
 			res = nfct_mnl_dump(NFNL_SUBSYS_CTNETLINK,
@@ -2576,7 +2576,7 @@ int main(int argc, char *argv[])
 			nfct_mnl_socket_close();
 			break;
 		} else if (type == CT_TABLE_UNCONFIRMED) {
-			if (nfct_mnl_socket_open() < 0)
+			if (nfct_mnl_socket_open(0) < 0)
 				exit_error(OTHER_PROBLEM, "Can't open handler");
 
 			res = nfct_mnl_dump(NFNL_SUBSYS_CTNETLINK,
@@ -2779,7 +2779,7 @@ int main(int argc, char *argv[])
 		fprintf(stderr, "%s v%s (conntrack-tools): ",PROGNAME,VERSION);
 		fprintf(stderr,"expectation table has been emptied.\n");
 		break;
-		
+
 	case CT_EVENT:
 		if (options & CT_OPT_EVENT_MASK) {
 			unsigned int nl_events = 0;
@@ -2860,7 +2860,7 @@ int main(int argc, char *argv[])
 		/* If we fail with netlink, fall back to /proc to ensure
 		 * backward compatibility.
 		 */
-		if (nfct_mnl_socket_open() < 0)
+		if (nfct_mnl_socket_open(0) < 0)
 			goto try_proc_count;
 
 		res = nfct_mnl_get(NFNL_SUBSYS_CTNETLINK,
@@ -2905,7 +2905,7 @@ try_proc_count:
 		/* If we fail with netlink, fall back to /proc to ensure
 		 * backward compatibility.
 		 */
-		if (nfct_mnl_socket_open() < 0)
+		if (nfct_mnl_socket_open(0) < 0)
 			goto try_proc;
 
 		res = nfct_mnl_dump(NFNL_SUBSYS_CTNETLINK,
@@ -2924,7 +2924,7 @@ try_proc_count:
 		/* If we fail with netlink, fall back to /proc to ensure
 		 * backward compatibility.
 		 */
-		if (nfct_mnl_socket_open() < 0)
+		if (nfct_mnl_socket_open(0) < 0)
 			goto try_proc;
 
 		res = nfct_mnl_dump(NFNL_SUBSYS_CTNETLINK_EXP,
-- 
2.11.0

