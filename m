Return-Path: <SRS0=YvWH=YU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4BD7CA9EAF
	for <netfilter-devel@archiver.kernel.org>; Sun, 27 Oct 2019 12:02:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C21E52070B
	for <netfilter-devel@archiver.kernel.org>; Sun, 27 Oct 2019 12:02:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbfJ0MCs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 27 Oct 2019 08:02:48 -0400
Received: from correo.us.es ([193.147.175.20]:60144 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726836AbfJ0MCn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 27 Oct 2019 08:02:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CC4BE7FC52
        for <netfilter-devel@vger.kernel.org>; Sun, 27 Oct 2019 13:02:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BD901B8005
        for <netfilter-devel@vger.kernel.org>; Sun, 27 Oct 2019 13:02:38 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B3225B7FFE; Sun, 27 Oct 2019 13:02:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BA13CB7FF2;
        Sun, 27 Oct 2019 13:02:36 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 27 Oct 2019 13:02:36 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 86CD242EE38F;
        Sun, 27 Oct 2019 13:02:36 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 4/5] ipvs: move old_secure_tcp into struct netns_ipvs
Date:   Sun, 27 Oct 2019 13:02:20 +0100
Message-Id: <20191027120221.2884-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191027120221.2884-1-pablo@netfilter.org>
References: <20191027120221.2884-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

syzbot reported the following issue :

BUG: KCSAN: data-race in update_defense_level / update_defense_level

read to 0xffffffff861a6260 of 4 bytes by task 3006 on cpu 1:
 update_defense_level+0x621/0xb30 net/netfilter/ipvs/ip_vs_ctl.c:177
 defense_work_handler+0x3d/0xd0 net/netfilter/ipvs/ip_vs_ctl.c:225
 process_one_work+0x3d4/0x890 kernel/workqueue.c:2269
 worker_thread+0xa0/0x800 kernel/workqueue.c:2415
 kthread+0x1d4/0x200 drivers/block/aoe/aoecmd.c:1253
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352

write to 0xffffffff861a6260 of 4 bytes by task 7333 on cpu 0:
 update_defense_level+0xa62/0xb30 net/netfilter/ipvs/ip_vs_ctl.c:205
 defense_work_handler+0x3d/0xd0 net/netfilter/ipvs/ip_vs_ctl.c:225
 process_one_work+0x3d4/0x890 kernel/workqueue.c:2269
 worker_thread+0xa0/0x800 kernel/workqueue.c:2415
 kthread+0x1d4/0x200 drivers/block/aoe/aoecmd.c:1253
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 7333 Comm: kworker/0:5 Not tainted 5.4.0-rc3+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events defense_work_handler

Indeed, old_secure_tcp is currently a static variable, while it
needs to be a per netns variable.

Fixes: a0840e2e165a ("IPVS: netns, ip_vs_ctl local vars moved to ipvs struct.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Simon Horman <horms@verge.net.au>
---
 include/net/ip_vs.h            |  1 +
 net/netfilter/ipvs/ip_vs_ctl.c | 15 +++++++--------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 3759167f91f5..078887c8c586 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -889,6 +889,7 @@ struct netns_ipvs {
 	struct delayed_work	defense_work;   /* Work handler */
 	int			drop_rate;
 	int			drop_counter;
+	int			old_secure_tcp;
 	atomic_t		dropentry;
 	/* locks in ctl.c */
 	spinlock_t		dropentry_lock;  /* drop entry handling */
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index c8f81dd15c83..3cccc88ef817 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -93,7 +93,6 @@ static bool __ip_vs_addr_is_local_v6(struct net *net,
 static void update_defense_level(struct netns_ipvs *ipvs)
 {
 	struct sysinfo i;
-	static int old_secure_tcp = 0;
 	int availmem;
 	int nomem;
 	int to_change = -1;
@@ -174,35 +173,35 @@ static void update_defense_level(struct netns_ipvs *ipvs)
 	spin_lock(&ipvs->securetcp_lock);
 	switch (ipvs->sysctl_secure_tcp) {
 	case 0:
-		if (old_secure_tcp >= 2)
+		if (ipvs->old_secure_tcp >= 2)
 			to_change = 0;
 		break;
 	case 1:
 		if (nomem) {
-			if (old_secure_tcp < 2)
+			if (ipvs->old_secure_tcp < 2)
 				to_change = 1;
 			ipvs->sysctl_secure_tcp = 2;
 		} else {
-			if (old_secure_tcp >= 2)
+			if (ipvs->old_secure_tcp >= 2)
 				to_change = 0;
 		}
 		break;
 	case 2:
 		if (nomem) {
-			if (old_secure_tcp < 2)
+			if (ipvs->old_secure_tcp < 2)
 				to_change = 1;
 		} else {
-			if (old_secure_tcp >= 2)
+			if (ipvs->old_secure_tcp >= 2)
 				to_change = 0;
 			ipvs->sysctl_secure_tcp = 1;
 		}
 		break;
 	case 3:
-		if (old_secure_tcp < 2)
+		if (ipvs->old_secure_tcp < 2)
 			to_change = 1;
 		break;
 	}
-	old_secure_tcp = ipvs->sysctl_secure_tcp;
+	ipvs->old_secure_tcp = ipvs->sysctl_secure_tcp;
 	if (to_change >= 0)
 		ip_vs_protocol_timeout_change(ipvs,
 					      ipvs->sysctl_secure_tcp > 1);
-- 
2.11.0

