From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH] netfilter: hashlimit and recent net_id are mostly read
Date: Sun, 21 Nov 2010 09:39:47 +0100
Message-ID: <1290328787.2756.106.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54671 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab0KUIjv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Nov 2010 03:39:51 -0500
Received: by wyb28 with SMTP id 28so5948801wyb.19
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Nov 2010 00:39:50 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Make sure hashlimit_net_id and recent_net_id dont sit in an often
written cache line.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 net/netfilter/xt_hashlimit.c |    2 +-
 net/netfilter/xt_recent.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 9228ee0..20ada88 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -48,7 +48,7 @@ struct hashlimit_net {
 	struct proc_dir_entry	*ip6t_hashlimit;
 };
 
-static int hashlimit_net_id;
+static int hashlimit_net_id __read_mostly;
 static inline struct hashlimit_net *hashlimit_pernet(struct net *net)
 {
 	return net_generic(net, hashlimit_net_id);
diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index d2ff15a..8ae475e 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -88,7 +88,7 @@ struct recent_net {
 #endif
 };
 
-static int recent_net_id;
+static int recent_net_id __read_mostly;
 static inline struct recent_net *recent_pernet(struct net *net)
 {
 	return net_generic(net, recent_net_id);


