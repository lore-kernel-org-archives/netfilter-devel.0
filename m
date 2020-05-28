Return-Path: <SRS0=RvX8=7K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B363EC433DF
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 May 2020 01:41:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D606207CB
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 May 2020 01:41:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UtVBQc/p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725920AbgE1Ble (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 May 2020 21:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbgE1Bld (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 May 2020 21:41:33 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE8BC05BD1E;
        Wed, 27 May 2020 18:41:33 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id g7so1684657qvx.11;
        Wed, 27 May 2020 18:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0UAuq4wVNFynRMDmAKu8+0PlLZ9xpiajh5Mx4cqmXb8=;
        b=UtVBQc/pv0LNaYVT3PxdeFRu6cNVsSN/0Q2hKXKTHh2OHGeh0P/e6CXLalXhGCeHBi
         y1DCcvKY5bEb6e0Ylhkn7mzE70HosL1Euv9ztYlbumTCJsnWEontoppmIhVukjBayMNN
         67wcnCrDUow5QHjuKma1wp7FFJdMMOc6lY/rk2isFbxnDayFlCXB2xxHtxjGLit0mx7M
         zpo6yZOyqnAzNRAJCwupiPT1GyQEtS0kzPJEt6Kh/HAdsTgHRtQUHN33e6L+0qE8Z3BQ
         x8DPo2RulGtW6kVoMDUFcUSuU1Wtqce8IHM2O4odwVe4wbLDqBAfiFWcSheQwJ1Wb93m
         WMmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0UAuq4wVNFynRMDmAKu8+0PlLZ9xpiajh5Mx4cqmXb8=;
        b=r1xBHzWxIfN9uOWyntxC9FHwq5Yoh3RwtSxPBdIdI58p+lj9IQwxj//i+LdlFl2ka9
         Afglf2NBljGI0lyugIPBVMJWYahdaO1lKwwAQndTVUlsJRfucTSRaUya7KqKx6GSXYbr
         VT5PxbKwVlB2OL+WYwWbZ/jhnUITcw0ZP0DN0TIKQwx0e0/RsKKt/J37jq5b2/tUEYot
         SkWftZzWNy0PFrAH76HfGAgdzh0MJ+f4NCsb44hx9SUk5vEgBBzaalbW0NbCTGZeSz01
         Z0M4oLQRUCUuLgq1X4lw4QuEsAcDmP/EivuB36iHF6cAa0PTamzFo6dxytK/su0iTArl
         x+Kg==
X-Gm-Message-State: AOAM530r8mw6ccZgbwBtH+i98VtUwA5d6W/qtwLnJFKT6Pwk0acU3d1+
        UKpAs3HzZwQbeW4NZg3WtWk=
X-Google-Smtp-Source: ABdhPJxXNsEaymkJw1Kz+48qSErJnuZJqOA09vi1ZZpD2YM4UpqmZlN01EuNHLjHNK57DW97XCz7CQ==
X-Received: by 2002:a05:6214:118e:: with SMTP id t14mr820347qvv.201.1590630092699;
        Wed, 27 May 2020 18:41:32 -0700 (PDT)
Received: from localhost.localdomain (toroon0411w-lp130-02-64-231-189-42.dsl.bell.ca. [64.231.189.42])
        by smtp.googlemail.com with ESMTPSA id l184sm3809399qke.115.2020.05.27.18.41.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 18:41:31 -0700 (PDT)
From:   Andrew Sy Kim <kim.andrewsy@gmail.com>
Cc:     Julian Anastasov <ja@ssi.bg>, Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Andrew Sy Kim <kim.andrewsy@gmail.com>
Subject: [PATCH] netfilter/ipvs: queue delayed work to expire no destination connections if expire_nodest_conn=1
Date:   Wed, 27 May 2020 21:41:02 -0400
Message-Id: <20200528014102.32357-1-kim.andrewsy@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <CABc050Hq9hKRHqAM2oNp9e756ASiEHNyU7g3TFqwi2VCmSGB2A@mail.gmail.com>
References: <CABc050Hq9hKRHqAM2oNp9e756ASiEHNyU7g3TFqwi2VCmSGB2A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When expire_nodest_conn=1 and a destination is deleted, IPVS does not
expire the existing connections until the next matching incoming packet.
If there are many connection entries from a single client to a single
destination, many packets may get dropped before all the connections are
expired (more likely with lots of UDP traffic). An optimization can be
made where upon deletion of a destination, IPVS queues up delayed work
to immediately expire any connections with a deleted destination. This
ensures any reused source ports from a client (within the IPVS timeouts)
are scheduled to new real servers instead of silently dropped.

Signed-off-by: Andrew Sy Kim <kim.andrewsy@gmail.com>
---
 include/net/ip_vs.h             |  9 ++++++
 net/netfilter/ipvs/ip_vs_conn.c | 53 +++++++++++++++++++++++++++++++++
 net/netfilter/ipvs/ip_vs_core.c | 44 +++++++++++----------------
 net/netfilter/ipvs/ip_vs_ctl.c  | 12 ++++++++
 4 files changed, 92 insertions(+), 26 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 83be2d93b407..1636100f7da5 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -884,6 +884,9 @@ struct netns_ipvs {
 	atomic_t		nullsvc_counter;
 	atomic_t		conn_out_counter;
 
+	/* delayed work for expiring no dest connections */
+	struct delayed_work	expire_nodest_conn_work;
+
 #ifdef CONFIG_SYSCTL
 	/* 1/rate drop and drop-entry variables */
 	struct delayed_work	defense_work;   /* Work handler */
@@ -1049,6 +1052,11 @@ static inline int sysctl_conn_reuse_mode(struct netns_ipvs *ipvs)
 	return ipvs->sysctl_conn_reuse_mode;
 }
 
+static inline int sysctl_expire_nodest_conn(struct netns_ipvs *ipvs)
+{
+	return ipvs->sysctl_expire_nodest_conn;
+}
+
 static inline int sysctl_schedule_icmp(struct netns_ipvs *ipvs)
 {
 	return ipvs->sysctl_schedule_icmp;
@@ -1232,6 +1240,7 @@ struct ip_vs_conn *ip_vs_conn_new(const struct ip_vs_conn_param *p, int dest_af,
 				  __be16 dport, unsigned int flags,
 				  struct ip_vs_dest *dest, __u32 fwmark);
 void ip_vs_conn_expire_now(struct ip_vs_conn *cp);
+void expire_nodest_conn_handler(struct work_struct *work);
 
 const char *ip_vs_state_name(const struct ip_vs_conn *cp);
 
diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 02f2f636798d..5e802b7fabbb 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -28,6 +28,7 @@
 #include <linux/module.h>
 #include <linux/vmalloc.h>
 #include <linux/proc_fs.h>		/* for proc_net_* */
+#include <linux/workqueue.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
 #include <linux/jhash.h>
@@ -1366,6 +1367,58 @@ static void ip_vs_conn_flush(struct netns_ipvs *ipvs)
 		goto flush_again;
 	}
 }
+
+/*	Handler for delayed work for expiring no
+ *	destination connections
+ */
+void expire_nodest_conn_handler(struct work_struct *work)
+{
+	int idx;
+	struct ip_vs_conn *cp, *cp_c;
+	struct ip_vs_dest *dest;
+	struct netns_ipvs *ipvs;
+
+	ipvs = container_of(work, struct netns_ipvs,
+			    expire_nodest_conn_work.work);
+
+	/* netns clean up started, aborted delayed work */
+	if (!ipvs->enable)
+		return;
+
+	/* only start delayed work if expire_nodest_conn=1 */
+	if (!ipvs->sysctl_expire_nodest_conn)
+		return;
+
+	rcu_read_lock();
+	for (idx = 0; idx < ip_vs_conn_tab_size; idx++) {
+		hlist_for_each_entry_rcu(cp, &ip_vs_conn_tab[idx], c_list) {
+			if (cp->ipvs != ipvs)
+				continue;
+
+			dest = cp->dest;
+			if (!dest || (dest->flags & IP_VS_DEST_F_AVAILABLE))
+				continue;
+
+			/* As timers are expired in LIFO order, restart
+			 * the timer of controlling connection first, so
+			 * that it is expired after us.
+			 */
+			cp_c = cp->control;
+			/* cp->control is valid only with reference to cp */
+			if (cp_c && __ip_vs_conn_get(cp)) {
+				IP_VS_DBG(4, "del controlling connection\n");
+				ip_vs_conn_expire_now(cp_c);
+				__ip_vs_conn_put(cp);
+			}
+
+			IP_VS_DBG(4, "del connection\n");
+			ip_vs_conn_expire_now(cp);
+		}
+		cond_resched_rcu();
+	}
+	rcu_read_unlock();
+}
+
 /*
  * per netns init and exit
  */
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index aa6a603a2425..c8389936d51a 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -694,11 +694,6 @@ static int sysctl_nat_icmp_send(struct netns_ipvs *ipvs)
 	return ipvs->sysctl_nat_icmp_send;
 }
 
-static int sysctl_expire_nodest_conn(struct netns_ipvs *ipvs)
-{
-	return ipvs->sysctl_expire_nodest_conn;
-}
-
 #else
 
 static int sysctl_snat_reroute(struct netns_ipvs *ipvs) { return 0; }
@@ -2095,36 +2090,33 @@ ip_vs_in(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, int
 		}
 	}
 
-	if (unlikely(!cp)) {
-		int v;
-
-		if (!ip_vs_try_to_schedule(ipvs, af, skb, pd, &v, &cp, &iph))
-			return v;
-	}
-
-	IP_VS_DBG_PKT(11, af, pp, skb, iph.off, "Incoming packet");
-
 	/* Check the server status */
-	if (cp->dest && !(cp->dest->flags & IP_VS_DEST_F_AVAILABLE)) {
+	if (cp && cp->dest && !(cp->dest->flags & IP_VS_DEST_F_AVAILABLE)) {
 		/* the destination server is not available */
 
-		__u32 flags = cp->flags;
-
-		/* when timer already started, silently drop the packet.*/
-		if (timer_pending(&cp->timer))
-			__ip_vs_conn_put(cp);
-		else
-			ip_vs_conn_put(cp);
+		if (sysctl_expire_nodest_conn(ipvs)) {
+			bool uses_ct = ip_vs_conn_uses_conntrack(cp, skb);
 
-		if (sysctl_expire_nodest_conn(ipvs) &&
-		    !(flags & IP_VS_CONN_F_ONE_PACKET)) {
-			/* try to expire the connection immediately */
 			ip_vs_conn_expire_now(cp);
+			__ip_vs_conn_put(cp);
+			if (uses_ct)
+				return NF_DROP;
+			cp = NULL;
+		} else {
+			__ip_vs_conn_put(cp);
+			return NF_DROP;
 		}
+	}
 
-		return NF_DROP;
+	if (unlikely(!cp)) {
+		int v;
+
+		if (!ip_vs_try_to_schedule(ipvs, af, skb, pd, &v, &cp, &iph))
+			return v;
 	}
 
+	IP_VS_DBG_PKT(11, af, pp, skb, iph.off, "Incoming packet");
+
 	ip_vs_in_stats(cp, skb);
 	ip_vs_set_state(cp, IP_VS_DIR_INPUT, skb, pd);
 	if (cp->packet_xmit)
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 8d14a1acbc37..6eb1afa30c74 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -1163,6 +1163,13 @@ static void __ip_vs_del_dest(struct netns_ipvs *ipvs, struct ip_vs_dest *dest,
 	list_add(&dest->t_list, &ipvs->dest_trash);
 	dest->idle_start = 0;
 	spin_unlock_bh(&ipvs->dest_trash_lock);
+
+	/*	If expire_nodest_conn is enabled and we're not cleaning up,
+	 *	queue up delayed work to expire all no destination connections
+	 */
+	if (sysctl_expire_nodest_conn(ipvs) && !cleanup)
+		queue_delayed_work(system_long_wq,
+				   &ipvs->expire_nodest_conn_work, 1);
 }
 
 
@@ -4065,6 +4072,10 @@ static int __net_init ip_vs_control_net_init_sysctl(struct netns_ipvs *ipvs)
 	INIT_DELAYED_WORK(&ipvs->defense_work, defense_work_handler);
 	schedule_delayed_work(&ipvs->defense_work, DEFENSE_TIMER_PERIOD);
 
+	/* Init delayed work for expiring no dest conn */
+	INIT_DELAYED_WORK(&ipvs->expire_nodest_conn_work,
+			  expire_nodest_conn_handler);
+
 	return 0;
 }
 
@@ -4072,6 +4083,7 @@ static void __net_exit ip_vs_control_net_cleanup_sysctl(struct netns_ipvs *ipvs)
 {
 	struct net *net = ipvs->net;
 
+	cancel_delayed_work_sync(&ipvs->expire_nodest_conn_work);
 	cancel_delayed_work_sync(&ipvs->defense_work);
 	cancel_work_sync(&ipvs->defense_work.work);
 	unregister_net_sysctl_table(ipvs->sysctl_hdr);
-- 
2.20.1

