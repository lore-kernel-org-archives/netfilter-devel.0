From: Patrick Schaaf <bof@bof.de>
Subject: Re: init_conntrack() low hanging fruit
Date: Sun, 7 Jul 2002 12:51:41 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020707125141.L13116@oknodo.bof.de>
References: <20020707123754.K13116@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="i0/AhcQY5QxfSsSZ"
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Patrick Schaaf <bof@bof.de>
Content-Disposition: inline
In-Reply-To: <20020707123754.K13116@oknodo.bof.de>; from bof@bof.de on Sun, Jul 07, 2002 at 12:37:54PM +0200
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--i0/AhcQY5QxfSsSZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Just spotted one more thing, rediff appended. Now that I've saved some
horizontal screen real estate, the drop error can be single-line again...

:)
  Patrick


--i0/AhcQY5QxfSsSZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="bof-conntrack.1.patch"

--- linux-2.4.19-post7/net/ipv4/netfilter/ip_conntrack_core.c	Fri Apr 19 21:50:25 2002
+++ bof-conntrack/net/ipv4/netfilter/ip_conntrack_core.c	Sun Jul  7 12:36:57 2002
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
@@ -572,6 +557,23 @@
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
+		       "ip_conntrack: table full, dropping packet.\n");
+		return ERR_PTR(-ENOMEM);
+	}
 }
 
 /* On success, returns conntrack ptr, sets skb->nfct and ctinfo */

--i0/AhcQY5QxfSsSZ--
