From: fgao@ikuai8.com
Subject: [PATCH nf-next 1/1] netfilter: sip: Use mod_timer_pending instead of current multiple statements
Date: Thu,  9 Feb 2017 16:46:45 +0800
Message-ID: <1486630005-58605-1-git-send-email-fgao@ikuai8.com>
Cc: gfree.wind@gmail.com, Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from SMTPBG19.QQ.COM ([183.60.61.236]:49500 "EHLO smtpbg320.qq.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751577AbdBIIsZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Feb 2017 03:48:25 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

Current statements is del and add, it could be replaced by
mod_timer_pending.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 net/netfilter/nf_conntrack_sip.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index c3fc14e..24174c52 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -809,13 +809,11 @@ static int refresh_signalling_expectation(struct nf_conn *ct,
 		    exp->tuple.dst.protonum != proto ||
 		    exp->tuple.dst.u.udp.port != port)
 			continue;
-		if (!del_timer(&exp->timeout))
-			continue;
-		exp->flags &= ~NF_CT_EXPECT_INACTIVE;
-		exp->timeout.expires = jiffies + expires * HZ;
-		add_timer(&exp->timeout);
-		found = 1;
-		break;
+		if (mod_timer_pending(&exp->timeout, jiffies + expires * HZ)) {
+			exp->flags &= ~NF_CT_EXPECT_INACTIVE;
+			found = 1;
+			break;
+		}
 	}
 	spin_unlock_bh(&nf_conntrack_expect_lock);
 	return found;
-- 
1.9.1


