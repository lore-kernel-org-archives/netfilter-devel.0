From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 2/2] netfilter: ipset: Null pointer exception in ipset list:set
Date: Sun, 19 Feb 2017 19:24:16 +0100
Message-ID: <1487528656-21961-3-git-send-email-kadlec@blackhole.kfki.hu>
References: <1487528656-21961-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:56475 "EHLO smtp2.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750880AbdBSSY6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 Feb 2017 13:24:58 -0500
In-Reply-To: <1487528656-21961-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Vishwanath Pai <vpai@akamai.com>

If we use before/after to add an element to an empty list it will cause
a kernel panic.

$> cat crash.restore
create a hash:ip
create b hash:ip
create test list:set timeout 5 size 4
add test b before a

$> ipset -R < crash.restore

Executing the above will crash the kernel.

Signed-off-by: Vishwanath Pai <vpai@akamai.com>
Reviewed-by: Josh Hunt <johunt@akamai.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_list_set.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index 51077c5..178d4eb 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -260,11 +260,14 @@ struct list_set {
 		else
 			prev = e;
 	}
+
+	/* If before/after is used on an empty set */
+	if ((d->before > 0 && !next) ||
+	    (d->before < 0 && !prev))
+		return -IPSET_ERR_REF_EXIST;
+
 	/* Re-add already existing element */
 	if (n) {
-		if ((d->before > 0 && !next) ||
-		    (d->before < 0 && !prev))
-			return -IPSET_ERR_REF_EXIST;
 		if (!flag_exist)
 			return -IPSET_ERR_EXIST;
 		/* Update extensions */
-- 
1.8.5.1

