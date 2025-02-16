Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08896198831
	for <netfilter-devel@vger.kernel.org>; Sun, 16 Feb 2025 12:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739710768; cv=none; b=m3OisC3rsXhGNEU06M9+PviUfMnPxyHKRsWY7VqzWtwCKj3iy9iQ9HSEi+SBS01sV7UShmyTiKb7ILh2AJ75p7ikurjz6n/9MmB8/Wcqb7Adk55kNoQfdIH6ok43TGZh2r0iXam3EFCvzNuExYR5KWQ69dGj9VNJF31HI4mVYh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739710768; c=relaxed/simple;
	bh=0okZqDXAj6OWKFae//my5TaBQ3Xx3rkDO9GO4MLEc/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D99Dkoq8yreu3VHshIwy+4TCkhUpa6N+clBdy75Z+rvfTxhBFZT2Puy14RZNHR6tGO0ZYLWK113BkHm6GfVy3NJ3mMMhlnTa36hwccI4XdcyFw6as/bwgMkW1bVnRbIVtKYFvi9zUkaUr+gFzZcdCWvgYRgzGLUFYuWEG9N25X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=cZfWKDcF; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=MxTHdpNT; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="cZfWKDcF";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="MxTHdpNT"
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1739710301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SlYtlPYwn8A2wfbRst1mve1bNY3Vm3u3sn5X+0h3fa8=;
	b=cZfWKDcF3NmSBYL9xRx+T6RzKvTZOp1irBwvQW7c8tWb6xNUUBSfU1bW5NsQAyFlJYIm78
	Ve42aLXHOJk13DwX7mU+dPOJ8ZcZnMNk7Bc7n7HG+eh1/xJJO6GkUXy2bMngmQ6QAqqEcC
	2psN6cKxZ32iwASmqUK+j3O2qMAgh3KnMFJPQAthh2kYC516DKSUnFg5uOwgmpe9BOE6YS
	JolfhXSGUbYWt2ebN5SZwMJXRYHGvk5gFW8hGjmx94fa7ZCKsR/8cpQNviYibVgfOFfLLE
	jhPXCqQdiCDEVNN6DF9Na0x1gmR14vJY0+NE5RFtR/t4j9aYqnpV2zNZEuECzg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1739710301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SlYtlPYwn8A2wfbRst1mve1bNY3Vm3u3sn5X+0h3fa8=;
	b=MxTHdpNTogM5M8txIjWQZUmPjkhVr0KCT+hsJDH+JMZelIBUQSWYuB5CqodJqcvuBORzd6
	rZRf+nLDH5d7IFBQ==
To: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next 1/3] netfilter: Make xt_table::private RCU protected.
Date: Sun, 16 Feb 2025 13:51:33 +0100
Message-ID: <20250216125135.3037967-2-bigeasy@linutronix.de>
In-Reply-To: <20250216125135.3037967-1-bigeasy@linutronix.de>
References: <20250216125135.3037967-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The seqcount xt_recseq is used to synchronize the replacement of
xt_table::private in xt_replace_table() against all readers such as
ipt_do_table(). After the pointer is replaced, xt_register_target()
iterates over all per-CPU xt_recseq to ensure that none of CPUs is
within the critical section.
Once this is done, the old pointer can be examined and deallocated
safely.

This can also be achieved with RCU: Each reader of the private pointer
will be with in an RCU read section. The new pointer will be published
with rcu_assign_pointer() and synchronize_rcu() is used to wait until
each reader left its critical section.

Use RCU to assign xt_table::private and synchronise against reader.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/linux/netfilter/x_tables.h |  8 ++++-
 net/ipv4/netfilter/arp_tables.c    | 20 +++++++-----
 net/ipv4/netfilter/ip_tables.c     | 20 +++++++-----
 net/ipv6/netfilter/ip6_tables.c    | 20 +++++++-----
 net/netfilter/x_tables.c           | 50 ++++++++++++------------------
 5 files changed, 62 insertions(+), 56 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x=
_tables.h
index f39f688d72852..b9cd82e845d08 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -227,7 +227,7 @@ struct xt_table {
 	unsigned int valid_hooks;
=20
 	/* Man behind the curtain... */
-	struct xt_table_info *private;
+	struct xt_table_info __rcu *priv_info;
=20
 	/* hook ops that register the table with the netfilter core */
 	struct nf_hook_ops *ops;
@@ -345,6 +345,12 @@ void xt_free_table_info(struct xt_table_info *info);
  */
 DECLARE_PER_CPU(seqcount_t, xt_recseq);
=20
+bool xt_af_lock_held(u_int8_t af);
+static inline struct xt_table_info *nf_table_private(const struct xt_table=
 *table)
+{
+	return rcu_dereference_check(table->priv_info, xt_af_lock_held(table->af)=
);
+}
+
 /* xt_tee_enabled - true if x_tables needs to handle reentrancy
  *
  * Enabled if current ip(6)tables ruleset has at least one -j TEE rule.
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_table=
s.c
index 1cdd9c28ab2da..0628e68910f7f 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -203,8 +203,9 @@ unsigned int arpt_do_table(void *priv,
 	outdev =3D state->out ? state->out->name : nulldevname;
=20
 	local_bh_disable();
+	rcu_read_lock();
 	addend =3D xt_write_recseq_begin();
-	private =3D READ_ONCE(table->private); /* Address dependency. */
+	private =3D rcu_dereference(table->priv_info);
 	cpu     =3D smp_processor_id();
 	table_base =3D private->entries;
 	jumpstack  =3D (struct arpt_entry **)private->jumpstack[cpu];
@@ -279,6 +280,7 @@ unsigned int arpt_do_table(void *priv,
 		}
 	} while (!acpar.hotdrop);
 	xt_write_recseq_end(addend);
+	rcu_read_unlock();
 	local_bh_enable();
=20
 	if (acpar.hotdrop)
@@ -648,9 +650,9 @@ static void get_old_counters(const struct xt_table_info=
 *t,
=20
 static struct xt_counters *alloc_counters(const struct xt_table *table)
 {
+	const struct xt_table_info *private =3D nf_table_private(table);
 	unsigned int countersize;
 	struct xt_counters *counters;
-	const struct xt_table_info *private =3D table->private;
=20
 	/* We need atomic snapshot of counters: rest doesn't change
 	 * (other than comefrom, which userspace doesn't care
@@ -671,10 +673,10 @@ static int copy_entries_to_user(unsigned int total_si=
ze,
 				const struct xt_table *table,
 				void __user *userptr)
 {
+	struct xt_table_info *private =3D nf_table_private(table);
 	unsigned int off, num;
 	const struct arpt_entry *e;
 	struct xt_counters *counters;
-	struct xt_table_info *private =3D table->private;
 	int ret =3D 0;
 	void *loc_cpu_entry;
=20
@@ -808,7 +810,7 @@ static int get_info(struct net *net, void __user *user,=
 const int *len)
 	t =3D xt_request_find_table_lock(net, NFPROTO_ARP, name);
 	if (!IS_ERR(t)) {
 		struct arpt_getinfo info;
-		const struct xt_table_info *private =3D t->private;
+		const struct xt_table_info *private =3D nf_table_private(t);
 #ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 		struct xt_table_info tmp;
=20
@@ -861,7 +863,7 @@ static int get_entries(struct net *net, struct arpt_get=
_entries __user *uptr,
=20
 	t =3D xt_find_table_lock(net, NFPROTO_ARP, get.name);
 	if (!IS_ERR(t)) {
-		const struct xt_table_info *private =3D t->private;
+		const struct xt_table_info *private =3D nf_table_private(t);
=20
 		if (get.size =3D=3D private->size)
 			ret =3D copy_entries_to_user(private->size,
@@ -1022,7 +1024,8 @@ static int do_add_counters(struct net *net, sockptr_t=
 arg, unsigned int len)
 	}
=20
 	local_bh_disable();
-	private =3D t->private;
+	rcu_read_lock();
+	private =3D rcu_dereference(t->priv_info);
 	if (private->number !=3D tmp.num_counters) {
 		ret =3D -EINVAL;
 		goto unlock_up_free;
@@ -1040,6 +1043,7 @@ static int do_add_counters(struct net *net, sockptr_t=
 arg, unsigned int len)
 	}
 	xt_write_recseq_end(addend);
  unlock_up_free:
+	rcu_read_unlock();
 	local_bh_enable();
 	xt_table_unlock(t);
 	module_put(t->me);
@@ -1340,8 +1344,8 @@ static int compat_copy_entries_to_user(unsigned int t=
otal_size,
 				       struct xt_table *table,
 				       void __user *userptr)
 {
+	const struct xt_table_info *private =3D nf_table_private(table);
 	struct xt_counters *counters;
-	const struct xt_table_info *private =3D table->private;
 	void __user *pos;
 	unsigned int size;
 	int ret =3D 0;
@@ -1390,7 +1394,7 @@ static int compat_get_entries(struct net *net,
 	xt_compat_lock(NFPROTO_ARP);
 	t =3D xt_find_table_lock(net, NFPROTO_ARP, get.name);
 	if (!IS_ERR(t)) {
-		const struct xt_table_info *private =3D t->private;
+		const struct xt_table_info *private =3D nf_table_private(t);
 		struct xt_table_info info;
=20
 		ret =3D compat_table_info(private, &info);
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 3d101613f27fa..20e8b46af8876 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -256,8 +256,9 @@ ipt_do_table(void *priv,
=20
 	WARN_ON(!(table->valid_hooks & (1 << hook)));
 	local_bh_disable();
+	rcu_read_lock();
+	private =3D rcu_dereference(table->priv_info);
 	addend =3D xt_write_recseq_begin();
-	private =3D READ_ONCE(table->private); /* Address dependency. */
 	cpu        =3D smp_processor_id();
 	table_base =3D private->entries;
 	jumpstack  =3D (struct ipt_entry **)private->jumpstack[cpu];
@@ -354,6 +355,7 @@ ipt_do_table(void *priv,
 	} while (!acpar.hotdrop);
=20
 	xt_write_recseq_end(addend);
+	rcu_read_unlock();
 	local_bh_enable();
=20
 	if (acpar.hotdrop)
@@ -788,9 +790,9 @@ static void get_old_counters(const struct xt_table_info=
 *t,
=20
 static struct xt_counters *alloc_counters(const struct xt_table *table)
 {
+	const struct xt_table_info *private =3D nf_table_private(table);
 	unsigned int countersize;
 	struct xt_counters *counters;
-	const struct xt_table_info *private =3D table->private;
=20
 	/* We need atomic snapshot of counters: rest doesn't change
 	   (other than comefrom, which userspace doesn't care
@@ -811,10 +813,10 @@ copy_entries_to_user(unsigned int total_size,
 		     const struct xt_table *table,
 		     void __user *userptr)
 {
+	const struct xt_table_info *private =3D nf_table_private(table);
 	unsigned int off, num;
 	const struct ipt_entry *e;
 	struct xt_counters *counters;
-	const struct xt_table_info *private =3D table->private;
 	int ret =3D 0;
 	const void *loc_cpu_entry;
=20
@@ -963,7 +965,7 @@ static int get_info(struct net *net, void __user *user,=
 const int *len)
 	t =3D xt_request_find_table_lock(net, AF_INET, name);
 	if (!IS_ERR(t)) {
 		struct ipt_getinfo info;
-		const struct xt_table_info *private =3D t->private;
+		const struct xt_table_info *private =3D nf_table_private(t);
 #ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 		struct xt_table_info tmp;
=20
@@ -1017,7 +1019,7 @@ get_entries(struct net *net, struct ipt_get_entries _=
_user *uptr,
=20
 	t =3D xt_find_table_lock(net, AF_INET, get.name);
 	if (!IS_ERR(t)) {
-		const struct xt_table_info *private =3D t->private;
+		const struct xt_table_info *private =3D nf_table_private(t);
 		if (get.size =3D=3D private->size)
 			ret =3D copy_entries_to_user(private->size,
 						   t, uptr->entrytable);
@@ -1175,7 +1177,8 @@ do_add_counters(struct net *net, sockptr_t arg, unsig=
ned int len)
 	}
=20
 	local_bh_disable();
-	private =3D t->private;
+	rcu_read_lock();
+	private =3D rcu_dereference(t->priv_info);
 	if (private->number !=3D tmp.num_counters) {
 		ret =3D -EINVAL;
 		goto unlock_up_free;
@@ -1192,6 +1195,7 @@ do_add_counters(struct net *net, sockptr_t arg, unsig=
ned int len)
 	}
 	xt_write_recseq_end(addend);
  unlock_up_free:
+	rcu_read_unlock();
 	local_bh_enable();
 	xt_table_unlock(t);
 	module_put(t->me);
@@ -1550,8 +1554,8 @@ static int
 compat_copy_entries_to_user(unsigned int total_size, struct xt_table *tabl=
e,
 			    void __user *userptr)
 {
+	const struct xt_table_info *private =3D nf_table_private(table);
 	struct xt_counters *counters;
-	const struct xt_table_info *private =3D table->private;
 	void __user *pos;
 	unsigned int size;
 	int ret =3D 0;
@@ -1597,7 +1601,7 @@ compat_get_entries(struct net *net, struct compat_ipt=
_get_entries __user *uptr,
 	xt_compat_lock(AF_INET);
 	t =3D xt_find_table_lock(net, AF_INET, get.name);
 	if (!IS_ERR(t)) {
-		const struct xt_table_info *private =3D t->private;
+		const struct xt_table_info *private =3D nf_table_private(t);
 		struct xt_table_info info;
 		ret =3D compat_table_info(private, &info);
 		if (!ret && get.size =3D=3D info.size)
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_table=
s.c
index 7d5602950ae72..c12d489a09840 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -278,8 +278,9 @@ ip6t_do_table(void *priv, struct sk_buff *skb,
 	WARN_ON(!(table->valid_hooks & (1 << hook)));
=20
 	local_bh_disable();
+	rcu_read_lock();
+	private =3D rcu_dereference(table->priv_info);
 	addend =3D xt_write_recseq_begin();
-	private =3D READ_ONCE(table->private); /* Address dependency. */
 	cpu        =3D smp_processor_id();
 	table_base =3D private->entries;
 	jumpstack  =3D (struct ip6t_entry **)private->jumpstack[cpu];
@@ -372,6 +373,7 @@ ip6t_do_table(void *priv, struct sk_buff *skb,
 	} while (!acpar.hotdrop);
=20
 	xt_write_recseq_end(addend);
+	rcu_read_unlock();
 	local_bh_enable();
=20
 	if (acpar.hotdrop)
@@ -804,9 +806,9 @@ static void get_old_counters(const struct xt_table_info=
 *t,
=20
 static struct xt_counters *alloc_counters(const struct xt_table *table)
 {
+	const struct xt_table_info *private =3D nf_table_private(table);
 	unsigned int countersize;
 	struct xt_counters *counters;
-	const struct xt_table_info *private =3D table->private;
=20
 	/* We need atomic snapshot of counters: rest doesn't change
 	   (other than comefrom, which userspace doesn't care
@@ -827,10 +829,10 @@ copy_entries_to_user(unsigned int total_size,
 		     const struct xt_table *table,
 		     void __user *userptr)
 {
+	const struct xt_table_info *private =3D nf_table_private(table);
 	unsigned int off, num;
 	const struct ip6t_entry *e;
 	struct xt_counters *counters;
-	const struct xt_table_info *private =3D table->private;
 	int ret =3D 0;
 	const void *loc_cpu_entry;
=20
@@ -979,7 +981,7 @@ static int get_info(struct net *net, void __user *user,=
 const int *len)
 	t =3D xt_request_find_table_lock(net, AF_INET6, name);
 	if (!IS_ERR(t)) {
 		struct ip6t_getinfo info;
-		const struct xt_table_info *private =3D t->private;
+		const struct xt_table_info *private =3D nf_table_private(t);
 #ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 		struct xt_table_info tmp;
=20
@@ -1034,7 +1036,7 @@ get_entries(struct net *net, struct ip6t_get_entries =
__user *uptr,
=20
 	t =3D xt_find_table_lock(net, AF_INET6, get.name);
 	if (!IS_ERR(t)) {
-		struct xt_table_info *private =3D t->private;
+		struct xt_table_info *private =3D nf_table_private(t);
 		if (get.size =3D=3D private->size)
 			ret =3D copy_entries_to_user(private->size,
 						   t, uptr->entrytable);
@@ -1191,7 +1193,8 @@ do_add_counters(struct net *net, sockptr_t arg, unsig=
ned int len)
 	}
=20
 	local_bh_disable();
-	private =3D t->private;
+	rcu_read_lock();
+	private =3D rcu_dereference(t->priv_info);
 	if (private->number !=3D tmp.num_counters) {
 		ret =3D -EINVAL;
 		goto unlock_up_free;
@@ -1208,6 +1211,7 @@ do_add_counters(struct net *net, sockptr_t arg, unsig=
ned int len)
 	}
 	xt_write_recseq_end(addend);
  unlock_up_free:
+	rcu_read_unlock();
 	local_bh_enable();
 	xt_table_unlock(t);
 	module_put(t->me);
@@ -1559,8 +1563,8 @@ static int
 compat_copy_entries_to_user(unsigned int total_size, struct xt_table *tabl=
e,
 			    void __user *userptr)
 {
+	const struct xt_table_info *private =3D nf_table_private(table);
 	struct xt_counters *counters;
-	const struct xt_table_info *private =3D table->private;
 	void __user *pos;
 	unsigned int size;
 	int ret =3D 0;
@@ -1606,7 +1610,7 @@ compat_get_entries(struct net *net, struct compat_ip6=
t_get_entries __user *uptr,
 	xt_compat_lock(AF_INET6);
 	t =3D xt_find_table_lock(net, AF_INET6, get.name);
 	if (!IS_ERR(t)) {
-		const struct xt_table_info *private =3D t->private;
+		const struct xt_table_info *private =3D nf_table_private(t);
 		struct xt_table_info info;
 		ret =3D compat_table_info(private, &info);
 		if (!ret && get.size =3D=3D info.size)
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 709840612f0df..ee38272cca562 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -85,6 +85,19 @@ static const char *const xt_prefix[NFPROTO_NUMPROTO] =3D=
 {
 	[NFPROTO_IPV6]   =3D "ip6",
 };
=20
+#ifdef CONFIG_LOCKDEP
+bool xt_af_lock_held(u_int8_t af)
+{
+	return lockdep_is_held(&xt[af].mutex) ||
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
+		lockdep_is_held(&xt[af].compat_mutex);
+#else
+		false;
+#endif
+}
+EXPORT_SYMBOL_GPL(xt_af_lock_held);
+#endif
+
 /* Registration hooks for targets. */
 int xt_register_target(struct xt_target *target)
 {
@@ -1388,7 +1401,6 @@ xt_replace_table(struct xt_table *table,
 	      int *error)
 {
 	struct xt_table_info *private;
-	unsigned int cpu;
 	int ret;
=20
 	ret =3D xt_jumpstack_alloc(newinfo);
@@ -1397,48 +1409,24 @@ xt_replace_table(struct xt_table *table,
 		return NULL;
 	}
=20
-	/* Do the substitution. */
-	local_bh_disable();
-	private =3D table->private;
+	private =3D nf_table_private(table);
=20
 	/* Check inside lock: is the old number correct? */
 	if (num_counters !=3D private->number) {
 		pr_debug("num_counters !=3D table->private->number (%u/%u)\n",
 			 num_counters, private->number);
-		local_bh_enable();
 		*error =3D -EAGAIN;
 		return NULL;
 	}
=20
 	newinfo->initial_entries =3D private->initial_entries;
-	/*
-	 * Ensure contents of newinfo are visible before assigning to
-	 * private.
-	 */
-	smp_wmb();
-	table->private =3D newinfo;
-
-	/* make sure all cpus see new ->private value */
-	smp_mb();
=20
+	rcu_assign_pointer(table->priv_info, newinfo);
 	/*
 	 * Even though table entries have now been swapped, other CPU's
 	 * may still be using the old entries...
 	 */
-	local_bh_enable();
-
-	/* ... so wait for even xt_recseq on all cpus */
-	for_each_possible_cpu(cpu) {
-		seqcount_t *s =3D &per_cpu(xt_recseq, cpu);
-		u32 seq =3D raw_read_seqcount(s);
-
-		if (seq & 1) {
-			do {
-				cond_resched();
-				cpu_relax();
-			} while (seq =3D=3D raw_read_seqcount(s));
-		}
-	}
+	synchronize_rcu();
=20
 	audit_log_nfcfg(table->name, table->af, private->number,
 			!private->number ? AUDIT_XT_OP_REGISTER :
@@ -1475,12 +1463,12 @@ struct xt_table *xt_register_table(struct net *net,
 	}
=20
 	/* Simplifies replace_table code. */
-	table->private =3D bootstrap;
+	rcu_assign_pointer(table->priv_info, bootstrap);
=20
 	if (!xt_replace_table(table, 0, newinfo, &ret))
 		goto unlock;
=20
-	private =3D table->private;
+	private =3D nf_table_private(table);
 	pr_debug("table->private->number =3D %u\n", private->number);
=20
 	/* save number of initial entries */
@@ -1503,7 +1491,7 @@ void *xt_unregister_table(struct xt_table *table)
 	struct xt_table_info *private;
=20
 	mutex_lock(&xt[table->af].mutex);
-	private =3D table->private;
+	private =3D nf_table_private(table);
 	list_del(&table->list);
 	mutex_unlock(&xt[table->af].mutex);
 	audit_log_nfcfg(table->name, table->af, private->number,
--=20
2.47.2

