Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CA28C4332F
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Nov 2022 16:57:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234415AbiKVQ5X (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Nov 2022 11:57:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234423AbiKVQ5S (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Nov 2022 11:57:18 -0500
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E4D24769CA;
        Tue, 22 Nov 2022 08:57:11 -0800 (PST)
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id 29F7226124;
        Tue, 22 Nov 2022 18:57:11 +0200 (EET)
Received: from ink.ssi.bg (unknown [193.238.174.40])
        by mg.ssi.bg (Proxmox) with ESMTP id 4422126029;
        Tue, 22 Nov 2022 18:47:48 +0200 (EET)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id 079CA3C043F;
        Tue, 22 Nov 2022 18:47:17 +0200 (EET)
Received: from ja.home.ssi.bg (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.17.1/8.16.1) with ESMTP id 2AMGlHEI066797;
        Tue, 22 Nov 2022 18:47:17 +0200
Received: (from root@localhost)
        by ja.home.ssi.bg (8.17.1/8.17.1/Submit) id 2AMGlHQC066796;
        Tue, 22 Nov 2022 18:47:17 +0200
From:   Julian Anastasov <ja@ssi.bg>
To:     Simon Horman <horms@verge.net.au>
Cc:     lvs-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Jiri Wiesner <jwiesner@suse.de>,
        yunhong-cgl jiang <xintian1976@gmail.com>,
        dust.li@linux.alibaba.com
Subject: [PATCHv7 3/6] ipvs: use u64_stats_t for the per-cpu counters
Date:   Tue, 22 Nov 2022 18:46:01 +0200
Message-Id: <20221122164604.66621-4-ja@ssi.bg>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221122164604.66621-1-ja@ssi.bg>
References: <20221122164604.66621-1-ja@ssi.bg>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use the provided u64_stats_t type to avoid
load/store tearing.

Fixes: 316580b69d0a ("u64_stats: provide u64_stats_t type")
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Cc: yunhong-cgl jiang <xintian1976@gmail.com>
Cc: "dust.li" <dust.li@linux.alibaba.com>
Reviewed-by: Jiri Wiesner <jwiesner@suse.de>
Tested-by: Jiri Wiesner <jwiesner@suse.de>
---
 include/net/ip_vs.h             | 10 +++++-----
 net/netfilter/ipvs/ip_vs_core.c | 30 +++++++++++++++---------------
 net/netfilter/ipvs/ip_vs_ctl.c  | 10 +++++-----
 net/netfilter/ipvs/ip_vs_est.c  | 20 ++++++++++----------
 4 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index e5582c01a4a3..a4d44138c2a8 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -351,11 +351,11 @@ struct ip_vs_seq {
 
 /* counters per cpu */
 struct ip_vs_counters {
-	__u64		conns;		/* connections scheduled */
-	__u64		inpkts;		/* incoming packets */
-	__u64		outpkts;	/* outgoing packets */
-	__u64		inbytes;	/* incoming bytes */
-	__u64		outbytes;	/* outgoing bytes */
+	u64_stats_t	conns;		/* connections scheduled */
+	u64_stats_t	inpkts;		/* incoming packets */
+	u64_stats_t	outpkts;	/* outgoing packets */
+	u64_stats_t	inbytes;	/* incoming bytes */
+	u64_stats_t	outbytes;	/* outgoing bytes */
 };
 /* Stats per cpu */
 struct ip_vs_cpu_stats {
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index fcdaef1fcccf..2fcc26507d69 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -132,21 +132,21 @@ ip_vs_in_stats(struct ip_vs_conn *cp, struct sk_buff *skb)
 
 		s = this_cpu_ptr(dest->stats.cpustats);
 		u64_stats_update_begin(&s->syncp);
-		s->cnt.inpkts++;
-		s->cnt.inbytes += skb->len;
+		u64_stats_inc(&s->cnt.inpkts);
+		u64_stats_add(&s->cnt.inbytes, skb->len);
 		u64_stats_update_end(&s->syncp);
 
 		svc = rcu_dereference(dest->svc);
 		s = this_cpu_ptr(svc->stats.cpustats);
 		u64_stats_update_begin(&s->syncp);
-		s->cnt.inpkts++;
-		s->cnt.inbytes += skb->len;
+		u64_stats_inc(&s->cnt.inpkts);
+		u64_stats_add(&s->cnt.inbytes, skb->len);
 		u64_stats_update_end(&s->syncp);
 
 		s = this_cpu_ptr(ipvs->tot_stats->s.cpustats);
 		u64_stats_update_begin(&s->syncp);
-		s->cnt.inpkts++;
-		s->cnt.inbytes += skb->len;
+		u64_stats_inc(&s->cnt.inpkts);
+		u64_stats_add(&s->cnt.inbytes, skb->len);
 		u64_stats_update_end(&s->syncp);
 
 		local_bh_enable();
@@ -168,21 +168,21 @@ ip_vs_out_stats(struct ip_vs_conn *cp, struct sk_buff *skb)
 
 		s = this_cpu_ptr(dest->stats.cpustats);
 		u64_stats_update_begin(&s->syncp);
-		s->cnt.outpkts++;
-		s->cnt.outbytes += skb->len;
+		u64_stats_inc(&s->cnt.outpkts);
+		u64_stats_add(&s->cnt.outbytes, skb->len);
 		u64_stats_update_end(&s->syncp);
 
 		svc = rcu_dereference(dest->svc);
 		s = this_cpu_ptr(svc->stats.cpustats);
 		u64_stats_update_begin(&s->syncp);
-		s->cnt.outpkts++;
-		s->cnt.outbytes += skb->len;
+		u64_stats_inc(&s->cnt.outpkts);
+		u64_stats_add(&s->cnt.outbytes, skb->len);
 		u64_stats_update_end(&s->syncp);
 
 		s = this_cpu_ptr(ipvs->tot_stats->s.cpustats);
 		u64_stats_update_begin(&s->syncp);
-		s->cnt.outpkts++;
-		s->cnt.outbytes += skb->len;
+		u64_stats_inc(&s->cnt.outpkts);
+		u64_stats_add(&s->cnt.outbytes, skb->len);
 		u64_stats_update_end(&s->syncp);
 
 		local_bh_enable();
@@ -200,17 +200,17 @@ ip_vs_conn_stats(struct ip_vs_conn *cp, struct ip_vs_service *svc)
 
 	s = this_cpu_ptr(cp->dest->stats.cpustats);
 	u64_stats_update_begin(&s->syncp);
-	s->cnt.conns++;
+	u64_stats_inc(&s->cnt.conns);
 	u64_stats_update_end(&s->syncp);
 
 	s = this_cpu_ptr(svc->stats.cpustats);
 	u64_stats_update_begin(&s->syncp);
-	s->cnt.conns++;
+	u64_stats_inc(&s->cnt.conns);
 	u64_stats_update_end(&s->syncp);
 
 	s = this_cpu_ptr(ipvs->tot_stats->s.cpustats);
 	u64_stats_update_begin(&s->syncp);
-	s->cnt.conns++;
+	u64_stats_inc(&s->cnt.conns);
 	u64_stats_update_end(&s->syncp);
 
 	local_bh_enable();
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index ec6db864ac36..5f9cc2e7ba71 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2335,11 +2335,11 @@ static int ip_vs_stats_percpu_show(struct seq_file *seq, void *v)
 
 		do {
 			start = u64_stats_fetch_begin(&u->syncp);
-			conns = u->cnt.conns;
-			inpkts = u->cnt.inpkts;
-			outpkts = u->cnt.outpkts;
-			inbytes = u->cnt.inbytes;
-			outbytes = u->cnt.outbytes;
+			conns = u64_stats_read(&u->cnt.conns);
+			inpkts = u64_stats_read(&u->cnt.inpkts);
+			outpkts = u64_stats_read(&u->cnt.outpkts);
+			inbytes = u64_stats_read(&u->cnt.inbytes);
+			outbytes = u64_stats_read(&u->cnt.outbytes);
 		} while (u64_stats_fetch_retry(&u->syncp, start));
 
 		seq_printf(seq, "%3X %8LX %8LX %8LX %16LX %16LX\n",
diff --git a/net/netfilter/ipvs/ip_vs_est.c b/net/netfilter/ipvs/ip_vs_est.c
index 9a1a7af6a186..f53150d82a92 100644
--- a/net/netfilter/ipvs/ip_vs_est.c
+++ b/net/netfilter/ipvs/ip_vs_est.c
@@ -67,11 +67,11 @@ static void ip_vs_read_cpu_stats(struct ip_vs_kstats *sum,
 		if (add) {
 			do {
 				start = u64_stats_fetch_begin(&s->syncp);
-				conns = s->cnt.conns;
-				inpkts = s->cnt.inpkts;
-				outpkts = s->cnt.outpkts;
-				inbytes = s->cnt.inbytes;
-				outbytes = s->cnt.outbytes;
+				conns = u64_stats_read(&s->cnt.conns);
+				inpkts = u64_stats_read(&s->cnt.inpkts);
+				outpkts = u64_stats_read(&s->cnt.outpkts);
+				inbytes = u64_stats_read(&s->cnt.inbytes);
+				outbytes = u64_stats_read(&s->cnt.outbytes);
 			} while (u64_stats_fetch_retry(&s->syncp, start));
 			sum->conns += conns;
 			sum->inpkts += inpkts;
@@ -82,11 +82,11 @@ static void ip_vs_read_cpu_stats(struct ip_vs_kstats *sum,
 			add = true;
 			do {
 				start = u64_stats_fetch_begin(&s->syncp);
-				sum->conns = s->cnt.conns;
-				sum->inpkts = s->cnt.inpkts;
-				sum->outpkts = s->cnt.outpkts;
-				sum->inbytes = s->cnt.inbytes;
-				sum->outbytes = s->cnt.outbytes;
+				sum->conns = u64_stats_read(&s->cnt.conns);
+				sum->inpkts = u64_stats_read(&s->cnt.inpkts);
+				sum->outpkts = u64_stats_read(&s->cnt.outpkts);
+				sum->inbytes = u64_stats_read(&s->cnt.inbytes);
+				sum->outbytes = u64_stats_read(&s->cnt.outbytes);
 			} while (u64_stats_fetch_retry(&s->syncp, start));
 		}
 	}
-- 
2.38.1


