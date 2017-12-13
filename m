From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 09/12] netfilter: xt_osf: Add missing permission checks
Date: Wed, 13 Dec 2017 19:45:17 +0100
Message-ID: <20171213184520.8193-10-pablo@netfilter.org>
References: <20171213184520.8193-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171213184520.8193-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Kevin Cernekee <cernekee@chromium.org>

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_osf.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/netfilter/xt_osf.c b/net/netfilter/xt_osf.c
index 36e14b1f061d..a34f314a8c23 100644
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
2.11.0
