From: Patrick Schaaf <bof@bof.de>
Subject: init_conntrack() low hanging fruit
Date: Sun, 7 Jul 2002 12:37:54 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020707123754.K13116@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="NzB8fVQJ5HfG6fxh"
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

HiHo,

while wandering idly within init_conntrack() [ip_conntrack_core.c], I see
some low-hanging fruit we could easily reap. Find appended a totally untested
patch, for your review. Here's the issues:

- upon entry of init_conntrack(), the hash function computes the hash bucket
  corresponding to the tuple, unconditionally. There are two opportunities:
  first, the caller already just computed that hash function (which is
  hopefully constant on the same tuple). Pass the precomputed value and
  reuse it. Also, observe that the only _use_ of the computed hash value,
  is in the last chance of the early_drop logic, which has a miniscule
  probability of running at all. Thus, the interface change appears
  undesirable, so move the recomputation right to where it is needed.
- Having thought about the rareness of the early_out stuff, I move it out
  of line, to improve readability. Beat me up if you must, but goto's pretty.
- later in init_conntrack(), the hash function computes repl_hash, the hash
  value for the reply connection. I don't see any piece of code _using_
  that computed value. I remove the computation.
- as noted earlier, drop_next needs some more sanity. I think it is now ok.
  The rearranged code never writes anything >= the bucket count into
  memory, so no processor can read a bad index from there. They'll hover
  a bit at bucket nr. 0, but that's about as likely as the original race.

Note that I didn't even compile the patch. Incorporate any way you want.

best regards
  Patrick


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="bof-conntrack.1.patch"

--- linux-2.4.19-post7/net/ipv4/netfilter/ip_conntrack_core.c	Fri Apr 19 21:50:25 2002
+++ bof-conntrack/net/ipv4/netfilter/ip_conntrack_core.c	Sun Jul  7 12:19:29 2002
@@ -485,35 +485,20 @@
 {
 	struct ip_conntrack *conntrack;
 	struct ip_conntrack_tuple repl_tuple;
-	size_t hash, repl_hash;
 	struct ip_conntrack_expect *expected;
 	int i;
-	static unsigned int drop_next = 0;
-
-	hash = hash_conntrack(tuple);
 
 	if (ip_conntrack_max &&
 	    atomic_read(&ip_conntrack_count) >= ip_conntrack_max) {
-		/* Try dropping from random chain, or else from the
-                   chain about to put into (in case they're trying to
-                   bomb one hash chain). */
-		if (drop_next >= ip_conntrack_htable_size)
-			drop_next = 0;
-		if (!early_drop(&ip_conntrack_hash[drop_next++])
-		    && !early_drop(&ip_conntrack_hash[hash])) {
-			if (net_ratelimit())
-				printk(KERN_WARNING
-				       "ip_conntrack: table full, dropping"
-				       " packet.\n");
-			return ERR_PTR(-ENOMEM);
-		}
+		goto under_pressure;
 	}
 
+let_it_pass:
+
 	if (!invert_tuple(&repl_tuple, tuple, protocol)) {
 		DEBUGP("Can't invert tuple.\n");
 		return NULL;
 	}
-	repl_hash = hash_conntrack(&repl_tuple);
 
 	conntrack = kmem_cache_alloc(ip_conntrack_cachep, GFP_ATOMIC);
 	if (!conntrack) {
@@ -572,6 +557,24 @@
 	if (expected && expected->expectfn)
 		expected->expectfn(conntrack);
 	return &conntrack->tuplehash[IP_CT_DIR_ORIGINAL];
+
+under_pressure: {
+		/* Try dropping from random chain, or else from the
+		   chain about to put into (in case they're trying to
+		   bomb one hash chain). */
+		static size_t drop_next = 0;
+		size_t victim = drop_next;
+		size_t next = victim + 1;
+		drop_next = (next < ip_conntrack_htable_size) ? next : 0;
+		if (	early_drop(&ip_conntrack_hash[victim])
+		     || early_drop(&ip_conntrack_hash[hash_conntrack(tuple)]))
+			goto let_it_pass;
+		if (net_ratelimit())
+			printk(KERN_WARNING
+		       "ip_conntrack: table full, dropping"
+		       " packet.\n");
+		return ERR_PTR(-ENOMEM);
+	}
 }
 
 /* On success, returns conntrack ptr, sets skb->nfct and ctinfo */

--NzB8fVQJ5HfG6fxh--
