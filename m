From: Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH -nf] netfilter: x_tables: fix cgroup matching on non-full sks
Date: Fri, 27 Mar 2015 19:37:41 +0100
Message-ID: <63c15d588bb75294ed013671be1aff791126d142.1427479072.git.daniel@iogearbox.net>
Cc: netfilter-devel@vger.kernel.org,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexey Perevalov <a.perevalov@samsung.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:40579 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbbC0Shp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Mar 2015 14:37:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

While originally only being intended for outgoing traffic, commit
a00e76349f35 ("netfilter: x_tables: allow to use cgroup match for
LOCAL_IN nf hooks") enabled xt_cgroups for the NF_INET_LOCAL_IN hook
as well, in order to allow for nfacct accounting.

Besides being currently limited to early demuxes only, commit
a00e76349f35 forgot to add a check if we deal with full sockets,
i.e. in this case not with time wait sockets. TCP time wait sockets
do not have the same memory layout as full sockets, a lower memory
footprint and consequently also don't have a sk_classid member;
probing for sk_classid member there could potentially lead to a
crash.

Fixes: a00e76349f35 ("netfilter: x_tables: allow to use cgroup match for LOCAL_IN nf hooks")
Cc: Alexey Perevalov <a.perevalov@samsung.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 (As discussed the fix for xt_cgroups, so it can be queued for
  -stable. In nf-next speak that would be !sk_fullsock(skb->sk).)

 net/netfilter/xt_cgroup.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/xt_cgroup.c b/net/netfilter/xt_cgroup.c
index 7198d66..d64aca0 100644
--- a/net/netfilter/xt_cgroup.c
+++ b/net/netfilter/xt_cgroup.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_cgroup.h>
+#include <net/tcp_states.h> /* for TCP_TIME_WAIT */
 #include <net/sock.h>
 
 MODULE_LICENSE("GPL");
@@ -39,7 +40,7 @@ cgroup_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_cgroup_info *info = par->matchinfo;
 
-	if (skb->sk == NULL)
+	if (skb->sk == NULL || skb->sk->sk_state == TCP_TIME_WAIT)
 		return false;
 
 	return (info->id == skb->sk->sk_classid) ^ info->invert;
-- 
1.9.3

