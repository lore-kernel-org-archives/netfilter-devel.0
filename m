Return-Path: <SRS0=HMuw=IE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88836C4332D
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Mar 2021 12:13:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72F4564FE8
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Mar 2021 12:13:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbhCFMMv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Mar 2021 07:12:51 -0500
Received: from correo.us.es ([193.147.175.20]:46386 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230372AbhCFMMk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Mar 2021 07:12:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AE9AEF2580
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Mar 2021 13:12:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 973A8DA793
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Mar 2021 13:12:33 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8C1C2DA73F; Sat,  6 Mar 2021 13:12:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2DC99DA73F;
        Sat,  6 Mar 2021 13:12:31 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 06 Mar 2021 13:12:31 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 04D2642DC6E2;
        Sat,  6 Mar 2021 13:12:30 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 6/9] netfilter: x_tables: gpf inside xt_find_revision()
Date:   Sat,  6 Mar 2021 13:12:20 +0100
Message-Id: <20210306121223.28711-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210306121223.28711-1-pablo@netfilter.org>
References: <20210306121223.28711-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

nested target/match_revfn() calls work with xt[NFPROTO_UNSPEC] lists
without taking xt[NFPROTO_UNSPEC].mutex. This can race with module unload
and cause host to crash:

general protection fault: 0000 [#1]
Modules linked in: ... [last unloaded: xt_cluster]
CPU: 0 PID: 542455 Comm: iptables
RIP: 0010:[<ffffffff8ffbd518>]  [<ffffffff8ffbd518>] strcmp+0x18/0x40
RDX: 0000000000000003 RSI: ffff9a5a5d9abe10 RDI: dead000000000111
R13: ffff9a5a5d9abe10 R14: ffff9a5a5d9abd8c R15: dead000000000100
(VvS: %R15 -- &xt_match,  %RDI -- &xt_match.name,
xt_cluster unregister match in xt[NFPROTO_UNSPEC].match list)
Call Trace:
 [<ffffffff902ccf44>] match_revfn+0x54/0xc0
 [<ffffffff902ccf9f>] match_revfn+0xaf/0xc0
 [<ffffffff902cd01e>] xt_find_revision+0x6e/0xf0
 [<ffffffffc05a5be0>] do_ipt_get_ctl+0x100/0x420 [ip_tables]
 [<ffffffff902cc6bf>] nf_getsockopt+0x4f/0x70
 [<ffffffff902dd99e>] ip_getsockopt+0xde/0x100
 [<ffffffff903039b5>] raw_getsockopt+0x25/0x50
 [<ffffffff9026c5da>] sock_common_getsockopt+0x1a/0x20
 [<ffffffff9026b89d>] SyS_getsockopt+0x7d/0xf0
 [<ffffffff903cbf92>] system_call_fastpath+0x25/0x2a

Fixes: 656caff20e1 ("netfilter 04/09: x_tables: fix match/target revision lookup")
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/x_tables.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index acce622582e3..bce6ca203d46 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -330,6 +330,7 @@ static int match_revfn(u8 af, const char *name, u8 revision, int *bestp)
 	const struct xt_match *m;
 	int have_rev = 0;
 
+	mutex_lock(&xt[af].mutex);
 	list_for_each_entry(m, &xt[af].match, list) {
 		if (strcmp(m->name, name) == 0) {
 			if (m->revision > *bestp)
@@ -338,6 +339,7 @@ static int match_revfn(u8 af, const char *name, u8 revision, int *bestp)
 				have_rev = 1;
 		}
 	}
+	mutex_unlock(&xt[af].mutex);
 
 	if (af != NFPROTO_UNSPEC && !have_rev)
 		return match_revfn(NFPROTO_UNSPEC, name, revision, bestp);
@@ -350,6 +352,7 @@ static int target_revfn(u8 af, const char *name, u8 revision, int *bestp)
 	const struct xt_target *t;
 	int have_rev = 0;
 
+	mutex_lock(&xt[af].mutex);
 	list_for_each_entry(t, &xt[af].target, list) {
 		if (strcmp(t->name, name) == 0) {
 			if (t->revision > *bestp)
@@ -358,6 +361,7 @@ static int target_revfn(u8 af, const char *name, u8 revision, int *bestp)
 				have_rev = 1;
 		}
 	}
+	mutex_unlock(&xt[af].mutex);
 
 	if (af != NFPROTO_UNSPEC && !have_rev)
 		return target_revfn(NFPROTO_UNSPEC, name, revision, bestp);
@@ -371,12 +375,10 @@ int xt_find_revision(u8 af, const char *name, u8 revision, int target,
 {
 	int have_rev, best = -1;
 
-	mutex_lock(&xt[af].mutex);
 	if (target == 1)
 		have_rev = target_revfn(af, name, revision, &best);
 	else
 		have_rev = match_revfn(af, name, revision, &best);
-	mutex_unlock(&xt[af].mutex);
 
 	/* Nothing at all?  Return 0 to try loading module. */
 	if (best == -1) {
-- 
2.20.1

