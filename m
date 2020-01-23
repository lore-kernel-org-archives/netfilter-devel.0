Return-Path: <SRS0=Vl9M=3M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F35E6C33CAA
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jan 2020 07:25:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFD9A217F4
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jan 2020 07:25:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbgAWHZn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jan 2020 02:25:43 -0500
Received: from relay.sw.ru ([185.231.240.75]:36714 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726029AbgAWHZn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jan 2020 02:25:43 -0500
Received: from vvs-ws.sw.ru ([172.16.24.21])
        by relay.sw.ru with esmtp (Exim 4.92.3)
        (envelope-from <vvs@virtuozzo.com>)
        id 1iuWs1-0005xG-1a; Thu, 23 Jan 2020 10:25:41 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH 3/4] recent_seq_next should increase position index
To:     coreteam@netfilter.org, netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Message-ID: <2d823164-5254-d878-d0d4-4d06b5b5b404@virtuozzo.com>
Date:   Thu, 23 Jan 2020 10:25:40 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

if seq_file .next fuction does not change position index,
read after some lseek can generate unexpected output.

https://bugzilla.kernel.org/show_bug.cgi?id=206283
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/netfilter/xt_recent.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 781e0b4..6c2582a 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -492,12 +492,12 @@ static void *recent_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 	const struct recent_entry *e = v;
 	const struct list_head *head = e->list.next;
 
+	(*pos)++;
 	while (head == &t->iphash[st->bucket]) {
 		if (++st->bucket >= ip_list_hash_size)
 			return NULL;
 		head = t->iphash[st->bucket].next;
 	}
-	(*pos)++;
 	return list_entry(head, struct recent_entry, list);
 }
 
-- 
1.8.3.1

