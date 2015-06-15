From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH RFC 01/15] net: include missing headers in net/net_namespace.h
Date: Mon, 15 Jun 2015 17:46:43 +0200
Message-ID: <1434383217-13732-2-git-send-email-pablo@netfilter.org>
References: <1434383217-13732-1-git-send-email-pablo@netfilter.org>
Cc: ebiederm@xmission.com, aschultz@warp10.net, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36828 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083AbbFOPlo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Jun 2015 11:41:44 -0400
In-Reply-To: <1434383217-13732-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Include linux/idr.h and linux/skbuff.h since they are required by objects that
are declared in the net structure.

 struct net {
	...
	struct idr		netns_ids;
	...
	struct sk_buff_head	wext_nlevents;
	...

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/net_namespace.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 72eb237..e951453 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -28,6 +28,8 @@
 #include <net/netns/xfrm.h>
 #include <net/netns/mpls.h>
 #include <linux/ns_common.h>
+#include <linux/idr.h>
+#include <linux/skbuff.h>
 
 struct user_namespace;
 struct proc_dir_entry;
-- 
1.7.10.4

