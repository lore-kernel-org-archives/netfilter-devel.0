From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH]: several small patches
Date: Sun, 15 Jun 2003 20:50:25 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EECBFF1.2070503@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070104070309020309020608"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------070104070309020309020608
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi Harald,
these are some patches that summed up, mostly one liners.
If you would like i could also combine some of these.

1. ip_conntrack-outdated-comment.diff:
remove outdated comment in ip_conntrack_expect_related
that seems to have it's origin in time before newnat. it also
makes the initialization of new->use explicit.

2. ip-conntrack-unneeded-check.diff:
remove double-check for ct->master, master_ct() also does the
check.

3. ip-conntrack-unconfirmed-expect.diff:
in init_conntrack: do not delete timer/call expect function for
connections matching expectations from unconfirmed connections.

4. unneeded-init.diff:
this is an old patch which removes some memset(x,0,..) for
data in bss segment. some more unneeded initializations since
last post:

- conntrack->tuplehash[IP_CT_DIR_ORIGINAL].list.next = NULL
in init_conntrack() seems to be forgotten when IPS_CONFIRMED
was introduced.
- memset and INIT_LIST_HEAD in ip_conntrack_expect_related()
are not required, memory is overwritten in the next line anyway
and list-member heads don't need to be initialized.

5. ip-conntrack-expect-drop-refcnt.diff:
drop master conntrack refcnt before setting expectant = NULL in
remove_expectations. untested but seems to make sense.

6. ip-conntrack-remove_expectations-list_for_each_safe.diff:
use list_for_each_safe in remove_expectations

Best regards,
Patrick
 

--------------070104070309020309020608
Content-Type: text/plain;
 name="01-ip_conntrack-outdated-comment.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01-ip_conntrack-outdated-comment.diff"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1201  -> 1.1202 
#	net/ipv4/netfilter/ip_conntrack_core.c	1.19    -> 1.20   
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/06/15	kaber@trash.net	1.1202
# remove outdated comment, explicitly set usage count to 1
# --------------------------------------------
#
diff -Nru a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c	Sun Jun 15 20:23:03 2003
+++ b/net/ipv4/netfilter/ip_conntrack_core.c	Sun Jun 15 20:23:03 2003
@@ -1041,10 +1041,7 @@
 	memcpy(new, expect, sizeof(*expect));
 	new->expectant = related_to;
 	new->sibling = NULL;
-	/* increase usage count. This sucks. The memset above overwrites
-	 * old usage count [if still present] and we increase to one.  Only
-	 * works because everything is done under ip_conntrack_lock() */
-	atomic_inc(&new->use);
+	atomic_set(&new->use, 1);
 	
 	/* add to expected list for this connection */	
 	list_add(&new->expected_list, &related_to->sibling_list);

--------------070104070309020309020608
Content-Type: text/plain;
 name="02-ip-conntrack-unneeded-check.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02-ip-conntrack-unneeded-check.diff"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1202  -> 1.1203 
#	net/ipv4/netfilter/ip_conntrack_core.c	1.20    -> 1.21   
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/06/15	kaber@trash.net	1.1203
# remove double check for ct->master, master_ct() also checks
# --------------------------------------------
#
diff -Nru a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c	Sun Jun 15 20:23:35 2003
+++ b/net/ipv4/netfilter/ip_conntrack_core.c	Sun Jun 15 20:23:35 2003
@@ -313,7 +313,7 @@
 	IP_NF_ASSERT(atomic_read(&nfct->use) == 0);
 	IP_NF_ASSERT(!timer_pending(&ct->timeout));
 
-	if (ct->master && master_ct(ct))
+	if (master_ct(ct))
 		ip_conntrack_put(master_ct(ct));
 
 	/* To make sure we don't get any weird locking issues here:

--------------070104070309020309020608
Content-Type: text/plain;
 name="03-ip-conntrack-unconfirmed-expect.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="03-ip-conntrack-unconfirmed-expect.diff"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1203  -> 1.1204 
#	net/ipv4/netfilter/ip_conntrack_core.c	1.21    -> 1.22   
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/06/15	kaber@trash.net	1.1204
# [NETFILTER]: do not delete timer/call expect function for connections
# matching expectations from unconfirmed connections.
# --------------------------------------------
#
diff -Nru a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c	Sun Jun 15 20:24:32 2003
+++ b/net/ipv4/netfilter/ip_conntrack_core.c	Sun Jun 15 20:24:32 2003
@@ -705,6 +705,14 @@
 			     struct ip_conntrack_expect *, tuple);
 	READ_UNLOCK(&ip_conntrack_expect_tuple_lock);
 
+	/* If master is not in hash table yet (ie. packet hasn't left
+	   this machine yet), how can other end know about expected?
+	   Hence these are not the droids you are looking for (if
+	   master ct never got confirmed, we'd hold a reference to it
+	   and weird things would happen to future packets). */
+	if (expected && !is_confirmed(expected->expectant))
+		expected = NULL;
+
 	/* Look up the conntrack helper for master connections only */
 	if (!expected)
 		conntrack->helper = ip_ct_find_helper(&repl_tuple);
@@ -715,12 +723,7 @@
 	    && ! del_timer(&expected->timeout))
 		expected = NULL;
 
-	/* If master is not in hash table yet (ie. packet hasn't left
-	   this machine yet), how can other end know about expected?
-	   Hence these are not the droids you are looking for (if
-	   master ct never got confirmed, we'd hold a reference to it
-	   and weird things would happen to future packets). */
-	if (expected && is_confirmed(expected->expectant)) {
+	if (expected) {
 		DEBUGP("conntrack: expectation arrives ct=%p exp=%p\n",
 			conntrack, expected);
 		/* Welcome, Mr. Bond.  We've been expecting you... */

--------------070104070309020309020608
Content-Type: text/plain;
 name="04-unneeded-init.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="04-unneeded-init.diff"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1204  -> 1.1205 
#	net/ipv4/netfilter/ip_conntrack_core.c	1.22    -> 1.23   
#	net/ipv4/netfilter/ip_nat_ftp.c	1.6     -> 1.7    
#	net/ipv4/netfilter/ipt_ULOG.c	1.6     -> 1.7    
#	net/ipv4/netfilter/ip_conntrack_irc.c	1.6     -> 1.7    
#	net/ipv4/netfilter/ip_conntrack_ftp.c	1.9     -> 1.10   
#	net/ipv4/netfilter/ip_nat_irc.c	1.3     -> 1.4    
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/06/15	kaber@trash.net	1.1205
# [NETFILTER]: remove unneeded initilizations/memsets
# --------------------------------------------
#
diff -Nru a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c	Sun Jun 15 20:25:00 2003
+++ b/net/ipv4/netfilter/ip_conntrack_core.c	Sun Jun 15 20:25:00 2003
@@ -695,9 +695,6 @@
 
 	INIT_LIST_HEAD(&conntrack->sibling_list);
 
-	/* Mark clearly that it's not in the hash table. */
-	conntrack->tuplehash[IP_CT_DIR_ORIGINAL].list.next = NULL;
-
 	WRITE_LOCK(&ip_conntrack_lock);
 	/* Need finding and deleting of expected ONLY if we win race */
 	READ_LOCK(&ip_conntrack_expect_tuple_lock);
@@ -1036,11 +1033,7 @@
 		return -ENOMEM;
 	}
 	
-	/* Zero out the new structure, then fill out it with the data */
 	DEBUGP("new expectation %p of conntrack %p\n", new, related_to);
-	memset(new, 0, sizeof(*expect));
-	INIT_LIST_HEAD(&new->list);
-	INIT_LIST_HEAD(&new->expected_list);
 	memcpy(new, expect, sizeof(*expect));
 	new->expectant = related_to;
 	new->sibling = NULL;
diff -Nru a/net/ipv4/netfilter/ip_conntrack_ftp.c b/net/ipv4/netfilter/ip_conntrack_ftp.c
--- a/net/ipv4/netfilter/ip_conntrack_ftp.c	Sun Jun 15 20:25:00 2003
+++ b/net/ipv4/netfilter/ip_conntrack_ftp.c	Sun Jun 15 20:25:00 2003
@@ -405,7 +405,6 @@
 		ports[0] = FTP_PORT;
 
 	for (i = 0; (i < MAX_PORTS) && ports[i]; i++) {
-		memset(&ftp[i], 0, sizeof(struct ip_conntrack_helper));
 		ftp[i].tuple.src.u.tcp.port = htons(ports[i]);
 		ftp[i].tuple.dst.protonum = IPPROTO_TCP;
 		ftp[i].mask.src.u.tcp.port = 0xFFFF;
diff -Nru a/net/ipv4/netfilter/ip_conntrack_irc.c b/net/ipv4/netfilter/ip_conntrack_irc.c
--- a/net/ipv4/netfilter/ip_conntrack_irc.c	Sun Jun 15 20:25:00 2003
+++ b/net/ipv4/netfilter/ip_conntrack_irc.c	Sun Jun 15 20:25:00 2003
@@ -259,8 +259,6 @@
 
 	for (i = 0; (i < MAX_PORTS) && ports[i]; i++) {
 		hlpr = &irc_helpers[i];
-		memset(hlpr, 0,
-		       sizeof(struct ip_conntrack_helper));
 		hlpr->tuple.src.u.tcp.port = htons(ports[i]);
 		hlpr->tuple.dst.protonum = IPPROTO_TCP;
 		hlpr->mask.src.u.tcp.port = 0xFFFF;
diff -Nru a/net/ipv4/netfilter/ip_nat_ftp.c b/net/ipv4/netfilter/ip_nat_ftp.c
--- a/net/ipv4/netfilter/ip_nat_ftp.c	Sun Jun 15 20:25:00 2003
+++ b/net/ipv4/netfilter/ip_nat_ftp.c	Sun Jun 15 20:25:00 2003
@@ -306,9 +306,6 @@
 		ports[0] = FTP_PORT;
 
 	for (i = 0; (i < MAX_PORTS) && ports[i]; i++) {
-
-		memset(&ftp[i], 0, sizeof(struct ip_nat_helper));
-
 		ftp[i].tuple.dst.protonum = IPPROTO_TCP;
 		ftp[i].tuple.src.u.tcp.port = htons(ports[i]);
 		ftp[i].mask.dst.protonum = 0xFFFF;
diff -Nru a/net/ipv4/netfilter/ip_nat_irc.c b/net/ipv4/netfilter/ip_nat_irc.c
--- a/net/ipv4/netfilter/ip_nat_irc.c	Sun Jun 15 20:25:00 2003
+++ b/net/ipv4/netfilter/ip_nat_irc.c	Sun Jun 15 20:25:00 2003
@@ -243,9 +243,6 @@
 
 	for (i = 0; (i < MAX_PORTS) && ports[i] != 0; i++) {
 		hlpr = &ip_nat_irc_helpers[i];
-		memset(hlpr, 0,
-		       sizeof(struct ip_nat_helper));
-
 		hlpr->tuple.dst.protonum = IPPROTO_TCP;
 		hlpr->tuple.src.u.tcp.port = htons(ports[i]);
 		hlpr->mask.src.u.tcp.port = 0xFFFF;
diff -Nru a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
--- a/net/ipv4/netfilter/ipt_ULOG.c	Sun Jun 15 20:25:00 2003
+++ b/net/ipv4/netfilter/ipt_ULOG.c	Sun Jun 15 20:25:00 2003
@@ -322,7 +322,6 @@
 
 	/* initialize ulog_buffers */
 	for (i = 0; i < ULOG_MAXNLGROUPS; i++) {
-		memset(&ulog_buffers[i], 0, sizeof(ulog_buff_t));
 		init_timer(&ulog_buffers[i].timer);
 		ulog_buffers[i].timer.function = ulog_timer;
 		ulog_buffers[i].timer.data = i;

--------------070104070309020309020608
Content-Type: text/plain;
 name="05-ip-conntrack-expect-drop-refcnt.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="05-ip-conntrack-expect-drop-refcnt.diff"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1205  -> 1.1206 
#	net/ipv4/netfilter/ip_conntrack_core.c	1.23    -> 1.24   
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/06/15	kaber@trash.net	1.1206
# [NETFILTER]: drop reference to conntrack after removing confirmed expectation
# --------------------------------------------
#
diff -Nru a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c	Sun Jun 15 20:37:57 2003
+++ b/net/ipv4/netfilter/ip_conntrack_core.c	Sun Jun 15 20:37:57 2003
@@ -275,6 +275,7 @@
 		if (exp->sibling) {
 			DEBUGP("remove_expectations: skipping established %p of %p\n", exp->sibling, ct);
 			/* Indicate that this expectations parent is dead */
+			ip_conntrack_put(exp->expectant);
 			exp->expectant = NULL;
 			continue;
 		}

--------------070104070309020309020608
Content-Type: text/plain;
 name="06-ip-conntrack-remove_expectations-list_for_each_safe.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="06-ip-conntrack-remove_expectations-list_for_each_safe.diff"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1206  -> 1.1207 
#	net/ipv4/netfilter/ip_conntrack_core.c	1.24    -> 1.25   
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/06/15	kaber@trash.net	1.1207
# [NETFILTER]: use list_for_each_safe in remove_expectations
# --------------------------------------------
#
diff -Nru a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c	Sun Jun 15 20:41:48 2003
+++ b/net/ipv4/netfilter/ip_conntrack_core.c	Sun Jun 15 20:41:48 2003
@@ -264,9 +264,7 @@
 
 	DEBUGP("remove_expectations(%p)\n", ct);
 
-	for (exp_entry = ct->sibling_list.next;
-	     exp_entry != &ct->sibling_list; exp_entry = next) {
-		next = exp_entry->next;
+	list_for_each_safe(exp_entry, next, &ct->sibling_list) {
 		exp = list_entry(exp_entry, struct ip_conntrack_expect,
 				 expected_list);
 

--------------070104070309020309020608--
