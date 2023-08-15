Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 626F0C41513
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Aug 2023 01:58:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241151AbjHPB5n (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Aug 2023 21:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241152AbjHPB5O (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Aug 2023 21:57:14 -0400
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A64010D1;
        Tue, 15 Aug 2023 18:57:12 -0700 (PDT)
Received: from mg.bb.i.ssi.bg (localhost [127.0.0.1])
        by mg.bb.i.ssi.bg (Proxmox) with ESMTP id B417F12203;
        Wed, 16 Aug 2023 04:57:10 +0300 (EEST)
Received: from ink.ssi.bg (ink.ssi.bg [193.238.174.40])
        by mg.bb.i.ssi.bg (Proxmox) with ESMTPS id 9CA5811EFE;
        Wed, 16 Aug 2023 04:57:10 +0300 (EEST)
Received: from ja.ssi.bg (unknown [213.16.62.126])
        by ink.ssi.bg (Postfix) with ESMTPSA id 2D7713C07CF;
        Wed, 16 Aug 2023 04:57:07 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=ssi.bg; s=ink;
        t=1692151028; bh=1R8mK5Q/gtSqFtNIgEb88jvYBoCfYiZn9A3SO+6MGaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=lbwC4WGNwaNEHm3FNmmI89pb7DH+sHfS9LjkA6okpzBbOh7YvTESKIESyldGIqoi6
         F5XcZ/MK4OYjL1dyAT54wKKXRwgOmuYF6nSTH0+zTptE3qttZMn2z7kg6XeyPJZ4oL
         eeb7RjvzYwfyrIAxgdYs8EFiDNn8/I1x1YlDQk3A=
Received: from ja.home.ssi.bg (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.17.1/8.17.1) with ESMTP id 37FHWHrI168651;
        Tue, 15 Aug 2023 20:32:17 +0300
Received: (from root@localhost)
        by ja.home.ssi.bg (8.17.1/8.17.1/Submit) id 37FHWHsD168650;
        Tue, 15 Aug 2023 20:32:17 +0300
From:   Julian Anastasov <ja@ssi.bg>
To:     Simon Horman <horms@verge.net.au>
Cc:     lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, "Paul E . McKenney" <paulmck@kernel.org>,
        rcu@vger.kernel.org, Dust Li <dust.li@linux.alibaba.com>,
        Jiejian Wu <jiejian@linux.alibaba.com>,
        Jiri Wiesner <jwiesner@suse.de>
Subject: [PATCH RFC net-next 10/14] ipvs: show the current conn_tab size to users
Date:   Tue, 15 Aug 2023 20:30:27 +0300
Message-ID: <20230815173031.168344-11-ja@ssi.bg>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230815173031.168344-1-ja@ssi.bg>
References: <20230815173031.168344-1-ja@ssi.bg>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

As conn_tab is per-net, better to show the current hash table size
to users instead of the ip_vs_conn_tab_size (max).

Signed-off-by: Julian Anastasov <ja@ssi.bg>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 36 +++++++++++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 8d994847b44a..43057b81c924 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2738,10 +2738,16 @@ static void ip_vs_info_seq_stop(struct seq_file *seq, void *v)
 
 static int ip_vs_info_seq_show(struct seq_file *seq, void *v)
 {
+	struct net *net = seq_file_net(seq);
+	struct netns_ipvs *ipvs = net_ipvs(net);
+
 	if (v == SEQ_START_TOKEN) {
+		struct ip_vs_rht *tc = rcu_dereference(ipvs->conn_tab);
+		int csize = tc ? tc->size : 0;
+
 		seq_printf(seq,
 			"IP Virtual Server version %d.%d.%d (size=%d)\n",
-			NVERSION(IP_VS_VERSION_CODE), ip_vs_conn_tab_size);
+			NVERSION(IP_VS_VERSION_CODE), csize);
 		seq_puts(seq,
 			 "Prot LocalAddress:Port Scheduler Flags\n");
 		seq_puts(seq,
@@ -3419,10 +3425,17 @@ do_ip_vs_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 	switch (cmd) {
 	case IP_VS_SO_GET_VERSION:
 	{
+		struct ip_vs_rht *t;
+		int csize = 0;
 		char buf[64];
 
+		rcu_read_lock();
+		t = rcu_dereference(ipvs->conn_tab);
+		if (t)
+			csize = t->size;
+		rcu_read_unlock();
 		sprintf(buf, "IP Virtual Server version %d.%d.%d (size=%d)",
-			NVERSION(IP_VS_VERSION_CODE), ip_vs_conn_tab_size);
+			NVERSION(IP_VS_VERSION_CODE), csize);
 		if (copy_to_user(user, buf, strlen(buf)+1) != 0) {
 			ret = -EFAULT;
 			goto out;
@@ -3434,8 +3447,16 @@ do_ip_vs_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 	case IP_VS_SO_GET_INFO:
 	{
 		struct ip_vs_getinfo info;
+		struct ip_vs_rht *t;
+		int csize = 0;
+
+		rcu_read_lock();
+		t = rcu_dereference(ipvs->conn_tab);
+		if (t)
+			csize = t->size;
+		rcu_read_unlock();
 		info.version = IP_VS_VERSION_CODE;
-		info.size = ip_vs_conn_tab_size;
+		info.size = csize;
 		info.num_services =
 			atomic_read(&ipvs->num_services[IP_VS_AF_INET]);
 		if (copy_to_user(user, &info, sizeof(info)) != 0)
@@ -4377,6 +4398,8 @@ static int ip_vs_genl_get_cmd(struct sk_buff *skb, struct genl_info *info)
 	int ret, cmd, reply_cmd;
 	struct net *net = sock_net(skb->sk);
 	struct netns_ipvs *ipvs = net_ipvs(net);
+	struct ip_vs_rht *t;
+	int csize;
 
 	cmd = info->genlhdr->cmd;
 
@@ -4444,10 +4467,13 @@ static int ip_vs_genl_get_cmd(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	case IPVS_CMD_GET_INFO:
+		csize = 0;
+		t = rcu_dereference(ipvs->conn_tab);
+		if (t)
+			csize = t->size;
 		if (nla_put_u32(msg, IPVS_INFO_ATTR_VERSION,
 				IP_VS_VERSION_CODE) ||
-		    nla_put_u32(msg, IPVS_INFO_ATTR_CONN_TAB_SIZE,
-				ip_vs_conn_tab_size))
+		    nla_put_u32(msg, IPVS_INFO_ATTR_CONN_TAB_SIZE, csize))
 			goto nla_put_failure;
 		break;
 	}
-- 
2.41.0


