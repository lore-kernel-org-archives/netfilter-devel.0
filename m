From: Patrick Schaaf <bof@bof.de>
Subject: Re: init_conntrack() low hanging fruit
Date: Sun, 7 Jul 2002 20:11:03 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020707201103.Q13116@oknodo.bof.de>
References: <20020707123754.K13116@oknodo.bof.de> <20020707125141.L13116@oknodo.bof.de> <200207071340.53733@henrik.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="aT9PWwzfKXlsBJM1"
Cc: Patrick Schaaf <bof@bof.de>, netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <200207071340.53733@henrik.marasystems.com>; from hno@marasystems.com on Sun, Jul 07, 2002 at 01:40:53PM +0200
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--aT9PWwzfKXlsBJM1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 07, 2002 at 01:40:53PM +0200, Henrik Nordstrom wrote:
> 
> drop_next should most likely be made voilatile to protect from 
> compiler optimization evilness, and you may need to care for 
> alignment etc.... using atomic_t as proposed earlier feels like a 
> good bet.

I don't feel like arguing about the need for atomic_t here, so find
appended a rediff with your changes applied. It's safer this way,
and doesn't matter in performance.

> To other readers: We do not need to SMP synchronize here.. only SMP 
> criteria is that the value cannot be badly corrupted by concurrent 
> read/write to produce a invalid reading. It does not matter if a few 
> (or even many) iterations of drop_next is lost/forgotten/skipped.

Exactly.

While making the rediff, I noticed another small uglyness, also corrected
in the appended patch. hash_conntrack() is defined to return u_int32_t.
init_conntrack() uses size_t variables to hold the return values of
hash_conntrack(). I kept that in my earlier patch. Another function
uses a simple "unsigned int". In your mail, you used a signed "int".
To avoid future confusion, the attached patch uses u_int32_t in all
the places.

While worrying about that, I remembered the note about atomic_t only
guaranteeing 24 bit (apparently signed ones). As we are being paranoid,
there's also a patch to ip_conntrack_init(), enforcing this limitation.
Sorry, folks, no bucket sizes larger than 2^23-1 (8 million). Show me
a box where you need it. <smile/>

Oh, and while I was at that place, let's do the odd thing with the
even bucket sizes. All the pictures show it can only help.

all the best
  Patrick


--aT9PWwzfKXlsBJM1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="bof-conntrack.2.patch"

--- linux-2.4.19-post7/net/ipv4/netfilter/ip_conntrack_core.c	Fri Apr 19 21:50:25 2002
+++ bof-conntrack/net/ipv4/netfilter/ip_conntrack_core.c	Sun Jul  7 19:52:25 2002
@@ -271,7 +271,7 @@
 int
 __ip_conntrack_confirm(struct nf_ct_info *nfct)
 {
-	unsigned int hash, repl_hash;
+	u_int32_t hash, repl_hash;
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
 
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
+		static atomic_t drop_next = ATOMIC_INIT(0);
+		u_int32_t victim = atomic_read(&drop_next);
+		u_int32_t next = victim + 1;
+		atomic_set(&drop_next,
+				(next < ip_conntrack_htable_size) ? next : 0);
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
@@ -1097,7 +1100,21 @@
 			ip_conntrack_htable_size = 8192;
 		if (ip_conntrack_htable_size < 16)
 			ip_conntrack_htable_size = 16;
+		/*
+		 * Avoid even table sizes. They tend to be trouble.
+		 * NOTE: hashsize= module option overrides this!
+		 */
+		if (0 == (ip_conntrack_htable_size & 1))
+			ip_conntrack_htable_size--;
 	}
+
+	/*
+	 * protect against overflowing atomic_t drop_next, used in
+	 * init_conntrack(), above.
+	 */
+	if (ip_conntrack_htable_size >= (1 << 23))
+		ip_conntrack_htable_size = (1 << 23) - 1;
+
 	ip_conntrack_max = 8 * ip_conntrack_htable_size;
 
 	printk("ip_conntrack (%u buckets, %d max)\n",

--aT9PWwzfKXlsBJM1--
