Return-Path: <SRS0=6+Vk=V4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6873EC433FF
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Jul 2019 16:39:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40234208E3
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Jul 2019 16:39:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729820AbfGaQjv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Jul 2019 12:39:51 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:40928 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729823AbfGaQjv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Jul 2019 12:39:51 -0400
Received: from localhost ([::1]:54018 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hsrdm-0005ke-NE; Wed, 31 Jul 2019 18:39:50 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 3/5] xtables-monitor: Improve error messages
Date:   Wed, 31 Jul 2019 18:39:13 +0200
Message-Id: <20190731163915.22232-4-phil@nwl.cc>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190731163915.22232-1-phil@nwl.cc>
References: <20190731163915.22232-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Print a line explaining what was wrong before the general help text.
Also catch multiple family selectors, they overwrite each other and
hence could cause unexpected behaviour.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-monitor.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/iptables/xtables-monitor.c b/iptables/xtables-monitor.c
index eb80bac81c645..02e8e446b1c8c 100644
--- a/iptables/xtables-monitor.c
+++ b/iptables/xtables-monitor.c
@@ -588,6 +588,16 @@ static void print_usage(void)
 	exit(EXIT_FAILURE);
 }
 
+static void set_nfproto(struct cb_arg *arg, uint32_t val)
+{
+	if (arg->nfproto != NFPROTO_UNSPEC && arg->nfproto != val) {
+		fprintf(stderr, "Only one of '-4' or '-6' may be specified at once.\n\n");
+		print_usage();
+		exit(PARAMETER_PROBLEM);
+	}
+	arg->nfproto = val;
+}
+
 int xtables_monitor_main(int argc, char *argv[])
 {
 	struct mnl_socket *nl;
@@ -626,10 +636,10 @@ int xtables_monitor_main(int argc, char *argv[])
 			print_usage();
 			exit(0);
 		case '4':
-			cb_arg.nfproto = NFPROTO_IPV4;
+			set_nfproto(&cb_arg, NFPROTO_IPV4);
 			break;
 		case '6':
-			cb_arg.nfproto = NFPROTO_IPV6;
+			set_nfproto(&cb_arg, NFPROTO_IPV6);
 			break;
 		case 'V':
 			printf("xtables-monitor %s\n", PACKAGE_VERSION);
@@ -647,6 +657,7 @@ int xtables_monitor_main(int argc, char *argv[])
 		nfgroup |= 1 << (NFNLGRP_NFTABLES - 1);
 
 	if (nfgroup == 0) {
+		fprintf(stderr, "Missing mandatory argument, specify either '-t' or '-e' (or both).\n\n");
 		print_usage();
 		exit(EXIT_FAILURE);
 	}
-- 
2.22.0

