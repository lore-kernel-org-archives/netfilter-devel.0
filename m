From: Aaron Conole <aconole@bytheb.org>
Subject: [PATCH nf-next] ipset: remove unused function __ip_set_get_netlink
Date: Mon, 10 Apr 2017 15:52:37 -0400
Message-ID: <20170410195237.19909-1-aconole@bytheb.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:35499 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752042AbdDJTwm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Apr 2017 15:52:42 -0400
Received: by mail-qt0-f195.google.com with SMTP id o36so4690719qtb.2
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Apr 2017 12:52:42 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There are no in-tree callers.

Signed-off-by: Aaron Conole <aconole@bytheb.org>
---
 net/netfilter/ipset/ip_set_core.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index c296f9b..68ba531 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -501,14 +501,6 @@ __ip_set_put(struct ip_set *set)
  * a separate reference counter
  */
 static inline void
-__ip_set_get_netlink(struct ip_set *set)
-{
-	write_lock_bh(&ip_set_ref_lock);
-	set->ref_netlink++;
-	write_unlock_bh(&ip_set_ref_lock);
-}
-
-static inline void
 __ip_set_put_netlink(struct ip_set *set)
 {
 	write_lock_bh(&ip_set_ref_lock);
-- 
2.9.3

