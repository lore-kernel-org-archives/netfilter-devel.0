From: Florian Westphal <fw@strlen.de>
Subject: Re: netfilter question
Date: Thu, 17 Nov 2016 01:07:25 +0100
Message-ID: <20161117000725.GK30581@breakpoint.cc>
References: <cad49557-7c7a-83c9-d2b6-71d9624f0d52@miromedia.ca>
 <CANn89iLr-Zf2W5MW47QtKo17915UoryZentihKt1SMv7NP_dOw@mail.gmail.com>
 <20161116150200.GH30581@breakpoint.cc>
 <1479309789.8455.194.camel@edumazet-glaptop3.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
        Eric Dumazet <edumazet@google.com>,
        Eric Desrochers <ericd@miromedia.ca>,
        netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:51898 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933687AbcKQAJv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Nov 2016 19:09:51 -0500
Content-Disposition: inline
In-Reply-To: <1479309789.8455.194.camel@edumazet-glaptop3.roam.corp.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > > On Wed, Nov 16, 2016 at 2:22 AM, Eric Desrochers <ericd@miromedia.ca> wrote:
> > > > Hi Eric,
> > > >
> > > > My name is Eric and I'm reaching you today as I found your name in multiple netfilter kernel commits, and was hoping we can discuss about a potential regression.
> > > >
> > > > I identified (git bisect) this commit [https://github.com/torvalds/linux/commit/71ae0dff02d756e4d2ca710b79f2ff5390029a5f] as the one introducing a serious performance slowdown when using the binary ip/ip6tables with a large number of policies.
> > > >
> > > > I also tried with the latest and greatest v4.9-rc4 mainline kernel, and the slowdown is still present.
> > > >
> > > > So even commit [https://github.com/torvalds/linux/commit/a1a56aaa0735c7821e85c37268a7c12e132415cb] which introduce a 16 bytes alignment on xt_counter percpu allocations so that bytes and packets sit in same cache line, doesn't have impact too.
> > > >
> > > >
> > > > Everything I found is detailed in the following bug : https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1640786
> > > >
> > > > Of course, I'm totally aware that "iptables-restore" should be the favorite choice as it is way more efficient (note that using iptables-restore doesn't exhibit the problem) but some folks still rely on ip/ip6tables and might face this performance slowdown.
> > > >
> > > > I found the problem today, I will continue to investigate on my side, but I was wondering if we could have a discussion about this subject.
> > > >
> > > > Thanks in advance.
> > 
> > [..]
> > 
> > > Key point is that we really care about fast path : packet processing.
> > > And cited commit helps this a lot by lowering the memory foot print on
> > > hosts with many cores.
> > > This is a step into right direction.
> > > 
> > > Now we probably should batch the percpu allocations one page at a
> > > time, or ask Tejun if percpu allocations could be really really fast
> > > (probably much harder)
> > > 
> > > But really you should not use iptables one rule at a time...
> > > This will never compete with iptables-restore. ;)
> > > 
> > > Florian, would you have time to work on a patch trying to group the
> > > percpu allocations one page at a time ?
> > 
> > You mean something like this ? :
> >         xt_entry_foreach(iter, entry0, newinfo->size) {
> > -               ret = find_check_entry(iter, net, repl->name, repl->size);
> > -               if (ret != 0)
> > +               if (pcpu_alloc == 0) {
> > +                       pcnt = __alloc_percpu(PAGE_SIZE, sizeof(struct xt_counters));
> 
> alignment should be a page.

[..]

> > Error unwind will also be a mess (we can abuse .bcnt to tell if pcpu offset should be free'd or not).
> 
> Free if the address is aligned to a page boundary ?

Good idea.  This seems to work for me.  Eric (Desrochers), does this
improve the situation for you as well?

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -403,38 +403,14 @@ static inline unsigned long ifname_compare_aligned(const char *_a,
 	return ret;
 }
 
+struct xt_percpu_counter_alloc_state {
+	unsigned int off;
+	const char *mem;
+};
 
-/* On SMP, ip(6)t_entry->counters.pcnt holds address of the
- * real (percpu) counter.  On !SMP, its just the packet count,
- * so nothing needs to be done there.
- *
- * xt_percpu_counter_alloc returns the address of the percpu
- * counter, or 0 on !SMP. We force an alignment of 16 bytes
- * so that bytes/packets share a common cache line.
- *
- * Hence caller must use IS_ERR_VALUE to check for error, this
- * allows us to return 0 for single core systems without forcing
- * callers to deal with SMP vs. NONSMP issues.
- */
-static inline unsigned long xt_percpu_counter_alloc(void)
-{
-	if (nr_cpu_ids > 1) {
-		void __percpu *res = __alloc_percpu(sizeof(struct xt_counters),
-						    sizeof(struct xt_counters));
-
-		if (res == NULL)
-			return -ENOMEM;
-
-		return (__force unsigned long) res;
-	}
-
-	return 0;
-}
-static inline void xt_percpu_counter_free(u64 pcnt)
-{
-	if (nr_cpu_ids > 1)
-		free_percpu((void __percpu *) (unsigned long) pcnt);
-}
+bool xt_percpu_counter_alloc(struct xt_percpu_counter_alloc_state *state,
+			     struct xt_counters *counter);
+void xt_percpu_counter_free(struct xt_counters *cnt);
 
 static inline struct xt_counters *
 xt_get_this_cpu_counter(struct xt_counters *cnt)
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 39004da318e2..cbea0cb030da 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -411,17 +411,15 @@ static inline int check_target(struct arpt_entry *e, const char *name)
 }
 
 static inline int
-find_check_entry(struct arpt_entry *e, const char *name, unsigned int size)
+find_check_entry(struct arpt_entry *e, const char *name, unsigned int size,
+		 struct xt_percpu_counter_alloc_state *alloc_state)
 {
 	struct xt_entry_target *t;
 	struct xt_target *target;
-	unsigned long pcnt;
 	int ret;
 
-	pcnt = xt_percpu_counter_alloc();
-	if (IS_ERR_VALUE(pcnt))
+	if (!xt_percpu_counter_alloc(alloc_state, &e->counters))
 		return -ENOMEM;
-	e->counters.pcnt = pcnt;
 
 	t = arpt_get_target(e);
 	target = xt_request_find_target(NFPROTO_ARP, t->u.user.name,
@@ -439,7 +437,7 @@ find_check_entry(struct arpt_entry *e, const char *name, unsigned int size)
 err:
 	module_put(t->u.kernel.target->me);
 out:
-	xt_percpu_counter_free(e->counters.pcnt);
+	xt_percpu_counter_free(&e->counters);
 
 	return ret;
 }
@@ -519,7 +517,7 @@ static inline void cleanup_entry(struct arpt_entry *e)
 	if (par.target->destroy != NULL)
 		par.target->destroy(&par);
 	module_put(par.target->me);
-	xt_percpu_counter_free(e->counters.pcnt);
+	xt_percpu_counter_free(&e->counters);
 }
 
 /* Checks and translates the user-supplied table segment (held in
@@ -528,6 +526,7 @@ static inline void cleanup_entry(struct arpt_entry *e)
 static int translate_table(struct xt_table_info *newinfo, void *entry0,
 			   const struct arpt_replace *repl)
 {
+	struct xt_percpu_counter_alloc_state alloc_state = { 0 };
 	struct arpt_entry *iter;
 	unsigned int *offsets;
 	unsigned int i;
@@ -590,7 +589,7 @@ static int translate_table(struct xt_table_info *newinfo, void *entry0,
 	/* Finally, each sanity check must pass */
 	i = 0;
 	xt_entry_foreach(iter, entry0, newinfo->size) {
-		ret = find_check_entry(iter, repl->name, repl->size);
+		ret = find_check_entry(iter, repl->name, repl->size, &alloc_state);
 		if (ret != 0)
 			break;
 		++i;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 46815c8a60d7..0024550516d1 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -531,7 +531,8 @@ static int check_target(struct ipt_entry *e, struct net *net, const char *name)
 
 static int
 find_check_entry(struct ipt_entry *e, struct net *net, const char *name,
-		 unsigned int size)
+		 unsigned int size,
+		 struct xt_percpu_counter_alloc_state *alloc_state)
 {
 	struct xt_entry_target *t;
 	struct xt_target *target;
@@ -539,12 +540,9 @@ find_check_entry(struct ipt_entry *e, struct net *net, const char *name,
 	unsigned int j;
 	struct xt_mtchk_param mtpar;
 	struct xt_entry_match *ematch;
-	unsigned long pcnt;
 
-	pcnt = xt_percpu_counter_alloc();
-	if (IS_ERR_VALUE(pcnt))
+	if (!xt_percpu_counter_alloc(alloc_state, &e->counters))
 		return -ENOMEM;
-	e->counters.pcnt = pcnt;
 
 	j = 0;
 	mtpar.net	= net;
@@ -582,7 +580,7 @@ find_check_entry(struct ipt_entry *e, struct net *net, const char *name,
 		cleanup_match(ematch, net);
 	}
 
-	xt_percpu_counter_free(e->counters.pcnt);
+	xt_percpu_counter_free(&e->counters);
 
 	return ret;
 }
@@ -670,7 +668,7 @@ cleanup_entry(struct ipt_entry *e, struct net *net)
 	if (par.target->destroy != NULL)
 		par.target->destroy(&par);
 	module_put(par.target->me);
-	xt_percpu_counter_free(e->counters.pcnt);
+	xt_percpu_counter_free(&e->counters);
 }
 
 /* Checks and translates the user-supplied table segment (held in
@@ -679,6 +677,7 @@ static int
 translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 		const struct ipt_replace *repl)
 {
+	struct xt_percpu_counter_alloc_state alloc_state = { 0 };
 	struct ipt_entry *iter;
 	unsigned int *offsets;
 	unsigned int i;
@@ -738,7 +737,7 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 	/* Finally, each sanity check must pass */
 	i = 0;
 	xt_entry_foreach(iter, entry0, newinfo->size) {
-		ret = find_check_entry(iter, net, repl->name, repl->size);
+		ret = find_check_entry(iter, net, repl->name, repl->size, &alloc_state);
 		if (ret != 0)
 			break;
 		++i;
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 6ff42b8301cc..123d9af6742e 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -562,7 +562,8 @@ static int check_target(struct ip6t_entry *e, struct net *net, const char *name)
 
 static int
 find_check_entry(struct ip6t_entry *e, struct net *net, const char *name,
-		 unsigned int size)
+		 unsigned int size,
+		 struct xt_percpu_counter_alloc_state *alloc_state)
 {
 	struct xt_entry_target *t;
 	struct xt_target *target;
@@ -570,12 +571,9 @@ find_check_entry(struct ip6t_entry *e, struct net *net, const char *name,
 	unsigned int j;
 	struct xt_mtchk_param mtpar;
 	struct xt_entry_match *ematch;
-	unsigned long pcnt;
 
-	pcnt = xt_percpu_counter_alloc();
-	if (IS_ERR_VALUE(pcnt))
+	if (!xt_percpu_counter_alloc(alloc_state, &e->counters))
 		return -ENOMEM;
-	e->counters.pcnt = pcnt;
 
 	j = 0;
 	mtpar.net	= net;
@@ -612,7 +610,7 @@ find_check_entry(struct ip6t_entry *e, struct net *net, const char *name,
 		cleanup_match(ematch, net);
 	}
 
-	xt_percpu_counter_free(e->counters.pcnt);
+	xt_percpu_counter_free(&e->counters);
 
 	return ret;
 }
@@ -699,8 +697,7 @@ static void cleanup_entry(struct ip6t_entry *e, struct net *net)
 	if (par.target->destroy != NULL)
 		par.target->destroy(&par);
 	module_put(par.target->me);
-
-	xt_percpu_counter_free(e->counters.pcnt);
+	xt_percpu_counter_free(&e->counters);
 }
 
 /* Checks and translates the user-supplied table segment (held in
@@ -709,6 +706,7 @@ static int
 translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 		const struct ip6t_replace *repl)
 {
+	struct xt_percpu_counter_alloc_state alloc_state = { 0 };
 	struct ip6t_entry *iter;
 	unsigned int *offsets;
 	unsigned int i;
@@ -768,7 +766,7 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 	/* Finally, each sanity check must pass */
 	i = 0;
 	xt_entry_foreach(iter, entry0, newinfo->size) {
-		ret = find_check_entry(iter, net, repl->name, repl->size);
+		ret = find_check_entry(iter, net, repl->name, repl->size, &alloc_state);
 		if (ret != 0)
 			break;
 		++i;
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index ad818e52859b..a4d1084b163f 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1615,6 +1615,59 @@ void xt_proto_fini(struct net *net, u_int8_t af)
 }
 EXPORT_SYMBOL_GPL(xt_proto_fini);
 
+/**
+ * xt_percpu_counter_alloc - allocate x_tables rule counter
+ *
+ * @state: pointer to xt_percpu allocation state
+ * @counter: pointer to counter struct inside the ip(6)/arpt_entry struct
+ *
+ * On SMP, the packet counter [ ip(6)t_entry->counters.pcnt ] will then
+ * contain the address of the real (percpu) counter.
+ *
+ * Rule evaluation needs to use xt_get_this_cpu_counter() helper
+ * to fetch the real percpu counter.
+ *
+ * To speed up allocation and improve data locality, an entire
+ * page is allocated.
+ *
+ * xt_percpu_counter_alloc_state contains the base address of the
+ * allocated page and the current sub-offset.
+ *
+ * returns false on error.
+ */
+bool xt_percpu_counter_alloc(struct xt_percpu_counter_alloc_state *state,
+			     struct xt_counters *counter)
+{
+	BUILD_BUG_ON(PAGE_SIZE < (sizeof(*counter) * 2));
+
+	if (nr_cpu_ids <= 1)
+		return true;
+
+	if (state->mem == NULL) {
+		state->mem = __alloc_percpu(PAGE_SIZE, PAGE_SIZE);
+		if (!state->mem)
+			return false;
+	}
+	counter->pcnt = (__force unsigned long)(state->mem + state->off);
+	state->off += sizeof(*counter);
+	if (state->off > (PAGE_SIZE - sizeof(*counter))) {
+		state->mem = NULL;
+		state->off = 0;
+	}
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(xt_percpu_counter_alloc);
+
+void xt_percpu_counter_free(struct xt_counters *counters)
+{
+	unsigned long pcnt = counters->pcnt;
+
+	if (nr_cpu_ids > 1 && (pcnt & (PAGE_SIZE - 1)) == 0)
+		free_percpu((void __percpu *) (unsigned long)pcnt);
+}
+EXPORT_SYMBOL_GPL(xt_percpu_counter_free);
+
 static int __net_init xt_net_init(struct net *net)
 {
 	int i;
