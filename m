From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 31/69]: {ip,arp,ip6}_tables: fix sparse warnings in compat code
Date: Wed, 30 Jan 2008 21:17:42 +0100 (MET)
Message-ID: <20080130201740.29874.58601.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60708 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765052AbYA3URo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:17:44 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: {ip,arp,ip6}_tables: fix sparse warnings in compat code

  CHECK   net/ipv4/netfilter/ip_tables.c
net/ipv4/netfilter/ip_tables.c:1453:8: warning: incorrect type in argument 3 (different signedness)
net/ipv4/netfilter/ip_tables.c:1453:8:    expected int *size
net/ipv4/netfilter/ip_tables.c:1453:8:    got unsigned int [usertype] *size
net/ipv4/netfilter/ip_tables.c:1458:44: warning: incorrect type in argument 3 (different signedness)
net/ipv4/netfilter/ip_tables.c:1458:44:    expected int *size
net/ipv4/netfilter/ip_tables.c:1458:44:    got unsigned int [usertype] *size
net/ipv4/netfilter/ip_tables.c:1603:2: warning: incorrect type in argument 2 (different signedness)
net/ipv4/netfilter/ip_tables.c:1603:2:    expected unsigned int *i
net/ipv4/netfilter/ip_tables.c:1603:2:    got int *<noident>
net/ipv4/netfilter/ip_tables.c:1627:8: warning: incorrect type in argument 3 (different signedness)
net/ipv4/netfilter/ip_tables.c:1627:8:    expected int *size
net/ipv4/netfilter/ip_tables.c:1627:8:    got unsigned int *size
net/ipv4/netfilter/ip_tables.c:1634:40: warning: incorrect type in argument 3 (different signedness)
net/ipv4/netfilter/ip_tables.c:1634:40:    expected int *size
net/ipv4/netfilter/ip_tables.c:1634:40:    got unsigned int *size
net/ipv4/netfilter/ip_tables.c:1653:8: warning: incorrect type in argument 5 (different signedness)
net/ipv4/netfilter/ip_tables.c:1653:8:    expected unsigned int *i
net/ipv4/netfilter/ip_tables.c:1653:8:    got int *<noident>
net/ipv4/netfilter/ip_tables.c:1666:2: warning: incorrect type in argument 2 (different signedness)
net/ipv4/netfilter/ip_tables.c:1666:2:    expected unsigned int *i
net/ipv4/netfilter/ip_tables.c:1666:2:    got int *<noident>
  CHECK   net/ipv4/netfilter/arp_tables.c
net/ipv4/netfilter/arp_tables.c:1285:40: warning: incorrect type in argument 3 (different signedness)
net/ipv4/netfilter/arp_tables.c:1285:40:    expected int *size
net/ipv4/netfilter/arp_tables.c:1285:40:    got unsigned int *size
net/ipv4/netfilter/arp_tables.c:1543:44: warning: incorrect type in argument 3 (different signedness)
net/ipv4/netfilter/arp_tables.c:1543:44:    expected int *size
net/ipv4/netfilter/arp_tables.c:1543:44:    got unsigned int [usertype] *size
  CHECK   net/ipv6/netfilter/ip6_tables.c
net/ipv6/netfilter/ip6_tables.c:1481:8: warning: incorrect type in argument 3 (different signedness)
net/ipv6/netfilter/ip6_tables.c:1481:8:    expected int *size
net/ipv6/netfilter/ip6_tables.c:1481:8:    got unsigned int [usertype] *size
net/ipv6/netfilter/ip6_tables.c:1486:44: warning: incorrect type in argument 3 (different signedness)
net/ipv6/netfilter/ip6_tables.c:1486:44:    expected int *size
net/ipv6/netfilter/ip6_tables.c:1486:44:    got unsigned int [usertype] *size
net/ipv6/netfilter/ip6_tables.c:1631:2: warning: incorrect type in argument 2 (different signedness)
net/ipv6/netfilter/ip6_tables.c:1631:2:    expected unsigned int *i
net/ipv6/netfilter/ip6_tables.c:1631:2:    got int *<noident>
net/ipv6/netfilter/ip6_tables.c:1655:8: warning: incorrect type in argument 3 (different signedness)
net/ipv6/netfilter/ip6_tables.c:1655:8:    expected int *size
net/ipv6/netfilter/ip6_tables.c:1655:8:    got unsigned int *size
net/ipv6/netfilter/ip6_tables.c:1662:40: warning: incorrect type in argument 3 (different signedness)
net/ipv6/netfilter/ip6_tables.c:1662:40:    expected int *size
net/ipv6/netfilter/ip6_tables.c:1662:40:    got unsigned int *size
net/ipv6/netfilter/ip6_tables.c:1680:8: warning: incorrect type in argument 5 (different signedness)
net/ipv6/netfilter/ip6_tables.c:1680:8:    expected unsigned int *i
net/ipv6/netfilter/ip6_tables.c:1680:8:    got int *<noident>
net/ipv6/netfilter/ip6_tables.c:1693:2: warning: incorrect type in argument 2 (different signedness)
net/ipv6/netfilter/ip6_tables.c:1693:2:    expected unsigned int *i
net/ipv6/netfilter/ip6_tables.c:1693:2:    got int *<noident>

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit e31ab9c086cec05ec66429e4d60a12cb60615c0e
tree 7d55247673a73a6c25d1264ce4974a71012361af
parent 15a3018c4c11086b7dc5310aae4d1f13640fe844
author Patrick McHardy <kaber@trash.net> Tue, 29 Jan 2008 16:22:08 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 21:03:02 +0100

 include/linux/netfilter/x_tables.h |    8 ++++----
 net/ipv4/netfilter/ip_tables.c     |   10 ++++++----
 net/ipv6/netfilter/ip6_tables.c    |   10 ++++++----
 net/netfilter/x_tables.c           |    8 ++++----
 4 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 91a1dd5..11eea39 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -432,15 +432,15 @@ extern short xt_compat_calc_jump(int af, unsigned int offset);
 
 extern int xt_compat_match_offset(struct xt_match *match);
 extern int xt_compat_match_from_user(struct xt_entry_match *m,
-				     void **dstptr, int *size);
+				     void **dstptr, unsigned int *size);
 extern int xt_compat_match_to_user(struct xt_entry_match *m,
-				   void __user **dstptr, int *size);
+				   void __user **dstptr, unsigned int *size);
 
 extern int xt_compat_target_offset(struct xt_target *target);
 extern void xt_compat_target_from_user(struct xt_entry_target *t,
-				       void **dstptr, int *size);
+				       void **dstptr, unsigned int *size);
 extern int xt_compat_target_to_user(struct xt_entry_target *t,
-				    void __user **dstptr, int *size);
+				    void __user **dstptr, unsigned int *size);
 
 #endif /* CONFIG_COMPAT */
 #endif /* __KERNEL__ */
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 427bc9b..a73afa1 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1429,7 +1429,7 @@ struct compat_ipt_replace {
 
 static int
 compat_copy_entry_to_user(struct ipt_entry *e, void __user **dstptr,
-			  compat_uint_t *size, struct xt_counters *counters,
+			  unsigned int *size, struct xt_counters *counters,
 			  unsigned int *i)
 {
 	struct ipt_entry_target *t;
@@ -1476,7 +1476,7 @@ compat_find_calc_match(struct ipt_entry_match *m,
 		       const char *name,
 		       const struct ipt_ip *ip,
 		       unsigned int hookmask,
-		       int *size, int *i)
+		       int *size, unsigned int *i)
 {
 	struct xt_match *match;
 
@@ -1534,7 +1534,8 @@ check_compat_entry_size_and_hooks(struct compat_ipt_entry *e,
 	struct ipt_entry_target *t;
 	struct xt_target *target;
 	unsigned int entry_offset;
-	int ret, off, h, j;
+	unsigned int j;
+	int ret, off, h;
 
 	duprintf("check_compat_entry_size_and_hooks %p\n", e);
 	if ((unsigned long)e % __alignof__(struct compat_ipt_entry) != 0
@@ -1647,7 +1648,8 @@ static int
 compat_check_entry(struct ipt_entry *e, const char *name,
 				     unsigned int *i)
 {
-	int j, ret;
+	unsigned int j;
+	int ret;
 
 	j = 0;
 	ret = IPT_MATCH_ITERATE(e, check_match, name, &e->ip,
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 6fabb73..b91738a 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1457,7 +1457,7 @@ struct compat_ip6t_replace {
 
 static int
 compat_copy_entry_to_user(struct ip6t_entry *e, void __user **dstptr,
-			  compat_uint_t *size, struct xt_counters *counters,
+			  unsigned int *size, struct xt_counters *counters,
 			  unsigned int *i)
 {
 	struct ip6t_entry_target *t;
@@ -1504,7 +1504,7 @@ compat_find_calc_match(struct ip6t_entry_match *m,
 		       const char *name,
 		       const struct ip6t_ip6 *ipv6,
 		       unsigned int hookmask,
-		       int *size, int *i)
+		       int *size, unsigned int *i)
 {
 	struct xt_match *match;
 
@@ -1562,7 +1562,8 @@ check_compat_entry_size_and_hooks(struct compat_ip6t_entry *e,
 	struct ip6t_entry_target *t;
 	struct xt_target *target;
 	unsigned int entry_offset;
-	int ret, off, h, j;
+	unsigned int j;
+	int ret, off, h;
 
 	duprintf("check_compat_entry_size_and_hooks %p\n", e);
 	if ((unsigned long)e % __alignof__(struct compat_ip6t_entry) != 0
@@ -1674,7 +1675,8 @@ compat_copy_entry_from_user(struct compat_ip6t_entry *e, void **dstptr,
 static int compat_check_entry(struct ip6t_entry *e, const char *name,
 				     unsigned int *i)
 {
-	int j, ret;
+	unsigned int j;
+	int ret;
 
 	j = 0;
 	ret = IP6T_MATCH_ITERATE(e, check_match, name, &e->ipv6,
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index d7fbb1b..cd78fc8 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -399,7 +399,7 @@ int xt_compat_match_offset(struct xt_match *match)
 EXPORT_SYMBOL_GPL(xt_compat_match_offset);
 
 int xt_compat_match_from_user(struct xt_entry_match *m, void **dstptr,
-			      int *size)
+			      unsigned int *size)
 {
 	struct xt_match *match = m->u.kernel.match;
 	struct compat_xt_entry_match *cm = (struct compat_xt_entry_match *)m;
@@ -426,7 +426,7 @@ int xt_compat_match_from_user(struct xt_entry_match *m, void **dstptr,
 EXPORT_SYMBOL_GPL(xt_compat_match_from_user);
 
 int xt_compat_match_to_user(struct xt_entry_match *m, void __user **dstptr,
-			    int *size)
+			    unsigned int *size)
 {
 	struct xt_match *match = m->u.kernel.match;
 	struct compat_xt_entry_match __user *cm = *dstptr;
@@ -493,7 +493,7 @@ int xt_compat_target_offset(struct xt_target *target)
 EXPORT_SYMBOL_GPL(xt_compat_target_offset);
 
 void xt_compat_target_from_user(struct xt_entry_target *t, void **dstptr,
-				int *size)
+				unsigned int *size)
 {
 	struct xt_target *target = t->u.kernel.target;
 	struct compat_xt_entry_target *ct = (struct compat_xt_entry_target *)t;
@@ -519,7 +519,7 @@ void xt_compat_target_from_user(struct xt_entry_target *t, void **dstptr,
 EXPORT_SYMBOL_GPL(xt_compat_target_from_user);
 
 int xt_compat_target_to_user(struct xt_entry_target *t, void __user **dstptr,
-			     int *size)
+			     unsigned int *size)
 {
 	struct xt_target *target = t->u.kernel.target;
 	struct compat_xt_entry_target __user *ct = *dstptr;
