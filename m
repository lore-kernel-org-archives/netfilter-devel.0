From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf] netfilter: ctnetlink: make it safer when checking the ct helper name
Date: Sat,  1 Apr 2017 20:55:44 +0800
Message-ID: <1491051344-29766-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, cernekee@chromium.org,
        Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-12.163.com ([220.181.12.12]:60105 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751353AbdDAM4b (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Apr 2017 08:56:31 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

One CPU is doing ctnetlink_change_helper(), while another CPU is doing
unhelp() at the same time. So even if help->helper is not NULL at first,
the later statement strcmp(help->helper->name, ...) may still access
the NULL pointer.

So we must use rcu_read_lock and rcu_dereference to avoid such _bad_
thing happen.

Fixes: f95d7a46bc57 ("netfilter: ctnetlink: Fix regression in CTA_HELP processing")
Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 net/netfilter/nf_conntrack_netlink.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 59ee27d..7b83bbf 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1488,11 +1488,16 @@ static int ctnetlink_change_helper(struct nf_conn *ct,
 		 * treat the second attempt as a no-op instead of returning
 		 * an error.
 		 */
-		if (help && help->helper &&
-		    !strcmp(help->helper->name, helpname))
-			return 0;
-		else
-			return -EBUSY;
+		err = -EBUSY;
+		if (help) {
+			rcu_read_lock();
+			helper = rcu_dereference(help->helper);
+			if (helper && !strcmp(helper->name, helpname))
+				err = 0;
+			rcu_read_unlock();
+		}
+
+		return err;
 	}
 
 	if (!strcmp(helpname, "")) {
-- 
2.5.5


