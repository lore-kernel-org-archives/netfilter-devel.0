Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77AE8C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Jan 2022 15:05:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244065AbiAKPFO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Jan 2022 10:05:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244013AbiAKPFN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Jan 2022 10:05:13 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADCA1C06173F
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Jan 2022 07:05:13 -0800 (PST)
Received: from localhost ([::1]:59132 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1n7Ihz-0007XQ-VP; Tue, 11 Jan 2022 16:05:12 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 08/11] xshared: Store parsed wait and wait_interval in xtables_args
Date:   Tue, 11 Jan 2022 16:04:26 +0100
Message-Id: <20220111150429.29110-9-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220111150429.29110-1-phil@nwl.cc>
References: <20220111150429.29110-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

While nft-variants don't care, legacy ones do.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xshared.c | 8 +++-----
 iptables/xshared.h | 2 ++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/iptables/xshared.c b/iptables/xshared.c
index 4c8ee3aa20278..b7dad707d1d1a 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -1311,11 +1311,9 @@ void do_parse(int argc, char *argv[],
 	struct xtables_match *m;
 	struct xtables_rule_match *matchp;
 	bool wait_interval_set = false;
-	struct timeval wait_interval;
 	struct xtables_target *t;
 	bool table_set = false;
 	bool invert = false;
-	int wait = 0;
 
 	/* re-set optind to 0 in case do_command4 gets called
 	 * a second time */
@@ -1658,7 +1656,7 @@ void do_parse(int argc, char *argv[],
 					      "iptables-restore");
 			}
 
-			wait = parse_wait_time(argc, argv);
+			args->wait = parse_wait_time(argc, argv);
 			break;
 
 		case 'W':
@@ -1668,7 +1666,7 @@ void do_parse(int argc, char *argv[],
 					      "iptables-restore");
 			}
 
-			parse_wait_interval(argc, argv, &wait_interval);
+			parse_wait_interval(argc, argv, &args->wait_interval);
 			wait_interval_set = true;
 			break;
 
@@ -1753,7 +1751,7 @@ void do_parse(int argc, char *argv[],
 			"\nThe \"nat\" table is not intended for filtering, "
 			"the use of DROP is therefore inhibited.\n\n");
 
-	if (!wait && wait_interval_set)
+	if (!args->wait && wait_interval_set)
 		xtables_error(PARAMETER_PROBLEM,
 			      "--wait-interval only makes sense with --wait\n");
 
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 13ea05fef87e0..48bfe911f7a47 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -293,6 +293,8 @@ struct xtables_args {
 	const char	*arp_hlen, *arp_opcode;
 	const char	*arp_htype, *arp_ptype;
 	unsigned long long pcnt_cnt, bcnt_cnt;
+	int		wait;
+	struct timeval	wait_interval;
 };
 
 struct xt_cmd_parse_ops {
-- 
2.34.1

