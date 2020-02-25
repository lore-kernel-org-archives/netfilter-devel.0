Return-Path: <SRS0=2ZCu=4N=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A7D9C35DF5
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Feb 2020 07:07:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E16DD2082F
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Feb 2020 07:07:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729169AbgBYHHP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Feb 2020 02:07:15 -0500
Received: from relay.sw.ru ([185.231.240.75]:40350 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729131AbgBYHHP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Feb 2020 02:07:15 -0500
Received: from vvs-ws.sw.ru ([172.16.24.21])
        by relay.sw.ru with esmtp (Exim 4.92.3)
        (envelope-from <vvs@virtuozzo.com>)
        id 1j6UJF-0004s3-8p; Tue, 25 Feb 2020 10:07:13 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v2 4/4] xt_mttg_seq_next should increase position index
To:     coreteam@netfilter.org, netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
References: <497a82c1-7b6a-adf4-a4ce-df46fe436aae@virtuozzo.com>
Message-ID: <c47c76a1-4c2f-c7a6-e04a-0651e19c4718@virtuozzo.com>
Date:   Tue, 25 Feb 2020 10:07:12 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <497a82c1-7b6a-adf4-a4ce-df46fe436aae@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

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
---
 net/netfilter/x_tables.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index e27c6c5..cd2b034 100644
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
1.8.3.1

