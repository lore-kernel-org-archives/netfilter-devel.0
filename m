Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBBD1C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Jan 2022 11:21:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbiADLVC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Jan 2022 06:21:02 -0500
Received: from mail.netfilter.org ([217.70.188.207]:58686 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbiADLVB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Jan 2022 06:21:01 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id F149D60098
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Jan 2022 12:18:15 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH ulogd] GPRINT: fix it with NFLOG
Date:   Tue,  4 Jan 2022 12:20:56 +0100
Message-Id: <20220104112056.4034-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add ULOGD_DTYPE_RAW to GPRINT to make it work.

Update example ulogd.conf.in file since BASE provides a more complete
packet dissection.

Fixes: 59a71256945d ("src: add example use of GPRINT to ulogd.conf.in configuration file")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 output/ulogd_output_GPRINT.c | 2 +-
 ulogd.conf.in                | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/output/ulogd_output_GPRINT.c b/output/ulogd_output_GPRINT.c
index bc7aa3419ed8..aedd08e980f7 100644
--- a/output/ulogd_output_GPRINT.c
+++ b/output/ulogd_output_GPRINT.c
@@ -249,7 +249,7 @@ static int gprint_fini(struct ulogd_pluginstance *pi)
 static struct ulogd_plugin gprint_plugin = {
 	.name = "GPRINT",
 	.input = {
-		.type = ULOGD_DTYPE_PACKET | ULOGD_DTYPE_FLOW | ULOGD_DTYPE_SUM,
+		.type = ULOGD_DTYPE_RAW | ULOGD_DTYPE_PACKET | ULOGD_DTYPE_FLOW | ULOGD_DTYPE_SUM,
 	},
 	.output = {
 		.type = ULOGD_DTYPE_SINK,
diff --git a/ulogd.conf.in b/ulogd.conf.in
index 99cfc244d2b7..9a04bf7c442a 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -65,7 +65,7 @@ logfile="/var/log/ulogd.log"
 #stack=log2:NFLOG,base1:BASE,mark1:MARK,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,emu1:LOGEMU
 
 # this is a stack for packet-based logging via GPRINT
-#stack=log1:NFLOG,gp1:GPRINT
+#stack=log1:NFLOG,base1:BASE,gp1:GPRINT
 
 # this is a stack for flow-based logging via LOGEMU
 #stack=ct1:NFCT,ip2str1:IP2STR,print1:PRINTFLOW,emu1:LOGEMU
-- 
2.30.2

