From: Scott James Remnant <scott@canonical.com>
Subject: [PATCH 04/31] netfilter: Auto-load ip_queue module when socket opened.
Date: Mon, 2 Mar 2009 17:03:47 +0000
Message-ID: <cad3a5b11d97ba57d8a5e4df605ed55324e2b734.1236702228.git.scott@canonical.com>
References: <cover.1236702228.git.scott@canonical.com>
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from zelda.netsplit.com ([87.194.19.211]:34589 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769AbZCJQni (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:43:38 -0400
In-Reply-To: <cover.1236702228.git.scott@canonical.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The ip_queue module is missing the net-pf-16-proto-3 alias that would
causae it to be auto-loaded when a socket of that type is opened.  This
patch adds the alias.

Signed-off-by: Scott James Remnant <scott@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 net/ipv4/netfilter/ip_queue.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ip_queue.c b/net/ipv4/netfilter/ip_queue.c
index 432ce9d..5f22c91 100644
--- a/net/ipv4/netfilter/ip_queue.c
+++ b/net/ipv4/netfilter/ip_queue.c
@@ -24,6 +24,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/security.h>
+#include <linux/net.h>
 #include <linux/mutex.h>
 #include <net/net_namespace.h>
 #include <net/sock.h>
@@ -640,6 +641,7 @@ static void __exit ip_queue_fini(void)
 MODULE_DESCRIPTION("IPv4 packet queue handler");
 MODULE_AUTHOR("James Morris <jmorris@intercode.com.au>");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS_NET_PF_PROTO(PF_NETLINK, NETLINK_FIREWALL);
 
 module_init(ip_queue_init);
 module_exit(ip_queue_fini);
-- 
1.6.0.5

