Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5466EC04A6A
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Aug 2023 01:58:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241155AbjHPB5o (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Aug 2023 21:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241164AbjHPB5S (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Aug 2023 21:57:18 -0400
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C8AB2129;
        Tue, 15 Aug 2023 18:57:16 -0700 (PDT)
Received: from mg.bb.i.ssi.bg (localhost [127.0.0.1])
        by mg.bb.i.ssi.bg (Proxmox) with ESMTP id 01EA612206;
        Wed, 16 Aug 2023 04:57:15 +0300 (EEST)
Received: from ink.ssi.bg (ink.ssi.bg [193.238.174.40])
        by mg.bb.i.ssi.bg (Proxmox) with ESMTPS id DEFEA12205;
        Wed, 16 Aug 2023 04:57:14 +0300 (EEST)
Received: from ja.ssi.bg (unknown [213.16.62.126])
        by ink.ssi.bg (Postfix) with ESMTPSA id 79BC73C07D0;
        Wed, 16 Aug 2023 04:57:08 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=ssi.bg; s=ink;
        t=1692151028; bh=YazX7hVaynCeD2nwGa3M0l3D0RDVSOrt/lYw/EJ1QRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=eZLapMqeEf+5uOZxUXQugARRBsrR51Ljy0Es5RuwTZ+zKzXcv/H8adOcEBdf2UsOO
         rxofGphD6tVPrVZG/xlQKA4egEJTuPJpkmt6kHxsngt+W1VLLvzPyBPGxlIaNinytA
         F24zNmmgLR5aRHcSIXuqDa0MpNk50ImRfDMjQRlU=
Received: from ja.home.ssi.bg (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.17.1/8.17.1) with ESMTP id 37FHWIOo168669;
        Tue, 15 Aug 2023 20:32:18 +0300
Received: (from root@localhost)
        by ja.home.ssi.bg (8.17.1/8.17.1/Submit) id 37FHWIZd168668;
        Tue, 15 Aug 2023 20:32:18 +0300
From:   Julian Anastasov <ja@ssi.bg>
To:     Simon Horman <horms@verge.net.au>
Cc:     lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, "Paul E . McKenney" <paulmck@kernel.org>,
        rcu@vger.kernel.org, Dust Li <dust.li@linux.alibaba.com>,
        Jiejian Wu <jiejian@linux.alibaba.com>,
        Jiri Wiesner <jwiesner@suse.de>
Subject: [PATCH RFC net-next 14/14] ipvs: add conn_lfactor and svc_lfactor sysctl vars
Date:   Tue, 15 Aug 2023 20:30:31 +0300
Message-ID: <20230815173031.168344-15-ja@ssi.bg>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230815173031.168344-1-ja@ssi.bg>
References: <20230815173031.168344-1-ja@ssi.bg>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Allow the default load factor for the connection and service tables
to be configured.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
---
 Documentation/networking/ipvs-sysctl.rst | 31 ++++++++++
 net/netfilter/ipvs/ip_vs_ctl.c           | 72 ++++++++++++++++++++++++
 2 files changed, 103 insertions(+)

diff --git a/Documentation/networking/ipvs-sysctl.rst b/Documentation/networking/ipvs-sysctl.rst
index 3fb5fa142eef..61fdc0ec4c39 100644
--- a/Documentation/networking/ipvs-sysctl.rst
+++ b/Documentation/networking/ipvs-sysctl.rst
@@ -29,6 +29,28 @@ backup_only - BOOLEAN
 	If set, disable the director function while the server is
 	in backup mode to avoid packet loops for DR/TUN methods.
 
+conn_lfactor - INTEGER
+	4 - default
+	Valid range: -8 (smaller table) .. 8 (larger table)
+
+	Controls the sizing of the connection hash table based on the
+	load factor (number of connections per table buckets).
+	As result, the table grows if load increases and shrinks when
+	load decreases in the range of 2^8 - 2^conn_tab_bits (module
+	parameter).
+	The value is a shift count where positive values select
+	buckets = (connection hash nodes << value) while negative
+	values select buckets = (connection hash nodes >> value). The
+	positive values reduce the collisions and reduce the time for
+	lookups but increase the table size. Negative values will
+	tolerate load above 100% when using smaller table is
+	preferred. If using NAT connections consider increasing the
+	value with one because they add two nodes in the hash table.
+
+	Example:
+	4: grow if load goes above 6% (buckets = nodes * 16)
+	-2: grow if load goes above 400% (buckets = nodes / 4)
+
 conn_reuse_mode - INTEGER
 	1 - default
 
@@ -219,6 +241,15 @@ secure_tcp - INTEGER
 	The value definition is the same as that of drop_entry and
 	drop_packet.
 
+svc_lfactor - INTEGER
+	3 - default
+	Valid range: -8 (smaller table) .. 8 (larger table)
+
+	Controls the sizing of the service hash table based on the
+	load factor (number of services per table buckets). The table
+	will grow and shrink in the range of 2^4 - 2^20.
+	See conn_lfactor for explanation.
+
 sync_threshold - vector of 2 INTEGERs: sync_threshold, sync_period
 	default 3 50
 
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 5b2a5e3bf309..ca21f4c64a45 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2427,6 +2427,60 @@ static int ipvs_proc_run_estimation(struct ctl_table *table, int write,
 	return ret;
 }
 
+static int ipvs_proc_conn_lfactor(struct ctl_table *table, int write,
+				  void *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct netns_ipvs *ipvs = table->extra2;
+	int *valp = table->data;
+	int val = *valp;
+	int ret;
+
+	struct ctl_table tmp_table = {
+		.data = &val,
+		.maxlen = sizeof(int),
+	};
+
+	ret = proc_dointvec(&tmp_table, write, buffer, lenp, ppos);
+	if (write && ret >= 0) {
+		if (val < -8 || val > 8) {
+			ret = -EINVAL;
+		} else {
+			*valp = val;
+			if (rcu_dereference_protected(ipvs->conn_tab, 1))
+				mod_delayed_work(system_unbound_wq,
+						 &ipvs->conn_resize_work, 0);
+		}
+	}
+	return ret;
+}
+
+static int ipvs_proc_svc_lfactor(struct ctl_table *table, int write,
+				 void *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct netns_ipvs *ipvs = table->extra2;
+	int *valp = table->data;
+	int val = *valp;
+	int ret;
+
+	struct ctl_table tmp_table = {
+		.data = &val,
+		.maxlen = sizeof(int),
+	};
+
+	ret = proc_dointvec(&tmp_table, write, buffer, lenp, ppos);
+	if (write && ret >= 0) {
+		if (val < -8 || val > 8) {
+			ret = -EINVAL;
+		} else {
+			*valp = val;
+			if (rcu_dereference_protected(ipvs->svc_table, 1))
+				mod_delayed_work(system_unbound_wq,
+						 &ipvs->svc_resize_work, 0);
+		}
+	}
+	return ret;
+}
+
 /*
  *	IPVS sysctl table (under the /proc/sys/net/ipv4/vs/)
  *	Do not change order or insert new entries without
@@ -2615,6 +2669,18 @@ static struct ctl_table vs_vars[] = {
 		.mode		= 0644,
 		.proc_handler	= ipvs_proc_est_nice,
 	},
+	{
+		.procname	= "conn_lfactor",
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= ipvs_proc_conn_lfactor,
+	},
+	{
+		.procname	= "svc_lfactor",
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= ipvs_proc_svc_lfactor,
+	},
 #ifdef CONFIG_IP_VS_DEBUG
 	{
 		.procname	= "debug_level",
@@ -4850,6 +4916,12 @@ static int __net_init ip_vs_control_net_init_sysctl(struct netns_ipvs *ipvs)
 	tbl[idx].extra2 = ipvs;
 	tbl[idx++].data = &ipvs->sysctl_est_nice;
 
+	tbl[idx].extra2 = ipvs;
+	tbl[idx++].data = &ipvs->sysctl_conn_lfactor;
+
+	tbl[idx].extra2 = ipvs;
+	tbl[idx++].data = &ipvs->sysctl_svc_lfactor;
+
 #ifdef CONFIG_IP_VS_DEBUG
 	/* Global sysctls must be ro in non-init netns */
 	if (!net_eq(net, &init_net))
-- 
2.41.0


