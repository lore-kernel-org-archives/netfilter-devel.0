From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH nf-next-2.6] netfilter: nfnetlink_log: RCU conversion
Date: Wed, 09 Jun 2010 20:09:30 +0200
Message-ID: <1276106970.2442.221.camel@edumazet-laptop>
References: <1276099088.2442.196.camel@edumazet-laptop>
	 <4C0FBE33.3030100@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:51919 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757605Ab0FISQi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Jun 2010 14:16:38 -0400
Received: by wwb31 with SMTP id 31so498480wwb.19
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Jun 2010 11:16:37 -0700 (PDT)
In-Reply-To: <4C0FBE33.3030100@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mercredi 09 juin 2010 =C3=A0 18:15 +0200, Patrick McHardy a =C3=A9cr=
it :

>=20
> Looks good to me. Applied, thanks Eric.

Well, I missed some bits ;)

Here are the fixes, sorry for previous crap !

Thanks

[PATCH nf-next-2.6] netfilter: nfnetlink_log: RCU conversion, part 2

- must use atomic_inc_not_zero() in instance_lookup_get()

- must use hlist_add_head_rcu() instead of hlist_add_head()

- must use hlist_del_rcu() instead of hlist_del()

- Introduce NFULNL_COPY_DISABLED to stop lockless reader from using an
instance, before we do final instance_put() on it.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 include/linux/netfilter/nfnetlink_log.h |    1 +
 net/netfilter/nfnetlink_log.c           |   18 ++++++++++++------
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_log.h b/include/linux/ne=
tfilter/nfnetlink_log.h
index d3bab7a..1d0b84a 100644
--- a/include/linux/netfilter/nfnetlink_log.h
+++ b/include/linux/netfilter/nfnetlink_log.h
@@ -89,6 +89,7 @@ enum nfulnl_attr_config {
 #define NFULNL_COPY_NONE	0x00
 #define NFULNL_COPY_META	0x01
 #define NFULNL_COPY_PACKET	0x02
+#define NFULNL_COPY_DISABLED	0x03
=20
 #define NFULNL_CFG_F_SEQ	0x0001
 #define NFULNL_CFG_F_SEQ_GLOBAL	0x0002
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_lo=
g.c
index 8ec23ec..fb86a51 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -109,8 +109,8 @@ instance_lookup_get(u_int16_t group_num)
=20
 	rcu_read_lock_bh();
 	inst =3D __instance_lookup(group_num);
-	if (inst)
-		instance_get(inst);
+	if (inst && !atomic_inc_not_zero(&inst->use))
+		inst =3D NULL;
 	rcu_read_unlock_bh();
=20
 	return inst;
@@ -171,7 +171,7 @@ instance_create(u_int16_t group_num, int pid)
 	inst->copy_mode 	=3D NFULNL_COPY_PACKET;
 	inst->copy_range 	=3D NFULNL_COPY_RANGE_MAX;
=20
-	hlist_add_head(&inst->hlist,
+	hlist_add_head_rcu(&inst->hlist,
 		       &instance_table[instance_hashfn(group_num)]);
=20
 	spin_unlock_bh(&instances_lock);
@@ -185,18 +185,23 @@ out_unlock:
=20
 static void __nfulnl_flush(struct nfulnl_instance *inst);
=20
+/* called with BH disabled */
 static void
 __instance_destroy(struct nfulnl_instance *inst)
 {
 	/* first pull it out of the global list */
-	hlist_del(&inst->hlist);
+	hlist_del_rcu(&inst->hlist);
=20
 	/* then flush all pending packets from skb */
=20
-	spin_lock_bh(&inst->lock);
+	spin_lock(&inst->lock);
+
+	/* lockless readers wont be able to use us */
+	inst->copy_mode =3D NFULNL_COPY_DISABLED;
+
 	if (inst->skb)
 		__nfulnl_flush(inst);
-	spin_unlock_bh(&inst->lock);
+	spin_unlock(&inst->lock);
=20
 	/* and finally put the refcount */
 	instance_put(inst);
@@ -624,6 +629,7 @@ nfulnl_log_packet(u_int8_t pf,
 		size +=3D nla_total_size(data_len);
 		break;
=20
+	case NFULNL_COPY_DISABLED:
 	default:
 		goto unlock_and_release;
 	}


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
