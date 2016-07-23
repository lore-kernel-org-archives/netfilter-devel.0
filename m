From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next] netfilter: nf_ct_h323: do not re-activate already expired timer
Date: Sat, 23 Jul 2016 22:16:56 +0800
Message-ID: <1469283416-25879-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>,
	Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-14.163.com ([220.181.12.14]:59127 "EHLO m12-14.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035AbcGWORa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Jul 2016 10:17:30 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

Commit 96d1327ac2e3 ("netfilter: h323: Use mod_timer instead of
set_expect_timeout") just simplify the source codes
    if (!del_timer(&exp->timeout))
        return 0;
    add_timer(&exp->timeout);
to mod_timer(&exp->timeout, jiffies + info->timeout * HZ);

This is not correct, and introduce a race codition:
    CPU0                     CPU1
     -                     timer expire
  process_rcf              expectation_timed_out
  lock(exp_lock)              -
  find_exp                 waiting exp_lock...
  re-activate timer!!      waiting exp_lock...
  unlock(exp_lock)         lock(exp_lock)
     -                     unlink expect
     -                     free(expect)
     -                     unlock(exp_lock)
So when the timer expires again, we will access the memory that
was already freed.

Replace mod_timer with mod_timer_pending here to fix this problem.

Fixes: 96d1327ac2e3 ("netfilter: h323: Use mod_timer instead of set_expect_timeout")
Cc: Gao Feng <fgao@ikuai8.com>
Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
When I found this problem and want to report it, it was a little too late.
I find that this commit was already pushed to the cgit :(

 net/netfilter/nf_conntrack_h323_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index bb77a97..5c0db5c 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -1473,7 +1473,8 @@ static int process_rcf(struct sk_buff *skb, struct nf_conn *ct,
 				 "timeout to %u seconds for",
 				 info->timeout);
 			nf_ct_dump_tuple(&exp->tuple);
-			mod_timer(&exp->timeout, jiffies + info->timeout * HZ);
+			mod_timer_pending(&exp->timeout,
+					  jiffies + info->timeout * HZ);
 		}
 		spin_unlock_bh(&nf_conntrack_expect_lock);
 	}
-- 
2.5.5


