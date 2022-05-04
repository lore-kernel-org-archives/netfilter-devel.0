Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9E18C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 May 2022 01:10:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233133AbiEDBNg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 May 2022 21:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245082AbiEDBNY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 May 2022 21:13:24 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E3504507B
        for <netfilter-devel@vger.kernel.org>; Tue,  3 May 2022 18:09:12 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id fv2so16833205pjb.4
        for <netfilter-devel@vger.kernel.org>; Tue, 03 May 2022 18:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0y39QTxVkxEvhd0aRDakleJkJCfhBIdtoYr0OZYCOQA=;
        b=pCdbhR1JdAJ68iceolL+V3nE3BY02syoqZMpUPxM5Uu+20KR9ZuofSsPjb4aB+oVEU
         jn4olqUZ8YTjVuf36khReQWOSYwtvK8ZrAJ3f7aSomxSZ4uKD6JlaBojeF0a6Sl6O441
         ZD/LG44rYzpvfwLcq7NfPbhQYjHubg8DJmuverZos51WwnhZjjJ/qYeik1ShWSPGhLNQ
         2MCNS27my+c0SNWq5vFQ5fm9zxfaPY79d7/jRAtHGynLfSI+CwlCyXb5LQCBDLcdZgCz
         uGwAKtXV+ERFr01fk3tIiF31nc6dQUXP12513Ze5f047ScV20IYa9AGGoIQ7U7G4NjTr
         61ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0y39QTxVkxEvhd0aRDakleJkJCfhBIdtoYr0OZYCOQA=;
        b=AiqaEtMyOJTCZNtNJeGgRqW2LaCjEKpFcPiLKuZMng5kwjeyJefDCl9167u64gf9th
         ZfPYp6rtmUzCNJnq5BMfj/r8nrKQogUgNSR78GodWH2Px4YZiwZ2nHjPXVTbCP1UfcbC
         77MFaKBha6niQTysOSS8gypZZP1IaFGQm3ggxnUj1124X+hi1Sl8MvRSM863tNAWCsSm
         3mL+Ehg/U6xMbJ/0mVUo9U/vzVoWerhWD6UhCy+2nhwsCVId9Kft9kMjTGc5J5c1NLuC
         matoFmjqUZk/bPI4DRxyR9ZvG4DEqhz+qTspUSCd0xYggzdI/SJBBl+qObvOmMwzG9bd
         08nA==
X-Gm-Message-State: AOAM530mvAEyVuwDw0xzap/bSOG93GPFIHvJu+HPRPybp2cWT6u2MWdY
        uafTBVrEHFHzhvb4Q1zu2qrduEqxF09VHg==
X-Google-Smtp-Source: ABdhPJw5m/cD40DlKkiz7/zBfyvg96OcX3YLZtdDv1651G0jbyQjpLa2eE3FoXwDxpa3cpdjtiAUSQ==
X-Received: by 2002:a17:902:f789:b0:156:5f56:ddff with SMTP id q9-20020a170902f78900b001565f56ddffmr19615148pln.116.1651626548398;
        Tue, 03 May 2022 18:09:08 -0700 (PDT)
Received: from localhost.localdomain (c-67-160-105-174.hsd1.wa.comcast.net. [67.160.105.174])
        by smtp.gmail.com with ESMTPSA id d3-20020aa78143000000b0050dc76281b0sm6893100pfn.138.2022.05.03.18.09.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 May 2022 18:09:07 -0700 (PDT)
From:   William Tu <u9012063@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, Yifeng Sun <pkusunyifeng@gmail.com>,
        Greg Rose <gvrose8192@gmail.com>
Subject: [PATCH] netfilter: nf_conncount: reduce unnecessary GC
Date:   Tue,  3 May 2022 18:09:03 -0700
Message-Id: <20220504010903.24090-1-u9012063@gmail.com>
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

