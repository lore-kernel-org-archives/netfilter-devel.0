From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 12/33] netns ct: export netns list
Date: Mon,  8 Sep 2008 07:02:49 +0400
Message-ID: <1220842990-30500-12-git-send-email-adobriyan@gmail.com>
References: <48C01046.2070704@trash.net>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	containers@lists.linux-foundation.org
To: kaber@trash.net
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <48C01046.2070704@trash.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Conntrack code will use it for
a) removing expectations and helpers when corresponding module is removed, and
b) removing conntracks when L3 protocol conntrack module is removed.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 7c52fe2..b0dc818 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -18,6 +18,7 @@ static struct list_head *first_device = &pernet_list;
 static DEFINE_MUTEX(net_mutex);
 
 LIST_HEAD(net_namespace_list);
+EXPORT_SYMBOL_GPL(net_namespace_list);
 
 struct net init_net;
 EXPORT_SYMBOL(init_net);
