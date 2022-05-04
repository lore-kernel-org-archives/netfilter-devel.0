Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29C08C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 May 2022 15:36:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236890AbiEDPjo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 May 2022 11:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352227AbiEDPjo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 May 2022 11:39:44 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C5F15739
        for <netfilter-devel@vger.kernel.org>; Wed,  4 May 2022 08:36:05 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id j8-20020a17090a060800b001cd4fb60dccso1552873pjj.2
        for <netfilter-devel@vger.kernel.org>; Wed, 04 May 2022 08:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pkxrHygfEKJKJx+Pka4Sp5z+QSkICosHCCoCE4DENSU=;
        b=jLNgPv4J6YsytAo6OgFyjdwainPpXg3ouHkMmPAyB44z7qcY7b94W62o7BITNYjTnn
         6V2K//ITM7UQ3fzm6mvLcQXvIiRDwU+EmYYIHbmN2rKhgfXTdjwrFPU9VoaSWQMxWfCU
         HYq3ObT6/AQeGTmo69wY276N0skFKtuIvQYSKd7msa596Nq42gocY+C11uaq45ig7ZdH
         pp3lVCl3LaRobdp0aswCx6dOkTjSnQQjFRbBkzIkbFq3TDQYdsq4SSbSPLwzt313Ay3r
         F6uDjzqmYzvYgPeyI1F8Fg7XXT0bRQHJa2RirRb2GrRMgDodm81jGR0+/fS+89QqUqpa
         urxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pkxrHygfEKJKJx+Pka4Sp5z+QSkICosHCCoCE4DENSU=;
        b=qfC6APLsp13PVrW3qfmc5a1o7ewdo0mbTlVQYWiwnq0u/IUzXFiGcusNb9nZiAaV2/
         QDwnAJnVqjFzJTNk42IYGyixBeSlDYWRcYf0xYIfJZtFLRiZaIP0l8S4XUBAsMJCydGz
         VtJ4O9io5CK1xG9GKxLJQGxCl3PbpjBgMThdqOWDLBc+MF4WCkdtTHTjqqlc3A6JxtBc
         rSiOHfF/1iAdBe+6SJH/MEfsMblE9MFoA8sQw2g62cfXT7r9USguqLm3ffCnwOU9UeGh
         yUTMGWUgBC9LgOn8idYWEJ1nusdnzWs4rZWFVNkVoBkWfljYZCGtwosNmr+e6C/1ITOi
         vEBA==
X-Gm-Message-State: AOAM530eOAC8XIKbP39aZaRR9ost8sas+44NoZICLDhKpmswLfgKuS1y
        Ammc80oyqmNW+XORexJwK3msaLTk/jmE0Q==
X-Google-Smtp-Source: ABdhPJwiyfx2WXKZed0eA2BuvxOrgw8567mI8RS6ez1HF1zvf8vRLo+T+Sllno8K9XSBz1T3LccXOQ==
X-Received: by 2002:a17:902:f28b:b0:15c:5c21:dc15 with SMTP id k11-20020a170902f28b00b0015c5c21dc15mr22492467plc.16.1651678564613;
        Wed, 04 May 2022 08:36:04 -0700 (PDT)
Received: from tuc-a02.vmware.com.com (c-67-160-105-174.hsd1.wa.comcast.net. [67.160.105.174])
        by smtp.gmail.com with ESMTPSA id c8-20020a170903234800b0015e8d4eb296sm2754045plh.224.2022.05.04.08.36.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 May 2022 08:36:03 -0700 (PDT)
From:   William Tu <u9012063@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Yifeng Sun <pkusunyifeng@gmail.com>,
        Greg Rose <gvrose8192@gmail.com>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCHv2] netfilter: nf_conncount: reduce unnecessary GC
Date:   Wed,  4 May 2022 08:35:59 -0700
Message-Id: <20220504153559.74263-1-u9012063@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220504010903.24090-1-u9012063@gmail.com>
References: <20220504010903.24090-1-u9012063@gmail.com>
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
v2:
- use u32 jiffies in struct nf_conncount_list
  now its 4-byte list_lock followed by 4-byte last_ct
- move the timestamp check before lock at
  nf_conncount_gc_list and use READ_ONCE
- move the timestamp check out of list for each loop
  in __nf_conncount_add
---
 include/net/netfilter/nf_conntrack_count.h |  1 +
 net/netfilter/nf_conncount.c               | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/include/net/netfilter/nf_conntrack_count.h b/include/net/netfilter/nf_conntrack_count.h
index 9645b47fa7e4..e227d997fc71 100644
--- a/include/net/netfilter/nf_conntrack_count.h
+++ b/include/net/netfilter/nf_conntrack_count.h
@@ -10,6 +10,7 @@ struct nf_conncount_data;
 
 struct nf_conncount_list {
 	spinlock_t list_lock;
+	u32 last_gc;		/* jiffies at most recent gc */
 	struct list_head head;	/* connections with the same filtering key */
 	unsigned int count;	/* length of list */
 };
diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 82f36beb2e76..5d8ed6c90b7e 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -132,6 +132,9 @@ static int __nf_conncount_add(struct net *net,
 	struct nf_conn *found_ct;
 	unsigned int collect = 0;
 
+	if (time_is_after_eq_jiffies((unsigned long)list->last_gc))
+		goto add_new_node;
+
 	/* check the saved connections */
 	list_for_each_entry_safe(conn, conn_n, &list->head, node) {
 		if (collect > CONNCOUNT_GC_MAX_NODES)
@@ -177,6 +180,7 @@ static int __nf_conncount_add(struct net *net,
 		nf_ct_put(found_ct);
 	}
 
+add_new_node:
 	if (WARN_ON_ONCE(list->count > INT_MAX))
 		return -EOVERFLOW;
 
@@ -190,6 +194,7 @@ static int __nf_conncount_add(struct net *net,
 	conn->jiffies32 = (u32)jiffies;
 	list_add_tail(&conn->node, &list->head);
 	list->count++;
+	list->last_gc = (u32)jiffies;
 	return 0;
 }
 
@@ -214,6 +219,7 @@ void nf_conncount_list_init(struct nf_conncount_list *list)
 	spin_lock_init(&list->list_lock);
 	INIT_LIST_HEAD(&list->head);
 	list->count = 0;
+	list->last_gc = (u32)jiffies;
 }
 EXPORT_SYMBOL_GPL(nf_conncount_list_init);
 
@@ -227,6 +233,10 @@ bool nf_conncount_gc_list(struct net *net,
 	unsigned int collected = 0;
 	bool ret = false;
 
+	/* don't bother if we just did GC */
+	if (time_is_after_eq_jiffies((unsigned long)READ_ONCE(list->last_gc)))
+		return false;
+
 	/* don't bother if other cpu is already doing GC */
 	if (!spin_trylock(&list->list_lock))
 		return false;
@@ -258,6 +268,7 @@ bool nf_conncount_gc_list(struct net *net,
 
 	if (!list->count)
 		ret = true;
+	list->last_gc = (u32)jiffies;
 	spin_unlock(&list->list_lock);
 
 	return ret;
-- 
2.30.1 (Apple Git-130)

