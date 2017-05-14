From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nft] src: delete the old cache when dumping is interrupted
Date: Sun, 14 May 2017 15:56:12 +0800
Message-ID: <20170514075612.29226-1-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:36839 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751334AbdENH5F (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 May 2017 03:57:05 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

When the dumping operation is interrupted, we will restart the
cache_init(), but unfortunatly, we forget to delete the old cache.
So in extreme case, we will leak a huge amount of memory.

Running the following commands can simulate the extreme case:
  # nft add table t
  # nft add set t s {type inet_service \;}
  # for i in $(seq 65000); do
  nft add element t s {$i}
  done &
  # while : ; do
  time nft list ruleset -nn
  done

After a while, oom killer will be triggered:
  [ 2808.243537] Out of memory: Kill process 16975 (nft) score 649 or
                 sacrifice child
  [ 2808.255372] Killed process 16975 (nft) total-vm:1955348kB,
                 anon-rss:1952120kB, file-rss:0kB, shmem-rss:0kB
  [ 2858.353729] nft invoked oom-killer: gfp_mask=0x14201ca(GFP_HIGHUSER_
                 MOVABLE|__GFP_COLD), nodemask=(null),  order=0,
                 oom_score_adj=0
  [ 2858.374521] nft cpuset=/ mems_allowed=0
  ...

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 src/rule.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/rule.c b/src/rule.c
index 209cf2d..5923bf6 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -156,11 +156,11 @@ replay:
 	netlink_genid_get();
 	ret = cache_init(cmd, msgs);
 	if (ret < 0) {
+		cache_release();
 		if (errno == EINTR) {
 			netlink_restart();
 			goto replay;
 		}
-		cache_release();
 		return -1;
 	}
 	cache_initialized = true;
-- 
2.9.3


