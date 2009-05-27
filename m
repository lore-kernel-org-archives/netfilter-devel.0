From: Jan Engelhardt <jengelh@medozas.de>
Subject: [2/2] ipset: change %i -> %d
Date: Wed, 27 May 2009 14:36:07 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0905271435500.26986@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0905271400540.26986@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48491 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760570AbZE0MgG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 May 2009 08:36:06 -0400
In-Reply-To: <alpine.LSU.2.00.0905271400540.26986@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


parent a1b31451f546a536fc3a37647437a048bda6601a ()
commit 1e768f11ad05fb8ccc3738eb26a822d13190a739
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed May 27 14:34:08 2009 +0200

ipset: change %i -> %d

%i is the historical, and deprecated, variant of %d.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ipset.c         |    4 ++--
 ipset_ipmap.c   |    4 ++--
 kernel/ip_set.c |   12 ++++++------
 libipt_set.h    |    2 +-
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/ipset.c b/ipset.c
index de6a4ec..5ff32cf 100644
--- a/ipset.c
+++ b/ipset.c
@@ -1577,7 +1577,7 @@ static int set_adtip(struct set *set, const char *adt,
 
 	/* Alloc memory for the data to send */
 	size = sizeof(struct ip_set_req_adt) + set->settype->adt_size ;
-	DP("alloc size %i", size);
+	DP("alloc size %d", size);
 	data = ipset_malloc(size);
 
 	/* Fill out the request */
@@ -1663,7 +1663,7 @@ static int set_bind(struct set *set, const char *adt,
 		size += IP_SET_MAXNAMELEN;
 	else if (!(op == IP_SET_OP_UNBIND_SET && set == NULL))
 		size += set->settype->adt_size;
-	DP("alloc size %i", size);
+	DP("alloc size %d", size);
 	data = ipset_malloc(size);
 
 	/* Fill out the request */
diff --git a/ipset_ipmap.c b/ipset_ipmap.c
index 287b057..992a862 100644
--- a/ipset_ipmap.c
+++ b/ipset_ipmap.c
@@ -225,12 +225,12 @@ initheader(struct set *set, const void *data)
 		mask = range_to_mask(header->from, header->to, &mask_bits);
 		netmask_bits = mask_to_bits(header->netmask);
 
-		DP("bits: %i %i", mask_bits, netmask_bits);
+		DP("bits: %d %d", mask_bits, netmask_bits);
 		map->hosts = 2 << (32 - netmask_bits - 1);
 		map->sizeid = 2 << (netmask_bits - mask_bits - 1);
 	}
 
-	DP("%i %i", map->hosts, map->sizeid );
+	DP("%d %d", map->hosts, map->sizeid );
 }
 
 static void
diff --git a/kernel/ip_set.c b/kernel/ip_set.c
index 8b9ee3a..fd01e83 100644
--- a/kernel/ip_set.c
+++ b/kernel/ip_set.c
@@ -1220,7 +1220,7 @@ static int ip_set_save_set(ip_set_id_t index,
 	*used += sizeof(struct ip_set_save);
 
 	set = ip_set_list[index];
-	DP("set: %s, used: %i(%i) %p %p", set->name, *used, len,
+	DP("set: %s, used: %d(%d) %p %p", set->name, *used, len,
 	   data, data + *used);
 
 	read_lock_bh(&set->lock);
@@ -1237,7 +1237,7 @@ static int ip_set_save_set(ip_set_id_t index,
 	set->type->list_header(set, data + *used);
 	*used += set_save->header_size;
 
-	DP("set header filled: %s, used: %i(%lu) %p %p", set->name, *used,
+	DP("set header filled: %s, used: %d(%lu) %p %p", set->name, *used,
 	   (unsigned long)set_save->header_size, data, data + *used);
 	/* Get and ensure set specific members size */
 	set_save->members_size = set->type->list_members_size(set);
@@ -1248,7 +1248,7 @@ static int ip_set_save_set(ip_set_id_t index,
 	set->type->list_members(set, data + *used);
 	*used += set_save->members_size;
 	read_unlock_bh(&set->lock);
-	DP("set members filled: %s, used: %i(%lu) %p %p", set->name, *used,
+	DP("set members filled: %s, used: %d(%lu) %p %p", set->name, *used,
 	   (unsigned long)set_save->members_size, data, data + *used);
 	return 0;
 
@@ -1329,7 +1329,7 @@ static int ip_set_restore(void *data,
 	while (1) {
 		line++;
 		
-		DP("%i %zu %i", used, sizeof(struct ip_set_restore), len);
+		DP("%d %zu %d", used, sizeof(struct ip_set_restore), len);
 		/* Get and ensure header size */
 		if (used + sizeof(struct ip_set_restore) > len)
 			return line;
@@ -1373,7 +1373,7 @@ static int ip_set_restore(void *data,
 		while (members_size + set->type->reqsize <=
 		       set_restore->members_size) {
 			line++;
-		       	DP("members: %i, line %i", members_size, line);
+			DP("members: %d, line %d", members_size, line);
 			res = __ip_set_addip(index,
 					   data + used + members_size,
 					   set->type->reqsize);
@@ -1382,7 +1382,7 @@ static int ip_set_restore(void *data,
 			members_size += set->type->reqsize;
 		}
 
-		DP("members_size %lu  %i",
+		DP("members_size %lu  %d",
 		   (unsigned long)set_restore->members_size, members_size);
 		if (members_size != set_restore->members_size)
 			return line++;
diff --git a/libipt_set.h b/libipt_set.h
index 0521251..b7f23f0 100644
--- a/libipt_set.h
+++ b/libipt_set.h
@@ -36,7 +36,7 @@ parse_bindings(const char *optarg, struct ipt_set_info *info)
 
 	if (tmp)
 		exit_error(PARAMETER_PROBLEM,
-			   "Can't follow bindings deeper than %i.", 
+			   "Can't follow bindings deeper than %d.",
 			   IP_SET_MAX_BINDINGS);
 
 	free(saved);
-- 
# Created with git-export-patch
