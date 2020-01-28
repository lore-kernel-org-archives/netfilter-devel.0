Return-Path: <SRS0=fFh5=3R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54F94C2D0DB
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jan 2020 19:16:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 338712173E
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jan 2020 19:16:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgA1TQa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Jan 2020 14:16:30 -0500
Received: from smtprelay0094.hostedemail.com ([216.40.44.94]:55440 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726002AbgA1TQ3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Jan 2020 14:16:29 -0500
X-Greylist: delayed 474 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Jan 2020 14:16:29 EST
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave04.hostedemail.com (Postfix) with ESMTP id 6005B1801665A
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jan 2020 19:08:36 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 94DD918225DF9;
        Tue, 28 Jan 2020 19:08:34 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: brush21_4aa0e106f0634
X-Filterd-Recvd-Size: 2518
Received: from XPS-9350.home (unknown [47.151.135.224])
        (Authenticated sender: joe@perches.com)
        by omf18.hostedemail.com (Postfix) with ESMTPA;
        Tue, 28 Jan 2020 19:08:32 +0000 (UTC)
Message-ID: <5a01f309d91c35fa10b8faa60f4b84a8cb7d13b0.camel@perches.com>
Subject: [PATCH] netfilter: Use kvcalloc
From:   Joe Perches <joe@perches.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Date:   Tue, 28 Jan 2020 11:07:27 -0800
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Convert the uses of kvmalloc_array with __GFP_ZERO to
the equivalent kvcalloc.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/netfilter/nf_conntrack_core.c | 3 +--
 net/netfilter/x_tables.c          | 4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index f4c4b46..d13054 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2248,8 +2248,7 @@ void *nf_ct_alloc_hashtable(unsigned int *sizep, int nulls)
 	BUILD_BUG_ON(sizeof(struct hlist_nulls_head) != sizeof(struct hlist_head));
 	nr_slots = *sizep = roundup(*sizep, PAGE_SIZE / sizeof(struct hlist_nulls_head));
 
-	hash = kvmalloc_array(nr_slots, sizeof(struct hlist_nulls_head),
-			      GFP_KERNEL | __GFP_ZERO);
+	hash = kvcalloc(nr_slots, sizeof(struct hlist_nulls_head), GFP_KERNEL);
 
 	if (hash && nulls)
 		for (i = 0; i < nr_slots; i++)
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index ce70c25..e27c6c5 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -939,14 +939,14 @@ EXPORT_SYMBOL(xt_check_entry_offsets);
  *
  * @size: number of entries
  *
- * Return: NULL or kmalloc'd or vmalloc'd array
+ * Return: NULL or zeroed kmalloc'd or vmalloc'd array
  */
 unsigned int *xt_alloc_entry_offsets(unsigned int size)
 {
 	if (size > XT_MAX_TABLE_SIZE / sizeof(unsigned int))
 		return NULL;
 
-	return kvmalloc_array(size, sizeof(unsigned int), GFP_KERNEL | __GFP_ZERO);
+	return kvcalloc(size, sizeof(unsigned int), GFP_KERNEL);
 
 }
 EXPORT_SYMBOL(xt_alloc_entry_offsets);


