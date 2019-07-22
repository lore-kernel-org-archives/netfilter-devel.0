Return-Path: <SRS0=3WFO=VT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0C59C76188
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 10:16:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8AC5217D6
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 10:16:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729229AbfGVKQy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jul 2019 06:16:54 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:45462 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726846AbfGVKQy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jul 2019 06:16:54 -0400
Received: from localhost ([::1]:58552 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hpVNE-0000ci-N7; Mon, 22 Jul 2019 12:16:52 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 07/11] xtables-save: Pass optstring/longopts to xtables_save_main()
Date:   Mon, 22 Jul 2019 12:16:24 +0200
Message-Id: <20190722101628.21195-8-phil@nwl.cc>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190722101628.21195-1-phil@nwl.cc>
References: <20190722101628.21195-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Introduce variables for the different optstrings so short and long
options live side-by-side.

In order to make xtables_save_main() more versatile, pass optstring and
longopts via parameter.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-save.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index ac452f1dd6f14..b4d14b5bcd016 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -33,7 +33,8 @@
 
 static bool show_counters = false;
 
-static const struct option options[] = {
+static const char *ipt_save_optstring = "bcdt:M:f:46V";
+static const struct option ipt_save_options[] = {
 	{.name = "counters", .has_arg = false, .val = 'c'},
 	{.name = "version",  .has_arg = false, .val = 'V'},
 	{.name = "dump",     .has_arg = false, .val = 'd'},
@@ -45,6 +46,7 @@ static const struct option options[] = {
 	{NULL},
 };
 
+static const char *arp_save_optstring = "cM:V";
 static const struct option arp_save_options[] = {
 	{.name = "counters", .has_arg = false, .val = 'c'},
 	{.name = "version",  .has_arg = false, .val = 'V'},
@@ -52,6 +54,7 @@ static const struct option arp_save_options[] = {
 	{NULL},
 };
 
+static const char *ebt_save_optstring = "ct:M:V";
 static const struct option ebt_save_options[] = {
 	{.name = "counters", .has_arg = false, .val = 'c'},
 	{.name = "version",  .has_arg = false, .val = 'V'},
@@ -129,7 +132,8 @@ do_output(struct nft_handle *h, const char *tablename, struct do_output_data *d)
  * rule
  */
 static int
-xtables_save_main(int family, int argc, char *argv[])
+xtables_save_main(int family, int argc, char *argv[],
+		  const char *optstring, const struct option *longopts)
 {
 	const struct builtin_table *tables;
 	const char *tablename = NULL;
@@ -150,7 +154,7 @@ xtables_save_main(int family, int argc, char *argv[])
 		exit(1);
 	}
 
-	while ((c = getopt_long(argc, argv, "bcdt:M:f:46V", options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, optstring, longopts, NULL)) != -1) {
 		switch (c) {
 		case 'b':
 			fprintf(stderr, "-b/--binary option is not implemented\n");
@@ -245,12 +249,14 @@ xtables_save_main(int family, int argc, char *argv[])
 
 int xtables_ip4_save_main(int argc, char *argv[])
 {
-	return xtables_save_main(NFPROTO_IPV4, argc, argv);
+	return xtables_save_main(NFPROTO_IPV4, argc, argv,
+				 ipt_save_optstring, ipt_save_options);
 }
 
 int xtables_ip6_save_main(int argc, char *argv[])
 {
-	return xtables_save_main(NFPROTO_IPV6, argc, argv);
+	return xtables_save_main(NFPROTO_IPV6, argc, argv,
+				 ipt_save_optstring, ipt_save_options);
 }
 
 static int __ebt_save(struct nft_handle *h, const char *tablename, void *data)
@@ -323,7 +329,7 @@ int xtables_eb_save_main(int argc_, char *argv_[])
 		exit(1);
 	}
 
-	while ((c = getopt_long(argc_, argv_, "ct:M:V", ebt_save_options, NULL)) != -1) {
+	while ((c = getopt_long(argc_, argv_, ebt_save_optstring, ebt_save_options, NULL)) != -1) {
 		switch (c) {
 		case 'c':
 			unsetenv("EBTABLES_SAVE_COUNTER");
@@ -378,7 +384,7 @@ int xtables_arp_save_main(int argc, char **argv)
 		exit(1);
 	}
 
-	while ((c = getopt_long(argc, argv, "cM:V", arp_save_options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, arp_save_optstring, arp_save_options, NULL)) != -1) {
 		switch (c) {
 		case 'c':
 			show_counters = true;
-- 
2.22.0

