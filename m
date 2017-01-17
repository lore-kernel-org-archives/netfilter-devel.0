From: Kevin Cernekee <cernekee@chromium.org>
Subject: [RFC/PATCH 1/3] netfilter: ctnetlink: Fix regression in CTA_TIMEOUT processing
Date: Mon, 16 Jan 2017 21:14:06 -0800
Message-ID: <1484630048-25416-2-git-send-email-cernekee@chromium.org>
References: <1484630048-25416-1-git-send-email-cernekee@chromium.org>
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1484630048-25416-1-git-send-email-cernekee@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Commit b7bd1809e078 ("netfilter: nfnetlink_queue: get rid of
nfnetlink_queue_ct.c") introduced a new check on the return value
from the NFQA_CT parser (currently ctnetlink_glue_parse_ct()).
Prior to Linux 4.4, nfqnl_ct_parse() would process the NFQA_EXP
attribute even if there were errors in the NFQA_CT attribute.
After Linux 4.4, this is no longer true, so any error in the NFQA_CT
attribute will cause the kernel to silently fail to create an
expectation.

The new check is causing user conntrack helpers to fail.  If a user
program sends an NFQA_CT attribute containing a CTA_TIMEOUT attribute
before the connection is confirmed (i.e. before the initial
ACCEPT/DROP decision has been made), del_timer() in
ctnetlink_change_timeout() will fail, and all further processing will be
aborted.  The (simplified) calling sequence looks like:

    nfnetlink_rcv_msg
      nfqnl_recv_verdict
        nfqnl_ct_parse
          ctnetlink_glue_parse_ct
            ctnetlink_change_timeout
              del_timer [ERROR]
        nf_reinject
          __nf_conntrack_confirm

Fix this by adding a case to ctnetlink_change_timeout() to handle
unconfirmed connections.

Also, if a timeout of 0 is set for an unconfirmed connection, restore the
old behavior of ignoring it (rather than setting up a connection that
expires immediately).

Signed-off-by: Kevin Cernekee <cernekee@chromium.org>
---
 net/netfilter/nf_conntrack_netlink.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 9f5272968abb..43beb950df16 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1531,11 +1531,15 @@ ctnetlink_change_timeout(struct nf_conn *ct, const struct nlattr * const cda[])
 {
 	u_int32_t timeout = ntohl(nla_get_be32(cda[CTA_TIMEOUT]));
 
-	if (!del_timer(&ct->timeout))
-		return -ETIME;
+	if (nf_ct_is_confirmed(ct)) {
+		if (!del_timer(&ct->timeout))
+			return -ETIME;
 
-	ct->timeout.expires = jiffies + timeout * HZ;
-	add_timer(&ct->timeout);
+		ct->timeout.expires = jiffies + timeout * HZ;
+		add_timer(&ct->timeout);
+	} else if (timeout != 0) {
+		ct->timeout.expires = timeout * HZ;
+	}
 
 	return 0;
 }
-- 
2.7.4
