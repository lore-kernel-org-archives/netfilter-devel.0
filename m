From: Chris Boot <bootc@bootc.net>
Subject: [PATCH] ulogd: ulogd_inppkt_NFLOG: close nflog handle after unbinding
Date: Mon, 18 Nov 2013 11:09:14 +0000
Message-ID: <1384772954-20144-1-git-send-email-bootc@bootc.net>
Cc: Chris Boot <bootc@bootc.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from kamaji.grokhost.net ([87.117.218.43]:40252 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab3KRLJh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Nov 2013 06:09:37 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The nflog handle is closed, and then nflog_unbind_pf() is called on it, which
triggers an assertion failure within libnfnetlink. This patch simply moves
the nflog_close() just after the nflog_unbind_pf() calls.

Signed-off-by: Chris Boot <bootc@bootc.net>

---

The below information is included in the Debian patch file (Debian's DEP-3
patch tagging guidelines):

Author: Chris Boot <debian@bootc.net>
Bug: https://bugzilla.netfilter.org/show_bug.cgi?id=871
Bug-Debian: http://bugs.debian.org/729055
Bug-Ubuntu: https://bugs.launchpad.net/bugs/1250520
Forwarded: https://bugzilla.netfilter.org/attachment.cgi?id=425
Last-Update: 2013-11-15

Regards,
Chris

--- ulogd2-2.0.2.orig/input/packet/ulogd_inppkt_NFLOG.c
+++ ulogd2-2.0.2/input/packet/ulogd_inppkt_NFLOG.c
@@ -618,12 +618,12 @@ static int start(struct ulogd_pluginstan
 	return 0;
 
 out_bind:
-	nflog_close(ui->nful_h);
 	if (group_ce(upi->config_kset).u.value == 0) {
 		nflog_unbind_pf(ui->nful_h, AF_INET);
 		nflog_unbind_pf(ui->nful_h, AF_INET6);
 		nflog_unbind_pf(ui->nful_h, AF_BRIDGE);
 	}
+	nflog_close(ui->nful_h);
 out_handle:
 	free(ui->nfulog_buf);
 out_buf:
