From: Dan Eble <dane@aiinet.com>
Subject: [PATCH] unused "prepend" argument
Date: Mon, 16 Sep 2002 15:24:56 -0400 (EDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0209161523100.26236-100000@dane-linux.aiinet.com>
Reply-To: <dane@aiinet.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

--- iptables-GPL-old/libiptc/libiptc.c	Wed May 29 09:08:16 2002
+++ iptables-GPL/libiptc/libiptc.c	Mon Sep 16 15:21:29 2002
@@ -699,13 +699,11 @@
 	return 1;
 }
 
-/* If prepend is set, then we are prepending to a chain: if the
- * insertion position is an entry point, keep the entry point. */
+/* If the insertion position is an entry point, keep the entry point. */
 static int
 insert_rules(unsigned int num_rules, unsigned int rules_size,
 	     const STRUCT_ENTRY *insert,
 	     unsigned int offset, unsigned int num_rules_offset,
-	     int prepend,
 	     TC_HANDLE_T *handle)
 {
 	TC_HANDLE_T newh;
@@ -939,7 +937,7 @@
 		return 0;
 
 	ret = insert_rules(1, e->next_offset, e, offset,
-			   chainindex + rulenum, rulenum == 0, handle);
+			   chainindex + rulenum, handle);
 	unmap_target((STRUCT_ENTRY *)e, &old);
 	return ret;
 }
@@ -982,7 +980,7 @@
 		return 0;
 
 	ret = insert_rules(1, e->next_offset, e, offset,
-			   chainindex + rulenum, 1, handle);
+			   chainindex + rulenum, handle);
 	unmap_target((STRUCT_ENTRY *)e, &old);
 	return ret;
 }
@@ -1011,7 +1009,7 @@
 	ret = insert_rules(1, e->next_offset, e,
 			   entry2offset(*handle, c->end),
 			   entry2index(*handle, c->end),
-			   0, handle);
+			   handle);
 	unmap_target((STRUCT_ENTRY *)e, &old);
 	return ret;
 }
@@ -1371,7 +1369,7 @@
 	ret = insert_rules(2, sizeof(newc), &newc.head,
 			   index2offset(*handle, (*handle)->new_number - 1),
 			   (*handle)->new_number - 1,
-			   0, handle);
+			   handle);
 	return ret;
 }
 
