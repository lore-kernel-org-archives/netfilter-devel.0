From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] first version of optimized mark_source_chains()
Date: Thu, 5 Jun 2003 12:34:56 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030605103456.GG18183@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bi5JUZtvcfApsciF"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--bi5JUZtvcfApsciF
Content-Type: multipart/mixed; boundary="M38YqGLZlgb6RLPS"
Content-Disposition: inline


--M38YqGLZlgb6RLPS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

Since I'm going to be on short vacation till Tuesday, I wanted to post
the current version of the optimized loop detection /
mark_source_chains() implementation.

It spits out lots of debugging info, and is still a recursive
implementation - thus you might be able to overflow your kernel stack
with a very depth ruleset.  Also, it needs some cleanup.

I thought of the recursive version as a proof-of-concept, and later
implement a iterative version (patches are welcome *g*).

Anyway, you might give it a try.  Any improvements are welcome, but be
aware that I'm not going to reply within the next 5 days.

Thanks again to Andre Uratsuka Manoel for his suggested algorithm.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--M38YqGLZlgb6RLPS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="newloop-0.01.patch"
Content-Transfer-Encoding: quoted-printable

--- linux-2.4.21-rc6-nfpending-nfnl/net/ipv4/netfilter/ip_tables.c	2003-06-=
01 12:14:42.000000000 +0200
+++ linux-2.4.21-rc6-nfpending-nfnl-newloop/net/ipv4/netfilter/ip_tables.c	=
2003-06-03 23:03:18.000000000 +0200
@@ -7,6 +7,10 @@
  * 19 Jan 2002 Harald Welte <laforge@gnumonks.org>
  * 	- increase module usage count as soon as we have rules inside
  * 	  a table
+ * 28 May 2003 Harald Welte <laforge@netfilter.org>
+ * 	- implement more efficient loop detection / mark_source_chains
+ *	  (Idea by Andre Uratsuka Manoel <andre@insite.com.br>, implementation
+ *	   funded by Astaro AG, http://www.astaro.com/)
  */
 #include <linux/config.h>
 #include <linux/cache.h>
@@ -25,7 +29,7 @@
=20
 #include <linux/netfilter_ipv4/ip_tables.h>
=20
-/*#define DEBUG_IP_FIREWALL*/
+#define DEBUG_IP_FIREWALL
 /*#define DEBUG_ALLOW_ALL*/ /* Useful for remote debugging */
 /*#define DEBUG_IP_FIREWALL_USER*/
=20
@@ -41,6 +45,8 @@
 #define duprintf(format, args...)
 #endif
=20
+#define DEBUGP(format, args...) printk(__FUNCTION__ ":" format, ## args)
+
 #ifdef CONFIG_NETFILTER_DEBUG
 #define IP_NF_ASSERT(x)						\
 do {								\
@@ -68,12 +74,13 @@
 #define inline
 #endif
=20
-/*
+/* Locking is simple: we assume at worst case there will be one packet
+   in user context and one from bottom halves (or soft irq if Alexey's
+   softnet patch was applied).
+
    We keep a set of rules for each CPU, so we can avoid write-locking
-   them in the softirq when updating the counters and therefore
-   only need to read-lock in the softirq; doing a write_lock_bh() in user
-   context stops packets coming through and allows user context to read
-   the counters or update the rules.
+   them; doing a readlock_bh() stops packets coming through if we're
+   in user context.
=20
    To be cache friendly on SMP, we arrange them like so:
    [ n-entries ]
@@ -494,99 +501,232 @@
 	return 1;
 }
=20
-/* Figures out from what hook each rule can be called: returns 0 if
-   there are loops.  Puts hook bitmask in comefrom. */
-static int
+/******************/
+
+#if 0
+enum {
+	IPT_COLOR_WHITE =3D 1,
+	IPT_COLOR_GREY,
+	IPT_COLOR_BLACK
+} iptables_color;
+#endif
+
+#define 	IPT_COLOR_WHITE		1
+#define		IPT_COLOR_GREY		2
+#define		IPT_COLOR_BLACK		3
+
+struct chain_stack_element {
+	struct chain_stack_element *next;	/* next in stack */
+	struct ipt_entry *e;			/* pointer to chain */
+};
+
+static struct chain_stack_element *chain_stack =3D NULL;
+
+static inline struct ipt_entry *
+chain_stack_pop(void)
+{
+	struct chain_stack_element *se;
+	struct ipt_entry *e;
+
+	if (!chain_stack)
+		return NULL;
+
+	se =3D chain_stack;
+	chain_stack =3D se->next;
+	e =3D se->e;
+	kfree(se);
+
+	return e;
+}
+
+static inline int
+chain_stack_push(struct ipt_entry *e)
+{
+	struct chain_stack_element *se;
+
+	se =3D kmalloc(GFP_ATOMIC, sizeof(struct chain_stack_element));
+	if (!se)
+		return -1;
+
+	se->next =3D chain_stack;
+	se->e =3D e;
+	chain_stack =3D se;
+
+	return 0;
+}
+
+static inline int
+initialize_white(struct ipt_entry *e, struct ipt_table_info *tinfo,
+		 unsigned char *base, unsigned char *limit)
+{
+	int h;
+	struct ipt_entry_target *t =3D ipt_get_target(e);
+
+	for (h =3D 0; h < NF_IP_NUMHOOKS; h++) {
+		if ((unsigned char *)e - base  =3D=3D tinfo->hook_entry[h]) {
+			/* start of builtin chain */
+			DEBUGP("entry=3D%p: builtin chain, painting white\n", e);
+			e->counters.bcnt =3D IPT_COLOR_WHITE;
+			e->comefrom =3D 0;
+			return 0;
+		}
+	}
+		=09
+	if (!strcmp(t->u.user.name, IPT_ERROR_TARGET)) {
+		/* start of userdefined chain */
+		DEBUGP("entry=3D%p: user chain %s, painting white\n", e, t->data);
+		e->counters.bcnt =3D IPT_COLOR_WHITE;
+		e->comefrom =3D 0;
+	}
+
+	return 0;
+}
+
+/* dfs - depth first search
+ * returns 1 if loop found, 0 otherwise */
+int dfs(struct ipt_entry *ie, const char *base, int base_offset, char *end)
+{
+	struct ipt_entry *e;
+	int pos;
+
+	DEBUGP("entry=3D%p: dfs entered: base=3D%p, base_offset=3D0x%x, end=3D%p\=
n",
+		ie, base, base_offset, end);
+
+	if (ie->counters.bcnt =3D=3D IPT_COLOR_GREY) {
+		DEBUGP("entry=3D%p: already color grey, loop found\n", ie);
+		return 1;
+	}
+	if (ie->counters.bcnt =3D=3D IPT_COLOR_BLACK) {
+		DEBUGP("entry=3D%p: already color black, no loop below here\n", ie);
+		return 0;
+	}
+
+	if (ie->counters.bcnt !=3D IPT_COLOR_WHITE) {
+		printk(KERN_ERR "entry=3D%p: color not white (%d!=3D%d)\n",
+			ie, ie->counters.bcnt, IPT_COLOR_WHITE);
+		return 1;
+	}
+
+	DEBUGP("entry=3D%p: painting grey\n", ie);
+	ie->counters.bcnt =3D IPT_COLOR_GREY;
+
+	for (pos =3D base_offset, e =3D (struct ipt_entry *)((char *)base+base_of=
fset);=20
+	     base+base_offset <=3D end;=20
+	     pos +=3D e->next_offset, e =3D (struct ipt_entry *)((char *)base+pos=
)) {
+		struct ipt_standard_target *t =3D=20
+			(struct ipt_standard_target *) ipt_get_target(e);
+
+		DEBUGP("iterating over e=3D%p\n", e);
+		/* Unconditional return/END. */
+		if (e->target_offset =3D=3D sizeof(struct ipt_entry)
+		    && (strcmp(t->target.u.user.name, IPT_STANDARD_TARGET) =3D=3D 0)
+		    && t->verdict < 0 && unconditional(&e->ip)) {
+			/* unconditional return/end */
+			DEBUGP("chain=3D%p entry=3D%p: unconditional return, painting black\n",=
 ie, e);
+			ie->counters.bcnt =3D IPT_COLOR_BLACK;
+			chain_stack_push(ie);
+			return 0;
+		} else {
+			if (!strcmp(t->target.u.user.name, IPT_STANDARD_TARGET)
+			    && t->verdict >=3D 0) {
+				/* another jump */
+				struct ipt_entry *ejt =3D=20
+					(struct ipt_entry *) ((char *)base + t->verdict);
+				/* subtract size of chain head */
+				ejt =3D (char *)ejt - IPT_ALIGN(sizeof(struct ipt_entry)+sizeof(struct=
 ipt_entry_target)+IPT_TABLE_MAXNAMELEN);
+				DEBUGP("entry=3D%p: jump. recursing to %p\n", e, ejt);
+				if (dfs(ejt, base, t->verdict, end) =3D=3D 1)
+					return 1;
+			} else {
+				DEBUGP("entry=3D%p: normal rule, skipping\n", e);
+				/* a normal rule */
+			}
+			continue;
+		}
+		/* not reached */
+		DEBUGP("entry=3D%p: not reached!!!!!!!!\n", e);
+	}
+	/* not reached */
+	DEBUGP("recursed over end of table ?!?\n");
+	return -1;
+}
+
+/* returns 1 if no loops found */
+static int=20
 mark_source_chains(struct ipt_table_info *newinfo, unsigned int valid_hook=
s)
 {
 	unsigned int hook;
+	struct ipt_entry *ie;
+
+	DEBUGP("entered\n");
+
+	/* paint all chains white, initialize comefrom  */
+	IPT_ENTRY_ITERATE(newinfo->entries, newinfo->size,=20
+			  initialize_white, newinfo, newinfo->entries,
+			  newinfo->entries + newinfo->size);
=20
-	/* No recursion; use packet counter to save back ptrs (reset
-	   to 0 as we leave), and comefrom to save source hook bitmask */
 	for (hook =3D 0; hook < NF_IP_NUMHOOKS; hook++) {
 		unsigned int pos =3D newinfo->hook_entry[hook];
-		struct ipt_entry *e
+		struct ipt_entry *e=20
 			=3D (struct ipt_entry *)(newinfo->entries + pos);
=20
 		if (!(valid_hooks & (1 << hook)))
 			continue;
=20
-		/* Set initial back pointer. */
-		e->counters.pcnt =3D pos;
+		if (dfs(e, newinfo->entries, pos,=20
+			newinfo->entries + newinfo->size) =3D=3D 1) {
+			/* loop detected, returning */
+			return 0;
+		}
+	}
=20
-		for (;;) {
-			struct ipt_standard_target *t
-				=3D (void *)ipt_get_target(e);
+	/* now we can be sure that there are no loops */
=20
-			if (e->comefrom & (1 << NF_IP_NUMHOOKS)) {
-				printk("iptables: loop hook %u pos %u %08X.\n",
-				       hook, pos, e->comefrom);
-				return 0;
-			}
-			e->comefrom
-				|=3D ((1 << hook) | (1 << NF_IP_NUMHOOKS));
+	/* initialize comefrom of builtin hooks / entry points */
+	for (hook =3D 0; hook < NF_IP_NUMHOOKS; hook++) {
+		unsigned int pos =3D newinfo->hook_entry[hook];
+		struct ipt_entry *e
+			=3D (struct ipt_entry *)(newinfo->entries + pos);
=20
-			/* Unconditional return/END. */
+		/* initialize comefrom of builtin chains */
+		e->comefrom =3D (1 << hook);
+	}
+
+	/* FIXME: while no chains on stack, pop and set comefrom */
+	while (ie =3D chain_stack_pop()) {
+		struct ipt_entry *e =3D ie;
+		DEBUGP("popping chain %p from stack\n", ie);
+		for (;;) {
+			struct ipt_standard_target *t =3D (struct ipt_standard_target *) ipt_ge=
t_target(e);
+			DEBUGP("iterating over entry %p\n", e);
 			if (e->target_offset =3D=3D sizeof(struct ipt_entry)
-			    && (strcmp(t->target.u.user.name,
-				       IPT_STANDARD_TARGET) =3D=3D 0)
-			    && t->verdict < 0
-			    && unconditional(&e->ip)) {
-				unsigned int oldpos, size;
-
-				/* Return: backtrack through the last
-				   big jump. */
-				do {
-					e->comefrom ^=3D (1<<NF_IP_NUMHOOKS);
-#ifdef DEBUG_IP_FIREWALL_USER
-					if (e->comefrom
-					    & (1 << NF_IP_NUMHOOKS)) {
-						duprintf("Back unset "
-							 "on hook %u "
-							 "rule %u\n",
-							 hook, pos);
-					}
-#endif
-					oldpos =3D pos;
-					pos =3D e->counters.pcnt;
-					e->counters.pcnt =3D 0;
-
-					/* We're at the start. */
-					if (pos =3D=3D oldpos)
-						goto next;
-
-					e =3D (struct ipt_entry *)
-						(newinfo->entries + pos);
-				} while (oldpos =3D=3D pos + e->next_offset);
-
-				/* Move along one */
-				size =3D e->next_offset;
-				e =3D (struct ipt_entry *)
-					(newinfo->entries + pos + size);
-				e->counters.pcnt =3D pos;
-				pos +=3D size;
+			    && (strcmp(t->target.u.user.name, IPT_STANDARD_TARGET) =3D=3D 0)
+			    && t->verdict < 0 && unconditional(&e->ip)) {
+				/* unconditional return */
+				goto next_chain;
 			} else {
-				int newpos =3D t->verdict;
-
-				if (strcmp(t->target.u.user.name,
-					   IPT_STANDARD_TARGET) =3D=3D 0
-				    && newpos >=3D 0) {
-					/* This a jump; chase it. */
-					duprintf("Jump rule %u -> %u\n",
-						 pos, newpos);
+				DEBUGP("entry=3D%p, setting comefrom 0x%x->0x%x\n", e, e->comefrom, e-=
>comefrom|ie->comefrom);
+				e->comefrom |=3D ie->comefrom;
+				if (!strcmp(t->target.u.user.name, IPT_STANDARD_TARGET)
+				    && t->verdict >=3D 0) {
+					/* a jump */
+					struct ipt_entry *ejt =3D=20
+						(struct ipt_entry *) ((char *)newinfo->entries + t->verdict);
+					/* subtract size of chain head */
+					ejt =3D (char *)ejt - IPT_ALIGN(sizeof(struct ipt_entry)+sizeof(struc=
t ipt_entry_target)+IPT_TABLE_MAXNAMELEN);
+					DEBUGP("entry=3D%p jump: setting target=3D%p comefrom 0x%x->0x%x\n", =
e, ejt, ejt->comefrom, ejt->comefrom | ie->comefrom);
+					ejt->comefrom |=3D ie->comefrom;
 				} else {
-					/* ... this is a fallthru */
-					newpos =3D pos + e->next_offset;
+					/* normal rule */
 				}
-				e =3D (struct ipt_entry *)
-					(newinfo->entries + newpos);
-				e->counters.pcnt =3D pos;
-				pos =3D newpos;
+				/* in any case, go on with next rule */
+				e =3D (char *) e + e->next_offset;
 			}
+			/* FIXME: don't run over end of table */
 		}
-		next:
-		duprintf("Finished chain %u\n", hook);
+next_chain:
 	}
+
 	return 1;
 }
=20
@@ -705,6 +845,7 @@
=20
 	if (t->u.kernel.target =3D=3D &ipt_standard_target) {
 		if (!standard_check(t, size)) {
+			duprintf("check_entry: standard check failed\n");
 			ret =3D -EINVAL;
 			goto cleanup_matches;
 		}


--M38YqGLZlgb6RLPS--

--bi5JUZtvcfApsciF
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+3xzQXaXGVTD0i/8RAr9BAJ9lD2E2uhGNZ2u6eObiQkrKdRzhywCfQQRK
qdRy8zFbhRRmD/FoFgw3B1s=
=PoD5
-----END PGP SIGNATURE-----

--bi5JUZtvcfApsciF--
