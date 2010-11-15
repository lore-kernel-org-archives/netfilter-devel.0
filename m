From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH] ipvs: add static and read_mostly attributes
Date: Mon, 15 Nov 2010 18:38:52 +0100
Message-ID: <1289842732.2607.111.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Simon Horman <horms@verge.net.au>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45366 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932988Ab0KORi5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Nov 2010 12:38:57 -0500
Received: by wwa36 with SMTP id 36so280712wwa.1
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Nov 2010 09:38:56 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ip_vs_conn_tab_bits & ip_vs_conn_tab_mask are static to
ipvs/ip_vs_conn.c

ip_vs_conn_tab_size, ip_vs_conn_tab_mask, ip_vs_conn_tab [the pointer],
ip_vs_conn_rnd are mostly read.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 net/netfilter/ipvs/ip_vs_conn.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index e9adecd..b543c51 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -48,18 +48,18 @@
 /*
  * Connection hash size. Default is what was selected at compile time.
 */
-int ip_vs_conn_tab_bits = CONFIG_IP_VS_TAB_BITS;
+static int ip_vs_conn_tab_bits = CONFIG_IP_VS_TAB_BITS;
 module_param_named(conn_tab_bits, ip_vs_conn_tab_bits, int, 0444);
 MODULE_PARM_DESC(conn_tab_bits, "Set connections' hash size");
 
 /* size and mask values */
-int ip_vs_conn_tab_size;
-int ip_vs_conn_tab_mask;
+int ip_vs_conn_tab_size __read_mostly;
+static int ip_vs_conn_tab_mask __read_mostly;
 
 /*
  *  Connection hash table: for input and output packets lookups of IPVS
  */
-static struct list_head *ip_vs_conn_tab;
+static struct list_head *ip_vs_conn_tab __read_mostly;
 
 /*  SLAB cache for IPVS connections */
 static struct kmem_cache *ip_vs_conn_cachep __read_mostly;
@@ -71,7 +71,7 @@ static atomic_t ip_vs_conn_count = ATOMIC_INIT(0);
 static atomic_t ip_vs_conn_no_cport_cnt = ATOMIC_INIT(0);
 
 /* random value for IPVS connection hash */
-static unsigned int ip_vs_conn_rnd;
+static unsigned int ip_vs_conn_rnd __read_mostly;
 
 /*
  *  Fine locking granularity for big connection hash table


