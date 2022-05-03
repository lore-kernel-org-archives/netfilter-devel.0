Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88C24C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 May 2022 21:52:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234537AbiECV4Y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 May 2022 17:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbiECV4W (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 May 2022 17:56:22 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 627523A731
        for <netfilter-devel@vger.kernel.org>; Tue,  3 May 2022 14:52:48 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id q76so11973984pgq.10
        for <netfilter-devel@vger.kernel.org>; Tue, 03 May 2022 14:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0y39QTxVkxEvhd0aRDakleJkJCfhBIdtoYr0OZYCOQA=;
        b=jEACdNcU+SBJrsIO9PJUWqcM+ywrbzAYxey+poVeB5X7v3yUvQuTv+EqOSFrh5m8/r
         xC7vokjaKxoUBgxv2Qq7sMkbHrJexpH9MY+8IZyqx9e4OtdBhMDd1qP5nD1NxlSB/tbi
         bP+g4sj0APiU7ohbGLAuBanPxtiMW004Z+420CiSLrTl+wv4Wxv/0Ovs1ELSv3nsT1ZO
         UyZXVqbfI/dpr0LMebWq9RK4EGRvHxY1DKyNqTKeMgkm8C3qAsg//dMW9t4y6jM/RxkF
         S/nddT5pFF73YrGLOuzcqnyn1VcXdEYmfuC2ZTtHuefathO/azReHycVsYojk8cuQZM8
         gAyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0y39QTxVkxEvhd0aRDakleJkJCfhBIdtoYr0OZYCOQA=;
        b=0VLaYnIT4Nq5jdbl1MGzHtem2C7Hdy+uTdOnaTwyW2fXEp+Q+nc9BP2Mqa9OgSZUcr
         n8hvfhGzxteLHJhmYDvy8n/VUsBG/2bGrCiOLQEDDwZH1F8GRk9d2nM6uvMCyLylgW8b
         vwncNHS1HdKnTDU5L24wXZcURMXxw8IiGUNjMlW/Q2cWaWvWey/Xcx9il4obCARl0FWc
         k93NQ6R+JfG2fOjQBw358421N7/CXNx+GtCNJBGNg2EHHTbsvNs1tfdnxg/UIoR0OIF9
         AVMzmovy3vo8V4ujCiNlTEicfOIMYcqiIm4vzBsBGBMuWUMI8ZBC0fsuqy2Og3eMmt5w
         lW/A==
X-Gm-Message-State: AOAM5307HWrGGpXyP0NfZ9UJ5/MqiYx2ZD10O9SEwBIJ6vGLtr/CdJ9o
        CJX9fDRilo2CYAA0w5+8PECNMjbbcTg=
X-Google-Smtp-Source: ABdhPJyutv2tmry75ImZkSpZrN/mVEuo5bTOpJEnyE59BLLlxAJn/r/NwD+fNy6841ibYZ1qDQznWQ==
X-Received: by 2002:a63:34cd:0:b0:3ab:a3e8:7b48 with SMTP id b196-20020a6334cd000000b003aba3e87b48mr15635880pga.524.1651614767504;
        Tue, 03 May 2022 14:52:47 -0700 (PDT)
Received: from tuc-a02.vmware.com.com (c-67-160-105-174.hsd1.wa.comcast.net. [67.160.105.174])
        by smtp.gmail.com with ESMTPSA id x186-20020a6363c3000000b003c14af505f6sm13211523pgb.14.2022.05.03.14.52.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 May 2022 14:52:46 -0700 (PDT)
From:   William Tu <u9012063@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, Yifeng Sun <pkusunyifeng@gmail.com>,
        Greg Rose <gvrose8192@gmail.com>
Subject: [PATCH] netfilter: nf_conncount: reduce unnecessary GC
Date:   Tue,  3 May 2022 14:52:37 -0700
Message-Id: <20220503215237.98485-1-u9012063@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Currently nf_conncount can trigger garbage collection (GC)
at multiple places. Each GC process takes a spin_lock_bh
to traverse the nf_conncount_list. We found that when testing
port scanning use two parallel nmap, because the number of
connection increase fast, the nf_conncount_count and its
subsequent call to __nf_conncount_add take too much time,
causing several CPU lockup. This happens when user set the
conntrack limit to +20,000, because the larger the limit,
the longer the list that GC has to traverse.

The patch mitigate the performance issue by avoiding unnecessary
GC with a timestamp. Whenever nf_conncount has done a GC,
a timestamp is updated, and beforce the next time GC is
triggered, we make sure it's more than a jiffies.
By doin this we can greatly reduce the CPU cycles and
avoid the softirq lockup.

To reproduce it in OVS,
$ ovs-appctl dpctl/ct-set-limits zone=1,limit=20000
$ ovs-appctl dpctl/ct-get-limits

At another machine, runs two nmap
$ nmap -p1- <IP>
$ nmap -p1- <IP>

Signed-off-by: William Tu <u9012063@gmail.com>
Co-authored-by: Yifeng Sun <pkusunyifeng@gmail.com>
Reported-by: Greg Rose <gvrose8192@gmail.com>
Suggested-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack_count.h |  1 +
 net/netfilter/nf_conncount.c               | 12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/include/net/netfilter/nf_conntrack_count.h b/include/net/netfilter/nf_conntrack_count.h
index 9645b47fa7e4..f39070d3e17f 100644
--- a/include/net/netfilter/nf_conntrack_count.h
+++ b/include/net/netfilter/nf_conntrack_count.h
@@ -12,6 +12,7 @@ struct nf_conncount_list {
 	spinlock_t list_lock;
 	struct list_head head;	/* connections with the same filtering key */
 	unsigned int count;	/* length of list */
+	unsigned long last_gc;	/* jiffies at most recent gc */
 };
 
 struct nf_conncount_data *nf_conncount_init(struct net *net, unsigned int family,
diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 82f36beb2e76..6480711ecd44 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -134,6 +134,9 @@ static int __nf_conncount_add(struct net *net,
 
 	/* check the saved connections */
 	list_for_each_entry_safe(conn, conn_n, &list->head, node) {
+		if (time_after_eq(list->last_gc, jiffies))
+			break;
+
 		if (collect > CONNCOUNT_GC_MAX_NODES)
 			break;
 
@@ -190,6 +193,7 @@ static int __nf_conncount_add(struct net *net,
 	conn->jiffies32 = (u32)jiffies;
 	list_add_tail(&conn->node, &list->head);
 	list->count++;
+	list->last_gc = jiffies;
 	return 0;
 }
 
@@ -214,6 +218,7 @@ void nf_conncount_list_init(struct nf_conncount_list *list)
 	spin_lock_init(&list->list_lock);
 	INIT_LIST_HEAD(&list->head);
 	list->count = 0;
+	list->last_gc = jiffies;
 }
 EXPORT_SYMBOL_GPL(nf_conncount_list_init);
 
@@ -231,6 +236,12 @@ bool nf_conncount_gc_list(struct net *net,
 	if (!spin_trylock(&list->list_lock))
 		return false;
 
+	/* don't bother if we just done GC */
+	if (time_after_eq(list->last_gc, jiffies)) {
+		spin_unlock(&list->list_lock);
+		return false;
+	}
+
 	list_for_each_entry_safe(conn, conn_n, &list->head, node) {
 		found = find_or_evict(net, list, conn);
 		if (IS_ERR(found)) {
@@ -258,6 +269,7 @@ bool nf_conncount_gc_list(struct net *net,
 
 	if (!list->count)
 		ret = true;
+	list->last_gc = jiffies;
 	spin_unlock(&list->list_lock);
 
 	return ret;
-- 
2.30.1 (Apple Git-130)

