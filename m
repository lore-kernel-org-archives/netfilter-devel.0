From: Jan Engelhardt <jengelh@medozas.de>
Subject: ipset 3.2 RT fixes
Date: Sat, 12 Sep 2009 02:22:44 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0909120220070.28279@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:41216 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114AbZILAWm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Sep 2009 20:22:42 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,


I have here a patch that I needed for compiling with 2.6.31-rc8-rt. 
(Works on vanilla too afterwards.)

parent e5bedea496d5e4e1ddd46de2cdea97b6913681b7 (v1.18-2-ge5bedea)
commit c66b25a009577fe01a57ad5a8d6269c10b1260c1
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Sat Sep 12 02:14:00 2009 +0200

ipset: fix compile error on 2.6.31-rt

ip_set.c:42:8: warning: type defaults to 'int' in declaration of
'DECLARE_MUTEX'

2.6.31-rt has cleaned up the naming mess in semaphore.h. Without
making use of #if hackery, we can use struct semaphore as declaration
plus an explicit sema_init() call.
---
 extensions/ipset/ip_set.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/extensions/ipset/ip_set.c b/extensions/ipset/ip_set.c
index 8ea57fc..df84f97 100644
--- a/extensions/ipset/ip_set.c
+++ b/extensions/ipset/ip_set.c
@@ -39,7 +39,7 @@
 static struct list_head set_type_list;		/* all registered sets */
 static struct ip_set **ip_set_list;		/* all individual sets */
 static DEFINE_RWLOCK(ip_set_lock);		/* protects the lists and the hash */
-static DECLARE_MUTEX(ip_set_app_mutex);		/* serializes user access */
+static struct semaphore ip_set_app_mutex;	/* serializes user access */
 static ip_set_id_t ip_set_max = CONFIG_IP_NF_SET_MAX;
 static ip_set_id_t ip_set_bindings_hash_size =  CONFIG_IP_NF_SET_HASHSIZE;
 static struct list_head *ip_set_hash;		/* hash of bindings */
@@ -2016,6 +2016,7 @@ static int __init ip_set_init(void)
 	int res;
 	ip_set_id_t i;
 
+	sema_init(&ip_set_app_mutex, 1);
 	get_random_bytes(&ip_set_hash_random, 4);
 	if (max_sets)
 		ip_set_max = max_sets;
-- 
# Created with git-export-patch
