Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 997F9C4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Dec 2022 19:59:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233368AbiLLT7f (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Dec 2022 14:59:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233180AbiLLT71 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Dec 2022 14:59:27 -0500
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 37E7D17431;
        Mon, 12 Dec 2022 11:59:25 -0800 (PST)
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id 9A0444448B;
        Mon, 12 Dec 2022 21:59:23 +0200 (EET)
Received: from ink.ssi.bg (unknown [193.238.174.40])
        by mg.ssi.bg (Proxmox) with ESMTP id C64CC44486;
        Mon, 12 Dec 2022 21:59:21 +0200 (EET)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id 68A2B3C07CA;
        Mon, 12 Dec 2022 21:59:21 +0200 (EET)
Received: from ja.home.ssi.bg (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.17.1/8.16.1) with ESMTP id 2BCJxLoK101928;
        Mon, 12 Dec 2022 21:59:21 +0200
Received: (from root@localhost)
        by ja.home.ssi.bg (8.17.1/8.17.1/Submit) id 2BCJxHDp101919;
        Mon, 12 Dec 2022 21:59:17 +0200
From:   Julian Anastasov <ja@ssi.bg>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Simon Horman <horms@verge.net.au>, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, Jiri Wiesner <jwiesner@suse.de>
Subject: [PATCH] ipvs: use u64 to silence do_div warnings
Date:   Mon, 12 Dec 2022 21:58:45 +0200
Message-Id: <20221212195845.101844-1-ja@ssi.bg>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fix the following warning from kernel test robot:

All warnings (new ones prefixed by >>):

   In file included from ./arch/arc/include/generated/asm/div64.h:1,
                    from include/linux/math.h:6,
                    from include/linux/kernel.h:25,
                    from net/netfilter/ipvs/ip_vs_est.c:18:
   net/netfilter/ipvs/ip_vs_est.c: In function 'ip_vs_est_calc_limits':
>> include/asm-generic/div64.h:222:35: warning: comparison of distinct pointer types lacks a cast
     222 |         (void)(((typeof((n)) *)0) == ((uint64_t *)0));  \
         |                                   ^~
   net/netfilter/ipvs/ip_vs_est.c:688:17: note: in expansion of macro 'do_div'
     688 |                 do_div(val, loops);
         |                 ^~~~~~
>> include/asm-generic/div64.h:222:35: warning: comparison of distinct pointer types lacks a cast
     222 |         (void)(((typeof((n)) *)0) == ((uint64_t *)0));  \
         |                                   ^~
   net/netfilter/ipvs/ip_vs_est.c:694:33: note: in expansion of macro 'do_div'
     694 |                                 do_div(val, min_est);
         |                                 ^~~~~~

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Julian Anastasov <ja@ssi.bg>
---
 net/netfilter/ipvs/ip_vs_est.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_est.c b/net/netfilter/ipvs/ip_vs_est.c
index df56073bb282..5473328f367f 100644
--- a/net/netfilter/ipvs/ip_vs_est.c
+++ b/net/netfilter/ipvs/ip_vs_est.c
@@ -638,11 +638,12 @@ static int ip_vs_est_calc_limits(struct netns_ipvs *ipvs, int *chain_max)
 	struct ip_vs_stats *s;
 	int cache_factor = 4;
 	int i, loops, ntest;
-	s32 min_est = 0;
+	u32 min_est = 0;
 	ktime_t t1, t2;
-	s64 diff, val;
 	int max = 8;
 	int ret = 1;
+	s64 diff;
+	u64 val;
 
 	INIT_HLIST_HEAD(&chain);
 	mutex_lock(&__ip_vs_mutex);
-- 
2.38.1


