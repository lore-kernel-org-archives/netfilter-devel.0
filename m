From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] init-conntrack-optimize does not apply to 2.4
Date: Fri, 1 Oct 2004 15:05:55 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20041001220555.GB30842@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="H1spWtNR+x+ondvy"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--H1spWtNR+x+ondvy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

init-conntrack-optimize in pom-ng depends on expect-slab-cache,
which requires kernel >= 2.6.6.  This breaks --batch mode on 2.4.
The below patch removes the 2.4 version and adds the proper 'requires'
entry.

Phil



--H1spWtNR+x+ondvy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-initconntrack

diff -ruN pom-orig/init_conntrack-optimize/info pom-new/init_conntrack-optimize/info
--- pom-orig/init_conntrack-optimize/info	2004-07-22 16:30:39.000000000 -0400
+++ pom-new/init_conntrack-optimize/info	2004-10-01 17:59:05.299613768 -0400
@@ -1,4 +1,5 @@
 Author: Pablo Neira <pablo@eurodev.net>
 Status: Pending for kernel inclusion
 Repository: pending
+Requires: linux >= 2.6.6
 Depends: expect-slab-cache
diff -ruN pom-orig/init_conntrack-optimize/linux-2.4.patch pom-new/init_conntrack-optimize/linux-2.4.patch
--- pom-orig/init_conntrack-optimize/linux-2.4.patch	2004-05-08 10:27:54.000000000 -0400
+++ pom-new/init_conntrack-optimize/linux-2.4.patch	1969-12-31 19:00:00.000000000 -0500
@@ -1,84 +0,0 @@
---- linux-2.4.25-old/net/ipv4/netfilter/ip_conntrack_core.c	2004-02-18 14:36:32.000000000 +0100
-+++ linux-2.4.25/net/ipv4/netfilter/ip_conntrack_core.c	2004-02-25 16:46:30.000000000 +0100
-@@ -708,42 +708,48 @@
- 			     struct ip_conntrack_expect *, tuple);
- 	READ_UNLOCK(&ip_conntrack_expect_tuple_lock);
- 
--	/* If master is not in hash table yet (ie. packet hasn't left
--	   this machine yet), how can other end know about expected?
--	   Hence these are not the droids you are looking for (if
--	   master ct never got confirmed, we'd hold a reference to it
--	   and weird things would happen to future packets). */
--	if (expected && !is_confirmed(expected->expectant))
--		expected = NULL;
--
--	/* Look up the conntrack helper for master connections only */
--	if (!expected)
--		conntrack->helper = ip_ct_find_helper(&repl_tuple);
--
--	/* If the expectation is dying, then this is a looser. */
--	if (expected
--	    && expected->expectant->helper->timeout
--	    && ! del_timer(&expected->timeout))
--		expected = NULL;
--
- 	if (expected) {
--		DEBUGP("conntrack: expectation arrives ct=%p exp=%p\n",
--			conntrack, expected);
--		/* Welcome, Mr. Bond.  We've been expecting you... */
--		IP_NF_ASSERT(master_ct(conntrack));
--		__set_bit(IPS_EXPECTED_BIT, &conntrack->status);
--		conntrack->master = expected;
--		expected->sibling = conntrack;
--		LIST_DELETE(&ip_conntrack_expect_list, expected);
--		expected->expectant->expecting--;
--		nf_conntrack_get(&master_ct(conntrack)->infos[0]);
--	}
--	atomic_inc(&ip_conntrack_count);
-+		/* If master is not in hash table yet (ie. packet hasn't left
-+		   this machine yet), how can other end know about expected?
-+		   Hence these are not the droids you are looking for (if
-+		   master ct never got confirmed, we'd hold a reference to it
-+		   and weird things would happen to future packets). */
-+		if (!is_confirmed(expected->expectant)) {
-+			conntrack->helper = ip_ct_find_helper(&repl_tuple);
-+			goto end;
-+		}
-+
-+		/* Expectation is dying... */
-+		if (expected->expectant->helper->timeout
-+		    && !del_timer(&expected->timeout))
-+			goto end;	
-+
-+		DEBUGP("conntrack: expectation arrives ct=%p exp=%p\n",
-+			conntrack, expected);
-+		/* Welcome, Mr. Bond.  We've been expecting you... */
-+		IP_NF_ASSERT(master_ct(conntrack));
-+		__set_bit(IPS_EXPECTED_BIT, &conntrack->status);
-+		conntrack->master = expected;
-+		expected->sibling = conntrack;
-+		LIST_DELETE(&ip_conntrack_expect_list, expected);
-+		expected->expectant->expecting--;
-+		nf_conntrack_get(&master_ct(conntrack)->infos[0]);
-+
-+		/* this is a braindead... */
-+		atomic_inc(&ip_conntrack_count);
-+		WRITE_UNLOCK(&ip_conntrack_lock);
-+
-+		if (expected->expectfn)
-+			expected->expectfn(conntrack);
-+
-+		goto ret;
-+	} else 
-+		conntrack->helper = ip_ct_find_helper(&repl_tuple);
-+
-+end:	atomic_inc(&ip_conntrack_count);
- 	WRITE_UNLOCK(&ip_conntrack_lock);
- 
--	if (expected && expected->expectfn)
--		expected->expectfn(conntrack);
--	return &conntrack->tuplehash[IP_CT_DIR_ORIGINAL];
-+ret:	return &conntrack->tuplehash[IP_CT_DIR_ORIGINAL];
- }
- 
- /* On success, returns conntrack ptr, sets skb->nfct and ctinfo */

--H1spWtNR+x+ondvy--
