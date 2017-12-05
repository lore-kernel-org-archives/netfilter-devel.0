From: Kevin Cernekee <cernekee@chromium.org>
Subject: [PATCH] netfilter: xt_osf: Add missing permission checks
Date: Tue,  5 Dec 2017 15:42:41 -0800
Message-ID: <1512517361-23689-1-git-send-email-cernekee@chromium.org>
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:46516 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752625AbdLEXow (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Dec 2017 18:44:52 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The capability check in nfnetlink_rcv() verifies that the caller
has CAP_NET_ADMIN in the namespace that "owns" the netlink socket.
However, xt_osf_fingers is shared by all net namespaces on the
system.  An unprivileged user can create user and net namespaces
in which he holds CAP_NET_ADMIN to bypass the netlink_net_capable()
check:

    vpnns -- nfnl_osf -f /tmp/pf.os

    vpnns -- nfnl_osf -f /tmp/pf.os -d

These non-root operations successfully modify the systemwide OS
fingerprint list.  Add new capable() checks so that they can't.

Signed-off-by: Kevin Cernekee <cernekee@chromium.org>
---
 net/netfilter/xt_osf.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/netfilter/xt_osf.c b/net/netfilter/xt_osf.c
index 36e14b1..a34f314 100644
--- a/net/netfilter/xt_osf.c
+++ b/net/netfilter/xt_osf.c
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 
+#include <linux/capability.h>
 #include <linux/if.h>
 #include <linux/inetdevice.h>
 #include <linux/ip.h>
@@ -70,6 +71,9 @@ static int xt_osf_add_callback(struct net *net, struct sock *ctnl,
 	struct xt_osf_finger *kf = NULL, *sf;
 	int err = 0;
 
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
 	if (!osf_attrs[OSF_ATTR_FINGER])
 		return -EINVAL;
 
@@ -115,6 +119,9 @@ static int xt_osf_remove_callback(struct net *net, struct sock *ctnl,
 	struct xt_osf_finger *sf;
 	int err = -ENOENT;
 
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
 	if (!osf_attrs[OSF_ATTR_FINGER])
 		return -EINVAL;
 
-- 
2.7.4

