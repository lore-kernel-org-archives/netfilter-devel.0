Return-Path: <SRS0=2TpG=4X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CE35C10DCE
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Mar 2020 18:15:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DA7520578
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Mar 2020 18:15:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgCFSPX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 Mar 2020 13:15:23 -0500
Received: from correo.us.es ([193.147.175.20]:40764 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726682AbgCFSPW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Mar 2020 13:15:22 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E8D9015AEB7
        for <netfilter-devel@vger.kernel.org>; Fri,  6 Mar 2020 19:15:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DA19ADA3A5
        for <netfilter-devel@vger.kernel.org>; Fri,  6 Mar 2020 19:15:03 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CF09BDA3A9; Fri,  6 Mar 2020 19:15:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B4867DA72F;
        Fri,  6 Mar 2020 19:15:01 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 06 Mar 2020 19:15:01 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 9014D4301DE0;
        Fri,  6 Mar 2020 19:15:01 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 04/11] netfilter: x_tables: xt_mttg_seq_next should increase position index
Date:   Fri,  6 Mar 2020 19:15:06 +0100
Message-Id: <20200306181513.656594-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200306181513.656594-1-pablo@netfilter.org>
References: <20200306181513.656594-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

If .next function does not change position index,
following .show function will repeat output related
to current position index.

Without patch:
 # dd if=/proc/net/ip_tables_matches  # original file output
 conntrack
 conntrack
 conntrack
 recent
 recent
 icmp
 udplite
 udp
 tcp
 0+1 records in
 0+1 records out
 65 bytes copied, 5.4074e-05 s, 1.2 MB/s

 # dd if=/proc/net/ip_tables_matches bs=62 skip=1
 dd: /proc/net/ip_tables_matches: cannot skip to specified offset
 cp   <<< end of  last line
 tcp  <<< and then unexpected whole last line once again
 0+1 records in
 0+1 records out
 7 bytes copied, 0.000102447 s, 68.3 kB/s

Cc: stable@vger.kernel.org
Fixes: 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code ...")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206283
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/x_tables.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index e27c6c5ba9df..cd2b034eef59 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1551,6 +1551,9 @@ static void *xt_mttg_seq_next(struct seq_file *seq, void *v, loff_t *ppos,
 	uint8_t nfproto = (unsigned long)PDE_DATA(file_inode(seq->file));
 	struct nf_mttg_trav *trav = seq->private;
 
+	if (ppos != NULL)
+		++(*ppos);
+
 	switch (trav->class) {
 	case MTTG_TRAV_INIT:
 		trav->class = MTTG_TRAV_NFP_UNSPEC;
@@ -1576,9 +1579,6 @@ static void *xt_mttg_seq_next(struct seq_file *seq, void *v, loff_t *ppos,
 	default:
 		return NULL;
 	}
-
-	if (ppos != NULL)
-		++*ppos;
 	return trav;
 }
 
-- 
2.11.0

