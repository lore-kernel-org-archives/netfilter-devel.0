From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH 2.6.20 08/10] nfnetlink_log: shorten instances_lock holding time
Date: Mon, 12 Feb 2007 01:40:12 +0100
Message-ID: <20070212004012.GI8262@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org
To: netfilter-devel@lists.netfilter.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964798AbXBLJJh@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Shorten instances_lock window at the cost of doing unnecessary work
on the failure case. I don't know if it makes sense actually. ;>

Signed-off-by: Micha=B3 Miros=B3aw <mirq-linux@rere.qmqm.pl>

--- linux-2.6.20/net/netfilter/nfnetlink_log.c.6	2007-02-11 22:31:19.00=
0000000 +0100
+++ linux-2.6.20/net/netfilter/nfnetlink_log.c	2007-02-11 22:41:18.0000=
00000 +0100
@@ -149,18 +149,14 @@ instance_create(u_int16_t group_num, int
=20
 	if (!try_module_get(THIS_MODULE)) {
 		UDEBUG("aborting, could not reference own module (module unloading?)=
\n");
-		goto out_modunload;
-	}
-
-	write_lock_bh(&instances_lock);=09
-	if (__instance_lookup(group_num)) {
-		UDEBUG("aborting, instance already exists\n");
-		goto out_unlock;
+		return NULL;
 	}
=20
 	inst =3D kzalloc(sizeof(*inst), GFP_ATOMIC);
-	if (!inst)
-		goto out_unlock;
+	if (!inst) {
+		module_put(THIS_MODULE);
+		return NULL;
+	}
=20
 	INIT_HLIST_NODE(&inst->hlist);
 	spin_lock_init(&inst->lock);
@@ -181,21 +177,25 @@ instance_create(u_int16_t group_num, int
 	inst->copy_mode 	=3D NFULNL_COPY_PACKET;
 	inst->copy_range 	=3D 0xffff;
=20
-	hlist_add_head(&inst->hlist,=20
+	write_lock_bh(&instances_lock);=09
+
+	if (!__instance_lookup(group_num)) {
+		hlist_add_head(&inst->hlist,=20
 		       &instance_table[instance_hashfn(group_num)]);
=20
-	UDEBUG("newly added node: %p, next=3D%p\n", &inst->hlist,=20
-		inst->hlist.next);
+		UDEBUG("newly added node: %p, next=3D%p\n", &inst->hlist,=20
+			inst->hlist.next);
+	} else {
+		UDEBUG("aborting, instance already exists\n");
+
+		kfree(inst);
+		module_put(THIS_MODULE);
+		inst =3D NULL;
+	}
=20
 	write_unlock_bh(&instances_lock);
=20
 	return inst;
-
-out_unlock:
-	write_unlock_bh(&instances_lock);
-	module_put(THIS_MODULE);
-out_modunload:
-	return NULL;
 }
=20
 static int __nfulnl_send(struct nfulnl_instance *inst);
