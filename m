Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C61C8C433E6
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Jan 2021 22:32:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BAB723A5E
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Jan 2021 22:32:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730730AbhANWcw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Jan 2021 17:32:52 -0500
Received: from correo.us.es ([193.147.175.20]:44114 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730735AbhANWcv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Jan 2021 17:32:51 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DAFE8303D02
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Jan 2021 23:31:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CD50BDA73F
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Jan 2021 23:31:22 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C2C46DA730; Thu, 14 Jan 2021 23:31:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A3FB0DA78A;
        Thu, 14 Jan 2021 23:31:20 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 14 Jan 2021 23:31:20 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 8749742DC700;
        Thu, 14 Jan 2021 23:31:20 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     mikhail.sennikovskii@cloud.ionos.com
Subject: [PATCH conntrack-tools 3/3] conntrack: add do_command_ct()
Date:   Thu, 14 Jan 2021 23:32:02 +0100
Message-Id: <20210114223202.4758-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210114223202.4758-1-pablo@netfilter.org>
References: <20210114223202.4758-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Wrap the code to run the command around the do_command_ct() function.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/conntrack.c | 44 ++++++++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 20 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 019299645a0d..987d936e7ee2 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -1444,8 +1444,7 @@ split_address_and_port(const char *arg, char **address, char **port_str)
 	}
 }
 
-static void
-usage(char *prog)
+static void usage(const char *prog)
 {
 	fprintf(stdout, "Command line interface for the connection "
 			"tracking system. Version %s\n", VERSION);
@@ -3084,26 +3083,12 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 	ct_cmd->socketbuffersize = socketbuffersize;
 }
 
-int main(int argc, char *argv[])
+static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 {
-	struct ct_cmd _cmd = {}, *cmd = &_cmd;
+	struct nfct_filter_dump *filter_dump;
 	int res = 0;
 
-	register_tcp();
-	register_udp();
-	register_udplite();
-	register_sctp();
-	register_dccp();
-	register_icmp();
-	register_icmpv6();
-	register_gre();
-	register_unknown();
-
-	do_parse(cmd, argc, argv);
-
 	switch(cmd->command) {
-	struct nfct_filter_dump *filter_dump;
-
 	case CT_LIST:
 		if (cmd->type == CT_TABLE_DYING) {
 			if (nfct_mnl_socket_open(0) < 0)
@@ -3508,12 +3493,12 @@ try_proc:
 		printf("%s v%s (conntrack-tools)\n", PROGNAME, VERSION);
 		break;
 	case CT_HELP:
-		usage(argv[0]);
+		usage(progname);
 		if (options & CT_OPT_PROTO)
 			extension_help(h, cmd->protonum);
 		break;
 	default:
-		usage(argv[0]);
+		usage(progname);
 		break;
 	}
 
@@ -3535,3 +3520,22 @@ try_proc:
 
 	return EXIT_SUCCESS;
 }
+
+int main(int argc, char *argv[])
+{
+	struct ct_cmd _cmd = {}, *cmd = &_cmd;
+
+	register_tcp();
+	register_udp();
+	register_udplite();
+	register_sctp();
+	register_dccp();
+	register_icmp();
+	register_icmpv6();
+	register_gre();
+	register_unknown();
+
+	do_parse(cmd, argc, argv);
+
+	return do_command_ct(argv[0], cmd);
+}
-- 
2.20.1

