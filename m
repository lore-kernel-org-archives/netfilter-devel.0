From: Pablo Neira <pablo@eurodev.net>
Subject: init_conntrack optimization
Date: Wed, 25 Feb 2004 13:40:05 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <403C97A5.7070109@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090606020800040200060109"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
	netfilter-devel@lists.netfilter.org
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
--------------090606020800040200060109
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Harald and list!

I patched the init_conntrack function to optimize the expectation handling.

With this patch, if an expectation is not found for the conntrack, it 
will look for an helper and go out, this way we save three "if's". By 
other hand, if an expectation is found we save one "if".

I consider that the general case is that an expectation is not found, 
isn't it? because most connection tracked by the system don't need a 
helper, so they not need to handle expectations.

BTW, can we consider that if there's no helper for a given tuple, it 
won't have expectations? because while writing the patch i had more 
ideas, maybe this could be optimized a bit more. Well, I'm not sure...

hope that i'm not missing anything! if so, please let me know.

cheers,
Pablo

--------------090606020800040200060109
Content-Type: text/plain;
 name="init_conntrack-optimize.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="init_conntrack-optimize.patch"

diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c' --exclude '*~' linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_core.c old-compiled/linux-2.6.3/net/ipv4/netfilter/ip_conntrack_core.c
--- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_core.c	2004-02-22 13:29:30.000000000 +0100
+++ old-compiled/linux-2.6.3/net/ipv4/netfilter/ip_conntrack_core.c	2004-02-25 13:02:35.000000000 +0100
@@ -691,42 +691,50 @@
 			     struct ip_conntrack_expect *, tuple);
 	READ_UNLOCK(&ip_conntrack_expect_tuple_lock);
 
-	/* If master is not in hash table yet (ie. packet hasn't left
-	   this machine yet), how can other end know about expected?
-	   Hence these are not the droids you are looking for (if
-	   master ct never got confirmed, we'd hold a reference to it
-	   and weird things would happen to future packets). */
-	if (expected && !is_confirmed(expected->expectant))
-		expected = NULL;
-
-	/* Look up the conntrack helper for master connections only */
-	if (!expected)
-		conntrack->helper = ip_ct_find_helper(&repl_tuple);
-
-	/* If the expectation is dying, then this is a loser. */
-	if (expected
-	    && expected->expectant->helper->timeout
-	    && ! del_timer(&expected->timeout))
-		expected = NULL;
-
 	if (expected) {
-		DEBUGP("conntrack: expectation arrives ct=%p exp=%p\n",
-			conntrack, expected);
-		/* Welcome, Mr. Bond.  We've been expecting you... */
-		IP_NF_ASSERT(master_ct(conntrack));
-		__set_bit(IPS_EXPECTED_BIT, &conntrack->status);
-		conntrack->master = expected;
-		expected->sibling = conntrack;
-		LIST_DELETE(&ip_conntrack_expect_list, expected);
-		expected->expectant->expecting--;
-		nf_conntrack_get(&master_ct(conntrack)->infos[0]);
-	}
-	atomic_inc(&ip_conntrack_count);
+		/* If master is not in hash table yet (ie. packet hasn't left
+		   this machine yet), how can other end know about expected?
+		   Hence these are not the droids you are looking for (if
+		   master ct never got confirmed, we'd hold a reference to it
+		   and weird things would happen to future packets). */
+		if (!is_confirmed(expected->expectant)) {
+			
+			conntrack->helper = ip_ct_find_helper(&repl_tuple);
+			goto end;
+		}
+
+		/* Expectation is dying... */
+		if (expected->expectant->helper->timeout
+		    && ! del_timer(&expected->timeout)) {
+			goto end;	
+		}
+
+                DEBUGP("conntrack: expectation arrives ct=%p exp=%p\n",
+                       conntrack, expected);
+                /* Welcome, Mr. Bond.  We've been expecting you... */
+                IP_NF_ASSERT(master_ct(conntrack));
+                __set_bit(IPS_EXPECTED_BIT, &conntrack->status);
+                conntrack->master = expected;
+                expected->sibling = conntrack;
+                LIST_DELETE(&ip_conntrack_expect_list, expected);
+                expected->expectant->expecting--;
+                nf_conntrack_get(&master_ct(conntrack)->infos[0]);
+
+		/* this is a braindead... --pablo */
+	        atomic_inc(&ip_conntrack_count);
+	        WRITE_UNLOCK(&ip_conntrack_lock);
+
+	        if (expected->expectfn)
+			expected->expectfn(conntrack);
+
+		goto ret;
+        } else 
+                conntrack->helper = ip_ct_find_helper(&repl_tuple);
+
+end:	atomic_inc(&ip_conntrack_count);
 	WRITE_UNLOCK(&ip_conntrack_lock);
 
-	if (expected && expected->expectfn)
-		expected->expectfn(conntrack);
-	return &conntrack->tuplehash[IP_CT_DIR_ORIGINAL];
+ret:	return &conntrack->tuplehash[IP_CT_DIR_ORIGINAL];
 }
 
 /* On success, returns conntrack ptr, sets skb->nfct and ctinfo */

--------------090606020800040200060109--
