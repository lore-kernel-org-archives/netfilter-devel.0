From: Olaf Rempel <razzor@kopf-tisch.de>
Subject: [iptables 1.3.0 / libiptc patch] sort chains by hooknum/names
Date: Fri, 4 Mar 2005 21:21:14 +0100
Message-ID: <20050304212114.130e2a7c@coruscant>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

hi list

>From 1.3.0 all chain names were alphabetically sorted when listing tables.
A user-defined chain 'AAA' is listed before the buildin chain "INPUT", and 
"FORWARD" is listed before "INPUT".

I've created two patches to revert it to the "old" behavior:
first buildin chains, sorted by hooknum, than userdefined chains, sorted by name.

OK, why two patches? 
The first one need some preconditions: 
*all* buildin chains need to be "in order" and in front of *any* user chain 
when parsing the kernel-list.

I was not sure about this, so I made a second patch, that does not need these
preconditions. 

Olaf


diff -uNr iptables-1.3.0.org/libiptc/libiptc.c iptables-1.3.0/libiptc/libiptc.c
--- iptables-1.3.0.org/libiptc/libiptc.c	2005-02-12 21:05:32.000000000 +0100
+++ iptables-1.3.0/libiptc/libiptc.c	2005-03-04 17:12:17.909906736 +0100
@@ -396,10 +396,13 @@
 {
 	struct chain_head *tmp;
 
-	list_for_each_entry(tmp, &h->chains, list) {
-		if (strcmp(c->name, tmp->name) <= 0) {
-			list_add(&c->list, tmp->list.prev);
-			return;
+	/* sort only user defined chains */
+	if (!c->hooknum) {
+		list_for_each_entry(tmp, &h->chains, list) {
+			if (strcmp(c->name, tmp->name) <= 0) {
+				list_add(&c->list, tmp->list.prev);
+				return;
+			}
 		}
 	}


diff -uNr iptables-1.3.0.org/libiptc/libiptc.c iptables-1.3.0/libiptc/libiptc.c
--- iptables-1.3.0.org/libiptc/libiptc.c	2005-02-12 21:05:32.000000000 +0100
+++ iptables-1.3.0/libiptc/libiptc.c	2005-03-04 17:20:12.720724520 +0100
@@ -396,10 +396,23 @@
 {
 	struct chain_head *tmp;
 
-	list_for_each_entry(tmp, &h->chains, list) {
-		if (strcmp(c->name, tmp->name) <= 0) {
-			list_add(&c->list, tmp->list.prev);
-			return;
+	/* sort only user defined chains */
+	if (!c->hooknum) {
+		/* sort user-defined by name and after builtins */
+		list_for_each_entry(tmp, &h->chains, list) {
+			if (!tmp->hooknum && strcmp(c->name, tmp->name) <= 0) {
+				list_add(&c->list, tmp->list.prev);
+				return;
+			}
+		}
+	
+	} else {
+		/* sort builtins by hooknum and before user-defined */
+		list_for_each_entry(tmp, &h->chains, list) {
+			if (!tmp->hooknum || tmp->hooknum > c->hooknum) {
+				list_add(&c->list, tmp->list.prev);
+				return;
+			}
 		}
 	}
 
