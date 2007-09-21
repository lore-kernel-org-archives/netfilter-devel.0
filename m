From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH 2.6.22.3 4/5] nfnetlink_log: Fix instance_create() failure path
Date: Fri, 21 Sep 2007 18:49:17 +0200
Message-ID: <20070921164917.GD3779@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rere.qmqm.pl ([86.63.132.164]:55234 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759931AbXIUQ4F (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Sep 2007 12:56:05 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

=46ix memory leak on instance_create() while module is being unloaded.

Signed-off-by: Micha=B3 Miros=B3aw <mirq-linux@rere.qmqm.pl>           =
                                                   =20

--- lq3/net/netfilter/nfnetlink_log.c	2007-09-21 18:25:15.000000000 +02=
00
+++ rechot/net/netfilter/nfnetlink_log.c	2007-09-21 18:24:09.000000000 =
+0200
@@ -153,6 +153,11 @@
 	if (!inst)
 		goto out_unlock;
=20
+	if (!try_module_get(THIS_MODULE)) {
+		kfree(inst);
+		goto out_unlock;
+	}
+
 	INIT_HLIST_NODE(&inst->hlist);
 	spin_lock_init(&inst->lock);
 	/* needs to be two, since we _put() after creation */
@@ -169,9 +174,6 @@
 	inst->copy_mode 	=3D NFULNL_COPY_PACKET;
 	inst->copy_range 	=3D 0xffff;
=20
-	if (!try_module_get(THIS_MODULE))
-		goto out_free;
-
 	hlist_add_head(&inst->hlist,
 		       &instance_table[instance_hashfn(group_num)]);
=20
@@ -182,8 +184,6 @@
=20
 	return inst;
=20
-out_free:
-	instance_put(inst);
 out_unlock:
 	write_unlock_bh(&instances_lock);
 	return NULL;
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
