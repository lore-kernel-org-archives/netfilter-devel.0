From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH 2.6.20 07/10] nfnetlink_log: fix module reference counting
Date: Mon, 12 Feb 2007 01:39:56 +0100
Message-ID: <20070212003956.GH8262@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org
To: netfilter-devel@lists.netfilter.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964797AbXBLJJh@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Count module references correctly: after instance_destroy() there
might be timer pending and holding a reference for this netlink instanc=
e.

Signed-off-by: Micha=B3 Miros=B3aw <mirq-linux@rere.qmqm.pl>

--- linux-2.6.20/net/netfilter/nfnetlink_log.c.5	2007-02-11 22:24:56.00=
0000000 +0100
+++ linux-2.6.20/net/netfilter/nfnetlink_log.c	2007-02-11 22:31:19.0000=
00000 +0100
@@ -133,6 +133,7 @@ instance_put(struct nfulnl_instance *ins
 	if (inst && atomic_dec_and_test(&inst->use)) {
 		UDEBUG("kfree(inst=3D%p)\n", inst);
 		kfree(inst);
+		module_put(THIS_MODULE);
 	}
 }
=20
@@ -146,9 +147,13 @@ instance_create(u_int16_t group_num, int
 	UDEBUG("entering (group_num=3D%u, pid=3D%d)\n", group_num,
 		pid);
=20
+	if (!try_module_get(THIS_MODULE)) {
+		UDEBUG("aborting, could not reference own module (module unloading?)=
\n");
+		goto out_modunload;
+	}
+
 	write_lock_bh(&instances_lock);=09
 	if (__instance_lookup(group_num)) {
-		inst =3D NULL;
 		UDEBUG("aborting, instance already exists\n");
 		goto out_unlock;
 	}
@@ -176,9 +181,6 @@ instance_create(u_int16_t group_num, int
 	inst->copy_mode 	=3D NFULNL_COPY_PACKET;
 	inst->copy_range 	=3D 0xffff;
=20
-	if (!try_module_get(THIS_MODULE))
-		goto out_free;
-
 	hlist_add_head(&inst->hlist,=20
 		       &instance_table[instance_hashfn(group_num)]);
=20
@@ -189,10 +191,10 @@ instance_create(u_int16_t group_num, int
=20
 	return inst;
=20
-out_free:
-	instance_put(inst);
 out_unlock:
 	write_unlock_bh(&instances_lock);
+	module_put(THIS_MODULE);
+out_modunload:
 	return NULL;
 }
=20
@@ -228,8 +230,6 @@ _instance_destroy2(struct nfulnl_instanc
=20
 	/* and finally put the refcount */
 	instance_put(inst);
-
-	module_put(THIS_MODULE);
 }
=20
 static inline void
