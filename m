From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 02/25] netns ct: export netns list
Date: Sun, 22 Jun 2008 05:00:39 +0400
Message-ID: <20080622010039.GC5392@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	den@openvz.org, xemul@openvz.org, ebiederm@xmission.com,
	benjamin.thery@bull.net, dlezcano@fr.ibm.com
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:1127 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbYFVBEs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 Jun 2008 21:04:48 -0400
Received: by ug-out-1314.google.com with SMTP id h2so243847ugf.16
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Jun 2008 18:04:47 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Connection tracking code will use it for
a) nuking expectations and helpers when module is removed, and
b) removing conntracks when L3 protocol conntrack module is removed

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 net/core/net_namespace.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -18,6 +18,7 @@ static struct list_head *first_device = &pernet_list;
 static DEFINE_MUTEX(net_mutex);
 
 LIST_HEAD(net_namespace_list);
+EXPORT_SYMBOL_GPL(net_namespace_list);
 
 struct net init_net;
 EXPORT_SYMBOL(init_net);
-- 
1.5.4.5


