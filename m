Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F315BC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Sep 2021 10:52:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D69AD619A6
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Sep 2021 10:52:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350036AbhI3KyM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Sep 2021 06:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350161AbhI3KyL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Sep 2021 06:54:11 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD686C06176D
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Sep 2021 03:52:27 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mVtfr-0002QZ-Qk; Thu, 30 Sep 2021 12:52:23 +0200
Date:   Thu, 30 Sep 2021 12:52:23 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>,
        Senthil Kumar Balasubramanian <senthilb@qubercomm.com>,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: ebtables behaving weirdly on MIPS platform
Message-ID: <20210930105223.GD2935@breakpoint.cc>
References: <CA+6nuS7f=bLh56k463rJSPn7P3PvwW-kzAz2oYx2wiw24_9_Mw@mail.gmail.com>
 <20210930103840.GP32194@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210930103840.GP32194@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> On Thu, Sep 30, 2021 at 11:53:32AM +0530, Senthil Kumar Balasubramanian wrote:
> > However, dumping the data that goes to the kernel, we see a huge
> > difference between MIPS and ARM..
> > 
> > in ARM platform
> >  w_l->w:
> >   0000  6e 66 6c 6f 67 00 ff b6 00 00 00 00 00 00 00 00  nflog...........
> >   0010  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >   0020  50 00 00 00 00 00 00 00 01 00 01 00 00 00 00 00  P...............
> >   0030  45 4e 54 52 59 31 00 00 00 00 00 00 00 00 00 00  ENTRY1..........
> >   0040  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >   0050  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >   0060  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >   0070  00 00 00 00
> > 
> > in tplink a6 (MIPS platform)
> > 
> >  w_l->w:
> >   0000  6e 66 6c 6f 67 00 b2 e0 69 6d 69 74 20 65 78 63    nflog...imit exc
> >   0010  65 65 64 65 64 00 56 69 72 74 75 61 6c 20 74 69    eeded.Virtual ti
> >   0020  00 00 00 50 65 78 70 69 00 01 00 01 50 72 6f 66     ...Pexpi....Prof
> >   0030  45 4e 54 52 59 31 00 69 6d 65 72 20 65 78 70 69    ENTRY1.imer expi
> >   0040  72 65 64 00 57 69 6e 64 6f 77 20 63 68 61 6e 67     red.Window chang
> >   0050  65 64 00 49 2f 4f 20 70 6f 73 73 69 62 6c 65 00        ed.I/O possible.
> >   0060  50 6f 77 65 72 20 66 61 69 6c 75 72 65 00 42 61       Power failure.Ba
> >   0070  64 20 73 79
> >               d sy
> > 
> > Can you please let me know what's going wrong with this?
> 
> Looks like the data structure contains garbage. Looking at ebtables
> code, that seems likely as extension data structures are allocated using
> malloc() and never set zero. init() function in ebt_nflog.c only
> initializes prefix, group and threshold fields (which seem to be set
> correctly in your MIPS dump).

Yes, probably pure luck (libc differences and the like).

Senthil, can you try this patch (compile tested only)?

diff --git a/libebtc.c b/libebtc.c
--- a/libebtc.c
+++ b/libebtc.c
@@ -41,6 +41,18 @@
 static void decrease_chain_jumps(struct ebt_u_replace *replace);
 static int iterate_entries(struct ebt_u_replace *replace, int type);
 
+static void *xzalloc(size_t s)
+{
+	void *p = malloc(s);
+
+	if (!p)
+		ebt_print_memory();
+
+	memset(p, 0, s);
+
+	return p;
+}
+
 /* The standard names */
 const char *ebt_hooknames[NF_BR_NUMHOOKS] =
 {
@@ -266,9 +278,7 @@ void ebt_reinit_extensions()
 	for (m = ebt_matches; m; m = m->next) {
 		if (m->used) {
 			size = EBT_ALIGN(m->size) + sizeof(struct ebt_entry_match);
-			m->m = (struct ebt_entry_match *)malloc(size);
-			if (!m->m)
-				ebt_print_memory();
+			m->m = xzalloc(size);
 			strcpy(m->m->u.name, m->name);
 			m->m->u.revision = m->revision;
 			m->m->match_size = EBT_ALIGN(m->size);
@@ -280,9 +290,7 @@ void ebt_reinit_extensions()
 	for (w = ebt_watchers; w; w = w->next) {
 		if (w->used) {
 			size = EBT_ALIGN(w->size) + sizeof(struct ebt_entry_watcher);
-			w->w = (struct ebt_entry_watcher *)malloc(size);
-			if (!w->w)
-				ebt_print_memory();
+			w->w = xzalloc(size);
 			strcpy(w->w->u.name, w->name);
 			w->w->watcher_size = EBT_ALIGN(w->size);
 			w->used = 0;
@@ -293,9 +301,7 @@ void ebt_reinit_extensions()
 	for (t = ebt_targets; t; t = t->next) {
 		if (t->used) {
 			size = EBT_ALIGN(t->size) + sizeof(struct ebt_entry_target);
-			t->t = (struct ebt_entry_target *)malloc(size);
-			if (!t->t)
-				ebt_print_memory();
+			t->t = xzalloc(size);
 			strcpy(t->t->u.name, t->name);
 			t->t->target_size = EBT_ALIGN(t->size);
 			t->used = 0;
@@ -645,9 +651,7 @@ void ebt_add_rule(struct ebt_u_replace *replace, struct ebt_u_entry *new_entry,
 	new_entry->prev = u_e->prev;
 	u_e->prev->next = new_entry;
 	u_e->prev = new_entry;
-	new_cc = (struct ebt_cntchanges *)malloc(sizeof(struct ebt_cntchanges));
-	if (!new_cc)
-		ebt_print_memory();
+	new_cc = xzalloc(sizeof(struct ebt_cntchanges));
 	new_cc->type = CNT_ADD;
 	new_cc->change = 0;
 	if (new_entry->next == entries->entries) {
@@ -861,18 +865,14 @@ void ebt_new_chain(struct ebt_u_replace *replace, const char *name, int policy)
 
 	if (replace->num_chains == replace->max_chains)
 		ebt_double_chains(replace);
-	new = (struct ebt_u_entries *)malloc(sizeof(struct ebt_u_entries));
-	if (!new)
-		ebt_print_memory();
+	new = xzalloc(sizeof(struct ebt_u_entries));
 	replace->chains[replace->num_chains++] = new;
 	new->nentries = 0;
 	new->policy = policy;
 	new->counter_offset = replace->nentries;
 	new->hook_mask = 0;
 	strcpy(new->name, name);
-	new->entries = (struct ebt_u_entry *)malloc(sizeof(struct ebt_u_entry));
-	if (!new->entries)
-		ebt_print_memory();
+	new->entries = xzalloc(sizeof(struct ebt_u_entry));
 	new->entries->next = new->entries->prev = new->entries;
 	new->kernel_start = NULL;
 }
@@ -1041,7 +1041,7 @@ void ebt_check_for_loops(struct ebt_u_replace *replace)
 	}
 	if (replace->num_chains == NF_BR_NUMHOOKS)
 		return;
-	stack = (struct ebt_u_stack *)malloc((replace->num_chains - NF_BR_NUMHOOKS) * sizeof(struct ebt_u_stack));
+	stack = calloc((replace->num_chains - NF_BR_NUMHOOKS), sizeof(struct ebt_u_stack));
 	if (!stack)
 		ebt_print_memory();
 
@@ -1111,10 +1111,7 @@ void ebt_add_match(struct ebt_u_entry *new_entry, struct ebt_u_match *m)
 	struct ebt_u_match_list **m_list, *new;
 
 	for (m_list = &new_entry->m_list; *m_list; m_list = &(*m_list)->next);
-	new = (struct ebt_u_match_list *)
-	   malloc(sizeof(struct ebt_u_match_list));
-	if (!new)
-		ebt_print_memory();
+	new = xzalloc(sizeof(struct ebt_u_match_list));
 	*m_list = new;
 	new->next = NULL;
 	new->m = (struct ebt_entry_match *)m;
@@ -1126,10 +1123,7 @@ void ebt_add_watcher(struct ebt_u_entry *new_entry, struct ebt_u_watcher *w)
 	struct ebt_u_watcher_list *new;
 
 	for (w_list = &new_entry->w_list; *w_list; w_list = &(*w_list)->next);
-	new = (struct ebt_u_watcher_list *)
-	   malloc(sizeof(struct ebt_u_watcher_list));
-	if (!new)
-		ebt_print_memory();
+	new = xzalloc(sizeof(struct ebt_u_watcher_list));
 	*w_list = new;
 	new->next = NULL;
 	new->w = (struct ebt_entry_watcher *)w;
@@ -1206,9 +1200,7 @@ void ebt_register_match(struct ebt_u_match *m)
 	int size = EBT_ALIGN(m->size) + sizeof(struct ebt_entry_match);
 	struct ebt_u_match **i;
 
-	m->m = (struct ebt_entry_match *)malloc(size);
-	if (!m->m)
-		ebt_print_memory();
+	m->m = xzalloc(size);
 	strcpy(m->m->u.name, m->name);
 	m->m->u.revision = m->revision;
 	m->m->match_size = EBT_ALIGN(m->size);
@@ -1224,9 +1216,7 @@ void ebt_register_watcher(struct ebt_u_watcher *w)
 	int size = EBT_ALIGN(w->size) + sizeof(struct ebt_entry_watcher);
 	struct ebt_u_watcher **i;
 
-	w->w = (struct ebt_entry_watcher *)malloc(size);
-	if (!w->w)
-		ebt_print_memory();
+	w->w = xzalloc(size);
 	strcpy(w->w->u.name, w->name);
 	w->w->watcher_size = EBT_ALIGN(w->size);
 	w->init(w->w);
@@ -1241,9 +1231,7 @@ void ebt_register_target(struct ebt_u_target *t)
 	int size = EBT_ALIGN(t->size) + sizeof(struct ebt_entry_target);
 	struct ebt_u_target **i;
 
-	t->t = (struct ebt_entry_target *)malloc(size);
-	if (!t->t)
-		ebt_print_memory();
+	t->t = xzalloc(size);
 	strcpy(t->t->u.name, t->name);
 	t->t->target_size = EBT_ALIGN(t->size);
 	t->init(t->t);

