From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH nf-next-2.6] netfilter: add __rcu annotations
Date: Mon, 15 Nov 2010 18:03:35 +0100
Message-ID: <1289840615.2607.96.camel@edumazet-laptop>
References: <1289839592.2607.91.camel@edumazet-laptop>
	 <4CE16591.9030504@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46866 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756641Ab0KORDl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Nov 2010 12:03:41 -0500
Received: by wyb28 with SMTP id 28so4610521wyb.19
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Nov 2010 09:03:39 -0800 (PST)
In-Reply-To: <4CE16591.9030504@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le lundi 15 novembre 2010 =C3=A0 17:53 +0100, Patrick McHardy a =C3=A9c=
rit :
> On 15.11.2010 17:46, Eric Dumazet wrote:
> > @@ -49,11 +52,15 @@ EXPORT_SYMBOL(nf_register_queue_handler);
> >  /* The caller must flush their queue before this */
> >  int nf_unregister_queue_handler(u_int8_t pf, const struct nf_queue=
_handler *qh)
> >  {
> > +	const struct nf_queue_handler *old;
> > +
> >  	if (pf >=3D ARRAY_SIZE(queue_handler))
> >  		return -EINVAL;
> > =20
> >  	mutex_lock(&queue_handler_mutex);
> > -	if (queue_handler[pf] && queue_handler[pf] !=3D qh) {
> > +	old =3D rcu_dereference_protected(queue_handler[pf],
> > +					lockdep_is_held(&queue_handler_mutex));
> > +	if (old && old) {
>=20
> This doesn't look like it was intended :)
>=20
> if (old && old !=3D qh)?

Thanks for the catch Patrick, here is an updated version.

[PATCH nf-next-2.6] netfilter: add __rcu annotations

Add some __rcu annotations and use helpers to reduce number of sparse
warnings (CONFIG_SPARSE_RCU_POINTER=3Dy)

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 include/linux/netfilter.h                    |    6 ++---
 include/net/netfilter/nf_conntrack_ecache.h  |    4 +--
 include/net/netfilter/nf_conntrack_l3proto.h |    2 -
 net/netfilter/core.c                         |    4 +--
 net/netfilter/nf_conntrack_expect.c          |    6 ++---
 net/netfilter/nf_conntrack_proto.c           |   20 ++++++++++++-----
 net/netfilter/nf_conntrack_standalone.c      |    9 +++++--
 net/netfilter/nf_log.c                       |    6 +++--
 net/netfilter/nf_queue.c                     |   18 +++++++++++----
 net/netfilter/nfnetlink_log.c                |    6 ++---
 10 files changed, 53 insertions(+), 28 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 89341c3..928a35e 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -265,7 +265,7 @@ struct nf_afinfo {
 	int		route_key_size;
 };
=20
-extern const struct nf_afinfo *nf_afinfo[NFPROTO_NUMPROTO];
+extern const struct nf_afinfo __rcu *nf_afinfo[NFPROTO_NUMPROTO];
 static inline const struct nf_afinfo *nf_get_afinfo(unsigned short fam=
ily)
 {
 	return rcu_dereference(nf_afinfo[family]);
@@ -355,9 +355,9 @@ nf_nat_decode_session(struct sk_buff *skb, struct f=
lowi *fl, u_int8_t family)
 #endif /*CONFIG_NETFILTER*/
=20
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE=
)
-extern void (*ip_ct_attach)(struct sk_buff *, struct sk_buff *);
+extern void (*ip_ct_attach)(struct sk_buff *, struct sk_buff *) __rcu;
 extern void nf_ct_attach(struct sk_buff *, struct sk_buff *);
-extern void (*nf_ct_destroy)(struct nf_conntrack *);
+extern void (*nf_ct_destroy)(struct nf_conntrack *) __rcu;
 #else
 static inline void nf_ct_attach(struct sk_buff *new, struct sk_buff *s=
kb) {}
 #endif
diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/=
netfilter/nf_conntrack_ecache.h
index f596b60..8fdb04b 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -67,7 +67,7 @@ struct nf_ct_event_notifier {
 	int (*fcn)(unsigned int events, struct nf_ct_event *item);
 };
=20
-extern struct nf_ct_event_notifier *nf_conntrack_event_cb;
+extern struct nf_ct_event_notifier __rcu *nf_conntrack_event_cb;
 extern int nf_conntrack_register_notifier(struct nf_ct_event_notifier =
*nb);
 extern void nf_conntrack_unregister_notifier(struct nf_ct_event_notifi=
er *nb);
=20
@@ -167,7 +167,7 @@ struct nf_exp_event_notifier {
 	int (*fcn)(unsigned int events, struct nf_exp_event *item);
 };
=20
-extern struct nf_exp_event_notifier *nf_expect_event_cb;
+extern struct nf_exp_event_notifier __rcu *nf_expect_event_cb;
 extern int nf_ct_expect_register_notifier(struct nf_exp_event_notifier=
 *nb);
 extern void nf_ct_expect_unregister_notifier(struct nf_exp_event_notif=
ier *nb);
=20
diff --git a/include/net/netfilter/nf_conntrack_l3proto.h b/include/net=
/netfilter/nf_conntrack_l3proto.h
index a754761..e8010f4 100644
--- a/include/net/netfilter/nf_conntrack_l3proto.h
+++ b/include/net/netfilter/nf_conntrack_l3proto.h
@@ -73,7 +73,7 @@ struct nf_conntrack_l3proto {
 	struct module *me;
 };
=20
-extern struct nf_conntrack_l3proto *nf_ct_l3protos[AF_MAX];
+extern struct nf_conntrack_l3proto __rcu *nf_ct_l3protos[AF_MAX];
=20
 /* Protocol registration. */
 extern int nf_conntrack_l3proto_register(struct nf_conntrack_l3proto *=
proto);
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 85dabb8..5faec4f 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -212,7 +212,7 @@ EXPORT_SYMBOL(skb_make_writable);
 /* This does not belong here, but locally generated errors need it if =
connection
    tracking in use: without this, connection may not be in hash table,=
 and hence
    manufactured ICMP or RST packets will not be associated with it. */
-void (*ip_ct_attach)(struct sk_buff *, struct sk_buff *);
+void (*ip_ct_attach)(struct sk_buff *, struct sk_buff *) __rcu __read_=
mostly;
 EXPORT_SYMBOL(ip_ct_attach);
=20
 void nf_ct_attach(struct sk_buff *new, struct sk_buff *skb)
@@ -229,7 +229,7 @@ void nf_ct_attach(struct sk_buff *new, struct sk_bu=
ff *skb)
 }
 EXPORT_SYMBOL(nf_ct_attach);
=20
-void (*nf_ct_destroy)(struct nf_conntrack *);
+void (*nf_ct_destroy)(struct nf_conntrack *) __rcu __read_mostly;
 EXPORT_SYMBOL(nf_ct_destroy);
=20
 void nf_conntrack_destroy(struct nf_conntrack *nfct)
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_con=
ntrack_expect.c
index 46e8966..cab196c 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -482,7 +482,7 @@ static struct hlist_node *ct_expect_get_first(struc=
t seq_file *seq)
 	struct hlist_node *n;
=20
 	for (st->bucket =3D 0; st->bucket < nf_ct_expect_hsize; st->bucket++)=
 {
-		n =3D rcu_dereference(net->ct.expect_hash[st->bucket].first);
+		n =3D rcu_dereference(hlist_first_rcu(&net->ct.expect_hash[st->bucke=
t]));
 		if (n)
 			return n;
 	}
@@ -495,11 +495,11 @@ static struct hlist_node *ct_expect_get_next(stru=
ct seq_file *seq,
 	struct net *net =3D seq_file_net(seq);
 	struct ct_expect_iter_state *st =3D seq->private;
=20
-	head =3D rcu_dereference(head->next);
+	head =3D rcu_dereference(hlist_next_rcu(head));
 	while (head =3D=3D NULL) {
 		if (++st->bucket >=3D nf_ct_expect_hsize)
 			return NULL;
-		head =3D rcu_dereference(net->ct.expect_hash[st->bucket].first);
+		head =3D rcu_dereference(hlist_first_rcu(&net->ct.expect_hash[st->bu=
cket]));
 	}
 	return head;
 }
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conn=
track_proto.c
index dc7bb74..03b56a0 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -166,6 +166,7 @@ static void nf_ct_l3proto_unregister_sysctl(struct =
nf_conntrack_l3proto *l3proto
 int nf_conntrack_l3proto_register(struct nf_conntrack_l3proto *proto)
 {
 	int ret =3D 0;
+	struct nf_conntrack_l3proto *old;
=20
 	if (proto->l3proto >=3D AF_MAX)
 		return -EBUSY;
@@ -174,7 +175,9 @@ int nf_conntrack_l3proto_register(struct nf_conntra=
ck_l3proto *proto)
 		return -EINVAL;
=20
 	mutex_lock(&nf_ct_proto_mutex);
-	if (nf_ct_l3protos[proto->l3proto] !=3D &nf_conntrack_l3proto_generic=
) {
+	old =3D rcu_dereference_protected(nf_ct_l3protos[proto->l3proto],
+					lockdep_is_held(&nf_ct_proto_mutex));
+	if (old !=3D &nf_conntrack_l3proto_generic) {
 		ret =3D -EBUSY;
 		goto out_unlock;
 	}
@@ -201,7 +204,9 @@ void nf_conntrack_l3proto_unregister(struct nf_conn=
track_l3proto *proto)
 	BUG_ON(proto->l3proto >=3D AF_MAX);
=20
 	mutex_lock(&nf_ct_proto_mutex);
-	BUG_ON(nf_ct_l3protos[proto->l3proto] !=3D proto);
+	BUG_ON(rcu_dereference_protected(nf_ct_l3protos[proto->l3proto],
+					 lockdep_is_held(&nf_ct_proto_mutex)
+					 ) !=3D proto);
 	rcu_assign_pointer(nf_ct_l3protos[proto->l3proto],
 			   &nf_conntrack_l3proto_generic);
 	nf_ct_l3proto_unregister_sysctl(proto);
@@ -299,8 +304,10 @@ int nf_conntrack_l4proto_register(struct nf_conntr=
ack_l4proto *l4proto)
 		smp_wmb();
=20
 		nf_ct_protos[l4proto->l3proto] =3D proto_array;
-	} else if (nf_ct_protos[l4proto->l3proto][l4proto->l4proto] !=3D
-					&nf_conntrack_l4proto_generic) {
+	} else if (rcu_dereference_protected(
+			nf_ct_protos[l4proto->l3proto][l4proto->l4proto],
+			lockdep_is_held(&nf_ct_proto_mutex)
+			) !=3D &nf_conntrack_l4proto_generic) {
 		ret =3D -EBUSY;
 		goto out_unlock;
 	}
@@ -331,7 +338,10 @@ void nf_conntrack_l4proto_unregister(struct nf_con=
ntrack_l4proto *l4proto)
 	BUG_ON(l4proto->l3proto >=3D PF_MAX);
=20
 	mutex_lock(&nf_ct_proto_mutex);
-	BUG_ON(nf_ct_protos[l4proto->l3proto][l4proto->l4proto] !=3D l4proto)=
;
+	BUG_ON(rcu_dereference_protected(
+			nf_ct_protos[l4proto->l3proto][l4proto->l4proto],
+			lockdep_is_held(&nf_ct_proto_mutex)
+			) !=3D l4proto);
 	rcu_assign_pointer(nf_ct_protos[l4proto->l3proto][l4proto->l4proto],
 			   &nf_conntrack_l4proto_generic);
 	nf_ct_l4proto_unregister_sysctl(l4proto);
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf=
_conntrack_standalone.c
index 0fb6570..328f1d2 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -29,6 +29,7 @@
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_acct.h>
 #include <net/netfilter/nf_conntrack_zones.h>
+#include <linux/rculist_nulls.h>
=20
 MODULE_LICENSE("GPL");
=20
@@ -56,7 +57,7 @@ static struct hlist_nulls_node *ct_get_first(struct s=
eq_file *seq)
 	for (st->bucket =3D 0;
 	     st->bucket < net->ct.htable_size;
 	     st->bucket++) {
-		n =3D rcu_dereference(net->ct.hash[st->bucket].first);
+		n =3D rcu_dereference(hlist_nulls_first_rcu(&net->ct.hash[st->bucket=
]));
 		if (!is_a_nulls(n))
 			return n;
 	}
@@ -69,13 +70,15 @@ static struct hlist_nulls_node *ct_get_next(struct =
seq_file *seq,
 	struct net *net =3D seq_file_net(seq);
 	struct ct_iter_state *st =3D seq->private;
=20
-	head =3D rcu_dereference(head->next);
+	head =3D rcu_dereference(hlist_nulls_next_rcu(head));
 	while (is_a_nulls(head)) {
 		if (likely(get_nulls_value(head) =3D=3D st->bucket)) {
 			if (++st->bucket >=3D net->ct.htable_size)
 				return NULL;
 		}
-		head =3D rcu_dereference(net->ct.hash[st->bucket].first);
+		head =3D rcu_dereference(
+				hlist_nulls_first_rcu(
+					&net->ct.hash[st->bucket]));
 	}
 	return head;
 }
diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index b07393e..20c775c 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -161,7 +161,8 @@ static int seq_show(struct seq_file *s, void *v)
 	struct nf_logger *t;
 	int ret;
=20
-	logger =3D nf_loggers[*pos];
+	logger =3D rcu_dereference_protected(nf_loggers[*pos],
+					   lockdep_is_held(&nf_log_mutex));
=20
 	if (!logger)
 		ret =3D seq_printf(s, "%2lld NONE (", *pos);
@@ -249,7 +250,8 @@ static int nf_log_proc_dostring(ctl_table *table, i=
nt write,
 		mutex_unlock(&nf_log_mutex);
 	} else {
 		mutex_lock(&nf_log_mutex);
-		logger =3D nf_loggers[tindex];
+		logger =3D rcu_dereference_protected(nf_loggers[tindex],
+						   lockdep_is_held(&nf_log_mutex));
 		if (!logger)
 			table->data =3D "NONE";
 		else
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 74aebed..1876f74 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -27,14 +27,17 @@ static DEFINE_MUTEX(queue_handler_mutex);
 int nf_register_queue_handler(u_int8_t pf, const struct nf_queue_handl=
er *qh)
 {
 	int ret;
+	const struct nf_queue_handler *old;
=20
 	if (pf >=3D ARRAY_SIZE(queue_handler))
 		return -EINVAL;
=20
 	mutex_lock(&queue_handler_mutex);
-	if (queue_handler[pf] =3D=3D qh)
+	old =3D rcu_dereference_protected(queue_handler[pf],
+					lockdep_is_held(&queue_handler_mutex));
+	if (old =3D=3D qh)
 		ret =3D -EEXIST;
-	else if (queue_handler[pf])
+	else if (old)
 		ret =3D -EBUSY;
 	else {
 		rcu_assign_pointer(queue_handler[pf], qh);
@@ -49,11 +52,15 @@ EXPORT_SYMBOL(nf_register_queue_handler);
 /* The caller must flush their queue before this */
 int nf_unregister_queue_handler(u_int8_t pf, const struct nf_queue_han=
dler *qh)
 {
+	const struct nf_queue_handler *old;
+
 	if (pf >=3D ARRAY_SIZE(queue_handler))
 		return -EINVAL;
=20
 	mutex_lock(&queue_handler_mutex);
-	if (queue_handler[pf] && queue_handler[pf] !=3D qh) {
+	old =3D rcu_dereference_protected(queue_handler[pf],
+					lockdep_is_held(&queue_handler_mutex));
+	if (old && old !=3D qh) {
 		mutex_unlock(&queue_handler_mutex);
 		return -EINVAL;
 	}
@@ -73,7 +80,10 @@ void nf_unregister_queue_handlers(const struct nf_qu=
eue_handler *qh)
=20
 	mutex_lock(&queue_handler_mutex);
 	for (pf =3D 0; pf < ARRAY_SIZE(queue_handler); pf++)  {
-		if (queue_handler[pf] =3D=3D qh)
+		if (rcu_dereference_protected(
+				queue_handler[pf],
+				lockdep_is_held(&queue_handler_mutex)
+				) =3D=3D qh)
 			rcu_assign_pointer(queue_handler[pf], NULL);
 	}
 	mutex_unlock(&queue_handler_mutex);
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_lo=
g.c
index 6a1572b..91592da 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -874,19 +874,19 @@ static struct hlist_node *get_first(struct iter_s=
tate *st)
=20
 	for (st->bucket =3D 0; st->bucket < INSTANCE_BUCKETS; st->bucket++) {
 		if (!hlist_empty(&instance_table[st->bucket]))
-			return rcu_dereference_bh(instance_table[st->bucket].first);
+			return rcu_dereference_bh(hlist_first_rcu(&instance_table[st->bucke=
t]));
 	}
 	return NULL;
 }
=20
 static struct hlist_node *get_next(struct iter_state *st, struct hlist=
_node *h)
 {
-	h =3D rcu_dereference_bh(h->next);
+	h =3D rcu_dereference_bh(hlist_next_rcu(h));
 	while (!h) {
 		if (++st->bucket >=3D INSTANCE_BUCKETS)
 			return NULL;
=20
-		h =3D rcu_dereference_bh(instance_table[st->bucket].first);
+		h =3D rcu_dereference_bh(hlist_first_rcu(&instance_table[st->bucket]=
));
 	}
 	return h;
 }


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
