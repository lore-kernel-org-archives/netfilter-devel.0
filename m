From: Marcelo Ricardo Leitner <mleitner@redhat.com>
Subject: [PATCH] netfilter: conntrack: adjust nf_conntrack_buckets default value
Date: Wed,  3 Dec 2014 17:30:19 -0200
Message-ID: <7537ac022aea771d7af0aef2bd3bb30e5fa0a008.1417634768.git.mleitner@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbaLCTad (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Dec 2014 14:30:33 -0500
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sB3JUWwe023014
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <netfilter-devel@vger.kernel.org>; Wed, 3 Dec 2014 14:30:32 -0500
Received: from localhost.localdomain.com (vpn1-4-239.gru2.redhat.com [10.97.4.239])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id sB3JUUjf002892
	for <netfilter-devel@vger.kernel.org>; Wed, 3 Dec 2014 14:30:31 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Manually bumping either nf_conntrack_buckets or nf_conntrack_max has
become a common task as our Linux servers tend to serve more and more
clients/applications, so let's adjust nf_conntrack_buckets this to a
more updated value.

Now for systems with more than 4GB of memory, nf_conntrack_buckets
becomes 65536 instead of 16384, resulting in nf_conntrack_max=256k
entries.

Signed-off-by: Marcelo Ricardo Leitner <mleitner@redhat.com>
---
 Documentation/networking/nf_conntrack-sysctl.txt |  3 ++-
 net/netfilter/nf_conntrack_core.c                | 11 ++++++++---
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/nf_conntrack-sysctl.txt b/Documentation/networking/nf_conntrack-sysctl.txt
index 70da5086153dbd24a9c9258e73cc16440d247519..f55599c62c9d61335005202146fdad75c8c133b9 100644
--- a/Documentation/networking/nf_conntrack-sysctl.txt
+++ b/Documentation/networking/nf_conntrack-sysctl.txt
@@ -11,7 +11,8 @@ nf_conntrack_buckets - INTEGER (read-only)
 	Size of hash table. If not specified as parameter during module
 	loading, the default size is calculated by dividing total memory
 	by 16384 to determine the number of buckets but the hash table will
-	never have fewer than 32 or more than 16384 buckets.
+	never have fewer than 32 and limited to 16384 buckets. For systems
+	with more than 4GB of memory it will be 65536 buckets.
 
 nf_conntrack_checksum - BOOLEAN
 	0 - disabled
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 5016a6929085ebdbf151a1f47582d36195885540..4ceb570541573bf246891f54563961fbc8e2eeff 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1627,13 +1627,18 @@ int nf_conntrack_init_start(void)
 	for (i = 0; i < CONNTRACK_LOCKS; i++)
 		spin_lock_init(&nf_conntrack_locks[i]);
 
-	/* Idea from tcp.c: use 1/16384 of memory.  On i386: 32MB
-	 * machine has 512 buckets. >= 1GB machines have 16384 buckets. */
 	if (!nf_conntrack_htable_size) {
+		/* Idea from tcp.c: use 1/16384 of memory.
+		 * On i386: 32MB machine has 512 buckets.
+		 * >= 1GB machines have 16384 buckets.
+		 * >= 4GB machines have 65536 buckets.
+		 */
 		nf_conntrack_htable_size
 			= (((totalram_pages << PAGE_SHIFT) / 16384)
 			   / sizeof(struct hlist_head));
-		if (totalram_pages > (1024 * 1024 * 1024 / PAGE_SIZE))
+		if (totalram_pages > (4 * (1024 * 1024 * 1024 / PAGE_SIZE)))
+			nf_conntrack_htable_size = 65536;
+		else if (totalram_pages > (1024 * 1024 * 1024 / PAGE_SIZE))
 			nf_conntrack_htable_size = 16384;
 		if (nf_conntrack_htable_size < 32)
 			nf_conntrack_htable_size = 32;
-- 
1.9.3

