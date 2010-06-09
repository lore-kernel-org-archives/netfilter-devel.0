From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH nf-next-2.6] netfilter: CLUSTERIP: RCU conversion
Date: Wed, 09 Jun 2010 19:11:47 +0200
Message-ID: <1276103507.2442.214.camel@edumazet-laptop>
References: <1276099861.2442.199.camel@edumazet-laptop>
	 <4C0FC1B6.2050605@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58648 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982Ab0FIRLv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Jun 2010 13:11:51 -0400
Received: by wyb40 with SMTP id 40so328028wyb.19
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Jun 2010 10:11:49 -0700 (PDT)
In-Reply-To: <4C0FC1B6.2050605@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mercredi 09 juin 2010 =C3=A0 18:30 +0200, Patrick McHardy a =C3=A9cr=
it :
> Eric Dumazet wrote:
> > @@ -121,16 +128,14 @@ clusterip_config_find_get(__be32 clusterip, i=
nt entry)
> >  {
> >  	struct clusterip_config *c;
> > =20
> > -	read_lock_bh(&clusterip_lock);
> > +	rcu_read_lock_bh();
> >  	c =3D __clusterip_config_find(clusterip);
> > -	if (!c) {
> > -		read_unlock_bh(&clusterip_lock);
> > -		return NULL;
> > +	if (c) {
> > +		atomic_inc(&c->refcount);
> > +		if (entry)
> > +			atomic_inc(&c->entries);
> >  =20
>=20
> Shouldn't this be using atomic_inc_not_zero() to avoid races with
> clusterip_config_entry_put()?
>=20

Ah yes, I should stop doing patches today !

Hmm, I am not sure current code is correct ?

clusterip_config_find_get() can return a struct clusterip_config pointe=
r
to an entry just that was given to clusterip_config_entry_put()
(c->entries =3D=3D 0)

Then we access c->dev, while clusterip_config_entry_put() did a
dev_put(c->dev) on it ?

So following 'standard rcu lookup' works, but race is still there ?

static inline struct clusterip_config *
clusterip_config_find_get(__be32 clusterip, int entry)
{
        struct clusterip_config *c;

        rcu_read_lock_bh();
        c =3D __clusterip_config_find(clusterip);
        if (c) {
                if (unlikely(!atomic_inc_not_zero(&c->refcount)))
                        c  =3D NULL;
                else if (entry)
                        atomic_inc(&c->entries);
        }
        rcu_read_unlock_bh();

        return c;
}


updated patch for reference :

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ip=
t_CLUSTERIP.c
index f91c94b..ecd77b1 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -53,12 +53,13 @@ struct clusterip_config {
 #endif
 	enum clusterip_hashmode hash_mode;	/* which hashing mode */
 	u_int32_t hash_initval;			/* hash initialization */
+	struct rcu_head rcu;
 };
=20
 static LIST_HEAD(clusterip_configs);
=20
 /* clusterip_lock protects the clusterip_configs list */
-static DEFINE_RWLOCK(clusterip_lock);
+static DEFINE_SPINLOCK(clusterip_lock);
=20
 #ifdef CONFIG_PROC_FS
 static const struct file_operations clusterip_proc_fops;
@@ -71,11 +72,17 @@ clusterip_config_get(struct clusterip_config *c)
 	atomic_inc(&c->refcount);
 }
=20
+
+static void clusterip_config_rcu_free(struct rcu_head *head)
+{
+	kfree(container_of(head, struct clusterip_config, rcu));
+}
+
 static inline void
 clusterip_config_put(struct clusterip_config *c)
 {
 	if (atomic_dec_and_test(&c->refcount))
-		kfree(c);
+		call_rcu_bh(&c->rcu, clusterip_config_rcu_free);
 }
=20
 /* decrease the count of entries using/referencing this config.  If la=
st
@@ -84,10 +91,10 @@ clusterip_config_put(struct clusterip_config *c)
 static inline void
 clusterip_config_entry_put(struct clusterip_config *c)
 {
-	write_lock_bh(&clusterip_lock);
+	spin_lock_bh(&clusterip_lock);
 	if (atomic_dec_and_test(&c->entries)) {
 		list_del(&c->list);
-		write_unlock_bh(&clusterip_lock);
+		spin_unlock_bh(&clusterip_lock);
=20
 		dev_mc_del(c->dev, c->clustermac);
 		dev_put(c->dev);
@@ -100,7 +107,7 @@ clusterip_config_entry_put(struct clusterip_config =
*c)
 #endif
 		return;
 	}
-	write_unlock_bh(&clusterip_lock);
+	spin_unlock_bh(&clusterip_lock);
 }
=20
 static struct clusterip_config *
@@ -108,7 +115,7 @@ __clusterip_config_find(__be32 clusterip)
 {
 	struct clusterip_config *c;
=20
-	list_for_each_entry(c, &clusterip_configs, list) {
+	list_for_each_entry_rcu(c, &clusterip_configs, list) {
 		if (c->clusterip =3D=3D clusterip)
 			return c;
 	}
@@ -121,16 +128,15 @@ clusterip_config_find_get(__be32 clusterip, int e=
ntry)
 {
 	struct clusterip_config *c;
=20
-	read_lock_bh(&clusterip_lock);
+	rcu_read_lock_bh();
 	c =3D __clusterip_config_find(clusterip);
-	if (!c) {
-		read_unlock_bh(&clusterip_lock);
-		return NULL;
+	if (c) {
+		if (unlikely(!atomic_inc_not_zero(&c->refcount)))
+			c  =3D NULL;
+		else if (entry)
+			atomic_inc(&c->entries);
 	}
-	atomic_inc(&c->refcount);
-	if (entry)
-		atomic_inc(&c->entries);
-	read_unlock_bh(&clusterip_lock);
+	rcu_read_unlock_bh();
=20
 	return c;
 }
@@ -181,9 +187,9 @@ clusterip_config_init(const struct ipt_clusterip_tg=
t_info *i, __be32 ip,
 	}
 #endif
=20
-	write_lock_bh(&clusterip_lock);
+	spin_lock_bh(&clusterip_lock);
 	list_add(&c->list, &clusterip_configs);
-	write_unlock_bh(&clusterip_lock);
+	spin_unlock_bh(&clusterip_lock);
=20
 	return c;
 }
@@ -733,6 +739,9 @@ static void __exit clusterip_tg_exit(void)
 #endif
 	nf_unregister_hook(&cip_arp_ops);
 	xt_unregister_target(&clusterip_tg_reg);
+
+	/* Wait for completion of call_rcu_bh()'s (clusterip_config_rcu_free)=
 */
+	rcu_barrier_bh();
 }
=20
 module_init(clusterip_tg_init);


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
