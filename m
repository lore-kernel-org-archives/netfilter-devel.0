From: Harald Welte <laforge@netfilter.org>
Subject: Re: [netfilter-core] asymptotic complexity when creating new chains and rules
Date: Tue, 6 Jan 2004 20:07:38 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040106190738.GD934@obroa-skai.de.gnumonks.org>
References: <20040104043038.16CC32C2C1@lists.samba.org> <Pine.LNX.4.33.0401051055260.27269-100000@fantomas.insite.com.br>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kA1LkgxZ0NN7Mz3A"
Cc: Rusty Russell <rusty@rustcorp.com.au>,
	Stefan Winter <mail@stefan-winter.de>,
	"netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Andre Uratsuka Manoel <andre@insite.com.br>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0401051055260.27269-100000@fantomas.insite.com.br>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--kA1LkgxZ0NN7Mz3A
Content-Type: multipart/mixed; boundary="11Y7aswkeuHtSBEs"
Content-Disposition: inline


--11Y7aswkeuHtSBEs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 05, 2004 at 11:11:33AM -0200, Andre Uratsuka Manoel wrote:

> 	I resumed working on that (again) last week, based on the cvs
> version of iptables, but I later noticed that on iptables-1.2.9 there is a
> directory called libiptc2. I have a lot of work done on iptables cvs. What
> is the status of libiptc2? I would like to keep on working on current line
> of work (libiptc2 seems to use the same approach as I do).

I've started to re-implement libiptc, and called it libiptc2.  However,
this was never finished.... just too much other work that distracted me
=66rom this.

The idea was to have iptables-1.3.x branch linked against the
'libiptc2'. libiptc2 would have it's whole internal representation of an
'ip table', linked list of rules, chains, etc.  Only at the TC_COMMIT
phase, the blob for kernel insertion would be created.

> I think I can get something out this week.

that would be great.  Please use the appended diff file (against latest CVS=
) as a starting point.

> 	Happy new year to all,

thanks.

> 	Andre

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--11Y7aswkeuHtSBEs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="a.diff"
Content-Transfer-Encoding: quoted-printable

Index: libiptc.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
RCS file: /cvsroot/netfilter/userspace/libiptc/libiptc.c,v
retrieving revision 1.41
retrieving revision 1.42
diff -u -r1.41 -r1.42
--- libiptc.c	5 Jul 2003 20:11:11 -0000	1.41
+++ libiptc.c	6 Jan 2004 18:59:46 -0000	1.42
@@ -1,4 +1,4 @@
-/* Library which manipulates firewall rules.  Version $Revision: 1.41 $ */
+/* Library which manipulates firewall rules.  Version $Revision: 1.42 $ */
=20
 /* Architecture of firewall rules is as follows:
  *
@@ -15,23 +15,19 @@
  * 2003-Jun-20: Harald Welte <laforge@netfilter.org>:
  *	- Reimplementation of chain cache to use offsets instead of entries
  * 2003-Jun-23: Harald Welte <laforge@netfilter.org>:
- * 	- performance optimization, sponsored by Astaro AG (http://www.astaro.=
com/)
+ * 	- speed optimization, sponsored by Astaro AG (http://www.astaro.com/)
  * 	  don't rebuild the chain cache after every operation, instead fix it
  * 	  up after a ruleset change. =20
+ * 2003-Jun-30: Harald Welte <laforge@netfilter.org>:
+ * 	- reimplementation from scratch. *sigh*.  I hope nobody has to touch=
=20
+ * 	  this code ever again.
  */
+#include "linux_listhelp.h"
=20
 #ifndef IPT_LIB_DIR
 #define IPT_LIB_DIR "/usr/local/lib/iptables"
 #endif
=20
-#ifndef __OPTIMIZE__
-STRUCT_ENTRY_TARGET *
-GET_TARGET(STRUCT_ENTRY *e)
-{
-	return (void *)e + e->target_offset;
-}
-#endif
-
 static int sockfd =3D -1;
 static void *iptc_fn =3D NULL;
=20
@@ -64,25 +60,55 @@
 	char error[TABLE_MAXNAMELEN];
 };
=20
-struct chain_cache
+struct rule_head
 {
+	struct list_head list;		/* list of rules in chain */
+=09
+	struct chain_head *chain;	/* we're part of this chain */
+
+	struct chain_head *jumpto;	/* target of this rule, in case
+					   it is a jump rule */
+
+	struct counter_map counter_map;
+
+	unsigned int size;		/* size of rule */
+	STRUCT_ENTRY *entry_blob;	/* pointer to entry in blob */
+	STRUCT_ENTRY entry[0];
+};
+
+struct chain_head
+{
+	struct list_head list;
+
 	char name[TABLE_MAXNAMELEN];
-	/* This is the first rule in chain. */
-	unsigned int start_off;
-	/* Last rule in chain */
-	unsigned int end_off;
+	unsigned int hooknum;
+	struct list_head rules;
+	struct rule_head *firstrule; 	/* first (ERROR) rule */
+	struct rule_head *lastrule;	/* last (RETURN) rule */
 };
=20
 STRUCT_TC_HANDLE
 {
 	/* Have changes been made? */
 	int changed;
-	/* Size in here reflects original state. */
+
+	/* linked list of chains in this table */
+	struct list_head chains;
+=09
+	/* current position of first_chain() / next_chain() */
+	struct chain_head *chain_iterator_cur;
+
+	/* current position of first_rule() / next_rule() */
+	struct rule_head *rule_iterator_cur;
+
+	/* the structure we receive from getsockopt() */
 	STRUCT_GETINFO info;
=20
-	struct counter_map *counter_map;
 	/* Array of hook names */
 	const char **hooknames;
+#if 0
+	/* Size in here reflects original state. */
+
=20
 	/* Cached position of chain heads (NULL =3D no cache). */
 	unsigned int cache_num_chains;
@@ -97,6 +123,7 @@
=20
 	/* Number in here reflects current state. */
 	unsigned int new_number;
+#endif
 	STRUCT_GET_ENTRIES entries;
 };
=20
@@ -113,6 +140,97 @@
 #define CHECK(h)
 #endif
=20
+static struct rule_head *ruleh_alloc(unsigned int size)
+{
+	struct rule_head *ruleh =3D malloc(sizeof(*ruleh)+size);
+	if (!ruleh)
+		return NULL;
+=09
+	memset(ruleh, 0, sizeof(*ruleh)+size);
+	ruleh->size =3D size;
+
+	return ruleh;
+}
+
+static void ruleh_free(struct rule_head *ruleh)
+{
+	list_del(&ruleh->list);
+	free(ruleh);
+}
+
+static struct chain_head *chainh_alloc(TC_HANDLE_T h, const char *name)
+{
+	struct chain_head *chainh =3D malloc(sizeof(*chainh));
+	if (!chainh)
+		return NULL;
+
+	memset(chainh, 0, sizeof(*chainh));
+	strncpy(chainh->name, name, sizeof(&chainh->name));
+	list_append(&chainh->list, &h->chains);
+
+	return chainh;
+}
+
+static void
+chainh_clean(struct chain_head *chainh)
+{
+	/* FIXME */
+	struct list_head *cur_item, *item2;
+
+	list_for_each_safe(cur_item, item2, &chainh->rules) {
+		struct rule_head *ruleh =3D list_entry(cur_item,=20
+						     struct rule_head,
+						    list);
+		ruleh_free(ruleh);
+	}
+}
+
+static void=20
+chainh_free(struct chain_head *chainh)
+{
+	chainh_clean(chainh);
+	list_del(&chainh->list);
+}
+
+static struct chain_head *
+chainh_find(TC_HANDLE_T h, const IPT_CHAINLABEL name)
+{
+	struct list_head *cur;
+
+	list_for_each(cur, &h->chains) {
+		struct chain_head *ch =3D list_entry(cur, struct chain_head,=20
+						   list);
+		if (!strcmp(name, ch->name))
+			return ch;
+	}
+	return NULL;
+}
+
+/* Returns chain head if found, otherwise NULL. */
+static struct chain_head *
+find_label(const char *name, TC_HANDLE_T handle)
+{
+	return chainh_find(handle, name);
+}
+
+
+/*=20
+ * functions that directly operate on the blob=20
+ */
+
+static inline unsigned long
+entry2offset(const TC_HANDLE_T h, const STRUCT_ENTRY *e)
+{
+	return (void *)e - (void *)h->entries.entrytable;
+}
+
+static inline STRUCT_ENTRY *
+get_entry(TC_HANDLE_T h, unsigned int offset)
+{
+	return (STRUCT_ENTRY *)((char *)h->entries.entrytable + offset);
+}
+
+/* needed by entry2index */
 static inline int
 get_number(const STRUCT_ENTRY *i,
 	   const STRUCT_ENTRY *seek,
@@ -164,24 +282,28 @@
 	return ret;
 }
=20
-static inline STRUCT_ENTRY *
-get_entry(TC_HANDLE_T h, unsigned int offset)
-{
-	return (STRUCT_ENTRY *)((char *)h->entries.entrytable + offset);
-}
-
 static inline unsigned long
-entry2offset(const TC_HANDLE_T h, const STRUCT_ENTRY *e)
+index2offset(TC_HANDLE_T h, unsigned int index)
 {
-	return (void *)e - (void *)h->entries.entrytable;
+	return entry2offset(h, index2entry(h, index));
 }
=20
-static inline unsigned long
-index2offset(TC_HANDLE_T h, unsigned int index)
+static char *
+get_errorlabel(TC_HANDLE_T h, unsigned int offset)
 {
-	return entry2offset(h, index2entry(h, index));
+	STRUCT_ENTRY *e;
+
+	e =3D get_entry(h, offset);
+	if (strcmp(GET_TARGET(e)->u.user.name, ERROR_TARGET) !=3D 0) {
+		fprintf(stderr, "ERROR: offset %u not an error node!\n",
+			offset);
+		abort();
+	}
+
+	return (char *)GET_TARGET(e)->data;
 }
=20
+#if 0
 static inline STRUCT_ENTRY *
 offset2entry(TC_HANDLE_T h, unsigned int offset)
 {
@@ -195,24 +317,12 @@
 }
=20
=20
-static const char *
-get_errorlabel(TC_HANDLE_T h, unsigned int offset)
-{
-	STRUCT_ENTRY *e;
-
-	e =3D get_entry(h, offset);
-	if (strcmp(GET_TARGET(e)->u.user.name, ERROR_TARGET) !=3D 0) {
-		fprintf(stderr, "ERROR: offset %u not an error node!\n",
-			offset);
-		abort();
-	}
-
-	return (const char *)GET_TARGET(e)->data;
-}
+#endif
=20
 /* Allocate handle of given size */
 static TC_HANDLE_T
-alloc_handle(const char *tablename, unsigned int size, unsigned int num_ru=
les)
+alloc_tc_handle(const char *tablename, unsigned int size,=20
+		unsigned int num_rules)
 {
 	size_t len;
 	TC_HANDLE_T h;
@@ -227,23 +337,162 @@
 	}
=20
 	h->changed =3D 0;
-	h->cache_num_chains =3D 0;
-	h->cache_chain_heads =3D NULL;
-	h->counter_map =3D (void *)h
-		+ sizeof(STRUCT_TC_HANDLE)
-		+ size;
+
 	strcpy(h->info.name, tablename);
 	strcpy(h->entries.name, tablename);
+	INIT_LIST_HEAD(&h->chains);
=20
 	return h;
 }
=20
+/* get the name of the chain that we jump to */
+static char *
+parse_jumptarget(const STRUCT_ENTRY *e, TC_HANDLE_T h)
+{
+	STRUCT_ENTRY *jumpto;
+	int spos, labelidx;
+
+	if (strcmp(GET_TARGET(e)->u.user.name, STANDARD_TARGET) !=3D 0) {
+		/* called for non-standard target */
+		return "__FIXME";
+	}
+	/* Standard target: evaluate */
+	spos =3D *(int *)GET_TARGET(e)->data;
+	if (spos < 0) {
+		return "__FIXME";
+	}
+
+	jumpto =3D get_entry(h, spos);
+
+	/* Fall through rule */
+	if (jumpto =3D=3D (void *)e + e->next_offset)
+		return "";
+
+	/* Must point to head of a chain: ie. after error rule */
+	/* FIXME: this needs to deal with internal jump targets */
+	labelidx =3D entry2index(h, jumpto) - 1;
+	return get_errorlabel(h, index2offset(h, labelidx));
+}
+
+/* parser functions */
+
+struct rule_head *
+append_entrycopy(const STRUCT_ENTRY *e, struct rule_head *prev)
+{
+	struct rule_head *ruleh =3D ruleh_alloc(e->next_offset);
+	if (!ruleh)
+		return NULL;
+=09
+	memcpy(&ruleh->entry, e, e->next_offset);
+	ruleh->chain =3D prev->chain;
+	ruleh->entry_blob =3D e;
+	list_append(&ruleh->list, &prev->list);
+
+	return ruleh;
+}
+
+/* have to return 0 on success, bcf ENTRY_ITERATE */
+static inline int=20
+parse_entry(const STRUCT_ENTRY *e, TC_HANDLE_T h, struct chain_head **curc=
hain)
+{
+	int i;
+	union tgt_u {
+		STRUCT_ENTRY_TARGET ent;
+		STRUCT_STANDARD_TARGET std;
+		struct ipt_error_target err;
+	} *tgt;
+
+	struct rule_head *lastrule =3D list_entry((*curchain)->rules.prev,
+						 struct rule_head, list);
+	struct rule_head *newrule;
+
+	tgt =3D (union tgt_u *) GET_TARGET(e);
+
+	if (e->target_offset =3D=3D sizeof(STRUCT_ENTRY)
+	    && (strcmp(tgt->ent.u.user.name, IPT_STANDARD_TARGET) =3D=3D 0)) {
+		/* jump to somewhere else */
+		char *targname;
+		struct chain_head *chainh;
+
+		newrule =3D append_entrycopy(e, lastrule);
+
+		targname =3D parse_jumptarget(e, h);
+		if (!(chainh =3D find_label(targname, h))) {
+			chainh =3D chainh_alloc(h, targname);
+		}
+		if (!chainh) {
+			errno =3D ENOMEM;
+			return 1;
+		}
+		newrule->jumpto =3D chainh;
+
+	} else if (e->target_offset =3D=3D sizeof(STRUCT_ENTRY)
+		   && e->next_offset =3D=3D sizeof(STRUCT_ENTRY)
+		   			+ ALIGN(sizeof(struct ipt_error_target))
+		   && !strcmp(tgt->ent.u.user.name, ERROR_TARGET)) {
+		/* chain head */
+		*curchain =3D chainh_find(h, tgt->err.error);
+		if (!(*curchain)) {
+			*curchain =3D chainh_alloc(h, tgt->err.error);
+			/* FIXME: error handling */
+		}
+		newrule =3D append_entrycopy(e, lastrule);
+		(*curchain)->firstrule =3D newrule;
+
+	} else if (e->target_offset =3D=3D sizeof(STRUCT_ENTRY)
+		   && e->next_offset =3D=3D sizeof(STRUCT_ENTRY)
+		   			+ ALIGN(sizeof(STRUCT_STANDARD_TARGET))
+		   && tgt->std.verdict =3D=3D RETURN) {
+		/* chain end */
+		newrule =3D append_entrycopy(e, lastrule);
+		(*curchain)->lastrule =3D newrule;
+		*curchain =3D NULL;
+	} else {
+		/* normal rule */
+		newrule =3D append_entrycopy(e, lastrule);
+	}
+
+	/* create counter map entry */
+	newrule->counter_map.maptype =3D COUNTER_MAP_NORMAL_MAP;
+	newrule->counter_map.mappos =3D entry2index(h, e);
+
+	/* iterate over hook_entries, needed to connect builtin
+	 * chains with hook numbers */
+	for (i =3D 0; i < NUMHOOKS; i++) {
+		if (!(h->info.valid_hooks & (1 << i)))
+			continue;
+		if (h->info.hook_entry[i] =3D=3D entry2offset(h, e)) {
+			/* found hook entry point */
+			if (*curchain)
+				(*curchain)->hooknum =3D i;
+		}
+		if (h->info.underflow[i] =3D=3D entry2offset(h, e)) {
+			/* found underflow point */
+		}
+	}
+
+	return 0;
+}
+
+static int parse_ruleset(TC_HANDLE_T h)
+{
+	struct chain_head *curchain;
+=09
+	/* iterate over ruleset; create linked list of rule_head/chain_head */
+	if (ENTRY_ITERATE(h->entries.entrytable, h->entries.size,=20
+		      parse_entry, h, &curchain)) {
+		/* some error happened while iterating */
+		return 0;
+	}
+
+	return 1;
+}
+
 TC_HANDLE_T
 TC_INIT(const char *tablename)
 {
 	TC_HANDLE_T h;
 	STRUCT_GETINFO info;
-	unsigned int i;
 	int tmp;
 	socklen_t s;
=20
@@ -269,7 +518,7 @@
 	if (getsockopt(sockfd, TC_IPPROTO, SO_GET_INFO, &info, &s) < 0)
 		return NULL;
=20
-	if ((h =3D alloc_handle(info.name, info.size, info.num_entries))
+	if ((h =3D alloc_tc_handle(info.name, info.size, info.num_entries))
 	    =3D=3D NULL) {
 		close(sockfd);
 		sockfd =3D -1;
@@ -295,11 +544,8 @@
=20
 	/* Initialize current state */
 	h->info =3D info;
-	h->new_number =3D h->info.num_entries;
-	for (i =3D 0; i < h->info.num_entries; i++)
-		h->counter_map[i]
-			=3D ((struct counter_map){COUNTER_MAP_NORMAL_MAP, i});
-
+	//h->new_number =3D h->info.num_entries;
+	//
 	h->entries.size =3D h->info.size;
=20
 	tmp =3D sizeof(STRUCT_GET_ENTRIES) + h->info.size;
@@ -313,16 +559,29 @@
 	}
=20
 	CHECK(h);
+	parse_ruleset(h);
+
 	return h;
 }
=20
 void
 TC_FREE(TC_HANDLE_T *h)
 {
+	struct list_head *cur_item, *item2;
+
 	close(sockfd);
 	sockfd =3D -1;
-	if ((*h)->cache_chain_heads)
-		free((*h)->cache_chain_heads);
+
+	/* free all chains */
+	list_for_each_safe(cur_item, item2, &(*h)->chains) {
+		struct chain_head *chead =3D list_entry(cur_item,
+						      struct chain_head,
+						      list);
+		chainh_free(chead);
+	}
+
+	/* FIXME: free all other ressources we might be using */
+
 	free(*h);
 	*h =3D NULL;
 }
@@ -336,6 +595,7 @@
=20
 static int dump_entry(STRUCT_ENTRY *e, const TC_HANDLE_T handle);
 =20
+#if 0
 void
 TC_DUMP_ENTRIES(const TC_HANDLE_T handle)
 {
@@ -376,180 +636,13 @@
 	return 0;
 }
=20
-static inline int
-add_chain(STRUCT_ENTRY *e, TC_HANDLE_T h, STRUCT_ENTRY **prev)
-{
-	unsigned int builtin;
-
-	/* Last entry.  End it. */
-	if (entry2offset(h, e) + e->next_offset =3D=3D h->entries.size) {
-		/* This is the ERROR node at end of the table */
-		h->cache_chain_heads[h->cache_num_chains-1].end_off =3D=20
-			entry2offset(h, *prev);
-		return 0;
-	}
-
-	/* We know this is the start of a new chain if it's an ERROR
-	   target, or a hook entry point */
-	if (strcmp(GET_TARGET(e)->u.user.name, ERROR_TARGET) =3D=3D 0) {
-		/* prev was last entry in previous chain */
-		h->cache_chain_heads[h->cache_num_chains-1].end_off
-			=3D entry2offset(h, *prev);
-
-		strcpy(h->cache_chain_heads[h->cache_num_chains].name,
-		       (const char *)GET_TARGET(e)->data);
-		h->cache_chain_heads[h->cache_num_chains].start_off
-			=3D entry2offset(h, (void *)e + e->next_offset);
-		h->cache_num_chains++;
-	} else if ((builtin =3D is_hook_entry(e, h)) !=3D 0) {
-		if (h->cache_num_chains > 0)
-			/* prev was last entry in previous chain */
-			h->cache_chain_heads[h->cache_num_chains-1].end_off
-				=3D entry2offset(h, *prev);
-
-		strcpy(h->cache_chain_heads[h->cache_num_chains].name,
-		       h->hooknames[builtin-1]);
-		h->cache_chain_heads[h->cache_num_chains].start_off
-			=3D entry2offset(h, (void *)e);
-		h->cache_num_chains++;
-	}
-
-	*prev =3D e;
-	return 0;
-}
=20
 static int alphasort(const void *a, const void *b)
 {
 	return strcmp(((struct chain_cache *)a)->name,
 		      ((struct chain_cache *)b)->name);
 }
-
-static int populate_cache(TC_HANDLE_T h)
-{
-	unsigned int i;
-	STRUCT_ENTRY *prev;
-
-	/* # chains < # rules / 2 + num builtins - 1 */
-	h->cache_chain_heads =3D malloc((h->new_number / 2 + 4)
-				      * sizeof(struct chain_cache));
-	if (!h->cache_chain_heads) {
-		errno =3D ENOMEM;
-		return 0;
-	}
-
-	h->cache_num_chains =3D 0;
-	h->cache_num_builtins =3D 0;
-
-	/* Count builtins */
-	for (i =3D 0; i < NUMHOOKS; i++) {
-		if (h->info.valid_hooks & (1 << i))
-			h->cache_num_builtins++;
-	}
-
-	prev =3D NULL;
-	ENTRY_ITERATE(h->entries.entrytable, h->entries.size,
-		      add_chain, h, &prev);
-
-	qsort(h->cache_chain_heads + h->cache_num_builtins,
-	      h->cache_num_chains - h->cache_num_builtins,
-	      sizeof(struct chain_cache), alphasort);
-
-	return 1;
-}
-
-static int=20
-correct_cache(TC_HANDLE_T h, unsigned int offset, int delta)
-{
-	int i;		/* needs to be signed because deleting first
-			   chain can make it drop to -1 */
-
-	if (!delta)
-		return 1;
-
-	for (i =3D 0; i < h->cache_num_chains; i++) {
-		struct chain_cache *cc =3D &h->cache_chain_heads[i];
-
-		if (delta < 0) {
-			/* take care about deleted chains */
-			if (cc->start_off > offset+delta
-			    && cc->end_off < offset) {
-				/* this chain is within the deleted range,
-				 * let's remove it from the cache */
-				void *start;
-				unsigned int size;
-
-				h->cache_num_chains--;
-
-				/* no need for memmove since we are=20
-				 * removing the last entry */
-				if (i >=3D h->cache_num_chains)
-					continue;
-
-				start =3D &h->cache_chain_heads[i+1];
-				size =3D (h->cache_num_chains-i)
-					* sizeof(struct chain_cache);
-				memmove(cc, start, size);
-
-				/* iterate over same index again, since
-				 * it is now a different chain */
-				i--;
-				continue;
-			}
-		}
-
-		if (cc->start_off > offset)
-			cc->start_off +=3D delta;
-
-		if (cc->end_off >=3D offset)
-			cc->end_off +=3D delta;
-	}
-	/* HW_FIXME: sorting might be needed, but just in case a new chain was
-	 * added */
-
-	return 1;
-}
-
-static int
-add_chain_cache(TC_HANDLE_T h, const char *name, unsigned int start_off,
-		unsigned int end_off)
-{
-	struct chain_cache *ccs =3D realloc(h->cache_chain_heads,=20
-					  (h->new_number / 2 + 4 + 1)
-					   * sizeof(struct chain_cache));
-	struct chain_cache *newcc;
-=09
-	if (!ccs)
-		return 0;
-
-	h->cache_chain_heads =3D ccs;
-	newcc =3D &h->cache_chain_heads[h->cache_num_chains];
-	h->cache_num_chains++;
-
-	strncpy(newcc->name, name, TABLE_MAXNAMELEN-1);
-	newcc->start_off =3D start_off;
-	newcc->end_off =3D end_off;
-
-	return 1;
-}
-
-/* Returns cache ptr if found, otherwise NULL. */
-static struct chain_cache *
-find_label(const char *name, TC_HANDLE_T handle)
-{
-	unsigned int i;
-
-	if (handle->cache_chain_heads =3D=3D NULL
-	    && !populate_cache(handle))
-		return NULL;
-
-	/* FIXME: Linear search through builtins, then binary --RR */
-	for (i =3D 0; i < handle->cache_num_chains; i++) {
-		if (strcmp(handle->cache_chain_heads[i].name, name) =3D=3D 0)
-			return &handle->cache_chain_heads[i];
-	}
-
-	return NULL;
-}
+#endif
=20
 /* Does this chain exist? */
 int TC_IS_CHAIN(const char *chain, const TC_HANDLE_T handle)
@@ -557,6 +650,7 @@
 	return find_label(chain, handle) !=3D NULL;
 }
=20
+#if 0
 /* Returns the position of the final (ie. unconditional) element. */
 static unsigned int
 get_chain_end(const TC_HANDLE_T handle, unsigned int start)
@@ -593,39 +687,38 @@
 		handle->entries.size, off);
 	abort();
 }
+#endif
=20
 /* Iterator functions to run through the chains. */
 const char *
 TC_FIRST_CHAIN(TC_HANDLE_T *handle)
 {
-	if ((*handle)->cache_chain_heads =3D=3D NULL
-	    && !populate_cache(*handle))
-		return NULL;
-
-	(*handle)->cache_chain_iteration
-		=3D &(*handle)->cache_chain_heads[0];
+	struct chain_head *firsthead =3D list_entry((*handle)->chains.next,
+						   struct chain_head, list);
+	(*handle)->chain_iterator_cur =3D firsthead;
=20
-	return (*handle)->cache_chain_iteration->name;
+	return firsthead->name;
 }
=20
 /* Iterator functions to run through the chains.  Returns NULL at end. */
 const char *
 TC_NEXT_CHAIN(TC_HANDLE_T *handle)
 {
-	(*handle)->cache_chain_iteration++;
+	struct chain_head *next =3D list_entry(&(*handle)->chain_iterator_cur->li=
st.next, struct chain_head, list);
+	(*handle)->chain_iterator_cur =3D next;
=20
-	if ((*handle)->cache_chain_iteration - (*handle)->cache_chain_heads
-	    =3D=3D (*handle)->cache_num_chains)
+	if (&next->list =3D=3D &(*handle)->chains)
 		return NULL;
=20
-	return (*handle)->cache_chain_iteration->name;
+	return next->name;
 }
=20
 /* Get first rule in the given chain: NULL for empty chain. */
 const STRUCT_ENTRY *
 TC_FIRST_RULE(const char *chain, TC_HANDLE_T *handle)
 {
-	struct chain_cache *c;
+	struct chain_head *c;
+	struct rule_head *r;
=20
 	c =3D find_label(chain, *handle);
 	if (!c) {
@@ -634,22 +727,26 @@
 	}
=20
 	/* Empty chain: single return/policy rule */
-	if (c->start_off =3D=3D c->end_off)
+	if (list_empty(&c->rules))
 		return NULL;
=20
-	(*handle)->cache_rule_end =3D offset2entry(*handle, c->end_off);
-	return offset2entry(*handle, c->start_off);
+	r =3D list_entry(c->rules.next, struct rule_head, list);
+	(*handle)->rule_iterator_cur =3D r;
+
+	return r->entry;
 }
=20
 /* Returns NULL when rules run out. */
 const STRUCT_ENTRY *
 TC_NEXT_RULE(const STRUCT_ENTRY *prev, TC_HANDLE_T *handle)
 {
-	if ((void *)prev + prev->next_offset
-	    =3D=3D (void *)(*handle)->cache_rule_end)
+	struct rule_head *r =3D list_entry((*handle)->rule_iterator_cur->list.nex=
t, struct rule_head, list);
+
+	if (&r->list =3D=3D &r->chain->rules)
 		return NULL;
=20
-	return (void *)prev + prev->next_offset;
+	/* NOTE: prev is without any influence ! */
+	return r->entry;
 }
=20
 #if 0
@@ -695,8 +792,6 @@
 target_name(TC_HANDLE_T handle, const STRUCT_ENTRY *ce)
 {
 	int spos;
-	unsigned int labelidx;
-	STRUCT_ENTRY *jumpto;
=20
 	/* To avoid const warnings */
 	STRUCT_ENTRY *e =3D (STRUCT_ENTRY *)ce;
@@ -716,21 +811,24 @@
 		else if (spos =3D=3D -NF_QUEUE-1)
 			return LABEL_QUEUE;
=20
-		fprintf(stderr, "ERROR: off %lu/%u not a valid target (%i)\n",
-			entry2offset(handle, e), handle->entries.size,
-			spos);
+		fprintf(stderr, "ERROR: entry %p not a valid target (%d)\n",
+			e, spos);
 		abort();
 	}
=20
-	jumpto =3D get_entry(handle, spos);
+#if 0
+//	jumpto =3D get_entry(handle, spos);
=20
 	/* Fall through rule */
 	if (jumpto =3D=3D (void *)e + e->next_offset)
 		return "";
=20
 	/* Must point to head of a chain: ie. after error rule */
+	/* FIXME: this needs to deal with internal jump targets */
 	labelidx =3D entry2index(handle, jumpto) - 1;
 	return get_errorlabel(handle, index2offset(handle, labelidx));
+#endif
+	return "";
 }
=20
 /* Returns a pointer to the target name of this position. */
@@ -761,23 +859,31 @@
 	      STRUCT_COUNTERS *counters,
 	      TC_HANDLE_T *handle)
 {
-	unsigned int start;
 	STRUCT_ENTRY *e;
+	struct chain_head *chainh;
+	struct rule_head *ruleh;
 	int hook;
=20
 	hook =3D TC_BUILTIN(chain, *handle);
-	if (hook !=3D 0)
-		start =3D (*handle)->info.hook_entry[hook-1];
-	else
+	if (hook =3D=3D 0)
 		return NULL;
=20
-	e =3D get_entry(*handle, get_chain_end(*handle, start));
+	chainh =3D find_label(chain, *handle);
+	if (!chainh) {
+		errno =3D ENOENT;
+		return NULL;
+	}
+
+	ruleh =3D chainh->lastrule;
+
+	e =3D ruleh->entry;
 	*counters =3D e->counters;
=20
 	return target_name(*handle, e);
 }
=20
-static inline int
+#if 0
+static int
 correct_verdict(STRUCT_ENTRY *e,
 		char *base,
 		unsigned int offset, int delta_offset)
@@ -809,149 +915,9 @@
 	set_changed(*handle);
 	return 1;
 }
+#endif
=20
-/* If prepend is set, then we are prepending to a chain: if the
- * insertion position is an entry point, keep the entry point. */
-static int
-insert_rules(unsigned int num_rules, unsigned int rules_size,
-	     const STRUCT_ENTRY *insert,
-	     unsigned int offset, unsigned int num_rules_offset,
-	     int prepend,
-	     TC_HANDLE_T *handle)
-{
-	TC_HANDLE_T newh;
-	STRUCT_GETINFO newinfo;
-	unsigned int i;
-
-	if (offset >=3D (*handle)->entries.size) {
-		errno =3D EINVAL;
-		return 0;
-	}
-
-	newinfo =3D (*handle)->info;
-
-	/* Fix up entry points. */
-	for (i =3D 0; i < NUMHOOKS; i++) {
-		/* Entry points to START of chain, so keep same if
-                   inserting on at that point. */
-		if ((*handle)->info.hook_entry[i] > offset)
-			newinfo.hook_entry[i] +=3D rules_size;
-
-		/* Underflow always points to END of chain (policy),
-		   so if something is inserted at same point, it
-		   should be advanced. */
-		if ((*handle)->info.underflow[i] >=3D offset)
-			newinfo.underflow[i] +=3D rules_size;
-	}
-
-	newh =3D alloc_handle((*handle)->info.name,
-			    (*handle)->entries.size + rules_size,
-			    (*handle)->new_number + num_rules);
-	if (!newh)
-		return 0;
-	newh->info =3D newinfo;
-
-	/* Copy pre... */
-	memcpy(newh->entries.entrytable, (*handle)->entries.entrytable,offset);
-	/* ... Insert new ... */
-	memcpy((char *)newh->entries.entrytable + offset, insert, rules_size);
-	/* ... copy post */
-	memcpy((char *)newh->entries.entrytable + offset + rules_size,
-	       (char *)(*handle)->entries.entrytable + offset,
-	       (*handle)->entries.size - offset);
-
-	/* Move counter map. */
-	/* Copy pre... */
-	memcpy(newh->counter_map, (*handle)->counter_map,
-	       sizeof(struct counter_map) * num_rules_offset);
-	/* ... copy post */
-	memcpy(newh->counter_map + num_rules_offset + num_rules,
-	       (*handle)->counter_map + num_rules_offset,
-	       sizeof(struct counter_map) * ((*handle)->new_number
-					     - num_rules_offset));
-	/* Set intermediates to no counter copy */
-	for (i =3D 0; i < num_rules; i++)
-		newh->counter_map[num_rules_offset+i]
-			=3D ((struct counter_map){ COUNTER_MAP_SET, 0 });
-
-	newh->new_number =3D (*handle)->new_number + num_rules;
-	newh->entries.size =3D (*handle)->entries.size + rules_size;
-	newh->hooknames =3D (*handle)->hooknames;
-
-	newh->cache_chain_heads =3D (*handle)->cache_chain_heads;
-	newh->cache_num_builtins =3D (*handle)->cache_num_builtins;
-	newh->cache_num_chains =3D (*handle)->cache_num_chains;
-	newh->cache_rule_end =3D (*handle)->cache_rule_end;
-	newh->cache_chain_iteration =3D (*handle)->cache_chain_iteration;
-	if (!correct_cache(newh, offset, rules_size)) {
-		free(newh);
-		return 0;
-	}
-
-	free(*handle);
-	*handle =3D newh;
-
-	return set_verdict(offset, rules_size, handle);
-}
-
-static int
-delete_rules(unsigned int num_rules, unsigned int rules_size,
-	     unsigned int offset, unsigned int num_rules_offset,
-	     TC_HANDLE_T *handle)
-{
-	unsigned int i;
-
-	if (offset + rules_size > (*handle)->entries.size) {
-		errno =3D EINVAL;
-		return 0;
-	}
-
-	/* Fix up entry points. */
-	for (i =3D 0; i < NUMHOOKS; i++) {
-		/* In practice, we never delete up to a hook entry,
-		   since the built-in chains are always first,
-		   so these two are never equal */
-		if ((*handle)->info.hook_entry[i] >=3D offset + rules_size)
-			(*handle)->info.hook_entry[i] -=3D rules_size;
-		else if ((*handle)->info.hook_entry[i] > offset) {
-			fprintf(stderr, "ERROR: Deleting entry %u %u %u\n",
-				i, (*handle)->info.hook_entry[i], offset);
-			abort();
-		}
-
-		/* Underflow points to policy (terminal) rule in
-                   built-in, so sequality is valid here (when deleting
-                   the last rule). */
-		if ((*handle)->info.underflow[i] >=3D offset + rules_size)
-			(*handle)->info.underflow[i] -=3D rules_size;
-		else if ((*handle)->info.underflow[i] > offset) {
-			fprintf(stderr, "ERROR: Deleting uflow %u %u %u\n",
-				i, (*handle)->info.underflow[i], offset);
-			abort();
-		}
-	}
-
-	/* Move the rules down. */
-	memmove((char *)(*handle)->entries.entrytable + offset,
-		(char *)(*handle)->entries.entrytable + offset + rules_size,
-		(*handle)->entries.size - (offset + rules_size));
-
-	/* Move the counter map down. */
-	memmove(&(*handle)->counter_map[num_rules_offset],
-		&(*handle)->counter_map[num_rules_offset + num_rules],
-		sizeof(struct counter_map)
-		* ((*handle)->new_number - (num_rules + num_rules_offset)));
-
-	/* Fix numbers */
-	(*handle)->new_number -=3D num_rules;
-	(*handle)->entries.size -=3D rules_size;
-
-	/* Fix the chain cache */
-	if (!correct_cache(*handle, offset+rules_size, -(int)rules_size))
-		return 0;
=20
-	return set_verdict(offset, -(int)rules_size, handle);
-}
=20
 static int
 standard_map(STRUCT_ENTRY *e, int verdict)
@@ -979,7 +945,7 @@
 	   unsigned int offset,
 	   STRUCT_ENTRY_TARGET *old)
 {
-	STRUCT_ENTRY_TARGET *t =3D GET_TARGET(e);
+	STRUCT_ENTRY_TARGET *t =3D (STRUCT_ENTRY_TARGET *)GET_TARGET(e);
=20
 	/* Save old target (except data, which we don't change, except for
 	   standard case, where we don't care). */
@@ -1003,11 +969,14 @@
 		return 0;
 	} else {
 		/* Maybe it's an existing chain name. */
-		struct chain_cache *c;
+		struct chain_head *c;
=20
+#if 0
+		/* FIXME */
 		c =3D find_label(t->u.user.name, handle);
 		if (c)
 			return standard_map(e, c->start_off);
+#endif
 	}
=20
 	/* Must be a module?  If not, kernel will reject... */
@@ -1028,18 +997,32 @@
 	*t =3D *old;
 }
=20
-/* Insert the entry `fw' in chain `chain' into position `rulenum'. */
+static struct rule_head *
+ruleh_get_n(struct chain_head *chead, int rulenum)=20
+{
+	int i =3D 0;
+	struct list_head *list;
+
+=09
+	list_for_each(list, &chead->rules) {
+		struct rule_head *rhead =3D list_entry(list, struct rule_head,=20
+							list);
+		i++;
+		if (i =3D=3D rulenum)
+			return rhead;
+	}
+	return NULL;
+}
+
+/* Insert the entry `e' in chain `chain' into position `rulenum'. */
 int
 TC_INSERT_ENTRY(const IPT_CHAINLABEL chain,
 		const STRUCT_ENTRY *e,
 		unsigned int rulenum,
 		TC_HANDLE_T *handle)
 {
-	unsigned int chainindex, offset;
-	STRUCT_ENTRY_TARGET old;
-	struct chain_cache *c;
-	STRUCT_ENTRY *tmp;
-	int ret;
+	struct chain_head *c;
+	struct rule_head *prev;
=20
 	iptc_fn =3D TC_INSERT_ENTRY;
 	if (!(c =3D find_label(chain, *handle))) {
@@ -1047,24 +1030,16 @@
 		return 0;
 	}
=20
-	chainindex =3D offset2index(*handle, c->start_off);
-
-	tmp =3D index2entry(*handle, chainindex + rulenum);
-	if (!tmp || tmp > offset2entry(*handle, c->end_off)) {
+	prev =3D ruleh_get_n(c, rulenum-1);
+	if (!prev) {
 		errno =3D E2BIG;
 		return 0;
 	}
-	offset =3D index2offset(*handle, chainindex + rulenum);
=20
-	/* Mapping target actually alters entry, but that's
-           transparent to the caller. */
-	if (!map_target(*handle, (STRUCT_ENTRY *)e, offset, &old))
-		return 0;
+	if (append_entrycopy(e, prev))
+		return 1;
=20
-	ret =3D insert_rules(1, e->next_offset, e, offset,
-			   chainindex + rulenum, rulenum =3D=3D 0, handle);
-	unmap_target((STRUCT_ENTRY *)e, &old);
-	return ret;
+	return 0;
 }
=20
 /* Atomically replace rule `rulenum' in `chain' with `fw'. */
@@ -1074,11 +1049,8 @@
 		 unsigned int rulenum,
 		 TC_HANDLE_T *handle)
 {
-	unsigned int chainindex, offset;
-	STRUCT_ENTRY_TARGET old;
-	struct chain_cache *c;
-	STRUCT_ENTRY *tmp;
-	int ret;
+	struct chain_head *c;
+	struct rule_head *repl;
=20
 	iptc_fn =3D TC_REPLACE_ENTRY;
=20
@@ -1087,54 +1059,43 @@
 		return 0;
 	}
=20
-	chainindex =3D offset2index(*handle, c->start_off);
-
-	tmp =3D index2entry(*handle, chainindex + rulenum);
-	if (!tmp || tmp >=3D offset2entry(*handle, c->end_off)) {
+	repl =3D ruleh_get_n(c, rulenum);
+	if (!repl) {
 		errno =3D E2BIG;
 		return 0;
 	}
=20
-	offset =3D index2offset(*handle, chainindex + rulenum);
-	/* Replace =3D delete and insert. */
-	if (!delete_rules(1, get_entry(*handle, offset)->next_offset,
-			  offset, chainindex + rulenum, handle))
-		return 0;
-
-	if (!map_target(*handle, (STRUCT_ENTRY *)e, offset, &old))
+	if (!append_entrycopy(e, repl)) {
+		errno =3D ENOMEM;
 		return 0;
+	}
=20
-	ret =3D insert_rules(1, e->next_offset, e, offset,
-			   chainindex + rulenum, 1, handle);
-	unmap_target((STRUCT_ENTRY *)e, &old);
-	return ret;
+	ruleh_free(repl);
+	return 1;
 }
=20
-/* Append entry `fw' to chain `chain'.  Equivalent to insert with
+/* Append entry `e' to chain `chain'.  Equivalent to insert with
    rulenum =3D length of chain. */
 int
 TC_APPEND_ENTRY(const IPT_CHAINLABEL chain,
 		const STRUCT_ENTRY *e,
 		TC_HANDLE_T *handle)
 {
-	struct chain_cache *c;
-	STRUCT_ENTRY_TARGET old;
-	int ret;
+	struct chain_head *c;
+	struct rule_head *rhead;
=20
 	iptc_fn =3D TC_APPEND_ENTRY;
+
 	if (!(c =3D find_label(chain, *handle))) {
 		errno =3D ENOENT;
 		return 0;
 	}
=20
-	if (!map_target(*handle, (STRUCT_ENTRY *)e,
-			c->end_off, &old))
-		return 0;
-
-	ret =3D insert_rules(1, e->next_offset, e, c->end_off,=20
-			   offset2index(*handle, c->end_off), 0, handle);
-	unmap_target((STRUCT_ENTRY *)e, &old);
-	return ret;
+	rhead =3D list_entry(c->rules.prev, struct rule_head, list);
+	if(append_entrycopy(e, rhead))
+		return 1;
+=09
+	return 0;
 }
=20
 static inline int
@@ -1183,16 +1144,15 @@
 	const STRUCT_ENTRY *b,
 	unsigned char *matchmask);
=20
-/* Delete the first rule in `chain' which matches `fw'. */
+/* Delete the first rule in `chain' which matches `origfw'. */
 int
 TC_DELETE_ENTRY(const IPT_CHAINLABEL chain,
 		const STRUCT_ENTRY *origfw,
 		unsigned char *matchmask,
 		TC_HANDLE_T *handle)
 {
-	unsigned int offset;
-	struct chain_cache *c;
-	STRUCT_ENTRY *e, *fw;
+	struct chain_head *c;
+	struct list_head *cur, *cur2;
=20
 	iptc_fn =3D TC_DELETE_ENTRY;
 	if (!(c =3D find_label(chain, *handle))) {
@@ -1200,40 +1160,15 @@
 		return 0;
 	}
=20
-	fw =3D malloc(origfw->next_offset);
-	if (fw =3D=3D NULL) {
-		errno =3D ENOMEM;
-		return 0;
-	}
-
-	for (offset =3D c->start_off; offset < c->end_off;
-	     offset +=3D e->next_offset) {
-		STRUCT_ENTRY_TARGET discard;
-
-		memcpy(fw, origfw, origfw->next_offset);
-
-		/* FIXME: handle this in is_same --RR */
-		if (!map_target(*handle, fw, offset, &discard)) {
-			free(fw);
-			return 0;
-		}
-		e =3D get_entry(*handle, offset);
-
-#if 0
-		printf("Deleting:\n");
-		dump_entry(newe);
-#endif
-		if (is_same(e, fw, matchmask)) {
-			int ret;
-			ret =3D delete_rules(1, e->next_offset,
-					   offset, entry2index(*handle, e),
-					   handle);
-			free(fw);
-			return ret;
+	list_for_each_safe(cur, cur2, &c->rules) {
+		struct rule_head *rhead =3D list_entry(cur, struct rule_head,=20
+							list);
+		if (is_same(rhead->entry, origfw, matchmask)) {
+			ruleh_free(rhead);
+			return 1;
 		}
 	}
=20
-	free(fw);
 	errno =3D ENOENT;
 	return 0;
 }
@@ -1244,33 +1179,25 @@
 		    unsigned int rulenum,
 		    TC_HANDLE_T *handle)
 {
-	unsigned int index;
-	int ret;
-	STRUCT_ENTRY *e;
-	struct chain_cache *c;
+	struct chain_head *chainh;
+	struct rule_head *rhead;
=20
 	iptc_fn =3D TC_DELETE_NUM_ENTRY;
-	if (!(c =3D find_label(chain, *handle))) {
+
+	if (!(chainh =3D find_label(chain, *handle))) {
 		errno =3D ENOENT;
 		return 0;
 	}
=20
-	index =3D offset2index(*handle, c->start_off) + rulenum;
-
-	if (index >=3D offset2index(*handle, c->end_off)) {
+	rhead =3D ruleh_get_n(chainh, rulenum);
+	if (!rhead) {
 		errno =3D E2BIG;
 		return 0;
 	}
=20
-	e =3D index2entry(*handle, index);
-	if (e =3D=3D NULL) {
-		errno =3D EINVAL;
-		return 0;
-	}
+	ruleh_free(rhead);
=20
-	ret =3D delete_rules(1, e->next_offset, entry2offset(*handle, e),
-			   index, handle);
-	return ret;
+	return 1;
 }
=20
 /* Check the packet `fw' on chain `chain'.  Returns the verdict, or
@@ -1288,46 +1215,40 @@
 int
 TC_FLUSH_ENTRIES(const IPT_CHAINLABEL chain, TC_HANDLE_T *handle)
 {
-	unsigned int startindex, endindex;
-	STRUCT_ENTRY *startentry, *endentry;
-	struct chain_cache *c;
-	int ret;
+	struct list_head *cur, *cur2;
+	struct chain_head *chainh;
=20
-	iptc_fn =3D TC_FLUSH_ENTRIES;
-	if (!(c =3D find_label(chain, *handle))) {
+	if (!(chainh =3D find_label(chain, *handle))) {
 		errno =3D ENOENT;
 		return 0;
 	}
-	startindex =3D offset2index(*handle, c->start_off);
-	endindex =3D offset2index(*handle, c->end_off);
-	startentry =3D offset2entry(*handle, c->start_off);
-	endentry =3D offset2entry(*handle, c->end_off);
-
-	ret =3D delete_rules(endindex - startindex,
-			   (char *)endentry - (char *)startentry,
-			   c->start_off, startindex,
-			   handle);
-	return ret;
+
+	list_for_each_safe(cur, cur2, &chainh->rules) {
+		struct rule_head *ruleh =3D list_entry(cur, struct rule_head,=20
+							list);
+		/* don't free the entry and policy/return entries */
+		if (ruleh !=3D chainh->firstrule && ruleh !=3D chainh->lastrule)
+			ruleh_free(ruleh);
+	}
+	return 1;
 }
=20
 /* Zeroes the counters in a chain. */
 int
 TC_ZERO_ENTRIES(const IPT_CHAINLABEL chain, TC_HANDLE_T *handle)
 {
-	unsigned int i, end;
-	struct chain_cache *c;
+	struct chain_head *c;
+	struct list_head *cur;
=20
 	if (!(c =3D find_label(chain, *handle))) {
 		errno =3D ENOENT;
 		return 0;
 	}
=20
-	i =3D offset2index(*handle, c->start_off);
-	end =3D offset2index(*handle, c->end_off);
-
-	for (; i <=3D end; i++) {
-		if ((*handle)->counter_map[i].maptype =3D=3DCOUNTER_MAP_NORMAL_MAP)
-			(*handle)->counter_map[i].maptype =3D COUNTER_MAP_ZEROED;
+	list_for_each(cur, c->rules.next) {
+		struct rule_head *r =3D list_entry(cur, struct rule_head, list);
+		if (r->counter_map.maptype =3D=3D COUNTER_MAP_NORMAL_MAP)
+			r->counter_map.maptype =3D COUNTER_MAP_ZEROED;
 	}
 	set_changed(*handle);
=20
@@ -1340,28 +1261,19 @@
 		TC_HANDLE_T *handle)
 {
 	STRUCT_ENTRY *e;
-	struct chain_cache *c;
-	unsigned int chainindex, end;
+	struct chain_head *c;
+	struct rule_head *r;
=20
 	iptc_fn =3D TC_READ_COUNTER;
 	CHECK(*handle);
=20
-	if (!(c =3D find_label(chain, *handle))) {
+	if (!(c =3D find_label(chain, *handle) )
+	      || !(r =3D ruleh_get_n(c, rulenum))) {
 		errno =3D ENOENT;
 		return NULL;
 	}
=20
-	chainindex =3D offset2index(*handle, c->start_off);
-	end =3D offset2index(*handle, c->end_off);
-
-	if (chainindex + rulenum > end) {
-		errno =3D E2BIG;
-		return NULL;
-	}
-
-	e =3D index2entry(*handle, chainindex + rulenum);
-
-	return &e->counters;
+	return &r->entry->counters;
 }
=20
 int
@@ -1370,32 +1282,20 @@
 		TC_HANDLE_T *handle)
 {
 	STRUCT_ENTRY *e;
-	struct chain_cache *c;
-	unsigned int chainindex, end;
+	struct chain_head *c;
+	struct rule_head *r;
 =09
 	iptc_fn =3D TC_ZERO_COUNTER;
 	CHECK(*handle);
=20
-	if (!(c =3D find_label(chain, *handle))) {
+	if (!(c =3D find_label(chain, *handle))
+	      || !(r =3D ruleh_get_n(c, rulenum))) {
 		errno =3D ENOENT;
 		return 0;
 	}
=20
-	chainindex =3D offset2index(*handle, c->start_off);
-	end =3D offset2index(*handle, c->end_off);
-
-	if (chainindex + rulenum > end) {
-		errno =3D E2BIG;
-		return 0;
-	}
-
-	e =3D index2entry(*handle, chainindex + rulenum);
-
-	if ((*handle)->counter_map[chainindex + rulenum].maptype
-			=3D=3D COUNTER_MAP_NORMAL_MAP) {
-		(*handle)->counter_map[chainindex + rulenum].maptype
-			 =3D COUNTER_MAP_ZEROED;
-	}
+	if (r->counter_map.maptype =3D=3D COUNTER_MAP_NORMAL_MAP)
+		r->counter_map.maptype =3D COUNTER_MAP_ZEROED;
=20
 	set_changed(*handle);
=20
@@ -1409,31 +1309,20 @@
 	       TC_HANDLE_T *handle)
 {
 	STRUCT_ENTRY *e;
-	struct chain_cache *c;
-	unsigned int chainindex, end;
+	struct chain_head *c;
+	struct rule_head *r;
=20
 	iptc_fn =3D TC_SET_COUNTER;
 	CHECK(*handle);
=20
-	if (!(c =3D find_label(chain, *handle))) {
+	if (!(c =3D find_label(chain, *handle))
+	      || !(r =3D ruleh_get_n(c, rulenum))) {
 		errno =3D ENOENT;
 		return 0;
 	}
-
-	chainindex =3D offset2index(*handle, c->start_off);
-	end =3D offset2index(*handle, c->end_off);
-
-	if (chainindex + rulenum > end) {
-		errno =3D E2BIG;
-		return 0;
-	}
-
-	e =3D index2entry(*handle, chainindex + rulenum);
-
-	(*handle)->counter_map[chainindex + rulenum].maptype
-		=3D COUNTER_MAP_SET;
-
-	memcpy(&e->counters, counters, sizeof(STRUCT_COUNTERS));
+=09
+	r->counter_map.maptype =3D COUNTER_MAP_SET;
+	memcpy(&r->entry->counters, counters, sizeof(STRUCT_COUNTERS));
=20
 	set_changed(*handle);
=20
@@ -1447,13 +1336,16 @@
 TC_CREATE_CHAIN(const IPT_CHAINLABEL chain, TC_HANDLE_T *handle)
 {
 	int ret;
-	struct {
+	struct chainstart {
 		STRUCT_ENTRY head;
 		struct ipt_error_target name;
+	} *newc1;
+	struct chainend {
 		STRUCT_ENTRY ret;
 		STRUCT_STANDARD_TARGET target;
-	} newc;
-	unsigned int destination;
+	} *newc2;
+	struct rule_head *newr1, *newr2;
+	struct chain_head *chead;
=20
 	iptc_fn =3D TC_CREATE_CHAIN;
=20
@@ -1473,42 +1365,53 @@
 		return 0;
 	}
=20
-	memset(&newc, 0, sizeof(newc));
-	newc.head.target_offset =3D sizeof(STRUCT_ENTRY);
-	newc.head.next_offset
+	chead =3D chainh_alloc(*handle, chain);
+	if (!chead) {
+		errno =3D ENOMEM;
+		return 0;
+	}
+=09
+	newr1 =3D ruleh_alloc(sizeof(*newc1));
+	if (!newr1) {
+		chainh_free(chead);
+		return 0;
+	}
+	newc1 =3D (struct chainstart *) newr1->entry;
+
+	newr2 =3D ruleh_alloc(sizeof(*newc2));
+	if (!newr2) {
+		chainh_free(chead);
+		ruleh_free(newr1);
+		return 0;
+	}
+	newc2 =3D (struct chainend *) newr2->entry;
+
+	newc1->head.target_offset =3D sizeof(STRUCT_ENTRY);
+	newc1->head.next_offset
 		=3D sizeof(STRUCT_ENTRY)
 		+ ALIGN(sizeof(struct ipt_error_target));
-	strcpy(newc.name.t.u.user.name, ERROR_TARGET);
-	newc.name.t.u.target_size =3D ALIGN(sizeof(struct ipt_error_target));
-	strcpy(newc.name.error, chain);
+	strcpy(newc1->name.t.u.user.name, ERROR_TARGET);
+	newc1->name.t.u.target_size =3D ALIGN(sizeof(struct ipt_error_target));
+	strcpy(newc1->name.error, chain);
=20
-	newc.ret.target_offset =3D sizeof(STRUCT_ENTRY);
-	newc.ret.next_offset
+	newc2->ret.target_offset =3D sizeof(STRUCT_ENTRY);
+	newc2->ret.next_offset
 		=3D sizeof(STRUCT_ENTRY)
 		+ ALIGN(sizeof(STRUCT_STANDARD_TARGET));
-	strcpy(newc.target.target.u.user.name, STANDARD_TARGET);
-	newc.target.target.u.target_size
+	strcpy(newc2->target.target.u.user.name, STANDARD_TARGET);
+	newc2->target.target.u.target_size
 		=3D ALIGN(sizeof(STRUCT_STANDARD_TARGET));
-	newc.target.verdict =3D RETURN;
-
-	destination =3D index2offset(*handle, (*handle)->new_number -1);
+	newc2->target.verdict =3D RETURN;
=20
-	/* Add just before terminal entry */
-	ret =3D insert_rules(2, sizeof(newc), &newc.head,
-			   destination,
-			   (*handle)->new_number - 1,
-			   0, handle);
+	list_prepend(&newr1->list, &chead->rules);
+	chead->firstrule =3D newr1;
+	list_append(&newr2->list, &chead->rules);
+	chead->lastrule =3D newr2;
=20
-	set_changed(*handle);
-
-	/* add chain cache info for this chain */
-	add_chain_cache(*handle, chain,=20
-			destination+newc.head.next_offset,=20
-			destination+newc.head.next_offset);
-
-	return ret;
+	return 1;
 }
=20
+#if 0
 static int
 count_ref(STRUCT_ENTRY *e, unsigned int offset, unsigned int *ref)
 {
@@ -1542,17 +1445,32 @@
 		      count_ref, c->start_off, ref);
 	return 1;
 }
+#endif
+
+static unsigned int
+count_rules(struct chain_head *chainh)
+{
+	unsigned int numrules =3D 0;
+	struct list_head *cur;
+
+	list_for_each(cur, &chainh->rules) {
+		numrules++;
+	}
+
+	if (numrules <=3D2)
+		return 0;
+	else
+		return numrules-2;
+}
=20
 /* Deletes a chain. */
 int
 TC_DELETE_CHAIN(const IPT_CHAINLABEL chain, TC_HANDLE_T *handle)
 {
-	unsigned int labelidx, labeloff;
 	unsigned int references;
-	struct chain_cache *c;
-	int ret;
-	STRUCT_ENTRY *start;
+	struct chain_head *chainh;
=20
+#if 0
 	if (!TC_GET_REFERENCES(&references, chain, handle))
 		return 0;
=20
@@ -1567,28 +1485,20 @@
 		errno =3D EMLINK;
 		return 0;
 	}
+#endif=20
=20
-	if (!(c =3D find_label(chain, *handle))) {
+	if (!(chainh =3D find_label(chain, *handle))) {
 		errno =3D ENOENT;
 		return 0;
 	}
=20
-	if (c->start_off !=3D c->end_off) {
+	if (!(count_rules(chainh) =3D=3D 0)) {
 		errno =3D ENOTEMPTY;
 		return 0;
 	}
=20
-	/* Need label index: preceeds chain start */
-	labelidx =3D offset2index(*handle, c->start_off) - 1;
-	labeloff =3D index2offset(*handle, labelidx);
-
-	start =3D offset2entry(*handle, c->start_off);
-
-	ret =3D delete_rules(2,
-			   get_entry(*handle, labeloff)->next_offset
-			   + start->next_offset,
-			   labeloff, labelidx, handle);
-	return ret;
+	chainh_free(chainh);
+	return 1;
 }
=20
 /* Renames a chain. */
@@ -1596,8 +1506,8 @@
 		    const IPT_CHAINLABEL newname,
 		    TC_HANDLE_T *handle)
 {
-	unsigned int labeloff, labelidx;
-	struct chain_cache *c;
+	struct chain_head *c;
+	struct rule_head *ruleh;
 	struct ipt_error_target *t;
=20
 	iptc_fn =3D TC_RENAME_CHAIN;
@@ -1624,22 +1534,14 @@
 		return 0;
 	}
=20
-	/* Need label index: preceeds chain start */
-	labelidx =3D offset2index(*handle, c->start_off) - 1;
-	labeloff =3D index2offset(*handle, labelidx);
+	ruleh =3D list_entry(&c->rules.next, struct rule_head, list);
=20
 	t =3D (struct ipt_error_target *)
-		GET_TARGET(get_entry(*handle, labeloff));
+		GET_TARGET(ruleh->entry);
=20
 	memset(t->error, 0, sizeof(t->error));
 	strcpy(t->error, newname);
=20
-	/* update chain cache */
-	memset(c->name, 0, sizeof(c->name));
-	strcpy(c->name, newname);
-
-	set_changed(*handle);
-
 	return 1;
 }
=20
@@ -1650,8 +1552,10 @@
 	      STRUCT_COUNTERS *counters,
 	      TC_HANDLE_T *handle)
 {
+	int ctrindex;
 	unsigned int hook;
-	unsigned int policyoff, ctrindex;
+	struct chain_head *chainh;
+	struct rule_head *policyrh;
 	STRUCT_ENTRY *e;
 	STRUCT_STANDARD_TARGET *t;
=20
@@ -1664,15 +1568,18 @@
 	} else
 		hook--;
=20
-	policyoff =3D get_chain_end(*handle, (*handle)->info.hook_entry[hook]);
-	if (policyoff !=3D (*handle)->info.underflow[hook]) {
-		printf("ERROR: Policy for `%s' offset %u !=3D underflow %u\n",
-		       chain, policyoff, (*handle)->info.underflow[hook]);
+	if (!(chainh =3D find_label(chain, *handle))) {
+		errno =3D ENOENT;
 		return 0;
 	}
=20
-	e =3D get_entry(*handle, policyoff);
-	t =3D (STRUCT_STANDARD_TARGET *)GET_TARGET(e);
+	policyrh =3D chainh->lastrule;
+	if (policyrh) {
+		printf("ERROR: Policy for `%s' non-existant", chain);
+		return 0;
+	}
+
+	t =3D (STRUCT_STANDARD_TARGET *)GET_TARGET(policyrh->entry);
=20
 	if (strcmp(policy, LABEL_ACCEPT) =3D=3D 0)
 		t->verdict =3D -NF_ACCEPT - 1;
@@ -1689,12 +1596,11 @@
 		/* set byte and packet counters */
 		memcpy(&e->counters, counters, sizeof(STRUCT_COUNTERS));
=20
-		(*handle)->counter_map[ctrindex].maptype
-			=3D COUNTER_MAP_SET;
+		policyrh->counter_map.maptype =3D COUNTER_MAP_SET;
=20
 	} else {
-		(*handle)->counter_map[ctrindex]
-			=3D ((struct counter_map){ COUNTER_MAP_NOMAP, 0 });
+		policyrh->counter_map.maptype =3D COUNTER_MAP_NOMAP;
+		policyrh->counter_map.mappos =3D 0;
 	}
=20
 	set_changed(*handle);

--11Y7aswkeuHtSBEs--

--kA1LkgxZ0NN7Mz3A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/+wd6XaXGVTD0i/8RApUPAJ9couEubjrlD0bTeVI0GXqd9tdFWQCdFAU0
PLPkfZ5EG2ibUIehLEy7dOU=
=RBQE
-----END PGP SIGNATURE-----

--kA1LkgxZ0NN7Mz3A--
