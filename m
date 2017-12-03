From: Kevin Cernekee <cernekee@chromium.org>
Subject: [PATCH] netfilter: nfnetlink_cthelper: Add missing permission checks
Date: Sun,  3 Dec 2017 12:12:45 -0800
Message-ID: <1512331965-30830-1-git-send-email-cernekee@chromium.org>
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f46.google.com ([74.125.83.46]:43719 "EHLO
        mail-pg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751208AbdLCUMu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 3 Dec 2017 15:12:50 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The capability check in nfnetlink_rcv() verifies that the caller
has CAP_NET_ADMIN in the namespace that "owns" the netlink socket.
However, nfnl_cthelper_list is shared by all net namespaces on the
system.  An unprivileged user can create user and net namespaces
in which he holds CAP_NET_ADMIN to bypass the netlink_net_capable()
check:

    $ nfct helper list
    nfct v1.4.4: netlink error: Operation not permitted
    $ vpnns -- nfct helper list
    {
            .name = ftp,
            .queuenum = 0,
            .l3protonum = 2,
            .l4protonum = 6,
            .priv_data_len = 24,
            .status = enabled,
    };

Add capable() checks in nfnetlink_cthelper, as this is cleaner than
trying to generalize the solution.

Signed-off-by: Kevin Cernekee <cernekee@chromium.org>
---
 net/netfilter/nfnetlink_cthelper.c | 10 ++++++++++
 1 file changed, 10 insertions(+)


I think xt_osf has the same issue with respect to xt_osf_fingers.
Also, it looks like nlmon devices created in an unprivileged netns can
see netlink activity from the init namespace.


diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index 41628b393673..d33ce6d5ebce 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -17,6 +17,7 @@
 #include <linux/types.h>
 #include <linux/list.h>
 #include <linux/errno.h>
+#include <linux/capability.h>
 #include <net/netlink.h>
 #include <net/sock.h>
 
@@ -407,6 +408,9 @@ static int nfnl_cthelper_new(struct net *net, struct sock *nfnl,
 	struct nfnl_cthelper *nlcth;
 	int ret = 0;
 
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
 	if (!tb[NFCTH_NAME] || !tb[NFCTH_TUPLE])
 		return -EINVAL;
 
@@ -611,6 +615,9 @@ static int nfnl_cthelper_get(struct net *net, struct sock *nfnl,
 	struct nfnl_cthelper *nlcth;
 	bool tuple_set = false;
 
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
 	if (nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
 			.dump = nfnl_cthelper_dump_table,
@@ -678,6 +685,9 @@ static int nfnl_cthelper_del(struct net *net, struct sock *nfnl,
 	struct nfnl_cthelper *nlcth, *n;
 	int j = 0, ret;
 
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
 	if (tb[NFCTH_NAME])
 		helper_name = nla_data(tb[NFCTH_NAME]);
 
-- 
2.7.4

