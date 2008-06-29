From: Sven Wegener <sven.wegener@stealer.net>
Subject: [PATCH] ipset/iptreemap: Remove needless casts of void pointers
Date: Sun, 29 Jun 2008 19:40:42 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0806291939290.14884@titan.stealer.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.stealer.net ([88.198.224.204]:44926 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443AbYF2Rta (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 29 Jun 2008 13:49:30 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove needless casts from and to void pointers.
---
 ipset_iptreemap.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- ipset.orig/ipset_iptreemap.c
+++ ipset/ipset_iptreemap.c
@@ -31,7 +31,7 @@
 void
 create_init(void *data)
 {
-	struct ip_set_req_iptreemap_create *mydata = (struct ip_set_req_iptreemap_create *) data;
+	struct ip_set_req_iptreemap_create *mydata = data;
 
 	mydata->gc_interval = 0;
 }
@@ -39,7 +39,7 @@
 int
 create_parse(int c, char *argv[], void *data, unsigned int *flags)
 {
-	struct ip_set_req_iptreemap_create *mydata = (struct ip_set_req_iptreemap_create *) data;
+	struct ip_set_req_iptreemap_create *mydata = data;
 
 	switch (c) {
 		case 'g':
@@ -68,7 +68,7 @@
 ip_set_ip_t
 adt_parser(unsigned int cmd, const char *optarg, void *data)
 {
-	struct ip_set_req_iptreemap *mydata = (struct ip_set_req_iptreemap *) data;
+	struct ip_set_req_iptreemap *mydata = data;
 	ip_set_ip_t mask;
 
 	char *saved = ipset_strdup(optarg);
@@ -94,8 +94,8 @@
 void
 initheader(struct set *set, const void *data)
 {
-	struct ip_set_req_iptreemap_create *header = (struct ip_set_req_iptreemap_create *) data;
-	struct ip_set_iptreemap *map = (struct ip_set_iptreemap *) set->settype->header;
+	const struct ip_set_req_iptreemap_create *header = data;
+	struct ip_set_iptreemap *map = set->settype->header;
 
 	map->gc_interval = header->gc_interval;
 }
@@ -103,7 +103,7 @@
 void
 printheader(struct set *set, unsigned int options)
 {
-	struct ip_set_iptreemap *mysetdata = (struct ip_set_iptreemap *) set->settype->header;
+	struct ip_set_iptreemap *mysetdata = set->settype->header;
 
 	if (mysetdata->gc_interval)
 		printf(" gc: %u", mysetdata->gc_interval);
@@ -118,7 +118,7 @@
 	size_t offset = 0;
 
 	while (len >= offset + sizeof(struct ip_set_req_iptreemap)) {
-		req = (struct ip_set_req_iptreemap *) (data + offset);
+		req = data + offset;
 
 		printf("%s", ip_tostring(req->start, options));
 		if (req->start != req->end)
@@ -132,7 +132,7 @@
 void
 saveheader(struct set *set, unsigned int options)
 {
-	struct ip_set_iptreemap *mysetdata = (struct ip_set_iptreemap *) set->settype->header;
+	struct ip_set_iptreemap *mysetdata = set->settype->header;
 
 	printf("-N %s %s", set->name, set->settype->typename);
 
@@ -149,7 +149,7 @@
 	size_t offset = 0;
 
 	while (len >= offset + sizeof(struct ip_set_req_iptreemap)) {
-		req = (struct ip_set_req_iptreemap *) (data + offset);
+		req = data + offset;
 
 		printf("-A %s %s", set->name, ip_tostring(req->start, options));
 
