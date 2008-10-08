From: Patrick McHardy <kaber@trash.net>
Subject: netns 23/79: export netns list
Date: Wed,  8 Oct 2008 12:46:52 +0200 (MEST)
Message-ID: <20081008104652.10423.54712.sendpatchset@x2.localnet>
References: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45924 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539AbYJHKqx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:46:53 -0400
In-Reply-To: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit b76a461f11eb5f32d37a9c8eae7b2f3b3f261b43
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Wed Oct 8 11:35:06 2008 +0200

    netns: export netns list
    
    Conntrack code will use it for
    a) removing expectations and helpers when corresponding module is removed, and
    b) removing conntracks when L3 protocol conntrack module is removed.
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

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
