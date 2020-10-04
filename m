Return-Path: <SRS0=OxIk=DL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCF7AC4727F
	for <netfilter-devel@archiver.kernel.org>; Sun,  4 Oct 2020 19:50:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5AC32067D
	for <netfilter-devel@archiver.kernel.org>; Sun,  4 Oct 2020 19:50:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgJDTuM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 4 Oct 2020 15:50:12 -0400
Received: from correo.us.es ([193.147.175.20]:34928 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726352AbgJDTuJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 4 Oct 2020 15:50:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0EFD0EF42E
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Oct 2020 21:50:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F41A4DA78E
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Oct 2020 21:50:07 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E97ACDA78B; Sun,  4 Oct 2020 21:50:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A5B11DA730;
        Sun,  4 Oct 2020 21:50:05 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 04 Oct 2020 21:50:05 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 7D9CB42EF9E2;
        Sun,  4 Oct 2020 21:50:05 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 01/11] netfilter: conntrack: proc: rename stat column
Date:   Sun,  4 Oct 2020 21:49:30 +0200
Message-Id: <20201004194940.7368-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201004194940.7368-1-pablo@netfilter.org>
References: <20201004194940.7368-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Rename 'searched' column to 'clashres' (same len).

conntrack(8) using the old /proc interface (ctnetlink not available) shows:

cpu=0  entries=4784 clashres=2292 [..]

Another alternative is to add another column, but this increases the
number of always-0 columns.

Fixes: bc92470413f3af1 ("netfilter: conntrack: add clash resolution stat counter")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_standalone.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 0ff39740797d..46c5557c1fec 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -428,14 +428,14 @@ static int ct_cpu_seq_show(struct seq_file *seq, void *v)
 	const struct ip_conntrack_stat *st = v;
 
 	if (v == SEQ_START_TOKEN) {
-		seq_puts(seq, "entries  searched found new invalid ignore delete delete_list insert insert_failed drop early_drop icmp_error  expect_new expect_create expect_delete search_restart\n");
+		seq_puts(seq, "entries  clashres found new invalid ignore delete delete_list insert insert_failed drop early_drop icmp_error  expect_new expect_create expect_delete search_restart\n");
 		return 0;
 	}
 
 	seq_printf(seq, "%08x  %08x %08x %08x %08x %08x %08x %08x "
 			"%08x %08x %08x %08x %08x  %08x %08x %08x %08x\n",
 		   nr_conntracks,
-		   st->clash_resolve, /* was: searched */
+		   st->clash_resolve,
 		   st->found,
 		   0,
 		   st->invalid,
-- 
2.20.1

