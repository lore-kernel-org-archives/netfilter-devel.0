From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: [libnl-nft PATCH] Fix out of bounds buffer access in rtnl_netem_set_delay_distribution()
Date: Tue, 25 Dec 2012 15:15:27 +0100
Message-ID: <50D9B4FF.9000806@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re04.intra2net.com ([82.165.46.26]:36983 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab2LYOVo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Dec 2012 09:21:44 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

sizeof(test_path) returns the array size
and not the number of array elements.

Detected by cppcheck

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
---
 lib/route/sch/netem.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/lib/route/sch/netem.c b/lib/route/sch/netem.c
index 18878a7..5894fd9 100644
--- a/lib/route/sch/netem.c
+++ b/lib/route/sch/netem.c
@@ -861,7 +861,7 @@ int rtnl_netem_set_delay_distribution(struct rtnl_qdisc *qdisc, const char *dist
 		return -NLE_NOMEM;
 		
 	FILE *f = NULL;
-	int i, n = 0;
+	int i = 0, n = 0;
 	size_t len = 2048;
 	char *line;
 	char name[NAME_MAX];
@@ -873,11 +873,12 @@ int rtnl_netem_set_delay_distribution(struct rtnl_qdisc *qdisc, const char *dist
 		strcpy(dist_suffix, "");
 	
 	/* Check several locations for the dist file */
-	char *test_path[] = { "", "./", "/usr/lib/tc/", "/usr/local/lib/tc/" };
+	char *test_path[] = { "", "./", "/usr/lib/tc/", "/usr/local/lib/tc/", NULL };
 	
-	for (i = 0; i < sizeof(test_path) && f == NULL; i++) {
+	while(f == NULL && test_path[i] != NULL) {
 		snprintf(name, NAME_MAX, "%s%s%s", test_path[i], dist_type, dist_suffix);
 		f = fopen(name, "r");
+		++i;
 	}
 	
 	if ( f == NULL )
-- 
1.7.11.7

